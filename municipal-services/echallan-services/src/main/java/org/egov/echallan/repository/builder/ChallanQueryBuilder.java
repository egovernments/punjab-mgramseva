package org.egov.echallan.repository.builder;

import java.util.Arrays;
import java.util.List;

import org.egov.echallan.config.ChallanConfiguration;
import org.egov.echallan.model.SearchCriteria;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ChallanQueryBuilder {

    private ChallanConfiguration config;

    @Autowired
    public ChallanQueryBuilder(ChallanConfiguration config) {
        this.config = config;
    }

    private static final String INNER_JOIN_STRING = " INNER JOIN ";

   /* private static final String QUERY = "SELECT challan.*,chaladdr.*,challan.id as challan_id,challan.tenantid as challan_tenantId,challan.lastModifiedTime as " +
            "challan_lastModifiedTime,challan.createdBy as challan_createdBy,challan.lastModifiedBy as challan_lastModifiedBy,challan.createdTime as " +
            "challan_createdTime,chaladdr.id as chaladdr_id," +
            "challan.accountId as uuid,challan.description as description,challan.typeOfExpense as typeOfExpense, challan.billDate as billDate,  "
            + " challan.billIssuedDate as billIssuedDate, challan.paidDate as paidDate, challan.isBillPaid as isBillPaid , challan.vendor as vendor FROM eg_echallan challan"
            +" LEFT OUTER JOIN "
            +" eg_challan_address chaladdr ON chaladdr.echallanid = challan.id  ";*/
    
	private static final String QUERY = "SELECT count(*) OVER() AS full_count, challan.*,chaladdr.*,challan.id as challan_id,challan.tenantid as challan_tenantId,challan.lastModifiedTime as "
			+ "challan_lastModifiedTime,challan.createdBy as challan_createdBy,challan.lastModifiedBy as challan_lastModifiedBy,challan.createdTime as "
			+ "challan_createdTime,chaladdr.id as chaladdr_id,"
			+ "challan.accountId as uuid,challan.description as description,challan.typeOfExpense as typeOfExpense, challan.billDate as billDate,  "
			+ " challan.billIssuedDate as billIssuedDate, challan.paidDate as paidDate, challan.isBillPaid as isBillPaid , challan.vendor as vendor, vendor.name as vendorName "
			+ " FROM eg_echallan challan" + " LEFT OUTER JOIN "
			+ " eg_challan_address chaladdr ON chaladdr.echallanid = challan.id   INNER JOIN eg_vendor vendor on vendor.id = challan.vendor ";

      private final String paginationWrapper = "{} {orderby} {pagination}";

      public static final String FILESTOREID_UPDATE_SQL = "UPDATE eg_echallan SET filestoreid=? WHERE id=?";
      
      public static final String CANCEL_RECEIPT_UPDATE_SQL = "UPDATE eg_echallan SET applicationStatus='ACTIVE' WHERE challanNo=? and businessService=?";
      
      private static final String TENANTIDS = "SELECT distinct(tenantid) FROM eg_echallan challan";
      
      public static final String ACTIVEEXPENSECOUNTQUERY =  "select count(*) from eg_echallan  where applicationstatus ='ACTIVE' ";
      
      public static final String PENDINGCOLLECTION = "select (sum(demanddtl.taxamount)-sum(demanddtl.collectionamount)) as pendingamount from egbs_demand_v1 demand, egbs_demanddetail_v1 demanddtl where  demand.id= demanddtl.demandid and demand.businessservice='WS' ";

	  public static final String PREVIOUSMONTHEXPENSE = " select sum(billdtl.totalamount) from eg_echallan challan, egbs_billdetail_v1 billdtl, egbs_bill_v1 bill  where challan.challanno= billdtl.consumercode  and billdtl.billid = bill.id and challan.isbillpaid ='true'  ";
	  
	  public static final String PREVIOUSMONTHCOLLECTION = " select count(pd.amountpaid) from egcl_paymentdetail pd, egcl_payment p where p.id= pd.paymentid and businessservice='EXPENSE.ADVANCE'  ";

	  public static final String PREVIOUSDAYCASHCOLLECTION = " select sum(totalamountpaid) as total, mobilenumber from egcl_payment where paymentmode='CASH' ";

	  public static final String PREVIOUSMONTHNEWEXPENSE = "  select sum(demanddtl.taxamount) from eg_echallan challan, egbs_billdetail_v1 billdtl,egbs_demanddetail_v1 demanddtl  where challan.challanno= billdtl.consumercode   and billdtl.demandid= billdtl.demandid";
	  
	  public static final String CUMULATIVEPENDINGEXPENSE = " select sum(demanddtl.taxamount-demanddtl.collectionamount) from eg_echallan challan, egbs_billdetail_v1 billdtl,egbs_demanddetail_v1 demanddtl  where challan.challanno= billdtl.consumercode  and billdtl.demandid= billdtl.demandid ";

	  public static final String NEWDEMAND ="select sum(dmdl.taxamount) FROM egbs_demand_v1 dmd INNER JOIN egbs_demanddetail_v1 dmdl ON dmd.id=dmdl.demandid AND dmd.tenantid=dmdl.tenantid WHERE dmd.businessservice='WS' ";
	  
	  public static final String ACTUALCOLLECTION =" select sum(py.totalAmountPaid) FROM egcl_payment py INNER JOIN egcl_paymentdetail pyd ON pyd.paymentid = py.id where pyd.businessservice='WS' ";




    public String getChallanSearchQuery(SearchCriteria criteria, List<Object> preparedStmtList) {

        StringBuilder builder = new StringBuilder(QUERY);

        addBusinessServiceClause(criteria,preparedStmtList,builder);


        if(criteria.getAccountId()!=null){
            addClauseIfRequired(preparedStmtList,builder);
            builder.append(" challan.accountid = ? ");
            preparedStmtList.add(criteria.getAccountId());

            List<String> ownerIds = criteria.getUserIds();
            if(!CollectionUtils.isEmpty(ownerIds)) {
                builder.append(" OR (challan.accountid IN (").append(createQuery(ownerIds)).append(")");
                addToPreparedStatement(preparedStmtList,ownerIds);
                addBusinessServiceClause(criteria,preparedStmtList,builder);
            }
        }
        else {

            if (criteria.getTenantId() != null) {
                addClauseIfRequired(preparedStmtList, builder);
                builder.append(" challan.tenantid=? ");
                preparedStmtList.add(criteria.getTenantId());
            }
            List<String> ids = criteria.getIds();
            if (!CollectionUtils.isEmpty(ids)) {
                addClauseIfRequired(preparedStmtList, builder);
                builder.append(" challan.id IN (").append(createQuery(ids)).append(")");
                addToPreparedStatement(preparedStmtList, ids);
            }

            List<String> ownerIds = criteria.getUserIds();
            if (!CollectionUtils.isEmpty(ownerIds)) {
                addClauseIfRequired(preparedStmtList, builder);
                builder.append(" challan.accountid IN (").append(createQuery(ownerIds)).append(")");
                addToPreparedStatement(preparedStmtList, ownerIds);
                //addClauseIfRequired(preparedStmtList, builder);
            }

            if (criteria.getChallanNo() != null) {
                addClauseIfRequired(preparedStmtList, builder);
                builder.append("  challan.challanno like ?");
                preparedStmtList.add('%' + criteria.getChallanNo() + '%');
            }
            if (criteria.getStatus() != null) {
                addClauseIfRequired(preparedStmtList, builder);
                builder.append("  challan.applicationstatus = ? ");
                preparedStmtList.add(criteria.getStatus());
            }
            
            if(criteria.getExpenseType() != null){
            	addClauseIfRequired(preparedStmtList, builder);
            	builder.append( " challan.typeOfExpense = ? ");
            	preparedStmtList.add(criteria.getExpenseType());
            }
            
            if(criteria.getVendorName() != null)
            {
            	addClauseIfRequired(preparedStmtList, builder);
				builder.append(" vendor.name like ?");
				preparedStmtList.add('%' + criteria.getVendorName() + '%');
            }
            
            if (criteria.getFromDate() != null) {
    			addClauseIfRequired(preparedStmtList, builder);
    			builder.append("  challan.createdTime >= ? ");
    			preparedStmtList.add(criteria.getFromDate());
    		}
    		if (criteria.getToDate() != null) {
    			addClauseIfRequired(preparedStmtList, builder);
    			builder.append("  challan.createdTime <= ? ");
    			preparedStmtList.add(criteria.getToDate());
    		}
    		if (criteria.getIsBillPaid() != null) {
    			addClauseIfRequired(preparedStmtList, builder);
    			builder.append("  challan.isBillPaid = ? ");
    			preparedStmtList.add(criteria.getIsBillPaid());
    		}


        }

        return addPaginationWrapper(builder.toString(),preparedStmtList,criteria);
    }


    private void addBusinessServiceClause(SearchCriteria criteria,List<Object> preparedStmtList,StringBuilder builder){
    	if(criteria.getBusinessService()!=null) {
    	List<String> businessServices = Arrays.asList(criteria.getBusinessService().split(","));
            addClauseIfRequired(preparedStmtList, builder);
            builder.append(" challan.businessservice IN (").append(createQuery(businessServices)).append(")");
            addToPreparedStatement(preparedStmtList, businessServices);
    }
    }

    private String createQuery(List<String> ids) {
        StringBuilder builder = new StringBuilder();
        int length = ids.size();
        for( int i = 0; i< length; i++){
            builder.append(" ?");
            if(i != length -1) builder.append(",");
        }
        return builder.toString();
    }

    private void addToPreparedStatement(List<Object> preparedStmtList,List<String> ids)
    {
        ids.forEach(id ->{ preparedStmtList.add(id);});
    }


    private String addPaginationWrapper(String query,List<Object> preparedStmtList,
                                      SearchCriteria criteria){
       String string = addOrderByClause(criteria);

        int limit = config.getDefaultLimit();
        int offset = config.getDefaultOffset();
        String finalQuery = paginationWrapper.replace("{}",query);

		finalQuery = finalQuery.replace("{orderby}", string);

        if(criteria.getLimit()!=null && criteria.getLimit()<=config.getMaxSearchLimit())
            limit = criteria.getLimit();

        if(criteria.getLimit()!=null && criteria.getLimit()>config.getMaxSearchLimit())
            limit = config.getMaxSearchLimit();

        if(criteria.getOffset()!=null)
            offset = criteria.getOffset();
        
        finalQuery = finalQuery.replace("{pagination}", " offset ?  limit ?  ");
	    preparedStmtList.add(offset);
        preparedStmtList.add(limit+offset);

       return finalQuery;
    }


    private static void addClauseIfRequired(List<Object> values, StringBuilder queryString) {
        if (values.isEmpty())
            queryString.append(" WHERE ");
        else {
            queryString.append(" AND");
        }
    }

	public String getDistinctTenantIds() {
		return TENANTIDS;
	}

	/**
	 * 
	 * @param builder
	 * @param criteria
	 */
	private String addOrderByClause(SearchCriteria criteria) {

        StringBuilder builder = new StringBuilder();
        
		if (StringUtils.isEmpty(criteria.getSortBy()))
			builder.append(" ORDER BY challan_lastModifiedTime ");

		else if (criteria.getSortBy() == SearchCriteria.SortBy.billDate)
			builder.append(" ORDER BY billDate ");

		else if (criteria.getSortBy() == SearchCriteria.SortBy.typeOfExpense)
			builder.append(" ORDER BY typeOfExpense ");

		else if (criteria.getSortBy() == SearchCriteria.SortBy.paidDate)
			builder.append(" ORDER BY paidDate ");
		
		else if (criteria.getSortBy() == SearchCriteria.SortBy.challanno)
			builder.append(" ORDER BY challanno ");

//		else if (criteria.getSortBy() == SearchCriteria.SortBy.totalAmount)
//			builder.append(" ORDER BY challan.totalAmount ");

		if (criteria.getSortOrder() == SearchCriteria.SortOrder.ASC)
			builder.append(" ASC ");
		else
			builder.append(" DESC ");

		return builder.toString();
	}

}
