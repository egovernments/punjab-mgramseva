package digit.kafka;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import digit.config.ApplicationProperties;
import digit.web.models.MdmsRequest;
import digit.web.models.Mdms;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Component
@Slf4j
public class Consumer {

    @Autowired
    private ObjectMapper mapper;

    @Autowired
    private ApplicationProperties config;

    /*
     * Uncomment the below line to start consuming record from kafka.topics.consumer
     * Value of the variable kafka.topics.consumer should be overwritten in application.properties
     */
    @KafkaListener(topics = {"${kafka.topics.push.boundary}"})
    public void createTenantWithPushBoundary(final HashMap<String, String> villageData) {
        try {
            // Convert the villageData to a nested structure
            Mdms mdms = Mdms.builder()
                    .tenantId("pb")
                    .schemaCode("tenant.tenants")
                    .data(convertToDataStructure(villageData))
                    .isActive(true)
                    .build();

            MdmsRequest mdmsRequest = MdmsRequest.builder()
                    .mdms(mdms)
                    .build();

            log.info(mdmsRequest.toString());

            // Call the external API with the constructed MdmsRequest
            sendDataToExternalApi(mdmsRequest);
        } catch (Exception ex) {
            log.info("Error processing village data from topic: kafka.topics.push.boundary", ex);
        }
    }

    private JsonNode convertToDataStructure(Map<String, String> villageData) {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.convertValue(villageData, JsonNode.class);
    }

    private void sendDataToExternalApi(MdmsRequest mdmsRequest) {
        try {
            // Construct the API URL
            String url = config.getMdmsHost() + config.getMdmsv2Endpoint() + "/tenant.tenants";

            RestTemplate restTemplate = new RestTemplate();
            // Send POST request
             Map<String, Object> response = restTemplate.postForObject(url, mdmsRequest, Map.class);

            // Handle response
             if (response != null && !response.isEmpty()) {
                 log.info("Successfully pushed data to external API: {}", response);
             } else {
                 log.info("Failed to push data to external API. Empty or null response.");
             }
        } catch (Exception ex) {
            log.info("Error sending data to external API", ex);
        }
    }
}
