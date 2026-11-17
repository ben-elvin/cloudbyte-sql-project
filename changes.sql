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
