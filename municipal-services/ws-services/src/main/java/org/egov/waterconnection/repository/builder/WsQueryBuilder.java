package org.egov.waterconnection.repository.builder;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.egov.common.contract.request.RequestInfo;
import org.egov.waterconnection.config.WSConfiguration;
import org.egov.waterconnection.service.UserService;
import org.egov.waterconnection.util.WaterServicesUtil;
import org.egov.waterconnection.web.models.FeedbackSearchCriteria;
import org.egov.waterconnection.web.models.Property;
import org.egov.waterconnection.web.models.SearchCriteria;
import org.egov.waterconnection.web.models.users.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import static org.egov.waterconnection.constants.WCConstants.SEARCH_TYPE_CONNECTION;

@Component
public class WsQueryBuilder {

	@Autowired
	private WaterServicesUtil waterServicesUtil;

	@Autowired
	private WSConfiguration config;
	
	@Autowired
	private UserService userService;

	private static final String INNER_JOIN_STRING = "INNER JOIN";
    private static final String LEFT_OUTER_JOIN_STRING = " LEFT OUTER JOIN ";
//	private static final String Offset_Limit_String = "OFFSET ? LIMIT ?";
    
//    private static String holderSelectValues = "{HOLDERSELECTVALUES}";
   
    
	private static final String WATER_SEARCH_QUERY = "SELECT count(*) OVER() AS full_count, conn.*, wc.*, document.*, plumber.*, wc.connectionCategory, wc.connectionType, wc.waterSource,"
			+ " wc.meterId, wc.meterInstallationDate, wc.pipeSize, wc.noOfTaps, wc.proposedPipeSize, wc.proposedTaps, wc.connection_id as connection_Id, wc.connectionExecutionDate, wc.initialmeterreading, wc.appCreatedDate,"
			+ " wc.detailsprovidedby, wc.estimationfileStoreId , wc.sanctionfileStoreId , wc.estimationLetterDate,"
			+ " conn.id as conn_id, conn.tenantid, conn.applicationNo, conn.applicationStatus, conn.status, conn.connectionNo, conn.oldConnectionNo, conn.property_id, conn.roadcuttingarea,"
			+ " conn.action, conn.adhocpenalty, conn.adhocrebate, conn.adhocpenaltyreason, conn.applicationType, conn.dateEffectiveFrom,"
			+ " conn.adhocpenaltycomment, conn.adhocrebatereason, conn.adhocrebatecomment, conn.createdBy as ws_createdBy, conn.lastModifiedBy as ws_lastModifiedBy,"
			+ " conn.createdTime as ws_createdTime, conn.lastModifiedTime as ws_lastModifiedTime,conn.additionaldetails, "
			+ " conn.locality, conn.isoldapplication, conn.roadtype, document.id as doc_Id, document.documenttype, document.filestoreid, document.active as doc_active, plumber.id as plumber_id,"
			+ " plumber.name as plumber_name, plumber.licenseno, roadcuttingInfo.id as roadcutting_id, roadcuttingInfo.roadtype as roadcutting_roadtype, roadcuttingInfo.roadcuttingarea as roadcutting_roadcuttingarea, roadcuttingInfo.roadcuttingarea as roadcutting_roadcuttingarea,"
			+ " roadcuttingInfo.active as roadcutting_active, plumber.mobilenumber as plumber_mobileNumber, plumber.gender as plumber_gender, plumber.fatherorhusbandname, plumber.correspondenceaddress,"
			+ " plumber.relationship, " + "{holderSelectValues}"
			+ " FROM eg_ws_connection conn "
			+  INNER_JOIN_STRING 
			+" eg_ws_service wc ON wc.connection_id = conn.id"
			+  LEFT_OUTER_JOIN_STRING
			+ "eg_ws_applicationdocument document ON document.wsid = conn.id" 
			+  LEFT_OUTER_JOIN_STRING
			+ "eg_ws_plumberinfo plumber ON plumber.wsid = conn.id"
		    +  LEFT_OUTER_JOIN_STRING
		    + "eg_ws_connectionholder connectionholder ON connectionholder.connectionid = conn.id"
			+  LEFT_OUTER_JOIN_STRING
			+ "eg_ws_roadcuttinginfo roadcuttingInfo ON roadcuttingInfo.wsid = conn.id" ;

	private static final String PAGINATION_WRAPPER = "{} {orderby} {pagination}";
	
	private static final String ORDER_BY_CLAUSE= " ORDER BY wc.appCreatedDate DESC";
	
	public static final String GET_BILLING_CYCLE = "select fromperiod,toperiod from egcl_billdetial where billid=(select billid from egcl_paymentdetail where paymentid=?)";

	public static final String FEEDBACK_BASE_QUERY = "select id,tenantid,connectionno,paymentid, billingcycle,additionaldetails,createdtime,lastmodifiedtime,createdby,lastmodifiedby from eg_ws_feedback where tenantid=?";
	
	public static final String TotalCollectionAmount = " select sum(payd.amountpaid)  from egcl_paymentdetail payd join egcl_bill payspay ON ( payd.billid = payspay.id) where payd.businessservice='WS' ";

	public static final String CollectionAmountList = " select sum(payd.amountpaid) from egcl_paymentdetail payd join egcl_bill payspay ON ( payd.billid = payspay.id) where payd.businessservice='WS' ";

	
	
	/**
	 * 
	 * @param criteria
	 *            The WaterCriteria
	 * @param preparedStatement
	 *            The Array Of Object
	 * @param requestInfo
	 *            The Request Info
	 * @return query as a string
	 */
	public String getSearchQueryString(SearchCriteria criteria, List<Object> preparedStatement,
			RequestInfo requestInfo) {
		if (criteria.isEmpty())
				return null;
		StringBuilder query = new StringBuilder(WATER_SEARCH_QUERY);
		
		boolean propertyIdsPresent = false;

		Set<String> propertyIds = new HashSet<>();
		String propertyIdQuery = " (conn.property_id in (";

		if (!StringUtils.isEmpty(criteria.getMobileNumber()) || !StringUtils.isEmpty(criteria.getPropertyId()) || !StringUtils.isEmpty(criteria.getName())) {
			List<Property> propertyList = waterServicesUtil.propertySearchOnCriteria(criteria, requestInfo);
			propertyList.forEach(property -> propertyIds.add(property.getPropertyId()));
			criteria.setPropertyIds(propertyIds);
			if (!propertyIds.isEmpty()) {
				addClauseIfRequired(preparedStatement, query);
				query.append(propertyIdQuery).append(createQuery(propertyIds)).append(" )");
				addToPreparedStatement(preparedStatement, propertyIds);
				propertyIdsPresent = true;
			}
		}
		
		Set<String> uuids = null;
		if(!StringUtils.isEmpty(criteria.getMobileNumber()) || !StringUtils.isEmpty(criteria.getName())) {
			uuids = userService.getUUIDForUsers(criteria.getMobileNumber(), criteria.getName(), criteria.getTenantId(), requestInfo);
			boolean userIdsPresent = false;
			criteria.setUserIds(uuids);
			if (!CollectionUtils.isEmpty(uuids)) {
				addORClauseIfRequired(preparedStatement, query);
				if(!propertyIdsPresent)
					query.append("(");
				query.append(" connectionholder.userid in (").append(createQuery(uuids)).append(" ))");
				addToPreparedStatement(preparedStatement, uuids);
				userIdsPresent = true;
			}
			if(propertyIdsPresent && !userIdsPresent){
				query.append(")");
			}
		}

		/*
		 * to return empty result for mobilenumber empty result
		 */
		if (!StringUtils.isEmpty(criteria.getMobileNumber()) 
				&& CollectionUtils.isEmpty(criteria.getPropertyIds()) && CollectionUtils.isEmpty(criteria.getUserIds())
				&& StringUtils.isEmpty(criteria.getApplicationNumber()) && StringUtils.isEmpty(criteria.getPropertyId())
				&& StringUtils.isEmpty(criteria.getConnectionNumber()) && CollectionUtils.isEmpty(criteria.getIds())) {
			return null;
		}

		if (!StringUtils.isEmpty(criteria.getTenantId())) {
			addClauseIfRequired(preparedStatement, query);
			if(criteria.getTenantId().equalsIgnoreCase(config.getStateLevelTenantId())){
				query.append(" conn.tenantid LIKE ? ");
				preparedStatement.add(criteria.getTenantId() + '%');
			}
			else{
				query.append(" conn.tenantid = ? ");
				preparedStatement.add(criteria.getTenantId());
			}
		}
		if (!StringUtils.isEmpty(criteria.getPropertyId()) && StringUtils.isEmpty(criteria.getMobileNumber())) {
			if(propertyIdsPresent)
				query.append(")");
			else{
				addClauseIfRequired(preparedStatement, query);
				query.append(" conn.property_id = ? ");
				preparedStatement.add(criteria.getPropertyId());
			}
		}
		if (!CollectionUtils.isEmpty(criteria.getIds())) {
			addClauseIfRequired(preparedStatement, query);
			query.append(" conn.id in (").append(createQuery(criteria.getIds())).append(" )");
			addToPreparedStatement(preparedStatement, criteria.getIds());
		}
		if (!StringUtils.isEmpty(criteria.getOldConnectionNumber())) {
			addClauseIfRequired(preparedStatement, query);
			query.append(" conn.oldconnectionno = ? ");
			preparedStatement.add(criteria.getOldConnectionNumber());
		}

		if (criteria.getFreeSearch()) {
			if (!StringUtils.isEmpty(criteria.getConnectionNumber())) {
				if (!criteria.getUserIds().isEmpty()) {
					query.append(" OR conn.connectionno like ? ");
				} else {
					query.append(" AND conn.connectionno like ? ");
				}
				preparedStatement.add('%' + criteria.getConnectionNumber() + '%');
			}
		} else {
			if (!StringUtils.isEmpty(criteria.getConnectionNumber())) {
				addClauseIfRequired(preparedStatement, query);
				query.append(" conn.connectionno like ? ");
				preparedStatement.add('%' + criteria.getConnectionNumber() + '%');
			}
		}
	
		if (!StringUtils.isEmpty(criteria.getStatus())) {
			addClauseIfRequired(preparedStatement, query);
			query.append(" conn.status = ? ");
			preparedStatement.add(criteria.getStatus());
		}
		if (!StringUtils.isEmpty(criteria.getApplicationNumber())) {
			addClauseIfRequired(preparedStatement, query);
			query.append(" conn.applicationno = ? ");
			preparedStatement.add(criteria.getApplicationNumber());
		}
		if (!StringUtils.isEmpty(criteria.getApplicationStatus())) {
			addClauseIfRequired(preparedStatement, query);
			query.append(" conn.applicationStatus = ? ");
			preparedStatement.add(criteria.getApplicationStatus());
		}
		if (criteria.getFromDate() != null) {
			addClauseIfRequired(preparedStatement, query);
			query.append("  conn.createdTime >= ? ");
			preparedStatement.add(criteria.getFromDate());
		}
		if (criteria.getToDate() != null) {
			addClauseIfRequired(preparedStatement, query);
			query.append("  conn.createdTime <= ? ");
			preparedStatement.add(criteria.getToDate());
		}
		if(!StringUtils.isEmpty(criteria.getApplicationType())) {
			addClauseIfRequired(preparedStatement, query);
			query.append(" conn.applicationType = ? ");
			preparedStatement.add(criteria.getApplicationType());
		}
		if(!StringUtils.isEmpty(criteria.getPropertyType())) {
			addClauseIfRequired(preparedStatement, query);
			query.append(" conn.additionaldetails.propertyType = ? ");
			preparedStatement.add(criteria.getPropertyType());
		}
		if(!StringUtils.isEmpty(criteria.getSearchType())
				&& criteria.getSearchType().equalsIgnoreCase(SEARCH_TYPE_CONNECTION)){
			addClauseIfRequired(preparedStatement, query);
			query.append(" conn.isoldapplication = ? ");
			preparedStatement.add(Boolean.FALSE);
		}
		if (!StringUtils.isEmpty(criteria.getLocality())) {
			addClauseIfRequired(preparedStatement, query);
			query.append(" conn.locality = ? ");
			preparedStatement.add(criteria.getLocality());
		}
//		query.append(ORDER_BY_CLAUSE);
		return addPaginationWrapper(query.toString(), preparedStatement, criteria);
	}
	
	private void addClauseIfRequired(List<Object> values, StringBuilder queryString) {
		if (values.isEmpty())
			queryString.append(" WHERE ");
		else {
			queryString.append(" AND");
		}
	}

	private String createQuery(Set<String> ids) {
		StringBuilder builder = new StringBuilder();
		int length = ids.size();
		for (int i = 0; i < length; i++) {
			builder.append(" ?");
			if (i != length - 1)
				builder.append(",");
		}
		return builder.toString();
	}

	private void addToPreparedStatement(List<Object> preparedStatement, Set<String> ids) {
		preparedStatement.addAll(ids);
	}


	/**
	 * 
	 * @param query
	 *            Query String
	 * @param preparedStmtList
	 *            Array of object for preparedStatement list
	 * @param criteria SearchCriteria
	 * @return It's returns query
	 */
	private String addPaginationWrapper(String query, List<Object> preparedStmtList, SearchCriteria criteria) {
		String string = addOrderByClause(criteria);
		Integer limit = config.getDefaultLimit();
		Integer offset = config.getDefaultOffset();
		 String finalQuery = PAGINATION_WRAPPER.replace("{}",query);
		finalQuery = finalQuery.replace("{orderby}", string);
		if (criteria.getSortBy() != SearchCriteria.SortBy.collectionAmount && !criteria.getIscollectionAmount()) {
			finalQuery = finalQuery.replace("{holderSelectValues}", "null as collectionamount, connectionholder.tenantid as holdertenantid, connectionholder.connectionid as holderapplicationId, userid, connectionholder.status as holderstatus, isprimaryholder, connectionholdertype, holdershippercentage, connectionholder.relationship as holderrelationship, connectionholder.createdby as holdercreatedby, connectionholder.createdtime as holdercreatedtime, connectionholder.lastmodifiedby as holderlastmodifiedby, connectionholder.lastmodifiedtime as holderlastmodifiedtime");
		}else {
			finalQuery = finalQuery.replace("{holderSelectValues}", "(select nullif(sum(payd.amountpaid),0) from egcl_paymentdetail payd join egcl_bill payspay on (payd.billid = payspay.id) where payd.businessservice = 'WS' and payspay.consumercode = conn.connectionno group by payspay.consumercode) as collectionamount, connectionholder.tenantid as holdertenantid, connectionholder.connectionid as holderapplicationId, userid, connectionholder.status as holderstatus, isprimaryholder, connectionholdertype, holdershippercentage, connectionholder.relationship as holderrelationship, connectionholder.createdby as holdercreatedby, connectionholder.createdtime as holdercreatedtime, connectionholder.lastmodifiedby as holderlastmodifiedby, connectionholder.lastmodifiedtime as holderlastmodifiedtime");
		}
		if (criteria.getLimit() == null && criteria.getOffset() == null)
			limit = config.getMaxLimit();

		if (criteria.getLimit() != null && criteria.getLimit() <= config.getDefaultLimit())
			limit = criteria.getLimit();

		if (criteria.getLimit() != null && criteria.getLimit() > config.getDefaultOffset())
			limit = config.getDefaultLimit();

		if (criteria.getOffset() != null)
			offset = criteria.getOffset();

		finalQuery = finalQuery.replace("{pagination}", " offset ?  limit ?  ");
		preparedStmtList.add(offset);
		preparedStmtList.add(limit + offset);
		System.out.println("FINAL QUERY TO CHECK ::: " + finalQuery);
		return finalQuery;
	}
	
	private String addOrderByClause(SearchCriteria criteria) {
		StringBuilder builder = new StringBuilder();
        
		if (StringUtils.isEmpty(criteria.getSortBy()))
			builder.append(" ORDER BY wc.appCreatedDate ");

		else if (criteria.getSortBy() == SearchCriteria.SortBy.connectionNumber)
			builder.append(" ORDER BY connectionno ");

		else if (criteria.getSortBy() == SearchCriteria.SortBy.name)
			builder.append(" ORDER BY name ");

		else if (criteria.getSortBy() == SearchCriteria.SortBy.collectionAmount)
			builder.append(" ORDER BY collectionamount ");
		

		if (criteria.getSortOrder() == SearchCriteria.SortOrder.ASC)
			builder.append(" ASC ");
		else
			builder.append(" DESC ");

		if (criteria.getSortBy() == SearchCriteria.SortBy.collectionAmount)
			builder.append(" NULLS LAST ");
		
		return builder.toString();
	}

	private void addORClauseIfRequired(List<Object> values, StringBuilder queryString){
		if (values.isEmpty())
			queryString.append(" WHERE ");
		else {
			queryString.append(" OR");
		}
	}
	
	public String getFeedback(FeedbackSearchCriteria feedBackSearchCriteira,List<Object> preparedStatementValues) {

		StringBuilder query = new StringBuilder(FEEDBACK_BASE_QUERY);
		preparedStatementValues.add(feedBackSearchCriteira.getTenantId());

		if (feedBackSearchCriteira.getId() != null) {
			addClauseIfRequired(preparedStatementValues, query);
			query.append(" id = ? ");
			preparedStatementValues.add(feedBackSearchCriteira.getId());
		}

		if (feedBackSearchCriteira.getBillingCycle() != null) {

			addClauseIfRequired(preparedStatementValues, query);
			query.append(" billingcycle = ? ");
			preparedStatementValues.add(feedBackSearchCriteira.getBillingCycle());
		}

		if (feedBackSearchCriteira.getPaymentId() != null) {

			addClauseIfRequired(preparedStatementValues, query);
			query.append(" paymentid = ? ");
			preparedStatementValues.add(feedBackSearchCriteira.getPaymentId());
		}
		
		if (feedBackSearchCriteira.getConnectionNo() != null) {

			addClauseIfRequired(preparedStatementValues, query);
			query.append(" connectionno = ? ");
			preparedStatementValues.add(feedBackSearchCriteira.getConnectionNo());
		}
		
		if(feedBackSearchCriteira.getOffset()!=null) {
			
			query.append(" offset ? ");
			preparedStatementValues.add(feedBackSearchCriteira.getOffset());
			
		}
		
		
		if(feedBackSearchCriteira.getLimit()!=null) {
			
			query.append(" limit ? ");
			
			preparedStatementValues.add(feedBackSearchCriteira.getLimit());
			
		}

		return query.toString();

	}
}