package org.egov.demand.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.egov.common.contract.request.RequestInfo;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateBillRequest {

	@NotNull
	private RequestInfo RequestInfo;
	
	@NotNull
	@Valid
	private UpdateBillCriteria UpdateBillCriteria;
}
