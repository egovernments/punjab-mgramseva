package org.egov.waterconnection.web.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import java.util.List;
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Builder
public class WaterConnectionByDemandGenerationDateResponse {

    @JsonProperty("WaterConnections")
    List<WaterConnectionByDemandGenerationDate> waterConnectionByDemandGenerationDates;
}
