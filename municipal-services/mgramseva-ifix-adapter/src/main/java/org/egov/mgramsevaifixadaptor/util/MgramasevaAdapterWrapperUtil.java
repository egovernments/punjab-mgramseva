package org.egov.mgramsevaifixadaptor.util;

import java.util.ArrayList;
import java.util.List;

import org.egov.common.contract.request.RequestInfo;
import org.egov.mgramsevaifixadaptor.config.PropertyConfiguration;
import org.egov.mgramsevaifixadaptor.models.Event;
import org.egov.mgramsevaifixadaptor.models.EventRequest;
import org.egov.mgramsevaifixadaptor.models.EventTypeEnum;
import org.egov.mgramsevaifixadaptor.repository.ServiceRequestRepository;
import org.egov.tracer.model.CustomException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import com.jayway.jsonpath.JsonPath;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class MgramasevaAdapterWrapperUtil {

	@Autowired
	ServiceRequestRepository serviceRequestRepository;

	@Autowired
	PropertyConfiguration propertyConfiguration;
	
	@Autowired
    MDMSUtils mdmsUtil;
	
	public void callIFIXAdapter(Object entity, String event, String tenantId,RequestInfo requestInfo) {

		EventRequest eventRequest = new EventRequest();
		Event eventObj = new Event();
		switch (event) {
		case "DEMAND": {
			eventObj.setEventType(EventTypeEnum.DEMAND);
			break;
		}
		case "BILL": {
			eventObj.setEventType(EventTypeEnum.BILL);
			break;

		}

		case "RECEIPT": {
			eventObj.setEventType(EventTypeEnum.BILL);
			break;

		}

		default:
			break;
		}

		List<Object> entityObjects = new ArrayList<Object>();
		entityObjects.add(entity);
		eventObj.setEntity(entityObjects);
		eventObj.setTenantId(tenantId);
		String projectId=getProjectId(tenantId,requestInfo);
		eventObj.setProjectId(projectId);
		try {
		serviceRequestRepository.fetchResult(
				propertyConfiguration.getAdapterHost() + propertyConfiguration.getAdapterCreateEndpoint(),
				eventRequest);
		
		}catch (Exception e) {
			log.error("error while pushing data to ifix adapter",e.getMessage());
		}

	}
	
	public String getProjectId(String tenantId,RequestInfo requestInfo) {
	Object result=	mdmsUtil.mDMSCall(requestInfo, tenantId);
	String res = null;
	try {
		res = JsonPath.read(result, Constants.PROJECT_JSON_PATH);
	} catch (Exception e) {
		throw new CustomException("JSONPATH_ERROR", "Failed to parse mdms response for project");
	}

	return res;
	}

}
