CREATE TABLE IF NOT EXISTS bulk_demand_calls
(
  id VARCHAR(64) PRIMARY KEY,
  tenantId VARCHAR(64),
  billingPeriod VARCHAR(64) NOT NULL,
  createdTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(50)
);
CREATE SEQUENCE seq_bulk_demand_calls
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE bulk_demand_calls ALTER COLUMN id SET DEFAULT nextval('seq_bulk_demand_calls'::regclass);

CREATE INDEX IF NOT EXISTS index_bulk_demand_calls_tenantId ON bulk_demand_calls (tenantId);
CREATE INDEX IF NOT EXISTS index_eg_bulk_demand_calls_billingPeriod ON bulk_demand_calls (billingPeriod);