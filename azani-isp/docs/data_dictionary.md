# Data Dictionary – Azani ISP Information System

All monetary amounts are in **Kenya Shillings (KSh)**.

---

## tblBandwidth
Lookup table for the 5 available bandwidth tiers and their monthly rates.

| Field | Data Type | Size | Description |
|-------|-----------|------|-------------|
| BandwidthID | AUTOINCREMENT | – | Primary key |
| BandwidthMbps | INTEGER | – | Speed in Mbps: 2, 5, 10, 20, or 50 |
| Description | TEXT | 50 | Human-readable label e.g. "10 Mbps" |
| MonthlyRate | CURRENCY | – | Monthly charge in KSh |

**Relationships:** Referenced by tblSubscriptions (BandwidthID and PreviousBandwidthID).

---

## tblLANTiers
Lookup table for LAN node pricing by quantity range.

| Field | Data Type | Size | Description |
|-------|-----------|------|-------------|
| LANTierID | AUTOINCREMENT | – | Primary key |
| NodesFrom | INTEGER | – | Lower bound of the node count range |
| NodesTo | INTEGER | – | Upper bound of the node count range |
| CostPerNode | CURRENCY | – | Price per node in KSh for this range |
| Description | TEXT | 80 | Tier label e.g. "11 to 20 nodes" |

**Tier summary:**

| Tier | Range | Cost per Node |
|------|-------|---------------|
| 1 | 1 – 10 | KSh 2,500 |
| 2 | 11 – 20 | KSh 2,200 |
| 3 | 21 – 50 | KSh 2,000 |
| 4 | 51 – 100 | KSh 1,800 |
| 5 | Over 100 | KSh 1,500 |

**Relationships:** Referenced by tblInfrastructure (LANTierID).

---

## tblInstitutions
Master registration record for every client institution.

| Field | Data Type | Size | Description |
|-------|-----------|------|-------------|
| InstitutionID | AUTOINCREMENT | – | Primary key |
| InstitutionName | TEXT | 150 | Full official institution name |
| Category | TEXT | 20 | Primary / Junior / Senior / College |
| County | TEXT | 60 | County name |
| Town | TEXT | 60 | Town or area within county |
| PostalAddress | TEXT | 80 | P.O. Box address |
| PhoneNumber | TEXT | 20 | Main institution phone |
| EmailAddress | TEXT | 100 | Main institution email |
| ContactPersonName | TEXT | 100 | Name of the Azani ISP contact person |
| ContactPersonPhone | TEXT | 20 | Contact person's phone number |
| ContactPersonEmail | TEXT | 100 | Contact person's email address |
| RegistrationDate | DATETIME | – | Date the institution registered |
| RegistrationFee | CURRENCY | – | Always KSh 8,500 |
| IsReadyForInstall | YESNO | – | Yes = passed readiness assessment |
| InstallationDate | DATETIME | – | Date installation was completed (Null if not ready) |
| InstallationFee | CURRENCY | – | KSh 10,000 (only charged if IsReadyForInstall = Yes) |
| ServiceStatus | TEXT | 20 | Registered / Active / Disconnected |

**Relationships:** Parent table – referenced by tblInfrastructure, tblSubscriptions, tblMonthlyBills, tblPayments.

---

## tblInfrastructure
Records PCs and LAN nodes purchased from Azani ISP per institution.

| Field | Data Type | Size | Description |
|-------|-----------|------|-------------|
| InfraID | AUTOINCREMENT | – | Primary key |
| InstitutionID | INTEGER | – | FK → tblInstitutions |
| PurchaseDate | DATETIME | – | Date of purchase |
| NumPCsPurchased | INTEGER | – | Number of PCs bought |
| PCUnitCost | CURRENCY | – | KSh 40,000 per PC |
| TotalPCCost | CURRENCY | – | NumPCsPurchased × PCUnitCost |
| LANNodesBought | INTEGER | – | Number of LAN nodes bought |
| LANTierID | INTEGER | – | FK → tblLANTiers (determines node unit cost) |
| LANNodeUnitCost | CURRENCY | – | Cost per LAN node from the applicable tier |
| TotalLANCost | CURRENCY | – | LANNodesBought × LANNodeUnitCost |
| TotalInfraCost | CURRENCY | – | TotalPCCost + TotalLANCost |
| Notes | TEXT | 255 | Optional notes |

**Relationships:** InstitutionID → tblInstitutions; LANTierID → tblLANTiers.

---

## tblSubscriptions
Active bandwidth subscription and upgrade history for each institution.

| Field | Data Type | Size | Description |
|-------|-----------|------|-------------|
| SubscriptionID | AUTOINCREMENT | – | Primary key |
| InstitutionID | INTEGER | – | FK → tblInstitutions |
| BandwidthID | INTEGER | – | FK → tblBandwidth (current bandwidth tier) |
| PreviousBandwidthID | INTEGER | – | FK → tblBandwidth (tier before upgrade); Null if never upgraded |
| SubscriptionDate | DATETIME | – | Date subscription started |
| IsUpgraded | YESNO | – | Yes = this subscription is an upgrade |
| UpgradeDate | DATETIME | – | Date bandwidth was upgraded |
| DiscountPercent | CURRENCY | – | 10 for upgraded subscriptions; 0 otherwise |
| BaseMonthlyRate | CURRENCY | – | Monthly rate from tblBandwidth |
| DiscountAmount | CURRENCY | – | BaseMonthlyRate × DiscountPercent / 100 |
| EffectiveMonthlyRate | CURRENCY | – | BaseMonthlyRate − DiscountAmount |
| IsActive | YESNO | – | Yes = currently active subscription |

**Relationships:** InstitutionID → tblInstitutions; BandwidthID → tblBandwidth; PreviousBandwidthID → tblBandwidth.

---

## tblMonthlyBills
Monthly invoices generated for every active institution.

| Field | Data Type | Size | Description |
|-------|-----------|------|-------------|
| BillID | AUTOINCREMENT | – | Primary key |
| InstitutionID | INTEGER | – | FK → tblInstitutions |
| SubscriptionID | INTEGER | – | FK → tblSubscriptions |
| BillingMonth | INTEGER | – | 1 = January … 12 = December |
| BillingYear | INTEGER | – | Four-digit year e.g. 2026 |
| BillGeneratedDate | DATETIME | – | Date the bill was created |
| DueDate | DATETIME | – | Last day of the billing month |
| MonthlyCharge | CURRENCY | – | EffectiveMonthlyRate from tblSubscriptions |
| OverdueFineRate | CURRENCY | – | 0.15 (represents 15%) |
| OverdueFineAmount | CURRENCY | – | MonthlyCharge × 0.15 if payment is late; else 0 |
| ReconnectionFee | CURRENCY | – | KSh 1,000 if reconnected; else 0 |
| TotalAmountDue | CURRENCY | – | MonthlyCharge + OverdueFineAmount + ReconnectionFee |
| PaidAmount | CURRENCY | – | Total amount actually received |
| PaymentDate | DATETIME | – | Date payment was received |
| BillStatus | TEXT | 20 | Unpaid / Paid / Overdue / Disconnected / Reconnected |
| DisconnectionDate | DATETIME | – | Date service was disconnected (Null if not disconnected) |
| ReconnectionDate | DATETIME | – | Date service was reconnected (Null if not reconnected) |

**Disconnection rule:** If a bill is unpaid by the 10th of the following month, the service is disconnected and a KSh 1,000 reconnection fee is added.

**Relationships:** InstitutionID → tblInstitutions; SubscriptionID → tblSubscriptions.

---

## tblPayments
Records every individual financial transaction.

| Field | Data Type | Size | Description |
|-------|-----------|------|-------------|
| PaymentID | AUTOINCREMENT | – | Primary key |
| InstitutionID | INTEGER | – | FK → tblInstitutions |
| BillID | INTEGER | – | FK → tblMonthlyBills; Null for non-bill payments |
| PaymentDate | DATETIME | – | Date the payment was received |
| PaymentType | TEXT | 30 | See payment types below |
| AmountPaid | CURRENCY | – | Amount in KSh |
| PaymentMethod | TEXT | 30 | Cash / Cheque / M-Pesa / Bank Transfer |
| ReferenceNumber | TEXT | 50 | Receipt or transaction reference number |
| ReceivedBy | TEXT | 100 | Name of the clerk who received payment |
| Notes | TEXT | 255 | Optional notes |

**PaymentType values:**

| Value | Description |
|-------|-------------|
| Registration | One-time KSh 8,500 registration fee |
| Installation | KSh 10,000 installation fee (ready institutions only) |
| Infrastructure | Payment for PCs and/or LAN nodes |
| Monthly | Regular monthly service charge |
| OverdueFine | 15% overdue penalty |
| Reconnection | KSh 1,000 reconnection fee |

**Relationships:** InstitutionID → tblInstitutions; BillID → tblMonthlyBills.

---

## Entity Relationship Summary

```
tblBandwidth ──────────────┐
                           ├── tblSubscriptions ── tblMonthlyBills ── tblPayments
tblInstitutions ───────────┘         │                    │                │
       │                             │                    └────────────────┘
       └── tblInfrastructure
                │
           tblLANTiers
```
