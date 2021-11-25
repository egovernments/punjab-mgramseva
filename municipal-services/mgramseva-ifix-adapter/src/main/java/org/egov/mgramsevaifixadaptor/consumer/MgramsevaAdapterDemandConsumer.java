package org.egov.mgramsevaifixadaptor.consumer;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;

import org.egov.mgramsevaifixadaptor.config.PropertyConfiguration;
import org.egov.mgramsevaifixadaptor.contract.DemandRequest;
import org.egov.mgramsevaifixadaptor.models.AuditDetails;
import org.egov.mgramsevaifixadaptor.models.Bill.StatusEnum;
import org.egov.mgramsevaifixadaptor.models.Demand;
import org.egov.mgramsevaifixadaptor.models.DemandDetail;
import org.egov.mgramsevaifixadaptor.models.EventTypeEnum;
import org.egov.mgramsevaifixadaptor.util.Constants;
import org.egov.mgramsevaifixadaptor.util.MgramasevaAdapterWrapperUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class MgramsevaAdapterDemandConsumer {

	@Autowired
	MgramasevaAdapterWrapperUtil util;
	
	@KafkaListener(topics = { "${kafka.topics.create.demand}"})
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
	
	@KafkaListener(topics = { "${kafka.topics.update.demand}"})
	public void listenUpdate(final HashMap<String, Object> record, @Header(KafkaHeaders.RECEIVED_TOPIC) String topic) throws Exception {
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
			if(demandRequest != null) {
				Collections.sort(demandRequest.getDemands(), getCreatedTimeComparatorForDemand());
				if(demandRequest.getDemands().get(0).getStatus().toString().equalsIgnoreCase(Constants.CANCELLED)) {
					BigDecimal totalAmount = new BigDecimal(0.00);
					if(demandRequest.getDemands().get(0).getDemandDetails() != null) {
						for(DemandDetail dd : demandRequest.getDemands().get(0).getDemandDetails()) {
							totalAmount = totalAmount.add(dd.getTaxAmount());
						}
						totalAmount = totalAmount.negate();
						int demandDetailsSize = demandRequest.getDemands().get(0).getDemandDetails().size();
						for(int i=0; i<demandDetailsSize-1; i++) {
							demandRequest.getDemands().get(0).getDemandDetails().remove(0);
						}
						demandRequest.getDemands().get(0).getDemandDetails().get(0).setTaxAmount(totalAmount);
					}
				}else {
					int demandDetailsSize = demandRequest.getDemands().get(0).getDemandDetails().size();
					for(int i=0; i<demandDetailsSize-1; i++) {
						demandRequest.getDemands().get(0).getDemandDetails().remove(0);
					}
				}
			}
			util.callIFIXAdapter(demandRequest, eventType, demandRequest.getDemands().get(0).getTenantId(),demandRequest.getRequestInfo());
		} catch (final Exception e) {
			log.error("Error while listening to value: " + record + " on topic: " + topic + ": " + e);
		}
	}
	
	public static Comparator<Demand> getCreatedTimeComparatorForDemand() {
		return new Comparator<Demand>() {
			@Override
			public int compare(Demand o1, Demand o2) {
				return o2.getAuditDetails().getCreatedTime().compareTo(o1.getAuditDetails().getCreatedTime());
			}
		};
	}
}
