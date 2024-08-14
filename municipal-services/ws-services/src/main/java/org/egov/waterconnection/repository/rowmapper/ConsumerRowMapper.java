package org.egov.waterconnection.repository.rowmapper;

import org.egov.waterconnection.web.models.MonthReport;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import java.sql.ResultSet;
import java.sql.SQLException;

@Component
public class ConsumerRowMapper implements RowMapper<MonthReport> {
    @Override
    public MonthReport mapRow(ResultSet rs, int rowNum) throws SQLException {
        return MonthReport.builder()
                .tenantName(rs.getString("tenantId"))
                .connectionNo(rs.getString("connectionNo"))
                .oldConnectionNo(rs.getString("oldConnectionNo"))
                .consumerCreatedOnDate(rs.getLong("consumerCreatedOnDate"))
                .userId(rs.getString("userId"))
                .build();
    }
}