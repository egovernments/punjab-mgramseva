package org.egov.wscalculation.repository.builder;


import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Set;

@Component
@Slf4j
public class DemandQueryBuilder {
    private String selectClause = "SELECT b.demandid FROM egbs_demanddetail_v1 b ";
    private String subQuery = "SELECT dt.demandid FROM egbs_demand_v1 d LEFT OUTER JOIN egbs_demanddetail_v1 dt ON d.id = dt.demandid AND dt.taxamount > dt.collectionamount " +
            "AND dt.taxheadcode = '10101'"+"AND d.status = 'ACTIVE'";
    private String firstWhereClause = "WHERE demandid IN (" ;
    private String secondWhereClause = ") AND b.tenantid = '";

    String groupByClause = " GROUP BY b.demandid " +
            "HAVING COUNT(*) = 1 ";

    public String getPenaltyQuery(String tenantId, Long penaltyThresholdDate, Integer daysToBeSubstracted ) {
        //TODO: find out days
        long currentTimeMillis = System.currentTimeMillis();
        long tenDaysAgoMillis = Instant.ofEpochMilli(currentTimeMillis)
                .minus(daysToBeSubstracted, ChronoUnit.DAYS)
                .toEpochMilli();
        subQuery = subQuery +  " AND d.tenantid = '"+tenantId+"'";
        subQuery = subQuery + " AND d.createdtime < " + tenDaysAgoMillis;
        if(!ObjectUtils.isEmpty(penaltyThresholdDate) && penaltyThresholdDate > 0) {
            subQuery = subQuery + " AND d.taxperiodfrom > " + penaltyThresholdDate;
        }
        secondWhereClause= secondWhereClause +tenantId+"'";
        firstWhereClause = firstWhereClause + subQuery + secondWhereClause + groupByClause;
        selectClause = selectClause + firstWhereClause;
        StringBuilder  builder = new StringBuilder(selectClause);
        log.info("Query formed :" + builder.toString());
        return builder.toString();

    }
}
