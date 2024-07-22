package org.egov.waterconnection.web.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DemandLedgerReport {

    @JsonProperty("consumerName")
    private String consumerName = null;

    @JsonProperty("connectionNo")
    private String connectionNo = null;

    @JsonProperty("oldConnectionNo")
    private String oldConnectionNo = null;

    @JsonProperty("userId")
    private String userId = null;

    @JsonProperty("month")
    private String monthAndYear;

    @JsonProperty("demandGenerationDate")
    private Long demandGenerationDate;

    @JsonProperty("code")
    private String code = null;

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
    private Long dueDate;

    @JsonProperty("penaltyAppliedOnDate")
    private Long penaltyAppliedDate;

    public DemandLedgerReport(String monthAndYear) {
        this.monthAndYear = monthAndYear;
        this.taxamount = BigDecimal.ZERO;
        this.penalty = BigDecimal.ZERO;
        this.totalForCurrentMonth = BigDecimal.ZERO;
        this.arrears = BigDecimal.ZERO;
        this.total_due_amount = BigDecimal.ZERO;
    }
}
