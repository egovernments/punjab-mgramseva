package org.egov.wscalculation.service;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.egov.common.contract.request.RequestInfo;
import org.egov.common.contract.request.User;
import org.egov.wscalculation.service.UserService;
import org.egov.wscalculation.web.models.users.UserDetailResponse;
import org.egov.tracer.model.CustomException;
import org.egov.wscalculation.config.WSCalculationConfiguration;
import org.egov.wscalculation.constants.WSCalculationConstant;
import org.egov.wscalculation.producer.WSCalculationProducer;
import org.egov.wscalculation.repository.DemandRepository;
import org.egov.wscalculation.repository.ServiceRequestRepository;
import org.egov.wscalculation.repository.WSCalculationDao;
import org.egov.wscalculation.util.CalculatorUtil;
import org.egov.wscalculation.util.NotificationUtil;
import org.egov.wscalculation.util.WSCalculationUtil;
import org.egov.wscalculation.validator.WSCalculationValidator;
import org.egov.wscalculation.validator.WSCalculationWorkflowValidator;
import org.egov.wscalculation.web.models.Action;
import org.egov.wscalculation.web.models.ActionItem;
import org.egov.wscalculation.web.models.BulkDemand;
import org.egov.wscalculation.web.models.Calculation;
import org.egov.wscalculation.web.models.CalculationCriteria;
import org.egov.wscalculation.web.models.CalculationReq;
import org.egov.wscalculation.web.models.Category;
import org.egov.wscalculation.web.models.Demand;
import org.egov.wscalculation.web.models.Demand.StatusEnum;
import org.egov.wscalculation.web.models.DemandDetail;
import org.egov.wscalculation.web.models.DemandDetailAndCollection;
import org.egov.wscalculation.web.models.DemandRequest;
import org.egov.wscalculation.web.models.DemandResponse;
import org.egov.wscalculation.web.models.Event;
import org.egov.wscalculation.web.models.EventRequest;
import org.egov.wscalculation.web.models.GetBillCriteria;
import org.egov.wscalculation.web.models.OwnerInfo;
import org.egov.wscalculation.web.models.Property;
import org.egov.wscalculation.web.models.Recipient;
import org.egov.wscalculation.web.models.RequestInfoWrapper;
import org.egov.wscalculation.web.models.SMSRequest;
import org.egov.wscalculation.web.models.Source;
import org.egov.wscalculation.web.models.TaxHeadEstimate;
import org.egov.wscalculation.web.models.TaxPeriod;
import org.egov.wscalculation.web.models.WaterConnection;
import org.egov.wscalculation.web.models.WaterConnectionRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jayway.jsonpath.JsonPath;

import lombok.extern.slf4j.Slf4j;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;

@Service
@Slf4j
public class DemandService {

	@Autowired
	private ServiceRequestRepository repository;

	@Autowired
	private ObjectMapper mapper;

	@Autowired
	private PayService payService;

	@Autowired
	private MasterDataService mstrDataService;

	@Autowired
	private WSCalculationUtil utils;

	@Autowired
	private WSCalculationConfiguration configs;

	@Autowired
	private ServiceRequestRepository serviceRequestRepository;

	@Autowired
	private DemandRepository demandRepository;
    
    @Autowired
    private WSCalculationDao waterCalculatorDao;
    
    @Autowired
    private CalculatorUtil calculatorUtils;
    
    @Autowired
    private EstimationService estimationService;
    
    @Autowired
    private WSCalculationProducer wsCalculationProducer;
    
    @Autowired
    private WSCalculationUtil wsCalculationUtil;

    @Autowired
	private WSCalculationWorkflowValidator wsCalulationWorkflowValidator;

	@Autowired
	private WSCalculationValidator wsCalculationValidator;
	
	@Autowired
	private NotificationUtil util;
	
	@Autowired
	private UserService userService;

	@Autowired
	private WSCalculationProducer producer;
	

	@Autowired
	private WSCalculationConfiguration config;
	

	@Autowired
	private RestTemplate restTemplate;

	/**
	 * Creates or updates Demand
	 * 
	 * @param requestInfo
	 *            The RequestInfo of the calculation request
	 * @param calculations
	 *            The Calculation Objects for which demand has to be generated
	 *            or updated
	 */
	public List<Demand> generateDemand(RequestInfo requestInfo, List<Calculation> calculations,
			Map<String, Object> masterMap, boolean isForConnectionNo) {
		@SuppressWarnings("unchecked")
		Map<String, Object> financialYearMaster =  (Map<String, Object>) masterMap
				.get(WSCalculationConstant.BILLING_PERIOD);
		Long fromDate = (Long) financialYearMaster.get(WSCalculationConstant.STARTING_DATE_APPLICABLES);
		Long toDate = (Long) financialYearMaster.get(WSCalculationConstant.ENDING_DATE_APPLICABLES);
		
		// List that will contain Calculation for new demands
				List<Calculation> createCalculations = new LinkedList<>();
		// List that will contain Calculation for old demands
		List<Calculation> updateCalculations = new LinkedList<>();
		if (!CollectionUtils.isEmpty(calculations)) {
			// Collect required parameters for demand search
			String tenantId = calculations.get(0).getTenantId();
			Long fromDateSearch = null;
			Long toDateSearch = null;
			Set<String> consumerCodes;
				fromDateSearch = fromDate;
				toDateSearch = toDate;
				consumerCodes = calculations.stream().map(calculation -> calculation.getConnectionNo())
						.collect(Collectors.toSet());

			
			List<Demand> demands = searchDemand(tenantId, consumerCodes, fromDateSearch, toDateSearch, requestInfo);
			Set<String> connectionNumbersFromDemands = new HashSet<>();
			if (!CollectionUtils.isEmpty(demands)) {
				connectionNumbersFromDemands = demands.stream().filter(demand ->demand.getConsumerType().equalsIgnoreCase(isForConnectionNo ? "waterConnection" : "waterConnection-arrears")).map(Demand::getConsumerCode)
						.collect(Collectors.toSet());
			}
				

			// If demand already exists add it updateCalculations else
			// createCalculations
			for (Calculation calculation : calculations) {
				if (!connectionNumbersFromDemands.contains( calculation.getConnectionNo() ))
					createCalculations.add(calculation);
				else
					updateCalculations.add(calculation);
			}
		}
		List<Demand> createdDemands = new ArrayList<>();
		if (!CollectionUtils.isEmpty(createCalculations))
			createdDemands = createDemand(requestInfo, createCalculations, masterMap, isForConnectionNo);

		if (!CollectionUtils.isEmpty(updateCalculations))
			createdDemands = updateDemandForCalculation(requestInfo, updateCalculations, fromDate, toDate, isForConnectionNo);
		return createdDemands;
	}
	
	/**
	 * 
	 * @param requestInfo RequestInfo
	 * @param calculations List of Calculation
	 * @param masterMap Master MDMS Data
	 * @return Returns list of demands
	 */
	private List<Demand> createDemand(RequestInfo requestInfo, List<Calculation> calculations,
			Map<String, Object> masterMap, boolean isForConnectionNO) {
		List<Demand> demands = new LinkedList<>();
		List<SMSRequest> smsRequests = new LinkedList<>();
		DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
		String billCycle="";
		String consumerCode = null;
		for (Calculation calculation : calculations) {
			WaterConnection connection = calculation.getWaterConnection();
			if (connection == null) {
				throw new CustomException("INVALID_WATER_CONNECTION", "Demand cannot be generated for "
						+ (isForConnectionNO ? calculation.getConnectionNo() : calculation.getApplicationNO())
						+ " Water Connection with this number does not exist ");
			}
			WaterConnectionRequest waterConnectionRequest = WaterConnectionRequest.builder().waterConnection(connection)
					.requestInfo(requestInfo).build();
			Property property = wsCalculationUtil.getProperty(waterConnectionRequest);
			String tenantId = calculation.getTenantId();
			consumerCode = calculation.getConnectionNo();
			User owner = property.getOwners().get(0).toCommonUser();
			if (!CollectionUtils.isEmpty(waterConnectionRequest.getWaterConnection().getConnectionHolders())) {
				owner = waterConnectionRequest.getWaterConnection().getConnectionHolders().get(0).toCommonUser();
			}
			List<DemandDetail> demandDetails = new LinkedList<>();
			calculation.getTaxHeadEstimates().forEach(taxHeadEstimate -> {
				demandDetails.add(DemandDetail.builder().taxAmount(taxHeadEstimate.getEstimateAmount())
						.taxHeadMasterCode(taxHeadEstimate.getTaxHeadCode()).collectionAmount(BigDecimal.ZERO)
						.tenantId(tenantId).build());
			});
			@SuppressWarnings("unchecked")
			Map<String, Object> financialYearMaster = (Map<String, Object>) masterMap
					.get(WSCalculationConstant.BILLING_PERIOD);

			Long fromDate = (Long) financialYearMaster.get(WSCalculationConstant.STARTING_DATE_APPLICABLES);
			Long toDate = (Long) financialYearMaster.get(WSCalculationConstant.ENDING_DATE_APPLICABLES);
			Long expiryDate = (Long) financialYearMaster.get(WSCalculationConstant.Demand_Expiry_Date_String);
			BigDecimal minimumPayableAmount =  configs.getMinimumPayableAmount();
			String businessService = configs.getBusinessService();

			addRoundOffTaxHead(calculation.getTenantId(), demandDetails);

			demands.add(Demand.builder().consumerCode(consumerCode).demandDetails(demandDetails).payer(owner)
					.minimumAmountPayable(minimumPayableAmount).tenantId(tenantId).taxPeriodFrom(fromDate)
					.taxPeriodTo(toDate).consumerType( isForConnectionNO ? "waterConnection" : "waterConnection-arrears").businessService(businessService)
					.status(StatusEnum.valueOf("ACTIVE")).billExpiryTime(expiryDate).build());

			HashMap<String, String> localizationMessage = util.getLocalizationMessage(requestInfo, WSCalculationConstant.mGram_Consumer_NewBill, tenantId);
			
			String actionLink = config.getNotificationUrl() + config.getBillDownloadSMSLink().replace("$mobile", owner.getMobileNumber())
					.replace("$consumerCode", waterConnectionRequest.getWaterConnection().getConnectionNo())
					.replace("$tenantId", property.getTenantId());
			
			if(waterConnectionRequest.getWaterConnection().getConnectionType().equalsIgnoreCase(WSCalculationConstant.meteredConnectionType)) {
				actionLink = actionLink.replace("$key", "ws-bill");
			}else {
				actionLink = actionLink.replace("$key", "ws-bill-nm");
			}
			
			String messageString = localizationMessage.get(WSCalculationConstant.MSG_KEY);

			System.out.println("Localization message::" + messageString);
			if (!StringUtils.isEmpty(messageString) && isForConnectionNO) {
				log.info("Demand Object" + demands.toString());

				List<String> billNumber = fetchBill(demands, requestInfo);
				log.info("Bill Number :: " + billNumber.toString());
				
				if(billNumber.size() > 0 ) {
					actionLink = actionLink.replace("$billNumber", billNumber.get(0));		
				}
				actionLink = actionLink.replace("$billNumber", billNumber.get(0));		
				billCycle = (Instant.ofEpochMilli(fromDate).atZone(ZoneId.systemDefault()).toLocalDate() + "-"
						+ Instant.ofEpochMilli(toDate).atZone(ZoneId.systemDefault()).toLocalDate());
				messageString = messageString.replace("{ownername}", owner.getName());
				messageString = messageString.replace("{Period}", billCycle);
				messageString = messageString.replace("{consumerno}", consumerCode);
				messageString = messageString.replace("{billamount}", demandDetails.stream()
						.map(DemandDetail::getTaxAmount).reduce(BigDecimal.ZERO, BigDecimal::add).toString());
				messageString = messageString.replace("{BILL_LINK}", getShortenedUrl(actionLink));

				System.out.println("Demand genaratio Message::" + messageString);

				SMSRequest sms = SMSRequest.builder().mobileNumber(owner.getMobileNumber()).message(messageString)
						.category(Category.TRANSACTION).build();
				producer.push(config.getSmsNotifTopic(), sms);

			}
		}
		log.info("Demand Object" + demands.toString());
		List<Demand> demandRes = demandRepository.saveDemand(requestInfo, demands);
				
		return demandRes;
	}

	private String getShortenedUrl(String url) {
		String res = null;
		HashMap<String,String> body = new HashMap<>();
		body.put("url",url);
		StringBuilder builder = new StringBuilder(config.getUrlShortnerHost());
		builder.append(config.getUrlShortnerEndpoint());
		try {
			res = restTemplate.postForObject(builder.toString(), body, String.class);

		}catch(Exception e) {
			 log.error("Error while shortening the url: " + url,e);
			
		}
		if(StringUtils.isEmpty(res)){
			log.error("URL_SHORTENING_ERROR","Unable to shorten url: "+url); ;
			return url;
		}
		else return res;
	}

	private void sendSMSNotification(RequestInfo requestInfo, List<SMSRequest> smsRequests, String billCycle, String consumerCode, List<DemandDetail> demandDetails) {
		UserDetailResponse userDetailResponse = userService.getUserByRoleCodes(requestInfo, Arrays.asList("GP_ADMIN"), "pb");
		for (OwnerInfo ownerInfo : userDetailResponse.getUser()) {
			String localizationMessage = util.getLocalizationMessages(ownerInfo.getTenantId(), requestInfo);
			String messageString = util.getMessageTemplate(
					WSCalculationConstant.mGram_Consumer_NewBill, localizationMessage);
			if (messageString != null && !StringUtils.isEmpty(messageString)) {
				messageString = messageString.replace("{BILL_LINK}", configs.getDownLoadBillLink());
				messageString = messageString.replace("{ULB_Name}", ownerInfo.getTenantId());
				messageString = messageString.replace("{ownername}", ownerInfo.getUserName());
				messageString = messageString.replace("{billingcycle}", billCycle);
				messageString = messageString.replace("{consumerno}", consumerCode);
				SMSRequest sms = SMSRequest.builder().mobileNumber(ownerInfo.getMobileNumber()).message(messageString)
						.category(Category.TRANSACTION).build();
				producer.push(config.getSmsNotifTopic(), sms);
			}
		}
	}

	/**
	 * Returns the list of new DemandDetail to be added for updating the demand
	 * 
	 * @param calculation
	 *            The calculation object for the update request
	 * @param demandDetails
	 *            The list of demandDetails from the existing demand
	 * @return The list of new DemandDetails
	 */
	private List<DemandDetail> getUpdatedDemandDetails(Calculation calculation, List<DemandDetail> demandDetails) {

		List<DemandDetail> newDemandDetails = new ArrayList<>();
		Map<String, List<DemandDetail>> taxHeadToDemandDetail = new HashMap<>();

		demandDetails.forEach(demandDetail -> {
			if (!taxHeadToDemandDetail.containsKey(demandDetail.getTaxHeadMasterCode())) {
				List<DemandDetail> demandDetailList = new LinkedList<>();
				demandDetailList.add(demandDetail);
				taxHeadToDemandDetail.put(demandDetail.getTaxHeadMasterCode(), demandDetailList);
			} else
				taxHeadToDemandDetail.get(demandDetail.getTaxHeadMasterCode()).add(demandDetail);
		});

		BigDecimal diffInTaxAmount;
		List<DemandDetail> demandDetailList;
		BigDecimal total;

		for (TaxHeadEstimate taxHeadEstimate : calculation.getTaxHeadEstimates()) {
			if (!taxHeadToDemandDetail.containsKey(taxHeadEstimate.getTaxHeadCode()))
				newDemandDetails.add(DemandDetail.builder().taxAmount(taxHeadEstimate.getEstimateAmount())
						.taxHeadMasterCode(taxHeadEstimate.getTaxHeadCode()).tenantId(calculation.getTenantId())
						.collectionAmount(BigDecimal.ZERO).build());
			else {
				demandDetailList = taxHeadToDemandDetail.get(taxHeadEstimate.getTaxHeadCode());
				total = demandDetailList.stream().map(DemandDetail::getTaxAmount).reduce(BigDecimal.ZERO,
						BigDecimal::add);
				diffInTaxAmount = taxHeadEstimate.getEstimateAmount().subtract(total);
				if (diffInTaxAmount.compareTo(BigDecimal.ZERO) != 0) {
					newDemandDetails.add(DemandDetail.builder().taxAmount(diffInTaxAmount)
							.taxHeadMasterCode(taxHeadEstimate.getTaxHeadCode()).tenantId(calculation.getTenantId())
							.collectionAmount(BigDecimal.ZERO).build());
				}
			}
		}
		List<DemandDetail> combinedBillDetails = new LinkedList<>(demandDetails);
		combinedBillDetails.addAll(newDemandDetails);
		addRoundOffTaxHead(calculation.getTenantId(), combinedBillDetails);
		return combinedBillDetails;
	}

	/**
	 * Adds roundOff taxHead if decimal values exists
	 * 
	 * @param tenantId
	 *            The tenantId of the demand
	 * @param demandDetails
	 *            The list of demandDetail
	 */
	private void addRoundOffTaxHead(String tenantId, List<DemandDetail> demandDetails) {
		BigDecimal totalTax = BigDecimal.ZERO;

		BigDecimal previousRoundOff = BigDecimal.ZERO;

		/*
		 * Sum all taxHeads except RoundOff as new roundOff will be calculated
		 */
		for (DemandDetail demandDetail : demandDetails) {
			if (!demandDetail.getTaxHeadMasterCode().equalsIgnoreCase(WSCalculationConstant.WS_Round_Off))
				totalTax = totalTax.add(demandDetail.getTaxAmount());
			else
				previousRoundOff = previousRoundOff.add(demandDetail.getTaxAmount());
		}

		BigDecimal decimalValue = totalTax.remainder(BigDecimal.ONE);
		BigDecimal midVal = BigDecimal.valueOf(0.5);
		BigDecimal roundOff = BigDecimal.ZERO;

		/*
		 * If the decimal amount is greater than 0.5 we subtract it from 1 and
		 * put it as roundOff taxHead so as to nullify the decimal eg: If the
		 * tax is 12.64 we will add extra tax roundOff taxHead of 0.36 so that
		 * the total becomes 13
		 */
		if (decimalValue.compareTo(midVal) >= 0)
			roundOff = BigDecimal.ONE.subtract(decimalValue);

		/*
		 * If the decimal amount is less than 0.5 we put negative of it as
		 * roundOff taxHead so as to nullify the decimal eg: If the tax is 12.36
		 * we will add extra tax roundOff taxHead of -0.36 so that the total
		 * becomes 12
		 */
		if (decimalValue.compareTo(midVal) < 0)
			roundOff = decimalValue.negate();

		/*
		 * If roundOff already exists in previous demand create a new roundOff
		 * taxHead with roundOff amount equal to difference between them so that
		 * it will be balanced when bill is generated. eg: If the previous
		 * roundOff amount was of -0.36 and the new roundOff excluding the
		 * previous roundOff is 0.2 then the new roundOff will be created with
		 * 0.2 so that the net roundOff will be 0.2 -(-0.36)
		 */
		if (previousRoundOff.compareTo(BigDecimal.ZERO) != 0) {
			roundOff = roundOff.subtract(previousRoundOff);
		}

		if (roundOff.compareTo(BigDecimal.ZERO) != 0) {
			DemandDetail roundOffDemandDetail = DemandDetail.builder().taxAmount(roundOff)
					.taxHeadMasterCode(WSCalculationConstant.WS_Round_Off).tenantId(tenantId)
					.collectionAmount(BigDecimal.ZERO).build();
			demandDetails.add(roundOffDemandDetail);
		}
	}

	/**
	 * Searches demand for the given consumerCode and tenantIDd
	 * 
	 * @param tenantId
	 *            The tenantId of the tradeLicense
	 * @param consumerCodes
	 *            The set of consumerCode of the demands
	 * @param requestInfo
	 *            The RequestInfo of the incoming request
	 * @return Lis to demands for the given consumerCode
	 */
	private List<Demand> searchDemand(String tenantId, Set<String> consumerCodes, Long taxPeriodFrom, Long taxPeriodTo,
			RequestInfo requestInfo) {
		Object result = serviceRequestRepository.fetchResult(
				getDemandSearchURL(tenantId, consumerCodes, taxPeriodFrom, taxPeriodTo),
				RequestInfoWrapper.builder().requestInfo(requestInfo).build());
		try {
			return mapper.convertValue(result, DemandResponse.class).getDemands();
		} catch (IllegalArgumentException e) {
			throw new CustomException("PARSING_ERROR", "Failed to parse response from Demand Search");
		}

	}
	
	/**
	 * Creates demand Search url based on tenantId,businessService, and
	 * 
	 * @return demand search url
	 */
	public StringBuilder getDemandSearchURLForDemandId() {
		StringBuilder url = new StringBuilder(configs.getBillingServiceHost());
		url.append(configs.getDemandSearchEndPoint());
		url.append("?");
		url.append("tenantId=");
		url.append("{1}");
		url.append("&");
		url.append("businessService=");
		url.append("{2}");
		url.append("&");
		url.append("consumerCode=");
		url.append("{3}");
		url.append("&");
		url.append("isPaymentCompleted=false");
		return url;
	}
	/**
	 * 
	 * @param tenantId TenantId
	 * @param consumerCode Connection number
	 * @param requestInfo - RequestInfo
	 * @return List of Demand
	 */
	public List<Demand> searchDemandBasedOnConsumerCode(String tenantId, String consumerCode,
			RequestInfo requestInfo) {
		String uri = getDemandSearchURLForDemandId().toString();
		uri = uri.replace("{1}", tenantId);
		uri = uri.replace("{2}", configs.getBusinessService());
		uri = uri.replace("{3}", consumerCode);
		Object result = serviceRequestRepository.fetchResult(new StringBuilder(uri),
				RequestInfoWrapper.builder().requestInfo(requestInfo).build());
		try {
			return mapper.convertValue(result, DemandResponse.class).getDemands();
		} catch (IllegalArgumentException e) {
			throw new CustomException("PARSING_ERROR", "Failed to parse response from Demand Search");
		}
	}
	/**
	 * Creates demand Search url based on tenantId,businessService, period from, period to and
	 * ConsumerCode 
	 * 
	 * @return demand search url
	 */
	public StringBuilder getDemandSearchURL(String tenantId, Set<String> consumerCodes, Long taxPeriodFrom, Long taxPeriodTo) {
		StringBuilder url = new StringBuilder(configs.getBillingServiceHost());
		String businessService = taxPeriodFrom == null  ? WSCalculationConstant.ONE_TIME_FEE_SERVICE_FIELD : configs.getBusinessService();
		url.append(configs.getDemandSearchEndPoint());
		url.append("?");
		url.append("tenantId=");
		url.append(tenantId);
		url.append("&");
		url.append("businessService=");
		url.append(businessService);
		url.append("&");
		url.append("consumerCode=");
		url.append(StringUtils.join(consumerCodes, ','));
		if (taxPeriodFrom != null) {
			url.append("&");
			url.append("periodFrom=");
			url.append(taxPeriodFrom.toString());
		}
		if (taxPeriodTo != null) {
			url.append("&");
			url.append("periodTo=");
			url.append(taxPeriodTo.toString());
		}
		return url;
	}

	/**
	 * 
	 * @param getBillCriteria Bill Criteria
	 * @param requestInfoWrapper contains request info wrapper
	 * @return updated demand response
	 */
	public List<Demand> updateDemands(GetBillCriteria getBillCriteria, RequestInfoWrapper requestInfoWrapper) {

		if (getBillCriteria.getAmountExpected() == null)
			getBillCriteria.setAmountExpected(BigDecimal.ZERO);
		RequestInfo requestInfo = requestInfoWrapper.getRequestInfo();
		Map<String, JSONArray> billingSlabMaster = new HashMap<>();

		Map<String, JSONArray> timeBasedExemptionMasterMap = new HashMap<>();
		mstrDataService.setWaterConnectionMasterValues(requestInfo, getBillCriteria.getTenantId(), billingSlabMaster,
				timeBasedExemptionMasterMap);

		if (CollectionUtils.isEmpty(getBillCriteria.getConsumerCodes()))
			getBillCriteria.setConsumerCodes(Collections.singletonList(getBillCriteria.getConnectionNumber()));

		DemandResponse res = mapper.convertValue(
				repository.fetchResult(utils.getDemandSearchUrl(getBillCriteria), requestInfoWrapper),
				DemandResponse.class);
		if (CollectionUtils.isEmpty(res.getDemands())) {
			Map<String, String> map = new HashMap<>();
			map.put(WSCalculationConstant.EMPTY_DEMAND_ERROR_CODE, WSCalculationConstant.EMPTY_DEMAND_ERROR_MESSAGE);
			throw new CustomException(map);
		}


		// Loop through the consumerCodes and re-calculate the time base applicable
		Map<String, Demand> consumerCodeToDemandMap = res.getDemands().stream()
				.collect(Collectors.toMap(Demand::getId, Function.identity()));
		List<Demand> demandsToBeUpdated = new LinkedList<>();

		String tenantId = getBillCriteria.getTenantId();

		List<TaxPeriod> taxPeriods = mstrDataService.getTaxPeriodList(requestInfoWrapper.getRequestInfo(), tenantId, WSCalculationConstant.SERVICE_FIELD_VALUE_WS);
		
		consumerCodeToDemandMap.forEach((id, demand) ->{
			if (demand.getStatus() != null
					&& WSCalculationConstant.DEMAND_CANCELLED_STATUS.equalsIgnoreCase(demand.getStatus().toString()))
				throw new CustomException(WSCalculationConstant.EG_WS_INVALID_DEMAND_ERROR,
						WSCalculationConstant.EG_WS_INVALID_DEMAND_ERROR_MSG);
			applyTimeBasedApplicables(demand, requestInfoWrapper, timeBasedExemptionMasterMap, taxPeriods);
			addRoundOffTaxHead(tenantId, demand.getDemandDetails());
			demandsToBeUpdated.add(demand);
		});

		//Call demand update in bulk to update the interest or penalty
		DemandRequest request = DemandRequest.builder().demands(demandsToBeUpdated).requestInfo(requestInfo).build();
		repository.fetchResult(utils.getUpdateDemandUrl(), request);
		return res.getDemands();

	}

	/**
	 * Updates demand for the given list of calculations
	 * 
	 * @param requestInfo
	 *            The RequestInfo of the calculation request
	 * @param calculations
	 *            List of calculation object
	 * @return Demands that are updated
	 */
	private List<Demand> updateDemandForCalculation(RequestInfo requestInfo, List<Calculation> calculations,
			Long fromDate, Long toDate, boolean isForConnectionNo) {
		List<Demand> demands = new LinkedList<>();
		Long fromDateSearch = fromDate; //isForConnectionNo ? fromDate : null;
		Long toDateSearch = toDate; //isForConnectionNo ? toDate : null;
		String billCycle = "";
		for (Calculation calculation : calculations) {
			Set<String> consumerCodes = Collections.singleton(calculation.getWaterConnection().getConnectionNo());
			List<Demand> searchResult = searchDemand(calculation.getTenantId(), consumerCodes, fromDateSearch,
					toDateSearch, requestInfo);
			if (CollectionUtils.isEmpty(searchResult))
				throw new CustomException("INVALID_DEMAND_UPDATE", "No demand exists for Number: "
						+ consumerCodes.toString());
			Demand demand = searchResult.get(0);
			demand.setDemandDetails(getUpdatedDemandDetails(calculation, demand.getDemandDetails()));

			
			
			WaterConnectionRequest waterConnectionRequest = WaterConnectionRequest.builder().waterConnection(calculation.getWaterConnection())
					.requestInfo(requestInfo).build();
			Property property = wsCalculationUtil.getProperty(waterConnectionRequest);
			String tenantId = calculation.getTenantId();
			User owner = property.getOwners().get(0).toCommonUser();
			if (!CollectionUtils.isEmpty(waterConnectionRequest.getWaterConnection().getConnectionHolders())) {
				owner = waterConnectionRequest.getWaterConnection().getConnectionHolders().get(0).toCommonUser();
			}
			
			List<DemandDetail> demandDetails = new LinkedList<>();
			calculation.getTaxHeadEstimates().forEach(taxHeadEstimate -> {
				demandDetails.add(DemandDetail.builder().taxAmount(taxHeadEstimate.getEstimateAmount())
						.taxHeadMasterCode(taxHeadEstimate.getTaxHeadCode()).collectionAmount(BigDecimal.ZERO)
						.tenantId(calculation.getTenantId()).build());
			});

			HashMap<String, String> localizationMessage = util.getLocalizationMessage(requestInfo, WSCalculationConstant.mGram_Consumer_NewBill, calculation.getTenantId());
			
			String actionLink = config.getNotificationUrl() + config.getBillDownloadSMSLink().replace("$mobile", owner.getMobileNumber())
					.replace("$consumerCode", waterConnectionRequest.getWaterConnection().getConnectionNo())
					.replace("$tenantId", property.getTenantId());
			
			if(waterConnectionRequest.getWaterConnection().getConnectionType().equalsIgnoreCase(WSCalculationConstant.meteredConnectionType)) {
				actionLink = actionLink.replace("$key", "ws-bill");
			}else {
				actionLink = actionLink.replace("$key", "ws-bill-nm");
			}
			actionLink = getShortenedUrl(actionLink);
			String messageString = localizationMessage.get(WSCalculationConstant.MSG_KEY);

			System.out.println("Localization message::" + messageString);
			if( !StringUtils.isEmpty(messageString)) {
					billCycle = (Instant.ofEpochMilli(fromDate).atZone(ZoneId.systemDefault()).toLocalDate() + "-"
					+ Instant.ofEpochMilli(toDate).atZone(ZoneId.systemDefault()).toLocalDate());
			messageString = messageString.replace("{ownername}", owner.getName());
			messageString = messageString.replace("{Period}", billCycle);
			messageString = messageString.replace("{consumerno}", calculation.getConnectionNo());
			messageString = messageString.replace("{billamount}", demandDetails.stream().map(DemandDetail::getTaxAmount)
					.reduce(BigDecimal.ZERO, BigDecimal::add).toString());
			messageString = messageString.replace("{BILL_LINK}", getShortenedUrl(actionLink));
			
			System.out.println("Demand genaratio Message::" + messageString);
			
			SMSRequest sms = SMSRequest.builder().mobileNumber(owner.getMobileNumber()).message(messageString)
					.category(Category.TRANSACTION).build();
			producer.push(config.getSmsNotifTopic(), sms);
			
			}
			
			if(isForConnectionNo){
				WaterConnection connection = calculation.getWaterConnection();
				if (connection == null) {
					List<WaterConnection> waterConnectionList = calculatorUtils.getWaterConnection(requestInfo,
							calculation.getConnectionNo(),calculation.getTenantId());
					int size = waterConnectionList.size();
					connection = waterConnectionList.get(size-1);

				}

//				if(connection.getApplicationType().equalsIgnoreCase("MODIFY_WATER_CONNECTION")){
//					WaterConnectionRequest waterConnectionRequest = WaterConnectionRequest.builder().waterConnection(connection)
//							.requestInfo(requestInfo).build();
//					Property property = wsCalculationUtil.getProperty(waterConnectionRequest);
//					User owner = property.getOwners().get(0).toCommonUser();
//					if (!CollectionUtils.isEmpty(waterConnectionRequest.getWaterConnection().getConnectionHolders())) {
//						owner = waterConnectionRequest.getWaterConnection().getConnectionHolders().get(0).toCommonUser();
//					}
//					if(!(demand.getPayer().getUuid().equalsIgnoreCase(owner.getUuid())))
//						demand.setPayer(owner);
//				}


			}

			demands.add(demand);
		}

		log.info("Updated Demand Details " + demands.toString());
		return demandRepository.updateDemand(requestInfo, demands);
	}

	
	/**
	 * Applies Penalty/Rebate/Interest to the incoming demands
	 * 
	 * If applied already then the demand details will be updated
	 * 
	 * @param demand - Demand Object
	 * @param requestInfoWrapper RequestInfoWrapper Object
	 * @param timeBasedExemptionMasterMap - List of TimeBasedExemption details
	 * @param taxPeriods - List of tax periods
	 * @return Returns TRUE if successful, FALSE otherwise
	 */

	private boolean applyTimeBasedApplicables(Demand demand, RequestInfoWrapper requestInfoWrapper,
											  Map<String, JSONArray> timeBasedExemptionMasterMap, List<TaxPeriod> taxPeriods) {

		String tenantId = demand.getTenantId();
		String demandId = demand.getId();
		Long expiryDate = demand.getBillExpiryTime();
		TaxPeriod taxPeriod = taxPeriods.stream().filter(t -> demand.getTaxPeriodFrom().compareTo(t.getFromDate()) >= 0
				&& demand.getTaxPeriodTo().compareTo(t.getToDate()) <= 0).findAny().orElse(null);
		
		if (taxPeriod == null) {
			log.info("Demand Expired!! ->> Consumer Code "+ demand.getConsumerCode() +" Demand Id -->> "+ demand.getId());
			return false;
		}
		boolean isCurrentDemand = false;
		if (!(taxPeriod.getFromDate() <= System.currentTimeMillis()
				&& taxPeriod.getToDate() >= System.currentTimeMillis()))
			isCurrentDemand = true;
		
		if(expiryDate < System.currentTimeMillis()) {
		BigDecimal waterChargeApplicable = BigDecimal.ZERO;
		BigDecimal oldPenalty = BigDecimal.ZERO;
		BigDecimal oldInterest = BigDecimal.ZERO;
		

		for (DemandDetail detail : demand.getDemandDetails()) {
			if (WSCalculationConstant.TAX_APPLICABLE.contains(detail.getTaxHeadMasterCode())) {
				waterChargeApplicable = waterChargeApplicable.add(detail.getTaxAmount());
			}
			if (detail.getTaxHeadMasterCode().equalsIgnoreCase(WSCalculationConstant.WS_TIME_PENALTY)) {
				oldPenalty = oldPenalty.add(detail.getTaxAmount());
			}
			if (detail.getTaxHeadMasterCode().equalsIgnoreCase(WSCalculationConstant.WS_TIME_INTEREST)) {
				oldInterest = oldInterest.add(detail.getTaxAmount());
			}
		}
		
		boolean isPenaltyUpdated = false;
		boolean isInterestUpdated = false;
		
		List<DemandDetail> details = demand.getDemandDetails();

		Map<String, BigDecimal> interestPenaltyEstimates = payService.applyPenaltyRebateAndInterest(
				waterChargeApplicable, taxPeriod.getFinancialYear(), timeBasedExemptionMasterMap, expiryDate);
		if (null == interestPenaltyEstimates)
			return isCurrentDemand;

		BigDecimal penalty = interestPenaltyEstimates.get(WSCalculationConstant.WS_TIME_PENALTY);
		BigDecimal interest = interestPenaltyEstimates.get(WSCalculationConstant.WS_TIME_INTEREST);
		if(penalty == null)
			penalty = BigDecimal.ZERO;
		if(interest == null)
			interest = BigDecimal.ZERO;

		DemandDetailAndCollection latestPenaltyDemandDetail, latestInterestDemandDetail;

		if (interest.compareTo(BigDecimal.ZERO) != 0) {
			latestInterestDemandDetail = utils.getLatestDemandDetailByTaxHead(WSCalculationConstant.WS_TIME_INTEREST,
					details);
			if (latestInterestDemandDetail != null) {
				updateTaxAmount(interest, latestInterestDemandDetail);
				isInterestUpdated = true;
			}
		}

		if (penalty.compareTo(BigDecimal.ZERO) != 0) {
			latestPenaltyDemandDetail = utils.getLatestDemandDetailByTaxHead(WSCalculationConstant.WS_TIME_PENALTY,
					details);
			if (latestPenaltyDemandDetail != null) {
				updateTaxAmount(penalty, latestPenaltyDemandDetail);
				isPenaltyUpdated = true;
			}
		}

		if (!isPenaltyUpdated && penalty.compareTo(BigDecimal.ZERO) > 0)
			details.add(
					DemandDetail.builder().taxAmount(penalty.setScale(2, 2)).taxHeadMasterCode(WSCalculationConstant.WS_TIME_PENALTY)
							.demandId(demandId).tenantId(tenantId).build());
		if (!isInterestUpdated && interest.compareTo(BigDecimal.ZERO) > 0)
			details.add(
					DemandDetail.builder().taxAmount(interest.setScale(2, 2)).taxHeadMasterCode(WSCalculationConstant.WS_TIME_INTEREST)
							.demandId(demandId).tenantId(tenantId).build());
		}

		return isCurrentDemand;
	}

	/**
	 * Updates the amount in the latest demandDetail by adding the diff between
	 * new and old amounts to it
	 * 
	 * @param newAmount
	 *            The new tax amount for the taxHead
	 * @param latestDetailInfo
	 *            The latest demandDetail for the particular taxHead
	 */
	private void updateTaxAmount(BigDecimal newAmount, DemandDetailAndCollection latestDetailInfo) {
		BigDecimal diff = newAmount.subtract(latestDetailInfo.getTaxAmountForTaxHead());
		BigDecimal newTaxAmountForLatestDemandDetail = latestDetailInfo.getLatestDemandDetail().getTaxAmount()
				.add(diff);
		latestDetailInfo.getLatestDemandDetail().setTaxAmount(newTaxAmountForLatestDemandDetail);
	}
	
	
	
	
	/**
	 * 
	 * @param tenantId
	 *            TenantId for getting master data.
	 */
	public void generateDemandForTenantId(String tenantId, RequestInfo requestInfo) {
		requestInfo.getUserInfo().setTenantId(tenantId);
		Map<String, Object> billingMasterData = calculatorUtils.loadBillingFrequencyMasterData(requestInfo, tenantId);
		generateDemandForULB(billingMasterData, requestInfo, tenantId);
	}

	/**
	 * 
	 * @param tenantId
	 *            TenantId for getting master data.
	 */
	public void generateBulkDemandForTenantId(BulkDemand bulkDemand) {
		RequestInfo requestInfo = bulkDemand.getRequestInfo();
		String tenantId = bulkDemand.getTenantId();
		requestInfo.getUserInfo().setTenantId(tenantId);
		Map<String, Object> billingMasterData = calculatorUtils.loadBillingFrequencyMasterData(requestInfo, tenantId);
		generateBulkDemandForULB(billingMasterData, bulkDemand);
	}
	
	public void generateBulkDemandForULB(Map<String, Object> master,BulkDemand bulkDemand) {
		log.info("Billing master data values for non metered connection:: {}", master);
		String billingPeriod = bulkDemand.getBillingPeriod();
		if (StringUtils.isEmpty(billingPeriod))
			 throw new CustomException("BILLING_PERIOD_PARSING_ISSUE", "Billing can not empty!!");
		
		List<String> connectionNos =  waterCalculatorDao.getConnectionsNoList(bulkDemand.getTenantId(),
				WSCalculationConstant.nonMeterdConnection);
		List<String> meteredConnectionNos =  waterCalculatorDao.getConnectionsNoList(bulkDemand.getTenantId(),
				WSCalculationConstant.meteredConnectionType);
		
		List<ActionItem> items = new ArrayList<>();
		String actionLink = config.getBulkDemandLink();
		ActionItem item = ActionItem.builder().actionUrl(actionLink).build();
		items.add(item);
		Action action = Action.builder().actionUrls(items).build();

		List<Event> events = new ArrayList<>();
		
		HashMap<String, String> messageMap = new HashMap<String, String>();

		String message = null;
		if(connectionNos.size() > 0 && meteredConnectionNos.size() > 0) {
			messageMap = util.getLocalizationMessage(bulkDemand.getRequestInfo(),
					WSCalculationConstant.NEW_BULK_DEMAND_EVENT, bulkDemand.getTenantId());
			int size = connectionNos.size() + meteredConnectionNos.size();
			message = messageMap.get(WSCalculationConstant.MSG_KEY);
			message = message.replace("{billing cycle}", billingPeriod);
			message = message.replace("{X}", String.valueOf(connectionNos.size()));
			message = message.replace("{X/X+Y}", String.valueOf(connectionNos.size())+"/"+String.valueOf(size));
			message = message.replace("{Y}", String.valueOf(meteredConnectionNos.size()));
		}else if(connectionNos.size() > 0 && meteredConnectionNos.isEmpty()) {
			messageMap = util.getLocalizationMessage(bulkDemand.getRequestInfo(),
					WSCalculationConstant.NEW_BULK_DEMAND_EVENT_NM, bulkDemand.getTenantId());

			message = messageMap.get(WSCalculationConstant.MSG_KEY);
			message = message.replace("{billing cycle}", billingPeriod);
			message = message.replace("{X}", String.valueOf(connectionNos.size()));
			message = message.replace("{X/X}", String.valueOf(connectionNos.size())+"/"+String.valueOf(connectionNos.size()));
		}else if(connectionNos.isEmpty() && meteredConnectionNos.size() > 0) {
			 messageMap = util.getLocalizationMessage(bulkDemand.getRequestInfo(),
					WSCalculationConstant.NEW_BULK_DEMAND_EVENT_M, bulkDemand.getTenantId());

				message = messageMap.get(WSCalculationConstant.MSG_KEY);
				message = message.replace("{Y}", String.valueOf(meteredConnectionNos.size()));
		}

		System.out.println("Bulk Event msg:: " + message);
		events.add(Event.builder().tenantId(bulkDemand.getTenantId())
				.description(message)
				.eventType(WSCalculationConstant.USREVENTS_EVENT_TYPE).name(WSCalculationConstant.USREVENTS_EVENT_NAME).postedBy(WSCalculationConstant.USREVENTS_EVENT_POSTEDBY)
				.recepient(getRecepient(bulkDemand.getRequestInfo(), bulkDemand.getTenantId())).source(Source.WEBAPP).eventDetails(null).actions(action)
				.build());
		
		if (!CollectionUtils.isEmpty(events)) {
			EventRequest eventReq =  EventRequest.builder().requestInfo(bulkDemand.getRequestInfo()).events(events).build();
			util.sendEventNotification(eventReq);
		} 
		
		
		// GP User message
		
		HashMap<String, String> demandMessage = util.getLocalizationMessage(bulkDemand.getRequestInfo(),
				WSCalculationConstant.mGram_Consumer_NewDemand, bulkDemand.getTenantId());

		UserDetailResponse userDetailResponse = userService.getUserByRoleCodes(bulkDemand.getRequestInfo(),
				Arrays.asList("COLLECTION_OPERATOR"), bulkDemand.getTenantId());
		Map<String, String> mobileNumberIdMap = new LinkedHashMap<>();

		
		String msgLink = config.getNotificationUrl() + config.getGpUserDemandLink();
		
		for (OwnerInfo userInfo : userDetailResponse.getUser())
			if (userInfo.getName() != null) {
				mobileNumberIdMap.put(userInfo.getMobileNumber(), userInfo.getName());
			} else {
				mobileNumberIdMap.put(userInfo.getMobileNumber(), userInfo.getUserName());
			}
		mobileNumberIdMap.entrySet().stream().forEach(map -> {
			String msg = demandMessage.get(WSCalculationConstant.MSG_KEY);
			msg = msg.replace("{ownername}", map.getValue());
			msg = msg.replace("{villagename}", bulkDemand.getTenantId());
			msg = msg.replace("{billingcycle}", billingPeriod);
			msg = msg.replace("{LINK}", msgLink);

			System.out.println("Demand GP USER SMS::" + msg);

			SMSRequest smsRequest = SMSRequest.builder().mobileNumber(map.getKey()).message(msg)
					.category(Category.TRANSACTION).build();

			producer.push(config.getSmsNotifTopic(), smsRequest);

		});
		
		Set<String> connectionSet = connectionNos.stream().collect(Collectors.toSet());
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
		Date billingStrartDate;
		Calendar startCal = Calendar.getInstance();
		Calendar endCal = Calendar.getInstance();
		try {
			billingStrartDate = sdf.parse(billingPeriod.split("-")[0].trim());
			Date billingEndDate = sdf.parse(billingPeriod.split("-")[1].trim());
			startCal.setTime(billingStrartDate);
			endCal.setTime(billingEndDate);
			
		} catch (CustomException | ParseException ex) {
			log.error("", ex);
			
			if (ex instanceof CustomException)
				throw new CustomException("BILLING_PERIOD_ISSUE", "Billing period can not be in future!!");
			
			throw new CustomException("BILLING_PERIOD_PARSING_ISSUE", "Billing period can not parsed!!");
		}
		wsCalculationValidator.validateBulkDemandBillingPeriod(startCal.getTimeInMillis(),connectionSet,bulkDemand.getTenantId(),(String) master.get(WSCalculationConstant.Billing_Cycle_String));
		String assessmentYear = estimationService.getAssessmentYear();
		for (String connectionNo : connectionNos) {
			CalculationCriteria calculationCriteria = CalculationCriteria.builder().tenantId(bulkDemand.getTenantId())
					.assessmentYear(assessmentYear).connectionNo(connectionNo).from(startCal.getTimeInMillis()).to(endCal.getTimeInMillis()).build();
			List<CalculationCriteria> calculationCriteriaList = new ArrayList<>();
			calculationCriteriaList.add(calculationCriteria);
			CalculationReq calculationReq = CalculationReq.builder().calculationCriteria(calculationCriteriaList)
					.requestInfo(bulkDemand.getRequestInfo()).isconnectionCalculation(true).build();
			wsCalculationProducer.push(configs.getCreateDemand(), calculationReq);
			// log.info("Prepared Statement" + calculationRes.toString());

		}
	}
	
	
	private String formatDemandMessage(RequestInfo requestInfo, String tenantId, String string) {
		// TODO Auto-generated method stub
		return null;
	}

	private Recipient getRecepient(RequestInfo requestInfo, String tenantId) {
		Recipient recepient = null;
		UserDetailResponse userDetailResponse = userService.getUserByRoleCodes(requestInfo,Arrays.asList("GP_ADMIN"), tenantId);
		if (userDetailResponse.getUser().isEmpty())
			log.error("Recepient is absent");
		else {
			List<String> toUsers = userDetailResponse.getUser().stream().map(OwnerInfo::getUuid)
					.collect(Collectors.toList());

			recepient = Recipient.builder().toUsers(toUsers).toRoles(null).build();
		}
		return recepient;
	}

	private int getBillingCycleMiddleDay(String billingFrequency) {
		if (billingFrequency.equalsIgnoreCase(WSCalculationConstant.Monthly_Billing_Period)) {
			return 15;
		} else if (billingFrequency.equalsIgnoreCase(WSCalculationConstant.Quaterly_Billing_Period)) {
			return 80;
		}
		return 0;
	}
	
	/**
	 * 
	 * @param master Master MDMS Data
	 * @param requestInfo Request Info
	 * @param tenantId Tenant Id
	 */
	public void generateDemandForULB(Map<String, Object> master, RequestInfo requestInfo, String tenantId) {
		log.info("Billing master data values for non metered connection:: {}", master);
		long startDay = (((int) master.get(WSCalculationConstant.Demand_Generate_Date_String)) / 86400000);
		if(isCurrentDateIsMatching((String) master.get(WSCalculationConstant.Billing_Cycle_String), startDay) ) {
			List<String> connectionNos = waterCalculatorDao.getConnectionsNoList(tenantId,
					WSCalculationConstant.nonMeterdConnection);
			String assessmentYear = estimationService.getAssessmentYear();
			for (String connectionNo : connectionNos) {
				CalculationCriteria calculationCriteria = CalculationCriteria.builder().tenantId(tenantId)
						.assessmentYear(assessmentYear).connectionNo(connectionNo).build();
				List<CalculationCriteria> calculationCriteriaList = new ArrayList<>();
				calculationCriteriaList.add(calculationCriteria);
				CalculationReq calculationReq = CalculationReq.builder().calculationCriteria(calculationCriteriaList)
						.requestInfo(requestInfo).isconnectionCalculation(true).build();
				wsCalculationProducer.push(configs.getCreateDemand(), calculationReq);
				// log.info("Prepared Statement" + calculationRes.toString());

			}
		}
	}

	/**
	 * 
	 * @param billingFrequency Billing Frequency details
	 * @param dayOfMonth Day of the given month
	 * @return true if current day is for generation of demand
	 */
	private boolean isCurrentDateIsMatching(String billingFrequency, long dayOfMonth) {
		if (billingFrequency.equalsIgnoreCase(WSCalculationConstant.Monthly_Billing_Period)
				&& (dayOfMonth == LocalDateTime.now().getDayOfMonth())) {
			return true;
		} else if (billingFrequency.equalsIgnoreCase(WSCalculationConstant.Quaterly_Billing_Period)) {
			return false;
		}
		return true;
	}
	
	public List<String> fetchBill(List<Demand> demandResponse, RequestInfo requestInfo) {
		boolean notificationSent = false;
		List<String> billNumber = new ArrayList<>();
		for (Demand demand : demandResponse) {
			try {
				Object result = serviceRequestRepository.fetchResult(
						calculatorUtils.getFetchBillURL(demand.getTenantId(), demand.getConsumerCode()),
						RequestInfoWrapper.builder().requestInfo(requestInfo).build());
				billNumber = JsonPath.read(result, "$.Bill.*.billNumber");
				

				HashMap<String, Object> billResponse = new HashMap<>();
				
				billResponse.put("requestInfo", requestInfo);
				billResponse.put("billResponse", result);
				wsCalculationProducer.push(configs.getPayTriggers(), billResponse);
				notificationSent = true;
			} catch (Exception ex) {
				log.error("Fetch Bill Error", ex);
			}
		}
		return billNumber;
	}
	
/**
 * compare and update the demand details
 * 
 * @param calculation - Calculation object
 * @param demandDetails - List Of Demand Details
 * @return combined demand details list
 */ 
	private List<DemandDetail> getUpdatedAdhocTax(Calculation calculation, List<DemandDetail> demandDetails) {

		List<DemandDetail> newDemandDetails = new ArrayList<>();
		Map<String, List<DemandDetail>> taxHeadToDemandDetail = new HashMap<>();

		demandDetails.forEach(demandDetail -> {
			if (!taxHeadToDemandDetail.containsKey(demandDetail.getTaxHeadMasterCode())) {
				List<DemandDetail> demandDetailList = new LinkedList<>();
				demandDetailList.add(demandDetail);
				taxHeadToDemandDetail.put(demandDetail.getTaxHeadMasterCode(), demandDetailList);
			} else
				taxHeadToDemandDetail.get(demandDetail.getTaxHeadMasterCode()).add(demandDetail);
		});

		BigDecimal diffInTaxAmount;
		List<DemandDetail> demandDetailList;
		BigDecimal total;

		for (TaxHeadEstimate taxHeadEstimate : calculation.getTaxHeadEstimates()) {
			if (!taxHeadToDemandDetail.containsKey(taxHeadEstimate.getTaxHeadCode()))
				newDemandDetails.add(DemandDetail.builder().taxAmount(taxHeadEstimate.getEstimateAmount())
						.taxHeadMasterCode(taxHeadEstimate.getTaxHeadCode()).tenantId(calculation.getTenantId())
						.collectionAmount(BigDecimal.ZERO).build());
			else {
				demandDetailList = taxHeadToDemandDetail.get(taxHeadEstimate.getTaxHeadCode());
				total = demandDetailList.stream().map(DemandDetail::getTaxAmount).reduce(BigDecimal.ZERO,
						BigDecimal::add);
				diffInTaxAmount = taxHeadEstimate.getEstimateAmount().subtract(total);
				if (diffInTaxAmount.compareTo(BigDecimal.ZERO) != 0) {
					newDemandDetails.add(DemandDetail.builder().taxAmount(diffInTaxAmount)
							.taxHeadMasterCode(taxHeadEstimate.getTaxHeadCode()).tenantId(calculation.getTenantId())
							.collectionAmount(BigDecimal.ZERO).build());
				}
			}
		}
		List<DemandDetail> combinedBillDetails = new LinkedList<>(demandDetails);
		combinedBillDetails.addAll(newDemandDetails);
		addRoundOffTaxHead(calculation.getTenantId(), combinedBillDetails);
		return combinedBillDetails;
	}
	
	/**
	 * Search demand based on demand id and updated the tax heads with new adhoc tax heads
	 * 
	 * @param requestInfo - Request Info Object
	 * @param calculations - List of Calculation to update the Demand
	 * @return List of calculation
	 */
	public List<Calculation> updateDemandForAdhocTax(RequestInfo requestInfo, List<Calculation> calculations) {
		List<Demand> demands = new LinkedList<>();
		for (Calculation calculation : calculations) {
			String consumerCode = calculation.getConnectionNo();
			List<Demand> searchResult = searchDemandBasedOnConsumerCode(calculation.getTenantId(), consumerCode,
					requestInfo);
			if (CollectionUtils.isEmpty(searchResult))
				throw new CustomException("INVALID_DEMAND_UPDATE",
						"No demand exists for Number: " + consumerCode);

			Collections.sort(searchResult, new Comparator<Demand>() {
				@Override
				public int compare(Demand d1, Demand d2) {
					return d1.getTaxPeriodFrom().compareTo(d2.getTaxPeriodFrom());
				}
			});

			Demand demand = searchResult.get(0);
			demand.setDemandDetails(getUpdatedAdhocTax(calculation, demand.getDemandDetails()));
			demands.add(demand);
		}

		log.info("Updated Demand Details " + demands.toString());
		demandRepository.updateDemand(requestInfo, demands);
		return calculations;
	}

}
