use  Construction_RealEstate ; 

-- 1. Projects

-- 1. Show all project names and budgets
SELECT ProjectID, Name, Budget FROM Projects;

-- 2. Show projects with budget more than 20M
SELECT Name, Budget 
FROM Projects 
WHERE Budget > 20000000;

-- 3. Show projects with budget between 15M and 22M
SELECT Name, Location, Budget 
FROM Projects 
WHERE Budget BETWEEN 15000000 AND 22000000;

-- 4. Show Residential and Commercial projects
SELECT Name, Type, Location 
FROM Projects 
WHERE Type IN ('Residential', 'Commercial');

-- 5. Show projects containing the word 'Tech'
SELECT Name, Location 
FROM Projects 
WHERE Name LIKE '%Tech%';

-- 6. Show projects without EndDate
SELECT Name, EndDate 
FROM Projects 
WHERE EndDate IS NULL;

-- 7. Show projects in descending order of budget
SELECT Name, Budget 
FROM Projects 
ORDER BY Budget DESC;

-- 8. Show number of projects by Type
SELECT Type, COUNT(*) AS TotalProjects
FROM Projects
GROUP BY Type;

-- 9. Show average budget by Status
SELECT Status, AVG(Budget) AS AvgBudget
FROM Projects
GROUP BY Status;

-- 10. Show distinct locations
SELECT DISTINCT Location 
FROM Projects;

-- 11. Show Residential projects with budget > 16M
SELECT Name, Location, Budget 
FROM Projects
WHERE Type = 'Residential' AND Budget > 16000000;

-- 12. Show all Ongoing or Completed projects
SELECT Name, Status 
FROM Projects
WHERE Status = 'Ongoing' OR Status = 'Completed';

-- 13. Update status of project ID = 19
UPDATE Projects
SET Status = 'On Hold'
WHERE ProjectID = 19;

-- 14. Delete project with ID = 20
DELETE FROM Projects
WHERE ProjectID = 20;

-- 15. Add a new column for creation date
ALTER TABLE Projects
ADD CreatedDate DATE ;

-- 16. Modify column Location length to 150
ALTER TABLE Projects
MODIFY COLUMN Location VARCHAR(150);

-- 17. Rename column Description → ProjectDescription
ALTER TABLE Projects
change COLUMN Description  ProjectDescription varchar(100); 

-- 18. Show projects with alias for Name and Budget
SELECT Name AS ProjectName, Budget AS ProjectBudget
FROM Projects;

-- 19. Show top 5 projects with highest budgets
SELECT Name, Location, Budget 
FROM Projects
ORDER BY Budget DESC
LIMIT 5;

-- 20. Show projects starting after 2022-05-01
SELECT Name, StartDate 
FROM Projects
WHERE StartDate > '2022-05-01';

-- 2. Sites

-- 1. Show all sites in Maharashtra
SELECT SiteID, City, State 
FROM Sites 
WHERE State = 'Maharashtra';

-- 2. Find sites with area greater than 10,000 sq ft
SELECT SiteID, Address, AreaSqFt 
FROM Sites 
WHERE AreaSqFt > 10000;

-- 3. List only Residential and Commercial sites
SELECT SiteID, LandType, City 
FROM Sites 
WHERE LandType IN ('Residential', 'Commercial');

-- 4. Get all cleared sites in Mumbai
SELECT SiteID, Address, Status 
FROM Sites 
WHERE City = 'Mumbai' AND Status = 'Cleared';

-- 5. Show sites not in Gujarat
SELECT SiteID, City, State 
FROM Sites 
WHERE State <> 'Gujarat';

-- 6. Order sites by area (descending)
SELECT SiteID, Address, AreaSqFt 
FROM Sites 
ORDER BY AreaSqFt DESC;

-- 7. Show first 5 surveyed sites
SELECT SiteID, Address, Status 
FROM Sites 
WHERE Status = 'Surveyed' 
LIMIT 5;

-- 8. Update status of Nagpur site to "Approved"
UPDATE Sites 
SET Status = 'Approved' 
WHERE City = 'Nagpur';

-- 9. Rename column ZipCode to PostalCode
ALTER TABLE Sites RENAME COLUMN ZipCode TO PostalCode;

-- 10. Delete sites where status is "Cancelled"
DELETE FROM Sites 
WHERE Status = 'Cancelled';

-- 11. Add a new column for "OwnershipType"
ALTER TABLE Sites ADD OwnershipType VARCHAR(50);

-- 12. Find average area of Residential sites
SELECT AVG(AreaSqFt) AS AvgResidentialArea 
FROM Sites 
WHERE LandType = 'Residential';

-- 13. Show max area site in Karnataka
SELECT MAX(AreaSqFt) AS LargestSite 
FROM Sites 
WHERE State = 'Karnataka';

-- 14. Show city-wise total number of sites
SELECT City, COUNT(*) AS SiteCount 
FROM Sites 
GROUP BY City;

-- 15. Increase area of Pune sites by 5%
UPDATE Sites 
SET AreaSqFt = AreaSqFt * 1.05 
WHERE City = 'Pune';

-- 16. Find sites with address containing "Road"
SELECT SiteID, Address 
FROM Sites 
WHERE Address LIKE '%Road%';

-- 17. Get sites where land type is Mixed-Use but status is not Approved
SELECT SiteID, Address, LandType, Status 
FROM Sites 
WHERE LandType = 'Mixed-Use' AND Status <> 'Approved';

-- 18. Remove column GeoCoordinates
ALTER TABLE Sites DROP COLUMN GeoCoordinates;

-- 19. Delete site with the smallest area
DELETE FROM Sites 
WHERE AreaSqFt = (SELECT MIN(AreaSqFt) FROM Sites);

-- 20. Change column LandType datatype to VARCHAR(100)
ALTER TABLE Sites MODIFY LandType VARCHAR(100);

-- 3. Contractors

-- 1. Show contractors from Mumbai
SELECT ContractorID, Name, City 
FROM Contractors 
WHERE City = 'Mumbai';

-- 2. Contractors with rating above 4.5
SELECT ContractorID, Name, Rating 
FROM Contractors 
WHERE Rating > 4.5;

-- 3. Contractors handling both Residential and Commercial projects
SELECT ContractorID, Name, Specialization 
FROM Contractors 
WHERE Specialization IN ('Residential', 'Commercial');

-- 4. Contractors with experience more than 10 years
SELECT Name, ExperienceYears 
FROM Contractors 
WHERE ExperienceYears > 10;

-- 5. List only active contractors
SELECT ContractorID, Name, Status 
FROM Contractors 
WHERE Status = 'Active';

-- 6. Show top 5 highest rated contractors
SELECT Name, Rating 
FROM Contractors 
ORDER BY Rating DESC 
LIMIT 5;

-- 7. Count contractors city-wise
SELECT City, COUNT(*) AS ContractorCount 
FROM Contractors 
GROUP BY City;

-- 8. Average experience of contractors in Pune
SELECT AVG(ExperienceYears) AS AvgExperience 
FROM Contractors 
WHERE City = 'Pune';

-- 9. Maximum rating among Industrial contractors
SELECT MAX(Rating) AS MaxIndustrialRating 
FROM Contractors 
WHERE Specialization = 'Industrial';

-- 10. Contractors whose name starts with 'S'
SELECT ContractorID, Name 
FROM Contractors 
WHERE Name LIKE 'S%';

-- 11. Update rating of contractor ID 7 to 4.9
UPDATE Contractors 
SET Rating = 4.9 
WHERE ContractorID = 7;

-- 12. Mark contractors from Delhi as "Inactive"
UPDATE Contractors 
SET Status = 'Inactive' 
WHERE City = 'Delhi';

-- 13. Delete contractor with the lowest rating
DELETE FROM Contractors 
WHERE Rating = (SELECT MIN(Rating) FROM Contractors);

-- 14. Delete all contractors who are "Inactive"
DELETE FROM Contractors 
WHERE Status = 'Inactive';

-- 15. Add a new column for PAN number
ALTER TABLE Contractors 
ADD PANNumber VARCHAR(20);

-- 16. Change data type of Phone column
ALTER TABLE Contractors 
MODIFY Phone VARCHAR(15);

-- 17. Rename column ExperienceYears → YearsOfExperience
ALTER TABLE Contractors 
RENAME COLUMN ExperienceYears TO YearsOfExperience;

-- 18. Show contractor name and rating with alias
SELECT Name AS ContractorName, Rating AS PerformanceRating 
FROM Contractors;

-- 19. Show contractors not from Gujarat
SELECT ContractorID, Name, State 
FROM Contractors 
WHERE State <> 'Gujarat';

-- 20. Show contractors with rating between 3.5 and 4.5
SELECT Name, Rating 
FROM Contractors 
WHERE Rating BETWEEN 3.5 AND 4.5;

-- 4. Clients

-- 1. Show clients from Maharashtra
SELECT ClientID, Name, City, State 
FROM Clients 
WHERE State = 'Maharashtra';

-- 2. Clients with phone numbers starting with '98'
SELECT ClientID, Name, Phone 
FROM Clients 
WHERE Phone LIKE '98%';

-- 3. Clients who registered in 2023
SELECT Name, RegistrationDate 
FROM Clients 
WHERE YEAR(RegistrationDate) = 2023;

-- 4. Clients with Gmail accounts
SELECT ClientID, Name, Email 
FROM Clients 
WHERE Email LIKE '%@gmail.com';

-- 5. Clients from Pune or Mumbai
SELECT Name, City, State 
FROM Clients 
WHERE City IN ('Pune', 'Mumbai');

-- 6. Clients not from Delhi
SELECT ClientID, Name, City 
FROM Clients 
WHERE City <> 'Delhi';

-- 7. Count clients by city
SELECT City, COUNT(*) AS TotalClients 
FROM Clients 
GROUP BY City;

-- 8. Count clients by type
SELECT ClientType, COUNT(*) AS ClientCount 
FROM Clients 
GROUP BY ClientType;

-- 9. Find the most recent registered client
SELECT Name, RegistrationDate 
FROM Clients 
ORDER BY RegistrationDate DESC 
LIMIT 1;

-- 10. Find earliest registered client
SELECT Name, RegistrationDate 
FROM Clients 
ORDER BY RegistrationDate ASC 
LIMIT 1;

-- 11. Update phone number of client ID = 5
UPDATE Clients 
SET Phone = '9876500000' 
WHERE ClientID = 5;

-- 12. Update all corporate clients to status = "Active"
UPDATE Clients 
SET Status = 'Active' 
WHERE ClientType = 'Corporate';

-- 13. Delete clients without email
DELETE FROM Clients 
WHERE Email IS NULL;

-- 14. Delete clients registered before 2020
DELETE FROM Clients 
WHERE YEAR(RegistrationDate) < 2020;

-- 15. Add a new column for Aadhaar number
ALTER TABLE Clients 
ADD AadhaarNumber VARCHAR(12);

-- 16. Modify Email column size
ALTER TABLE Clients 
MODIFY Email VARCHAR(150);

-- 17. Rename column ClientType → Category
ALTER TABLE Clients 
RENAME COLUMN ClientType TO Category;

-- 18. Show client name and email with alias
SELECT Name AS ClientName, Email AS ContactEmail 
FROM Clients;

-- 19. Show clients registered between Jan and Jun 2022
SELECT Name, RegistrationDate 
FROM Clients 
WHERE RegistrationDate BETWEEN '2022-01-01' AND '2022-06-30';

-- 20. Show distinct states where clients are located
SELECT DISTINCT State 
FROM Clients;

-- 5. Agents

-- 1. Show agents with more than 7 years of experience
SELECT Name, ExperienceYears FROM Agents
WHERE ExperienceYears > 7;

-- 2. Find agents with rating above 4.5
SELECT AgentID, Name, Rating FROM Agents
WHERE Rating > 4.5;

-- 3. Order agents by CommissionRate (descending)
SELECT Name, CommissionRate FROM Agents
ORDER BY CommissionRate DESC;

-- 4. Get top 5 agents by Rating
SELECT Name, Rating FROM Agents
ORDER BY Rating DESC
LIMIT 5;

-- 5. Count agents based on specialization
SELECT Specialization, COUNT(*) AS TotalAgents
FROM Agents
GROUP BY Specialization;

-- 6. Average rating of Residential agents
SELECT Specialization, AVG(Rating) AS AvgRating
FROM Agents
WHERE Specialization = 'Residential'
GROUP BY Specialization;

-- 7. Find agents with commission rate above average
SELECT Name, CommissionRate FROM Agents
WHERE CommissionRate > (SELECT AVG(CommissionRate) FROM Agents);

-- 8. Update phone number of agent with AgentID=3
UPDATE Agents
SET Phone = '9800000000'
WHERE AgentID = 3;

-- 9. Update status to 'Inactive' for agents with Rating < 4.0
UPDATE Agents
SET Status = 'Inactive'
WHERE Rating < 4.0;

-- 10. Increase commission rate by 0.2 for Luxury specialists
UPDATE Agents
SET CommissionRate = CommissionRate + 0.20
WHERE Specialization LIKE '%Luxury%';

-- 11. Delete agents with less than 3 years of experience
DELETE FROM Agents
WHERE ExperienceYears < 3;

-- 12. Delete an agent by email
DELETE FROM Agents
WHERE Email = 'vikram.r@estatex.com';

-- 13. Add a new column for TotalSales
ALTER TABLE Agents
ADD TotalSales INT DEFAULT 0;

-- 14. Modify column CommissionRate precision
ALTER TABLE Agents
MODIFY CommissionRate DECIMAL(6,3);

-- 15. Rename column "Phone" to "Mobile"
ALTER TABLE Agents
CHANGE Phone Mobile VARCHAR(15);

-- 16. Find average commission per specialization (HAVING filter)
SELECT Specialization, AVG(CommissionRate) AS AvgCommission
FROM Agents
GROUP BY Specialization
HAVING AVG(CommissionRate) > 1.80;

-- 17. List agents whose name starts with 'A'
SELECT * FROM Agents
WHERE Name LIKE 'A%';

-- 18. Select distinct specializations
SELECT DISTINCT Specialization FROM Agents;

-- 19. Show top 3 experienced agents in Mumbai
SELECT Name, ExperienceYears, Address FROM Agents
WHERE Address LIKE '%Mumbai%'
ORDER BY ExperienceYears DESC
LIMIT 3;

-- 20. Find agents who earn commission above 2.0 and have rating above 4.5
SELECT Name, CommissionRate, Rating FROM Agents
WHERE CommissionRate > 2.0 AND Rating > 4.5;


-- 6. PropertyListings

-- 1. Show all property records
SELECT * FROM PropertyListings;

-- 2. Display Title, Price, and Status with alias
SELECT Title AS PropertyName, Price AS Cost, Status AS Availability FROM PropertyListings;

-- 3. Find properties where Price > 8,000,000
SELECT PropertyID, Title, Price FROM PropertyListings WHERE Price > 8000000;

-- 4. Properties priced between 5,000,000 and 10,000,000
SELECT Title, Price FROM PropertyListings WHERE Price BETWEEN 5000000 AND 10000000;

-- 5. Show properties whose Title starts with 'L'
SELECT Title, Type FROM PropertyListings WHERE Title LIKE 'L%';

-- 6. Order properties by Price descending
SELECT Title, Price FROM PropertyListings ORDER BY Price DESC;

-- 7. Count number of Residential type properties
SELECT COUNT(*) AS ResidentialCount FROM PropertyListings WHERE Type = 'Residential';

-- 8. Show properties not marked 'Available'
SELECT Title, Status FROM PropertyListings WHERE Status <> 'Available';

-- 9. Group properties by Type and count each type
SELECT Type, COUNT(*) AS Total FROM PropertyListings GROUP BY Type;

-- 10. Show properties facing East or West
SELECT Title, Facing FROM PropertyListings WHERE Facing IN ('East','West');

-- 11. Update price of property with ID=3
UPDATE PropertyListings SET Price = Price + 500000 WHERE PropertyID = 3;

-- 12. Delete properties where Status = 'Booked'
DELETE FROM PropertyListings WHERE Status = 'Booked';

-- 13. Change Status of all Industrial type properties to 'Under Review'
UPDATE PropertyListings SET Status = 'Under Review' WHERE Type = 'Industrial';

-- 14. Add a new column ParkingSpaces
ALTER TABLE PropertyListings ADD ParkingSpaces INT DEFAULT 0;

-- 15. Rename column Title to PropertyTitle
ALTER TABLE PropertyListings RENAME COLUMN Title TO PropertyTitle;

-- 16. Change datatype of Floor to SMALLINT
ALTER TABLE PropertyListings MODIFY Floor SMALLINT;

-- 17. Drop column ParkingSpaces
ALTER TABLE PropertyListings DROP COLUMN ParkingSpaces;

-- 18. Display only Available properties, ordered by Area ASC
SELECT PropertyID, Title, Area, Status FROM PropertyListings 
WHERE Status = 'Available'
ORDER BY Area ASC;

-- 19. Show max price of property for each Type
SELECT Type, MAX(Price) AS MaxPrice FROM PropertyListings GROUP BY Type;

-- 20. Truncate table (remove all records but keep structure)
TRUNCATE TABLE PropertyListings;

-- 7. Sales

-- 1. Show all sales records
SELECT * FROM Sales;

-- 2. Display only SaleID, PropertyID and FinalPrice
SELECT SaleID, PropertyID, FinalPrice FROM Sales;

-- 3. Find completed sales
SELECT SaleID, Status FROM Sales WHERE Status = 'Completed';

-- 4. Show pending or cancelled sales
SELECT SaleID, Status FROM Sales WHERE Status IN ('Pending', 'Cancelled');

-- 5. Find sales with price greater than 9,000,000
SELECT SaleID, FinalPrice FROM Sales WHERE FinalPrice > 9000000;

-- 6. Count total completed sales
SELECT COUNT(*) AS CompletedSales FROM Sales WHERE Status = 'Completed';

-- 7. Order sales by FinalPrice descending
SELECT SaleID, FinalPrice FROM Sales ORDER BY FinalPrice DESC;

-- 8. Use alias for better readability
SELECT SaleID AS DealNo, FinalPrice AS Amount, Status AS DealStatus FROM Sales;

-- 9. Find sales between 7,000,000 and 9,000,000
SELECT SaleID, FinalPrice FROM Sales WHERE FinalPrice BETWEEN 7000000 AND 9000000;

-- 10. Display sales not using Cash
SELECT SaleID, PaymentMode FROM Sales WHERE PaymentMode <> 'Cash';

-- 11. Update payment mode for a sale
UPDATE Sales SET PaymentMode = 'UPI' WHERE SaleID = 2;

-- 12. Delete a cancelled sale
DELETE FROM Sales WHERE Status = 'Cancelled';

-- 13. Add a new column for CommissionAmount
ALTER TABLE Sales ADD CommissionAmount DECIMAL(12,2);

-- 14. Rename column Remarks to Notes
ALTER TABLE Sales RENAME COLUMN Remarks TO Notes;

-- 15. Modify datatype of PaymentMode
ALTER TABLE Sales MODIFY PaymentMode VARCHAR(50);

-- 16. Show sales where AgreementSigned is FALSE
SELECT SaleID, Status FROM Sales WHERE AgreementSigned = FALSE;

-- 17. Find top 5 lowest sale prices
SELECT SaleID, FinalPrice FROM Sales ORDER BY FinalPrice ASC LIMIT 5;

-- 18. Use arithmetic operator to calculate 5% discount on FinalPrice
SELECT SaleID, FinalPrice, FinalPrice * 0.95 AS DiscountedPrice FROM Sales;

-- 19. Update commission amount as 2% of FinalPrice
UPDATE Sales SET CommissionAmount = FinalPrice * 0.02;

-- 20. Drop CommissionAmount column
ALTER TABLE Sales DROP COLUMN CommissionAmount;
-- 8. Leads

-- 1. Display all records
SELECT * FROM Leads;

-- 2. Show LeadID, Source, and Priority with alias
SELECT LeadID AS ID, Source AS LeadSource, Priority AS Urgency FROM Leads;

-- 3. Find all Leads where Status is 'New'
SELECT LeadID, ClientID, Status FROM Leads WHERE Status = 'New';

-- 4. Leads created between 2024-01-10 and 2024-02-01
SELECT LeadID, InquiryDate, Status 
FROM Leads 
WHERE InquiryDate BETWEEN '2024-01-10' AND '2024-02-01';

-- 5. Leads from 'Website' or 'Facebook'
SELECT LeadID, Source, Status 
FROM Leads 
WHERE Source IN ('Website', 'Facebook');

-- 6. Leads with Priority not equal to 'Low'
SELECT LeadID, Priority, Status 
FROM Leads 
WHERE Priority <> 'Low';

-- 7. Count how many Leads per Source
SELECT Source, COUNT(*) AS TotalLeads 
FROM Leads 
GROUP BY Source;

-- 8. Show highest LeadID from Leads table
SELECT MAX(LeadID) AS MaxLeadID FROM Leads;

-- 9. Find Leads where Notes contain 'visit'
SELECT LeadID, Notes 
FROM Leads 
WHERE Notes LIKE '%visit%';

-- 10. Order Leads by FollowUpDate descending
SELECT LeadID, ClientID, FollowUpDate 
FROM Leads 
ORDER BY FollowUpDate DESC;

-- 11. Update status of LeadID=5 to 'Closed'
UPDATE Leads SET Status = 'Closed' WHERE LeadID = 5;

-- 12. Delete leads where Priority = 'Low'
DELETE FROM Leads WHERE Priority = 'Low';

-- 13. Change Status of all 'Followed Up' leads to 'Converted'
UPDATE Leads SET Status = 'Converted' WHERE Status = 'Followed Up';

-- 14. Add a new column LeadScore
ALTER TABLE Leads ADD LeadScore INT DEFAULT 0;

-- 15. Rename column Notes to Remarks
ALTER TABLE Leads RENAME COLUMN Notes TO Remarks;

-- 16. Modify column Priority to accept 50 chars
ALTER TABLE Leads MODIFY Priority VARCHAR(50);

-- 17. Drop the column LeadScore
ALTER TABLE Leads DROP COLUMN LeadScore;

-- 18. Display Leads whose FollowUpDate is after '2024-02-10'
SELECT LeadID, FollowUpDate 
FROM Leads 
WHERE FollowUpDate > '2024-02-10';

-- 19. Count leads grouped by Priority
SELECT Priority, COUNT(*) AS Total FROM Leads GROUP BY Priority;

-- 20. Truncate the table (remove all records but keep structure)
TRUNCATE TABLE Leads;

-- 9. Employees
-- 1. Display all Employees
SELECT * FROM Employees;

-- 2. Show EmployeeID, Name and Department with alias
SELECT EmployeeID AS ID, Name AS EmployeeName, Department AS Dept FROM Employees;

-- 3. Find all employees from 'Sales' department
SELECT EmployeeID, Name, Department FROM Employees WHERE Department = 'Sales';

-- 4. Employees hired between 2023-01-01 and 2023-12-31
SELECT EmployeeID, Name, HireDate 
FROM Employees 
WHERE HireDate BETWEEN '2023-01-01' AND '2023-12-31';

-- 5. Employees whose Salary is more than 50,000
SELECT EmployeeID, Name, Salary 
FROM Employees 
WHERE Salary > 50000;

-- 6. Employees whose Department is not 'HR'
SELECT EmployeeID, Name, Department 
FROM Employees 
WHERE Department <> 'HR';

-- 7. Count number of employees in each Department
SELECT Department, COUNT(*) AS TotalEmployees 
FROM Employees 
GROUP BY Department;

-- 8. Highest salary in Employees table
SELECT MAX(Salary) AS HighestSalary FROM Employees;

-- 9. Employees with names starting with 'A'
SELECT EmployeeID, Name 
FROM Employees 
WHERE Name LIKE 'A%';

-- 10. List Employees ordered by Salary descending
SELECT EmployeeID, Name, Salary 
FROM Employees 
ORDER BY Salary DESC;

-- 11. Update Salary of EmployeeID=3 by 10%
UPDATE Employees SET Salary = Salary * 1.10 WHERE EmployeeID = 3;

-- 12. Delete employees from Department = 'Temporary'
DELETE FROM Employees WHERE Department = 'Temporary';

-- 13. Update Department of all 'Interns' to 'Trainees'
UPDATE Employees SET Department = 'Trainees' WHERE Department = 'Interns';

-- 14. Add a new column Email
ALTER TABLE Employees ADD Email VARCHAR(100);

-- 15. Rename column Phone to Mobile
ALTER TABLE Employees RENAME COLUMN Phone TO Mobile;

-- 16. Modify Salary column to DECIMAL(12,2)
ALTER TABLE Employees MODIFY Salary DECIMAL(12,2);

-- 17. Drop the Email column
ALTER TABLE Employees DROP COLUMN Email;

-- 18. Show Employees whose JobTitle = 'Manager' OR Salary > 60000
SELECT EmployeeID, Name, JobTitle, Salary 
FROM Employees 
WHERE JobTitle = 'Manager' OR Salary > 60000;

-- 19. Count Employees by JobTitle
SELECT JobTitle, COUNT(*) AS Total 
FROM Employees 
GROUP BY JobTitle;

-- 20. Truncate the table (delete all rows, keep structure)
TRUNCATE TABLE Employees;

-- 10. Vendors

-- 1. Display all vendors
SELECT * FROM Vendors;

-- 2. Show VendorID, CompanyName, and ServiceType with alias
SELECT VendorID AS ID, CompanyName AS Vendor, ServiceType AS Service FROM Vendors;

-- 3. Vendors located in Mumbai
SELECT VendorID, CompanyName, Address FROM Vendors WHERE Address = 'Mumbai';

-- 4. Vendors with Rating greater than 4.5
SELECT VendorID, CompanyName, Rating 
FROM Vendors 
WHERE Rating > 4.5;

-- 5. Vendors whose Status is not 'Approved'
SELECT VendorID, CompanyName, Status 
FROM Vendors 
WHERE Status <> 'Approved';

-- 6. Count vendors by ServiceType
SELECT ServiceType, COUNT(*) AS TotalVendors 
FROM Vendors 
GROUP BY ServiceType;

-- 7. Show highest vendor rating
SELECT MAX(Rating) AS HighestRating FROM Vendors;

-- 8. Vendors whose CompanyName starts with 'B'
SELECT VendorID, CompanyName 
FROM Vendors 
WHERE CompanyName LIKE 'B%';

-- 9. Vendors from Mumbai OR Pune
SELECT VendorID, CompanyName, Address 
FROM Vendors 
WHERE Address IN ('Mumbai', 'Pune');

-- 10. Order vendors by Rating descending
SELECT VendorID, CompanyName, Rating 
FROM Vendors 
ORDER BY Rating DESC;

-- 11. Update Status of VendorID=205 to 'Pending'
UPDATE Vendors SET Status = 'Pending' WHERE VendorID = 205;

-- 12. Delete vendors from 'Lucknow'
DELETE FROM Vendors WHERE Address = 'Lucknow';

-- 13. Update Rating of vendors in 'Paint' service to 4.9
UPDATE Vendors SET Rating = 4.9 WHERE ServiceType = 'Paint';

-- 14. Add new column Website
ALTER TABLE Vendors ADD Website VARCHAR(100);

-- 15. Rename column Phone to ContactNumber
ALTER TABLE Vendors RENAME COLUMN Phone TO ContactNumber;

-- 16. Modify Rating to DECIMAL(4,2)
ALTER TABLE Vendors MODIFY Rating DECIMAL(4,2);

-- 17. Drop the Website column
ALTER TABLE Vendors DROP COLUMN Website;

-- 18. Vendors in Delhi OR with Rating above 4.6
SELECT VendorID, CompanyName, Address, Rating 
FROM Vendors 
WHERE Address = 'Delhi' OR Rating > 4.6;

-- 19. Count vendors grouped by Status
SELECT Status, COUNT(*) AS Total 
FROM Vendors 
GROUP BY Status;

-- 20. Truncate table Vendors (remove all rows, keep structure)
TRUNCATE TABLE Vendors;

-- 11. Materials

-- 1. Display all materials
SELECT * FROM Materials;

-- 2. Show Name, Category, PricePerUnit as "Price" and StockQuantity as "Stock"
SELECT Name AS Material, Category, PricePerUnit AS Price, StockQuantity AS Stock 
FROM Materials;

-- 3. Materials with PricePerUnit greater than 500
SELECT Name, PricePerUnit FROM Materials WHERE PricePerUnit > 500;

-- 4. Materials in 'Construction' category and StockQuantity more than 1000
SELECT Name, Category, StockQuantity 
FROM Materials 
WHERE Category = 'Construction' AND StockQuantity > 1000;

-- 5. Materials not in 'Electrical' category
SELECT Name, Category FROM Materials WHERE Category <> 'Electrical';

-- 6. Count of materials by Category
SELECT Category, COUNT(*) AS TotalMaterials FROM Materials GROUP BY Category;

-- 7. Show maximum and minimum PricePerUnit
SELECT MAX(PricePerUnit) AS MaxPrice, MIN(PricePerUnit) AS MinPrice FROM Materials;

-- 8. Materials whose Name starts with 'C'
SELECT Name FROM Materials WHERE Name LIKE 'C%';

-- 9. Materials supplied by SupplierID 1, 2, or 3
SELECT Name, SupplierID FROM Materials WHERE SupplierID IN (1, 2, 3);

-- 10. Order materials by StockQuantity descending
SELECT Name, StockQuantity FROM Materials ORDER BY StockQuantity DESC;

-- 11. Increase PricePerUnit by 10% for 'Finishing' category
UPDATE Materials SET PricePerUnit = PricePerUnit * 1.1 WHERE Category = 'Finishing';

-- 12. Delete materials with StockQuantity = 0
DELETE FROM Materials WHERE StockQuantity = 0;

-- 13. Add new column "WarehouseLocation"
ALTER TABLE Materials ADD WarehouseLocation VARCHAR(50);

-- 14. Rename column "Remarks" to "Notes"
ALTER TABLE Materials RENAME COLUMN Remarks TO Notes;

-- 15. Modify PricePerUnit to DECIMAL(12,2)
ALTER TABLE Materials MODIFY PricePerUnit DECIMAL(12,2);

-- 16. Drop column "WarehouseLocation"
ALTER TABLE Materials DROP COLUMN WarehouseLocation;

-- 17. Materials in 'Plumbing' or with PricePerUnit less than 50
SELECT Name, Category, PricePerUnit 
FROM Materials 
WHERE Category = 'Plumbing' OR PricePerUnit < 50;

-- 18. Count materials grouped by Status
SELECT Status, COUNT(*) AS Total FROM Materials GROUP BY Status;

-- 19. Show average PricePerUnit for each Category
SELECT Category, AVG(PricePerUnit) AS AvgPrice FROM Materials GROUP BY Category;

-- 20. Remove all records but keep table structure
TRUNCATE TABLE Materials;

-- 12. PurchaseOrders

-- 1. Display all purchase orders
SELECT * FROM PurchaseOrders;

-- 2. Show OrderID, VendorID, Quantity as "Qty", TotalCost as "Cost"
SELECT OrderID, VendorID, Quantity AS Qty, TotalCost AS Cost FROM PurchaseOrders;

-- 3. Orders with TotalCost greater than 50000
SELECT OrderID, TotalCost FROM PurchaseOrders WHERE TotalCost > 50000;

-- 4. Orders pending delivery
SELECT OrderID, Status FROM PurchaseOrders WHERE Status = 'Pending';

-- 5. Orders with Quantity between 50 and 200
SELECT OrderID, Quantity FROM PurchaseOrders WHERE Quantity BETWEEN 50 AND 200;

-- 6. Count orders by Status
SELECT Status, COUNT(*) AS TotalOrders FROM PurchaseOrders GROUP BY Status;

-- 7. Maximum and minimum TotalCost
SELECT MAX(TotalCost) AS MaxCost, MIN(TotalCost) AS MinCost FROM PurchaseOrders;

-- 8. Orders placed by VendorID 1, 2, or 3
SELECT OrderID, VendorID FROM PurchaseOrders WHERE VendorID IN (1, 2, 3);

-- 9. Order by TotalCost descending
SELECT OrderID, TotalCost FROM PurchaseOrders ORDER BY TotalCost DESC;

-- 10. Update status to 'Delivered' for pending orders before 2025-06-10
UPDATE PurchaseOrders 
SET Status = 'Delivered' 
WHERE Status = 'Pending' AND OrderDate < '2025-06-10';

-- 11. Delete orders with Quantity less than 30
DELETE FROM PurchaseOrders WHERE Quantity < 30;

-- 12. Add new column "PaymentStatus"
ALTER TABLE PurchaseOrders ADD PaymentStatus VARCHAR(30);

-- 13. Rename column "Notes" to "Remarks"
ALTER TABLE PurchaseOrders RENAME COLUMN Notes TO Remarks;

-- 14. Modify Quantity column to DECIMAL(12,2)
ALTER TABLE PurchaseOrders MODIFY Quantity DECIMAL(12,2);

-- 15. Drop column "PaymentStatus"
ALTER TABLE PurchaseOrders DROP COLUMN PaymentStatus;

-- 16. Orders delivered and TotalCost greater than 20000
SELECT OrderID, Status, TotalCost 
FROM PurchaseOrders 
WHERE Status = 'Delivered' AND TotalCost > 20000;

-- 17. Count of orders grouped by VendorID
SELECT VendorID, COUNT(*) AS OrdersCount FROM PurchaseOrders GROUP BY VendorID;

-- 18. Average TotalCost by Status
SELECT Status, AVG(TotalCost) AS AvgCost FROM PurchaseOrders GROUP BY Status;

-- 19. Orders with MaterialID not equal to 5
SELECT OrderID, MaterialID FROM PurchaseOrders WHERE MaterialID <> 5;

-- 20. Remove all records but keep table structure
TRUNCATE TABLE PurchaseOrders;

-- 13. Payments

-- 1. Display all payments
SELECT * FROM Payments;

-- 2. Show PaymentID, Amount as "PaidAmount", PaymentDate
SELECT PaymentID, Amount AS PaidAmount, PaymentDate FROM Payments;

-- 3. Payments greater than 1,000,000
SELECT PaymentID, Amount FROM Payments WHERE Amount > 1000000;

-- 4. Pending payments
SELECT PaymentID, Status FROM Payments WHERE Status = 'Pending';

-- 5. Payments made by Bank Transfer or UPI
SELECT PaymentID, Method, Amount 
FROM Payments 
WHERE Method IN ('Bank Transfer', 'UPI');

-- 6. Count payments by Status
SELECT Status, COUNT(*) AS TotalPayments FROM Payments GROUP BY Status;

-- 7. Maximum and minimum payment amount
SELECT MAX(Amount) AS MaxAmount, MIN(Amount) AS MinAmount FROM Payments;

-- 8. Payments received by ReceivedBy = 1, 2, 3
SELECT PaymentID, ReceivedBy FROM Payments WHERE ReceivedBy IN (1,2,3);

-- 9. Order payments by Amount descending
SELECT PaymentID, Amount FROM Payments ORDER BY Amount DESC;

-- 10. Update Status to 'Completed' for pending payments before '2025-06-10'
UPDATE Payments 
SET Status = 'Completed' 
WHERE Status = 'Pending' AND PaymentDate < '2025-06-10';

-- 11. Delete payments less than 500,000
DELETE FROM Payments WHERE Amount < 500000;

-- 12. Add new column "ConfirmationStatus"
ALTER TABLE Payments ADD ConfirmationStatus VARCHAR(30);

-- 13. Rename column "Remarks" to "Notes"
ALTER TABLE Payments RENAME COLUMN Remarks TO Notes;

-- 14. Modify Amount column to DECIMAL(14,2)
ALTER TABLE Payments MODIFY Amount DECIMAL(14,2);

-- 15. Drop column "ConfirmationStatus"
ALTER TABLE Payments DROP COLUMN ConfirmationStatus;

-- 16. Payments completed and Amount > 1,500,000
SELECT PaymentID, Status, Amount 
FROM Payments 
WHERE Status = 'Completed' AND Amount > 1500000;

-- 17. Count of payments grouped by Method
SELECT Method, COUNT(*) AS PaymentCount FROM Payments GROUP BY Method;

-- 18. Average Amount by Status
SELECT Status, AVG(Amount) AS AvgPayment FROM Payments GROUP BY Status;

-- 19. Payments not received by ReceivedBy = 5
SELECT PaymentID, ReceivedBy FROM Payments WHERE ReceivedBy <> 5;

-- 20. Remove all payment records but keep table structure
TRUNCATE TABLE Payments;

-- 14. Inspections

-- 1. Display all inspections
SELECT * FROM Inspections;

-- 2. Show InspectionID, InspectorName AS Inspector, Result
SELECT InspectionID, InspectorName AS Inspector, Result FROM Inspections;

-- 3. Inspections with Result 'Fail'
SELECT InspectionID, Result FROM Inspections WHERE Result = 'Fail';

-- 4. Inspections scheduled after '2025-01-01'
SELECT InspectionID, InspectionDate FROM Inspections WHERE InspectionDate > '2025-01-01';

-- 5. Count inspections by Result
SELECT Result, COUNT(*) AS TotalInspections FROM Inspections GROUP BY Result;

-- 6. Order inspections by InspectionDate descending
SELECT InspectionID, InspectionDate FROM Inspections ORDER BY InspectionDate DESC;

-- 7. Update Status to 'Completed' for scheduled inspections before '2025-03-01'
UPDATE Inspections SET Status='Completed' WHERE Status='Scheduled' AND InspectionDate<'2025-03-01';

-- 8. Delete inspections with Result 'Pending'
DELETE FROM Inspections WHERE Result='Pending';

-- 9. Add column 'InspectionType'
ALTER TABLE Inspections ADD InspectionType VARCHAR(50);

-- 10. Rename column 'Remarks' to 'Comments'
ALTER TABLE Inspections RENAME COLUMN Remarks TO Comments;

-- 11. Modify InspectorName column to VARCHAR(150)
ALTER TABLE Inspections MODIFY InspectorName VARCHAR(150);

-- 12. Drop column 'NextInspection'
ALTER TABLE Inspections DROP COLUMN NextInspection;

-- 13. Maximum and minimum InspectionID
SELECT MAX(InspectionID) AS MaxID, MIN(InspectionID) AS MinID FROM Inspections;

-- 14. Inspections assigned by AssignedBy=3 or ApprovedBy=4
SELECT * FROM Inspections WHERE AssignedBy=3 OR ApprovedBy=4;

-- 15. Inspections not failed
SELECT * FROM Inspections WHERE Result<>'Fail';

-- 16. Count inspections by Status
SELECT Status, COUNT(*) AS StatusCount FROM Inspections GROUP BY Status;

-- 17. Truncate Inspections table
TRUNCATE TABLE Inspections;

-- 18. Display inspections with alias for Result as InspectionResult
SELECT InspectionID, Result AS InspectionResult FROM Inspections;

-- 19. Inspections before '2025-01-01' ordered by Result
SELECT * FROM Inspections WHERE InspectionDate<'2025-01-01' ORDER BY Result;

-- 20. Remove table structure completely
DROP TABLE Inspections;

-- 15. MaintenanceRequests
-- 1. Display all maintenance requests
SELECT * FROM MaintenanceRequests;

-- 2. Show RequestID, Status AS RequestStatus, IssueType
SELECT RequestID, Status AS RequestStatus, IssueType FROM MaintenanceRequests;

-- 3. Requests with Status 'Pending'
SELECT * FROM MaintenanceRequests WHERE Status='Pending';

-- 4. Requests assigned to AssignedTo=7
SELECT RequestID, AssignedTo FROM MaintenanceRequests WHERE AssignedTo=7;

-- 5. Count requests by IssueType
SELECT IssueType, COUNT(*) AS TotalRequests FROM MaintenanceRequests GROUP BY IssueType;

-- 6. Order requests by RequestDate ascending
SELECT * FROM MaintenanceRequests ORDER BY RequestDate ASC;

-- 7. Update Status to 'Resolved' for Electrical issues
UPDATE MaintenanceRequests SET Status='Resolved' WHERE IssueType='Electrical';

-- 8. Delete requests completed before '2025-01-01'
DELETE FROM MaintenanceRequests WHERE CompletionDate<'2025-01-01';

-- 9. Add column 'PriorityLevel'
ALTER TABLE MaintenanceRequests ADD PriorityLevel VARCHAR(20);

-- 10. Rename column 'Feedback' to 'ClientFeedback'
ALTER TABLE MaintenanceRequests RENAME COLUMN Feedback TO ClientFeedback;

-- 11. Modify Description column to VARCHAR(300)
ALTER TABLE MaintenanceRequests MODIFY Description VARCHAR(300);

-- 12. Drop column CompletionDate
ALTER TABLE MaintenanceRequests DROP COLUMN CompletionDate;

-- 13. Requests with ClientID in (1, 2, 3)
SELECT * FROM MaintenanceRequests WHERE ClientID IN (1,2,3);

-- 14. Count requests by Status
SELECT Status, COUNT(*) AS StatusCount FROM MaintenanceRequests GROUP BY Status;

-- 15. Requests not assigned to AssignedTo=1
SELECT * FROM MaintenanceRequests WHERE AssignedTo<>1;

-- 16. Requests with IssueType 'Plumbing' or 'Electrical'
SELECT * FROM MaintenanceRequests WHERE IssueType IN ('Plumbing','Electrical');

-- 17. Truncate MaintenanceRequests table
TRUNCATE TABLE MaintenanceRequests;

-- 18. Requests with alias for Status as CurrentStatus
SELECT RequestID, Status AS CurrentStatus FROM MaintenanceRequests;

-- 19. Requests before '2025-01-01' ordered by Status
SELECT * FROM MaintenanceRequests WHERE RequestDate<'2025-01-01' ORDER BY Status;

-- 20. Drop the table completely
DROP TABLE MaintenanceRequests;

-- 16. Leases

-- 1. Display all leases
SELECT * FROM Leases;

-- 2. Show LeaseID, RentAmount AS MonthlyRent, Status
SELECT LeaseID, RentAmount AS MonthlyRent, Status FROM Leases;

-- 3. Active leases
SELECT * FROM Leases WHERE Status='Active';

-- 4. Leases with RentAmount greater than 18000
SELECT LeaseID, RentAmount FROM Leases WHERE RentAmount>18000;

-- 5. Count leases by Status
SELECT Status, COUNT(*) AS TotalLeases FROM Leases GROUP BY Status;

-- 6. Order leases by StartDate descending
SELECT * FROM Leases ORDER BY StartDate DESC;

-- 7. Update Status to 'Expired' for leases ended before '2025-01-01'
UPDATE Leases SET Status='Expired' WHERE EndDate<'2025-01-01';

-- 8. Delete leases with DepositAmount less than 45000
DELETE FROM Leases WHERE DepositAmount<45000;

-- 9. Add column 'RenewalOption'
ALTER TABLE Leases ADD RenewalOption BOOLEAN DEFAULT FALSE;

-- 10. Rename column 'Notes' to 'LeaseNotes'
ALTER TABLE Leases RENAME COLUMN Notes TO LeaseNotes;

-- 11. Modify RentAmount to DECIMAL(12,2)
ALTER TABLE Leases MODIFY RentAmount DECIMAL(12,2);

-- 12. Drop column AgreementSigned
ALTER TABLE Leases DROP COLUMN AgreementSigned;

-- 13. Leases with ClientID in (1,2,3)
SELECT * FROM Leases WHERE ClientID IN (1,2,3);

-- 14. Maximum and minimum RentAmount
SELECT MAX(RentAmount) AS MaxRent, MIN(RentAmount) AS MinRent FROM Leases;

-- 15. Leases not active
SELECT * FROM Leases WHERE Status<>'Active';

-- 16. Count leases grouped by PropertyID
SELECT PropertyID, COUNT(*) AS LeaseCount FROM Leases GROUP BY PropertyID;

-- 17. Leases with alias for DepositAmount as SecurityDeposit
SELECT LeaseID, DepositAmount AS SecurityDeposit FROM Leases;

-- 18. Leases before '2025-01-01' ordered by RentAmount
SELECT * FROM Leases WHERE StartDate<'2025-01-01' ORDER BY RentAmount;

-- 19. Truncate Leases table
TRUNCATE TABLE Leases;

-- 20. Drop Leases table completely
DROP TABLE Leases;

-- 17. LegalDocuments

-- 1. Display all legal documents
SELECT * FROM LegalDocuments;

-- 2. Show DocumentID, DocumentType AS DocType, Status
SELECT DocumentID, DocumentType AS DocType, Status FROM LegalDocuments;

-- 3. Documents with Status 'Pending'
SELECT * FROM LegalDocuments WHERE Status='Pending';

-- 4. Documents issued before '2023-01-01'
SELECT DocumentID, IssueDate FROM LegalDocuments WHERE IssueDate<'2023-01-01';

-- 5. Count documents by DocumentType
SELECT DocumentType, COUNT(*) AS TotalDocs FROM LegalDocuments GROUP BY DocumentType;

-- 6. Order documents by UploadDate descending
SELECT * FROM LegalDocuments ORDER BY UploadDate DESC;

-- 7. Update Status to 'Verified' for Rejected documents
UPDATE LegalDocuments SET Status='Verified' WHERE Status='Rejected';

-- 8. Delete documents with ExpiryDate before '2025-01-01'
DELETE FROM LegalDocuments WHERE ExpiryDate<'2025-01-01';

-- 9. Add column 'VerifiedDate'
ALTER TABLE LegalDocuments ADD VerifiedDate DATE;

-- 10. Rename column 'Remarks' to 'Comments'
ALTER TABLE LegalDocuments RENAME COLUMN Remarks TO Comments;

-- 11. Modify FilePath column to VARCHAR(300)
ALTER TABLE LegalDocuments MODIFY FilePath VARCHAR(300);

-- 12. Drop column VerifiedBy
ALTER TABLE LegalDocuments DROP COLUMN VerifiedBy;

-- 13. Documents for PropertyID 1 or 2
SELECT * FROM LegalDocuments WHERE PropertyID IN (1,2);

-- 14. Count documents by Status
SELECT Status, COUNT(*) AS StatusCount FROM LegalDocuments GROUP BY Status;

-- 15. Documents not Verified
SELECT * FROM LegalDocuments WHERE Status<>'Verified';

-- 16. Documents issued in 2023
SELECT * FROM LegalDocuments WHERE YEAR(IssueDate)=2023;

-- 17. Truncate LegalDocuments table
TRUNCATE TABLE LegalDocuments;

-- 18. Documents with alias for Status as DocStatus
SELECT DocumentID, Status AS DocStatus FROM LegalDocuments;

-- 19. Documents before '2024-01-01' ordered by DocumentType
SELECT * FROM LegalDocuments WHERE IssueDate<'2024-01-01' ORDER BY DocumentType;

-- 20. Drop LegalDocuments table completely
DROP TABLE LegalDocuments;

-- 18. Permits
-- 1. Display all permits
SELECT * FROM Permits;

-- 2. Show PermitID, Type AS PermitType, Status
SELECT PermitID, Type AS PermitType, Status FROM Permits;

-- 3. Permits with Status 'Pending'
SELECT * FROM Permits WHERE Status='Pending';

-- 4. Permits issued by 'Municipal Authority'
SELECT PermitID, IssuedBy FROM Permits WHERE IssuedBy='Municipal Authority';

-- 5. Count permits by Type
SELECT Type, COUNT(*) AS TotalPermits FROM Permits GROUP BY Type;

-- 6. Order permits by IssueDate ascending
SELECT * FROM Permits ORDER BY IssueDate ASC;

-- 7. Update Status to 'Approved' for Pending permits issued before '2023-01-01'
UPDATE Permits SET Status='Approved' WHERE Status='Pending' AND IssueDate<'2023-01-01';

-- 8. Delete permits with ExpiryDate before '2025-01-01'
DELETE FROM Permits WHERE ExpiryDate<'2025-01-01';

-- 9. Add column 'PriorityLevel'
ALTER TABLE Permits ADD PriorityLevel VARCHAR(20);

-- 10. Rename column 'Notes' to 'PermitNotes'
ALTER TABLE Permits RENAME COLUMN Notes TO PermitNotes;

-- 11. Modify Type column to VARCHAR(100)
ALTER TABLE Permits MODIFY Type VARCHAR(100);

-- 12. Drop column VerifiedBy
ALTER TABLE Permits DROP COLUMN VerifiedBy;

-- 13. Permits for SiteID 1 or 2
SELECT * FROM Permits WHERE SiteID IN (1,2);

-- 14. Count permits by Status
SELECT Status, COUNT(*) AS StatusCount FROM Permits GROUP BY Status;

-- 15. Permits not approved
SELECT * FROM Permits WHERE Status<>'Approved';

-- 16. Permits issued in 2023
SELECT * FROM Permits WHERE YEAR(IssueDate)=2023;

-- 17. Truncate Permits table
TRUNCATE TABLE Permits;

-- 18. Permits with alias for Status as CurrentStatus
SELECT PermitID, Status AS CurrentStatus FROM Permits;

-- 19. Permits before '2024-01-01' ordered by Type
SELECT * FROM Permits WHERE IssueDate<'2024-01-01' ORDER BY Type;

-- 20. Drop Permits table completely
DROP TABLE Permits;

-- 19. ConstructionPhases

-- 1. Display all construction phases
SELECT * FROM ConstructionPhases;

-- 2. Show PhaseID, PhaseName AS Phase, Status
SELECT PhaseID, PhaseName AS Phase, Status FROM ConstructionPhases;

-- 3. Phases with Status 'Pending'
SELECT * FROM ConstructionPhases WHERE Status='Pending';

-- 4. Phases with Budget greater than 200000
SELECT PhaseID, Budget FROM ConstructionPhases WHERE Budget>200000;

-- 5. Count phases by Status
SELECT Status, COUNT(*) AS TotalPhases FROM ConstructionPhases GROUP BY Status;

-- 6. Order phases by StartDate descending
SELECT * FROM ConstructionPhases ORDER BY StartDate DESC;

-- 7. Update Status to 'Completed' for In Progress phases
UPDATE ConstructionPhases SET Status='Completed' WHERE Status='In Progress';

-- 8. Delete phases with EndDate before '2023-06-01'
DELETE FROM ConstructionPhases WHERE EndDate<'2023-06-01';

-- 9. Add column 'PhaseType'
ALTER TABLE ConstructionPhases ADD PhaseType VARCHAR(50);

-- 10. Rename column 'Remarks' to 'Comments'
ALTER TABLE ConstructionPhases RENAME COLUMN Remarks TO Comments;

-- 11. Modify PhaseName column to VARCHAR(150)
ALTER TABLE ConstructionPhases MODIFY PhaseName VARCHAR(150);

-- 12. Drop column ActualCost
ALTER TABLE ConstructionPhases DROP COLUMN ActualCost;

-- 13. Phases for ProjectID 1 or 2
SELECT * FROM ConstructionPhases WHERE ProjectID IN (1,2);

-- 14. Maximum and minimum Budget
SELECT MAX(Budget) AS MaxBudget, MIN(Budget) AS MinBudget FROM ConstructionPhases;

-- 15. Phases not Completed
SELECT * FROM ConstructionPhases WHERE Status<>'Completed';

-- 16. Count phases grouped by SupervisorID
SELECT SupervisorID, COUNT(*) AS PhaseCount FROM ConstructionPhases GROUP BY SupervisorID;

-- 17. Truncate ConstructionPhases table
TRUNCATE TABLE ConstructionPhases;

-- 18. Phases with alias for Budget as AllocatedBudget
SELECT PhaseID, Budget AS AllocatedBudget FROM ConstructionPhases;

-- 19. Phases starting before '2023-05-01' ordered by Status
SELECT * FROM ConstructionPhases WHERE StartDate<'2023-05-01' ORDER BY Status;

-- 20. Drop ConstructionPhases table completely
DROP TABLE ConstructionPhases;

-- 20. Tasks

-- 1. Display all tasks
SELECT * FROM Tasks;

-- 2. Show TaskID, TaskName AS Task, Status
SELECT TaskID, TaskName AS Task, Status FROM Tasks;

-- 3. Tasks with Status 'Pending'
SELECT * FROM Tasks WHERE Status='Pending';

-- 4. Tasks assigned to employee 301
SELECT TaskID, TaskName, AssignedTo FROM Tasks WHERE AssignedTo=301;

-- 5. Count tasks by Status
SELECT Status, COUNT(*) AS TotalTasks FROM Tasks GROUP BY Status;

-- 6. Order tasks by StartDate ascending
SELECT * FROM Tasks ORDER BY StartDate ASC;

-- 7. Update Status to 'Completed' for In Progress tasks
UPDATE Tasks SET Status='Completed' WHERE Status='In Progress';

-- 8. Delete tasks with ProgressPercent = 0
DELETE FROM Tasks WHERE ProgressPercent=0;

-- 9. Add column 'CompletionDate'
ALTER TABLE Tasks ADD CompletionDate DATE;

-- 10. Rename column 'Remarks' to 'TaskNotes'
ALTER TABLE Tasks RENAME COLUMN Remarks TO TaskNotes;

-- 11. Modify TaskName column to VARCHAR(150)
ALTER TABLE Tasks MODIFY TaskName VARCHAR(150);

-- 12. Drop column Priority
ALTER TABLE Tasks DROP COLUMN Priority;

-- 13. Tasks for PhaseID 1 or 2
SELECT * FROM Tasks WHERE PhaseID IN (1,2);

-- 14. Maximum and minimum ProgressPercent
SELECT MAX(ProgressPercent) AS MaxProgress, MIN(ProgressPercent) AS MinProgress FROM Tasks;

-- 15. Tasks not Completed
SELECT * FROM Tasks WHERE Status<>'Completed';

-- 16. Count tasks grouped by AssignedTo
SELECT AssignedTo, COUNT(*) AS TaskCount FROM Tasks GROUP BY AssignedTo;

-- 17. Truncate Tasks table
TRUNCATE TABLE Tasks;

-- 18. Tasks with alias for Status as CurrentStatus
SELECT TaskID, Status AS CurrentStatus FROM Tasks;

-- 19. Tasks starting before '2023-05-01' ordered by ProgressPercent descending
SELECT * FROM Tasks WHERE StartDate<'2023-05-01' ORDER BY ProgressPercent DESC;

-- 20. Drop Tasks table completely
DROP TABLE Tasks;

-- 21. Equipment

-- 1. Display all equipment
SELECT * FROM Equipment;

-- 2. Show Name AS EquipmentName and Status AS CurrentStatus
SELECT Name AS EquipmentName, Status AS CurrentStatus FROM Equipment;

-- 3. Equipment with Quantity greater than 3
SELECT * FROM Equipment WHERE Quantity > 3;

-- 4. Equipment assigned to site 1 or 2
SELECT * FROM Equipment WHERE AssignedToSite IN (1,2);

-- 5. Count of equipment by Type
SELECT Type, COUNT(*) AS TotalCount FROM Equipment GROUP BY Type;

-- 6. Order equipment by PurchaseDate descending
SELECT * FROM Equipment ORDER BY PurchaseDate DESC;

-- 7. Update Status to 'Under Repair' for equipment with Quantity = 1
UPDATE Equipment SET Status='Under Repair' WHERE Quantity=1;

-- 8. Delete equipment with Status = 'Inactive'
DELETE FROM Equipment WHERE Status='Inactive';

-- 9. Add column WarrantyEnd DATE
ALTER TABLE Equipment ADD WarrantyEnd DATE;

-- 10. Rename column Remarks to Notes
ALTER TABLE Equipment RENAME COLUMN Remarks TO Notes;

-- 11. Modify Name column length to VARCHAR(150)
ALTER TABLE Equipment MODIFY Name VARCHAR(150);

-- 12. Drop column VendorID
ALTER TABLE Equipment DROP COLUMN VendorID;

-- 13. Equipment not Active
SELECT * FROM Equipment WHERE Status<>'Active';

-- 14. Maximum and minimum Quantity
SELECT MAX(Quantity) AS MaxQty, MIN(Quantity) AS MinQty FROM Equipment;

-- 15. Count equipment grouped by AssignedToSite
SELECT AssignedToSite, COUNT(*) AS SiteEquipmentCount FROM Equipment GROUP BY AssignedToSite;

-- 16. Truncate Equipment table
TRUNCATE TABLE Equipment;

-- 17. Equipment starting with 'C' (LIKE operator)
SELECT * FROM Equipment WHERE Name LIKE 'C%';

-- 18. Alias for Quantity as TotalUnits
SELECT Name, Quantity AS TotalUnits FROM Equipment;

-- 19. Equipment with MaintenanceDate before '2024-07-01' ordered by MaintenanceDate
SELECT * FROM Equipment WHERE MaintenanceDate<'2024-07-01' ORDER BY MaintenanceDate;

-- 20. Drop Equipment table
DROP TABLE Equipment;

-- 22. SiteVisits

-- 1. Display all site visits
SELECT * FROM SiteVisits;

-- 2. Show VisitorName AS Visitor and VisitDate AS DateOfVisit
SELECT VisitorName AS Visitor, VisitDate AS DateOfVisit FROM SiteVisits;

-- 3. Visits with DurationMinutes greater than 60
SELECT * FROM SiteVisits WHERE DurationMinutes > 60;

-- 4. Visits guided by 101 or 102
SELECT * FROM SiteVisits WHERE GuidedBy IN (101,102);

-- 5. Count of visits by Status
SELECT Status, COUNT(*) AS TotalVisits FROM SiteVisits GROUP BY Status;

-- 6. Order visits by VisitDate ascending
SELECT * FROM SiteVisits ORDER BY VisitDate ASC;

-- 7. Update Status to 'Pending' for visits with DurationMinutes < 50
UPDATE SiteVisits SET Status='Pending' WHERE DurationMinutes < 50;

-- 8. Delete visits with Feedback = 'Negative'
DELETE FROM SiteVisits WHERE Feedback='Negative';

-- 9. Add column NextVisit DATE
ALTER TABLE SiteVisits ADD NextVisit DATE;

-- 10. Rename Notes to VisitNotes
ALTER TABLE SiteVisits RENAME COLUMN Notes TO VisitNotes;

-- 11. Modify VisitorName length to VARCHAR(150)
ALTER TABLE SiteVisits MODIFY VisitorName VARCHAR(150);

-- 12. Drop column GuidedBy
ALTER TABLE SiteVisits DROP COLUMN GuidedBy;

-- 13. Visits not Completed
SELECT * FROM SiteVisits WHERE Status<>'Completed';

-- 14. Maximum and minimum DurationMinutes
SELECT MAX(DurationMinutes) AS MaxDuration, MIN(DurationMinutes) AS MinDuration FROM SiteVisits;

-- 15. Count visits grouped by SiteID
SELECT SiteID, COUNT(*) AS VisitCount FROM SiteVisits GROUP BY SiteID;

-- 16. Truncate SiteVisits table
TRUNCATE TABLE SiteVisits;

-- 17. Visits in July 2023
SELECT * FROM SiteVisits WHERE MONTH(VisitDate)=7 AND YEAR(VisitDate)=2023;

-- 18. Alias DurationMinutes as VisitTime
SELECT VisitorName, DurationMinutes AS VisitTime FROM SiteVisits;

-- 19. Visits ordered by DurationMinutes descending
SELECT * FROM SiteVisits ORDER BY DurationMinutes DESC;

-- 20. Drop SiteVisits table
DROP TABLE SiteVisits;

-- 23. Budgets

-- 1. Display all budgets with alias
SELECT BudgetID AS ID, Amount AS BudgetAmount, Status FROM Budgets;

-- 2. Find all budgets approved in 2023
SELECT * FROM Budgets WHERE Year = 2023 AND Status = 'Approved';

-- 3. Show budgets greater than 200000
SELECT BudgetID, Amount FROM Budgets WHERE Amount > 200000;

-- 4. Budgets between 50000 and 150000
SELECT * FROM Budgets WHERE Amount BETWEEN 50000 AND 150000;

-- 5. Budgets with remarks containing 'work'
SELECT * FROM Budgets WHERE Remarks LIKE '%work%';

-- 6. Count budgets by Status
SELECT Status, COUNT(*) AS Total FROM Budgets GROUP BY Status;

-- 7. Show max and min budget amount
SELECT MAX(Amount) AS MaxBudget, MIN(Amount) AS MinBudget FROM Budgets;

-- 8. Average budget per category
SELECT Category, AVG(Amount) AS AvgAmount FROM Budgets GROUP BY Category;

-- 9. Budgets per year with total amount
SELECT Year, SUM(Amount) AS TotalAmount FROM Budgets GROUP BY Year;

-- 10. Only categories with total budget > 200000
SELECT Category, SUM(Amount) AS Total FROM Budgets GROUP BY Category HAVING SUM(Amount) > 200000;

-- 11. Sort budgets by Amount descending
SELECT * FROM Budgets ORDER BY Amount DESC;

-- 12. Update status to 'Approved' for all 2024 budgets
UPDATE Budgets SET Status = 'Approved' WHERE Year = 2024;

-- 13. Delete budgets where Amount < 20000
DELETE FROM Budgets WHERE Amount < 20000;

-- 14. Add a new column
ALTER TABLE Budgets ADD CreatedAt DATE;

-- 15. Modify Remarks column length
ALTER TABLE Budgets MODIFY Remarks VARCHAR(255);

-- 16. Rename column Year to BudgetYear
ALTER TABLE Budgets RENAME COLUMN Year TO BudgetYear;

-- 17. Drop column CreatedAt
ALTER TABLE Budgets DROP COLUMN CreatedAt;

-- 18. Find top 3 budgets by Amount
SELECT * FROM Budgets ORDER BY Amount DESC LIMIT 3;

-- 19. Show budgets grouped by both Year and Status
SELECT Year, Status, SUM(Amount) AS Total FROM Budgets GROUP BY Year, Status;

-- 20. Find projects that have more than 1 budget entry
SELECT ProjectID, COUNT(*) AS TotalBudgets
FROM Budgets
GROUP BY ProjectID
HAVING COUNT(*) > 1;

-- 24. Invoices

-- 1. Show all invoices with alias
SELECT InvoiceID AS ID, TotalAmount AS Bill, Status FROM Invoices;

-- 2. Invoices paid in July 2023
SELECT * FROM Invoices WHERE InvoiceDate BETWEEN '2023-07-01' AND '2023-07-31';

-- 3. Invoices where PaidAmount < TotalAmount
SELECT * FROM Invoices WHERE PaidAmount < TotalAmount;

-- 4. Invoices with Notes containing 'delivery'
SELECT * FROM Invoices WHERE Notes LIKE '%delivery%';

-- 5. Invoices by status count
SELECT Status, COUNT(*) FROM Invoices GROUP BY Status;

-- 6. Total amount collected per year
SELECT YEAR(InvoiceDate) AS Year, SUM(TotalAmount) AS Total FROM Invoices GROUP BY YEAR(InvoiceDate);

-- 7. Max and Min invoice amount
SELECT MAX(TotalAmount), MIN(TotalAmount) FROM Invoices;

-- 8. Vendors with total > 200000
SELECT VendorID, SUM(TotalAmount) FROM Invoices GROUP BY VendorID HAVING SUM(TotalAmount) > 200000;

-- 9. Sort invoices by DueDate
SELECT * FROM Invoices ORDER BY DueDate ASC;

-- 10. Update status to 'Overdue' if DueDate < CURRENT_DATE
UPDATE Invoices SET Status = 'Overdue' WHERE DueDate < CURDATE();

-- 11. Delete invoices with TotalAmount < 20000
DELETE FROM Invoices WHERE TotalAmount < 20000;

-- 12. Add a new column Tax
ALTER TABLE Invoices ADD Tax DECIMAL(10,2);

-- 13. Modify Notes length
ALTER TABLE Invoices MODIFY Notes VARCHAR(255);

-- 14. Rename column Notes to Remarks
ALTER TABLE Invoices RENAME COLUMN Notes TO Remarks;

-- 15. Drop column Tax
ALTER TABLE Invoices DROP COLUMN Tax;

-- 16. Count invoices per GeneratedBy
SELECT GeneratedBy, COUNT(*) FROM Invoices GROUP BY GeneratedBy;

-- 17. Invoices due in August 2024
SELECT * FROM Invoices WHERE DueDate BETWEEN '2024-08-01' AND '2024-08-31';

-- 18. Find top 3 invoices by TotalAmount
SELECT * FROM Invoices ORDER BY TotalAmount DESC LIMIT 3;

-- 19. Show invoices grouped by Status and Year
SELECT YEAR(InvoiceDate) AS Year, Status, COUNT(*) 
FROM Invoices 
GROUP BY YEAR(InvoiceDate), Status;

-- 20. Find vendors with more than 2 invoices
SELECT VendorID, COUNT(*) AS TotalInvoices
FROM Invoices
GROUP BY VendorID
HAVING COUNT(*) > 2;

-- 25. Feedback

-- 1. Show all feedback with alias
SELECT FeedbackID AS ID, Rating AS Stars, Status FROM Feedback;

-- 2. Feedback with Rating >= 4
SELECT * FROM Feedback WHERE Rating >= 4;

-- 3. Pending feedbacks only
SELECT * FROM Feedback WHERE Status = 'Pending';

-- 4. Comments containing 'agent'
SELECT * FROM Feedback WHERE Comments LIKE '%agent%';

-- 5. Count feedbacks by Rating
SELECT Rating, COUNT(*) FROM Feedback GROUP BY Rating;

-- 6. Average rating per Agent
SELECT AgentID, AVG(Rating) AS AvgRating FROM Feedback GROUP BY AgentID;

-- 7. Feedback count per year
SELECT YEAR(SubmittedDate) AS Year, COUNT(*) FROM Feedback GROUP BY YEAR(SubmittedDate);

-- 8. Agents with average rating < 3
SELECT AgentID, AVG(Rating) FROM Feedback GROUP BY AgentID HAVING AVG(Rating) < 3;

-- 9. Sort feedbacks by Rating descending
SELECT * FROM Feedback ORDER BY Rating DESC;

-- 10. Update status to 'Resolved' where Resolved = TRUE
UPDATE Feedback SET Status = 'Resolved' WHERE Resolved = TRUE;

-- 11. Delete feedbacks with Rating = 1
DELETE FROM Feedback WHERE Rating = 1;

-- 12. Add a new column Priority
ALTER TABLE Feedback ADD Priority VARCHAR(20);

-- 13. Modify Comments column
ALTER TABLE Feedback MODIFY Comments VARCHAR(255);

-- 14. Rename column Response to Reply
ALTER TABLE Feedback RENAME COLUMN Response TO Reply;

-- 15. Drop column Priority
ALTER TABLE Feedback DROP COLUMN Priority;

-- 16. Count Resolved vs Pending
SELECT Status, COUNT(*) FROM Feedback GROUP BY Status;

-- 17. Feedback submitted in June 2023
SELECT * FROM Feedback WHERE SubmittedDate BETWEEN '2023-06-01' AND '2023-06-30';

-- 18. Find top 3 most recent feedbacks
SELECT * FROM Feedback ORDER BY SubmittedDate DESC LIMIT 3;

-- 19. Show feedback grouped by Agent and Status
SELECT AgentID, Status, COUNT(*) AS Total FROM Feedback GROUP BY AgentID, Status;

-- 20. Find customers who gave more than 1 feedback
SELECT CustomerID, COUNT(*) AS TotalFeedback
FROM Feedback
GROUP BY CustomerID
HAVING COUNT(*) > 1;

