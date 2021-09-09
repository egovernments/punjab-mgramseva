package org.egov.echallan.repository;

import lombok.extern.slf4j.Slf4j;

import java.io.ObjectInputStream.GetField;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.egov.common.contract.request.RequestInfo;
import org.egov.echallan.config.ChallanConfiguration;
import org.egov.echallan.model.Challan;
import org.egov.echallan.model.ChallanRequest;
import org.egov.echallan.model.ChallanResponse;
import org.egov.echallan.model.SearchCriteria;
import org.egov.echallan.producer.Producer;
import org.egov.echallan.repository.builder.ChallanQueryBuilder;
import org.egov.echallan.repository.rowmapper.ChallanRowMapper;
import org.egov.echallan.service.ChallanService;
import org.egov.echallan.web.models.collection.Bill;
import org.egov.echallan.web.models.collection.PaymentDetail;
import org.egov.echallan.web.models.collection.PaymentRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.stereotype.Repository;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

import static org.egov.echallan.util.ChallanConstants.*;
import static org.egov.echallan.repository.builder.ChallanQueryBuilder.*;


@Slf4j
@Repository
public class ChallanRepository {

    private Producer producer;
    
    private ChallanConfiguration config;

    private JdbcTemplate jdbcTemplate;

    private ChallanQueryBuilder queryBuilder;

    private ChallanRowMapper rowMapper;
    
    private RestTemplate restTemplate;

    @Value("${egov.filestore.host}")
    private String fileStoreHost;

    @Value("${egov.filestore.setinactivepath}")
	private String fileStoreInactivePath;

    @Autowired
	private ObjectMapper mapper; 
    @Autowired
    public ChallanRepository(Producer producer, ChallanConfiguration config,ChallanQueryBuilder queryBuilder,
    		JdbcTemplate jdbcTemplate,ChallanRowMapper rowMapper,RestTemplate restTemplate) {
        this.producer = producer;
        this.config = config;
        this.jdbcTemplate = jdbcTemplate;
        this.queryBuilder = queryBuilder ; 
        this.rowMapper = rowMapper;
        this.restTemplate = restTemplate;
    }


    /**
     * Pushes the request on save topic
     *
     * @param ChallanRequest The challan create request
     */
    public void save(ChallanRequest challanRequest) {
    	
        producer.push(config.getSaveChallanTopic(), challanRequest);
    }
    
    /**
     * Pushes the request on update topic
     *
     * @param ChallanRequest The challan create request
     */
    public void update(ChallanRequest challanRequest) {
    	
    	log.info("CHALLAN ISBILLPAID:"+challanRequest.getChallan().getIsBillPaid()  +" | PAID DATE: "+challanRequest.getChallan().getPaidDate());
        producer.push(config.getUpdateChallanTopic(), challanRequest);
    }
    
    
    public List<Challan> getChallans(SearchCriteria criteria, Map<String, String> finalData) {
        List<Object> preparedStmtList = new ArrayList<>();
        String query = queryBuilder.getChallanSearchQuery(criteria, preparedStmtList);
        List<Challan> challans =  jdbcTemplate.query(query, preparedStmtList.toArray(), rowMapper); 
        
		if (criteria.getIsBillCount()) {
			List<Object> preparedStmnt = new ArrayList<>();
			StringBuilder paidQuery = new StringBuilder(queryBuilder.bill_count);
			paidQuery = queryBuilder.applyFilters(paidQuery, preparedStmnt, criteria);
			paidQuery.append(" AND isbillpaid=true ");
			List<Map<String, Object>> paidCountdata = jdbcTemplate.queryForList(paidQuery.toString(),
					preparedStmnt.toArray());
			List<Object> prpstmnt = new ArrayList<>();
			StringBuilder notPaidQuery = new StringBuilder(queryBuilder.bill_count);
			notPaidQuery = queryBuilder.applyFilters(notPaidQuery, prpstmnt, criteria);
			notPaidQuery.append(" AND isbillpaid=false ");
			
			List<Map<String, Object>> notPaidCountdata = jdbcTemplate.queryForList(notPaidQuery.toString(),
					preparedStmnt.toArray());
		
			finalData.put("paidcount", paidCountdata.get(0).get("count").toString());
			finalData.put("notPaidcount", notPaidCountdata.get(0).get("count").toString());
			System.out.println("Map Data Insertion :: " + finalData);
		}
		
        return challans;
    }



	public void updateFileStoreId(List<Challan> challans) {
		List<Object[]> rows = new ArrayList<>();

        challans.forEach(challan -> {
        	rows.add(new Object[] {challan.getFilestoreid(),
        			challan.getId()}
        	        );
        });

        jdbcTemplate.batchUpdate(FILESTOREID_UPDATE_SQL,rows);
		
	}
	
	 public void setInactiveFileStoreId(String tenantId, List<String> fileStoreIds)  {
			String idLIst = fileStoreIds.toString().substring(1, fileStoreIds.toString().length() - 1).replace(", ", ",");
			String Url = fileStoreHost + fileStoreInactivePath + "?tenantId=" + tenantId + "&fileStoreIds=" + idLIst;
			try {
				  restTemplate.postForObject(Url, null, String.class) ;
			} catch (Exception e) {
				log.error("Error in calling fileStore "+e.getMessage());
			}
			 
		}



	public void updateChallanOnCancelReceipt(HashMap<String, Object> record) {
		// TODO Auto-generated method stub

		PaymentRequest paymentRequest = mapper.convertValue(record, PaymentRequest.class);
		RequestInfo requestInfo = paymentRequest.getRequestInfo();

		List<PaymentDetail> paymentDetails = paymentRequest.getPayment().getPaymentDetails();
		String tenantId = paymentRequest.getPayment().getTenantId();
		List<Object[]> rows = new ArrayList<>();
		for (PaymentDetail paymentDetail : paymentDetails) {
			Bill bill = paymentDetail.getBill();
			rows.add(new Object[] {bill.getConsumerCode(),
        			bill.getBusinessService()}
        	        );
		}
		jdbcTemplate.batchUpdate(CANCEL_RECEIPT_UPDATE_SQL,rows);
		
	}
	
	public List<String> getTenantId() {
		String query = queryBuilder.getDistinctTenantIds();
		log.info("Tenants List Query : " + query);
		return jdbcTemplate.queryForList(query, String.class);
	}
	
	public List<String> getActiveExpenses(String tenantId) {
		StringBuilder query = new StringBuilder(queryBuilder.ACTIVEEXPENSECOUNTQUERY);
		query.append(" and tenantid = '").append(tenantId).append("'");
		log.info("Active expense query : " + query);
		return jdbcTemplate.queryForList(query.toString(), String.class);
	}



	public Integer getPreviousMonthExpensePayments(String tenantId, Long startDate, Long endDate) {
		StringBuilder query = new StringBuilder(queryBuilder.PREVIOUSMONTHEXPPAYMENT);
		
		//previous month start date startDate
		// previous month end date endDate
		
		query.append( " and PAYMTDTL.receiptdate  >= ").append( startDate)  
		.append(" and  PAYMTDTL.receiptdate <= " ).append(endDate); 
		log.info("Previous month expense paid query : " + query);
		return jdbcTemplate.queryForObject(query.toString(), Integer.class);
	}


	public List<String> getPreviousMonthExpenseExpenses(String tenantId, String startDate, String endDate) {
		StringBuilder query = new StringBuilder(queryBuilder.PREVIOUSMONTHEXPENSE);

		query.append(" and challan.paiddate  >= ").append(startDate).append(" and  challan.paiddate <= ")
				.append(endDate);
		log.info("Previous month expense query : " + query);
		return jdbcTemplate.queryForList(query.toString(), String.class);
	}



	public List<String> getPendingCollection(String tenantId, String startDate, String endDate) {
		StringBuilder query = new StringBuilder(queryBuilder.PENDINGCOLLECTION);
		query.append(" and demand.tenantid = '").append(tenantId).append("'")
		.append( " and taxperiodfrom  >= ").append( startDate)  
		.append(" and  taxperiodto <= " ).append(endDate);
		log.info("Active pending collection query : " + query);
		return jdbcTemplate.queryForList(query.toString(), String.class);
		
	}



	public List<Map<String, Object>> getTodayCollection(String tenantId, String startDate, String endDate, String mode) {
		StringBuilder query = new StringBuilder();
		if(mode.equalsIgnoreCase("CASH")) {
		 query = new StringBuilder(queryBuilder.PREVIOUSDAYCASHCOLLECTION);
		}else {
			query = new StringBuilder(queryBuilder.PREVIOUSDAYONLINECOLLECTION);
		}
		query.append( " and transactiondate  >= ").append( startDate)  
		.append(" and  transactiondate <= " ).append(endDate); 
		log.info("Previous Day collection query : " + query);
		List<Map<String, Object>> list =  jdbcTemplate.queryForList(query.toString());
		return list;
	}
	
	public Integer getPreviousMonthNewExpense(String tenantId, Long startDate, Long endDate) {
		StringBuilder query = new StringBuilder(queryBuilder.PREVIOUSMONTHNEWEXPENSE);
		query.append("  WHERE  CHALLAN.BILLISSUEDDATE BETWEEN ").append(startDate).append(" and  ")
				.append(endDate).append(" and CHALLAN.TENANTID = '").append(tenantId).append("'");
		return jdbcTemplate.queryForObject(query.toString(), Integer.class);
	}

	public Integer getCumulativePendingExpense(String tenantId) {
		StringBuilder query = new StringBuilder(queryBuilder.CUMULATIVEPENDINGEXPENSE);
		query.append(" and challan.tenantId = '").append(tenantId).append("'");
		return jdbcTemplate.queryForObject(query.toString(), Integer.class);
	}

	public Integer getTotalPendingCollection(String tenantId) {
		StringBuilder query = new StringBuilder(queryBuilder.PENDINGCOLLECTION);
		query.append(" and CONN.tenantid = '").append(tenantId).append("'");
		return jdbcTemplate.queryForObject(query.toString(), Integer.class);

	}

	public Integer getNewDemand(String tenantId, Long startDate, Long endDate) {
		StringBuilder query = new StringBuilder(queryBuilder.NEWDEMAND);
		query.append(" and dmd.taxPeriodFrom  >= ").append(startDate).append(" and dmd.taxPeriodTo <= ").append(endDate)
				.append(" and dmd.tenantId = '").append(tenantId).append("'");
		return jdbcTemplate.queryForObject(query.toString(), Integer.class);

	}

	public Integer getActualCollection(String tenantId, Long startDate, Long endDate) {
		StringBuilder query = new StringBuilder(queryBuilder.ACTUALCOLLECTION);
		query.append(" and py.transactionDate  >= ").append(startDate).append(" and py.transactionDate <= ")
				.append(endDate).append(" and py.tenantId = '").append(tenantId).append("'");
		return jdbcTemplate.queryForObject(query.toString(), Integer.class);

	}
	
    
}
