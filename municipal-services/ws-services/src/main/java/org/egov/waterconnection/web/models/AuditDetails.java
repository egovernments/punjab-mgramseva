package org.egov.waterconnection.web.models;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.util.Date;

/**
 * Collection of audit related fields used by most models
 */

@ToString
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuditDetails {

	@JsonProperty("createdBy")
	private String createdBy;

	@JsonProperty("lastModifiedBy")
	private String lastModifiedBy;

	@JsonProperty("createdTime")
	private Long createdTime;

	@JsonProperty("createdDate")
	private Date createdDate;

	@JsonProperty("lastModifiedTime")
	private Long lastModifiedTime;

	@JsonProperty("lastModifiedDate")
	private Date lastModifiedDate;

}
