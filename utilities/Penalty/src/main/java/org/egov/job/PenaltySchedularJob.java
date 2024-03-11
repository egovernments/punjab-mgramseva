package org.egov.job;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.egov.config.PenaltyShedularConfiguration;
import org.egov.model.AddPenaltyCriteria;
import org.egov.model.Tenant;
import org.egov.util.MDMSClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Component
@Slf4j
@AllArgsConstructor
@NoArgsConstructor
public class PenaltySchedularJob implements ApplicationRunner {

    @Autowired
    private MDMSClient mdmsClient;

    @Autowired
    private PenaltyShedularConfiguration adapterConfiguration;

    @Autowired
    private RestTemplate restTemplate;

    @Override
    public void run(ApplicationArguments args) throws Exception {

        try {
            List<Tenant> tenantList = mdmsClient.getTenants();
            System.out.println(tenantList.size());
            tenantList=tenantList.stream().filter(
                    tenant -> {
                        return adapterConfiguration.getPenaltyEnabledDivisionlist().contains(tenant.getDivisionCode());
                    }).collect(Collectors.toList());

            System.out.println(tenantList.size());

            tenantList.stream().forEach(tenant -> {

                addPenaltyEventToWaterCalculator(AddPenaltyCriteria.builder().tenantId(tenant.getCode()).build());

            });

        } catch (Exception e) {
            log.error("Exception occurred while running PenaltySchedularJob", e);
        }
    }

    public void addPenaltyEventToWaterCalculator(AddPenaltyCriteria penaltyCriteria) {
        log.info("Posting request to add Penalty for tenantid:" +penaltyCriteria.getTenantId());

        if (penaltyCriteria.getTenantId() != null) {
            try {
                restTemplate.put(getWaterConnnectionAddPennanltyUrl(), penaltyCriteria);

                log.info("Posted request to add Penalty for tenant:" + penaltyCriteria.getTenantId());
            } catch (RestClientException e) {
                log.error("Error while calling to water calculator service for tenant :" + penaltyCriteria.getTenantId() + " ERROR MESSAGE:" + e.getMessage(), e.getCause());
            }
        }
    }

    /**
     * @return - return iFix event publish url
     */
    public String getWaterConnnectionAddPennanltyUrl() {
        return (adapterConfiguration.getEgovWaterCalculatorHost() + adapterConfiguration.getEgovWaterCalculatorSearchUrl());
    }


}
