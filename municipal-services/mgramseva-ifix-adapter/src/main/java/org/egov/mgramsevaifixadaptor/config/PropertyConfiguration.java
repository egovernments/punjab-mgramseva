package org.egov.mgramsevaifixadaptor.config;

import org.egov.tracer.config.TracerConfiguration;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Import;
import org.springframework.stereotype.Component;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Import({TracerConfiguration.class})
@Getter
@Builder
@Component
@AllArgsConstructor
@NoArgsConstructor
public class PropertyConfiguration {
	
	
	@Value("${egov.ifix.refernce.adapter.host}")
	private String adapterHost;
	
	@Value("${egov.ifix.refernce.adapter.push.endpoint}")
	private String adapterCreateEndpoint;
	
	@Value("${egov.mdms.host}")
	private String mdmsHost;
	
	@Value("${egov.mdms.search.endpoint}")
	private String mdmsSearchEndpoint;

}
