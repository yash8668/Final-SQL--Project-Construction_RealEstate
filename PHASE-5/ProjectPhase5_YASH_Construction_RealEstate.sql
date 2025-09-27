use  Construction_RealEstate;

-- 1. List all vendors with rating above 4.5
SELECT * 
FROM Vendors
WHERE Rating > 4.5;

-- 2. Vendors in “Mumbai”
SELECT * 
FROM Vendors
WHERE Address LIKE '%Mumbai%';

-- 3. Vendors with “Paint” service type
SELECT * 
FROM Vendors
WHERE ServiceType = 'Paint';

-- 4. Vendors whose status is not “Approved”
SELECT * 
FROM Vendors
WHERE Status <> 'Approved';

-- 5. Vendors whose email ends with “@gmail.com”
SELECT * 
FROM Vendors
WHERE Email LIKE '%@gmail.com';

-- 6. Vendors sorted by rating descending
SELECT * 
FROM Vendors
ORDER BY Rating DESC;

-- 7. Vendors with duplicate GSTNumber (data anomaly)
SELECT GSTNumber, COUNT(*) AS cnt
FROM Vendors
GROUP BY GSTNumber
HAVING cnt > 1;

-- 8. Materials running low (stock < 100)
SELECT * 
FROM Materials
WHERE StockQuantity < 100;

-- 9. Materials by category “Finishing”
SELECT * 
FROM Materials
WHERE Category = 'Finishing';

-- 10. Materials with zero stock
SELECT * 
FROM Materials
WHERE StockQuantity = 0;

-- 11. Materials not “Available”
SELECT * 
FROM Materials
WHERE Status <> 'Available';

-- 12. Materials last updated before 2025-01-01
SELECT * 
FROM Materials
WHERE LastUpdated < '2025-01-01';

-- 13. Most expensive material (highest PricePerUnit)
SELECT * 
FROM Materials
ORDER BY PricePerUnit DESC
LIMIT 1;

-- 14. Sum of material value in stock (PricePerUnit × StockQuantity)
SELECT SUM(PricePerUnit * StockQuantity) AS TotalStockValue
FROM Materials;

-- 15. Materials whose supplier has rating > 4.5
SELECT m.*
FROM Materials m
JOIN Vendors v ON m.SupplierID = v.VendorID
WHERE v.Rating > 4.5;

-- 16. Materials with name starting with “C”
SELECT * 
FROM Materials
WHERE Name LIKE 'C%';

-- 17. PurchaseOrders pending delivery
SELECT * 
FROM PurchaseOrders
WHERE Status = 'Pending';

-- 18. PurchaseOrders delivered late (DeliveryDate > OrderDate + 7 days)
SELECT * 
FROM PurchaseOrders
WHERE DeliveryDate > OrderDate + INTERVAL 7 DAY;

-- 19. Purchase orders in June 2025
SELECT * 
FROM PurchaseOrders
WHERE OrderDate BETWEEN '2025-06-01' AND '2025-06-30';

-- 20. PurchaseOrders without delivery date (NULL)
SELECT * 
FROM PurchaseOrders
WHERE DeliveryDate IS NULL;

-- 21. PurchaseOrders where TotalCost = 0 (anomaly)
SELECT * 
FROM PurchaseOrders
WHERE TotalCost = 0;

-- 22. PurchaseOrders approved by employee 105
SELECT * 
FROM PurchaseOrders
WHERE ApprovedBy = 105;

-- 23. Total cost per vendor (sum of all orders)
SELECT VendorID, SUM(TotalCost) AS TotalSuppliedCost
FROM PurchaseOrders
GROUP BY VendorID;

-- 24. Top 5 vendors by supplied cost
SELECT VendorID, SUM(TotalCost) AS TotalSuppliedCost
FROM PurchaseOrders
GROUP BY VendorID
ORDER BY TotalSuppliedCost DESC
LIMIT 5;

-- 25. Purchase orders by vendor & material
SELECT VendorID, MaterialID, COUNT(*) AS NumOrders, SUM(TotalCost) AS SumCost
FROM PurchaseOrders
GROUP BY VendorID, MaterialID;

-- 26. Purchase orders whose TotalCost does not match PricePerUnit * Quantity
SELECT po.*
FROM PurchaseOrders po
JOIN Materials m ON po.MaterialID = m.MaterialID
WHERE ABS(po.TotalCost - (m.PricePerUnit * po.Quantity)) > 0.01;

-- 27. Vendors who never got a PurchaseOrder
SELECT * 
FROM Vendors v
LEFT JOIN PurchaseOrders po ON v.VendorID = po.VendorID
WHERE po.OrderID IS NULL;

-- 28. Payments made (non-pending)
SELECT * 
FROM Payments
WHERE Status <> 'Pending';

-- 29. Payments in last 7 days
SELECT * 
FROM Payments
WHERE PaymentDate >= CURDATE() - INTERVAL 7 DAY;

-- 30. Payments for bank “HDFC Bank”
SELECT * 
FROM Payments
WHERE BankName = 'HDFC Bank';

-- 31. Payment totals by SaleID
SELECT SaleID, SUM(Amount) AS TotalPaid
FROM Payments
GROUP BY SaleID;

-- 32. Payment methods used and counts
SELECT Method, COUNT(*) AS CountPayments
FROM Payments
GROUP BY Method;

-- 33. Payments sorted by amount descending
SELECT * 
FROM Payments
ORDER BY Amount DESC;

-- 34. Payments where status is “Pending” but amount > 0
SELECT * 
FROM Payments
WHERE Amount > 0 AND Status = 'Pending';

-- 35. Inspections scheduled in future (NextInspection > today)
SELECT * 
FROM Inspections
WHERE NextInspection > CURDATE();

-- 36. Inspections failed
SELECT * 
FROM Inspections
WHERE Result = 'Fail';

-- 37. Inspections by status “Delayed”
SELECT * 
FROM Inspections
WHERE Status = 'Delayed';

-- 38. Inspections in last year
SELECT * 
FROM Inspections
WHERE InspectionDate >= CURDATE() - INTERVAL 1 YEAR;

-- 39. Inspections done between dates
SELECT * 
FROM Inspections
WHERE InspectionDate BETWEEN '2025-01-01' AND '2025-06-30';

-- 40. Inspections for SiteID = 4
SELECT * 
FROM Inspections
WHERE SiteID = 4;

-- 41. Inspection counts per inspector
SELECT InspectorName, COUNT(*) AS NumInspections
FROM Inspections
GROUP BY InspectorName;

-- 42. MaintenanceRequests pending
SELECT * 
FROM MaintenanceRequests
WHERE Status = 'Pending';

-- 43. MaintenanceRequests completed in 2025
SELECT * 
FROM MaintenanceRequests
WHERE CompletionDate BETWEEN '2025-01-01' AND '2025-12-31';

-- 44. MaintenanceRequests assigned to 9
SELECT * 
FROM MaintenanceRequests
WHERE AssignedTo = 9;

-- 45. MaintenanceRequests unassigned (AssignedTo IS NULL)
SELECT * 
FROM MaintenanceRequests
WHERE AssignedTo IS NULL;

-- 46. MaintenanceRequests older than 90 days (unresolved)
SELECT * 
FROM MaintenanceRequests
WHERE RequestDate < CURDATE() - INTERVAL 90 DAY
  AND Status <> 'Resolved';

-- 47. MaintenanceRequests where description contains “leak”
SELECT * 
FROM MaintenanceRequests
WHERE Description LIKE '%leak%';

-- 48. MaintenanceRequests per property
SELECT PropertyID, COUNT(*) AS CountRequests
FROM MaintenanceRequests
GROUP BY PropertyID;

-- 49. Clients with more than one maintenance request
SELECT ClientID, COUNT(*) AS ReqCount
FROM MaintenanceRequests
GROUP BY ClientID
HAVING COUNT(*) > 1;

-- 50. Leases active
SELECT * 
FROM Leases
WHERE Status = 'Active';

-- 51. Leases expired (EndDate < today)
SELECT * 
FROM Leases
WHERE EndDate < CURDATE();

-- 52. Leases expiring soon (within 30 days)
SELECT * 
FROM Leases
WHERE EndDate BETWEEN CURDATE() AND CURDATE() + INTERVAL 30 DAY;

-- 53. Leases with no end date (NULL)
SELECT * 
FROM Leases
WHERE EndDate IS NULL;

-- 54. Leases started before 2025
SELECT * 
FROM Leases
WHERE StartDate < '2025-01-01';

-- 55. Leases where AgreementSigned = FALSE
SELECT * 
FROM Leases
WHERE AgreementSigned = FALSE;

-- 56. Leases with deposit > 50000
SELECT * 
FROM Leases
WHERE DepositAmount > 50000;

-- 57. Leases with rent between 10000 and 20000
SELECT * 
FROM Leases
WHERE RentAmount BETWEEN 10000 AND 20000;

-- 58. Leases per client (count of leases)
SELECT ClientID, COUNT(*) AS NumLeases
FROM Leases
GROUP BY ClientID;

-- 59. Leases ordered by deposit descending
SELECT * 
FROM Leases
ORDER BY DepositAmount DESC;

-- 60. Leases where notes contain “lease”
SELECT * 
FROM Leases
WHERE Notes LIKE '%lease%';

-- 61. Construction phases over budget (ActualCost > Budget)
SELECT * 
FROM ConstructionPhases
WHERE ActualCost > Budget;

-- 62. Construction phases in progress
SELECT * 
FROM ConstructionPhases
WHERE Status = 'In Progress';

-- 63. Phases not ended yet (EndDate IS NULL or > today)
SELECT * 
FROM ConstructionPhases
WHERE EndDate IS NULL OR EndDate > CURDATE();

-- 64. Phases with budget > 200000
SELECT * 
FROM ConstructionPhases
WHERE Budget > 200000;

-- 65. Phases with overlapping dates in same project
SELECT cp1.*
FROM ConstructionPhases cp1
JOIN ConstructionPhases cp2 
  ON cp1.ProjectID = cp2.ProjectID
  AND cp1.PhaseID <> cp2.PhaseID
WHERE cp1.StartDate < cp2.EndDate
  AND cp2.StartDate < cp1.EndDate;

-- 66. Phases with NULL actual cost
SELECT * 
FROM ConstructionPhases
WHERE ActualCost IS NULL;

-- 67. Phases with remarks containing “delay”
SELECT * 
FROM ConstructionPhases
WHERE Remarks LIKE '%delay%';

-- 68. Phases by cost ratio descending (ActualCost/Budget)
SELECT *, (ActualCost / Budget) AS CostRatio
FROM ConstructionPhases
WHERE Budget > 0
ORDER BY CostRatio DESC;

-- 69. Tasks not yet completed
SELECT * 
FROM Tasks
WHERE Status <> 'Completed';

-- 70. Tasks overdue (EndDate < today and not completed)
SELECT * 
FROM Tasks
WHERE EndDate < CURDATE()
  AND Status <> 'Completed';

-- 71. Tasks by priority = 'High'
SELECT * 
FROM Tasks
WHERE Priority = 'High';

-- 72. Tasks with progress < 50%
SELECT * 
FROM Tasks
WHERE ProgressPercent < 50;

-- 73. Tasks assigned to 301
SELECT * 
FROM Tasks
WHERE AssignedTo = 301;

-- 74. Tasks unstarted (ProgressPercent = 0)
SELECT * 
FROM Tasks
WHERE ProgressPercent = 0;

-- 75. Tasks overdue and unstarted
SELECT * 
FROM Tasks
WHERE EndDate < CURDATE() AND ProgressPercent = 0;

-- 76. Tasks starting and ending on same day (zero duration)
SELECT * 
FROM Tasks
WHERE StartDate = EndDate;

-- 77. Tasks whose StartDate > EndDate (data error)
SELECT * 
FROM Tasks
WHERE StartDate > EndDate;

-- 78. Tasks in 2025
SELECT * 
FROM Tasks
WHERE YEAR(StartDate) = 2025;

-- 79. Tasks ordered by priority then end date
SELECT * 
FROM Tasks
ORDER BY FIELD(Priority, 'High','Medium','Low'), EndDate;

-- 80. Tasks with remarks containing “delay”
SELECT * 
FROM Tasks
WHERE Remarks LIKE '%delay%';

-- 81. Tasks with NULL AssignedTo and not started
SELECT * 
FROM Tasks
WHERE AssignedTo IS NULL
  AND ProgressPercent = 0
  AND Status <> 'Completed';

-- 82. Tasks with priority “Low” not completed
SELECT * 
FROM Tasks
WHERE Priority = 'Low' AND Status <> 'Completed';

-- 83. Tasks with high priority and overdue
SELECT * 
FROM Tasks
WHERE Priority = 'High'
  AND EndDate < CURDATE()
  AND Status <> 'Completed';

-- 84. Join example: Vendor + Materials supplied by them
SELECT v.VendorID, v.CompanyName, m.MaterialID, m.Name AS MaterialName
FROM Vendors v
JOIN Materials m ON v.VendorID = m.SupplierID;

-- 85. Join example: PurchaseOrder + Material + Vendor
SELECT po.OrderID, po.OrderDate, v.CompanyName, m.Name AS MaterialName, po.Quantity, po.TotalCost
FROM PurchaseOrders po
JOIN Vendors v ON po.VendorID = v.VendorID
JOIN Materials m ON po.MaterialID = m.MaterialID;

-- 86. Join example: MaintenanceRequests + Leases (if property/lease relationship exists)
-- (Assume MaintenanceRequests.PropertyID = Leases.PropertyID)
SELECT mr.RequestID, mr.Status, l.LeaseID, l.Status AS LeaseStatus
FROM MaintenanceRequests mr
LEFT JOIN Leases l ON mr.PropertyID = l.PropertyID;

-- 87. Subquery: Vendors whose supplied total cost > average total cost
SELECT VendorID, SUM(TotalCost) AS Supplied
FROM PurchaseOrders
GROUP BY VendorID
HAVING SUM(TotalCost) > (
  SELECT AVG(total_cost_sub) FROM (
    SELECT SUM(TotalCost) AS total_cost_sub
    FROM PurchaseOrders
    GROUP BY VendorID
  ) AS sub
);

-- 88. Subquery: Materials priced above average price
SELECT * 
FROM Materials
WHERE PricePerUnit > (
  SELECT AVG(PricePerUnit) FROM Materials
);

-- 89. Correlated subquery: For each vendor, count number of materials they supply
SELECT v.VendorID, v.CompanyName,
  (SELECT COUNT(*) FROM Materials m WHERE m.SupplierID = v.VendorID) AS NumMaterials
FROM Vendors v;

-- 90. Correlated subquery: Purchase orders for vendor with highest sum
SELECT * 
FROM PurchaseOrders po
WHERE po.VendorID = (
  SELECT VendorID
  FROM (
    SELECT VendorID, SUM(TotalCost) AS tot
    FROM PurchaseOrders
    GROUP BY VendorID
    ORDER BY tot DESC
    LIMIT 1
  ) AS best
);

-- 91. Update: Mark a vendor status to “Inactive” for low rating
UPDATE Vendors
SET Status = 'Inactive'
WHERE Rating < 3.0;

-- 92. Update: Increase price per unit by 5% for materials in category “Finishing”
UPDATE Materials
SET PricePerUnit = PricePerUnit * 1.05
WHERE Category = 'Finishing';

-- 93. Delete: Remove purchase orders that have zero quantity
DELETE FROM PurchaseOrders
WHERE Quantity = 0;

-- 94. Delete: Remove materials with zero stock and price = 0 (anomalous)
DELETE FROM Materials
WHERE StockQuantity = 0
  AND PricePerUnit = 0;

-- 95. Insert: Add a new vendor
INSERT INTO Vendors (VendorID, CompanyName, ContactName, Email, Phone, Address, ServiceType, Rating, GSTNumber, Status)
VALUES (221, 'NewVendor Co.', 'Rohit Kumar', 'rohit@newvendor.com', '9800000000', 'Pune', 'Wood', 4.1, 'GSTIN12365', 'Approved');

-- 96. Insert: Add a new material
INSERT INTO Materials (MaterialID, Name, Category, Unit, PricePerUnit, StockQuantity, SupplierID, LastUpdated, Status, Remarks)
VALUES (21, 'Fiber Cement', 'Construction', 'Sheets', 550.00, 200.00, 221, '2025-07-01', 'Available', 'New product');

-- 97. Insert: New purchase order
INSERT INTO PurchaseOrders (OrderID, VendorID, MaterialID, OrderDate, DeliveryDate, Quantity, TotalCost, Status, ApprovedBy, Notes)
VALUES (21, 221, 21, '2025-07-10', NULL, 50.00, 27500.00, 'Pending', 105, 'For upcoming site');

-- 98. Transaction example: payment + order update (in a transaction block)
START TRANSACTION;
  INSERT INTO Payments (PaymentID, SaleID, Amount, PaymentDate, Method, Status, TransactionID, BankName, ReceivedBy, Remarks)
    VALUES (21, 21, 27500.00, CURDATE(), 'Bank Transfer', 'Completed', 'TXN2001', 'HDFC Bank', 1, 'Payment for PO21');
  UPDATE PurchaseOrders
    SET Status = 'Paid'
    WHERE OrderID = 21;
COMMIT;

-- 99. Create a view: vendor material summary
CREATE OR REPLACE VIEW VendorMaterialSummary AS
SELECT v.VendorID, v.CompanyName, COUNT(m.MaterialID) AS MaterialCount, COALESCE(SUM(po.TotalCost), 0) AS TotalSupplied
FROM Vendors v
LEFT JOIN Materials m ON v.VendorID = m.SupplierID
LEFT JOIN PurchaseOrders po ON po.VendorID = v.VendorID
GROUP BY v.VendorID, v.CompanyName;

-- 100. Query the view
SELECT * FROM VendorMaterialSummary;

