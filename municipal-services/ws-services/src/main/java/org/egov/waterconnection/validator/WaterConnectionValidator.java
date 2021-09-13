package org.egov.waterconnection.validator;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.egov.tracer.model.CustomException;
import org.egov.waterconnection.config.WSConfiguration;
import org.egov.waterconnection.constants.WCConstants;
import org.egov.waterconnection.repository.ServiceRequestRepository;
import org.egov.waterconnection.service.MeterInfoValidator;
import org.egov.waterconnection.service.PropertyValidator;
import org.egov.waterconnection.service.WaterFieldValidator;
import org.egov.waterconnection.web.models.CalculationRes;
import org.egov.waterconnection.web.models.Demand;
import org.egov.waterconnection.web.models.DemandDetail;
import org.egov.waterconnection.web.models.DemandResponse;
import org.egov.waterconnection.web.models.RequestInfoWrapper;
import org.egov.waterconnection.web.models.ValidatorResult;
import org.egov.waterconnection.web.models.WaterConnection;
import org.egov.waterconnection.web.models.WaterConnectionRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;


@Component
@Slf4j
public class WaterConnectionValidator {

	@Autowired
	private PropertyValidator propertyValidator;
	
	@Autowired
	private WaterFieldValidator waterFieldValidator;
	
	@Autowired
	private MeterInfoValidator meterInfoValidator;

	@Autowired
	private ServiceRequestRepository serviceRequestRepository;
	
	@Autowired
	private WSConfiguration config;

	@Autowired
	private ObjectMapper mapper;

	/**Used strategy pattern for avoiding multiple if else condition
	 * 
	 * @param waterConnectionRequest
	 * @param reqType
	 */
	public void validateWaterConnection(WaterConnectionRequest waterConnectionRequest, int reqType) {
		Map<String, String> errorMap = new HashMap<>();
		if (StringUtils.isEmpty(waterConnectionRequest.getWaterConnection().getProcessInstance())
				|| StringUtils.isEmpty(waterConnectionRequest.getWaterConnection().getProcessInstance().getAction())) {
			errorMap.put("INVALID_WF_ACTION", "Workflow obj can not be null or action can not be empty!!");
			throw new CustomException(errorMap);
		}
		ValidatorResult isPropertyValidated = propertyValidator.validate(waterConnectionRequest, reqType);
		if (!isPropertyValidated.isStatus())
			errorMap.putAll(isPropertyValidated.getErrorMessage());
		// GPWSC system does not this functionality
//		ValidatorResult isWaterFieldValidated = waterFieldValidator.validate(waterConnectionRequest, reqType);
//		if (!isWaterFieldValidated.isStatus())
//			errorMap.putAll(isWaterFieldValidated.getErrorMessage());
		Long previousMetereReading =waterConnectionRequest.getWaterConnection().getPreviousReadingDate() ;
		if(previousMetereReading == null || previousMetereReading <=0) {
			errorMap.put("PREVIOUS_METER_READIN_INVALID","Previous Meter reading date cannot be null");
		}
		ValidatorResult isMeterInfoValidated = meterInfoValidator.validate(waterConnectionRequest, reqType);
		if (!isMeterInfoValidated.isStatus())
			errorMap.putAll(isMeterInfoValidated.getErrorMessage());
		if(waterConnectionRequest.getWaterConnection().getProcessInstance().getAction().equalsIgnoreCase("PAY"))
			errorMap.put("INVALID_ACTION","Pay action cannot be perform directly");

		if (!errorMap.isEmpty())
			throw new CustomException(errorMap);
	}
	
	public void validatePropertyForConnection(List<WaterConnection> waterConnectionList) {
		waterConnectionList.forEach(waterConnection -> {
			if (StringUtils.isEmpty(waterConnection.getId())) {
				StringBuilder builder = new StringBuilder();
				builder.append("PROPERTY UUID NOT FOUND FOR ")
						.append(waterConnection.getConnectionNo() == null ? waterConnection.getApplicationNo()
								: waterConnection.getConnectionNo());
				log.error(builder.toString());
			}
		});
	}
	
	/**
	 * Validate for previous data to current data
	 * 
	 * @param request water connection request
	 * @param searchResult water connection search result
	 */
	public void validateUpdate(WaterConnectionRequest request, WaterConnection searchResult, int reqType) {
		validateAllIds(request.getWaterConnection(), searchResult);
		validateDuplicateDocuments(request);
		setFieldsFromSearch(request, searchResult, reqType);
		validateUpdateForDemand(request,searchResult);
		
	}
/**
 * GPWSC specific validation
 * @param request
 * @param searchResult
 */
	private void validateUpdateForDemand(WaterConnectionRequest request, WaterConnection searchResult) {
		Map<String, String> errorMap = new HashMap<>();
		StringBuilder url = new StringBuilder();
		url.append(config.getBillingHost()).append(config.getDemandSearchUri());
		url.append("?consumerCode=").append(request.getWaterConnection().getConnectionNo());
		url.append("&tenantId=").append(request.getWaterConnection().getTenantId());
		url.append("&businessService=WS");
		DemandResponse demandResponse = null;
		try {
			Object response = serviceRequestRepository.fetchResult(url, RequestInfoWrapper.builder().requestInfo(request.getRequestInfo()).build());
			 demandResponse = mapper.convertValue(response, DemandResponse.class);
			
		} catch (Exception ex) {
			log.error("Calculation response error!!", ex);
			throw new CustomException("WATER_CALCULATION_EXCEPTION", "Calculation response can not parsed!!!");
		}
		
		if( demandResponse!= null && demandResponse.getDemands().size() >0 ) {
			List<Demand> demands = demandResponse.getDemands().stream().filter( d-> !d.getConsumerType().equalsIgnoreCase("waterConnection-arrears")).collect(Collectors.toList());
			List<Demand> arrearDemands = demandResponse.getDemands().stream().filter( d-> d.getConsumerType().equalsIgnoreCase("waterConnection-arrears")).collect(Collectors.toList());
			List<DemandDetail> collect = arrearDemands.get(0).getDemandDetails().stream().filter( d-> d.getCollectionAmount().intValue()>0).collect(Collectors.toList());
			if(demands.size() > 0 || collect.size() >0 ) {
				if(!searchResult.getOldConnectionNo().equalsIgnoreCase(request.getWaterConnection().getOldConnectionNo())) {
					errorMap.put("INVALID_UPDATE_OLD_CONNO", "Old ConnectionNo cannot be modified!!");
				}
				if(searchResult.getPreviousReadingDate() != request.getWaterConnection().getPreviousReadingDate()) {
					errorMap.put("INVALID_UPDATE_PRVMETERREADING", "Previous Meter Reading Date cannot be modified cannot be modified!!");
				}
				if(searchResult.getArrears() != request.getWaterConnection().getArrears()) {
					errorMap.put("INVALID_UPDATE_ARREARS", "Arrears cannot be modified cannot be modified!!");
				}
			}
		}
	}
   
	/**
	 * Validates if all ids are same as obtained from search result
	 * 
	 * @param updateWaterConnection The water connection request from update request 
	 * @param searchResult The water connection from search result
	 */
	private void validateAllIds(WaterConnection updateWaterConnection, WaterConnection searchResult) {
		Map<String, String> errorMap = new HashMap<>();
		if (!searchResult.getApplicationNo().equals(updateWaterConnection.getApplicationNo()))
			errorMap.put("CONNECTION_NOT_FOUND", "The application number from search: " + searchResult.getApplicationNo()
					+ " and from update: " + updateWaterConnection.getApplicationNo() + " does not match");
		if (!CollectionUtils.isEmpty(errorMap))
			throw new CustomException(errorMap);
	}
    
    /**
     * Validates application documents for duplicates
     * 
     * @param request The waterConnection Request
     */
	private void validateDuplicateDocuments(WaterConnectionRequest request) {
		if (request.getWaterConnection().getDocuments() != null) {
			List<String> documentFileStoreIds = new LinkedList<>();
			request.getWaterConnection().getDocuments().forEach(document -> {
				if (documentFileStoreIds.contains(document.getFileStoreId()))
					throw new CustomException("DUPLICATE_DOCUMENT_ERROR",
							"Same document cannot be used multiple times");
				else
					documentFileStoreIds.add(document.getFileStoreId());
			});
		}
	}
	/**
	 * Enrich Immutable fields
	 * 
	 * @param request Water connection request
	 * @param searchResult water connection search result
	 */
	private void setFieldsFromSearch(WaterConnectionRequest request, WaterConnection searchResult, int reqType) {
		if (reqType == WCConstants.UPDATE_APPLICATION) {
			request.getWaterConnection().setConnectionNo(searchResult.getConnectionNo());
		}
	}
}
