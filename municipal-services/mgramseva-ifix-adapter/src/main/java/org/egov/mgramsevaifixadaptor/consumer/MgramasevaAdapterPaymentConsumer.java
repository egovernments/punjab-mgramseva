package org.egov.mgramsevaifixadaptor.consumer;

import java.util.HashMap;

import org.egov.mgramsevaifixadaptor.config.PropertyConfiguration;
import org.egov.mgramsevaifixadaptor.contract.PaymentRequest;
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
public class MgramasevaAdapterPaymentConsumer {

	@Autowired
	MgramasevaAdapterWrapperUtil util;
	
	@KafkaListener(topics = { "${kafka.topics.create.payment}" })
	public void listen(final HashMap<String, Object> record, @Header(KafkaHeaders.RECEIVED_TOPIC) String topic)
			throws Exception {
		ObjectMapper mapper = new ObjectMapper();
		PaymentRequest paymentRequest = null;
		try {
			log.debug("Consuming record: " + record);
			paymentRequest = mapper.convertValue(record, PaymentRequest.class);
			String eventType=null;
			if(paymentRequest.getPayment().getPaymentDetails().get(0).getBusinessService().contains(Constants.EXPENSE))
			{
				eventType=EventTypeEnum.PAYMENT.toString();
			}else {
				eventType=EventTypeEnum.RECEIPT.toString();
			}
			util.callIFIXAdapter(paymentRequest, eventType, paymentRequest.getPayment().getTenantId(),paymentRequest.getRequestInfo());
		} catch (final Exception e) {
			log.error("Error while listening to value: " + record + " on topic: " + topic + ": " + e);
		}

		// TODO enable after implementation
	}
}