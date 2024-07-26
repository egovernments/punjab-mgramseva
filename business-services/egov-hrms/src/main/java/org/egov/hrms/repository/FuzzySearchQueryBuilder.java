package org.egov.hrms.repository;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import lombok.extern.slf4j.Slf4j;
import org.egov.hrms.config.PropertiesManager;
import org.egov.hrms.web.contract.EmployeeSearchCriteria;
import org.egov.tracer.model.CustomException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.util.CollectionUtils;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

@Repository
@Slf4j
public class FuzzySearchQueryBuilder {
    private ObjectMapper mapper;

    private PropertiesManager config;

    @Autowired
    public FuzzySearchQueryBuilder(ObjectMapper mapper, PropertiesManager config) {
        this.mapper = mapper;
        this.config = config;
    }

    private static final String BASE_QUERY = "{\n" +
            "  \"from\": {{OFFSET}},\n" +
            "  \"size\": {{LIMIT}},\n" +
            "  \"sort\": {\n" +
            "    \"_score\": {\n" +
            "      \"order\": \"desc\"\n" +
            "    }\n" +
            "  },\n" +
            "  \"query\": {\n" +
            "  }\n" +
            "}";

    private static final String fuzzyQueryTemplate = "{\n" +
            "          \"match\": {\n" +
            "            \"{{VAR}}\": {\n" +
            "              \"query\": \"{{PARAM}}\",\n" +
            "              \"fuzziness\": \"{{FUZZINESS}}\"\n" +
            "            }\n" +
            "          }\n" +
            "        }";

    private static final String wildCardQueryTemplate = "{\n" +
            "          \"query_string\": {\n" +
            "            \"default_field\": \"{{VAR}}\",\n" +
            "            \"query\": \"*{{PARAM}}*\"\n" +
            "          }\n" +
            "        }";

    private static final String filterTemplate   = "\"filter\": { " +
            "      }";

    public String getFuzzySearchQuery(EmployeeSearchCriteria criteria, List<String> ids) {
        String finalQuery;

        try {
            // Generate base query with pagination
            String baseQuery = addPagination(criteria);
            JsonNode node = mapper.readTree(baseQuery);
            ObjectNode rootNode = (ObjectNode) node;
            ObjectNode insideMatch = (ObjectNode) rootNode.get("query");

            // Ensure the "bool" node is present
            ObjectNode boolNode = (ObjectNode) insideMatch.get("bool");
            if (boolNode == null) {
                boolNode = mapper.createObjectNode();
                insideMatch.set("bool", boolNode);
            }

            // Initialize the "must" array if it's not present
            ArrayNode mustArray = (ArrayNode) boolNode.get("must");
            if (mustArray == null) {
                mustArray = mapper.createArrayNode();
                boolNode.set("must", mustArray);
            }

            // Add fuzzy search clause for name if present in criteria
            if (criteria.getName() != null) {
                mustArray.add(getInnerNode(criteria.getName(), "Data.user.name", config.getNameFuziness()));
            }

            // Add filter by IDs if the list is not empty
            if (!CollectionUtils.isEmpty(ids)) {
                ObjectNode idsFilterNode = mapper.createObjectNode();
                idsFilterNode.set("terms", mapper.convertValue(new HashMap<String, List<String>>() {{
                    put("Data.id.keyword", ids);
                }}, JsonNode.class));
                boolNode.set("filter", idsFilterNode);
            }

            // Add filter for tenantId
            if (criteria.getTenantId() != null) {
                ObjectNode tenantFilterNode = mapper.createObjectNode();
                if (criteria.getTenantIds()!=null) {
                    // Handle tenantId as a list
                    JsonNode tenantIdNode = mapper.convertValue(new HashMap<String, List<String>>() {{
                        put("Data.tenantId", (List<String>) criteria.getTenantIds());
                    }}, JsonNode.class);
                    tenantFilterNode.set("terms", tenantIdNode);
                } else {
                    // Handle tenantId as a single value
                    JsonNode tenantIdNode = mapper.convertValue(new HashMap<String, String>() {{
                        put("Data.tenantId", criteria.getTenantId());
                    }}, JsonNode.class);
                    tenantFilterNode.set("term", tenantIdNode);
                }
                boolNode.set("filter", tenantFilterNode);
            }

            // Add filter for roles
            if (criteria.getRoles()!=null) {
                ArrayNode roleFilterArray = mapper.createArrayNode();
                for (String role : criteria.getRoles()) {
                    ObjectNode roleMatchNode = mapper.createObjectNode();
                    roleMatchNode.set("match", mapper.convertValue(new HashMap<String, String>() {{
                        put("Data.user.roles.code", role);
                    }}, JsonNode.class));
                    roleFilterArray.add(roleMatchNode);
                }
                ObjectNode roleBoolNode = mapper.createObjectNode();
                roleBoolNode.set("bool", mapper.convertValue(new HashMap<String, Object>() {{
                    put("should", roleFilterArray);
                }}, JsonNode.class));
                mustArray.add(roleBoolNode);
            }

            // Convert the final JSON node back to a string
            finalQuery = mapper.writeValueAsString(node);
        } catch (Exception e) {
            log.error("ES_ERROR", e);
            throw new CustomException("JSONNODE_ERROR", "Failed to build JSON query for fuzzy search");
        }

        log.info("finalQuery {}",finalQuery);
        return finalQuery;
    }

    private JsonNode getInnerNode(String param, String var, String fuziness) throws JsonProcessingException {

        String template;
        if(config.getIsSearchWildcardBased())
            template = wildCardQueryTemplate;
        else
            template = fuzzyQueryTemplate;
        String innerQuery = template.replace("{{PARAM}}",getEscapedString(param));
        innerQuery = innerQuery.replace("{{VAR}}",var);

        if(!config.getIsSearchWildcardBased())
            innerQuery = innerQuery.replace("{{FUZZINESS}}", fuziness);

        JsonNode innerNode = mapper.readTree(innerQuery);
        return innerNode;
    }

    private String addPagination(EmployeeSearchCriteria criteria) {

        Long limit = config.getDefaultLimit();
        Long offset = config.getDefaultOffset();

        if (criteria.getLimit() != null && criteria.getLimit() <= config.getMaxSearchLimit())
            limit = criteria.getLimit();

        if (criteria.getLimit() != null && criteria.getLimit() > config.getMaxSearchLimit())
            limit = config.getMaxSearchLimit();

        if (criteria.getOffset() != null)
            offset = criteria.getOffset();

        String baseQuery = BASE_QUERY.replace("{{OFFSET}}", offset.toString());
        baseQuery = baseQuery.replace("{{LIMIT}}", limit.toString());

        return baseQuery;
    }

    /**
     * Escapes special characters in given string
     * @param inputString
     * @return
     */
    private String getEscapedString(String inputString){
        final String[] metaCharacters = {"\\","/","^","$","{","}","[","]","(",")",".","*","+","?","|","<",">","-","&","%"};
        for (int i = 0 ; i < metaCharacters.length ; i++) {
            if (inputString.contains(metaCharacters[i])) {
                inputString = inputString.replace(metaCharacters[i], "\\\\" + metaCharacters[i]);
            }
        }
        return inputString;
    }
}
