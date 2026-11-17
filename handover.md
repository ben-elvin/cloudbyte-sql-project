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
