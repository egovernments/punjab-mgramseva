package org.egov.waterconnection.repository.rowmapper;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.egov.waterconnection.service.UserService;
import org.egov.waterconnection.web.models.LedgerReport;
import org.egov.waterconnection.web.models.OwnerInfo;
import org.egov.waterconnection.web.models.users.UserDetailResponse;
import org.egov.waterconnection.web.models.users.UserSearchRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.time.temporal.ChronoUnit;


@Slf4j
@Component
public class LedgerReportRowMapper implements ResultSetExtractor<List<LedgerReport>> {

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserService userService;

    @Override
    public List<LedgerReport> extractData(ResultSet resultSet) throws SQLException, DataAccessException {
        List<LedgerReport> ledgerReportList = new ArrayList<>();
        Map<String, LedgerReport> ledgerReports = new HashMap<>();
        BigDecimal previousBalanceLeft = BigDecimal.ZERO;
        BigDecimal arrears = BigDecimal.ZERO;

        while (resultSet.next()) {
            LocalDate date = resultSet.getDate("enddate").toLocalDate();
            String monthAndYear = date.format(DateTimeFormatter.ofPattern("MMMMyyyy"));

            String code = resultSet.getString("code");

            BigDecimal taxamount = resultSet.getBigDecimal("taxamount");

            LocalDate demandGenerationDateLocal = resultSet.getDate("demandgenerationdate").toLocalDate();
            String demandGenerationDate = demandGenerationDateLocal.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

            LedgerReport ledgerReport = ledgerReports.getOrDefault(monthAndYear, new LedgerReport(monthAndYear));

            if (code.equals("10102")) {
                ledgerReport.setArrears(taxamount);
                ledgerReport.setMonthAndYear(monthAndYear);
                arrears = resultSet.getBigDecimal("due").subtract(resultSet.getBigDecimal("paid"));
            } else if (code.equals("WS_TIME_PENALTY") || code.equals("10201")) {
                ledgerReport.setPenalty(taxamount);
                BigDecimal amount = ledgerReports.get(monthAndYear).getTaxamount() != null ? ledgerReports.get(monthAndYear).getTaxamount() : BigDecimal.ZERO;
                ledgerReport.setTotalForCurrentMonth(taxamount.add(amount));
                ledgerReport.setTotal_due_amount(ledgerReport.getTotalForCurrentMonth().add(ledgerReport.getArrears()));
                ledgerReport.setBalanceLeft(ledgerReport.getTotal_due_amount().subtract(ledgerReport.getPaid()));
                previousBalanceLeft = ledgerReport.getBalanceLeft();
            } else if (code.equals("10101")) {
                ledgerReport.setMonthAndYear(monthAndYear);
                ledgerReport.setDemandGenerationDate(demandGenerationDate);
                ledgerReport.setTaxamount(taxamount);
                ledgerReport.setTotalForCurrentMonth(ledgerReport.getTaxamount().add(ledgerReport.getPenalty()));
                ledgerReport.setDueDate(demandGenerationDateLocal.plus(10, ChronoUnit.DAYS).format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
                ledgerReport.setPenaltyAppliedDate(demandGenerationDateLocal.plus(11, ChronoUnit.DAYS).format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
                ledgerReport.setCollectionDate(resultSet.getDate("collectiondate") != null ? resultSet.getDate("collectiondate").toLocalDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) : null);
                ledgerReport.setReceiptNo(resultSet.getString("receiptno"));
                ledgerReport.setPaid(resultSet.getBigDecimal("paid"));
                if (arrears.equals(BigDecimal.ZERO)) {
                    ledgerReport.setArrears(previousBalanceLeft);
                } else {
                    ledgerReport.setArrears(arrears);
                    arrears = BigDecimal.ZERO;
                }
                ledgerReport.setTotal_due_amount(ledgerReport.getTotalForCurrentMonth().add(ledgerReport.getArrears()));
                ledgerReport.setBalanceLeft(ledgerReport.getTotal_due_amount().subtract(ledgerReport.getPaid()));
                previousBalanceLeft = ledgerReport.getBalanceLeft();
            }
            ledgerReport.setConnectionNo(resultSet.getString("connectionno"));
            ledgerReport.setOldConnectionNo(resultSet.getString("oldconnectionno"));
            ledgerReport.setUserId(resultSet.getString("uuid"));
            log.info("Data inserted into map "+ledgerReport.toString());
            ledgerReports.put(monthAndYear, ledgerReport);
        }
        ledgerReportList.addAll(ledgerReports.values());
        if(!ledgerReportList.isEmpty())
        {
            enrichConnectionHolderDetails(ledgerReportList);
        }
        return ledgerReportList;
    }

    private void enrichConnectionHolderDetails(List<LedgerReport> ledgerReportList) {
        Set<String> connectionHolderIds = new HashSet<>();
        for (LedgerReport ledgerReport : ledgerReportList) {
            connectionHolderIds.add(ledgerReport.getUserId());
        }
        UserSearchRequest userSearchRequest = new UserSearchRequest();
        userSearchRequest.setUuid(connectionHolderIds);
        UserDetailResponse userDetailResponse = userService.getUser(userSearchRequest);
        enrichConnectionHolderInfo(userDetailResponse, ledgerReportList);
    }

    private void enrichConnectionHolderInfo(UserDetailResponse userDetailResponse,
                                            List<LedgerReport> ledgerReportList) {
        List<OwnerInfo> connectionHolderInfos = userDetailResponse.getUser();
        Map<String, OwnerInfo> userIdToConnectionHolderMap = new HashMap<>();
        connectionHolderInfos.forEach(user -> userIdToConnectionHolderMap.put(user.getUuid(), user));
        ledgerReportList.forEach(ledgerReport-> ledgerReport.setConsumerName(userIdToConnectionHolderMap.get(ledgerReport.getUserId()).getName()));
    }
}
