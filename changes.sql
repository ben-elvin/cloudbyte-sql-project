-- Berlin spelled three ways in customers.city
BEGIN;
UPDATE customers SET city = 'Berlin' WHERE lower(btrim(city)) IN ('berlin', 'berlín');
COMMIT;

-- Acme GmbH twice in customers: consolidate 41 into 1
BEGIN;
UPDATE instances SET customer_ref = 1 WHERE customer_ref = 41;
UPDATE tickets SET customer_ref = 1 WHERE customer_ref = 41;
UPDATE invoices SET customer_ref = 1 WHERE customer_ref = 41;
UPDATE contacts SET customer_ref = 1 WHERE customer_ref = 41;
UPDATE portal_hits SET customer_ref = 1 WHERE customer_ref = 41;
DELETE FROM customers WHERE customer_id = 41;
COMMIT;

-- Negative hours in usage_daily
BEGIN;
DELETE FROM usage_daily WHERE hours < 0;
COMMIT;

-- Test accounts in customers, and every row that belongs to them
BEGIN;
DELETE FROM usage_daily WHERE instance_id IN (SELECT instance_id FROM instances WHERE customer_ref IN (42, 43));
DELETE FROM invoice_lines WHERE invoice_id IN (SELECT invoice_id FROM invoices WHERE customer_ref IN (42, 43));
DELETE FROM ticket_notes WHERE ticket_id IN (SELECT ticket_id FROM tickets WHERE customer_ref IN (42, 43));
DELETE FROM instances WHERE customer_ref IN (42, 43);
DELETE FROM invoices WHERE customer_ref IN (42, 43);
DELETE FROM tickets WHERE customer_ref IN (42, 43);
DELETE FROM contacts WHERE customer_ref IN (42, 43);
DELETE FROM portal_hits WHERE customer_ref IN (42, 43);
DELETE FROM customers WHERE customer_id IN (42, 43);
COMMIT;

-- Instances that point at a customer who doesn't exist, and their usage
BEGIN;
DELETE FROM usage_daily WHERE instance_id IN (SELECT i.instance_id FROM instances i LEFT JOIN customers c ON i.customer_ref = c.customer_id WHERE c.customer_id IS NULL);
DELETE FROM instances WHERE instance_id IN (SELECT i.instance_id FROM instances i LEFT JOIN customers c ON i.customer_ref = c.customer_id WHERE c.customer_id IS NULL);
COMMIT;

-- Instance-days loaded twice in usage_daily
BEGIN;
DELETE FROM usage_daily a USING usage_daily b WHERE b.instance_id = a.instance_id AND b.day = a.day AND a.usage_id > b.usage_id;
COMMIT;

-- Blank usage_daily.cost_eur, rebuilt from hours and the instance type's rate
BEGIN;
UPDATE usage_daily u SET cost_eur = u.hours * p.rate_eur_hour FROM instances i JOIN pricing p ON p.instance_type = i.instance_type WHERE i.instance_id = u.instance_id AND u.cost_eur IS NULL;
COMMIT;

-- instances.customer_ref → customers.customer_id
BEGIN;
ALTER TABLE instances ADD CONSTRAINT fk_instances_customer FOREIGN KEY (customer_ref) REFERENCES customers (customer_id);
COMMIT;

-- invoices.customer_ref → customers.customer_id
BEGIN;
ALTER TABLE invoices ADD CONSTRAINT fk_invoices_customer FOREIGN KEY (customer_ref) REFERENCES customers (customer_id);
COMMIT;

-- usage_daily.instance_id → instances.instance_id
BEGIN;
ALTER TABLE usage_daily ADD CONSTRAINT fk_usage_daily_instance FOREIGN KEY (instance_id) REFERENCES instances (instance_id);
COMMIT;

-- invoice_lines.invoice_id → invoices.invoice_id
BEGIN;
ALTER TABLE invoice_lines ADD CONSTRAINT fk_invoice_lines_invoice FOREIGN KEY (invoice_id) REFERENCES invoices (invoice_id);
COMMIT;

-- usage_daily.cost_eur NOT NULL
BEGIN;
ALTER TABLE usage_daily ALTER COLUMN cost_eur SET NOT NULL;
COMMIT;

-- uq_customers_company_name
BEGIN;
ALTER TABLE customers ADD CONSTRAINT uq_customers_company_name UNIQUE (company_name);
COMMIT;

-- uq_usage_daily_instance_day
BEGIN;
ALTER TABLE usage_daily ADD CONSTRAINT uq_usage_daily_instance_day UNIQUE (instance_id, day);
COMMIT;

-- ck_usage_daily_hours
BEGIN;
ALTER TABLE usage_daily ADD CONSTRAINT ck_usage_daily_hours CHECK (hours >= 0 AND hours <= 24);
COMMIT;

-- ck_customers_status
BEGIN;
ALTER TABLE customers ADD CONSTRAINT ck_customers_status CHECK (status IN ('active', 'churned'));
COMMIT;

-- ix_usage_daily_day: the monthly spend report reads one month of usage_daily
BEGIN;
CREATE INDEX ix_usage_daily_day ON usage_daily (day, cost_eur);
COMMIT;
VACUUM ANALYZE usage_daily;
