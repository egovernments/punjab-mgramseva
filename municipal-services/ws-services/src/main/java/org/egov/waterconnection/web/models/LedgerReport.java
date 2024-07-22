package org.egov.waterconnection.web.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LedgerReport
{
    @JsonProperty("demand")
    private DemandLedgerReport demand=null;

    @JsonProperty("payment")
    private List<PaymentLedgerReport> payment=null;
}
