package org.egov.web.notification.sms.models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.ToString;

import static org.apache.commons.lang3.StringUtils.isNotEmpty;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class SmsSaveRequest {
    private  String id;
    private String mobileNumber;
    private String message;
    private Category category;
    private Long createdtime;
    private String templateId;
    private String tenantId;
    public boolean isValid() {

        return isNotEmpty(mobileNumber) && isNotEmpty(message);
    }
}
