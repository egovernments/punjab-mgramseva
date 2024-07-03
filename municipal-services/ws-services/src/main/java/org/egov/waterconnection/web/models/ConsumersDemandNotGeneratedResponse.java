package org.egov.waterconnection.web.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import org.egov.common.contract.response.ResponseInfo;

import java.util.List;

@Builder
public class ConsumersDemandNotGeneratedResponse {
    @JsonProperty("responseInfo")
    private ResponseInfo responseInfo;

    @JsonProperty("ConsumersDemandNotGenerated")
    private List<ConsumersDemandNotGenerated> consumersDemandNotGenerated;
}
