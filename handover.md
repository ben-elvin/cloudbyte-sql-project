# CloudByte handover

The eleven tables of `cloudbyte`, one heading each, in the order `schema.sql` declares them: every column, what it holds, and the query that proved it. I hold half A, and map the three tables both halves share and my own four; the other half's four carry their heading and nothing else.

## staff

*12 rows.* `SELECT count(*) FROM staff;`

| column | what it holds | the query that proved it |
|---|---|---|
| `username` | a staff member's login name, lower-case first name: `alice` to `leo` | `SELECT * FROM staff ORDER BY username;` |
| `department` | one of three words: `Engineering` 4, `Marketing` 3, `Operations` 5 | `SELECT department, count(*) FROM staff GROUP BY department ORDER BY department;` |
| `started_on` | the day the person started, from `2020-02-03` to `2024-07-15` | `SELECT min(started_on), max(started_on), count(*) FROM staff;` |

## customers

*43 rows.* `SELECT count(*) FROM customers;`

| column | what it holds | the query that proved it |
|---|---|---|
| `customer_id` | the customer's number, `1` to `43` | `SELECT min(customer_id), max(customer_id), min(signed_on), max(signed_on), count(*) FROM customers;` |
| `company_name` | the company's name written out, such as `Acme GmbH` | `SELECT customer_id, company_name, city, country, signed_on, plan, status FROM customers ORDER BY customer_id LIMIT 5;` |
| `city` | the customer's city, 28 spellings; Berlin is spelt three ways: `Berlin` 7, `Berlín` 1, `berlin` 2 | `SELECT city, count(*) FROM customers GROUP BY city ORDER BY city;` |
| `country` | a two-letter country code: `AT` 1, `CH` 1, `DE` 40, `SE` 1 | `SELECT country, count(*) FROM customers GROUP BY country ORDER BY country;` |
| `signed_on` | the day the customer signed, from `2023-01-17` to `2025-04-08` | `SELECT min(customer_id), max(customer_id), min(signed_on), max(signed_on), count(*) FROM customers;` |
| `plan` | one of three plans: `basic` 16, `enterprise` 9, `standard` 18 | `SELECT plan, count(*) FROM customers GROUP BY plan ORDER BY plan;` |
| `status` | `active` 38 or `churned` 5 | `SELECT status, count(*) FROM customers GROUP BY status ORDER BY status;` |
| `contact_1_email` | a contact's email address, filled on 41 of the 43 customers | `SELECT count(*) FILTER (WHERE contact_1_email <> '') AS has_1, count(*) FILTER (WHERE contact_2_email <> '') AS has_2, count(*) FILTER (WHERE contact_3_email <> '') AS has_3 FROM customers;` |
| `contact_2_email` | a second contact's email address, filled on 29 of the 43 | `SELECT count(*) FILTER (WHERE contact_1_email <> '') AS has_1, count(*) FILTER (WHERE contact_2_email <> '') AS has_2, count(*) FILTER (WHERE contact_3_email <> '') AS has_3 FROM customers;` |
| `contact_3_email` | a third contact's email address, filled on 2 of the 43. A fourth contact has nowhere to go: no column holds one, and finding a customer by a contact's email means searching all three columns | `SELECT count(*) FILTER (WHERE contact_1_email <> '') AS has_1, count(*) FILTER (WHERE contact_2_email <> '') AS has_2, count(*) FILTER (WHERE contact_3_email <> '') AS has_3 FROM customers;` |

## pricing

*5 rows.* `SELECT count(*) FROM pricing;`

| column | what it holds | the query that proved it |
|---|---|---|
| `instance_type` | the five instance sizes: `cb.gpu`, `cb.large`, `cb.medium`, `cb.small`, `cb.xlarge` | `SELECT * FROM pricing ORDER BY instance_type;` |
| `rate_eur_hour` | the hourly rate in euros for that size, from `0.024` (`cb.small`) to `0.740` (`cb.gpu`) | `SELECT * FROM pricing ORDER BY instance_type;` |

## instances

*404 rows.* `SELECT count(*) FROM instances;`

| column | what it holds | the query that proved it |
|---|---|---|
| `instance_id` | the instance's number, `1001` to `1404` | `SELECT min(instance_id), max(instance_id), min(customer_ref), max(customer_ref), min(launched_on), max(launched_on), min(terminated_on), max(terminated_on), count(*) FROM instances;` |
| `customer_ref` | a customer number, from `1` to `46` | `SELECT min(instance_id), max(instance_id), min(customer_ref), max(customer_ref), min(launched_on), max(launched_on), min(terminated_on), max(terminated_on), count(*) FROM instances;` |
| `region` | one of three AWS-style regions: `eu-central-1` 138, `eu-north-1` 141, `eu-west-1` 125 | `SELECT region, count(*) FROM instances GROUP BY region ORDER BY region;` |
| `instance_type` | one of the five sizes: `cb.gpu` 91, `cb.large` 87, `cb.medium` 65, `cb.small` 77, `cb.xlarge` 84 | `SELECT instance_type, count(*) FROM instances GROUP BY instance_type ORDER BY instance_type;` |
| `launched_on` | the day the instance started, from `2024-01-01` to `2025-10-02` | `SELECT min(instance_id), max(instance_id), min(customer_ref), max(customer_ref), min(launched_on), max(launched_on), min(terminated_on), max(terminated_on), count(*) FROM instances;` |
| `terminated_on` | the day the instance was stopped, from `2024-03-29` to `2025-12-27`; blank on the first rows, so some instances still run | `SELECT min(instance_id), max(instance_id), min(customer_ref), max(customer_ref), min(launched_on), max(launched_on), min(terminated_on), max(terminated_on), count(*) FROM instances;` |

## usage_daily

*180660 rows.* `SELECT count(*) FROM usage_daily;`

| column | what it holds | the query that proved it |
|---|---|---|
| `usage_id` | the row's number, `1` to `180660` | `SELECT min(usage_id), max(usage_id), min(instance_id), max(instance_id), min(day), max(day), min(hours), max(hours), min(cost_eur), max(cost_eur), count(*) FROM usage_daily;` |
| `instance_id` | an instance number, `1001` to `1404` | `SELECT min(usage_id), max(usage_id), min(instance_id), max(instance_id), min(day), max(day), min(hours), max(hours), min(cost_eur), max(cost_eur), count(*) FROM usage_daily;` |
| `day` | the day the usage is for, from `2024-01-01` to `2025-12-31` | `SELECT min(usage_id), max(usage_id), min(instance_id), max(instance_id), min(day), max(day), min(hours), max(hours), min(cost_eur), max(cost_eur), count(*) FROM usage_daily;` |
| `hours` | hours the instance ran that day, from `-20` to `24`; a negative hour is not possible, so some rows are wrong | `SELECT min(usage_id), max(usage_id), min(instance_id), max(instance_id), min(day), max(day), min(hours), max(hours), min(cost_eur), max(cost_eur), count(*) FROM usage_daily;` |
| `cost_eur` | what that day cost in euros, from `-9.6200` to `17.7600` | `SELECT min(usage_id), max(usage_id), min(instance_id), max(instance_id), min(day), max(day), min(hours), max(hours), min(cost_eur), max(cost_eur), count(*) FROM usage_daily;` |

`usage_daily` has no row for July 2025: 10067 rows in June, 0 in July and 10735 in August. Found with `SELECT count(*) FILTER (WHERE day BETWEEN DATE '2025-06-01' AND DATE '2025-06-30') AS jun_2025, count(*) FILTER (WHERE day BETWEEN DATE '2025-07-01' AND DATE '2025-07-31') AS jul_2025, count(*) FILTER (WHERE day BETWEEN DATE '2025-08-01' AND DATE '2025-08-31') AS aug_2025 FROM usage_daily;`

## invoices

*854 rows.* `SELECT count(*) FROM invoices;`

| column | what it holds | the query that proved it |
|---|---|---|
| `invoice_id` | the invoice number, `5001` to `5854` | `SELECT min(invoice_id), max(invoice_id), min(customer_ref), max(customer_ref), min(period_month), max(period_month), min(issued_on), max(issued_on), min(total_eur), max(total_eur), count(*) FROM invoices;` |
| `customer_ref` | a customer number, `1` to `43` | `SELECT min(invoice_id), max(invoice_id), min(customer_ref), max(customer_ref), min(period_month), max(period_month), min(issued_on), max(issued_on), min(total_eur), max(total_eur), count(*) FROM invoices;` |
| `period_month` | the first day of the month billed, from `2024-01-01` to `2025-12-01` | `SELECT min(invoice_id), max(invoice_id), min(customer_ref), max(customer_ref), min(period_month), max(period_month), min(issued_on), max(issued_on), min(total_eur), max(total_eur), count(*) FROM invoices;` |
| `issued_on` | the day the invoice went out, from `2024-02-05` to `2026-01-05` | `SELECT min(invoice_id), max(invoice_id), min(customer_ref), max(customer_ref), min(period_month), max(period_month), min(issued_on), max(issued_on), min(total_eur), max(total_eur), count(*) FROM invoices;` |
| `status` | one of three words: `open` 174, `overdue` 151, `paid` 529 | `SELECT status, count(*) FROM invoices GROUP BY status ORDER BY status;` |
| `total_eur` | the invoice total in euros, from `12.97` to `2338.73` | `SELECT min(invoice_id), max(invoice_id), min(customer_ref), max(customer_ref), min(period_month), max(period_month), min(issued_on), max(issued_on), min(total_eur), max(total_eur), count(*) FROM invoices;` |

## invoice_lines

*3811 rows.* `SELECT count(*) FROM invoice_lines;`

| column | what it holds | the query that proved it |
|---|---|---|
| `line_id` | the line's number, `20001` to `23811` | `SELECT min(line_id), max(line_id), min(invoice_id), max(invoice_id), min(qty), max(qty), min(vat_rate), max(vat_rate), count(*) FROM invoice_lines;` |
| `invoice_id` | an invoice number, `5001` to `5854` | `SELECT min(line_id), max(line_id), min(invoice_id), max(invoice_id), min(qty), max(qty), min(vat_rate), max(vat_rate), count(*) FROM invoice_lines;` |
| `line_desc` | a size and an instance written out, such as `cb.medium compute, instance 1007` | `SELECT * FROM invoice_lines ORDER BY line_id LIMIT 5;` |
| `qty` | a whole number from `400` to `744`, the hours billed on the line | `SELECT min(line_id), max(line_id), min(invoice_id), max(invoice_id), min(qty), max(qty), min(vat_rate), max(vat_rate), count(*) FROM invoice_lines;` |
| `trn_amt_3` | the line's charge in cents, `qty` times an hourly rate; five rates, the five in `pricing` in cents: `2.40` on 601 lines, `4.80` on 524, `9.60` on 880, `19.20` on 831, `74.00` on 975, which is all 3811 | `SELECT round(trn_amt_3 * 1.0 / qty, 2) AS cents_per_hour, count(*) FROM invoice_lines WHERE qty > 0 GROUP BY cents_per_hour ORDER BY cents_per_hour;` |
| `vat_rate` | the VAT rate, `0.190` on every line | `SELECT vat_rate, count(*) FROM invoice_lines GROUP BY vat_rate ORDER BY vat_rate;` |

## contacts

*Half B's table: the other side maps it.*

## tickets

*Half B's table: the other side maps it.*

## ticket_notes

*Half B's table: the other side maps it.*

## portal_hits

*Half B's table: the other side maps it.*

## Relationships

| relationship | `INNER JOIN` rows | `LEFT JOIN` rows | the queries that proved it |
|---|---|---|---|
| `instances.customer_ref` → `customers.customer_id` | 398 | 404 | `SELECT count(*) AS inner_join FROM instances i JOIN customers c ON c.customer_id = i.customer_ref;` `SELECT count(*) AS left_join FROM instances i LEFT JOIN customers c ON c.customer_id = i.customer_ref;` |
| `invoices.customer_ref` → `customers.customer_id` | 854 | 854 | `SELECT count(*) AS inner_join FROM invoices i JOIN customers c ON c.customer_id = i.customer_ref;` `SELECT count(*) AS left_join FROM invoices i LEFT JOIN customers c ON c.customer_id = i.customer_ref;` |
| `usage_daily.instance_id` → `instances.instance_id` | 180660 | 180660 | `SELECT count(*) AS inner_join FROM usage_daily u JOIN instances i ON i.instance_id = u.instance_id;` `SELECT count(*) AS left_join FROM usage_daily u LEFT JOIN instances i ON i.instance_id = u.instance_id;` |
| `invoice_lines.invoice_id` → `invoices.invoice_id` | 3811 | 3811 | `SELECT count(*) AS inner_join FROM invoice_lines l JOIN invoices i ON i.invoice_id = l.invoice_id;` `SELECT count(*) AS left_join FROM invoice_lines l LEFT JOIN invoices i ON i.invoice_id = l.invoice_id;` |

`invoices` has 854 rows (`SELECT count(*) AS invoices FROM invoices;`). Joined to `invoice_lines` on `invoice_id`, it returns 3811 rows, one for each invoice line (`SELECT count(*) AS after_join FROM invoices i JOIN invoice_lines l ON l.invoice_id = i.invoice_id;`).

Declaring `instances.customer_ref` → `customers.customer_id` as a foreign key:

```sql
ALTER TABLE instances ADD CONSTRAINT fk_instances_customer FOREIGN KEY (customer_ref) REFERENCES customers (customer_id);
```

The engine refused it:

```text
ERROR:  insert or update on table "instances" violates foreign key constraint "fk_instances_customer"
DETAIL:  Key (customer_ref)=(44) is not present in table "customers".
```

The rows that carry `44` (`SELECT instance_id, customer_ref FROM instances WHERE customer_ref = 44 ORDER BY instance_id;`):

| instance_id | customer_ref |
|---|---|
| 1399 | 44 |
| 1400 | 44 |

`instances` has 6 orphan rows, pointing at 3 customer numbers that are not in `customers` (`SELECT count(*) AS orphan_instances, count(DISTINCT i.customer_ref) AS missing_customers FROM instances i LEFT JOIN customers c ON i.customer_ref = c.customer_id WHERE c.customer_id IS NULL;`).

## Corrections

### Blank `usage_daily.cost_eur`

Some rows of `usage_daily` have no value in `cost_eur`. The total of `cost_eur` is 1020370.6520, calculated from 177669 of the 180660 rows: `SELECT count(*) AS usage_rows, count(cost_eur) AS with_cost, sum(cost_eur) AS total_eur FROM usage_daily;`

The rows the total left out: `SELECT count(*) AS usage_rows FROM usage_daily WHERE cost_eur IS NULL;`

*2991 rows.*

Nothing in cloudbyte had been changed when this count was taken.

The repair: a blank cost is the reading's hours times the hourly rate of its instance's type. Rule test first, on the rows that have a cost: 174061 rows with a cost (`SELECT count(*) AS with_cost FROM usage_daily u JOIN instances i ON i.instance_id = u.instance_id JOIN pricing p ON p.instance_type = i.instance_type WHERE u.cost_eur IS NOT NULL;`), and 174061 that agree (`SELECT count(*) AS agree FROM usage_daily u JOIN instances i ON i.instance_id = u.instance_id JOIN pricing p ON p.instance_type = i.instance_type WHERE u.cost_eur = u.hours * p.rate_eur_hour;`).

```sql
BEGIN;
UPDATE usage_daily u SET cost_eur = u.hours * p.rate_eur_hour FROM instances i JOIN pricing p ON p.instance_type = i.instance_type WHERE i.instance_id = u.instance_id AND u.cost_eur IS NULL;
COMMIT;
```

The count just before the repair was 2942, not 2991 (`SELECT count(*) AS usage_rows FROM usage_daily WHERE cost_eur IS NULL;`): the test-account, orphan and duplicate deletes took 49 blank rows with them. The tag was `UPDATE 2942`. The check `SELECT usage_id FROM usage_daily WHERE cost_eur IS NULL;` returned 0 rows, and row 35 reads 24 hours × 0.048 = 1.1520 by hand. The repair moved the total of `usage_daily.cost_eur` up, from 1008414.6240 to 1025258.6440, now over all 177003 rows.

### Berlin spelled three ways in customers.city

`customers.city` holds Berlin in three spellings: `Berlin` on 7 customers, `Berlín` (an accent on the i) on 1, and `berlin ` (a small b and a space at the end, 7 characters) on 2: `SELECT city, length(city) AS characters, count(*) AS customers FROM customers GROUP BY city ORDER BY city;`

Folded, the three come to 10 customers: `SELECT count(*) AS customers FROM customers WHERE lower(btrim(city)) IN ('berlin', 'berlín');`

Why they are one city: every one of the ten rows has `country` `DE` (`SELECT customer_id, company_name, city, country FROM customers WHERE lower(btrim(city)) IN ('berlin', 'berlín') ORDER BY city, customer_id;`), and there is one Berlin in Germany. `Berlín` is the Spanish spelling of the same city's name. A capital letter and a trailing space are typing differences.

Nothing in cloudbyte had been changed when this count was taken.

The repair:

```sql
BEGIN;
UPDATE customers SET city = 'Berlin' WHERE lower(btrim(city)) IN ('berlin', 'berlín');
COMMIT;
```

The count just before the repair was 10, the same as above (`SELECT count(*) AS customers FROM customers WHERE lower(btrim(city)) IN ('berlin', 'berlín');`), and the tag was `UPDATE 10`. The check `SELECT customer_id, city FROM customers WHERE lower(btrim(city)) IN ('berlin', 'berlín') AND city <> 'Berlin';` returned 0 rows. The repair didn't change the total of `usage_daily.cost_eur`: it touched only `customers.city`. Had the tag come back below 10, the `UPDATE`'s `WHERE` would have missed some of the rows the count found, and I would have rolled back.

### Negative hours in usage_daily

The rule: an instance can't run for a negative number of hours in a day, so `usage_daily.hours` is never below zero. The rows that break it: `SELECT usage_id, instance_id, day, hours, cost_eur FROM usage_daily WHERE hours < 0 ORDER BY usage_id;`

*12 rows.*

Nothing in cloudbyte had been changed when this count was taken.

The repair: a negative reading is a credit typed in as usage, so the rows are deleted.

```sql
BEGIN;
DELETE FROM usage_daily WHERE hours < 0;
COMMIT;
```

The count just before the repair was 12, the same as above (`SELECT count(*) AS readings FROM usage_daily WHERE hours < 0;`), and the tag was `DELETE 12`. The check, the listing above, returned 0 rows. The repair moved the total of `usage_daily.cost_eur` up, from 1020370.6520 to 1020387.9520, because the twelve rows had negative costs; the blank rows are still 2991 (`SELECT count(*) AS usage_rows, count(cost_eur) AS with_cost, sum(cost_eur) AS total_eur FROM usage_daily;` now returns 180648, 177657, 1020387.9520).

### Acme GmbH twice in customers

The rule: each company is in `customers` once. The companies that break it, by folded name: `SELECT lower(btrim(company_name)) AS company, count(*) AS rows FROM customers GROUP BY lower(btrim(company_name)) HAVING count(*) > 1;`

*1 row.*

The company is `acme gmbh`, on two rows: `customer_id` 1 (`Acme GmbH`) and `customer_id` 41 (`ACME GmbH`).

Nothing in cloudbyte had been changed when this count was taken.

The consolidation: 1 is the original (the lower id) and 41 the copy. Rows pointing at 41 before the repair (`SELECT 'instances' AS table_name, count(*) AS rows FROM instances WHERE customer_ref = 41 UNION ALL SELECT 'tickets', count(*) FROM tickets WHERE customer_ref = 41 UNION ALL SELECT 'invoices', count(*) FROM invoices WHERE customer_ref = 41 UNION ALL SELECT 'contacts', count(*) FROM contacts WHERE customer_ref = 41 UNION ALL SELECT 'portal_hits', count(*) FROM portal_hits WHERE customer_ref = 41;`): `instances` 16, `tickets` 31, `invoices` 24, `contacts` 3, `portal_hits` 3780.

```sql
BEGIN;
UPDATE instances SET customer_ref = 1 WHERE customer_ref = 41;
UPDATE tickets SET customer_ref = 1 WHERE customer_ref = 41;
UPDATE invoices SET customer_ref = 1 WHERE customer_ref = 41;
UPDATE contacts SET customer_ref = 1 WHERE customer_ref = 41;
UPDATE portal_hits SET customer_ref = 1 WHERE customer_ref = 41;
DELETE FROM customers WHERE customer_id = 41;
COMMIT;
```

Tags: `UPDATE 16`, `UPDATE 31`, `UPDATE 24`, `UPDATE 3`, `UPDATE 3780`, `DELETE 1`. Both checks returned 0 rows: the tally with each table's id (`SELECT 'instances' AS table_name, instance_id AS id FROM instances WHERE customer_ref = 41 UNION ALL SELECT 'tickets', ticket_id FROM tickets WHERE customer_ref = 41 UNION ALL SELECT 'invoices', invoice_id FROM invoices WHERE customer_ref = 41 UNION ALL SELECT 'contacts', contact_id FROM contacts WHERE customer_ref = 41 UNION ALL SELECT 'portal_hits', hit_id FROM portal_hits WHERE customer_ref = 41;`), and the company listing above, also from a new connection after `COMMIT`. The consolidation didn't change the total of `usage_daily.cost_eur`: no `usage_daily` row was touched.

### Instance-days loaded twice in usage_daily

The rule: `usage_daily` holds one row for each instance on each day. The instance-days that break it, each with its number of rows (2 on every line): `SELECT instance_id, day, count(*) AS rows FROM usage_daily GROUP BY instance_id, day HAVING count(*) > 1 ORDER BY instance_id, day;`

*195 rows.*

Nothing in cloudbyte had been changed when this count was taken.

The repair, a self-join that keeps the row with the lower `usage_id`:

```sql
BEGIN;
DELETE FROM usage_daily a USING usage_daily b WHERE b.instance_id = a.instance_id AND b.day = a.day AND a.usage_id > b.usage_id;
COMMIT;
```

The count just before the repair was 182, not 195 (the listing above, run again). Three earlier repairs moved it: 9 of the 195 were a credit row beside a normal row, gone with the negative hours; 3 were on test-account instances and 1 on an orphan instance, gone with those two repairs. The tag was `DELETE 182`. The check, the listing above, returned 0 rows. The repair moved the total of `usage_daily.cost_eur` down, from 1009428.4480 to 1008414.6240, because each duplicate's cost had been counted twice.

### Test accounts in customers

The rule: a test account isn't a customer. The rows whose `company_name` says they are test accounts: `SELECT customer_id, company_name FROM customers WHERE company_name ILIKE '%test%' ORDER BY customer_id;`

*2 rows.*

The test accounts are `customer_id` 42 (`zz_test_account`) and 43 (`TEST-Account`). Rows linked to them, one line per table: `SELECT 'instances' AS table_name, count(*) AS rows FROM instances WHERE customer_ref IN (42, 43) UNION ALL SELECT 'invoices', count(*) FROM invoices WHERE customer_ref IN (42, 43) UNION ALL SELECT 'contacts', count(*) FROM contacts WHERE customer_ref IN (42, 43) UNION ALL SELECT 'tickets', count(*) FROM tickets WHERE customer_ref IN (42, 43) UNION ALL SELECT 'portal_hits', count(*) FROM portal_hits WHERE customer_ref IN (42, 43) UNION ALL SELECT 'usage_daily, through instances', count(*) FROM usage_daily u JOIN instances i ON i.instance_id = u.instance_id WHERE i.customer_ref IN (42, 43) UNION ALL SELECT 'invoice_lines, through invoices', count(*) FROM invoice_lines l JOIN invoices v ON v.invoice_id = l.invoice_id WHERE v.customer_ref IN (42, 43) UNION ALL SELECT 'ticket_notes, through tickets', count(*) FROM ticket_notes n JOIN tickets t ON t.ticket_id = n.ticket_id WHERE t.customer_ref IN (42, 43);`

- `instances`: 4
- `invoices`: 44
- `contacts`: 0
- `tickets`: 4
- `portal_hits`: 0
- `usage_daily`, through `instances`: 2136
- `invoice_lines`, through `invoices`: 75
- `ticket_notes`, through `tickets`: 15

Nothing in cloudbyte had been changed when this count was taken.

The repair, children first and `customers` last. The tally just before was the same as above.

```sql
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
```

Tags: `DELETE 2136`, `DELETE 75`, `DELETE 15`, `DELETE 4`, `DELETE 44`, `DELETE 4`, `DELETE 0`, `DELETE 0`, `DELETE 2`, each matching its line of the tally. Checks, all 0 rows: the tally with each table's id (`SELECT 'instances' AS table_name, instance_id AS id FROM instances WHERE customer_ref IN (42, 43) UNION ALL SELECT 'invoices', invoice_id FROM invoices WHERE customer_ref IN (42, 43) UNION ALL SELECT 'contacts', contact_id FROM contacts WHERE customer_ref IN (42, 43) UNION ALL SELECT 'tickets', ticket_id FROM tickets WHERE customer_ref IN (42, 43) UNION ALL SELECT 'portal_hits', hit_id FROM portal_hits WHERE customer_ref IN (42, 43);`), the rows left pointing at a missing parent (`SELECT 'usage_daily' AS table_name, u.usage_id AS id FROM usage_daily u WHERE NOT EXISTS (SELECT 1 FROM instances i WHERE i.instance_id = u.instance_id) UNION ALL SELECT 'invoice_lines', l.line_id FROM invoice_lines l WHERE NOT EXISTS (SELECT 1 FROM invoices v WHERE v.invoice_id = l.invoice_id) UNION ALL SELECT 'ticket_notes', n.note_id FROM ticket_notes n WHERE NOT EXISTS (SELECT 1 FROM tickets t WHERE t.ticket_id = n.ticket_id);`), and the listing above. The repair moved the total of `usage_daily.cost_eur` down, from 1020387.9520 to 1017315.5440: the test accounts' usage wasn't real spend.

### Instances that point at a customer who doesn't exist

The rule: every instance points at a customer who exists in `customers`. The rows that break it: `SELECT i.instance_id, i.customer_ref FROM instances i LEFT JOIN customers c ON i.customer_ref = c.customer_id WHERE c.customer_id IS NULL ORDER BY i.instance_id;`

*6 rows.*

Nothing in cloudbyte had been changed when this count was taken.

The repair. Counts just before: 6 orphan instances, the same as above and under `## Relationships`, and 1327 rows of `usage_daily` under them (`SELECT count(*) AS usage_rows FROM usage_daily WHERE instance_id IN (SELECT i.instance_id FROM instances i LEFT JOIN customers c ON i.customer_ref = c.customer_id WHERE c.customer_id IS NULL);`).

```sql
BEGIN;
DELETE FROM usage_daily WHERE instance_id IN (SELECT i.instance_id FROM instances i LEFT JOIN customers c ON i.customer_ref = c.customer_id WHERE c.customer_id IS NULL);
DELETE FROM instances WHERE instance_id IN (SELECT i.instance_id FROM instances i LEFT JOIN customers c ON i.customer_ref = c.customer_id WHERE c.customer_id IS NULL);
COMMIT;
```

Tags: `DELETE 1327`, `DELETE 6`. Checks, both 0 rows: the listing above, and `SELECT u.usage_id FROM usage_daily u WHERE NOT EXISTS (SELECT 1 FROM instances i WHERE i.instance_id = u.instance_id);`. The repair moved the total of `usage_daily.cost_eur` down, from 1017315.5440 to 1009428.4480.

`customers.status` holds two values, `active` on 35 rows and `churned` on 5 (`SELECT status, count(*) FROM customers GROUP BY status ORDER BY status;`), and neither is a fault: a churned customer was a real customer who left.

### The corrected figures

**Day one's top five**

The published query, behind the first table of `spend-report.md`: `SELECT city, sum(amount_eur) AS total_eur FROM billing_export GROUP BY city ORDER BY total_eur DESC LIMIT 5;`

The corrected query, which keeps each bill once, leaves out test accounts and blank amounts, and counts every spelling of Berlin as one city: `WITH each_bill AS (SELECT DISTINCT * FROM billing_export) SELECT CASE WHEN lower(btrim(city)) IN ('berlin', 'berlín') THEN 'Berlin' ELSE city END AS folded_city, sum(amount_eur) AS total_eur FROM each_bill WHERE company NOT ILIKE '%test%' AND amount_eur IS NOT NULL GROUP BY folded_city ORDER BY total_eur DESC LIMIT 5;`

| Rank | Published | Corrected |
|---|---|---|
| 1 | Bremen, 6296.25 | Berlin, 10221.05 |
| 2 | Hamburg, 5932.03 | Bremen, 5343.37 |
| 3 | Berlin, 5749.73 | Hamburg, 4858.99 |
| 4 | München, 3717.24 | München, 3185.13 |
| 5 | Berlín, 3279.31 | Jena, 2434.80 |

The rows each fault drops, counted at each stop (`WITH each_bill AS (SELECT DISTINCT * FROM billing_export) SELECT (SELECT count(*) FROM billing_export) AS all_rows, (SELECT count(*) FROM each_bill) AS once_each, (SELECT count(*) FROM each_bill WHERE company NOT ILIKE '%test%') AS no_tests, (SELECT count(*) FROM each_bill WHERE company NOT ILIKE '%test%' AND amount_eur IS NOT NULL) AS no_blanks;` returns 406, 336, 327, 306):

- bills that are in twice: 70 rows
- test accounts: 9 rows
- blank amounts: 21 rows

The published answer was wrong because Berlin's spend was split across three spellings: counted as one city, Berlin is first at 10221.05, not third at 5749.73.

**The metered cost**

|  | Old | Now |
|---|---|---|
| The figure | 1020370.6520 | 1025258.6440 |
| Rows it left out | 2991 | 0 |

The old figure left out the 2991 rows with a blank cost, and it also counted rows that later repairs deleted: credits, test-account usage, orphan instances' usage and readings loaded twice.

## Constraints

| # | the statement | what it closes |
|---:|---|---|
| 1 | `ALTER TABLE instances ADD CONSTRAINT fk_instances_customer FOREIGN KEY (customer_ref) REFERENCES customers (customer_id);` | `## Relationships`: `instances.customer_ref` → `customers.customer_id` |
| 2 | `ALTER TABLE invoices ADD CONSTRAINT fk_invoices_customer FOREIGN KEY (customer_ref) REFERENCES customers (customer_id);` | `## Relationships`: `invoices.customer_ref` → `customers.customer_id` |
| 3 | `ALTER TABLE usage_daily ADD CONSTRAINT fk_usage_daily_instance FOREIGN KEY (instance_id) REFERENCES instances (instance_id);` | `## Relationships`: `usage_daily.instance_id` → `instances.instance_id` |
| 4 | `ALTER TABLE invoice_lines ADD CONSTRAINT fk_invoice_lines_invoice FOREIGN KEY (invoice_id) REFERENCES invoices (invoice_id);` | `## Relationships`: `invoice_lines.invoice_id` → `invoices.invoice_id` |
| 5 | `ALTER TABLE usage_daily ALTER COLUMN cost_eur SET NOT NULL;` | `## Corrections`: Blank `usage_daily.cost_eur` |
| 6 | `ALTER TABLE customers ADD CONSTRAINT uq_customers_company_name UNIQUE (company_name);` | `## Corrections`: Acme GmbH twice in customers |
| 7 | `ALTER TABLE usage_daily ADD CONSTRAINT uq_usage_daily_instance_day UNIQUE (instance_id, day);` | `## Corrections`: Instance-days loaded twice in usage_daily |
| 8 | `ALTER TABLE usage_daily ADD CONSTRAINT ck_usage_daily_hours CHECK (hours >= 0 AND hours <= 24);` | `## Corrections`: Negative hours in usage_daily |
| 9 | `ALTER TABLE customers ADD CONSTRAINT ck_customers_status CHECK (status IN ('active', 'churned'));` | the sentence on the status column, below the Section 4 entries |

```sql
SELECT c.conrelid::regclass::text AS table_name, c.conname AS name,
       CASE c.contype WHEN 'f' THEN 'foreign key' WHEN 'u' THEN 'unique' ELSE 'check' END AS kind
  FROM pg_constraint c
 WHERE c.connamespace = 'public'::regnamespace AND c.contype IN ('f', 'u', 'c')
UNION ALL
SELECT a.attrelid::regclass::text, a.attname::text, 'not null'
  FROM pg_attribute a JOIN pg_class r ON r.oid = a.attrelid
 WHERE r.relnamespace = 'public'::regnamespace AND r.relkind = 'r'
   AND a.attnum > 0 AND NOT a.attisdropped AND a.attnotnull
   AND NOT EXISTS (SELECT 1 FROM pg_constraint p
                    WHERE p.conrelid = a.attrelid AND p.contype = 'p' AND a.attnum = ANY (p.conkey))
ORDER BY table_name, name;
```

```
  table_name   |            name             |    kind     
---------------+-----------------------------+-------------
 customers     | ck_customers_status         | check
 customers     | uq_customers_company_name   | unique
 instances     | fk_instances_customer       | foreign key
 invoice_lines | fk_invoice_lines_invoice    | foreign key
 invoices      | fk_invoices_customer        | foreign key
 usage_daily   | ck_usage_daily_hours        | check
 usage_daily   | cost_eur                    | not null
 usage_daily   | fk_usage_daily_instance     | foreign key
 usage_daily   | uq_usage_daily_instance_day | unique
(9 rows)
```

The unique constraint on `company_name` refuses a second `Acme GmbH` spelled exactly the same, but it lets in `ACME GmbH`, because to PostgreSQL different capital letters make different text (`SELECT company_name, company_name = 'ACME GmbH' AS same_text FROM customers WHERE lower(btrim(company_name)) = 'acme gmbh';` prints `f`).

In `customers.status`, `active` means a customer who still buys from CloudByte, and `churned` means a real customer who has left.

## The slow report

Kate's monthly report, the spend per day for September 2025:

```sql
SELECT u.day, sum(u.cost_eur) AS spend
FROM usage_daily u
WHERE u.day BETWEEN DATE '2025-09-01' AND DATE '2025-09-30'
GROUP BY u.day ORDER BY u.day;
```

| | node type on the line that names `usage_daily u` | `Buffers:` under that line |
|---|---|---|
| Before the index | `Parallel Seq Scan` | 1200 pages (`shared hit=1200`) |
| After the index | `Index Only Scan` | 43 pages (`shared hit=1 read=42`) |

The kept index:

```sql
CREATE INDEX ix_usage_daily_day ON usage_daily (day, cost_eur);
```

Why it helps: before it, `usage_daily` held two indexes, `usage_daily_pkey` sorted by `usage_id` first and `uq_usage_daily_instance_day` sorted by `instance_id` first. The report's `WHERE` tests `day`, so neither could find September's rows, and the scan read every page. `ix_usage_daily_day` sorts by `day` first, so September's entries sit together, and it also holds `cost_eur`, the one other column the report reads, so the report is answered from the index alone.

The before plan can't be re-run while the kept index is on the table: drop `ix_usage_daily_day` to see it again.

## The blocked session

A second role, `henry`, holds the `UPDATE` privilege on `customers`. While `henry`'s session held a row lock on customer 2, my own `UPDATE` of the same row waited. I found out who was in the way with this query:

```sql
SELECT w.usename AS waiting, w.wait_event_type, w.wait_event, w.query AS waiting_query,
       b.usename AS blocking, b.state AS blocking_state, b.query AS blocking_query
FROM pg_stat_activity w
JOIN pg_stat_activity b ON b.pid = ANY (pg_blocking_pids(w.pid))
WHERE w.wait_event_type = 'Lock'
  AND w.pid <> pg_backend_pid();
```

The record it printed, taken while my session waited (printed with expanded display, `\x on`):

```
-[ RECORD 1 ]---+-------------------------------------------------------------
waiting         | ops_admin
wait_event_type | Lock
wait_event      | transactionid
waiting_query   | UPDATE customers SET city = 'Dresden' WHERE customer_id = 2;
blocking        | henry
blocking_state  | idle in transaction
blocking_query  | UPDATE customers SET city = 'Leipzig' WHERE customer_id = 2;
```

The statement that held the lock, confirmed by the person who held it as the one statement they ran since `BEGIN;`:

```sql
UPDATE customers SET city = 'Leipzig' WHERE customer_id = 2;
```

What I'd do: when a session that isn't mine blocks mine and sits `idle in transaction`, I ask its owner to end their transaction with `COMMIT;` or `ROLLBACK;`, rather than end their session. Ending a session rolls back its whole open transaction, and `blocking_query` shows only its last statement, so I could undo work I can't see. On this instance I couldn't end it anyway: PostgreSQL refused my attempt to end `henry`'s session with `ERROR:  permission denied to terminate process`.

On a quiet database, when no session waits for a lock, the query returns no rows: `(0 rows)`.
