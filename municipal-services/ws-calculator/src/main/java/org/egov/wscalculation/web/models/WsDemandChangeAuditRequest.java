package org.egov.wscalculation.web.models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.Map;

import static org.apache.commons.lang3.StringUtils.isNotEmpty;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class WsDemandChangeAuditRequest {
    private Long id;
    private String consumercode;
    private String tenant_id;
    private String status;
    private String action;
    private Map<String,Object> data;
    private String createdby;
    private Long createdtime;
    public boolean isValid() {

        return isNotEmpty(consumercode);
    }
}
