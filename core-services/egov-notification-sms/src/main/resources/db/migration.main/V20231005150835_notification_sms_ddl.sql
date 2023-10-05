CREATE TABLE IF NOT EXISTS  eg_notification_sms (
    id SERIAL PRIMARY KEY,
    mobile_no VARCHAR(20) NOT NULL,
    message TEXT,
    category VARCHAR(50),
    template_id VARCHAR(50),
    createdtime TIMESTAMP,
    tenant_id VARCHAR(50)
);
