package org.egov.waterconnection.web.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LedgerReport
{
    @JsonProperty("demand")
    private DemandLedgerReport demand=new DemandLedgerReport();

    @JsonProperty("payment")
    private PaymentLedgerReport payment=new PaymentLedgerReport();
}
