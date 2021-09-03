package org.egov.waterconnection.service;

import java.util.List;

import org.egov.common.contract.request.RequestInfo;
import org.egov.waterconnection.web.models.Feedback;
import org.egov.waterconnection.web.models.FeedbackRequest;
import org.egov.waterconnection.web.models.FeedbackSearchCriteria;
import org.egov.waterconnection.web.models.SearchCriteria;
import org.egov.waterconnection.web.models.WaterConnection;
import org.egov.waterconnection.web.models.WaterConnectionRequest;
import org.egov.waterconnection.web.models.WaterConnectionResponse;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;

public interface WaterService {

	List<WaterConnection> createWaterConnection(WaterConnectionRequest waterConnectionRequest);

	WaterConnectionResponse search(SearchCriteria criteria, RequestInfo requestInfo);
	
	List<WaterConnection> updateWaterConnection(WaterConnectionRequest waterConnectionRequest);
	
	void submitFeedback( FeedbackRequest feedbackrequest);

	Object getFeedback( FeedbackSearchCriteria feedBackSearchCriteria) throws JsonMappingException, JsonProcessingException;

}
