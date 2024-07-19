package org.egov.waterconnection.repository.rowmapper;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.egov.waterconnection.repository.ServiceRequestRepository;
import org.egov.waterconnection.service.UserService;
import org.egov.waterconnection.util.WaterServicesUtil;
import org.egov.waterconnection.web.models.DemandLedgerReport;
import org.egov.waterconnection.web.models.LedgerReport;
import org.egov.waterconnection.web.models.OwnerInfo;
import org.egov.waterconnection.web.models.RequestInfoWrapper;
import org.egov.waterconnection.web.models.collection.PaymentResponse;
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
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.time.temporal.ChronoUnit;


@Slf4j
@Component
public class LedgerReportRowMapper implements ResultSetExtractor<List<Map<String, Object>>> {

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserService userService;

    @Autowired
    private WaterServicesUtil waterServiceUtil;

    @Autowired
    private ObjectMapper mapper;

    @Autowired
    private ServiceRequestRepository serviceRequestRepository;

//    LocalDate startDateLocalDate;
//    LocalDate endDateLocalDate;
//
//    public void setStartDate(LocalDate startDate) {
//        this.startDateLocalDate = startDate;
//        log.info("start date sent from frontend "+startDate.toString());
//    }
//
//    public void setEndDate(LocalDate endDate) {
//        this.endDateLocalDate = endDate;
//        log.info("end date sent from frontend "+endDate.toString());
//    }

    @Override
    public List<Map<String, Object>> extractData(ResultSet resultSet) throws SQLException, DataAccessException {
        List<Map<String, Object>> monthlyRecordsList = new ArrayList<>();
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

            LedgerReport ledgerReport = ledgerReports.getOrDefault(monthAndYear, new LedgerReport());

            if (ledgerReport.getDemand() == null) {
                ledgerReport.setDemand(new DemandLedgerReport());
            }

            if (code.equals("10102")) {
                ledgerReport.getDemand().setArrears(taxamount != null ? taxamount : BigDecimal.ZERO);
                ledgerReport.getDemand().setMonthAndYear(monthAndYear);
                arrears = (resultSet.getBigDecimal("due") != null ? resultSet.getBigDecimal("due") : BigDecimal.ZERO)
                        .subtract(resultSet.getBigDecimal("paid") != null ? resultSet.getBigDecimal("paid") : BigDecimal.ZERO);
            }
            else if (code.equals("WS_TIME_PENALTY") || code.equals("10201")) {
                ledgerReport.getDemand().setPenalty(taxamount != null ? taxamount : BigDecimal.ZERO);
                BigDecimal amount = ledgerReport.getDemand().getTaxamount() != null ? ledgerReport.getDemand().getTaxamount() : BigDecimal.ZERO;
                ledgerReport.getDemand().setTotalForCurrentMonth((taxamount != null ? taxamount : BigDecimal.ZERO).add(amount));
                ledgerReport.getDemand().setTotal_due_amount(ledgerReport.getDemand().getTotalForCurrentMonth().add(ledgerReport.getDemand().getArrears() != null ? ledgerReport.getDemand().getArrears() : BigDecimal.ZERO));
//                ledgerReport.setBalanceLeft(ledgerReport.getTotal_due_amount().subtract(ledgerReport.getPaid()));
//                previousBalanceLeft = ledgerReport.getBalanceLeft();
            } else if (code.equals("10101")) {
                ledgerReport.getDemand().setMonthAndYear(monthAndYear);
                ledgerReport.getDemand().setDemandGenerationDate(demandGenerationDate);
                ledgerReport.getDemand().setTaxamount(taxamount);
                ledgerReport.getDemand().setTotalForCurrentMonth(ledgerReport.getDemand().getTaxamount().add(ledgerReport.getDemand().getPenalty()));
                ledgerReport.getDemand().setDueDate(demandGenerationDateLocal.plus(10, ChronoUnit.DAYS).format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
                ledgerReport.getDemand().setPenaltyAppliedDate(demandGenerationDateLocal.plus(11, ChronoUnit.DAYS).format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
//                ledgerReport.setCollectionDate(resultSet.getDate("collectiondate") != null ? resultSet.getDate("collectiondate").toLocalDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) : null);
//                ledgerReport.setReceiptNo(resultSet.getString("receiptno"));
//                ledgerReport.setPaid(resultSet.getBigDecimal("paid"));
                if (arrears.equals(BigDecimal.ZERO)) {
                    ledgerReport.getDemand().setArrears(previousBalanceLeft);
                } else {
                    ledgerReport.getDemand().setArrears(arrears);
                    arrears = BigDecimal.ZERO;
                }
                ledgerReport.getDemand().setTotal_due_amount(ledgerReport.getDemand().getTotalForCurrentMonth().add(ledgerReport.getDemand().getArrears()));
//                ledgerReport.setBalanceLeft(ledgerReport.getTotal_due_amount().subtract(ledgerReport.getPaid()));
//                previousBalanceLeft = ledgerReport.getBalanceLeft();
                ledgerReport.getDemand().setCode(code);
                String consumerCode=resultSet.getString("connectionno");
            }
            ledgerReport.getDemand().setConnectionNo(resultSet.getString("connectionno"));
            ledgerReport.getDemand().setOldConnectionNo(resultSet.getString("oldconnectionno"));
            ledgerReport.getDemand().setUserId(resultSet.getString("uuid"));
            log.info("Data inserted into map " + ledgerReport.toString());
            ledgerReports.put(monthAndYear, ledgerReport);
        }
//        for (Map.Entry<String, LedgerReport> entry : ledgerReports.entrySet()) {
//            String monthAndYear = entry.getKey();
//            log.info("Month and year from map "+monthAndYear);
//            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMMyyyy", Locale.ENGLISH);
//            YearMonth yearMonth = YearMonth.parse(monthAndYear, formatter);
//            LocalDate endDate = yearMonth.atDay(1);
//            String code = entry.getValue().getCode();
//            if (!endDate.isBefore(startDateLocalDate) && !endDate.isAfter(endDateLocalDate) && code.equals("10101")) {
//                ledgerReportList.add(entry.getValue());
//            }
//        }
        for (Map.Entry<String, LedgerReport> entry : ledgerReports.entrySet()) {
            Map<String, Object> record = new HashMap<>();
            record.put(entry.getKey(), entry.getValue());
            monthlyRecordsList.add(record);
        }
        log.info("ledger report list"+monthlyRecordsList);
        if (!monthlyRecordsList.isEmpty()) {
            enrichConnectionHolderDetails(monthlyRecordsList);
        }
        return monthlyRecordsList;
    }

    private void enrichConnectionHolderDetails(List<Map<String, Object>> monthlyRecordsList) {
        Set<String> connectionHolderIds = new HashSet<>();
        for (Map<String, Object> record : monthlyRecordsList) {
            LedgerReport ledgerReport = (LedgerReport) record.values().iterator().next();
            connectionHolderIds.add(ledgerReport.getDemand().getUserId());
        }
        UserSearchRequest userSearchRequest = new UserSearchRequest();
        userSearchRequest.setUuid(connectionHolderIds);
        UserDetailResponse userDetailResponse = userService.getUser(userSearchRequest);
        enrichConnectionHolderInfo(userDetailResponse, monthlyRecordsList);
    }

    private void enrichConnectionHolderInfo(UserDetailResponse userDetailResponse,
                                            List<Map<String, Object>> monthlyRecordsList) {
        List<OwnerInfo> connectionHolderInfos = userDetailResponse.getUser();
        Map<String, OwnerInfo> userIdToConnectionHolderMap = new HashMap<>();
        connectionHolderInfos.forEach(user -> userIdToConnectionHolderMap.put(user.getUuid(), user));
        for (Map<String, Object> record : monthlyRecordsList) {
            LedgerReport ledgerReport = (LedgerReport) record.values().iterator().next();
            ledgerReport.getDemand().setConsumerName(userIdToConnectionHolderMap.get(ledgerReport.getDemand().getUserId()).getName());
        }
    }

    public void addPaymentDetails(String consumerCode,String tenantId,RequestInfoWrapper requestInfoWrapper)
    {
        String service = "WS";
        StringBuilder URL = waterServiceUtil.getcollectionURL();
        URL.append(service).append("/_search").append("?").append("consumerCodes=").append(consumerCode)
                .append("&").append("tenantId=").append(tenantId);
//        RequestInfoWrapper requestInfoWrapper = RequestInfoWrapper.builder().requestInfo(waterConnectionRequest.getRequestInfo()).build();
        Object response = serviceRequestRepository.fetchResult(URL,requestInfoWrapper);
        PaymentResponse paymentResponse = mapper.convertValue(response, PaymentResponse.class);
//        return paymentResponse.getPayments().get(0).getPaymentDetails().get(0).getReceiptNumber();
    }
}
