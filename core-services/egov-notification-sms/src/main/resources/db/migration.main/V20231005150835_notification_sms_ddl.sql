CREATE TABLE IF NOT EXISTS  eg_notification_sms (
    id CHARACTER VARYING (128) NOT NULL,
    mobile_no VARCHAR(20) NOT NULL,
    message TEXT,
    category VARCHAR(50),
    template_id VARCHAR(50),
    createdtime TIMESTAMP,
    tenant_id VARCHAR(50)
);
