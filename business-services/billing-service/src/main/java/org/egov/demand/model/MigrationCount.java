package org.egov.demand.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;
import org.springframework.validation.annotation.Validated;

import javax.validation.constraints.Size;

/**
 * Address
 */
@Validated
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MigrationCount   {

    @Size(max=64)
    @JsonProperty("id")
    private String id;

    @JsonProperty("offset")
    private Long offset;

    @JsonProperty("limit")
    private Long limit;

    @JsonProperty("createdTime")
    private Long createdTime;

    @JsonProperty("tenantid")
    private String tenantid;

    @JsonProperty("recordCount")
    private Long recordCount;

    @JsonProperty("businessService")
    private String businessService;

    @JsonProperty("message")
    private String message;

    @JsonProperty("auditTopic")
    private String auditTopic;

    @JsonProperty("auditTime")
    private Long auditTime;
}