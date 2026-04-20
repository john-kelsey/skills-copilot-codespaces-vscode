# Step-by-Step Microsoft Access Setup Guide

## Prerequisites
- Microsoft Access 2016, 2019, 2021, or Microsoft 365
- No prior Access experience required

---

## Step 1 – Create the Database File

1. Open **Microsoft Access**.
2. Click **Blank database**.
3. Name the file **`AzaniISP.accdb`** and click **Create**.

---

## Step 2 – Open the SQL Query Editor

1. Click the **Create** tab in the ribbon.
2. Click **Query Design**.
3. When the "Show Table" dialog appears, click **Close** (do not add any tables).
4. In the ribbon, click **Home → View → SQL View**.

You now see an empty SQL editor. This is where you paste all SQL code.

---

## Step 3 – Create Each Table

Open the file `sql/01_create_tables.sql`.

For **each** `CREATE TABLE` block:

1. Select all text in the SQL editor and **delete** it.
2. Paste one `CREATE TABLE` block (from the first `CREATE TABLE` line to the closing `;`).
3. Click the **Run (!)** button (red exclamation mark in the ribbon).
4. If asked "Do you want to modify the table or proceed?" → click **Yes**.
5. Close the query tab (do **not** save it).

> **Always create tables in this exact order** (child tables need their parent tables first):

| # | Table Name |
|---|------------|
| 1 | tblBandwidth |
| 2 | tblLANTiers |
| 3 | tblInstitutions |
| 4 | tblInfrastructure |
| 5 | tblSubscriptions |
| 6 | tblMonthlyBills |
| 7 | tblPayments |

---

## Step 4 – Insert Lookup Data

Open `sql/02_insert_lookup_data.sql`.

1. Paste **all 5 `tblBandwidth` INSERT lines** and click **Run (!)**.
2. Clear the editor, paste **all 5 `tblLANTiers` INSERT lines** and click **Run (!)**.

---

## Step 5 – Insert Sample Data

Open `sql/03_insert_sample_data.sql`.

Run each section (A through E) separately:

| Section | Content |
|---------|---------|
| A | 8 institutions |
| B | Infrastructure purchases |
| C | Subscriptions |
| D | Monthly bills |
| E | Payments |

Paste each section's INSERT statements and click **Run (!)** before moving to the next.

---

## Step 6 – Set Up Relationships (Foreign Keys)

1. Click **Database Tools → Relationships**.
2. In the "Show Table" dialog, double-click every table to add it, then click **Close**.
3. Drag fields to create the following links:

| From (child table) | Field | To (parent table) | Field |
|--------------------|-------|-------------------|-------|
| tblInfrastructure | InstitutionID | tblInstitutions | InstitutionID |
| tblInfrastructure | LANTierID | tblLANTiers | LANTierID |
| tblSubscriptions | InstitutionID | tblInstitutions | InstitutionID |
| tblSubscriptions | BandwidthID | tblBandwidth | BandwidthID |
| tblSubscriptions | PreviousBandwidthID | tblBandwidth | BandwidthID |
| tblMonthlyBills | InstitutionID | tblInstitutions | InstitutionID |
| tblMonthlyBills | SubscriptionID | tblSubscriptions | SubscriptionID |
| tblPayments | InstitutionID | tblInstitutions | InstitutionID |
| tblPayments | BillID | tblMonthlyBills | BillID |

4. For each link, tick **Enforce Referential Integrity** → click **Create**.
5. Click **Save** (Ctrl+S).

---

## Step 7 – Create Named Queries

Open `sql/04_queries.sql`.

For each query block:

1. Paste the SQL into SQL View.
2. Click **Run (!)** to verify no errors.
3. Close the query tab.
4. When asked "Do you want to save changes?", click **Yes**.
5. Enter the query name shown in the comment above the SQL block
   (e.g. `qRegisteredInstitutions`).

---

## Step 8 – Generate Reports

For each saved query:

1. Right-click the query in the **Navigation Pane** (left panel).
2. Select **Report Wizard**.
3. Move all fields to the right column → click **Next**.
4. Add grouping if required (e.g. group by Category) → **Next**.
5. Choose a sort order → **Next**.
6. Select **Tabular** layout → **Next**.
7. Give the report a name and click **Finish**.

---

## Troubleshooting

| Error Message | Cause | Fix |
|---------------|-------|-----|
| "Table ... already exists" | Table was already created | Skip that block |
| "Syntax error in CREATE TABLE" | Pasted more than one block at once | Clear and paste one block only |
| "No current record" after INSERT | Parent table not yet populated | Run files in order: 01 → 02 → 03 |
| Date not recognised | Wrong date format | Use `#YYYY/MM/DD#` exactly |
| "Can't have more than one autonumber" | CREATE TABLE run twice | Delete the table in Navigation Pane and re-run |

---

## Quick Reference: Payment Types in tblPayments

| PaymentType value | When used |
|-------------------|-----------|
| `Registration` | One-time KSh 8,500 on sign-up |
| `Installation` | KSh 10,000 when institution is ready |
| `Infrastructure` | PCs and/or LAN nodes purchase |
| `Monthly` | Regular monthly service charge |
| `OverdueFine` | 15% penalty on late payment |
| `Reconnection` | KSh 1,000 after disconnection |
