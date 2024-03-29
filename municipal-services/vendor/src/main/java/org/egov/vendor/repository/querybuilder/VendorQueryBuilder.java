package org.egov.vendor.repository.querybuilder;

import java.util.List;

import org.egov.vendor.config.VendorConfiguration;
import org.egov.vendor.web.model.VendorSearchCriteria;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

@Component
public class VendorQueryBuilder {

	public static final String VENDOR_REPORT_QUERY = "select echallan.challanno,echallan.typeofexpense as type_of_expense,"
			+ " vendor.name,eg_user.uuid as owner_uuid from eg_echallan echallan INNER JOIN eg_vendor vendor on " +
			" echallan.vendor=vendor.id INNER JOIN eg_user on eg_user.uuid=vendor.owner_id where " +
			" echallan.applicationstatus!='CANCELLED' and echallan.tenantid =? " +
			" and echallan.createdtime >= ? order by echallan.challanno desc ";
	@Autowired
	private VendorConfiguration config;

	private static final String Query = "select vendor.*,vendor_address.*,vendor_driver.*,vendor_vehicle.*, vendor.id as vendor_id,"
			+ "  vendor.createdby as vendor_createdby,vendor.lastmodifiedby as vendor_lastmodifiedby,"
			+ "  vendor.createdtime as vendor_createdtime," + "  vendor.lastmodifiedtime as vendor_lastmodifiedtime,"
			+ "  vendor.additionaldetails as vendor_additionaldetails,"
			+ "  vendor_address.id as vendor_address_id FROM eg_vendor vendor"
			+ "  INNER JOIN eg_vendor_address vendor_address on  vendor_address.vendor_id=vendor.id"
			+ "  LEFT OUTER JOIN eg_vendor_driver vendor_driver on  vendor_driver.vendor_id=vendor_address.id"
			+ "  LEFT OUTER JOIN eg_vendor_vehicle vendor_vehicle on "
			+ "  vendor_vehicle.vendor_id=vendor_driver.vendor_id";

	private final String paginationWrapper = "SELECT * FROM "
			+ "(SELECT *, DENSE_RANK() OVER (ORDER BY vendor_lastModifiedTime DESC) offset_ FROM " + "({})"
			+ " result) result_offset " + "WHERE offset_ > ? AND offset_ <= ?";

	private static final String DRIVER_VEHICLE_QUERY = "SELECT %s FROM %s where %s = ?";
	private static final String VEHICLE_EXISTS = "SELECT vendor_id FROM eg_vendor_vehicle where vechile_id IN ";

	private static final String DRIVER_ID = "driver_id";
	private static final String VEHICLE_ID = "vechile_id";
	private static final String VENDOR_ID = "vendor_id";
	private static final String VENDOR_DRIVER = "eg_vendor_driver";
	private static final String VENDOR_VEHICLE = "eg_vendor_vehicle";
	
	public static final String VENDOR_COUNT="select count(*) from eg_vendor where owner_id IN ";

	public String getDriverSearchQuery() {
		return String.format(DRIVER_VEHICLE_QUERY, DRIVER_ID, VENDOR_DRIVER, VENDOR_ID);
	}

	public String getVehicleSearchQuery() {
		return String.format(DRIVER_VEHICLE_QUERY, VEHICLE_ID, VENDOR_VEHICLE, VENDOR_ID);
	}
	
	public String vendorsForVehicles(List<String> vehicleIds, List<Object> preparedStmtList) {
		StringBuilder builder = new StringBuilder(VEHICLE_EXISTS);		
		builder.append("(").append(createQuery(vehicleIds)).append(")");
		addToPreparedStatement(preparedStmtList, vehicleIds);
		return builder.toString();
	}

	public String getvendorCount(List<String> ownerList,String tenantId, List<Object> preparedStmtList) {
		StringBuilder builder = new StringBuilder(VENDOR_COUNT);		
		builder.append("(").append(createQuery(ownerList)).append(")");
		addToPreparedStatement(preparedStmtList, ownerList);
		
		if( !StringUtils.isEmpty(tenantId)) {
			builder.append(" and tenantid = ?");
			preparedStmtList.add(tenantId);
		}
		return builder.toString();

	}


	public String getVendorSearchQuery(VendorSearchCriteria criteria, List<Object> preparedStmtList) {
		StringBuilder builder = new StringBuilder(Query);
		if (criteria.getTenantId() != null) {
			
				addClauseIfRequired(preparedStmtList, builder);
				builder.append(" vendor.status = ? ");
				preparedStmtList.add("ACTIVE");
			
			
			if (criteria.getTenantId().split("\\.").length == 1) {
				addClauseIfRequired(preparedStmtList, builder);
				builder.append(" vendor.tenantid like ?");
				preparedStmtList.add('%' + criteria.getTenantId() + '%');
			} else {
				addClauseIfRequired(preparedStmtList, builder);
				builder.append(" vendor.tenantid=? ");
				preparedStmtList.add(criteria.getTenantId());
			}

			List<String> vendor_name = criteria.getName();
			if (!CollectionUtils.isEmpty(vendor_name)) {
				addClauseIfRequired(preparedStmtList, builder);
				builder.append(" vendor.name IN (").append(createQuery(vendor_name)).append(")");
				addToPreparedStatement(preparedStmtList, vendor_name);

			}
			List<String> ownerIds = criteria.getOwnerIds();
			if (!CollectionUtils.isEmpty(ownerIds)) {
				addClauseIfRequired(preparedStmtList, builder);
				builder.append(" vendor.owner_id IN (").append(createQuery(ownerIds)).append(")");
				addToPreparedStatement(preparedStmtList, ownerIds);
			}

			// Don't know to which coloum need to map mean while mapping to vendor_id
			List<String> ids = criteria.getIds();
			if (!CollectionUtils.isEmpty(ids)) {
				addClauseIfRequired(preparedStmtList, builder);
				builder.append(" vendor.id IN (").append(createQuery(ids)).append(")");
				addToPreparedStatement(preparedStmtList, ids);
			}
		}
		return addPaginationWrapper(builder.toString(), preparedStmtList, criteria);
	}

	private String addPaginationWrapper(String query, List<Object> preparedStmtList, VendorSearchCriteria criteria) {
		int limit = config.getDefaultLimit();
		int offset = config.getDefaultOffset();
		String finalQuery = paginationWrapper.replace("{}", query);

		if (criteria.getLimit() != null && criteria.getLimit() <= config.getMaxSearchLimit())
			limit = criteria.getLimit();

		if (criteria.getLimit() != null && criteria.getLimit() > config.getMaxSearchLimit()) {
			limit = config.getMaxSearchLimit();
		}

		if (criteria.getOffset() != null)
			offset = criteria.getOffset();

		if (limit == -1) {
			finalQuery = finalQuery.replace("WHERE offset_ > ? AND offset_ <= ?", "");
		} else {
			preparedStmtList.add(offset);
			preparedStmtList.add(limit + offset);
		}

		return finalQuery;

	}

	private void addClauseIfRequired(List<Object> values, StringBuilder queryString) {
		if (values.isEmpty())
			queryString.append(" WHERE ");
		else {
			queryString.append(" AND");
		}
	}

	private void addToPreparedStatement(List<Object> preparedStmtList, List<String> ids) {
		ids.forEach(id -> {
			preparedStmtList.add(id);
		});

	}

	private Object createQuery(List<String> ids) {
		StringBuilder builder = new StringBuilder();
		int length = ids.size();
		for (int i = 0; i < length; i++) {
			builder.append(" ?");
			if (i != length - 1)
				builder.append(",");
		}
		return builder.toString();
	}

	public String getVendorLikeQuery(VendorSearchCriteria criteria, List<Object> preparedStmtList) {

		StringBuilder builder = new StringBuilder(Query);

		List<String> ids = criteria.getIds();
		if (!CollectionUtils.isEmpty(ids)) {

			addClauseIfRequired(preparedStmtList, builder);
			builder.append(" vendor.id IN (").append(createQuery(ids)).append(")");
			addToPreparedStatement(preparedStmtList, ids);
		}

		return addPaginationClause(builder, preparedStmtList, criteria);

	}

	private String addPaginationClause(StringBuilder builder, List<Object> preparedStmtList,
			VendorSearchCriteria criteria) {

		if (criteria.getLimit()!=null && criteria.getLimit() != 0) {
			builder.append("and vendor.id in (select id from eg_vendor where tenantid like ? order by id offset ? limit ?)");
			if (criteria.getTenantId() != null) {
				if (criteria.getTenantId().split("\\.").length == 1) {
					
					preparedStmtList.add('%' + criteria.getTenantId() + '%');
				} else {
					
					preparedStmtList.add(criteria.getTenantId());
				}
			}
			preparedStmtList.add(criteria.getOffset());
			preparedStmtList.add(criteria.getLimit());

			 addOrderByClause(builder, criteria);

		} else {
			 addOrderByClause(builder, criteria);
		}
		return builder.toString();
	}

	private void addOrderByClause(StringBuilder builder, VendorSearchCriteria criteria) {
		builder.append(" ORDER BY vendor.id DESC ").toString();
	}

}
