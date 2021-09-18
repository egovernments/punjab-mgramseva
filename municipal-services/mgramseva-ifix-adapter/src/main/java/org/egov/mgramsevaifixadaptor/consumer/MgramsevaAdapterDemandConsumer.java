package org.egov.mgramsevaifixadaptor.consumer;

import java.util.HashMap;

import org.egov.mgramsevaifixadaptor.config.PropertyConfiguration;
import org.egov.mgramsevaifixadaptor.contract.DemandRequest;
import org.egov.mgramsevaifixadaptor.models.EventTypeEnum;
import org.egov.mgramsevaifixadaptor.util.Constants;
import org.egov.mgramsevaifixadaptor.util.MgramasevaAdapterWrapperUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class MgramsevaAdapterDemandConsumer {

	@Autowired
	MgramasevaAdapterWrapperUtil util;
	
	@KafkaListener(topics = { "${kafka.topics.create.demand}","${kafka.topics.update.demand}"})
	public void listen(final HashMap<String, Object> record, @Header(KafkaHeaders.RECEIVED_TOPIC) String topic) throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		DemandRequest demandRequest=null;
		try {
			log.debug("Consuming record: " + record);
			demandRequest = mapper.convertValue(record, DemandRequest.class);
			String eventType=null;
			if(demandRequest.getDemands().get(0).getBusinessService().contains(Constants.EXPENSE))
			{
				eventType=EventTypeEnum.BILL.toString();
			}else {
				eventType=EventTypeEnum.DEMAND.toString();
			}
				
			util.callIFIXAdapter(demandRequest, eventType, demandRequest.getDemands().get(0).getTenantId(),demandRequest.getRequestInfo());
		} catch (final Exception e) {
			log.error("Error while listening to value: " + record + " on topic: " + topic + ": " + e);
		}
		
		
		 //TODO enable after implementation
	}
}