-- ============================================================
-- FILE 2 OF 4: LOOKUP TABLE DATA
-- Run AFTER 01_create_tables.sql
-- Paste all lines for one table at a time, then click Run (!).
-- ============================================================

-- tblBandwidth: 5 bandwidth tiers
INSERT INTO tblBandwidth (BandwidthMbps, Description, MonthlyRate) VALUES (2,  '2 Mbps',   3500);
INSERT INTO tblBandwidth (BandwidthMbps, Description, MonthlyRate) VALUES (5,  '5 Mbps',   6000);
INSERT INTO tblBandwidth (BandwidthMbps, Description, MonthlyRate) VALUES (10, '10 Mbps', 10000);
INSERT INTO tblBandwidth (BandwidthMbps, Description, MonthlyRate) VALUES (20, '20 Mbps', 17000);
INSERT INTO tblBandwidth (BandwidthMbps, Description, MonthlyRate) VALUES (50, '50 Mbps', 35000);

-- tblLANTiers: 5 node-count pricing tiers
INSERT INTO tblLANTiers (NodesFrom, NodesTo, CostPerNode, Description) VALUES (1,    10,   2500, '1 to 10 nodes');
INSERT INTO tblLANTiers (NodesFrom, NodesTo, CostPerNode, Description) VALUES (11,   20,   2200, '11 to 20 nodes');
INSERT INTO tblLANTiers (NodesFrom, NodesTo, CostPerNode, Description) VALUES (21,   50,   2000, '21 to 50 nodes');
INSERT INTO tblLANTiers (NodesFrom, NodesTo, CostPerNode, Description) VALUES (51,  100,   1800, '51 to 100 nodes');
INSERT INTO tblLANTiers (NodesFrom, NodesTo, CostPerNode, Description) VALUES (101, 9999,  1500, 'Over 100 nodes');
