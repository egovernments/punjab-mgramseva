package org.egov.echallan.service;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Month;
import java.time.YearMonth;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.egov.common.contract.request.RequestInfo;
import org.egov.echallan.config.ChallanConfiguration;
import org.egov.echallan.model.SMSRequest;
import org.egov.echallan.model.UserInfo;
import org.egov.echallan.producer.Producer;
import org.egov.echallan.repository.ChallanRepository;
import org.egov.echallan.repository.ServiceRequestRepository;
import org.egov.echallan.util.ChallanConstants;
import org.egov.echallan.util.CommonUtils;
import org.egov.echallan.util.NotificationUtil;
import org.egov.echallan.web.models.user.UserDetailResponse;
import org.egov.echallan.web.models.uservevents.Action;
import org.egov.echallan.web.models.uservevents.ActionItem;
import org.egov.echallan.web.models.uservevents.Event;
import org.egov.echallan.web.models.uservevents.EventRequest;
import org.egov.echallan.web.models.uservevents.Recepient;
import org.egov.echallan.web.models.uservevents.Source;
import org.egov.mdms.model.MasterDetail;
import org.egov.mdms.model.MdmsCriteria;
import org.egov.mdms.model.MdmsCriteriaReq;
import org.egov.mdms.model.ModuleDetail;
import org.egov.tracer.model.CustomException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jayway.jsonpath.JsonPath;

import ch.qos.logback.core.net.SyslogOutputStream;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class SchedulerService {

	private ChallanRepository repository;

	private CommonUtils utils;

	private ServiceRequestRepository serviceRequestRepository;

	@Autowired
	private NotificationUtil util;

	@Autowired
	private ChallanConfiguration config;

	@Autowired
	private NotificationService notificationService;
	@Autowired
	private UserService userService;

	@Autowired
	private Producer producer;
	
	@Autowired
	private RestTemplate restTemplate;

	public static final String USREVENTS_EVENT_TYPE = "SYSTEMGENERATED";
	public static final String USREVENTS_EVENT_NAME = "Challan";
	public static final String USREVENTS_EVENT_POSTEDBY = "SYSTEM-CHALLAN";

	private static final String PENDING_COLLECTION_EVENT = "PENDING_COLLECTION_EN_REMINDER";
	private static final String MONTHLY_SUMMARY_EVENT = "MONTHLY_SUMMARY_EN_REMINDER";
	private static final String NEW_EXPENDITURE_EVENT = "NEW_ENPENDITURE_EN_REMINDER";
	private static final String MARK_PAID_BILL_EVENT = "MARK_PAID_BILL_EN_REMINDER";
	private static final String GENERATE_DEMAND_EVENT = "GENERATE_DEMAND_EN_REMINDER";
	private static final String NEW_EXPENDITURE_SMS = "mGram.GPUser.EnterExpense";
	private static final String MONTHLY_SUMMARY_SMS = "mGram.GPUser.PreviousMonthSummary";
	private static final String MARK_PAID_BILL_SMS = "mGram.GPUser.MarkExpense";
	private static final String PENDING_COLLECTION_SMS = "mGram.GPUser.CollectionReminder";

	private static final String TODAY_CASH_COLLECTION = "TODAY_COLLECTION_AS_CASH_SMS";
	private static final String TODAY_ONLINE_COLLECTION = "TODAY_COLLECTION_FROM_ONLINE_SMS";
	private static final String TODAY_CASH_COLLECTION_SMS = "TODAY_COLLECTION_FROM_CASH";
	private static final String TODAY_ONLINE_COLLECTION_SMS = "TODAY_COLLECTION_FROM_ONLINE";

	@Autowired
	public SchedulerService(ChallanRepository repository, CommonUtils utils,
			ServiceRequestRepository serviceRequestRepository) {
		this.repository = repository;
		this.utils = utils;
		this.serviceRequestRepository = serviceRequestRepository;
	}

	public Map<String, Object> getFinancialYear(RequestInfo requestInfo, String tenantId) {
		Set<String> financeYears = new HashSet<>(1);
		String financeYear = prepareFinanceYear();
		MdmsCriteriaReq mdmsCriteriaReq = getFinancialYearRequest(requestInfo, financeYear, tenantId);
		StringBuilder url = utils.getMdmsSearchUrl();
		Object res = serviceRequestRepository.fetchResult(url, mdmsCriteriaReq);
		Map<String, Object> financialYearProperties;
		String jsonPath = ChallanConstants.MDMS_EGFFINACIALYEAR_PATH.replace("{}", financeYear);
		try {
			List<Map<String, Object>> jsonOutput = JsonPath.read(res, jsonPath);
			financialYearProperties = jsonOutput.get(0);

		} catch (IndexOutOfBoundsException e) {
			throw new CustomException("EXP_FIN_NOT_FOUND", "Financial year not found: " + financeYears);
		}

		return financialYearProperties;
	}

	public String prepareFinanceYear() {
		LocalDateTime localDateTime = LocalDateTime.now();
		int currentMonth = localDateTime.getMonthValue();
		String financialYear;
		if (currentMonth >= Month.APRIL.getValue()) {
			financialYear = YearMonth.now().getYear() + "-";
			financialYear = financialYear
					+ (Integer.toString(YearMonth.now().getYear() + 1).substring(2, financialYear.length() - 1));
		} else {
			financialYear = YearMonth.now().getYear() - 1 + "-";
			financialYear = financialYear
					+ (Integer.toString(YearMonth.now().getYear()).substring(2, financialYear.length() - 1));

		}
		return financialYear;
	}

	public MdmsCriteriaReq getFinancialYearRequest(RequestInfo requestInfo, String financeYearsStr, String tenantId) {
		MasterDetail masterDetail = MasterDetail.builder().name("FinancialYear")
				.filter("[?(@." + "finYearRange" + " IN [" + financeYearsStr + "]" + " && @.module== '" + "WS" + "')]")
				.build();
		ModuleDetail moduleDetail = ModuleDetail.builder().moduleName("egf-master")
				.masterDetails(Arrays.asList(masterDetail)).build();
		MdmsCriteria mdmsCriteria = MdmsCriteria.builder().moduleDetails(Arrays.asList(moduleDetail)).tenantId(tenantId)
				.build();
		return MdmsCriteriaReq.builder().requestInfo(requestInfo).mdmsCriteria(mdmsCriteria).build();
	}

	public EventRequest sendNewExpenditureNotification(RequestInfo requestInfo, String tenantId) {

		List<ActionItem> items = new ArrayList<>();
		String actionLink = config.getUiAppHost() + config.getExpenditureLink();
		ActionItem item = ActionItem.builder().actionUrl(actionLink).build();
		items.add(item);
		Action action = Action.builder().actionUrls(items).build();
		List<Event> events = new ArrayList<>();

		if (tenantId.split("\\.").length >= 2) {
			HashMap<String, String> messageMap = util.getLocalizationMessage(requestInfo, NEW_EXPENDITURE_EVENT,
					tenantId);
			System.out.println("Final Message ::" + messageMap.get(NotificationUtil.MSG_KEY));
			events.add(Event.builder().tenantId(tenantId).description(messageMap.get(NotificationUtil.MSG_KEY))
					.eventType(USREVENTS_EVENT_TYPE).name(USREVENTS_EVENT_NAME).postedBy(USREVENTS_EVENT_POSTEDBY)
					.recepient(getRecepient(requestInfo, tenantId)).source(Source.WEBAPP).eventDetails(null)
					.actions(action).build());
		}

		if (!CollectionUtils.isEmpty(events))

		{
			return EventRequest.builder().requestInfo(requestInfo).events(events).build();
		} else {
			return null;
		}

	}

	/**
	 * Send the new expenditure notification every fortnight
	 * 
	 * @param requestInfo
	 */

	public void sendNewExpenditureEvent(RequestInfo requestInfo) {

		LocalDate dayofmonth = LocalDate.now().with(TemporalAdjusters.firstDayOfMonth());
		LocalDateTime scheduleTimeFirst = LocalDateTime.of(dayofmonth.getYear(), dayofmonth.getMonth(),
				dayofmonth.getDayOfMonth(), 10, 0, 0);
		LocalDateTime scheduleTimeSecond = LocalDateTime.of(dayofmonth.getYear(), dayofmonth.getMonth(), 15, 10, 0, 0);
		DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
		LocalDateTime currentTime = LocalDateTime.parse(LocalDateTime.now().format(dateTimeFormatter),
				dateTimeFormatter);

		List<String> tenantIds = repository.getTenantId();
		if (!currentTime.isEqual(scheduleTimeFirst) || currentTime.isEqual(scheduleTimeSecond)) {

			tenantIds.forEach(tenantId -> {
				if (tenantId.split("\\.").length >= 2) {

					if (null != config.getIsUserEventEnabled()) {
						if (config.getIsUserEventEnabled()) {
							EventRequest eventRequest = sendNewExpenditureNotification(requestInfo, tenantId);
							if (null != eventRequest)
								notificationService.sendEventNotification(eventRequest);
						}
					}

					if (null != config.getIsSMSEnabled()) {
						if (config.getIsSMSEnabled()) {
							
							UserDetailResponse userDetailResponse = userService.getUserByRoleCodes(requestInfo,
									tenantId, Arrays.asList("EXPENSE_PROCESSING"));
							Map<String, String> mobileNumberIdMap = new LinkedHashMap<>();

							HashMap<String, String> messageMap = util.getLocalizationMessage(requestInfo,
									NEW_EXPENDITURE_SMS, tenantId);
							for (UserInfo userInfo : userDetailResponse.getUser())
								if (userInfo.getName() != null) {
									mobileNumberIdMap.put(userInfo.getMobileNumber(), userInfo.getName());
								} else {
									mobileNumberIdMap.put(userInfo.getMobileNumber(), userInfo.getUserName());
								}
							mobileNumberIdMap.entrySet().stream().forEach(map -> {
								if (messageMap != null
										&& !StringUtils.isEmpty(messageMap.get(NotificationUtil.MSG_KEY))) {
									String message = messageMap.get(NotificationUtil.MSG_KEY);

									message = message.replace("{NEW_EXP_LINK}", getShortenedUrl(config.getExpenditureLink()));
									message = message.replace("{GPWSC}", tenantId); // TODO Replace
									// <GPWSC> with
									// value.
									System.out.println("New Expenditure SMS :: " + message);

									SMSRequest smsRequest = SMSRequest.builder().mobileNumber(map.getKey())
											.message(message).templateId(messageMap.get(NotificationUtil.TEMPLATE_KEY))
											.users(new String[] { map.getValue() }).build();
									producer.push(config.getSmsNotifTopic(), smsRequest);
								}
							});
						}
					}
				}
			});
		}
	}

	private CharSequence getShortenedUrl(String url) {
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

	public EventRequest sendGenerateDemandNotification(RequestInfo requestInfo, String tenantId) {

		List<ActionItem> items = new ArrayList<>();
		String actionLink = config.getDemanGenerationLink();
		ActionItem item = ActionItem.builder().actionUrl(actionLink).build();
		items.add(item);
		Action action = Action.builder().actionUrls(items).build();
		List<Event> events = new ArrayList<>();
		HashMap<String, String> messageMap = util.getLocalizationMessage(requestInfo, GENERATE_DEMAND_EVENT, tenantId);
		String message = messageMap.get(NotificationUtil.MSG_KEY);
		message = message.replace("{BILLING_CYCLE}", LocalDate.now().getMonth().toString());
		System.out.println("Demand Genaration Failed::" + messageMap);
		events.add(Event.builder().tenantId(tenantId).description(message)
				.eventType(USREVENTS_EVENT_TYPE).name(USREVENTS_EVENT_NAME).postedBy(USREVENTS_EVENT_POSTEDBY)
				.recepient(getRecepient(requestInfo, tenantId)).source(Source.WEBAPP).eventDetails(null).actions(action)
				.build());

		if (!CollectionUtils.isEmpty(events)) {
			return EventRequest.builder().requestInfo(requestInfo).events(events).build();
		} else {
			return null;
		}

	}

	public void sendGenerateDemandEvent(RequestInfo requestInfo) {
		LocalDate dayofmonth = LocalDate.now().with(TemporalAdjusters.firstDayOfMonth());
		LocalDateTime scheduleTime = LocalDateTime.of(dayofmonth.getYear(), dayofmonth.getMonth(),
				dayofmonth.getDayOfMonth(), 10, 0, 0);
		DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
		LocalDateTime currentTime = LocalDateTime.parse(LocalDateTime.now().format(dateTimeFormatter),
				dateTimeFormatter);

		List<String> tenantIds = repository.getTenantId();
		if (!currentTime.isEqual(scheduleTime)) {
			tenantIds.forEach(tenantId -> {
				if (tenantId.split("\\.").length >= 2) {
					if (null != config.getIsUserEventEnabled()) {
						if (config.getIsUserEventEnabled()) {
							EventRequest eventRequest = sendGenerateDemandNotification(requestInfo, tenantId);
							if (null != eventRequest)
								notificationService.sendEventNotification(eventRequest);
						}
					}
				}
			});
		}
	}

	public EventRequest sendMarkExpensebillNotification(RequestInfo requestInfo, String tenantId) {

		List<Event> events = new ArrayList<>();
		HashMap<String, String> messageMap = util.getLocalizationMessage(requestInfo, MARK_PAID_BILL_EVENT, tenantId);
		events.add(Event.builder().tenantId(tenantId)
				.description(formatMarkExpenseMessage(tenantId, messageMap.get(NotificationUtil.MSG_KEY)))
				.eventType(USREVENTS_EVENT_TYPE).name(USREVENTS_EVENT_NAME).postedBy(USREVENTS_EVENT_POSTEDBY)
				.recepient(getRecepient(requestInfo, tenantId)).source(Source.WEBAPP).eventDetails(null).build());

		if (!CollectionUtils.isEmpty(events)) {
			return EventRequest.builder().requestInfo(requestInfo).events(events).build();
		} else {
			return null;
		}

	}

	public String formatMarkExpenseMessage(String tenantId, String message) {
		List<String> activeExpenseCount = repository.getActiveExpenses(tenantId);
		if (null != activeExpenseCount && activeExpenseCount.size() > 0)
			message = message.replace("{BILL_COUNT_AWAIT}", activeExpenseCount.get(0));
		System.out.println("Final message for Mark Expense::" + message);
		return message;
	}

	/**
	 * Send mark expense bill notification on 7th and 21st of each month
	 * 
	 * @param requestInfo
	 */

	public void sendMarkExpensebillEvent(RequestInfo requestInfo) {
		LocalDate dayofmonth = LocalDate.now().with(TemporalAdjusters.firstDayOfMonth());
		LocalDateTime scheduleTimeFirst = LocalDateTime.of(dayofmonth.getYear(), dayofmonth.getMonth(), 7, 10, 0, 0);
		LocalDateTime scheduleTimeSecond = LocalDateTime.of(dayofmonth.getYear(), dayofmonth.getMonth(), 21, 10, 0, 0);
		DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
		LocalDateTime currentTime = LocalDateTime.parse(LocalDateTime.now().format(dateTimeFormatter),
				dateTimeFormatter);

		List<String> tenantIds = repository.getTenantId();
		if (!currentTime.isEqual(scheduleTimeFirst) || currentTime.isEqual(scheduleTimeSecond)) {

			tenantIds.forEach(tenantId -> {
				if (tenantId.split("\\.").length >= 2) {
					if (null != config.getIsUserEventEnabled()) {
						if (config.getIsUserEventEnabled()) {
							EventRequest eventRequest = sendMarkExpensebillNotification(requestInfo, tenantId);
							if (null != eventRequest)
								notificationService.sendEventNotification(eventRequest);
						}
					}

					if (null != config.getIsSMSEnabled()) {
						if (config.getIsSMSEnabled()) {
							
							UserDetailResponse userDetailResponse = userService.getUserByRoleCodes(requestInfo,
									tenantId, Arrays.asList("EXPENSE_PROCESSING"));
							Map<String, String> mobileNumberIdMap = new LinkedHashMap<>();

							for (UserInfo userInfo : userDetailResponse.getUser())
								if (userInfo.getName() != null) {
									mobileNumberIdMap.put(userInfo.getMobileNumber(), userInfo.getName());
								} else {
									mobileNumberIdMap.put(userInfo.getMobileNumber(), userInfo.getUserName());
								}
							
							HashMap<String, String> messageMap = util.getLocalizationMessage(requestInfo,
									MARK_PAID_BILL_SMS, tenantId);

							mobileNumberIdMap.entrySet().stream().forEach(map -> {
								if (messageMap != null
										&& !StringUtils.isEmpty(messageMap.get(NotificationUtil.MSG_KEY))) {
									String message = messageMap.get(NotificationUtil.MSG_KEY);
									message = message.replace("{EXP_MRK_LINK}", getShortenedUrl(config.getExpenseBillMarkPaidLink()));

									message = message.replace("{GPWSC}", tenantId); // TODO Replace
									// <GPWSC> with
									// value.
									System.out.println("Mark expense bills SMS::" + message);
									SMSRequest smsRequest = SMSRequest.builder().mobileNumber(map.getKey())
											.message(message).templateId(messageMap.get(NotificationUtil.TEMPLATE_KEY))
											.users(new String[] { map.getValue() }).build();
									producer.push(config.getSmsNotifTopic(), smsRequest);
								}
							});
						}
					}
				}
			});
		}
	}

	public EventRequest sendMonthSummaryNotification(RequestInfo requestInfo, String tenantId) {

		List<ActionItem> items = new ArrayList<>();
		String actionLink = config.getMonthDashboardLink();
		ActionItem item = ActionItem.builder().actionUrl(actionLink).build();
		items.add(item);
		Action action = Action.builder().actionUrls(items).build();

		List<Event> events = new ArrayList<>();
		HashMap<String, String> messageMap = util.getLocalizationMessage(requestInfo, MONTHLY_SUMMARY_EVENT, tenantId);
		events.add(Event.builder().tenantId(tenantId)
				.description(formatMonthSummaryMessage(requestInfo, tenantId, messageMap.get(NotificationUtil.MSG_KEY)))
				.eventType(USREVENTS_EVENT_TYPE).name(USREVENTS_EVENT_NAME).postedBy(USREVENTS_EVENT_POSTEDBY)
				.recepient(getRecepient(requestInfo, tenantId)).source(Source.WEBAPP).eventDetails(null).actions(action)
				.build());

		if (!CollectionUtils.isEmpty(events)) {
			return EventRequest.builder().requestInfo(requestInfo).events(events).build();
		} else {
			return null;
		}
	}

	public String formatMonthSummaryMessage(RequestInfo requestInfo, String tenantId, String message) {

		LocalDate prviousMonthStart = LocalDate.now().minusMonths(1).with(TemporalAdjusters.firstDayOfMonth());
		LocalDate prviousMonthEnd = LocalDate.now().minusMonths(1).with(TemporalAdjusters.lastDayOfMonth());
		LocalDateTime previousMonthStartDateTime = LocalDateTime.of(prviousMonthStart.getYear(),
				prviousMonthStart.getMonth(), prviousMonthStart.getDayOfMonth(), 0, 0, 0);
		LocalDateTime previousMonthEndDateTime = LocalDateTime.of(prviousMonthEnd.getYear(), prviousMonthEnd.getMonth(),
				prviousMonthEnd.getDayOfMonth(), 23, 59, 59);


		Integer previousMonthCollection = repository.getPreviousMonthExpensePayments(tenantId,
				((Long) previousMonthStartDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()),
				((Long) previousMonthEndDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()));
		if (null != previousMonthCollection )
			message = message.replace("{PREVIOUS_MONTH_COLLECTION}", previousMonthCollection.toString());


		message = message.replace("{PREVIOUS_MONTH}", LocalDate.now().minusMonths(1).getMonth().toString());
		List<String> previousMonthExpense = repository.getPreviousMonthExpenseExpenses(tenantId,
				((Long) previousMonthStartDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli())
						.toString(),
				((Long) previousMonthEndDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()).toString());
		if (null != previousMonthExpense && previousMonthExpense.size() > 0)
			message = message.replace("{PREVIOUS_MONTH_EXPENSE}", previousMonthExpense.get(0));
		System.out.println("Final message::" + message);
		return message;
	}

	/**
	 * Send the month summary notification new calendar month
	 * 
	 * @param requestInfo
	 */

	public void sendMonthSummaryEvent(RequestInfo requestInfo) {
		LocalDate dayofmonth = LocalDate.now().with(TemporalAdjusters.firstDayOfMonth());
		LocalDateTime scheduleTime = LocalDateTime.of(dayofmonth.getYear(), dayofmonth.getMonth(),
				dayofmonth.getDayOfMonth(), 10, 0, 0);

		DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
		LocalDateTime currentTime = LocalDateTime.parse(LocalDateTime.now().format(dateTimeFormatter),
				dateTimeFormatter);

		List<String> tenantIds = repository.getTenantId();
		if (!currentTime.isEqual(scheduleTime)) {
			tenantIds.forEach(tenantId -> {
				if (tenantId.split("\\.").length >= 2) {
					if (null != config.getIsUserEventEnabled()) {
						if (config.getIsUserEventEnabled()) {
							EventRequest eventRequest = sendMonthSummaryNotification(requestInfo, tenantId);
							if (null != eventRequest)
								notificationService.sendEventNotification(eventRequest);
						}
					}

					if (null != config.getIsSMSEnabled()) {
						if (config.getIsSMSEnabled()) {
							HashMap<String, String> messageMap = util.getLocalizationMessage(requestInfo,
									MONTHLY_SUMMARY_SMS, tenantId);
							UserDetailResponse userDetailResponse = userService.getUserByRoleCodes(requestInfo, tenantId,
									Arrays.asList("EXPENSE_PROCESSING"));

							Map<String, String> mobileNumberIdMap = new LinkedHashMap<>();
							for (UserInfo userInfo : userDetailResponse.getUser())
								if (userInfo.getName() != null) {
									mobileNumberIdMap.put(userInfo.getMobileNumber(), userInfo.getName());
								} else {
									mobileNumberIdMap.put(userInfo.getMobileNumber(), userInfo.getUserName());
								}
							mobileNumberIdMap.entrySet().stream().forEach(map -> {
								if (messageMap != null
										&& !StringUtils.isEmpty(messageMap.get(NotificationUtil.MSG_KEY))) {
									String uuidUsername = (String) map.getValue();
									String message = formatMonthSummaryMessage(requestInfo, tenantId,
											messageMap.get(NotificationUtil.MSG_KEY));
									message = message.replace("{LINK}", getShortenedUrl(config.getMonthDashboardLink()));
									message = message.replace("{GPWSC}", tenantId); // TODO Replace
									// <GPWSC> with
									// value
									message = message.replace("{user}", uuidUsername);
									System.out.println("SMS Notification::" + message);
									SMSRequest smsRequest = SMSRequest.builder().mobileNumber(map.getKey())
											.message(message).templateId(messageMap.get(NotificationUtil.TEMPLATE_KEY))
											.users(new String[] { uuidUsername }).build();
									producer.push(config.getSmsNotifTopic(), smsRequest);
								}
							});
						}
					}
				}
			});

		}
	}

	public EventRequest sendPendingCollectionNotification(RequestInfo requestInfo, String tenantId) {

		List<ActionItem> items = new ArrayList<>();
		String actionLink = config.getMonthRevenueDashboardLink();
		ActionItem item = ActionItem.builder().actionUrl(actionLink).build();
		items.add(item);
		Action action = Action.builder().actionUrls(items).build();
		List<Event> events = new ArrayList<>();
		HashMap<String, String> messageMap = util.getLocalizationMessage(requestInfo, PENDING_COLLECTION_EVENT,
				tenantId);
		events.add(Event.builder().tenantId(tenantId)
				.description(
						formatPendingCollectionMessage(requestInfo, tenantId, messageMap.get(NotificationUtil.MSG_KEY)))
				.eventType(USREVENTS_EVENT_TYPE).name(USREVENTS_EVENT_NAME).postedBy(USREVENTS_EVENT_POSTEDBY)
				.recepient(getRecepient(requestInfo, tenantId)).source(Source.WEBAPP)
				.recepient(getRecepient(requestInfo, tenantId)).eventDetails(null).actions(action).build());

		if (!CollectionUtils.isEmpty(events)) {
			return EventRequest.builder().requestInfo(requestInfo).events(events).build();
		} else {
			return null;
		}

	}

	/**
	 * Send the pending collection notification every fortnight
	 * 
	 * @param requestInfo
	 */

	public void sendPendingCollectionEvent(RequestInfo requestInfo) {
		LocalDate dayofmonth = LocalDate.now().with(TemporalAdjusters.firstDayOfMonth());
		LocalDateTime scheduleTimeFirst = LocalDateTime.of(dayofmonth.getYear(), dayofmonth.getMonth(),
				dayofmonth.getDayOfMonth(), 10, 0, 0);
		LocalDateTime scheduleTimeSecond = LocalDateTime.of(dayofmonth.getYear(), dayofmonth.getMonth(), 15, 10, 0, 0);
		DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
		LocalDateTime currentTime = LocalDateTime.parse(LocalDateTime.now().format(dateTimeFormatter),
				dateTimeFormatter);

		List<String> tenantIds = repository.getTenantId();
		if (!currentTime.isEqual(scheduleTimeFirst) || currentTime.isEqual(scheduleTimeSecond)) {
			tenantIds.forEach(tenantId -> {
				if (tenantId.split("\\.").length >= 2) {
					if (null != config.getIsUserEventEnabled()) {
						if (config.getIsUserEventEnabled()) {
							EventRequest eventRequest = sendPendingCollectionNotification(requestInfo, tenantId);
							if (null != eventRequest)
								notificationService.sendEventNotification(eventRequest);
						}
					}

					if (null != config.getIsSMSEnabled()) {
						if (config.getIsSMSEnabled()) {
							HashMap<String, String> messageMap = util.getLocalizationMessage(requestInfo,
									PENDING_COLLECTION_SMS, tenantId);
							UserDetailResponse userDetailResponse = userService.getUserByRoleCodes(requestInfo,
									tenantId, Arrays.asList("GP_ADMIN"));

							Map<String, String> mobileNumberIdMap = new LinkedHashMap<>();

							for (UserInfo userInfo : userDetailResponse.getUser())
								if (userInfo.getName() != null) {
									mobileNumberIdMap.put(userInfo.getMobileNumber(), userInfo.getName());
								} else {
									mobileNumberIdMap.put(userInfo.getMobileNumber(), userInfo.getUserName());
								}
							mobileNumberIdMap.entrySet().stream().forEach(map -> {
								if (messageMap != null
										&& !StringUtils.isEmpty(messageMap.get(NotificationUtil.MSG_KEY))) {
									String uuidUsername = map.getValue();
									String message = formatPendingCollectionMessage(requestInfo, tenantId,
											messageMap.get(NotificationUtil.MSG_KEY));
									message = message.replace("{PENDING_COL_LINK}",
											getShortenedUrl(config.getMonthRevenueDashboardLink()));
									message = message.replace("{GPWSC}", tenantId);
									message = message.replace("{ownername}", uuidUsername);
									message = message.replace("{Date}", LocalDate.now().toString());
									System.out.println("PENDING Coll SMS::" + message);
									SMSRequest smsRequest = SMSRequest.builder().mobileNumber(map.getKey())
											.message(message)
											.templateId(messageMap.get(NotificationUtil.TEMPLATE_KEY))
											.users(new String[] { uuidUsername }).build();
									producer.push(config.getSmsNotifTopic(), smsRequest);
								}
							});
						}
					}
				}
			});
		}
	}

	public String formatPendingCollectionMessage(RequestInfo requestInfo, String tenantId, String message) {

		Map<String, Object> financialYear = getFinancialYear(requestInfo, tenantId);
		List<String> pendingCollection = repository.getPendingCollection(tenantId,
				financialYear.get("startingDate").toString(), financialYear.get("endingDate").toString());
		if (null != pendingCollection && pendingCollection.size() > 0)
			if (message.contains("{PENDING_COLLECTION}")) {
				if (pendingCollection.get(0) != null)
					message = message.replace(" {PENDING_COLLECTION} ", pendingCollection.get(0));
				else
					message = message.replace(" {PENDING_COLLECTION} ", "0");
				System.out.println("Final EVENT MEssage is :" + message);
			} else if (message.contains("{amount}")) {
				if (pendingCollection.get(0) != null)
					message = message.replace("{amount}", pendingCollection.get(0));
				else
					message = message.replace("{amount}", "0");
				System.out.println("Final SMS MEssage is :" + message);
			}if(message.contains("{TODAY_DATE}")) {
				message = message.replace("{TODAY_DATE}", LocalDate.now().toString());
			}
		System.out.println("Final message is :" + message);
		return message;
	}

	private Recepient getRecepient(RequestInfo requestInfo, String tenantId) {
		Recepient recepient = null;
		UserDetailResponse userDetailResponse = userService.getUserByRoleCodes(requestInfo, tenantId,
				Arrays.asList("GP_ADMIN"));
		if (userDetailResponse.getUser().isEmpty())
			log.error("Recepient is absent");
		else {
			List<String> toUsers = userDetailResponse.getUser().stream().map(UserInfo::getUuid)
					.collect(Collectors.toList());

			recepient = Recepient.builder().toUsers(toUsers).toRoles(null).build();
		}
		return recepient;
	}

	private Map<String, String> getMobilenumberUuidMap(RequestInfo requestInfo) {
		Recepient recepient = getRecepient(requestInfo, "pb");
		UserDetailResponse response = userService.getUserById(requestInfo, "pb", recepient.getToUsers());

		Map<String, String> mobileNumberIdMap = response.getUser().stream()
				.collect(Collectors.toMap(UserInfo::getMobileNumber, UserInfo::getName));
		return mobileNumberIdMap;
	}

	public void sendTodaysCollection(RequestInfo requestInfo) {

		LocalDate date = LocalDate.now();
		LocalDateTime scheduleTime = LocalDateTime.of(date.getYear(), date.getMonth(), date.getDayOfMonth(), 11, 59,
				59);

		DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
		LocalDateTime currentTime = LocalDateTime.parse(LocalDateTime.now().format(dateTimeFormatter),
				dateTimeFormatter);
		List<String> tenantIds = repository.getTenantId();

		if (!currentTime.isEqual(scheduleTime)) {
			tenantIds.forEach(tenantId -> {
				if (tenantId.split("\\.").length >= 2) {
					if (!currentTime.isEqual(scheduleTime)) {
						if (null != config.getIsUserEventEnabled()) {
							if (config.getIsUserEventEnabled()) {
								EventRequest eventRequest = sendDayCollectionNotification(requestInfo, tenantId);
								if (null != eventRequest)
									notificationService.sendEventNotification(eventRequest);
							}
						}

						if (null != config.getIsSMSEnabled()) {
							if (config.getIsSMSEnabled()) {
								List<String> messages = new ArrayList<String>();
								HashMap<String, String> messageMap = util.getLocalizationMessage(requestInfo,
										TODAY_CASH_COLLECTION_SMS, tenantId);
								String mode = "cash";
								String message = formatTodayCollectionMessage(requestInfo, tenantId,
										messageMap.get(NotificationUtil.MSG_KEY), mode);
								HashMap<String, String> onlineMessageMap = util.getLocalizationMessage(requestInfo,
										TODAY_ONLINE_COLLECTION_SMS, tenantId);
								messages.add(message);
								mode = "online";
//								String onlineMessage = formatTodayCollectionMessage(requestInfo, tenantId,
//										onlineMessageMap.get(NotificationUtil.MSG_KEY), mode);
//								messages.add(onlineMessage);
								UserDetailResponse userDetailResponse = userService.getUserByRoleCodes(requestInfo,
										tenantId, Arrays.asList("COLLECTION_OPERATOR"));
								Map<String, String> mobileNumberIdMap = new LinkedHashMap<>();

								for (UserInfo userInfo : userDetailResponse.getUser())
									if (userInfo.getName() != null) {
										mobileNumberIdMap.put(userInfo.getMobileNumber(), userInfo.getName());
									} else {
										mobileNumberIdMap.put(userInfo.getMobileNumber(), userInfo.getUserName());
									}
								mobileNumberIdMap.entrySet().stream().forEach(map -> {
									if (!messages.isEmpty()) {
										String uuidUsername = map.getValue();

										messages.forEach(msg -> {
											msg = msg.replace("{ownername}", uuidUsername);
											msg = msg.replace("{GPWSC}", tenantId);
											msg = msg.replace("{date}", LocalDate.now().toString());
											System.out.println("TODAY Coll SMS::" + msg);
											SMSRequest smsRequest = SMSRequest.builder().mobileNumber(map.getKey())
													.message(msg)
													.templateId(messageMap.get(NotificationUtil.TEMPLATE_KEY))
													.users(new String[] { uuidUsername }).build();
											producer.push(config.getSmsNotifTopic(), smsRequest);
										});
									}
								});
							}
						}
					}
				}
			});
		}
	}

	@SuppressWarnings("null")
	private EventRequest sendDayCollectionNotification(RequestInfo requestInfo, String tenantId) {
		// TODO Auto-generated method stub

		List<ActionItem> items = new ArrayList<>();
		String actionLink = config.getDayCollectionLink();
		ActionItem item = ActionItem.builder().actionUrl(actionLink).build();
		items.add(item);
		Action action = Action.builder().actionUrls(items).build();
		List<Event> events = new ArrayList<>();
		List<String> messages = new ArrayList<String>();
		HashMap<String, String> cashMessageMap = util.getLocalizationMessage(requestInfo, TODAY_CASH_COLLECTION,
				tenantId);
		String mode = "cash";
		String message = formatTodayCollectionMessage(requestInfo, tenantId,
				cashMessageMap.get(NotificationUtil.MSG_KEY), mode);
		HashMap<String, String> onlineMessageMap = util.getLocalizationMessage(requestInfo, TODAY_ONLINE_COLLECTION,
				tenantId);
		messages.add(message);
//		mode = "online";
//		String onlineMessage = formatTodayCollectionMessage(requestInfo, tenantId,
//				onlineMessageMap.get(NotificationUtil.MSG_KEY), mode);
//		messages.add(onlineMessage);
		for (String msg : messages) {
			events.add(Event.builder().tenantId(tenantId).description(msg).eventType(USREVENTS_EVENT_TYPE)
					.name(USREVENTS_EVENT_NAME).postedBy(USREVENTS_EVENT_POSTEDBY)
					.recepient(getRecepient(requestInfo, tenantId)).source(Source.WEBAPP).eventDetails(null)
					.actions(action).build());
		}

		if (!CollectionUtils.isEmpty(events)) {
			return EventRequest.builder().requestInfo(requestInfo).events(events).build();
		} else {
			return null;
		}

	}

	private String formatTodayCollectionMessage(RequestInfo requestInfo, String tenantId, String message, String mode) {
		// TODO Auto-generated method stub
		LocalDate today = LocalDate.now();
		LocalDateTime todayStartDateTime = LocalDateTime.of(today.getYear(), today.getMonth(), today.getDayOfMonth(), 0,
				0, 0);
		LocalDateTime todayEndDateTime = LocalDateTime.of(today.getYear(), today.getMonth(), today.getDayOfMonth(), 23,
				59, 59);
		List<Map<String, Object>> todayCollection = repository.getTodayCollection(tenantId,
				((Long) todayStartDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()).toString(),
				((Long) todayEndDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()).toString(), mode);

		if (null != todayCollection && todayCollection.size() > 0) {
			for (Map<String, Object> map : todayCollection) {
				for (Map.Entry<String, Object> entry : map.entrySet()) {
					String key = entry.getKey();
					Object value = entry.getValue();
					if (key.equalsIgnoreCase("sum")) {
						if (value != null)
							message = message.replace("{amount}", value.toString());
						else
							message = message.replace("{amount}", "0");
					}
					if (key.equalsIgnoreCase("count")) {
						if (message.contains("{no}")) {
							if (value != null)
								message = message.replace("{no}", value.toString());
							else
								message = message.replace("{no}", "0");
						} else if (message.contains("{number}")) {
							if (value != null)
								message = message.replace("{number}", value.toString());
							else
								message = message.replace("{number}", "0");
						}
					}
				}
				System.out.println("Final message is :" + message);
			}
		}
		return message;
	}

}
