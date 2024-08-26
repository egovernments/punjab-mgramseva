
ALTER TABLE eg_ws_bulk_demand_batch ALTER COLUMN createdTime DROP DEFAULT;

ALTER TABLE eg_ws_bulk_demand_batch ALTER COLUMN createdTime TYPE BIGINT;

ALTER TABLE eg_ws_bulk_demand_batch ALTER COLUMN lastModifiedBy TYPE VARCHAR(64);

ALTER TABLE eg_ws_bulk_demand_batch ALTER COLUMN lastModifiedTime SET NOT NULL;
