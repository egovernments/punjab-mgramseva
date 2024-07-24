package org.egov.waterconnection.repository.rowmapper;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.egov.waterconnection.repository.ServiceRequestRepository;
import org.egov.waterconnection.repository.builder.WsQueryBuilder;
import org.egov.waterconnection.service.UserService;
import org.egov.waterconnection.util.WaterServicesUtil;
import org.egov.waterconnection.web.models.*;
import org.egov.waterconnection.web.models.collection.Payment;
import org.egov.waterconnection.web.models.collection.PaymentResponse;
import org.egov.waterconnection.web.models.users.UserDetailResponse;
import org.egov.waterconnection.web.models.users.UserSearchRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Instant;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.ZoneId;
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

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private WsQueryBuilder wsQueryBuilder;

    String tenantId;
    RequestInfoWrapper requestInfoWrapper;
//    BigDecimal taxAmountForArrers;
//    BigDecimal totalAmountPaidForArrers;

    public void setTenantId(String tenantId) {
        this.tenantId = tenantId;
    }

    public void setRequestInfo(RequestInfoWrapper requestInfoWrapper) {
        this.requestInfoWrapper = requestInfoWrapper;
//        log.info("end date sent from frontend "+endDate.toString());
    }

//    public void setTaxAmountResult(BigDecimal taxAmountResult)
//    {
//        this.taxAmountForArrers=taxAmountResult;
//    }
//
//    public void setTotalAmountPaidResult(BigDecimal totalAmountPaidResult)
//    {
//        this.totalAmountPaidForArrers=totalAmountPaidResult;
//    }

    @Override
    public List<Map<String, Object>> extractData(ResultSet resultSet) throws SQLException, DataAccessException {
        List<Map<String, Object>> monthlyRecordsList = new ArrayList<>();
        Map<String, LedgerReport> ledgerReports = new HashMap<>();
        BigDecimal previousBalanceLeft = BigDecimal.ZERO;
//        BigDecimal totalAmountForArrears = taxAmountForArrers != null ? taxAmountForArrers : BigDecimal.ZERO;
//        BigDecimal amountPaidForArrears = totalAmountPaidForArrers != null ? totalAmountPaidForArrers : BigDecimal.ZERO;
        BigDecimal arrears =BigDecimal.ZERO;

        while (resultSet.next()) {
            Long dateLong = resultSet.getLong("enddate");
            LocalDate date = Instant.ofEpochMilli(dateLong).atZone(ZoneId.systemDefault()).toLocalDate();
            String monthAndYear = date.format(DateTimeFormatter.ofPattern("MMMMyyyy"));

            String code = resultSet.getString("code");

            BigDecimal taxamount = resultSet.getBigDecimal("taxamount");

            Long demandGenerationDateLong = resultSet.getLong("demandgenerationdate");
            LocalDate demandGenerationDateLocal = Instant.ofEpochMilli(demandGenerationDateLong).atZone(ZoneId.systemDefault()).toLocalDate();
//            String demandGenerationDate = demandGenerationDateLocal.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

            LedgerReport ledgerReport = ledgerReports.getOrDefault(monthAndYear, new LedgerReport());

            if (ledgerReport.getDemand() == null) {
                ledgerReport.setDemand(new DemandLedgerReport());
            }
            if (ledgerReport.getPayment() == null) {
                ledgerReport.setPayment(new ArrayList<>());
            }

            if (code.equals("10102")) {
                ledgerReport.getDemand().setArrears(taxamount != null ? taxamount : BigDecimal.ZERO);
                ledgerReport.getDemand().setMonthAndYear(monthAndYear);
//                arrears = (resultSet.getBigDecimal("due") != null ? resultSet.getBigDecimal("due") : BigDecimal.ZERO)
//                        .subtract(resultSet.getBigDecimal("paid") != null ? resultSet.getBigDecimal("paid") : BigDecimal.ZERO);
            } else if (code.equals("WS_TIME_PENALTY") || code.equals("10201")) {
                ledgerReport.getDemand().setPenalty(taxamount != null ? taxamount : BigDecimal.ZERO);
                BigDecimal amount = ledgerReport.getDemand().getTaxamount() != null ? ledgerReport.getDemand().getTaxamount() : BigDecimal.ZERO;
                ledgerReport.getDemand().setTotalForCurrentMonth((taxamount != null ? taxamount : BigDecimal.ZERO).add(amount));
                ledgerReport.getDemand().setTotal_due_amount(ledgerReport.getDemand().getTotalForCurrentMonth().add(ledgerReport.getDemand().getArrears() != null ? ledgerReport.getDemand().getArrears() : BigDecimal.ZERO));
//                ledgerReport.setBalanceLeft(ledgerReport.getTotal_due_amount().subtract(ledgerReport.getPaid()));
//                previousBalanceLeft = ledgerReport.getBalanceLeft();
            } else if (code.equals("10101")) {
                ledgerReport.getDemand().setMonthAndYear(monthAndYear);
                ledgerReport.getDemand().setDemandGenerationDate(demandGenerationDateLong);
                ledgerReport.getDemand().setTaxamount(taxamount);
                ledgerReport.getDemand().setTotalForCurrentMonth(ledgerReport.getDemand().getTaxamount().add(ledgerReport.getDemand().getPenalty()!=null ? ledgerReport.getDemand().getPenalty() : BigDecimal.ZERO));
                long dueDateMillis = demandGenerationDateLocal.plus(10, ChronoUnit.DAYS).atStartOfDay(ZoneId.systemDefault()).toInstant().toEpochMilli();
                long penaltyAppliedDateMillis = demandGenerationDateLocal.plus(11, ChronoUnit.DAYS).atStartOfDay(ZoneId.systemDefault()).toInstant().toEpochMilli();
                ledgerReport.getDemand().setDueDate(dueDateMillis);
                ledgerReport.getDemand().setPenaltyAppliedDate(penaltyAppliedDateMillis);
//                ledgerReport.setCollectionDate(resultSet.getDate("collectiondate") != null ? resultSet.getDate("collectiondate").toLocalDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) : null);
//                ledgerReport.setReceiptNo(resultSet.getString("receiptno"));
//                ledgerReport.setPaid(resultSet.getBigDecimal("paid"));
//                if (arrears.equals(BigDecimal.ZERO)) {
//                } else {
//                    ledgerReport.getDemand().setArrears(arrears);
//                    arrears = BigDecimal.ZERO;
//                }
                Long startDate = resultSet.getLong("startdate");
                String connectionno=resultSet.getString("connectionno");
                BigDecimal taxAmountResult = getMonthlyTaxAmount(startDate,connectionno);
                BigDecimal totalAmountPaidResult = getMonthlyTotalAmountPaid(startDate,connectionno);
                ledgerReport.getDemand().setArrears(taxAmountResult.subtract(totalAmountPaidResult));
                ledgerReport.getDemand().setTotal_due_amount(ledgerReport.getDemand().getTotalForCurrentMonth().add(ledgerReport.getDemand().getArrears()));
//                ledgerReport.setBalanceLeft(ledgerReport.getTotal_due_amount().subtract(ledgerReport.getPaid()));
//                previousBalanceLeft = ledgerReport.getBalanceLeft();
//                String consumerCode=resultSet.getString("connectionno");
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
        log.info("ledger report list" + monthlyRecordsList);
        if (!monthlyRecordsList.isEmpty()) {
//            enrichConnectionHolderDetails(monthlyRecordsList);
            addPaymentToLedger(monthlyRecordsList);
        }
        return monthlyRecordsList;
    }

    private void enrichConnectionHolderDetails(List<Map<String, Object>> monthlyRecordsList) {
        Set<String> connectionHolderIds = new HashSet<>();
        for (Map<String, Object> record : monthlyRecordsList) {
            LedgerReport ledgerReport = (LedgerReport) record.values().iterator().next();
            if (ledgerReport == null) {
                log.info("LedgerReport is null for record: {}", record);
            }

            DemandLedgerReport demandLedgerReport = ledgerReport.getDemand();
            if (demandLedgerReport == null) {
                log.info("DemandLedgerReport is null for LedgerReport: {}", ledgerReport);
            }
            String userId = demandLedgerReport.getUserId();
            if (userId == null) {
                log.info("UserId is null for DemandLedgerReport: {}", demandLedgerReport);
            }
            connectionHolderIds.add(userId);
        }
        UserSearchRequest userSearchRequest = new UserSearchRequest();
        userSearchRequest.setUuid(connectionHolderIds);
        log.info("User search request" + userSearchRequest);
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

    public List<Payment> addPaymentDetails(String consumerCode) {
        String service = "WS";
        StringBuilder URL = waterServiceUtil.getcollectionURL();
        URL.append(service).append("/_search").append("?").append("consumerCodes=").append(consumerCode)
                .append("&").append("tenantId=").append(tenantId);
//        RequestInfoWrapper requestInfoWrapper = RequestInfoWrapper.builder().requestInfo(waterConnectionRequest.getRequestInfo()).build();
        Object response = serviceRequestRepository.fetchResult(URL, requestInfoWrapper);
        log.info("line 199 response "+response.toString());
        PaymentResponse paymentResponse = mapper.convertValue(response, PaymentResponse.class);
        log.info("paymnent response"+paymentResponse);
        return paymentResponse.getPayments();
    }

    private void addPaymentToLedger(List<Map<String, Object>> monthlyRecordList) {
        for (Map<String, Object> record : monthlyRecordList) {
            LedgerReport ledgerReport = (LedgerReport) record.values().iterator().next();
            if (ledgerReport.getDemand() == null) {
                log.info("DemandLedgerReport is null for LedgerReport: {}", ledgerReport);
            }
            String consumerCode = ledgerReport.getDemand().getConnectionNo();
            log.info("consumer code is "+consumerCode);
            List<Payment> payments = addPaymentDetails(consumerCode);

            for (Payment payment : payments) {
                Long transactionDateLong = payment.getTransactionDate();
                LocalDate transactionDate = Instant.ofEpochMilli(transactionDateLong).atZone(ZoneId.systemDefault()).toLocalDate();
                String transactionMonthAndYear = transactionDate.format(DateTimeFormatter.ofPattern("MMMMyyyy"));
                PaymentLedgerReport paymentLedgerReport = new PaymentLedgerReport();
                if (ledgerReport.getDemand().getMonthAndYear().equals(transactionMonthAndYear)) {
                    paymentLedgerReport.setCollectionDate(transactionDateLong);
                    paymentLedgerReport.setReceiptNo(payment.getPaymentDetails().get(0).getReceiptNumber());
                    paymentLedgerReport.setPaid(payment.getTotalAmountPaid());
                    paymentLedgerReport.setBalanceLeft(ledgerReport.getDemand().getTotal_due_amount().subtract(payment.getTotalAmountPaid()));
                }
//                else
//                {
//                    paymentLedgerReport.setCollectionDate(null);
//                    paymentLedgerReport.setReceiptNo(null);
//                    paymentLedgerReport.setPaid(BigDecimal.ZERO);
//                    paymentLedgerReport.setBalanceLeft(ledgerReport.getDemand().getTotal_due_amount().subtract(payment.getTotalAmountPaid()));
//                }

                if (ledgerReport.getPayment() == null) {
                    ledgerReport.setPayment(new ArrayList<>());
                }
                ledgerReport.getPayment().add(paymentLedgerReport);
            }
        }
    }

    private BigDecimal getMonthlyTaxAmount(Long startDate, String consumerCode) {
        StringBuilder taxAmountQuery=new StringBuilder(wsQueryBuilder.TAX_AMOUNT_QUERY);
        List<Object> taxAmountParams=new ArrayList<>();
        taxAmountParams.add(consumerCode);
        taxAmountParams.add(startDate);
        BigDecimal ans= jdbcTemplate.queryForObject(taxAmountQuery.toString(), taxAmountParams.toArray(), BigDecimal.class);
        if(ans!=null)
            return ans;
        return BigDecimal.ZERO;
    }

    private BigDecimal getMonthlyTotalAmountPaid(Long startDate, String consumerCode) {
        StringBuilder totalAmountPaidQuery = new StringBuilder(wsQueryBuilder.TOTAL_AMOUNT_PAID_QUERY);
        List<Object> totalAmountPaidParams = new ArrayList<>();
        totalAmountPaidParams.add(consumerCode);
        totalAmountPaidParams.add(startDate);
        BigDecimal ans=jdbcTemplate.queryForObject(totalAmountPaidQuery.toString(), totalAmountPaidParams.toArray(), BigDecimal.class);
        if(ans!=null)
            return ans;
        return BigDecimal.ZERO;
    }
}
