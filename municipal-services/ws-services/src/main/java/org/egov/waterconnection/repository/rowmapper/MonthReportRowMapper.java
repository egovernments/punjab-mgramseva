package org.egov.waterconnection.repository.rowmapper;

import org.egov.waterconnection.service.UserService;
import org.egov.waterconnection.web.models.CollectionReportData;
import org.egov.waterconnection.web.models.MonthReport;
import org.egov.waterconnection.web.models.OwnerInfo;
import org.egov.waterconnection.web.models.users.UserDetailResponse;
import org.egov.waterconnection.web.models.users.UserSearchRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

@Component
public class MonthReportRowMapper implements RowMapper<MonthReport>
{
    @Autowired
    private UserService userService;

    @Override
    public MonthReport mapRow(ResultSet rs, int rowNum) throws SQLException {
        MonthReport monthReport = MonthReport.builder()
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

        enrichConsumerName(monthReport);
        return monthReport;
    }

    private void enrichConsumerName(MonthReport monthReport) {
        Set<String> connectionHolderIds = new HashSet<>();
        connectionHolderIds.add(monthReport.getUserId());
        UserSearchRequest userSearchRequest = new UserSearchRequest();
        userSearchRequest.setUuid(connectionHolderIds);
        UserDetailResponse userDetailResponse = userService.getUser(userSearchRequest);
        if (userDetailResponse != null && userDetailResponse.getUser() != null && !userDetailResponse.getUser().isEmpty()) {
            OwnerInfo ownerInfo = userDetailResponse.getUser().get(0);
            monthReport.setConsumerName(ownerInfo.getName());
        }
    }
}
