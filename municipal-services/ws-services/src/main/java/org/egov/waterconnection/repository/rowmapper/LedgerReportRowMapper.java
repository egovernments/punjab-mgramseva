package org.egov.waterconnection.repository.rowmapper;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.models.auth.In;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.egov.waterconnection.config.WSConfiguration;
import org.egov.waterconnection.repository.ServiceRequestRepository;
import org.egov.waterconnection.repository.builder.WsQueryBuilder;
import org.egov.waterconnection.util.WaterServicesUtil;
import org.egov.waterconnection.web.models.*;
import org.egov.waterconnection.web.models.collection.Payment;
import org.egov.waterconnection.web.models.collection.PaymentResponse;
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
@Setter
public class LedgerReportRowMapper implements ResultSetExtractor<List<Map<String, Object>>> {

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
    Integer startYear;
    Integer endYear;
    String consumerCode;

    @Autowired
    private WSConfiguration config;

    public void setRequestInfo(RequestInfoWrapper requestInfoWrapper) {
        this.requestInfoWrapper = requestInfoWrapper;
    }

    @Override
    public List<Map<String, Object>> extractData(ResultSet resultSet) throws SQLException, DataAccessException {
        List<Map<String, Object>> monthlyRecordsList = new ArrayList<>();
        Map<String, LedgerReport> ledgerReports = new HashMap<>();
        YearMonth startMonth = YearMonth.of(startYear, 4);
        YearMonth endMonth;
        YearMonth now = YearMonth.now();

        if (startYear == now.getYear() || (startYear == now.getYear() - 1 && now.getMonthValue() <= 3)) {
            endMonth = now;
        } else {
            endMonth = YearMonth.of(startYear + 1, 3);
        }

        YearMonth currentMonth = startMonth;

        while (!currentMonth.isAfter(endMonth)) {
            String monthAndYear = currentMonth.format(DateTimeFormatter.ofPattern("MMMM yyyy"));
            LocalDate startOfMonth = currentMonth.atDay(1);
            Long epochTime = startOfMonth.atStartOfDay(ZoneId.systemDefault()).toInstant().toEpochMilli();
            log.info("epoch time is "+epochTime);
            LedgerReport ledgerReport = new LedgerReport();
            ledgerReport.setDemand(new DemandLedgerReport());
            ledgerReport.getDemand().setMonthAndYear(monthAndYear);
            ledgerReport.getDemand().setConnectionNo(consumerCode);

            log.info("Arrers are "+ledgerReport.getDemand().getArrears()+" and monthandYear"+ ledgerReport.getDemand().getMonthAndYear());
            ledgerReports.put(monthAndYear, ledgerReport);
            currentMonth = currentMonth.plusMonths(1);
        }
        while (resultSet.next()) {
            Long dateLong = resultSet.getLong("enddate");
            LocalDate date = Instant.ofEpochMilli(dateLong).atZone(ZoneId.systemDefault()).toLocalDate();
            String monthAndYear = date.format(DateTimeFormatter.ofPattern("MMMM yyyy"));

            String code = resultSet.getString("code");

            BigDecimal taxamount = resultSet.getBigDecimal("taxamount");

            Long demandGenerationDateLong = resultSet.getLong("demandgenerationdate");
            LocalDate demandGenerationDateLocal = Instant.ofEpochMilli(demandGenerationDateLong).atZone(ZoneId.systemDefault()).toLocalDate();
            BigDecimal totalAmountPaidResult = getMonthlyTotalAmountPaid(demandGenerationDateLong, consumerCode);
            boolean paymentExists = totalAmountPaidResult != null && totalAmountPaidResult.compareTo(BigDecimal.ZERO) > 0;
            BigDecimal taxAmountResult = getMonthlyTaxAmount(resultSet.getLong("startdate"), consumerCode,paymentExists);


            LedgerReport ledgerReport = ledgerReports.get(monthAndYear);
            ledgerReport.getDemand().setArrears(taxAmountResult.subtract(totalAmountPaidResult));

            if (ledgerReport.getPayment() == null) {
                ledgerReport.setPayment(new ArrayList<>());
            }

//            if (code.equals("10102")) {
//                ledgerReport.getDemand().setArrears(taxamount != null ? taxamount : BigDecimal.ZERO);
//                ledgerReport.getDemand().setMonthAndYear(monthAndYear);
//            } else
            BigDecimal arrers_Penalty=BigDecimal.ZERO;
            if(code.equalsIgnoreCase("10201"))
            {
                arrers_Penalty=taxamount;
            }
            if(code.equalsIgnoreCase("WS_Round_Off"))
            {
                ledgerReport.getDemand().setTaxamount(ledgerReport.getDemand().getTaxamount().add(taxamount));
            }
            if (code.equalsIgnoreCase("WS_TIME_PENALTY")) {
                ledgerReport.getDemand().setPenalty(taxamount != null ? taxamount : BigDecimal.ZERO);
                BigDecimal amount = ledgerReport.getDemand().getTaxamount() != null ? ledgerReport.getDemand().getTaxamount() : BigDecimal.ZERO;
                ledgerReport.getDemand().setTotalForCurrentMonth((taxamount != null ? taxamount : BigDecimal.ZERO).add(amount));
            } else if (code.equalsIgnoreCase("10101")) {
                ledgerReport.getDemand().setMonthAndYear(monthAndYear);
                ledgerReport.getDemand().setDemandGenerationDate(demandGenerationDateLong);
                ledgerReport.getDemand().setTaxamount(ledgerReport.getDemand().getTaxamount().add(taxamount));
                ledgerReport.getDemand().setTotalForCurrentMonth(ledgerReport.getDemand().getTaxamount().add(ledgerReport.getDemand().getPenalty() != null ? ledgerReport.getDemand().getPenalty() : BigDecimal.ZERO));
                long dueDateMillis = demandGenerationDateLocal.plus(10, ChronoUnit.DAYS).atStartOfDay(ZoneId.systemDefault()).toInstant().toEpochMilli();
                long penaltyAppliedDateMillis = demandGenerationDateLocal.plus(11, ChronoUnit.DAYS).atStartOfDay(ZoneId.systemDefault()).toInstant().toEpochMilli();
                ledgerReport.getDemand().setDueDate(dueDateMillis);
                ledgerReport.getDemand().setPenaltyAppliedDate(penaltyAppliedDateMillis);
//                ledgerReport.getDemand().setTotal_due_amount(ledgerReport.getDemand().getTotalForCurrentMonth().add(ledgerReport.getDemand().getArrears()));
            }
            ledgerReport.getDemand().setTotal_due_amount(ledgerReport.getDemand().getTotalForCurrentMonth().add(ledgerReport.getDemand().getArrears() != null ? ledgerReport.getDemand().getArrears() : BigDecimal.ZERO));
            ledgerReport.getDemand().setConnectionNo(resultSet.getString("connectionno"));
            ledgerReport.getDemand().setOldConnectionNo(resultSet.getString("oldconnectionno"));
            ledgerReport.getDemand().setUserId(resultSet.getString("uuid"));
            log.info("Data inserted into map " + ledgerReport.toString());
            ledgerReports.put(monthAndYear, ledgerReport);
        }
        for (Map.Entry<String, LedgerReport> entry : ledgerReports.entrySet()) {
            Map<String, Object> record = new HashMap<>();
                record.put(entry.getKey(), entry.getValue());
                monthlyRecordsList.add(record);
        }
        log.info("ledger report list" + monthlyRecordsList);
        if (!monthlyRecordsList.isEmpty()) {
            if(config.isReportRequiredInChronnologicalOrder())
                addPaymentToLedgerChronlogicalOrder(monthlyRecordsList);
            else
                addPaymentToLedger(monthlyRecordsList);

        }
        monthlyRecordsList.sort(new Comparator<Map<String, Object>>() {
            @Override
            public int compare(Map<String, Object> o1, Map<String, Object> o2) {
                String monthAndYear1 = (String) o1.keySet().iterator().next();
                String monthAndYear2 = (String) o2.keySet().iterator().next();

                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM yyyy", Locale.ENGLISH);
                YearMonth yearMonth1 = YearMonth.parse(monthAndYear1, formatter);
                YearMonth yearMonth2 = YearMonth.parse(monthAndYear2, formatter);

                return yearMonth1.compareTo(yearMonth2);
            }
        });
        return monthlyRecordsList;
    }

    public List<Payment> addPaymentDetails(String consumerCode) {
        if(consumerCode==null)
            return null;
        String service = "WS";
        StringBuilder URL = waterServiceUtil.getcollectionURL();
        URL.append(service).append("/_search").append("?").append("consumerCodes=").append(consumerCode)
                .append("&").append("tenantId=").append(tenantId);
        Object response = serviceRequestRepository.fetchResult(URL, requestInfoWrapper);
        log.info("line 226 response " + response.toString());
        PaymentResponse paymentResponse = mapper.convertValue(response, PaymentResponse.class);
        return paymentResponse.getPayments();
    }

    private void addPaymentToLedger(List<Map<String, Object>> monthlyRecordList) {
        for (Map<String, Object> record : monthlyRecordList) {
            LedgerReport ledgerReport = (LedgerReport) record.values().iterator().next();
            if (ledgerReport.getDemand() == null) {
                log.info("DemandLedgerReport is null for LedgerReport: {}", ledgerReport);
            }
            String consumerCode = ledgerReport.getDemand().getConnectionNo();
            log.info("consumer code is " + consumerCode);
            List<Payment> payments = addPaymentDetails(consumerCode);
            boolean paymentMatched = false;
            if(payments!=null)
            {
                BigDecimal totalPaymentInMonth=BigDecimal.ZERO;
                BigDecimal totalBalanceLeftInMonth=BigDecimal.ZERO;
                for (Payment payment : payments) {
                    Long transactionDateLong = payment.getTransactionDate();
                    LocalDate transactionDate = Instant.ofEpochMilli(transactionDateLong).atZone(ZoneId.systemDefault()).toLocalDate();
                    String transactionMonthAndYear = transactionDate.format(DateTimeFormatter.ofPattern("MMMM yyyy"));
                    if (ledgerReport.getDemand().getDemandGenerationDate().compareTo(transactionDateLong)<0 ) {
                        PaymentLedgerReport paymentLedgerReport = new PaymentLedgerReport();
                        paymentLedgerReport.setCollectionDate(transactionDateLong);
                        paymentLedgerReport.setReceiptNo(payment.getPaymentDetails().get(0).getReceiptNumber());
                        paymentLedgerReport.setPaid(payment.getTotalAmountPaid());
                        paymentLedgerReport.setBalanceLeft(payment.getTotalDue().subtract(paymentLedgerReport.getPaid()));
                        totalPaymentInMonth=totalPaymentInMonth.add(payment.getTotalAmountPaid());
                        totalBalanceLeftInMonth=totalBalanceLeftInMonth.add(payment.getTotalDue());
                        if (ledgerReport.getPayment() == null) {
                            ledgerReport.setPayment(new ArrayList<>());
                        }
                        ledgerReport.getPayment().add(paymentLedgerReport);
                        paymentMatched = true;
                    }
                }
                ledgerReport.setTotalBalanceLeftInMonth(totalBalanceLeftInMonth);
                ledgerReport.setTotalPaymentInMonth(totalPaymentInMonth);
            }
            if (!paymentMatched) {
                PaymentLedgerReport defaultPaymentLedgerReport = new PaymentLedgerReport();
                defaultPaymentLedgerReport.setCollectionDate(null);
                defaultPaymentLedgerReport.setReceiptNo("N/A");
                defaultPaymentLedgerReport.setPaid(BigDecimal.ZERO);
                defaultPaymentLedgerReport.setBalanceLeft(ledgerReport.getDemand().getTotal_due_amount());

                if (ledgerReport.getPayment() == null) {
                    ledgerReport.setPayment(new ArrayList<>());
                }
                ledgerReport.getPayment().add(defaultPaymentLedgerReport);
                ledgerReport.setTotalBalanceLeftInMonth(BigDecimal.ZERO);
                ledgerReport.setTotalPaymentInMonth(BigDecimal.ZERO);
            }
        }
    }


    private void addPaymentToLedgerChronlogicalOrder(List<Map<String, Object>> monthlyRecordList){
        LedgerReport lastValidDemandReport = null;
        monthlyRecordList.sort(new Comparator<Map<String, Object>>() {
            @Override
            public int compare(Map<String, Object> o1, Map<String, Object> o2) {
                String monthAndYear1 = (String) o1.keySet().iterator().next();
                String monthAndYear2 = (String) o2.keySet().iterator().next();

                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM yyyy", Locale.ENGLISH);
                YearMonth yearMonth1 = YearMonth.parse(monthAndYear1, formatter);
                YearMonth yearMonth2 = YearMonth.parse(monthAndYear2, formatter);

                return yearMonth1.compareTo(yearMonth2);
            }
        });

        for (int i = 0; i < monthlyRecordList.size(); i++) {
            Map<String, Object> record = monthlyRecordList.get(i);
            LedgerReport ledgerReport = (LedgerReport) record.values().iterator().next();

            // Skip months where demandGenerationDate is 0 (invalid demands)
            if (ledgerReport.getDemand() == null || ledgerReport.getDemand().getDemandGenerationDate() == 0) {
                log.info("Skipping LedgerReport for invalid demand in LedgerReport: {}", ledgerReport);
                PaymentLedgerReport defaultPaymentLedgerReport = new PaymentLedgerReport();
                defaultPaymentLedgerReport.setCollectionDate(null);
                defaultPaymentLedgerReport.setReceiptNo("N/A");
                defaultPaymentLedgerReport.setPaid(BigDecimal.ZERO);
                defaultPaymentLedgerReport.setBalanceLeft(ledgerReport.getDemand().getTotal_due_amount());

                if (ledgerReport.getPayment() == null) {
                    ledgerReport.setPayment(new ArrayList<>());
                }
                ledgerReport.getPayment().add(defaultPaymentLedgerReport);
                ledgerReport.setTotalBalanceLeftInMonth(BigDecimal.ZERO);
                ledgerReport.setTotalPaymentInMonth(BigDecimal.ZERO);
                continue;
            }

            String consumerCode = ledgerReport.getDemand().getConnectionNo();
            log.info("Processing LedgerReport for Consumer code: " + consumerCode);
            List<Payment> payments = addPaymentDetails(consumerCode);
            boolean paymentMatched = false;
            log.info("Payment:"+payments);
            if (payments != null && !payments.isEmpty()) {
                BigDecimal totalPaymentInMonth = BigDecimal.ZERO;
                BigDecimal totalBalanceLeftInMonth = BigDecimal.ZERO;

                // Get current demand's generation date
                Long currentDemandDate = ledgerReport.getDemand().getDemandGenerationDate();

                for (Payment payment : payments) {
                    Long transactionDateLong = payment.getTransactionDate();
                    Long nextMonthDemGenDateLong =getDemandGenerationDateOfNextMonth(monthlyRecordList, i);
                    log.info("nextMonthDemGenDateLong:"+nextMonthDemGenDateLong);
                    // Check if the payment date falls on or after the current demand's generation date
                    if (transactionDateLong >= currentDemandDate &&
                            (i + 1 == monthlyRecordList.size() || transactionDateLong < nextMonthDemGenDateLong )) {
                        LocalDate transactionDate = Instant.ofEpochMilli(transactionDateLong)
                                .atZone(ZoneId.systemDefault())
                                .toLocalDate();
                        log.info("settinng payment for month:"+ledgerReport.getDemand());
                        PaymentLedgerReport paymentLedgerReport = new PaymentLedgerReport();
                        paymentLedgerReport.setCollectionDate(transactionDateLong);
                        paymentLedgerReport.setReceiptNo(payment.getPaymentDetails().get(0).getReceiptNumber());
                        paymentLedgerReport.setPaid(payment.getTotalAmountPaid());
                        paymentLedgerReport.setBalanceLeft(payment.getTotalDue().subtract(paymentLedgerReport.getPaid()));

                        totalPaymentInMonth = totalPaymentInMonth.add(payment.getTotalAmountPaid());
                        totalBalanceLeftInMonth = totalBalanceLeftInMonth.add(payment.getTotalDue().subtract(payment.getTotalAmountPaid()));

                        if (ledgerReport.getPayment() == null) {
                            ledgerReport.setPayment(new ArrayList<>());
                        }
                        log.info("Payment for month:"+paymentLedgerReport);
                        ledgerReport.getPayment().add(paymentLedgerReport);
                        paymentMatched = true;
                    }
                }

                ledgerReport.setTotalBalanceLeftInMonth(ledgerReport.getDemand().getTotal_due_amount().subtract(totalPaymentInMonth));
                ledgerReport.setTotalPaymentInMonth(totalPaymentInMonth);
            }
            // Keep track of the last valid demand (non-zero demandGenerationDate)
            if (ledgerReport.getDemand().getDemandGenerationDate() != 0) {
                log.info("Last Valid Demand monnth:"+ledgerReport.getDemand());
                lastValidDemandReport = ledgerReport;
            }
            if (!paymentMatched ) {
                // Add a default PaymentLedgerReport if no payments matched
                log.info("If not matched:"+ledgerReport.getDemand().getMonthAndYear());
                PaymentLedgerReport defaultPaymentLedgerReport = new PaymentLedgerReport();
                defaultPaymentLedgerReport.setCollectionDate(null);
                defaultPaymentLedgerReport.setReceiptNo("N/A");
                defaultPaymentLedgerReport.setPaid(BigDecimal.ZERO);
                defaultPaymentLedgerReport.setBalanceLeft(ledgerReport.getDemand().getTotal_due_amount());

                if (ledgerReport.getPayment() == null) {
                    ledgerReport.setPayment(new ArrayList<>());
                }
                ledgerReport.getPayment().add(defaultPaymentLedgerReport);
            }


        }

        // Handle payments for months with no valid demands
        if (lastValidDemandReport != null) {
            log.info("Last month logic:"+lastValidDemandReport);
            // Assign payments to the last valid demand if found
            List<Payment> payments = addPaymentDetails(lastValidDemandReport.getDemand().getConnectionNo());
            BigDecimal totalPaymentInMonthlastValidMonth = BigDecimal.ZERO;
            BigDecimal totalBalanceLeftInMonthLatValidMonth=BigDecimal.ZERO;
            lastValidDemandReport.getPayment().clear();
            boolean ifLastDemandHavePayments= false;

            if (payments != null && !payments.isEmpty()) {

                for (Payment payment : payments) {
                    Long transactionDateLong = payment.getTransactionDate();
                    if (transactionDateLong >= lastValidDemandReport.getDemand().getDemandGenerationDate()) {
                        PaymentLedgerReport paymentLedgerReport = new PaymentLedgerReport();
                        paymentLedgerReport.setCollectionDate(transactionDateLong);
                        paymentLedgerReport.setReceiptNo(payment.getPaymentDetails().get(0).getReceiptNumber());
                        paymentLedgerReport.setPaid(payment.getTotalAmountPaid());
                        paymentLedgerReport.setBalanceLeft(payment.getTotalDue().subtract(paymentLedgerReport.getPaid()));

                        lastValidDemandReport.getPayment().add(paymentLedgerReport);
                        totalPaymentInMonthlastValidMonth = totalPaymentInMonthlastValidMonth.add(payment.getTotalAmountPaid());
                        totalBalanceLeftInMonthLatValidMonth = totalBalanceLeftInMonthLatValidMonth.add(payment.getTotalDue().subtract(payment.getTotalAmountPaid()));
                        ifLastDemandHavePayments=true;
                    }
                }
                lastValidDemandReport.setTotalBalanceLeftInMonth(lastValidDemandReport.getDemand().getTotal_due_amount().subtract(totalPaymentInMonthlastValidMonth));
                lastValidDemandReport.setTotalPaymentInMonth(totalPaymentInMonthlastValidMonth);

            }
            if(!ifLastDemandHavePayments){
                // Add a default PaymentLedgerReport if no payments matched
                log.info("If not matched:"+lastValidDemandReport.getDemand().getMonthAndYear());
                PaymentLedgerReport defaultPaymentLedgerReport = new PaymentLedgerReport();
                defaultPaymentLedgerReport.setCollectionDate(null);
                defaultPaymentLedgerReport.setReceiptNo("N/A");
                defaultPaymentLedgerReport.setPaid(BigDecimal.ZERO);
                defaultPaymentLedgerReport.setBalanceLeft(lastValidDemandReport.getDemand().getTotal_due_amount());

                if (lastValidDemandReport.getPayment() == null) {
                    lastValidDemandReport.setPayment(new ArrayList<>());
                }
                lastValidDemandReport.getPayment().add(defaultPaymentLedgerReport);
            }
        }
    }

    /**
     * This method retrieves the demand generation date for the next month in the ledger report.
     * If the next month is beyond the list size, it returns 0 to indicate no demand for a future month.
     *
     * @param monthlyRecordList The list of monthly ledger records.
     * @param currentIndex The index of the current month.
     * @return The demand generation date of the next month or 0 if there is no next month.
     */
    private Long getDemandGenerationDateOfNextMonth(List<Map<String, Object>> monthlyRecordList, int currentIndex) {
        // Check if there is a next month in the list
        if (currentIndex + 1 < monthlyRecordList.size()) {
            // Get the next month's record
            Map<String, Object> nextMonthRecord = monthlyRecordList.get(currentIndex + 1);

            // Extract the LedgerReport object for the next month
            LedgerReport nextMonthLedgerReport = (LedgerReport) nextMonthRecord.values().iterator().next();

            // Return the demand generation date of the next month
            if (nextMonthLedgerReport != null && nextMonthLedgerReport.getDemand() != null) {
                return nextMonthLedgerReport.getDemand().getDemandGenerationDate();
            }
        }
        // Return 0 if there is no next month or no valid demand for the next month
        return 0L;
    }


    private BigDecimal getMonthlyTaxAmount(Long startDate, String consumerCode,boolean paymentExists) {
        StringBuilder taxAmountQuery = new StringBuilder(wsQueryBuilder.TAX_AMOUNT_QUERY);
        if (paymentExists) {
            // Exclude WS_ADVANCE_CARRYFORWARD if payments exist
            taxAmountQuery.append(" AND taxheadcode != 'WS_ADVANCE_CARRYFORWARD'");
        }
        List<Object> taxAmountParams = new ArrayList<>();
        taxAmountParams.add(consumerCode);
        taxAmountParams.add(startDate);
        BigDecimal ans = jdbcTemplate.queryForObject(taxAmountQuery.toString(), taxAmountParams.toArray(), BigDecimal.class);
        if (ans != null)
            return ans;
        return BigDecimal.ZERO;
    }

    private BigDecimal getMonthlyTotalAmountPaid(Long startDate, String consumerCode) {
        StringBuilder totalAmountPaidQuery = new StringBuilder(wsQueryBuilder.TOTAL_AMOUNT_PAID_QUERY);
        List<Object> totalAmountPaidParams = new ArrayList<>();
        totalAmountPaidParams.add(consumerCode);
        totalAmountPaidParams.add(startDate);
        BigDecimal ans = jdbcTemplate.queryForObject(totalAmountPaidQuery.toString(), totalAmountPaidParams.toArray(), BigDecimal.class);
        if (ans != null)
            return ans;
        return BigDecimal.ZERO;
    }
}
