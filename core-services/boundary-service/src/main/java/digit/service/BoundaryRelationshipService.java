package digit.service;

import digit.config.ApplicationProperties;
import digit.kafka.Producer;
import digit.repository.BoundaryRelationshipRepository;
import digit.service.enrichment.BoundaryRelationshipEnricher;
import digit.service.validator.BoundaryRelationshipValidator;
import digit.util.HierarchyUtil;
import digit.web.models.*;
import lombok.extern.slf4j.Slf4j;
import org.egov.common.contract.request.RequestInfo;
import org.egov.common.utils.ResponseInfoUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.web.client.RestTemplate;

import java.util.*;
import java.util.stream.Collectors;

@Service
@Slf4j
public class BoundaryRelationshipService {

    private BoundaryRelationshipValidator boundaryRelationshipValidator;

    private BoundaryRelationshipEnricher boundaryRelationshipEnricher;

    private BoundaryRelationshipRepository boundaryRelationshipRepository;

    private HierarchyUtil hierarchyUtil;

    @Autowired
    private ApplicationProperties config;

    @Autowired
    private Producer producer;

    public BoundaryRelationshipService(BoundaryRelationshipValidator boundaryRelationshipValidator, BoundaryRelationshipEnricher boundaryRelationshipEnricher,
                                       BoundaryRelationshipRepository boundaryRelationshipRepository, HierarchyUtil hierarchyUtil) {
        this.boundaryRelationshipValidator = boundaryRelationshipValidator;
        this.boundaryRelationshipEnricher = boundaryRelationshipEnricher;
        this.boundaryRelationshipRepository = boundaryRelationshipRepository;
        this.hierarchyUtil = hierarchyUtil;
    }

    /**
     * Request handler for processing boundary relationship create requests.
     * @param body
     * @return
     */
    public BoundaryRelationshipResponse createBoundaryRelationship(BoundaryRelationshipRequest body) {

        // Validate boundary relationship and get ancestral materialized path if successfully validated
        String ancestralMaterializedPath = boundaryRelationshipValidator.validateBoundaryRelationshipCreateRequest(body);

        // Enrich boundary relationship
        boundaryRelationshipEnricher.enrichBoundaryRelationshipCreateRequest(body, ancestralMaterializedPath);

        // Delegate request to repository
        boundaryRelationshipRepository.create(body);

        // Create boundary relationship response and return
        return BoundaryRelationshipResponse.builder()
                .responseInfo(ResponseInfoUtil.createResponseInfoFromRequestInfo(body.getRequestInfo(), Boolean.TRUE))
                .tenantBoundary(Collections.singletonList(body.getBoundaryRelationship()))
                .build();

    }

    /**
     * Request handler for processing boundary relationship search requests.
     * @param boundaryRelationshipSearchCriteria
     * @return
     */
    public BoundarySearchResponse getBoundaryRelationships(BoundaryRelationshipSearchCriteria boundaryRelationshipSearchCriteria, RequestInfo requestInfo) {

        // Enrich search criteria
        boundaryRelationshipEnricher.enrichSearchCriteria(boundaryRelationshipSearchCriteria);

        // Get list of boundary relationships based on provided search criteria
        List<BoundaryRelationshipDTO> boundaries = boundaryRelationshipRepository.search(boundaryRelationshipSearchCriteria);

        // Get parent boundaries if includeParents flag is checked
        List<BoundaryRelationshipDTO> parentBoundaries = getParentBoundaries(boundaries, boundaryRelationshipSearchCriteria);

        // Get children boundaries if includeChildren flag is checked
        List<BoundaryRelationshipDTO> childrenBoundaries = getChildrenBoundaries(boundaries, boundaryRelationshipSearchCriteria);

        // Add parents and children boundaries to main boundary search list
        addParentsAndChildrenToBoundariesList(boundaries, parentBoundaries, childrenBoundaries);

        // Prepare search response for boundary search
        BoundarySearchResponse boundarySearchResponse = boundaryRelationshipEnricher.createBoundaryRelationshipSearchResponse(boundaries, boundaryRelationshipSearchCriteria.getTenantId(), boundaryRelationshipSearchCriteria.getHierarchyType(), requestInfo);

        // Return boundary search response
        return boundarySearchResponse;
    }

    /**
     * Service method to fetch children boundary DTOs.
     * @param boundaries
     * @param boundaryRelationshipSearchCriteria
     * @return
     */
    private List<BoundaryRelationshipDTO> getChildrenBoundaries(List<BoundaryRelationshipDTO> boundaries, BoundaryRelationshipSearchCriteria boundaryRelationshipSearchCriteria) {
        List<BoundaryRelationshipDTO> childrenBoundaries = new ArrayList<>();

        // Fetch children boundary DTOs if includeChildren flag is set to true.
        if (!CollectionUtils.isEmpty(boundaries) && boundaryRelationshipSearchCriteria.getIncludeChildren()) {
            List<String> currentBoundaryCodes = boundaries.stream()
                    .map(BoundaryRelationshipDTO::getCode)
                    .collect(Collectors.toList());

            childrenBoundaries = boundaryRelationshipRepository.search(BoundaryRelationshipSearchCriteria.builder()
                    .tenantId(boundaryRelationshipSearchCriteria.getTenantId())
                    .hierarchyType(boundaryRelationshipSearchCriteria.getHierarchyType())
                    .currentBoundaryCodes(currentBoundaryCodes)
                    .build());
        }

        return childrenBoundaries;
    }

    /**
     * Service method to fetch parent boundary DTOs.
     * @param boundaries
     * @param boundaryRelationshipSearchCriteria
     * @return
     */
    private List<BoundaryRelationshipDTO> getParentBoundaries(List<BoundaryRelationshipDTO> boundaries, BoundaryRelationshipSearchCriteria boundaryRelationshipSearchCriteria) {
        List<BoundaryRelationshipDTO> parentBoundaries = new ArrayList<>();

        // Fetch parent boundaries if includeParents flag is true.
        if (!CollectionUtils.isEmpty(boundaries) && boundaryRelationshipSearchCriteria.getIncludeParents()) {
            Set<String> allAncestorCodes = boundaries.stream()
                    .map(dto -> dto.getAncestralMaterializedPath().split("\\|"))
                    .flatMap(Arrays::stream)
                    .collect(Collectors.toSet());

            parentBoundaries = boundaryRelationshipRepository.search(BoundaryRelationshipSearchCriteria.builder()
                    .tenantId(boundaryRelationshipSearchCriteria.getTenantId())
                    .hierarchyType(boundaryRelationshipSearchCriteria.getHierarchyType())
                    .codes(new ArrayList<>(allAncestorCodes))
                    .build());
        }

        return parentBoundaries;
    }

    /**
     * Request handler for processing boundary relationship update requests.
     * @param body
     * @return
     */
    public BoundaryRelationshipResponse updateBoundaryRelationship(BoundaryRelationshipRequest body) {

        // Validate update request
        BoundaryRelationshipRequestDTO validatedRelationshipDTORequest = boundaryRelationshipValidator.validateBoundaryRelationshipUpdateRequest(body);

        // Enrich update request
        String oldParentCode = boundaryRelationshipEnricher.enrichBoundaryRelationshipUpdateRequest(body, validatedRelationshipDTORequest);

        // Fetch children boundaries
        List<BoundaryRelationshipDTO> childrenBoundaryRelationships = getChildrenBoundaries(Collections
                .singletonList(validatedRelationshipDTORequest.getBoundaryRelationshipDTO()), BoundaryRelationshipSearchCriteria.builder()
                .tenantId(validatedRelationshipDTORequest.getBoundaryRelationshipDTO().getTenantId())
                .hierarchyType(validatedRelationshipDTORequest.getBoundaryRelationshipDTO().getHierarchyType())
                .includeChildren(Boolean.TRUE)
                .build());

        // Update ancestral materialized path of children boundary relationships
        preProcessNodesForUpdate(validatedRelationshipDTORequest, childrenBoundaryRelationships, oldParentCode);

        // Delegate request to repository
        boundaryRelationshipRepository.update(validatedRelationshipDTORequest);

        // Return response
        return BoundaryRelationshipResponse.builder()
                .responseInfo(ResponseInfoUtil.createResponseInfoFromRequestInfo(body.getRequestInfo(), Boolean.TRUE))
                .tenantBoundary(Collections.singletonList(body.getBoundaryRelationship()))
                .build();
    }

    /**
     * This method updates ancestral materialized path in the node being updated along with its
     * children nodes.
     * @param validatedRelationshipDTORequest
     * @param childrenBoundaryRelationships
     * @param oldParentCode
     */
    private void preProcessNodesForUpdate(BoundaryRelationshipRequestDTO validatedRelationshipDTORequest, List<BoundaryRelationshipDTO> childrenBoundaryRelationships, String oldParentCode) {
        // Add children boundary relationships to the list of nodes to be updated
        List<BoundaryRelationshipDTO> allNodesToBeUpdated = new ArrayList<>(childrenBoundaryRelationships);

        // Add the concerned boundary relationship which is being updated
        allNodesToBeUpdated.add(validatedRelationshipDTORequest.getBoundaryRelationshipDTO());

        // For each node, update ancestral materialized path - replace old parent code with new parent code
        allNodesToBeUpdated.forEach(boundaryRelationship -> {
            boundaryRelationship.setAncestralMaterializedPath(boundaryRelationship.getAncestralMaterializedPath()
                    .replace(oldParentCode,
                            validatedRelationshipDTORequest.getBoundaryRelationshipDTO().getParent()));
        });

        // Set list of nodes to be updated
        validatedRelationshipDTORequest.setBoundaryRelationshipDTOList(allNodesToBeUpdated);

    }

    /**
     * Add parent and children boundaries to searched boundaries list.
     * @param boundaries
     * @param parentBoundaries
     * @param childrenBoundaries
     */
    private void addParentsAndChildrenToBoundariesList(List<BoundaryRelationshipDTO> boundaries, List<BoundaryRelationshipDTO> parentBoundaries, List<BoundaryRelationshipDTO> childrenBoundaries) {
        boundaries.addAll(parentBoundaries);
        boundaries.addAll(childrenBoundaries);
    }

    public void fetchBoundaryAndProcess(String tenantId, String hierarchyType, boolean includeChildren,RequestInfo requestInfo) {
        String url = config.getBoundaryServiceHost() + config.getBoundaryServiceUri() +
                "?tenantId=" + tenantId +
                "&hierarchyType=" + hierarchyType +
                "&includeChildren=" + includeChildren;
        log.info("Url for search is "+url);

        RestTemplate restTemplate = new RestTemplate();
        Map<String, Object> response = restTemplate.postForObject(url, requestInfo, Map.class);

        if (response != null && response.containsKey("TenantBoundary")) {
            List<Map<String, Object>> tenantBoundaries = (List<Map<String, Object>>) response.get("TenantBoundary");
            if (tenantBoundaries != null && !tenantBoundaries.isEmpty()) {
                processBoundaryData(tenantBoundaries);
            } else {
                // Handle empty TenantBoundary case
                log.info("TenantBoundary is empty for hierarchyType: " + hierarchyType);
            }
        } else {
            // Handle response being null or missing TenantBoundary
            log.info("Invalid response received from boundary service. Response: " + response);
        }
    }

    private void processBoundaryData(List<Map<String, Object>> tenantBoundaries) {
//        if (tenantBoundaries == null || tenantBoundaries.isEmpty()) {
//            log.info("Tenant boundaries list is null or empty.");
//            return;
//        }
        for (Map<String, Object> tenantBoundary : tenantBoundaries) {
            List<Map<String, Object>> boundaries = (List<Map<String, Object>>) tenantBoundary.get("boundary");
            if (boundaries != null && !boundaries.isEmpty()) {
                searchForVillageBoundaries(boundaries, new HashMap<>());
            } else {
                // Handle empty or null boundary list
                log.info("Boundaries list is empty or null for tenantBoundary: " + tenantBoundary);
            }
        }
    }

    private void searchForVillageBoundaries(List<Map<String, Object>> boundaries, Map<String, String> parentDetails) {
        if (boundaries == null || boundaries.isEmpty()) {
            log.info("Boundaries list is null, skipping...");
            return;
        }

        for (Map<String, Object> boundary : boundaries) {
            if (boundary == null) {
                log.info("Boundary object is null, skipping...");
            }

            String boundaryType = (String) boundary.get("boundaryType");
            String code = (String) boundary.get("code");

            if (boundaryType == null || code == null) {
                log.info("BoundaryType or Code is null, skipping boundary: " + boundary);
            }

            // Store hierarchy details based on boundary type
            updateParentDetails(boundaryType, code, parentDetails);

            if ("village".equalsIgnoreCase(boundaryType)) {
                // Create a map with required village details
                Map<String, String> villageData = createVillageData(code, parentDetails);
                // Push data to Kafka
                producer.push(config.getCreateNewTenantTopic(), villageData);
            }
            // Recursively check children
            List<Map<String, Object>> children = (List<Map<String, Object>>) boundary.get("children");
            if (children != null && !children.isEmpty()) {
                searchForVillageBoundaries(children, parentDetails);
            }
//            else {
//                log.info("No children found for boundary: " + boundary);
//            }
        }
    }

    private void updateParentDetails(String boundaryType, String code, Map<String, String> parentDetails) {
        switch (boundaryType.toLowerCase()) {
            case "zone":
                parentDetails.put("Zone Code", code);
                parentDetails.put("Zone Name", extractNameFromCode(code));
                break;
            case "circle":
                parentDetails.put("Circle Code", code);
                parentDetails.put("Circle Name", extractNameFromCode(code));
                break;
            case "division":
                parentDetails.put("Division Code", code);
                parentDetails.put("Division Name", extractNameFromCode(code));
                break;
            case "sub division":
                parentDetails.put("SubDivision Code", code);
                parentDetails.put("SubDivision Name", extractNameFromCode(code));
                break;
            case "section":
                parentDetails.put("Section Code", code);
                parentDetails.put("Section Name", extractNameFromCode(code));
                break;
        }
    }

    private Map<String, String> createVillageData(String code, Map<String, String> parentDetails) {
        Map<String, String> villageData = new HashMap<>();
        villageData.put("code", code);
        villageData.put("name", extractNameFromCode(code));
        villageData.put("address", extractNameFromCode(code)); // Address = village name
        villageData.put("description", extractNameFromCode(code)); // Description = village name
        villageData.put("DDR Name", extractNameFromCode(code));
        villageData.put("Scheme Code", code);  // Set scheme code
        villageData.put("Scheme Name", extractNameFromCode(code));  // Scheme name same as village name

        // Set hierarchy details
        villageData.putAll(parentDetails);

        // Adding office timings for the village
        Map<String, String> officeTimings = new HashMap<>();
        officeTimings.put("Mon - Fri", "9.00 AM - 6.00 PM");
        villageData.put("OfficeTimings", officeTimings.toString());

        return villageData;
    }

    private String extractNameFromCode(String code) {
        if (code == null || code.isEmpty()) {
            log.info("Code is null or empty, returning empty string.");
            return "";
        }
        String[] parts = code.split("_");
        return parts[parts.length - 1];  // Extract the last part of the code as the name
    }
}
