package org.egov.echallan.service;

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

import org.egov.common.contract.request.RequestInfo;
import org.egov.echallan.expense.service.PaymentService;
import org.egov.echallan.expense.validator.ExpenseValidator;
import org.egov.echallan.model.Challan;
import org.egov.echallan.model.Challan.StatusEnum;
import org.egov.echallan.model.ChallanRequest;
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
	
	
	 public List<Challan> search(SearchCriteria criteria, RequestInfo requestInfo){
	        List<Challan> challans;
	        //enrichmentService.enrichSearchCriteriaWithAccountId(requestInfo,criteria);
	         if(criteria.getMobileNumber()!=null){
	        	 challans = getChallansFromMobileNumber(criteria,requestInfo);
	         }
	         else {
	        	 challans = getChallansWithOwnerInfo(criteria,requestInfo);
	         }
	       return challans;
	    }
	 
	 public List<Challan> getChallansFromMobileNumber(SearchCriteria criteria, RequestInfo requestInfo){
		 List<Challan> challans = new LinkedList<>();
	        UserDetailResponse userDetailResponse = userService.getUser(criteria,requestInfo);
	        if(CollectionUtils.isEmpty(userDetailResponse.getUser())){
	            return Collections.emptyList();
	        }
	        enrichmentService.enrichSearchCriteriaWithOwnerids(criteria,userDetailResponse);
	        challans = repository.getChallans(criteria);

	        if(CollectionUtils.isEmpty(challans)){
	            return Collections.emptyList();
	        }

	        criteria=enrichmentService.getChallanCriteriaFromIds(challans);
	        challans = getChallansWithOwnerInfo(criteria,requestInfo);
	        return challans;
	    }
	 
	 public List<Challan> getChallansWithOwnerInfo(SearchCriteria criteria,RequestInfo requestInfo){
	        List<Challan> challans = repository.getChallans(criteria);
	        if(challans.isEmpty())
	            return Collections.emptyList();
	        challans = enrichmentService.enrichChallanSearch(challans,criteria,requestInfo);
	        return challans;
	    }
	 
	 public List<Challan> searchChallans(ChallanRequest request){
	        SearchCriteria criteria = new SearchCriteria();
	        List<String> ids = new LinkedList<>();
	        ids.add(request.getChallan().getId());

	        criteria.setTenantId(request.getChallan().getTenantId());
	        criteria.setIds(ids);
	        criteria.setBusinessService(request.getChallan().getBusinessService());

	        List<Challan> challans = repository.getChallans(criteria);

	        if(challans.isEmpty())
	            return Collections.emptyList();
	        challans = enrichmentService.enrichChallanSearch(challans,criteria,request.getRequestInfo());
	        return challans;
	    }
	 
	 public Challan update(ChallanRequest request) {
			Object mdmsData = utils.mDMSCall(request);
			expenseValidator.validateFields(request, mdmsData);
			validator.validateFields(request, mdmsData);
			List<Challan> searchResult = searchChallans(request);
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

	
}