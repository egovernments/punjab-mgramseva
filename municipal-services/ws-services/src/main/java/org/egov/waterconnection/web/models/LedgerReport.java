package org.egov.waterconnection.web.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LedgerReport
{
    @JsonProperty("month")
    private String monthAndYear;

    @JsonProperty("demandGenerationDate")
    private String demandGenerationDate;

    @JsonProperty("monthlyCharges")
    private BigDecimal taxamount;

    @JsonProperty("penalty")
    private BigDecimal penalty;

    @JsonProperty("totalForCurrentMonth")
    private BigDecimal totalForCurrentMonth;

    @JsonProperty("previousMonthBalance")
    private BigDecimal arrears;

    @JsonProperty("totalDues")
    private BigDecimal total_due_amount;

    @JsonProperty("dueDateOfPayment")
    private String dueDate;

    @JsonProperty("penaltyAppliedOnDate")
    private String penaltyAppliedDate;

    @JsonProperty("paymentCollectionDate")
    private String collectionDate;

    @JsonProperty("receiptNo")
    private String receiptNo;

    @JsonProperty("amountPaid")
    private BigDecimal paid;

    @JsonProperty("balanceLeft")
    private BigDecimal balanceLeft;

    public LedgerReport(String monthAndYear)
    {
        this.monthAndYear = monthAndYear;
        this.taxamount = BigDecimal.ZERO;
        this.penalty = BigDecimal.ZERO;
        this.totalForCurrentMonth = BigDecimal.ZERO;
        this.paid = BigDecimal.ZERO;
        this.balanceLeft = BigDecimal.ZERO;

    }
}
