-- ============================================================
-- AZANI INTERNET SERVICE PROVIDER INFORMATION SYSTEM
-- KCSE 2026 – Computer Studies Paper 3
-- FILE 1 OF 4: CREATE TABLES
-- ============================================================
-- HOW TO USE IN MICROSOFT ACCESS:
--   1. Open a new blank query in SQL View.
--   2. Paste ONE CREATE TABLE block at a time.
--   3. Click Run (!).  Repeat for every table.
--   4. Run tables IN ORDER (lookup tables first).
-- ============================================================


-- ============================================================
-- TABLE 1: tblBandwidth
-- Lookup table – 5 bandwidth tiers with monthly rates.
-- ============================================================
CREATE TABLE tblBandwidth (
    BandwidthID   AUTOINCREMENT  CONSTRAINT PK_Bandwidth PRIMARY KEY,
    BandwidthMbps INTEGER        NOT NULL,
    Description   TEXT(50)       NOT NULL,
    MonthlyRate   CURRENCY       NOT NULL
);


-- ============================================================
-- TABLE 2: tblLANTiers
-- Lookup table – LAN node pricing by quantity range.
-- ============================================================
CREATE TABLE tblLANTiers (
    LANTierID   AUTOINCREMENT  CONSTRAINT PK_LANTier PRIMARY KEY,
    NodesFrom   INTEGER        NOT NULL,
    NodesTo     INTEGER        NOT NULL,
    CostPerNode CURRENCY       NOT NULL,
    Description TEXT(80)
);


-- ============================================================
-- TABLE 3: tblInstitutions
-- Master registration record for every client institution.
-- ============================================================
CREATE TABLE tblInstitutions (
    InstitutionID       AUTOINCREMENT  CONSTRAINT PK_Institutions PRIMARY KEY,
    InstitutionName     TEXT(150)      NOT NULL,
    Category            TEXT(20)       NOT NULL,
    County              TEXT(60)       NOT NULL,
    Town                TEXT(60),
    PostalAddress       TEXT(80),
    PhoneNumber         TEXT(20),
    EmailAddress        TEXT(100),
    ContactPersonName   TEXT(100)      NOT NULL,
    ContactPersonPhone  TEXT(20),
    ContactPersonEmail  TEXT(100),
    RegistrationDate    DATETIME       NOT NULL,
    RegistrationFee     CURRENCY       NOT NULL DEFAULT 8500,
    IsReadyForInstall   YESNO          NOT NULL DEFAULT No,
    InstallationDate    DATETIME,
    InstallationFee     CURRENCY                DEFAULT 10000,
    ServiceStatus       TEXT(20)       NOT NULL DEFAULT 'Registered'
);


-- ============================================================
-- TABLE 4: tblInfrastructure
-- PCs and LAN nodes purchased from Azani per institution.
-- FK: InstitutionID -> tblInstitutions.InstitutionID
-- FK: LANTierID     -> tblLANTiers.LANTierID
-- ============================================================
CREATE TABLE tblInfrastructure (
    InfraID          AUTOINCREMENT  CONSTRAINT PK_Infra PRIMARY KEY,
    InstitutionID    INTEGER        NOT NULL,
    PurchaseDate     DATETIME       NOT NULL,
    NumPCsPurchased  INTEGER        NOT NULL DEFAULT 0,
    PCUnitCost       CURRENCY       NOT NULL DEFAULT 40000,
    TotalPCCost      CURRENCY       NOT NULL DEFAULT 0,
    LANNodesBought   INTEGER        NOT NULL DEFAULT 0,
    LANTierID        INTEGER,
    LANNodeUnitCost  CURRENCY                DEFAULT 0,
    TotalLANCost     CURRENCY       NOT NULL DEFAULT 0,
    TotalInfraCost   CURRENCY       NOT NULL DEFAULT 0,
    Notes            TEXT(255)
);


-- ============================================================
-- TABLE 5: tblSubscriptions
-- Bandwidth subscription + upgrade history per institution.
-- FK: InstitutionID       -> tblInstitutions.InstitutionID
-- FK: BandwidthID         -> tblBandwidth.BandwidthID
-- FK: PreviousBandwidthID -> tblBandwidth.BandwidthID
-- ============================================================
CREATE TABLE tblSubscriptions (
    SubscriptionID       AUTOINCREMENT  CONSTRAINT PK_Subscriptions PRIMARY KEY,
    InstitutionID        INTEGER        NOT NULL,
    BandwidthID          INTEGER        NOT NULL,
    PreviousBandwidthID  INTEGER,
    SubscriptionDate     DATETIME       NOT NULL,
    IsUpgraded           YESNO          NOT NULL DEFAULT No,
    UpgradeDate          DATETIME,
    DiscountPercent      CURRENCY       NOT NULL DEFAULT 0,
    BaseMonthlyRate      CURRENCY       NOT NULL,
    DiscountAmount       CURRENCY       NOT NULL DEFAULT 0,
    EffectiveMonthlyRate CURRENCY       NOT NULL,
    IsActive             YESNO          NOT NULL DEFAULT Yes
);


-- ============================================================
-- TABLE 6: tblMonthlyBills
-- Monthly invoices with due dates, fines, and status.
-- FK: InstitutionID  -> tblInstitutions.InstitutionID
-- FK: SubscriptionID -> tblSubscriptions.SubscriptionID
-- ============================================================
CREATE TABLE tblMonthlyBills (
    BillID            AUTOINCREMENT  CONSTRAINT PK_Bills PRIMARY KEY,
    InstitutionID     INTEGER        NOT NULL,
    SubscriptionID    INTEGER        NOT NULL,
    BillingMonth      INTEGER        NOT NULL,
    BillingYear       INTEGER        NOT NULL,
    BillGeneratedDate DATETIME       NOT NULL,
    DueDate           DATETIME       NOT NULL,
    MonthlyCharge     CURRENCY       NOT NULL,
    OverdueFineRate   CURRENCY       NOT NULL DEFAULT 0.15,
    OverdueFineAmount CURRENCY       NOT NULL DEFAULT 0,
    ReconnectionFee   CURRENCY       NOT NULL DEFAULT 0,
    TotalAmountDue    CURRENCY       NOT NULL,
    PaidAmount        CURRENCY       NOT NULL DEFAULT 0,
    PaymentDate       DATETIME,
    BillStatus        TEXT(20)       NOT NULL DEFAULT 'Unpaid',
    DisconnectionDate DATETIME,
    ReconnectionDate  DATETIME
);


-- ============================================================
-- TABLE 7: tblPayments
-- Every financial transaction (all payment types).
-- FK: InstitutionID -> tblInstitutions.InstitutionID
-- FK: BillID        -> tblMonthlyBills.BillID
-- ============================================================
CREATE TABLE tblPayments (
    PaymentID       AUTOINCREMENT  CONSTRAINT PK_Payments PRIMARY KEY,
    InstitutionID   INTEGER        NOT NULL,
    BillID          INTEGER,
    PaymentDate     DATETIME       NOT NULL,
    PaymentType     TEXT(30)       NOT NULL,
    AmountPaid      CURRENCY       NOT NULL,
    PaymentMethod   TEXT(30),
    ReferenceNumber TEXT(50),
    ReceivedBy      TEXT(100),
    Notes           TEXT(255)
);
