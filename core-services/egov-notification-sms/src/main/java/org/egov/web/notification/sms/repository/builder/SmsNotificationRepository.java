package org.egov.web.notification.sms.repository.builder;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import org.springframework.jdbc.core.JdbcTemplate;

@Component
@Slf4j
@Repository
public class SmsNotificationRepository {

    private JdbcTemplate jdbcTemplate;

    public static final String SELECT_NEXT_SEQUENCE_USER = "select nextval('seq_eg_notification_sms')";

    public Long getNextSequence() {
        return jdbcTemplate.queryForObject(SELECT_NEXT_SEQUENCE_USER, Long.class);
    }


}
