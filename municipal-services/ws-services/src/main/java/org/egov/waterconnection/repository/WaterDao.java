package org.egov.waterconnection.repository;

import org.egov.common.contract.request.RequestInfo;
import org.egov.waterconnection.web.models.SearchCriteria;
import org.egov.waterconnection.web.models.WaterConnectionRequest;
import org.egov.waterconnection.web.models.WaterConnectionResponse;

public interface WaterDao {
	void saveWaterConnection(WaterConnectionRequest waterConnectionRequest);

	WaterConnectionResponse getWaterConnectionList(SearchCriteria criteria,RequestInfo requestInfo);
	
	void updateWaterConnection(WaterConnectionRequest waterConnectionRequest, boolean isStateUpdatable);
}
