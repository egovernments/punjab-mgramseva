package org.egov.wscalculation.web.models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AddPenaltyCriteria {
    private String limit;
    private String offset;
    private String tenantId;
    private List<String> tenantids;
}
