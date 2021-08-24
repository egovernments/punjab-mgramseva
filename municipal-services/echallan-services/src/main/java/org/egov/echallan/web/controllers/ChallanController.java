package org.egov.echallan.web.controllers;

import java.util.Arrays;
import java.util.List;

import javax.validation.Valid;

import org.egov.common.contract.response.ResponseInfo;
import org.egov.echallan.model.Challan;
import org.egov.echallan.model.ChallanRequest;
import org.egov.echallan.model.ChallanResponse;
import org.egov.echallan.model.RequestInfoWrapper;
import org.egov.echallan.model.SearchCriteria;
import org.egov.echallan.repository.rowmapper.ChallanRowMapper;
import org.egov.echallan.service.ChallanService;
import org.egov.echallan.service.SchedulerService;
import org.egov.echallan.util.ResponseInfoFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("eChallan/v1")
public class ChallanController {

	@Autowired
	private ChallanService challanService;

	@Autowired
	private ResponseInfoFactory responseInfoFactory;
	
	@Autowired
	private SchedulerService schedulerService;
	
	@Autowired
	private ChallanRowMapper mapper;

	@PostMapping("/_create")
	public ResponseEntity<ChallanResponse> create(@Valid @RequestBody ChallanRequest challanRequest) {

		Challan challan = challanService.create(challanRequest);
		ResponseInfo resInfo = responseInfoFactory.createResponseInfoFromRequestInfo(challanRequest.getRequestInfo(), true);
		ChallanResponse response = ChallanResponse.builder().challans(Arrays.asList(challan))
				.responseInfo(resInfo)
				.build();
		return new ResponseEntity<>(response, HttpStatus.OK);
	}
	
	 @RequestMapping(value = "/_search", method = RequestMethod.POST)
	 public ResponseEntity<ChallanResponse> search(@Valid @RequestBody RequestInfoWrapper requestInfoWrapper,
	                                                       @Valid @ModelAttribute SearchCriteria criteria) {
	     List<Challan> challans = challanService.search(criteria, requestInfoWrapper.getRequestInfo());

	     ChallanResponse response = ChallanResponse.builder().challans(challans).totalCount(mapper.getFull_count()).responseInfo(
	               responseInfoFactory.createResponseInfoFromRequestInfo(requestInfoWrapper.getRequestInfo(), true))
	              .build();
	     return new ResponseEntity<>(response, HttpStatus.OK);
	}

	 @PostMapping("/_update")
	 public ResponseEntity<ChallanResponse> update(@Valid @RequestBody ChallanRequest challanRequest) {
		Challan challan = challanService.update(challanRequest);
		ResponseInfo resInfo = responseInfoFactory.createResponseInfoFromRequestInfo(challanRequest.getRequestInfo(), true);
		ChallanResponse response = ChallanResponse.builder().challans(Arrays.asList(challan))
				.responseInfo(resInfo)
				.build();
		return new ResponseEntity<>(response, HttpStatus.OK);
		}

	@PostMapping("/_schedulerpendingcollection")
	public void schedulerpendingcollection(@Valid @RequestBody RequestInfoWrapper requestInfoWrapper) {
		schedulerService.sendPendingCollectionEvent(requestInfoWrapper.getRequestInfo());
	}

	@PostMapping("/_schedulermonthsummary")
	public void schedulermonthsummary(@Valid @RequestBody RequestInfoWrapper requestInfoWrapper) {
		schedulerService.sendMonthSummaryEvent(requestInfoWrapper.getRequestInfo());
	}

	@PostMapping("/_schedulernewexpenditure")
	public void schedulernewexpenditure(@Valid @RequestBody RequestInfoWrapper requestInfoWrapper) {
		schedulerService.sendNewExpenditureEvent(requestInfoWrapper.getRequestInfo());
	}

	@PostMapping("/_schedulermarkexpensebill")
	public void schedulermarkexpensebill(@Valid @RequestBody RequestInfoWrapper requestInfoWrapper) {
		schedulerService.sendMarkExpensebillEvent(requestInfoWrapper.getRequestInfo());
	}

	@PostMapping("/_schedulergeneratedemand")
	public void schedulergeneratedemand(@Valid @RequestBody RequestInfoWrapper requestInfoWrapper) {
		schedulerService.sendGenerateDemandEvent(requestInfoWrapper.getRequestInfo());
	}
	
	@PostMapping("/_schedulerTodaysCollection")
	public void schedulerTodaysCollection(@Valid @RequestBody RequestInfoWrapper requestInfoWrapper) {
		schedulerService.sendTodaysCollection(requestInfoWrapper.getRequestInfo());
	}
	 
	

}
