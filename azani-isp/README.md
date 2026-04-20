# Azani ISP Information System
### KCSE 2026 – Computer Studies Paper 3

A complete Microsoft Access database project for the **Azani Internet Service Provider Information System**.

## Contents

| File | Purpose |
|------|---------|
| `sql/01_create_tables.sql` | CREATE TABLE statements (run one table at a time) |
| `sql/02_insert_lookup_data.sql` | Pre-populate tblBandwidth and tblLANTiers |
| `sql/03_insert_sample_data.sql` | 8 institutions with mixed scenarios |
| `sql/04_queries.sql` | All SELECT queries for Tasks 3–5 |
| `docs/setup_guide.md` | Step-by-step Access import guide |
| `docs/data_dictionary.md` | Full field reference for all 7 tables |
| `vba/modAzaniISP.bas` | VBA module – business logic, billing, payments |
| `vba/FORMS_VBA.md` | Ready-to-paste VBA event code for all 6 forms |

## Quick Start

1. Open Microsoft Access → Create a new blank `.accdb` database named `AzaniISP.accdb`.
2. Go to **Create → Query Design**, then close the Show Table dialog.
3. Switch to **SQL View** via Home → View → SQL View.
4. Run each `.sql` file **in order** (01 → 02 → 03 → 04), pasting one block at a time and clicking **Run (!)**.
5. After all tables exist, open **Database Tools → Relationships** and add the foreign-key links described in `docs/data_dictionary.md`.

## VBA Quick Start

6. Press **Alt + F11** to open the VBA Editor.
7. Choose **File → Import File…**, browse to `vba/modAzaniISP.bas`, click **Open**.
8. The module `modAzaniISP` appears in the Project pane – all business-logic functions are now available database-wide.
9. When building forms, paste the event procedures from `vba/FORMS_VBA.md` into the corresponding form modules (open the form in Design View → select a control → Property Sheet → Event tab → `[…]` → Code Builder).

## Business Rules

| Rule | Detail |
|------|--------|
| Registration fee | KSh 8,500 (one-time, all institutions) |
| Installation fee | KSh 10,000 (only if IsReadyForInstall = Yes) |
| PC unit cost | KSh 40,000 each |
| LAN nodes | Tiered pricing – see tblLANTiers |
| Upgrade discount | 10% off the new bandwidth monthly rate |
| Late-payment fine | 15% of the monthly charge |
| Disconnection trigger | Bill unpaid by the 10th of the following month |
| Reconnection fee | KSh 1,000 |

## Table Overview

```
tblBandwidth        – 5 bandwidth tiers + monthly rates
tblLANTiers         – LAN node pricing by quantity range
tblInstitutions     – Master registration record
tblInfrastructure   – PCs and LAN nodes purchased
tblSubscriptions    – Bandwidth subscription + upgrade history
tblMonthlyBills     – Monthly invoices, fines, and status
tblPayments         – Every financial transaction
```
