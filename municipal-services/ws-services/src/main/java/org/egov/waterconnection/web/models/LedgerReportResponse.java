package org.egov.waterconnection.web.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import org.egov.common.contract.response.ResponseInfo;

import java.util.List;

@Builder
public class LedgerReportResponse
{
    @JsonProperty("ledgerReport")
    private List<LedgerReport> ledgerReport;

    @JsonProperty("tenantName")
    private String tenantName;

    @JsonProperty("financialYear")
    private String financialYear;

    @JsonProperty("responseInfo")
    private ResponseInfo responseInfo = null;
}
