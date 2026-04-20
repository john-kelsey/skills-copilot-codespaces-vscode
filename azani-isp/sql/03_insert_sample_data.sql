-- ============================================================
-- FILE 3 OF 4: SAMPLE DATA – 8 INSTITUTIONS
-- Mixed scenarios: Active, Registered-only, Upgraded,
-- Defaulter, Disconnected, Reconnected.
-- Run AFTER 02_insert_lookup_data.sql
-- Paste each section separately and click Run (!).
-- ============================================================


-- ============================================================
-- SECTION A: tblInstitutions (paste all 8 together)
-- ============================================================

INSERT INTO tblInstitutions (InstitutionName,Category,County,Town,PostalAddress,PhoneNumber,EmailAddress,ContactPersonName,ContactPersonPhone,ContactPersonEmail,RegistrationDate,RegistrationFee,IsReadyForInstall,InstallationDate,InstallationFee,ServiceStatus)
VALUES ('Azani Primary School','Primary','Nairobi','Westlands','P.O.Box 100','0712000001','azprimary@edu.ke','Jane Mwangi','0712000011','jane@azprimary.ke',#2026/01/05#,8500,Yes,#2026/01/15#,10000,'Active');

INSERT INTO tblInstitutions (InstitutionName,Category,County,Town,PostalAddress,PhoneNumber,EmailAddress,ContactPersonName,ContactPersonPhone,ContactPersonEmail,RegistrationDate,RegistrationFee,IsReadyForInstall,InstallationDate,InstallationFee,ServiceStatus)
VALUES ('Kilimani Junior School','Junior','Nairobi','Kilimani','P.O.Box 200','0712000002','kilimani@edu.ke','Peter Odhiambo','0712000012','peter@kilimani.ke',#2026/01/08#,8500,Yes,#2026/01/20#,10000,'Active');

INSERT INTO tblInstitutions (InstitutionName,Category,County,Town,PostalAddress,PhoneNumber,EmailAddress,ContactPersonName,ContactPersonPhone,ContactPersonEmail,RegistrationDate,RegistrationFee,IsReadyForInstall,InstallationDate,InstallationFee,ServiceStatus)
VALUES ('Rift Valley Senior School','Senior','Nakuru','Nakuru Town','P.O.Box 300','0712000003','rvss@edu.ke','Alice Chebet','0712000013','alice@rvss.ke',#2026/01/10#,8500,No,Null,10000,'Registered');

INSERT INTO tblInstitutions (InstitutionName,Category,County,Town,PostalAddress,PhoneNumber,EmailAddress,ContactPersonName,ContactPersonPhone,ContactPersonEmail,RegistrationDate,RegistrationFee,IsReadyForInstall,InstallationDate,InstallationFee,ServiceStatus)
VALUES ('Coast Technical College','College','Mombasa','Mombasa CBD','P.O.Box 400','0712000004','coast@college.ke','David Karanja','0712000014','david@coastcoll.ke',#2026/01/12#,8500,Yes,#2026/01/25#,10000,'Active');

INSERT INTO tblInstitutions (InstitutionName,Category,County,Town,PostalAddress,PhoneNumber,EmailAddress,ContactPersonName,ContactPersonPhone,ContactPersonEmail,RegistrationDate,RegistrationFee,IsReadyForInstall,InstallationDate,InstallationFee,ServiceStatus)
VALUES ('Kisumu Junior Academy','Junior','Kisumu','Kisumu West','P.O.Box 500','0712000005','kisumu@edu.ke','Grace Otieno','0712000015','grace@kisumuacad.ke',#2026/01/14#,8500,Yes,#2026/02/01#,10000,'Disconnected');

INSERT INTO tblInstitutions (InstitutionName,Category,County,Town,PostalAddress,PhoneNumber,EmailAddress,ContactPersonName,ContactPersonPhone,ContactPersonEmail,RegistrationDate,RegistrationFee,IsReadyForInstall,InstallationDate,InstallationFee,ServiceStatus)
VALUES ('Mt Kenya Senior High','Senior','Nyeri','Nyeri Town','P.O.Box 600','0712000006','mtkenya@edu.ke','Samuel Gitau','0712000016','sam@mtkenya.ke',#2026/01/16#,8500,Yes,#2026/02/05#,10000,'Active');

INSERT INTO tblInstitutions (InstitutionName,Category,County,Town,PostalAddress,PhoneNumber,EmailAddress,ContactPersonName,ContactPersonPhone,ContactPersonEmail,RegistrationDate,RegistrationFee,IsReadyForInstall,InstallationDate,InstallationFee,ServiceStatus)
VALUES ('Eldoret Primary School','Primary','Uasin Gishu','Eldoret','P.O.Box 700','0712000007','eldoret@edu.ke','Mary Kosgei','0712000017','mary@eldoretpri.ke',#2026/01/18#,8500,No,Null,10000,'Registered');

INSERT INTO tblInstitutions (InstitutionName,Category,County,Town,PostalAddress,PhoneNumber,EmailAddress,ContactPersonName,ContactPersonPhone,ContactPersonEmail,RegistrationDate,RegistrationFee,IsReadyForInstall,InstallationDate,InstallationFee,ServiceStatus)
VALUES ('Meru National College','College','Meru','Meru Town','P.O.Box 800','0712000008','meru@college.ke','James Mutua','0712000018','james@merunatcoll.ke',#2026/01/20#,8500,Yes,#2026/02/10#,10000,'Active');


-- ============================================================
-- SECTION B: tblInfrastructure
-- Institutions 3 and 7 purchased PCs and LAN nodes.
-- ============================================================

-- Inst 3 (Rift Valley Senior School) – 10 PCs + 15 LAN nodes (tier 2: KSh 2,200/node)
INSERT INTO tblInfrastructure (InstitutionID,PurchaseDate,NumPCsPurchased,PCUnitCost,TotalPCCost,LANNodesBought,LANTierID,LANNodeUnitCost,TotalLANCost,TotalInfraCost,Notes)
VALUES (3,#2026/01/20#,10,40000,400000,15,2,2200,33000,433000,'10 PCs + 15 LAN nodes (tier 2)');

-- Inst 7 (Eldoret Primary School) – 5 PCs + 8 LAN nodes (tier 1: KSh 2,500/node)
INSERT INTO tblInfrastructure (InstitutionID,PurchaseDate,NumPCsPurchased,PCUnitCost,TotalPCCost,LANNodesBought,LANTierID,LANNodeUnitCost,TotalLANCost,TotalInfraCost,Notes)
VALUES (7,#2026/01/25#,5,40000,200000,8,1,2500,20000,220000,'5 PCs + 8 LAN nodes (tier 1)');


-- ============================================================
-- SECTION C: tblSubscriptions
-- ============================================================

-- Inst 1 (Azani Primary) – 5 Mbps, no upgrade
INSERT INTO tblSubscriptions (InstitutionID,BandwidthID,PreviousBandwidthID,SubscriptionDate,IsUpgraded,UpgradeDate,DiscountPercent,BaseMonthlyRate,DiscountAmount,EffectiveMonthlyRate,IsActive)
VALUES (1,2,Null,#2026/01/15#,No,Null,0,6000,0,6000,Yes);

-- Inst 2 (Kilimani Junior) – upgraded 2 Mbps to 10 Mbps (10% discount)
INSERT INTO tblSubscriptions (InstitutionID,BandwidthID,PreviousBandwidthID,SubscriptionDate,IsUpgraded,UpgradeDate,DiscountPercent,BaseMonthlyRate,DiscountAmount,EffectiveMonthlyRate,IsActive)
VALUES (2,3,1,#2026/01/20#,Yes,#2026/02/01#,10,10000,1000,9000,Yes);

-- Inst 4 (Coast Technical College) – upgraded 10 Mbps to 20 Mbps (10% discount)
INSERT INTO tblSubscriptions (InstitutionID,BandwidthID,PreviousBandwidthID,SubscriptionDate,IsUpgraded,UpgradeDate,DiscountPercent,BaseMonthlyRate,DiscountAmount,EffectiveMonthlyRate,IsActive)
VALUES (4,4,3,#2026/01/25#,Yes,#2026/03/01#,10,17000,1700,15300,Yes);

-- Inst 5 (Kisumu Junior Academy) – 5 Mbps, disconnected (inactive)
INSERT INTO tblSubscriptions (InstitutionID,BandwidthID,PreviousBandwidthID,SubscriptionDate,IsUpgraded,UpgradeDate,DiscountPercent,BaseMonthlyRate,DiscountAmount,EffectiveMonthlyRate,IsActive)
VALUES (5,2,Null,#2026/02/01#,No,Null,0,6000,0,6000,No);

-- Inst 6 (Mt Kenya Senior High) – 10 Mbps, no upgrade
INSERT INTO tblSubscriptions (InstitutionID,BandwidthID,PreviousBandwidthID,SubscriptionDate,IsUpgraded,UpgradeDate,DiscountPercent,BaseMonthlyRate,DiscountAmount,EffectiveMonthlyRate,IsActive)
VALUES (6,3,Null,#2026/02/05#,No,Null,0,10000,0,10000,Yes);

-- Inst 8 (Meru National College) – upgraded 20 Mbps to 50 Mbps (10% discount)
INSERT INTO tblSubscriptions (InstitutionID,BandwidthID,PreviousBandwidthID,SubscriptionDate,IsUpgraded,UpgradeDate,DiscountPercent,BaseMonthlyRate,DiscountAmount,EffectiveMonthlyRate,IsActive)
VALUES (8,5,4,#2026/02/10#,Yes,#2026/03/15#,10,35000,3500,31500,Yes);


-- ============================================================
-- SECTION D: tblMonthlyBills – February 2026
-- ============================================================

-- Inst 1 – paid on time
INSERT INTO tblMonthlyBills (InstitutionID,SubscriptionID,BillingMonth,BillingYear,BillGeneratedDate,DueDate,MonthlyCharge,OverdueFineRate,OverdueFineAmount,ReconnectionFee,TotalAmountDue,PaidAmount,PaymentDate,BillStatus,DisconnectionDate,ReconnectionDate)
VALUES (1,1,2,2026,#2026/02/01#,#2026/02/28#,6000,0.15,0,0,6000,6000,#2026/02/25#,'Paid',Null,Null);

-- Inst 2 – paid on time (Feb), overdue March bill added below
INSERT INTO tblMonthlyBills (InstitutionID,SubscriptionID,BillingMonth,BillingYear,BillGeneratedDate,DueDate,MonthlyCharge,OverdueFineRate,OverdueFineAmount,ReconnectionFee,TotalAmountDue,PaidAmount,PaymentDate,BillStatus,DisconnectionDate,ReconnectionDate)
VALUES (2,2,2,2026,#2026/02/01#,#2026/02/28#,9000,0.15,0,0,9000,9000,#2026/02/27#,'Paid',Null,Null);

-- Inst 4 – paid on time
INSERT INTO tblMonthlyBills (InstitutionID,SubscriptionID,BillingMonth,BillingYear,BillGeneratedDate,DueDate,MonthlyCharge,OverdueFineRate,OverdueFineAmount,ReconnectionFee,TotalAmountDue,PaidAmount,PaymentDate,BillStatus,DisconnectionDate,ReconnectionDate)
VALUES (4,3,2,2026,#2026/02/01#,#2026/02/28#,15300,0.15,0,0,15300,15300,#2026/02/20#,'Paid',Null,Null);

-- Inst 5 – overdue → disconnected → reconnected (fine 15% + KSh 1,000 reconnection)
INSERT INTO tblMonthlyBills (InstitutionID,SubscriptionID,BillingMonth,BillingYear,BillGeneratedDate,DueDate,MonthlyCharge,OverdueFineRate,OverdueFineAmount,ReconnectionFee,TotalAmountDue,PaidAmount,PaymentDate,BillStatus,DisconnectionDate,ReconnectionDate)
VALUES (5,4,2,2026,#2026/02/01#,#2026/02/28#,6000,0.15,900,1000,7900,7900,#2026/03/15#,'Reconnected',#2026/03/11#,#2026/03/15#);

-- Inst 6 – paid on time
INSERT INTO tblMonthlyBills (InstitutionID,SubscriptionID,BillingMonth,BillingYear,BillGeneratedDate,DueDate,MonthlyCharge,OverdueFineRate,OverdueFineAmount,ReconnectionFee,TotalAmountDue,PaidAmount,PaymentDate,BillStatus,DisconnectionDate,ReconnectionDate)
VALUES (6,5,2,2026,#2026/02/01#,#2026/02/28#,10000,0.15,0,0,10000,10000,#2026/02/26#,'Paid',Null,Null);

-- Inst 8 – paid on time
INSERT INTO tblMonthlyBills (InstitutionID,SubscriptionID,BillingMonth,BillingYear,BillGeneratedDate,DueDate,MonthlyCharge,OverdueFineRate,OverdueFineAmount,ReconnectionFee,TotalAmountDue,PaidAmount,PaymentDate,BillStatus,DisconnectionDate,ReconnectionDate)
VALUES (8,6,2,2026,#2026/02/01#,#2026/02/28#,31500,0.15,0,0,31500,31500,#2026/02/28#,'Paid',Null,Null);

-- Inst 2 – March 2026 OVERDUE (defaulter scenario)
INSERT INTO tblMonthlyBills (InstitutionID,SubscriptionID,BillingMonth,BillingYear,BillGeneratedDate,DueDate,MonthlyCharge,OverdueFineRate,OverdueFineAmount,ReconnectionFee,TotalAmountDue,PaidAmount,PaymentDate,BillStatus,DisconnectionDate,ReconnectionDate)
VALUES (2,2,3,2026,#2026/03/01#,#2026/03/31#,9000,0.15,1350,0,10350,0,Null,'Overdue',Null,Null);


-- ============================================================
-- SECTION E: tblPayments
-- ============================================================

-- Registration fees
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (1,Null,#2026/01/05#,'Registration',8500,'M-Pesa','MP001','Clerk A',Null);
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (2,Null,#2026/01/08#,'Registration',8500,'Cheque','CHQ002','Clerk A',Null);
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (3,Null,#2026/01/10#,'Registration',8500,'Cash','CSH003','Clerk B',Null);
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (4,Null,#2026/01/12#,'Registration',8500,'M-Pesa','MP004','Clerk A',Null);
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (5,Null,#2026/01/14#,'Registration',8500,'Bank Transfer','BNK005','Clerk C',Null);
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (6,Null,#2026/01/16#,'Registration',8500,'Cash','CSH006','Clerk B',Null);
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (7,Null,#2026/01/18#,'Registration',8500,'M-Pesa','MP007','Clerk A',Null);
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (8,Null,#2026/01/20#,'Registration',8500,'Cheque','CHQ008','Clerk C',Null);

-- Installation fees
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (1,Null,#2026/01/15#,'Installation',10000,'M-Pesa','MP011','Clerk A',Null);
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (2,Null,#2026/01/20#,'Installation',10000,'Cheque','CHQ012','Clerk A',Null);
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (4,Null,#2026/01/25#,'Installation',10000,'M-Pesa','MP014','Clerk B',Null);
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (5,Null,#2026/02/01#,'Installation',10000,'Bank Transfer','BNK015','Clerk C',Null);
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (6,Null,#2026/02/05#,'Installation',10000,'Cash','CSH016','Clerk B',Null);
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (8,Null,#2026/02/10#,'Installation',10000,'Cheque','CHQ018','Clerk A',Null);

-- Infrastructure payments
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (3,Null,#2026/01/20#,'Infrastructure',433000,'Bank Transfer','BNK023','Clerk C','10 PCs + 15 LAN nodes');
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (7,Null,#2026/01/25#,'Infrastructure',220000,'M-Pesa','MP027','Clerk A','5 PCs + 8 LAN nodes');

-- Monthly bill payments
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (1,1,#2026/02/25#,'Monthly',6000,'M-Pesa','MP101','Clerk A','Feb 2026');
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (2,2,#2026/02/27#,'Monthly',9000,'Cheque','CHQ102','Clerk A','Feb 2026');
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (4,3,#2026/02/20#,'Monthly',15300,'Bank Transfer','BNK104','Clerk C','Feb 2026');
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (6,5,#2026/02/26#,'Monthly',10000,'Cash','CSH106','Clerk B','Feb 2026');
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (8,6,#2026/02/28#,'Monthly',31500,'M-Pesa','MP108','Clerk A','Feb 2026');

-- Inst 5 – overdue fine + reconnection payment (3 separate transactions)
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (5,4,#2026/03/15#,'Monthly',6000,'M-Pesa','MP205','Clerk A','Feb 2026 (paid late)');
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (5,4,#2026/03/15#,'OverdueFine',900,'M-Pesa','MP206','Clerk A','15% fine on KSh 6,000');
INSERT INTO tblPayments (InstitutionID,BillID,PaymentDate,PaymentType,AmountPaid,PaymentMethod,ReferenceNumber,ReceivedBy,Notes) VALUES (5,4,#2026/03/15#,'Reconnection',1000,'M-Pesa','MP207','Clerk A','Reconnection fee');
