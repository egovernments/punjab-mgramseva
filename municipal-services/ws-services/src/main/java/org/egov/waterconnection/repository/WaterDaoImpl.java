package org.egov.waterconnection.repository;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.egov.common.contract.request.RequestInfo;
import org.egov.common.contract.request.Role;
import org.egov.common.contract.request.User;
import org.egov.waterconnection.config.WSConfiguration;
import org.egov.waterconnection.constants.WCConstants;
import org.egov.waterconnection.repository.rowmapper.BillingCycleRowMapper;
import org.egov.waterconnection.repository.rowmapper.FeedbackRowMapper;
import org.egov.waterconnection.repository.rowmapper.OpenWaterRowMapper;
import org.egov.waterconnection.web.models.BillingCycle;
import org.egov.waterconnection.web.models.Feedback;
import org.egov.waterconnection.web.models.FeedbackSearchCriteria;
import org.egov.waterconnection.web.models.SearchCriteria;
import org.egov.waterconnection.web.models.WaterConnection;
import org.egov.waterconnection.web.models.WaterConnectionRequest;
import org.egov.waterconnection.web.models.WaterConnectionResponse;
import org.egov.waterconnection.producer.WaterConnectionProducer;
import org.egov.waterconnection.repository.builder.WsQueryBuilder;
import org.egov.waterconnection.repository.rowmapper.WaterRowMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
public class WaterDaoImpl implements WaterDao {

	@Autowired
	private WaterConnectionProducer waterConnectionProducer;

	@Autowired
	private JdbcTemplate jdbcTemplate;

	@Autowired
	private WsQueryBuilder wsQueryBuilder;

	@Autowired
	private WaterRowMapper waterRowMapper;

	@Autowired
	private OpenWaterRowMapper openWaterRowMapper;
	
	@Autowired
	private WSConfiguration wsConfiguration;

	@Value("${egov.waterservice.createwaterconnection.topic}")
	private String createWaterConnection;

	@Value("${egov.waterservice.updatewaterconnection.topic}")
	private String updateWaterConnection;
	
	@Autowired
	private BillingCycleRowMapper billingCycleRowMapper;

	@Autowired
    private FeedbackRowMapper feedbackRowMapper;
	
	@Override
	public void saveWaterConnection(WaterConnectionRequest waterConnectionRequest) {
		waterConnectionProducer.push(createWaterConnection, waterConnectionRequest);
	}

	@Override
	public WaterConnectionResponse getWaterConnectionList(SearchCriteria criteria,
			RequestInfo requestInfo) {
		
		List<WaterConnection> waterConnectionList = new ArrayList<>();
		List<Object> preparedStatement = new ArrayList<>();
		String query = wsQueryBuilder.getSearchQueryString(criteria, preparedStatement, requestInfo);
		
		if (query == null)
			return null;
		
		Boolean isOpenSearch = isSearchOpen(requestInfo.getUserInfo());
		WaterConnectionResponse connectionResponse = new WaterConnectionResponse();
		if(isOpenSearch) {
			waterConnectionList = jdbcTemplate.query(query, preparedStatement.toArray(),
					openWaterRowMapper);
			connectionResponse = WaterConnectionResponse.builder().waterConnection(waterConnectionList).totalCount(openWaterRowMapper.getFull_count()).build();
		}
		else {
			waterConnectionList = jdbcTemplate.query(query, preparedStatement.toArray(),
					waterRowMapper);
			connectionResponse = WaterConnectionResponse.builder().waterConnection(waterConnectionList).totalCount(waterRowMapper.getFull_count()).build();
		}
		
//		if (waterConnectionList == null)
//			return Collections.emptyList();
		return connectionResponse;
	}

	@Override
	public void updateWaterConnection(WaterConnectionRequest waterConnectionRequest, boolean isStateUpdatable) {
		if (isStateUpdatable) {
			waterConnectionProducer.push(updateWaterConnection, waterConnectionRequest);
		} else {
			waterConnectionProducer.push(wsConfiguration.getWorkFlowUpdateTopic(), waterConnectionRequest);
		}
	}
	
	/**
	 * push object to create meter reading
	 * 
	 * @param waterConnectionRequest
	 */
	public void postForMeterReading(WaterConnectionRequest waterConnectionRequest) {
		log.info("Posting request to kafka topic - " + wsConfiguration.getCreateMeterReading());
		waterConnectionProducer.push(wsConfiguration.getCreateMeterReading(), waterConnectionRequest);
	}

	/**
	 * push object for edit notification
	 * 
	 * @param waterConnectionRequest
	 */
	public void pushForEditNotification(WaterConnectionRequest waterConnectionRequest) {
		if (!WCConstants.EDIT_NOTIFICATION_STATE
				.contains(waterConnectionRequest.getWaterConnection().getProcessInstance().getAction())) {
			waterConnectionProducer.push(wsConfiguration.getEditNotificationTopic(), waterConnectionRequest);
		}
	}
	
	/**
	 * Enrich file store Id's
	 * 
	 * @param waterConnectionRequest
	 */
	public void enrichFileStoreIds(WaterConnectionRequest waterConnectionRequest) {
		waterConnectionProducer.push(wsConfiguration.getFileStoreIdsTopic(), waterConnectionRequest);
	}
	
	/**
	 * Save file store Id's
	 * 
	 * @param waterConnectionRequest
	 */
	public void saveFileStoreIds(WaterConnectionRequest waterConnectionRequest) {
		waterConnectionProducer.push(wsConfiguration.getSaveFileStoreIdsTopic(), waterConnectionRequest);
	}

	public Boolean isSearchOpen(User userInfo) {

		return userInfo.getType().equalsIgnoreCase("SYSTEM")
				&& userInfo.getRoles().stream().map(Role::getCode).collect(Collectors.toSet()).contains("ANONYMOUS");
	}
	
	public BillingCycle getBillingCycle(String paymentId) {

		String query = WsQueryBuilder.GET_BILLING_CYCLE;

		List<Object> prepareStatementList = new ArrayList<Object>();

		prepareStatementList.add(paymentId);

		List<BillingCycle> billingCycleList = jdbcTemplate.query(query, prepareStatementList.toArray(),
				billingCycleRowMapper);

		return billingCycleList.get(0);
	}

	public List<Feedback> getFeebback(FeedbackSearchCriteria feedbackSearchCriteria) {

		List<Object> preparedStamentValues = new ArrayList<Object>();
		String query = wsQueryBuilder.getFeedback(feedbackSearchCriteria, preparedStamentValues);
		List<Feedback> feedBackList = jdbcTemplate.query(query, preparedStamentValues.toArray(), feedbackRowMapper);
		return feedBackList;
	}

}
