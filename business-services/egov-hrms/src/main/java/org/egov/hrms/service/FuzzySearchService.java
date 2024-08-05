package org.egov.hrms.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jayway.jsonpath.JsonPath;
import org.egov.common.contract.request.RequestInfo;
import org.egov.hrms.config.PropertiesManager;
import org.egov.hrms.model.Employee;
import org.egov.hrms.repository.ElasticSearchRepository;
import org.egov.hrms.repository.EmployeeRepository;
import org.egov.hrms.web.contract.EmployeeSearchCriteria;
import org.egov.tracer.model.CustomException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.*;

import static org.egov.hrms.utils.HRMSConstants.ES_DATA_PATH;

@Service
public class FuzzySearchService {
    @Autowired
    private ElasticSearchRepository elasticSearchRepository;
    @Autowired
    private ObjectMapper mapper;
    @Autowired
    private EmployeeRepository employeeRepository;
    @Autowired
    private PropertiesManager config;

    public List<Employee> getEmployees(RequestInfo requestInfo, EmployeeSearchCriteria criteria) {

        if(criteria.getTenantId() == null)
        {	criteria.setTenantId(config.getStateLevelTenantId()); }

        List<String> idsFromDB = employeeRepository.fetchEmployeesforAssignment(criteria,requestInfo);

//        if(CollectionUtils.isEmpty(idsFromDB))
//            return new LinkedList<>();

        validateFuzzySearchCriteria(criteria);

        Object esResponse = elasticSearchRepository.fuzzySearchEmployees(criteria, idsFromDB);

        Map<String, Set<String>> tenantIdToEmpId = getTenantIdToEmpIdMap(esResponse);

        List<Employee> employees = new LinkedList<>();

        for (Map.Entry<String, Set<String>> entry : tenantIdToEmpId.entrySet()) {
            String tenantId = entry.getKey();
            Set<String> empIds = entry.getValue();
            List<String> empList = new ArrayList<>(empIds);

            EmployeeSearchCriteria employeeSearchCriteria = EmployeeSearchCriteria.builder().tenantId(tenantId).codes(empList).build();

            employees.addAll(employeeRepository.fetchEmployees(employeeSearchCriteria, requestInfo));

        }

        return employees;
    }
    private void validateFuzzySearchCriteria(EmployeeSearchCriteria criteria){

        if(criteria.getName() == null)
            throw new CustomException("INVALID_SEARCH_CRITERIA","The search criteria is invalid");

    }
    private Map<String, Set<String>> getTenantIdToEmpIdMap(Object esResponse) {

        List<Map<String, Object>> data;
        Map<String, Set<String>> tenantIdToEmpIds = new LinkedHashMap<>();


        try {
            data = JsonPath.read(esResponse, ES_DATA_PATH);


            if (!CollectionUtils.isEmpty(data)) {

                for (Map<String, Object> map : data) {

                    String tenantId = JsonPath.read(map, "$.tenantData.code");
                    String empId = JsonPath.read(map, "$.code");
                    if (tenantIdToEmpIds.containsKey(tenantId))
                        tenantIdToEmpIds.get(tenantId).add(empId);
                    else {
                        Set<String> empIds = new HashSet<>();
                        empIds.add(empId);
                        tenantIdToEmpIds.put(tenantId, empIds);
                    }

                }

            }

        } catch (Exception e) {
            throw new CustomException("PARSING_ERROR", "Failed to extract employeeIds from es response");
        }

        return tenantIdToEmpIds;
    }
}
