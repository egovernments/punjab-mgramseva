package org.egov.waterconnection.repository;

import java.util.List;

import org.egov.common.contract.request.RequestInfo;
import org.egov.waterconnection.web.models.SearchCriteria;
import org.egov.waterconnection.web.models.WaterConnectionRequest;
import org.egov.waterconnection.web.models.WaterConnectionResponse;

public interface WaterDao {
	void saveWaterConnection(WaterConnectionRequest waterConnectionRequest);

	WaterConnectionResponse getWaterConnectionList(SearchCriteria criteria,RequestInfo requestInfo);
	
	void updateWaterConnection(WaterConnectionRequest waterConnectionRequest, boolean isStateUpdatable);

	List<String> getWCListFuzzySearch(SearchCriteria criteria);
	
	WaterConnectionResponse getWaterConnectionListForPlaneSearch(SearchCriteria criteria,RequestInfo requestInfo);

	void enrichFileStoreIds(WaterConnectionRequest waterConnectionRequest);
}
