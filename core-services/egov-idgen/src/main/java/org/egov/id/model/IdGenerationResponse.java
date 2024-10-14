package org.egov.id.model;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * <h1>IdGenerationResponse</h1>
 * 
 * @author Narendra
 *
 */
@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class IdGenerationResponse {

	@JsonProperty("ResponseInfo")
	private ResponseInfo responseInfo;

	private List<IdResponse> idResponses;

}
