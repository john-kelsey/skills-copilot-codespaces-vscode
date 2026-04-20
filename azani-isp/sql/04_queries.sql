-- ============================================================
-- FILE 4 OF 4: KEY QUERIES FOR THE PROJECT REQUIREMENTS
-- ============================================================
-- HOW TO USE IN MICROSOFT ACCESS:
--   1. Open a new blank query in SQL View.
--   2. Paste ONE query block.
--   3. Click Run (!) to test it.
--   4. Close the query tab → click Yes to save → type the name.
-- ============================================================


-- ----------------------------------------------------------
-- qRegisteredInstitutions
-- Task 3: All institutions grouped by category.
-- ----------------------------------------------------------
SELECT
    i.InstitutionID,
    i.InstitutionName,
    i.Category,
    i.County,
    i.Town,
    i.ContactPersonName,
    i.ContactPersonPhone,
    i.ContactPersonEmail,
    i.RegistrationDate,
    i.RegistrationFee,
    i.ServiceStatus
FROM tblInstitutions AS i
ORDER BY i.Category, i.InstitutionName;


-- ----------------------------------------------------------
-- qDefaulters
-- Task 3: Institutions with unpaid or overdue bills.
-- ----------------------------------------------------------
SELECT
    i.InstitutionName,
    i.Category,
    i.County,
    i.ContactPersonName,
    i.ContactPersonPhone,
    b.BillingMonth,
    b.BillingYear,
    b.MonthlyCharge,
    b.OverdueFineAmount,
    b.TotalAmountDue,
    b.PaidAmount,
    (b.TotalAmountDue - b.PaidAmount) AS BalanceOwing,
    b.BillStatus,
    b.DueDate
FROM tblInstitutions AS i
INNER JOIN tblMonthlyBills AS b ON i.InstitutionID = b.InstitutionID
WHERE b.BillStatus IN ('Unpaid','Overdue')
ORDER BY b.BillingYear, b.BillingMonth, i.InstitutionName;


-- ----------------------------------------------------------
-- qDisconnectedInstitutions
-- Task 3: Disconnection and reconnection details.
-- ----------------------------------------------------------
SELECT
    i.InstitutionName,
    i.Category,
    i.County,
    i.ContactPersonName,
    i.ContactPersonPhone,
    b.BillingMonth,
    b.BillingYear,
    b.MonthlyCharge,
    b.OverdueFineAmount,
    b.ReconnectionFee,
    b.TotalAmountDue,
    b.BillStatus,
    b.DisconnectionDate,
    b.ReconnectionDate
FROM tblInstitutions AS i
INNER JOIN tblMonthlyBills AS b ON i.InstitutionID = b.InstitutionID
WHERE b.BillStatus IN ('Disconnected','Reconnected')
ORDER BY b.DisconnectionDate DESC;


-- ----------------------------------------------------------
-- qInfrastructureDetails
-- Task 3: PC and LAN node purchases per institution.
-- ----------------------------------------------------------
SELECT
    i.InstitutionName,
    i.Category,
    i.County,
    i.IsReadyForInstall,
    inf.PurchaseDate,
    inf.NumPCsPurchased,
    inf.PCUnitCost,
    inf.TotalPCCost,
    inf.LANNodesBought,
    lt.Description       AS LANTierDescription,
    inf.LANNodeUnitCost,
    inf.TotalLANCost,
    inf.TotalInfraCost
FROM tblInstitutions AS i
LEFT JOIN tblInfrastructure AS inf ON i.InstitutionID = inf.InstitutionID
LEFT JOIN tblLANTiers AS lt        ON inf.LANTierID   = lt.LANTierID
ORDER BY i.Category, i.InstitutionName;


-- ----------------------------------------------------------
-- qTotalInstallationCost
-- Task 4a: Installation fee + infrastructure cost per institution.
-- ----------------------------------------------------------
SELECT
    i.InstitutionName,
    i.Category,
    i.County,
    IIF(i.IsReadyForInstall=True, i.InstallationFee, 0)        AS InstallationFee,
    IIF(inf.TotalInfraCost IS NULL, 0, inf.TotalInfraCost)     AS InfrastructureCost,
    IIF(i.IsReadyForInstall=True, i.InstallationFee, 0)
      + IIF(inf.TotalInfraCost IS NULL, 0, inf.TotalInfraCost) AS TotalInstallationCost
FROM tblInstitutions AS i
LEFT JOIN tblInfrastructure AS inf ON i.InstitutionID = inf.InstitutionID
ORDER BY TotalInstallationCost DESC;


-- ----------------------------------------------------------
-- qPCAndLANCost
-- Task 4b: PC cost and LAN cost for institutions with hardware.
-- ----------------------------------------------------------
SELECT
    i.InstitutionName,
    i.Category,
    inf.NumPCsPurchased,
    inf.PCUnitCost,
    inf.TotalPCCost,
    inf.LANNodesBought,
    lt.Description              AS LANTier,
    inf.LANNodeUnitCost,
    inf.TotalLANCost,
    (inf.TotalPCCost + inf.TotalLANCost) AS TotalPCAndLANCost
FROM tblInstitutions AS i
INNER JOIN tblInfrastructure AS inf ON i.InstitutionID = inf.InstitutionID
INNER JOIN tblLANTiers AS lt        ON inf.LANTierID   = lt.LANTierID
WHERE inf.NumPCsPurchased > 0 OR inf.LANNodesBought > 0
ORDER BY TotalPCAndLANCost DESC;


-- ----------------------------------------------------------
-- qUpgradedMonthlyCharges
-- Task 4c: Monthly charges for upgraded subscriptions (10% discount).
-- ----------------------------------------------------------
SELECT
    i.InstitutionName,
    i.Category,
    bwp.BandwidthMbps & ' Mbps'  AS PreviousBandwidth,
    bw.BandwidthMbps  & ' Mbps'  AS CurrentBandwidth,
    s.BaseMonthlyRate,
    s.DiscountPercent             AS DiscountPct,
    s.DiscountAmount,
    s.EffectiveMonthlyRate        AS MonthlyChargeAfterDiscount
FROM tblInstitutions AS i
INNER JOIN tblSubscriptions AS s   ON i.InstitutionID       = s.InstitutionID
INNER JOIN tblBandwidth     AS bw  ON s.BandwidthID         = bw.BandwidthID
LEFT  JOIN tblBandwidth     AS bwp ON s.PreviousBandwidthID = bwp.BandwidthID
WHERE s.IsUpgraded = True
ORDER BY s.EffectiveMonthlyRate DESC;


-- ----------------------------------------------------------
-- qMonthlyChargesByCategory
-- Task 4d: Monthly charges, fines, and reconnection fees by category.
-- ----------------------------------------------------------
SELECT
    i.Category,
    SUM(b.MonthlyCharge)     AS TotalMonthlyCharges,
    SUM(b.OverdueFineAmount) AS TotalOverdueFines,
    SUM(b.ReconnectionFee)   AS TotalReconnectionFees,
    SUM(b.TotalAmountDue)    AS GrandTotal
FROM tblInstitutions AS i
INNER JOIN tblMonthlyBills AS b ON i.InstitutionID = b.InstitutionID
GROUP BY i.Category
ORDER BY GrandTotal DESC;


-- ----------------------------------------------------------
-- qAggregatePaymentsByInstitution
-- Task 4e: All payment types aggregated per institution.
-- ----------------------------------------------------------
SELECT
    i.InstitutionName,
    i.Category,
    SUM(IIF(p.PaymentType='Registration',   p.AmountPaid, 0)) AS RegistrationPaid,
    SUM(IIF(p.PaymentType='Installation',   p.AmountPaid, 0)) AS InstallationPaid,
    SUM(IIF(p.PaymentType='Infrastructure', p.AmountPaid, 0)) AS InfrastructurePaid,
    SUM(IIF(p.PaymentType='Monthly',        p.AmountPaid, 0)) AS MonthlyServicePaid,
    SUM(IIF(p.PaymentType='OverdueFine',    p.AmountPaid, 0)) AS OverdueFinesPaid,
    SUM(IIF(p.PaymentType='Reconnection',   p.AmountPaid, 0)) AS ReconnectionPaid,
    SUM(p.AmountPaid)                                         AS TotalAllPayments
FROM tblInstitutions AS i
INNER JOIN tblPayments AS p ON i.InstitutionID = p.InstitutionID
GROUP BY i.InstitutionName, i.Category
ORDER BY i.InstitutionName;


-- ----------------------------------------------------------
-- qMonthlySummaryReport
-- Task 5: Full billing report with bandwidth and status details.
-- ----------------------------------------------------------
SELECT
    i.InstitutionName,
    i.Category,
    b.BillingYear,
    b.BillingMonth,
    bw.Description                    AS Bandwidth,
    s.IsUpgraded,
    s.EffectiveMonthlyRate            AS MonthlyCharge,
    b.OverdueFineAmount,
    b.ReconnectionFee,
    b.TotalAmountDue,
    b.PaidAmount,
    (b.TotalAmountDue - b.PaidAmount) AS Balance,
    b.BillStatus,
    b.DueDate,
    b.PaymentDate
FROM tblInstitutions  AS i
INNER JOIN tblMonthlyBills  AS b  ON i.InstitutionID  = b.InstitutionID
INNER JOIN tblSubscriptions AS s  ON b.SubscriptionID = s.SubscriptionID
INNER JOIN tblBandwidth     AS bw ON s.BandwidthID    = bw.BandwidthID
ORDER BY b.BillingYear, b.BillingMonth, i.InstitutionName;
