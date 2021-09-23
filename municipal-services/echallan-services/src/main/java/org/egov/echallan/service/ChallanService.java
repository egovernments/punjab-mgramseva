package org.egov.echallan.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Month;
import java.time.YearMonth;
import java.time.ZoneId;
import java.time.temporal.TemporalAdjusters;
import java.util.Calendar;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.egov.common.contract.request.RequestInfo;
import org.egov.echallan.expense.service.PaymentService;
import org.egov.echallan.expense.validator.ExpenseValidator;
import org.egov.echallan.model.Challan;
import org.egov.echallan.model.Challan.StatusEnum;
import org.egov.echallan.model.ChallanRequest;
import org.egov.echallan.model.LastMonthSummary;
import org.egov.echallan.model.SearchCriteria;
import org.egov.echallan.repository.ChallanRepository;
import org.egov.echallan.util.CommonUtils;
import org.egov.echallan.validator.ChallanValidator;
import org.egov.echallan.web.models.user.UserDetailResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;


@Service
public class ChallanService {

    @Autowired
    private EnrichmentService enrichmentService;

    private UserService userService;
    
    private ChallanRepository repository;
    
    private CalculationService calculationService;
    
    private ChallanValidator validator;
    
    private ExpenseValidator expenseValidator;

    private CommonUtils utils;
    
    private PaymentService paymentService;

    
	@Autowired
	public ChallanService(EnrichmentService enrichmentService, UserService userService, ChallanRepository repository,
			CalculationService calculationService, ChallanValidator validator, CommonUtils utils,
			ExpenseValidator expenseValidator, PaymentService paymentService) {
		this.enrichmentService = enrichmentService;
		this.userService = userService;
		this.repository = repository;
		this.calculationService = calculationService;
		this.validator = validator;
		this.utils = utils;
		this.expenseValidator = expenseValidator;
		this.paymentService = paymentService;
	}
    
	/**
	 * Enriches the Request and pushes to the Queue
	 *
	 * @param request ChallanRequest containing list of challans to be created
	 * @return Challan successfully created
	 */
	public Challan create(ChallanRequest request) {
		Object mdmsData = utils.mDMSCall(request);
		expenseValidator.validateFields(request, mdmsData);
		validator.validateFields(request, mdmsData);
		enrichmentService.enrichCreateRequest(request);
	//	userService.createUser(request);
		userService.setAccountUser(request);
		calculationService.addCalculation(request);
		paymentService.createPayment(request);  // If the Expense bill  is paid then post payment. 
		repository.save(request);
		return request.getChallan();
	}
	
	
	 public List<Challan> search(SearchCriteria criteria, RequestInfo requestInfo, Map<String, String> finalData){
	        List<Challan> challans;
	        //enrichmentService.enrichSearchCriteriaWithAccountId(requestInfo,criteria);
	         if(criteria.getMobileNumber()!=null){
	        	 challans = getChallansFromMobileNumber(criteria,requestInfo, finalData);
	         }
	         else {
	        	 challans = getChallansWithOwnerInfo(criteria,requestInfo, finalData);
	         }
	       return challans;
	    }
	 
	 public List<Challan> getChallansFromMobileNumber(SearchCriteria criteria, RequestInfo requestInfo, Map<String, String> finalData){
		 List<Challan> challans = new LinkedList<>();
	        UserDetailResponse userDetailResponse = userService.getUser(criteria,requestInfo);
	        if(CollectionUtils.isEmpty(userDetailResponse.getUser())){
	            return Collections.emptyList();
	        }
	        enrichmentService.enrichSearchCriteriaWithOwnerids(criteria,userDetailResponse);
	        challans = repository.getChallans(criteria, finalData);
	        if(CollectionUtils.isEmpty(challans)){
	            return Collections.emptyList();
	        }

	        criteria=enrichmentService.getChallanCriteriaFromIds(challans);
	        challans = getChallansWithOwnerInfo(criteria,requestInfo, finalData);
	        return challans;
	    }
	 
	 public List<Challan> getChallansWithOwnerInfo(SearchCriteria criteria,RequestInfo requestInfo, Map<String, String> finalData){
		 List<Challan> challans = repository.getChallans(criteria, finalData);
	        if(challans.isEmpty())
	            return Collections.emptyList();
	        challans = enrichmentService.enrichChallanSearch(challans,criteria,requestInfo);
	        return challans;
	    }
	 
	 public List<Challan> searchChallans(ChallanRequest request, Map<String, String> finalData){
	        SearchCriteria criteria = new SearchCriteria();
	        List<String> ids = new LinkedList<>();
	        ids.add(request.getChallan().getId());

	        criteria.setTenantId(request.getChallan().getTenantId());
	        criteria.setIds(ids);
	        criteria.setBusinessService(request.getChallan().getBusinessService());

	        List<Challan> challans = repository.getChallans(criteria, finalData);
	        if(challans.isEmpty())
	            return Collections.emptyList();
	        challans = enrichmentService.enrichChallanSearch(challans,criteria,request.getRequestInfo());
	        return challans;
	    }
	 
	 public Challan update(ChallanRequest request, Map<String, String> finalData) {
			Object mdmsData = utils.mDMSCall(request);
			expenseValidator.validateFields(request, mdmsData);
			validator.validateFields(request, mdmsData);
			List<Challan> searchResult = searchChallans(request, finalData);
			validator.validateUpdateRequest(request, searchResult);
			expenseValidator.validateUpdateRequest(request, searchResult);
			userService.setAccountUser(request);
			enrichmentService.enrichUpdateRequest(request);
			calculationService.addCalculation(request);
			if (request.getChallan().getApplicationStatus() == StatusEnum.PAID && searchResult.get(0).getApplicationStatus() == StatusEnum.ACTIVE)
				paymentService.createPayment(request);
			if (searchResult.get(0).getApplicationStatus() == StatusEnum.PAID)
				paymentService.updatePayment(request);
			repository.update(request);
			return request.getChallan();
		}

	public LastMonthSummary getLastMonthSummary(SearchCriteria criteria, RequestInfo requestInfo) {

		LastMonthSummary lastMonthSummary = new LastMonthSummary();
		String tenantId = criteria.getTenantId();
		LocalDate currentMonthDate = LocalDate.now();
		if(criteria.getCurrentDate() !=null) {
			Calendar currentDate =Calendar.getInstance();
			currentDate.setTimeInMillis(criteria.getCurrentDate());
			currentMonthDate = LocalDate.of(currentDate.get(Calendar.YEAR),currentDate.get(Calendar.MONTH)+1, currentDate.get(Calendar.DAY_OF_MONTH));
		}
		LocalDate prviousMonthStart = currentMonthDate.minusMonths(1).with(TemporalAdjusters.firstDayOfMonth());
		LocalDate prviousMonthEnd = currentMonthDate.minusMonths(1).with(TemporalAdjusters.lastDayOfMonth());

		LocalDateTime previousMonthStartDateTime = LocalDateTime.of(prviousMonthStart.getYear(),
				prviousMonthStart.getMonth(), prviousMonthStart.getDayOfMonth(), 0, 0, 0);
		LocalDateTime previousMonthEndDateTime = LocalDateTime.of(prviousMonthEnd.getYear(), prviousMonthEnd.getMonth(),
				prviousMonthEnd.getDayOfMonth(), 23, 59, 59);

		// actual payments
		Integer previousMonthExpensePayments = repository.getPreviousMonthExpensePayments(tenantId,
				((Long) previousMonthStartDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()),
				((Long) previousMonthEndDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()));
		if (null != previousMonthExpensePayments)
			lastMonthSummary.setPreviousMonthCollection(previousMonthExpensePayments.toString());

		// new expenditure
		Integer previousMonthNewExpense = repository.getPreviousMonthNewExpense(tenantId,
				((Long) previousMonthStartDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()),
				((Long) previousMonthEndDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()));
		if (null != previousMonthNewExpense )
			lastMonthSummary.setPreviousMonthNewExpense(previousMonthNewExpense.toString());

		// pending expenes to be paid
		Integer cumulativePendingExpense = repository.getCumulativePendingExpense(tenantId);
		if (null != cumulativePendingExpense )
			lastMonthSummary.setCumulativePendingExpense(cumulativePendingExpense.toString());

		//pending ws collectioni
		Integer cumulativePendingCollection = repository.getTotalPendingCollection(tenantId);
		if (null != cumulativePendingExpense )
			lastMonthSummary.setCumulativePendingCollection(cumulativePendingCollection.toString());

		// ws demands in period
		Integer newDemand = repository.getNewDemand(tenantId,
				((Long) previousMonthStartDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()),
				((Long) previousMonthEndDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()));
		if (null != newDemand )
			lastMonthSummary.setNewDemand(newDemand.toString());

		// actuall ws collection
		Integer actualCollection = repository.getActualCollection(tenantId,
				((Long) previousMonthStartDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()),
				((Long) previousMonthEndDateTime.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli()));
		if (null != actualCollection )
			lastMonthSummary.setActualCollection(actualCollection.toString());

		lastMonthSummary.setPreviousMonthYear(getMonthYear());
		
		return lastMonthSummary;

	}
	public String getMonthYear() {
		LocalDateTime localDateTime = LocalDateTime.now();
		int currentMonth = localDateTime.getMonthValue();
		String monthYear ;
		if (currentMonth >= Month.APRIL.getValue()) {
			monthYear = YearMonth.now().getYear() + "-";
			monthYear = monthYear
					+ (Integer.toString(YearMonth.now().getYear() + 1).substring(2, monthYear.length() - 1));
		} else {
			monthYear = YearMonth.now().getYear() - 1 + "-";
			monthYear = monthYear
					+ (Integer.toString(YearMonth.now().getYear()).substring(2, monthYear.length() - 1));

		}
		localDateTime.minusMonths(1);
		StringBuilder monthYearBuilder = new StringBuilder(localDateTime.getMonth().toString()).append(" ").append(monthYear);

		return monthYearBuilder.toString() ;
	}
	
}