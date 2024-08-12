package org.egov.waterconnection.repository.rowmapper;

import org.egov.waterconnection.repository.builder.WsQueryBuilder;
import org.egov.waterconnection.web.models.MonthReport;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

//public class MonthReportRowMapper implements ResultSetExtractor<List<MonthReport>>
//{
//
//    @Autowired
//    private ObjectMapper mapper;
//
//    @Autowired
//    private UserService userService;
//
//    @Override
//    public List<MonthReport> extractData(ResultSet resultSet) throws SQLException, DataAccessException {
//        List<MonthReport> monthReportList = new ArrayList<>();
//        while (resultSet.next()) {
//            MonthReport monthReport = new MonthReport();
//            monthReport.setTenantName(resultSet.getString("tenantId"));
//            monthReport.setConnectionNo(resultSet.getString("connectionNo"));
//            monthReport.setOldConnectionNo(resultSet.getString("oldConnectionNo"));
//            monthReport.setUserId(resultSet.getString("uuid"));
//            monthReport.setConsumerCreatedOnDate(resultSet.getString("connCreatedDate"));
//            monthReport.setAdvance(resultSet.getBigDecimal("WS_ADVANCE_CARRYFORWARD_DemandAmount"));
//            monthReport.setPenalty(resultSet.getBigDecimal("WS_TIME_PENALTY_DemandAmount"));
//            monthReport.setDemandAmount(resultSet.getBigDecimal("A10101_DemandAmount"));
//            monthReport.setDemandGenerationDate(resultSet.getLong("demandGenerationDate"));
//            monthReport.setTotalAmount(resultSet.getBigDecimal("TotalDemandAmount"));
//            monthReportList.add(monthReport);
//        }
//        if(!monthReportList.isEmpty()){
//            enrichConnectionHolderDetails(monthReportList);
//        }
//        return monthReportList;
//    }
//
//    private void enrichConnectionHolderDetails(List<MonthReport> monthReportList) {
//        Set<String> connectionHolderIds = new HashSet<>();
//        for (MonthReport monthReport : monthReportList) {
//            connectionHolderIds.add(monthReport.getUserId());
//        }
//        UserSearchRequest userSearchRequest = new UserSearchRequest();
//        userSearchRequest.setUuid(connectionHolderIds);
//        UserDetailResponse userDetailResponse = userService.getUser(userSearchRequest);
//        enrichConnectionHolderInfo(userDetailResponse, monthReportList);
//
//    }
//
//    private void enrichConnectionHolderInfo(UserDetailResponse userDetailResponse,
//                                            List<MonthReport> monthReportList) {
//        List<OwnerInfo> connectionHolderInfos = userDetailResponse.getUser();
//        Map<String, OwnerInfo> userIdToConnectionHolderMap = new HashMap<>();
//        connectionHolderInfos.forEach(user -> userIdToConnectionHolderMap.put(user.getUuid(), user));
//        monthReportList.forEach(monthReport-> monthReport.setConsumerName(userIdToConnectionHolderMap.get(monthReport.getUserId()).getName()));
//    }
//}
@Component
public class MonthReportRowMapper implements RowMapper<MonthReport>
{
    @Override
    public MonthReport mapRow(ResultSet rs, int rowNum) throws SQLException {
        return MonthReport.builder()
                .tenantName(rs.getString("tenantId"))
                .connectionNo(rs.getString("connectionNo"))
                .oldConnectionNo(rs.getString("oldConnectionNo"))
                .consumerCreatedOnDate(rs.getLong("consumerCreatedOnDate"))
                .userId(rs.getString("userId"))
                .demandGenerationDate(rs.getLong("demandGenerationDate"))
                .penalty(rs.getBigDecimal("penalty"))
                .demandAmount(rs.getBigDecimal("demandAmount"))
                .advance(rs.getBigDecimal("advance"))
                .build();
    }
}
