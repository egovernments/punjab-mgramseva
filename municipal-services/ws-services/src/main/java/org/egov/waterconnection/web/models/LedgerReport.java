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
    private DemandLedgerReport demand=null;

    @JsonProperty("payment")
    private PaymentLedgerReport payment=new PaymentLedgerReport();
}
