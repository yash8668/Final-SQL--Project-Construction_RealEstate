use  Construction_RealEstate ; 

-- Table 1. Project

-- 1. Simple SELECT with WHERE clause
SELECT ProjectID, Name, Type, Status, Budget
FROM Projects
WHERE Status = 'Ongoing';

-- 2. Built-in function: UPPER() for formatting project names
SELECT ProjectID, UPPER(Name) AS ProjectNameUpper
FROM Projects;

-- 3. Aggregate function: SUM() of budgets grouped by type
SELECT Type, SUM(Budget) AS TotalBudget
FROM Projects
GROUP BY Type;

-- 4. ORDER BY clause with DESC
SELECT ProjectID, Name, Budget
FROM Projects
ORDER BY Budget DESC;


-- 5. JOIN with Sites table: List projects and their site addresses
SELECT P.Name AS ProjectName, S.Address AS SiteAddress, S.AreaSqFt
FROM Projects P
JOIN Sites S ON P.ProjectID = S.ProjectID;

-- 6. LEFT JOIN with Agents table (ManagerID = AgentID)
SELECT P.Name, A.Name AS ManagerName
FROM Projects P
LEFT JOIN Agents A ON P.ManagerID = A.AgentID;

-- 7. RIGHT JOIN example with Sites
SELECT S.SiteID, S.Address, P.Name AS ProjectName
FROM Projects P
RIGHT JOIN Sites S ON P.ProjectID = S.ProjectID;

-- 8. JOIN with Contractors using cross join (demonstration)
SELECT P.Name AS ProjectName, C.Name AS ContractorName
FROM Projects P
CROSS JOIN Contractors C;

-- 9. Subquery: Find projects with budget higher than average budget
SELECT Name, Budget
FROM Projects
WHERE Budget > (SELECT AVG(Budget) FROM Projects);

-- 10. Correlated subquery: Projects with more than one site
SELECT Name
FROM Projects P
WHERE (SELECT COUNT(*) FROM Sites S WHERE S.ProjectID = P.ProjectID) > 1;


-- 11. Nested subquery: Project with max budget
SELECT Name, Budget
FROM Projects
WHERE Budget = (
    SELECT MAX(Budget)
    FROM Projects
);

-- 12. Date function: YEAR() extraction
SELECT Name, YEAR(StartDate) AS StartYear
FROM Projects;

-- 13. String function: SUBSTRING
SELECT ProjectID, SUBSTRING(Name, 1, 10) AS ShortName
FROM Projects;

-- 14. Math function: ROUND Budget
SELECT Name, ROUND(Budget/1000000,2) AS BudgetInMillions
FROM Projects;

-- 15. UDF Example: Create function to calculate project duration in days
DELIMITER $$

CREATE FUNCTION ProjectDuration(StartDate DATE, EndDate DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(EndDate, StartDate);
END$$

DELIMITER ;

-- Usage:
SELECT Name, ProjectDuration(StartDate, EndDate) AS DurationDays
FROM Projects;

-- 16. Window function: RANK() projects by budget
SELECT Name, Budget, RANK() OVER (ORDER BY Budget DESC) AS RankByBudget
FROM Projects;

-- 17. Window function: AVG() OVER()
SELECT Name, Budget, 
       AVG(Budget) OVER (PARTITION BY Type) AS AvgTypeBudget
FROM Projects;

-- 18. CASE expression: Categorize budget levels
SELECT Name, Budget,
       CASE 
         WHEN Budget > 25000000 THEN 'High Budget'
         WHEN Budget BETWEEN 15000000 AND 25000000 THEN 'Medium Budget'
         ELSE 'Low Budget'
       END AS BudgetCategory
FROM Projects;

-- 19. Join with Clients (show clients interested in a project type)
SELECT C.FullName, P.Name AS ProjectName, P.Type
FROM Clients C
JOIN Projects P ON C.PreferredType = P.Type;

-- 20. DELETE with subquery: Delete projects with no sites
DELETE FROM Projects
WHERE ProjectID NOT IN (SELECT DISTINCT ProjectID FROM Sites);


-- Table 2. Site

-- 1. Select all site details
SELECT * FROM Sites;

-- 2. Find all sites located in Maharashtra
SELECT SiteID, Address, City, State 
FROM Sites
WHERE State = 'Maharashtra';

-- 3. Get site area in acres (1 sqft = 0.0000229568 acres) using built-in function ROUND
SELECT SiteID, Address, ROUND(AreaSqFt * 0.0000229568, 2) AS AreaAcres
FROM Sites;

-- 4. List Residential sites only
SELECT SiteID, Address, City
FROM Sites
WHERE LandType = 'Residential';

-- 5. Count sites by land type
SELECT LandType, COUNT(*) AS TotalSites
FROM Sites
GROUP BY LandType;

-- 6. Find maximum site area
SELECT MAX(AreaSqFt) AS LargestArea
FROM Sites;

-- 7. Find average area of sites in Gujarat
SELECT AVG(AreaSqFt) AS AvgAreaGujarat
FROM Sites
WHERE State = 'Gujarat';

-- 8. Join Sites with Projects
SELECT s.SiteID, s.Address, p.ProjectName, p.Status
FROM Sites s
JOIN Projects p ON s.ProjectID = p.ProjectID;

-- 9. Join Sites and Projects with filter
SELECT s.Address, p.ProjectName, p.Budget
FROM Sites s
JOIN Projects p ON s.ProjectID = p.ProjectID
WHERE p.Budget > 10000000;

-- 10. Subquery to find sites bigger than average size
SELECT SiteID, Address, AreaSqFt
FROM Sites
WHERE AreaSqFt > (SELECT AVG(AreaSqFt) FROM Sites);

-- 11. Correlated subquery: sites in cities with more than one project
SELECT SiteID, Address, City
FROM Sites s
WHERE (SELECT COUNT(*) FROM Sites WHERE City = s.City) > 1;

-- 12. Find sites in cities starting with 'N' (built-in LIKE)
SELECT SiteID, City, Address
FROM Sites
WHERE City LIKE 'N%';

-- 13. Get distinct states of sites
SELECT DISTINCT State FROM Sites;

-- 14. Create a UDF to classify site size (MySQL)
DELIMITER $$

CREATE FUNCTION SiteSizeCategory(Area DECIMAL(10,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    RETURN CASE 
        WHEN Area < 9000 THEN 'Small'
        WHEN Area BETWEEN 9000 AND 11000 THEN 'Medium'
        ELSE 'Large'
    END;
END$$

DELIMITER ;

-- Usage Example:
SELECT SiteName, Area, SiteSizeCategory(Area) AS SizeCategory
FROM Sites;


-- 15. Use UDF in query
SELECT SiteID, Address, dbo.SiteSizeCategory(AreaSqFt) AS SizeCategory
FROM Sites;

-- 16. Sites with status either 'Cleared' or 'Approved'
SELECT SiteID, Address, Status
FROM Sites
WHERE Status IN ('Cleared', 'Approved');

-- 17. Sites grouped by state with total area
SELECT State, SUM(AreaSqFt) AS TotalArea
FROM Sites
GROUP BY State;

-- 18. Order sites by area descending
SELECT SiteID, Address, AreaSqFt
FROM Sites
ORDER BY AreaSqFt DESC;

-- 19. Top 5 largest sites 
SELECT SiteID, Address, AreaSqFt
FROM Sites
ORDER BY AreaSqFt DESC
LIMIT 5;

-- 20. Find site addresses with length of more than 15 characters
SELECT SiteID, Address, LEN(Address) AS AddressLength
FROM Sites
WHERE LEN(Address) > 15;

-- Table 3. Contractor

-- 1. Select all contractor details
SELECT * FROM Contractors;

-- 2. Contractors with more than 10 years experience
SELECT ContractorID, Name, ExperienceYears
FROM Contractors
WHERE ExperienceYears > 10;

-- 3. Contractors with specialization containing 'Residential'
SELECT ContractorID, Name, Specialization
FROM Contractors
WHERE Specialization LIKE '%Residential%';

-- 4. Average rating of all contractors
SELECT AVG(Rating) AS AvgRating
FROM Contractors;

-- 5. Highest rated contractor
SELECT Name, Rating
FROM Contractors
WHERE Rating = (SELECT MAX(Rating) FROM Contractors);

-- 6. Contractors with rating between 4.0 and 4.5
SELECT Name, Rating
FROM Contractors
WHERE Rating BETWEEN 4.0 AND 4.5;

-- 7. Contractors grouped by specialization with counts
SELECT Specialization, COUNT(*) AS TotalContractors
FROM Contractors
GROUP BY Specialization;

-- 8. Contractors grouped by specialization with avg rating
SELECT Specialization, AVG(Rating) AS AvgRating
FROM Contractors
GROUP BY Specialization;

-- 9. Contractors ordered by years of experience
SELECT Name, ExperienceYears
FROM Contractors
ORDER BY ExperienceYears DESC;

-- 10. Join Contractors with Projects (assuming Projects has ContractorID)
SELECT c.Name, p.ProjectName, p.Status
FROM Contractors c
JOIN Projects p ON c.ContractorID = p.ContractorID;

-- 11. Subquery: Contractors above avg rating
SELECT Name, Rating
FROM Contractors
WHERE Rating > (SELECT AVG(Rating) FROM Contractors);

-- 12. Correlated subquery: Contractors in cities with multiple contractors (MySQL)
SELECT Name, Address
FROM Contractors c
WHERE (
    SELECT COUNT(*)
    FROM Contractors c2
    WHERE SUBSTRING_INDEX(c2.Address, ',', -1) = SUBSTRING_INDEX(c.Address, ',', -1)
) > 1;

-- 13. Built-in function: Uppercase contractor names
SELECT UPPER(Name) AS ContractorName
FROM Contractors;

-- 14. Find contractors with email ending in '.com'
SELECT Name, Email
FROM Contractors
WHERE Email LIKE '%.com';

DELIMITER $$

-- 15. UDF: Classify rating in MySQL
CREATE FUNCTION RatingCategory(Rate DECIMAL(3,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE Category VARCHAR(20);

    IF Rate < 4 THEN
        SET Category = 'Average';
    ELSEIF Rate <= 4.5 THEN
        SET Category = 'Good';
    ELSE
        SET Category = 'Excellent';
    END IF;

    RETURN Category;
END$$

DELIMITER ;

-- Usage example
SELECT FeedbackID, Rating, RatingCategory(Rating) AS RatingLevel
FROM Feedback;


-- 16. Use UDF in query
SELECT Name, Rating, dbo.RatingCategory(Rating) AS RatingClass
FROM Contractors;

-- 17. Contractors with duplicate specialization
SELECT Specialization, COUNT(*) AS CountSpec
FROM Contractors
GROUP BY Specialization
HAVING COUNT(*) > 1;

-- 18. Contractors with phone numbers starting with 98
SELECT Name, Phone
FROM Contractors
WHERE Phone LIKE '98%';

-- 19. Contractors not yet rated above 4.2
SELECT Name, Rating
FROM Contractors
WHERE Rating <= 4.2;

-- 20. Contractors with license numbers ending in 'A'
SELECT Name, LicenseNo
FROM Contractors
WHERE LicenseNo LIKE '%A';

-- Table 4. Client 
-- 1. Select all clients
SELECT * FROM Clients;

-- 2. Clients from Maharashtra
SELECT FullName, City, State 
FROM Clients
WHERE State = 'Maharashtra';

-- 3. Clients registered after 2024-01-01
SELECT FullName, RegistrationDate
FROM Clients
WHERE RegistrationDate > '2024-01-01';

-- 4. Count of clients by preferred type
SELECT PreferredType, COUNT(*) AS TotalClients
FROM Clients
GROUP BY PreferredType;

-- 5. Average client registration year
SELECT AVG(YEAR(RegistrationDate)) AS AvgRegYear
FROM Clients;

-- 6. Maximum clients in a city
SELECT City, COUNT(*) AS TotalClients
FROM Clients
GROUP BY City
ORDER BY TotalClients DESC
LIMIT 1;

-- 7. Join Clients with PropertyListings based on preferred type
SELECT c.FullName, p.Title, p.Type
FROM Clients c
JOIN PropertyListings p ON c.PreferredType = p.Type;

-- 8. Clients with at least one property available
SELECT FullName
FROM Clients
WHERE PreferredType IN (
    SELECT Type FROM PropertyListings WHERE Status='Available'
);

-- 9. Correlated subquery: clients in cities with multiple clients
SELECT FullName, City
FROM Clients c
WHERE (SELECT COUNT(*) FROM Clients WHERE City=c.City) > 1;

-- 10. Built-in function: uppercase client names
SELECT UPPER(FullName) AS ClientName
FROM Clients;

-- 11. Clients with email ending '.com'
SELECT FullName, Email
FROM Clients
WHERE Email LIKE '%.com';

-- 12. Find clients registered in last 90 days (using DATE functions)
SELECT FullName, RegistrationDate
FROM Clients
WHERE RegistrationDate >= DATEADD(DAY, -90, GETDATE());

DELIMITER $$

-- 13. UDF: Categorize clients based on registration year
CREATE FUNCTION ClientCategory(RegDate DATE)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE Category VARCHAR(20);

    IF YEAR(RegDate) = YEAR(CURDATE()) THEN
        SET Category = 'New';
    ELSE
        SET Category = 'Existing';
    END IF;

    RETURN Category;
END$$

DELIMITER ;

-- Usage example
SELECT ClientID, Name, RegDate, ClientCategory(RegDate) AS ClientType
FROM Clients;


-- 14. Use UDF
SELECT FullName, dbo.ClientCategory(RegistrationDate) AS ClientType
FROM Clients;

-- 15. Clients with phone starting '98'
SELECT FullName, Phone
FROM Clients
WHERE Phone LIKE '98%';

-- 16. Count clients per state
SELECT State, COUNT(*) AS TotalClients
FROM Clients
GROUP BY State;

-- 17. Order clients by registration date descending
SELECT FullName, RegistrationDate
FROM Clients
ORDER BY RegistrationDate DESC;

-- 18. Clients preferring Residential properties
SELECT FullName, PreferredType
FROM Clients
WHERE PreferredType='Residential';

-- 19. Length of client names greater than 10 characters
SELECT FullName, LEN(FullName) AS NameLength
FROM Clients
WHERE LEN(FullName) > 10;

-- 20. Distinct cities of clients
SELECT DISTINCT City
FROM Clients;


-- Table 5. Agent 

-- 1. Select all agents
SELECT * FROM Agents;

-- 2. Agents with more than 5 years experience
SELECT Name, ExperienceYears
FROM Agents
WHERE ExperienceYears > 5;

-- 3. Agents specialized in Residential
SELECT Name, Specialization
FROM Agents
WHERE Specialization LIKE '%Residential%';

-- 4. Average agent rating
SELECT AVG(Rating) AS AvgRating
FROM Agents;

-- 5. Highest commission rate agent
SELECT Name, CommissionRate
FROM Agents
WHERE CommissionRate = (SELECT MAX(CommissionRate) FROM Agents);

-- 6. Agents with rating between 4.0 and 4.5
SELECT Name, Rating
FROM Agents
WHERE Rating BETWEEN 4.0 AND 4.5;

-- 7. Group agents by specialization
SELECT Specialization, COUNT(*) AS TotalAgents
FROM Agents
GROUP BY Specialization;

-- 8. Agents ordered by experience
SELECT Name, ExperienceYears
FROM Agents
ORDER BY ExperienceYears DESC;

-- 9. Join Agents with PropertyListings assuming AgentID linked in a future mapping table
-- Example: AgentProperties(AgentID, PropertyID)
SELECT a.Name, p.Title, p.Type
FROM Agents a
JOIN AgentProperties ap ON a.AgentID = ap.AgentID
JOIN PropertyListings p ON ap.PropertyID = p.PropertyID;

-- 10. Subquery: Agents with rating above average
SELECT Name, Rating
FROM Agents
WHERE Rating > (SELECT AVG(Rating) FROM Agents);

-- 11. Correlated subquery: Agents with commission higher than average in their specialization
SELECT Name, Specialization, CommissionRate
FROM Agents a
WHERE CommissionRate > (SELECT AVG(CommissionRate) 
                        FROM Agents 
                        WHERE Specialization = a.Specialization);

-- 12. Built-in: uppercase agent names
SELECT UPPER(Name) AS AgentName
FROM Agents;

-- 13. Find agents with email ending '.in'
SELECT Name, Email
FROM Agents
WHERE Email LIKE '%.in';

DELIMITER $$

-- 14. UDF: classify agent by rating
CREATE FUNCTION AgentRatingCategory(Rate DECIMAL(3,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE Category VARCHAR(20);

    IF Rate < 4 THEN
        SET Category = 'Average';
    ELSEIF Rate BETWEEN 4 AND 4.5 THEN
        SET Category = 'Good';
    ELSE
        SET Category = 'Excellent';
    END IF;

    RETURN Category;
END$$

DELIMITER ;

-- Usage example
SELECT AgentID, Name, Rating, AgentRatingCategory(Rating) AS RatingCategory
FROM Agents;


-- 15. Use UDF
SELECT Name, Rating, dbo.AgentRatingCategory(Rating) AS RatingClass
FROM Agents;

-- 16. Agents with commission > 2%
SELECT Name, CommissionRate
FROM Agents
WHERE CommissionRate > 2;

-- 17. Count agents per status
SELECT Status, COUNT(*) AS TotalAgents
FROM Agents
GROUP BY Status;

-- 18. Agents with phone starting '99'
SELECT Name, Phone
FROM Agents
WHERE Phone LIKE '99%';

-- 19. Agents with specialization appearing multiple times
SELECT Specialization, COUNT(*) AS CountSpec
FROM Agents
GROUP BY Specialization
HAVING COUNT(*) > 1;

-- 20. Order agents by rating descending
SELECT Name, Rating
FROM Agents
ORDER BY Rating DESC;


-- Table 6. PropertyListing

-- 1. Select all properties
SELECT * FROM PropertyListings;

-- 2. Properties available for sale
SELECT Title, Type, Price, Status
FROM PropertyListings
WHERE Status='Available';

-- 3. Properties with area > 1000 sqft
SELECT Title, Area
FROM PropertyListings
WHERE Area > 1000;

-- 4. Count properties by type
SELECT Type, COUNT(*) AS TotalProperties
FROM PropertyListings
GROUP BY Type;

-- 5. Average price per type
SELECT Type, AVG(Price) AS AvgPrice
FROM PropertyListings
GROUP BY Type;

-- 6. Maximum price property
SELECT Title, Price
FROM PropertyListings
WHERE Price = (SELECT MAX(Price) FROM PropertyListings);

-- 7. Join with Projects
SELECT p.Title, p.Type, pr.ProjectName, pr.Status
FROM PropertyListings p
JOIN Projects pr ON p.ProjectID = pr.ProjectID;

-- 8. Properties of clients' preferred type
SELECT pl.Title, pl.Type
FROM PropertyListings pl
WHERE pl.Type IN (SELECT PreferredType FROM Clients);

-- 9. Correlated subquery: properties with higher price than average in same type
SELECT Title, Type, Price
FROM PropertyListings p
WHERE Price > (SELECT AVG(Price) FROM PropertyListings WHERE Type=p.Type);

-- 10. Built-in: round price to nearest 1000
SELECT Title, ROUND(Price, -3) AS RoundedPrice
FROM PropertyListings;

-- 11. Properties with description length > 20
SELECT Title, LEN(Description) AS DescLength
FROM PropertyListings
WHERE LEN(Description) > 20;

DELIMITER $$

-- 12. UDF: classify property size
CREATE FUNCTION PropertySizeCategory(Area DECIMAL(10,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE Category VARCHAR(20);

    IF Area < 800 THEN
        SET Category = 'Small';
    ELSEIF Area BETWEEN 800 AND 1500 THEN
        SET Category = 'Medium';
    ELSE
        SET Category = 'Large';
    END IF;

    RETURN Category;
END$$

DELIMITER ;

-- Usage example
SELECT PropertyID, Name, Area, PropertySizeCategory(Area) AS SizeCategory
FROM PropertyListings;


-- 13. Use UDF
SELECT Title, Area, dbo.PropertySizeCategory(Area) AS SizeCategory
FROM PropertyListings;

-- 14. Properties on floor > 3
SELECT Title, Floor
FROM PropertyListings
WHERE Floor > 3;

-- 15. Properties with price between 5M and 10M
SELECT Title, Price
FROM PropertyListings
WHERE Price BETWEEN 5000000 AND 10000000;

-- 16. Distinct property types
SELECT DISTINCT Type
FROM PropertyListings;

-- 17. Order properties by price descending
SELECT Title, Price
FROM PropertyListings
ORDER BY Price DESC;

-- 18. Top 5 most expensive properties
SELECT Title, Price
FROM PropertyListings
ORDER BY Price DESC
LIMIT 5;

-- 19. Properties facing East
SELECT Title, Facing
FROM PropertyListings
WHERE Facing='East';

-- 20. Count properties per project
SELECT ProjectID, COUNT(*) AS TotalProperties
FROM PropertyListings
GROUP BY ProjectID;


-- Table 7. Sales

-- 1. Select all completed sales
SELECT * 
FROM Sales
WHERE Status = 'Completed';

-- 2. Count total sales per payment mode
SELECT PaymentMode, COUNT(*) AS TotalSales
FROM Sales
GROUP BY PaymentMode;

-- 3. Total revenue from completed sales
SELECT SUM(FinalPrice) AS TotalRevenue
FROM Sales
WHERE Status = 'Completed';

-- 4. Highest sale price
SELECT MAX(FinalPrice) AS HighestSale
FROM Sales;

-- 5. Lowest sale price
SELECT MIN(FinalPrice) AS LowestSale
FROM Sales;

-- 6. Average sale price for completed sales
SELECT AVG(FinalPrice) AS AvgSalePrice
FROM Sales
WHERE Status = 'Completed';

-- 7. Join Sales with Clients to get client name for each sale
SELECT s.SaleID, s.FinalPrice, c.FullName AS ClientName
FROM Sales s
JOIN Clients c ON s.ClientID = c.ClientID;

-- 8. Join Sales with Agents to get agent details for each sale
SELECT s.SaleID, s.FinalPrice, a.Name AS AgentName, a.Rating
FROM Sales s
JOIN Agents a ON s.AgentID = a.AgentID;

-- 9. Join Sales with PropertyListings to get property details
SELECT s.SaleID, s.FinalPrice, p.Title AS PropertyTitle, p.Type AS PropertyType
FROM Sales s
JOIN PropertyListings p ON s.PropertyID = p.PropertyID;

-- 10. Sales in a specific date range
SELECT * 
FROM Sales
WHERE SaleDate BETWEEN '2024-03-01' AND '2024-03-31';

-- 11. Total revenue by agent
SELECT a.Name AS AgentName, SUM(s.FinalPrice) AS RevenueGenerated
FROM Sales s
JOIN Agents a ON s.AgentID = a.AgentID
GROUP BY a.Name
ORDER BY RevenueGenerated DESC;

-- 12. Total revenue by client
SELECT c.FullName AS ClientName, SUM(s.FinalPrice) AS TotalSpent
FROM Sales s
JOIN Clients c ON s.ClientID = c.ClientID
GROUP BY c.FullName
ORDER BY TotalSpent DESC;

-- 13. Count sales per status
SELECT Status, COUNT(*) AS StatusCount
FROM Sales
GROUP BY Status;

-- 14. Using subquery: clients who bought properties above 10 million
SELECT ClientID, FinalPrice
FROM Sales
WHERE FinalPrice > (SELECT AVG(FinalPrice) FROM Sales);

-- 15. Using subquery with JOIN: top 5 agents by revenue
SELECT a.Name, SUM(s.FinalPrice) AS TotalRevenue
FROM Sales s
JOIN Agents a ON s.AgentID = a.AgentID
GROUP BY a.Name
HAVING SUM(s.FinalPrice) > (SELECT AVG(FinalPrice)*5 FROM Sales)
ORDER BY TotalRevenue DESC;

-- 16. Built-in function: Year-wise sales count
SELECT EXTRACT(YEAR FROM SaleDate) AS SaleYear, COUNT(*) AS TotalSales
FROM Sales
GROUP BY EXTRACT(YEAR FROM SaleDate);

-- 17. Built-in function: Month-wise revenue
SELECT TO_CHAR(SaleDate, 'Month') AS SaleMonth, SUM(FinalPrice) AS MonthlyRevenue
FROM Sales
GROUP BY TO_CHAR(SaleDate, 'Month');

-- 18. User-defined function example (calculate 2% commission)
-- Function creation:
CREATE FUNCTION CalculateCommission(amount DECIMAL(12,2)) RETURNS DECIMAL(12,2) DETERMINISTIC
RETURN amount * 0.02;

-- Using function in query
SELECT SaleID, FinalPrice, CalculateCommission(FinalPrice) AS Commission
FROM Sales;

-- 19. List all sales with remarks containing 'documents'
SELECT *
FROM Sales
WHERE Remarks LIKE '%documents%';

-- 20. Rank agents by total sales using window function
SELECT AgentID, SUM(FinalPrice) AS TotalSales,
       RANK() OVER (ORDER BY SUM(FinalPrice) DESC) AS SalesRank
FROM Sales
GROUP BY AgentID;


-- Table 8. Leads

-- 1. All new leads
SELECT * 
FROM Leads
WHERE Status = 'New';

-- 2. Count leads per source
SELECT Source, COUNT(*) AS LeadCount
FROM Leads
GROUP BY Source;

-- 3. Leads assigned to agents
SELECT l.LeadID, l.Status, a.Name AS AssignedAgent
FROM Leads l
JOIN Agents a ON l.AssignedAgentID = a.AgentID;

-- 4. Leads for high priority
SELECT *
FROM Leads
WHERE Priority = 'High';

-- 5. Leads with follow-up in next 7 days
SELECT *
FROM Leads
WHERE FollowUpDate BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL 7 DAY;

-- 6. Leads per client
SELECT c.FullName AS ClientName, COUNT(l.LeadID) AS TotalLeads
FROM Leads l
JOIN Clients c ON l.ClientID = c.ClientID
GROUP BY c.FullName;

-- 7. Leads per agent
SELECT a.Name AS AgentName, COUNT(l.LeadID) AS TotalLeads
FROM Leads l
JOIN Agents a ON l.AssignedAgentID = a.AgentID
GROUP BY a.Name;

-- 8. Subquery: leads with property price above average
SELECT *
FROM Leads l
WHERE PropertyID IN (SELECT PropertyID FROM PropertyListings WHERE Price > (SELECT AVG(Price) FROM PropertyListings));

-- 9. Join Leads with PropertyListings for type info
SELECT l.LeadID, l.Status, p.Title, p.Type
FROM Leads l
LEFT JOIN PropertyListings p ON l.PropertyID = p.PropertyID;

-- 10. Leads created this month
SELECT *
FROM Leads
WHERE EXTRACT(MONTH FROM InquiryDate) = EXTRACT(MONTH FROM CURRENT_DATE);

-- 11. Count leads by status
SELECT Status, COUNT(*) AS StatusCount
FROM Leads
GROUP BY Status;

-- 12. Leads with notes containing 'visit'
SELECT *
FROM Leads
WHERE Notes LIKE '%visit%';

-- 13. Upcoming follow-ups
SELECT LeadID, ClientID, FollowUpDate
FROM Leads
WHERE FollowUpDate > CURRENT_DATE
ORDER BY FollowUpDate ASC;

-- 14. High priority leads without assigned agent
SELECT *
FROM Leads
WHERE Priority = 'High' AND AssignedAgentID IS NULL;

-- 15. Lead age in days using built-in function
SELECT LeadID, CURRENT_DATE - InquiryDate AS LeadAgeDays
FROM Leads;

-- 16. User-defined function: classify lead priority based on notes
CREATE FUNCTION PriorityFromNotes(note TEXT) RETURNS VARCHAR(10) DETERMINISTIC
RETURN CASE WHEN note LIKE '%urgent%' THEN 'High'
            WHEN note LIKE '%later%' THEN 'Low'
            ELSE 'Medium' END;

SELECT LeadID, Notes, PriorityFromNotes(Notes) AS ComputedPriority
FROM Leads;

-- 17. Count leads per property type
SELECT p.Type, COUNT(l.LeadID) AS LeadCount
FROM Leads l
JOIN PropertyListings p ON l.PropertyID = p.PropertyID
GROUP BY p.Type;

-- 18. Leads assigned to agent with highest rating
SELECT l.LeadID, l.ClientID, a.Name AS AgentName, a.Rating
FROM Leads l
JOIN Agents a ON l.AssignedAgentID = a.AgentID
WHERE a.Rating = (SELECT MAX(Rating) FROM Agents);

-- 19. Leads with status changed (follow-up completed)
SELECT *
FROM Leads
WHERE Status = 'Followed Up';

-- 20. Rank agents by leads assigned
SELECT AssignedAgentID, COUNT(*) AS LeadCount,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS AgentRank
FROM Leads
GROUP BY AssignedAgentID;


-- Table 9. Employee

-- 1. List all active employees
SELECT * 
FROM Employees
WHERE Status = 'Active';

-- 2. Count employees per department
SELECT Department, COUNT(*) AS TotalEmployees
FROM Employees
GROUP BY Department;

-- 3. Employees reporting to manager 101
SELECT *
FROM Employees
WHERE ManagerID = 101;

-- 4. Average salary per department
SELECT Department, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department;

-- 5. Max salary in company
SELECT MAX(Salary) AS MaxSalary
FROM Employees;

-- 6. Employees with salary above average
SELECT *
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

-- 7. Join Employees with Managers (self join)
SELECT e.FullName AS EmployeeName, m.FullName AS ManagerName
FROM Employees e
LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID;

-- 8. Employees joined this year
SELECT *
FROM Employees
WHERE EXTRACT(YEAR FROM JoinDate) = EXTRACT(YEAR FROM CURRENT_DATE);

-- 9. Employees by role count
SELECT Role, COUNT(*) AS RoleCount
FROM Employees
GROUP BY Role;

-- 10. Employees with salary between 45000 and 60000
SELECT *
FROM Employees
WHERE Salary BETWEEN 45000 AND 60000;

-- 11. Using built-in function: Employee initials
SELECT EmployeeID, CONCAT(LEFT(FullName,1), '.', RIGHT(FullName,1)) AS Initials
FROM Employees;

-- 12. Employees under managers with >2 reports
SELECT *
FROM Employees
WHERE ManagerID IN (
    SELECT ManagerID
    FROM Employees
    GROUP BY ManagerID
    HAVING COUNT(*) > 2
);

-- 13. Top 5 highest-paid employees
SELECT *
FROM Employees
ORDER BY Salary DESC
LIMIT 5;

-- 14. Employees with 'Tech' in department
SELECT *
FROM Employees
WHERE Department LIKE '%Tech%';

-- 15. User-defined function: Calculate yearly bonus (10% of salary)
CREATE FUNCTION YearlyBonus(sal DECIMAL(10,2)) RETURNS DECIMAL(10,2) DETERMINISTIC
RETURN sal * 0.10;

SELECT EmployeeID, FullName, Salary, YearlyBonus(Salary) AS Bonus
FROM Employees;

-- 16. Total salary per department
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY Department;

-- 17. Rank employees by salary in department
SELECT EmployeeID, Department, Salary,
       RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
FROM Employees;

-- 18. Employees with email domain 'realbuild.com'
SELECT *
FROM Employees
WHERE Email LIKE '%@realbuild.com';

-- 19. Subquery: Employees earning above dept average
SELECT *
FROM Employees e1
WHERE Salary > (SELECT AVG(Salary) FROM Employees e2 WHERE e2.Department = e1.Department);

-- 20. Employees without manager
SELECT *
FROM Employees
WHERE ManagerID IS NULL;


-- Table 11. Vendor

-- 1. List all approved vendors
SELECT *
FROM Vendors
WHERE Status = 'Approved';

-- 2. Count vendors by service type
SELECT ServiceType, COUNT(*) AS VendorCount
FROM Vendors
GROUP BY ServiceType;

-- 3. Vendors with rating above 4.5
SELECT *
FROM Vendors
WHERE Rating > 4.5;

-- 4. Vendors based in Mumbai
SELECT *
FROM Vendors
WHERE Address LIKE '%Mumbai%';

-- 5. Max rated vendor
SELECT MAX(Rating) AS MaxRating
FROM Vendors;

-- 6. Min rated vendor
SELECT MIN(Rating) AS MinRating
FROM Vendors;

-- 7. Subquery: Vendors with rating above average
SELECT *
FROM Vendors
WHERE Rating > (SELECT AVG(Rating) FROM Vendors);

-- 8. Join Vendors with PropertyListings (example: material suppliers)
-- Assuming PropertyListings.Type matches ServiceType
SELECT v.CompanyName, p.Title, p.Type
FROM Vendors v
JOIN PropertyListings p ON v.ServiceType = p.Type;

-- 9. Top 3 vendors by rating
SELECT *
FROM Vendors
ORDER BY Rating DESC
LIMIT 3;

-- 10. Vendors providing Paint service
SELECT *
FROM Vendors
WHERE ServiceType = 'Paint';

-- 11. Vendors with GST number starting with 'GSTIN1234'
SELECT *
FROM Vendors
WHERE GSTNumber LIKE 'GSTIN1234%';

-- 12. Built-in function: Length of company name
SELECT CompanyName, LENGTH(CompanyName) AS NameLength
FROM Vendors;

-- 13. Vendors with email containing 'com'
SELECT *
FROM Vendors
WHERE Email LIKE '%.com%';

-- 14. Count vendors per city
SELECT Address AS City, COUNT(*) AS VendorCount
FROM Vendors
GROUP BY Address;

-- 15. User-defined function: calculate discount based on rating
CREATE FUNCTION VendorDiscount(r DECIMAL(3,2)) RETURNS DECIMAL(3,2) DETERMINISTIC
RETURN CASE WHEN r >= 4.5 THEN 0.10 ELSE 0.05 END;

SELECT VendorID, CompanyName, Rating, VendorDiscount(Rating) AS Discount
FROM Vendors;

-- 16. Vendors alphabetically
SELECT *
FROM Vendors
ORDER BY CompanyName;

-- 17. Rank vendors by rating
SELECT VendorID, CompanyName, Rating,
       RANK() OVER (ORDER BY Rating DESC) AS RatingRank
FROM Vendors;

-- 18. Vendors with service type not 'Paint'
SELECT *
FROM Vendors
WHERE ServiceType <> 'Paint';

-- 19. Subquery: Vendors supplying services present in more than 2 properties
SELECT *
FROM Vendors
WHERE ServiceType IN (
    SELECT Type
    FROM PropertyListings
    GROUP BY Type
    HAVING COUNT(*) > 2
);

-- 20. Vendors with rating between 4.3 and 4.6
SELECT *
FROM Vendors
WHERE Rating BETWEEN 4.3 AND 4.6;


-- Table 12. Material

-- 1. Select all available materials
SELECT * 
FROM Materials
WHERE Status = 'Available';

-- 2. Count materials per category
SELECT Category, COUNT(*) AS MaterialCount
FROM Materials
GROUP BY Category;

-- 3. Materials with stock below 500 units
SELECT * 
FROM Materials
WHERE StockQuantity < 500;

-- 4. Most expensive material
SELECT * 
FROM Materials
ORDER BY PricePerUnit DESC
LIMIT 1;

-- 5. Least expensive material
SELECT * 
FROM Materials
ORDER BY PricePerUnit ASC
LIMIT 1;

-- 6. Average price per category
SELECT Category, AVG(PricePerUnit) AS AvgPrice
FROM Materials
GROUP BY Category;

-- 7. Join Materials with Vendors table to get supplier info
SELECT m.Name, m.Category, v.CompanyName AS SupplierName
FROM Materials m
JOIN Vendors v ON m.SupplierID = v.VendorID;

-- 8. List materials updated in last 30 days
SELECT *
FROM Materials
WHERE LastUpdated >= CURRENT_DATE - INTERVAL 30 DAY;

-- 9. Subquery: Materials supplied by vendors with rating > 4.5
SELECT * 
FROM Materials
WHERE SupplierID IN (SELECT VendorID FROM Vendors WHERE Rating > 4.5);

-- 10. Total stock value per category
SELECT Category, SUM(StockQuantity * PricePerUnit) AS TotalValue
FROM Materials
GROUP BY Category;

-- 11. Built-in function: Length of material names
SELECT Name, LENGTH(Name) AS NameLength
FROM Materials;

-- 12. Materials in multiple units (like Kg or Bags)
SELECT DISTINCT Unit
FROM Materials;

-- 13. User-defined function: Calculate 5% restock cost
CREATE FUNCTION RestockCost(price DECIMAL(10,2), qty DECIMAL(10,2)) RETURNS DECIMAL(12,2) DETERMINISTIC
RETURN price * qty * 0.05;

-- Using the function
SELECT Name, RestockCost(PricePerUnit, StockQuantity) AS RestockCost
FROM Materials;

-- 14. Rank materials by stock quantity
SELECT Name, StockQuantity, 
       RANK() OVER (ORDER BY StockQuantity DESC) AS StockRank
FROM Materials;

-- 15. Materials with remarks containing 'High'
SELECT * 
FROM Materials
WHERE Remarks LIKE '%High%';

-- 16. Materials priced above category average
SELECT * 
FROM Materials m
WHERE PricePerUnit > (SELECT AVG(PricePerUnit) FROM Materials WHERE Category = m.Category);

-- 17. Count materials per supplier
SELECT SupplierID, COUNT(*) AS TotalMaterials
FROM Materials
GROUP BY SupplierID;

-- 18. Subquery: Materials with stock < average stock
SELECT * 
FROM Materials
WHERE StockQuantity < (SELECT AVG(StockQuantity) FROM Materials);

-- 19. Materials sorted by price descending
SELECT * 
FROM Materials
ORDER BY PricePerUnit DESC;

-- 20. Materials updated before a specific date
SELECT * 
FROM Materials
WHERE LastUpdated < '2025-06-10';


-- Table 13. PurchaseOrder

-- 1. Select all pending orders
SELECT * 
FROM PurchaseOrders
WHERE Status = 'Pending';

-- 2. Total cost of delivered orders
SELECT SUM(TotalCost) AS DeliveredCost
FROM PurchaseOrders
WHERE Status = 'Delivered';

-- 3. Join PurchaseOrders with Materials to get material name
SELECT po.OrderID, po.Quantity, po.TotalCost, m.Name AS MaterialName
FROM PurchaseOrders po
JOIN Materials m ON po.MaterialID = m.MaterialID;

-- 4. Join with Employees to get approver name
SELECT po.OrderID, po.Status, e.FullName AS ApprovedByName
FROM PurchaseOrders po
JOIN Employees e ON po.ApprovedBy = e.EmployeeID;

-- 5. Orders placed in last 7 days
SELECT *
FROM PurchaseOrders
WHERE OrderDate >= CURRENT_DATE - INTERVAL 7 DAY;

-- 6. Average order quantity per material
SELECT MaterialID, AVG(Quantity) AS AvgQuantity
FROM PurchaseOrders
GROUP BY MaterialID;

-- 7. Subquery: Orders above average total cost
SELECT * 
FROM PurchaseOrders
WHERE TotalCost > (SELECT AVG(TotalCost) FROM PurchaseOrders);

-- 8. Count orders per vendor
SELECT VendorID, COUNT(*) AS TotalOrders
FROM PurchaseOrders
GROUP BY VendorID;

-- 9. Orders delivered late (DeliveryDate > OrderDate + 5 days)
SELECT *
FROM PurchaseOrders
WHERE DeliveryDate > OrderDate + INTERVAL 5 DAY;


-- 10. Total order cost per vendor
SELECT VendorID, SUM(TotalCost) AS TotalCost
FROM PurchaseOrders
GROUP BY VendorID;

-- 11. Built-in function: Extract month from OrderDate
SELECT OrderID, EXTRACT(MONTH FROM OrderDate) AS OrderMonth
FROM PurchaseOrders;

-- 12. Orders approved by a specific employee
SELECT * 
FROM PurchaseOrders
WHERE ApprovedBy = 101;

-- 13. Rank orders by TotalCost
SELECT OrderID, TotalCost, 
       RANK() OVER (ORDER BY TotalCost DESC) AS CostRank
FROM PurchaseOrders;

-- 14. Orders with notes containing 'Urgent'
SELECT * 
FROM PurchaseOrders
WHERE Notes LIKE '%Urgent%';

-- 15. User-defined function: Calculate discount (2% for >50 units)
CREATE FUNCTION OrderDiscount(qty DECIMAL(10,2), total DECIMAL(12,2)) RETURNS DECIMAL(12,2) DETERMINISTIC
RETURN CASE WHEN qty > 50 THEN total * 0.02 ELSE 0 END;

SELECT OrderID, Quantity, TotalCost, OrderDiscount(Quantity, TotalCost) AS Discount
FROM PurchaseOrders;

-- 16. Orders delivered this month
SELECT * 
FROM PurchaseOrders
WHERE EXTRACT(MONTH FROM DeliveryDate) = EXTRACT(MONTH FROM CURRENT_DATE);

-- 17. Subquery: Orders for materials priced above 500
SELECT * 
FROM PurchaseOrders
WHERE MaterialID IN (SELECT MaterialID FROM Materials WHERE PricePerUnit > 500);

-- 18. Total quantity per material
SELECT MaterialID, SUM(Quantity) AS TotalQuantity
FROM PurchaseOrders
GROUP BY MaterialID;

-- 19. Pending orders count
SELECT COUNT(*) AS PendingOrders
FROM PurchaseOrders
WHERE Status = 'Pending';

-- 20. Orders sorted by DeliveryDate ascending
SELECT * 
FROM PurchaseOrders
ORDER BY DeliveryDate ASC;


-- Table 14. Payment
 
-- 1. Select all completed payments
SELECT * 
FROM Payments
WHERE Status = 'Completed';

-- 2. Total amount received
SELECT SUM(Amount) AS TotalReceived
FROM Payments
WHERE Status = 'Completed';

-- 3. Join Payments with Sales to get property info
SELECT p.PaymentID, p.Amount, s.PropertyID, s.ClientID
FROM Payments p
JOIN Sales s ON p.SaleID = s.SaleID;

-- 4. Payments received by a specific employee
SELECT * 
FROM Payments
WHERE ReceivedBy = 1;

-- 5. Payments made this month
SELECT * 
FROM Payments
WHERE EXTRACT(MONTH FROM PaymentDate) = EXTRACT(MONTH FROM CURRENT_DATE);

-- 6. Average payment amount by method
SELECT Method, AVG(Amount) AS AvgAmount
FROM Payments
GROUP BY Method;

-- 7. Subquery: Payments above average amount
SELECT * 
FROM Payments
WHERE Amount > (SELECT AVG(Amount) FROM Payments);

-- 8. Count payments per bank
SELECT BankName, COUNT(*) AS TotalPayments
FROM Payments
GROUP BY BankName;

-- 9. Join Payments with Clients via Sales
SELECT p.PaymentID, p.Amount, c.Name AS ClientName
FROM Payments p
JOIN Sales s ON p.SaleID = s.SaleID
JOIN Clients c ON s.ClientID = c.ClientID;

-- 10. Rank payments by amount
SELECT PaymentID, Amount, 
       RANK() OVER (ORDER BY Amount DESC) AS AmountRank
FROM Payments;

-- 11. Built-in function: Extract year from PaymentDate
SELECT PaymentID, EXTRACT(YEAR FROM PaymentDate) AS PaymentYear
FROM Payments;

-- 12. Payments with remarks containing 'Cash'
SELECT * 
FROM Payments
WHERE Remarks LIKE '%Cash%';

-- 13. Total amount per bank
SELECT BankName, SUM(Amount) AS TotalAmount
FROM Payments
GROUP BY BankName;

-- 14. Subquery: Payments for sales > 1,000,000
SELECT * 
FROM Payments
WHERE SaleID IN (SELECT SaleID FROM Sales WHERE FinalPrice > 1000000);

-- 15. User-defined function: Calculate 1% service charge
CREATE FUNCTION ServiceCharge(amount DECIMAL(12,2)) RETURNS DECIMAL(12,2) DETERMINISTIC
RETURN amount * 0.01;

SELECT PaymentID, Amount, ServiceCharge(Amount) AS Charge
FROM Payments;

-- 16. Payments pending
SELECT * 
FROM Payments
WHERE Status = 'Pending';

-- 17. Total payments received per employee
SELECT ReceivedBy, SUM(Amount) AS TotalReceived
FROM Payments
GROUP BY ReceivedBy;

-- 18. Subquery: Payments received from top client (max total sale)
SELECT * 
FROM Payments
WHERE SaleID IN (
  SELECT SaleID FROM Sales
  WHERE ClientID = (
    SELECT ClientID FROM Sales
    GROUP BY ClientID
    ORDER BY SUM(FinalPrice) DESC
    LIMIT 1
  )
);

-- 19. Payments sorted by PaymentDate descending
SELECT * 
FROM Payments
ORDER BY PaymentDate DESC;

-- 20. Count transactions per payment method
SELECT Method, COUNT(*) AS MethodCount
FROM Payments
GROUP BY Method;


-- Table 15. Inspection

-- 1. Select all scheduled inspections
SELECT * 
FROM Inspections
WHERE Status = 'Scheduled';

-- 2. Count inspections per site
SELECT SiteID, COUNT(*) AS TotalInspections
FROM Inspections
GROUP BY SiteID;

-- 3. Join Inspections with Sites to get site name
SELECT i.InspectionID, i.InspectorName, s.SiteName
FROM Inspections i
JOIN Sites s ON i.SiteID = s.SiteID;

-- 4. Inspections approved by a specific employee
SELECT * 
FROM Inspections
WHERE ApprovedBy = 4;

-- 5. Inspections due in next 30 days
SELECT * 
FROM Inspections
WHERE NextInspection BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL 30 DAY;

-- 6. Count pass/fail inspections
SELECT Result, COUNT(*) AS Total
FROM Inspections
GROUP BY Result;

-- 7. Subquery: Inspections conducted by inspector who inspected more than 3 sites
SELECT * 
FROM Inspections
WHERE InspectorName IN (
  SELECT InspectorName
  FROM Inspections
  GROUP BY InspectorName
  HAVING COUNT(DISTINCT SiteID) > 3
);

-- 8. Join with Employees to see assigned by
SELECT i.InspectionID, i.Status, e.FullName AS AssignedByName
FROM Inspections i
JOIN Employees e ON i.AssignedBy = e.EmployeeID;

-- 9. Rank inspections by date
SELECT InspectionID, InspectionDate, 
       RANK() OVER (ORDER BY InspectionDate DESC) AS RecentRank
FROM Inspections;

-- 10. Inspections with remarks containing 'Routine'
SELECT * 
FROM Inspections
WHERE Remarks LIKE '%Routine%';

-- 11. Built-in function: Extract month from InspectionDate
SELECT InspectionID, EXTRACT(MONTH FROM InspectionDate) AS Month
FROM Inspections;

-- 12. Inspections completed
SELECT * 
FROM Inspections
WHERE Status = 'Completed';

-- 13. Total inspections assigned per employee
SELECT AssignedBy, COUNT(*) AS AssignedCount
FROM Inspections
GROUP BY AssignedBy;

-- 14. Subquery: Inspections for sites with more than 2 inspections
SELECT * 
FROM Inspections
WHERE SiteID IN (
  SELECT SiteID
  FROM Inspections
  GROUP BY SiteID
  HAVING COUNT(*) > 2
);

-- 15. User-defined function: Days until next inspection
CREATE FUNCTION DaysUntilNext(next_date DATE) RETURNS INT DETERMINISTIC
RETURN DATEDIFF(next_date, CURRENT_DATE);

SELECT InspectionID, NextInspection, DaysUntilNext(NextInspection) AS DaysLeft
FROM Inspections;

-- 16. Inspections pending approval
SELECT * 
FROM Inspections
WHERE ApprovedBy IS NULL;

-- 17. Inspections failed
SELECT * 
FROM Inspections
WHERE Result = 'Fail';

-- 18. Upcoming inspections for a specific inspector
SELECT * 
FROM Inspections
WHERE InspectorName = 'Inspector 5' AND NextInspection >= CURRENT_DATE;

-- 19. Subquery: Inspections where result differs from last inspection
SELECT * 
FROM Inspections i1
WHERE Result <> (SELECT Result FROM Inspections i2 WHERE i2.SiteID = i1.SiteID AND i2.InspectionDate < i1.InspectionDate ORDER BY InspectionDate DESC LIMIT 1);

-- 20. Inspections sorted by NextInspection ascending
SELECT * 
FROM Inspections
ORDER BY NextInspection ASC;


-- Table 16. MaintenanceRequest

-- 1. Select all pending maintenance requests
SELECT * 
FROM MaintenanceRequests
WHERE Status = 'Pending';

-- 2. Count requests per issue type
SELECT IssueType, COUNT(*) AS TotalRequests
FROM MaintenanceRequests
GROUP BY IssueType;

-- 3. Join with Clients to get client info
SELECT m.RequestID, m.IssueType, c.Name AS ClientName
FROM MaintenanceRequests m
JOIN Clients c ON m.ClientID = c.ClientID;

-- 4. Requests assigned to a specific employee
SELECT * 
FROM MaintenanceRequests
WHERE AssignedTo = 2;

-- 5. Requests resolved this month
SELECT * 
FROM MaintenanceRequests
WHERE Status = 'Resolved'
AND EXTRACT(MONTH FROM CompletionDate) = EXTRACT(MONTH FROM CURRENT_DATE);

-- 6. Average completion time (in days)
SELECT AVG(DATEDIFF(CompletionDate, RequestDate)) AS AvgCompletionDays
FROM MaintenanceRequests
WHERE Status = 'Resolved';

-- 7. Subquery: Requests for clients with more than 2 requests
SELECT * 
FROM MaintenanceRequests
WHERE ClientID IN (
  SELECT ClientID
  FROM MaintenanceRequests
  GROUP BY ClientID
  HAVING COUNT(*) > 2
);

-- 8. Join with PropertyListings to get property details
SELECT m.RequestID, m.IssueType, p.PropertyName
FROM MaintenanceRequests m
JOIN PropertyListings p ON m.PropertyID = p.PropertyID;

-- 9. Rank requests by request date
SELECT RequestID, RequestDate, 
       RANK() OVER (ORDER BY RequestDate DESC) AS RecentRank
FROM MaintenanceRequests;

-- 10. Requests with feedback containing 'good'
SELECT * 
FROM MaintenanceRequests
WHERE Feedback LIKE '%good%';

-- 11. Built-in function: extract year of request
SELECT RequestID, EXTRACT(YEAR FROM RequestDate) AS RequestYear
FROM MaintenanceRequests;

-- 12. Count requests per status
SELECT Status, COUNT(*) AS TotalRequests
FROM MaintenanceRequests
GROUP BY Status;

-- 13. Requests pending and assigned to a specific employee
SELECT * 
FROM MaintenanceRequests
WHERE Status = 'Pending' AND AssignedTo = 9;

-- 14. Subquery: Requests related to properties in a specific city
SELECT * 
FROM MaintenanceRequests
WHERE PropertyID IN (
  SELECT PropertyID
  FROM PropertyListings
  WHERE City = 'Mumbai'
);

-- 15. UDF: Calculate estimated resolution days
CREATE FUNCTION EstResolutionDays(start_date DATE, end_date DATE) RETURNS INT DETERMINISTIC
RETURN DATEDIFF(end_date, start_date);

SELECT RequestID, IssueType, EstResolutionDays(RequestDate, CompletionDate) AS DaysToResolve
FROM MaintenanceRequests;

-- 16. Requests still in progress
SELECT * 
FROM MaintenanceRequests
WHERE Status = 'In Progress';

-- 17. Top 5 clients by number of requests
SELECT ClientID, COUNT(*) AS RequestsCount
FROM MaintenanceRequests
GROUP BY ClientID
ORDER BY RequestsCount DESC
LIMIT 5;

-- 18. Requests completed in last 30 days
SELECT * 
FROM MaintenanceRequests
WHERE CompletionDate BETWEEN CURRENT_DATE - INTERVAL 30 DAY AND CURRENT_DATE;

-- 19. Subquery: Requests for properties with high value
SELECT * 
FROM MaintenanceRequests
WHERE PropertyID IN (
  SELECT PropertyID
  FROM PropertyListings
  WHERE Price > 1000000
);

-- 20. Requests sorted by status and request date
SELECT * 
FROM MaintenanceRequests
ORDER BY Status ASC, RequestDate DESC;


-- Table 17. Lease

-- 1. Active leases
SELECT * 
FROM Leases
WHERE Status = 'Active';

-- 2. Total rent collected
SELECT SUM(RentAmount) AS TotalRent
FROM Leases
WHERE Status = 'Active';

-- 3. Join with Clients
SELECT l.LeaseID, c.Name AS ClientName, l.RentAmount
FROM Leases l
JOIN Clients c ON l.ClientID = c.ClientID;

-- 4. Leases ending this month
SELECT * 
FROM Leases
WHERE EXTRACT(MONTH FROM EndDate) = EXTRACT(MONTH FROM CURRENT_DATE);

-- 5. Average deposit amount
SELECT AVG(DepositAmount) AS AvgDeposit
FROM Leases;

-- 6. Subquery: Leases with rent above average
SELECT * 
FROM Leases
WHERE RentAmount > (SELECT AVG(RentAmount) FROM Leases);

-- 7. Count leases per property
SELECT PropertyID, COUNT(*) AS LeaseCount
FROM Leases
GROUP BY PropertyID;

-- 8. Join with PropertyListings for property details
SELECT l.LeaseID, p.PropertyName, l.RentAmount
FROM Leases l
JOIN PropertyListings p ON l.PropertyID = p.PropertyID;

-- 9. Rank leases by rent amount
SELECT LeaseID, RentAmount,
       RANK() OVER (ORDER BY RentAmount DESC) AS RentRank
FROM Leases;

-- 10. Built-in function: extract year from start date
SELECT LeaseID, EXTRACT(YEAR FROM StartDate) AS StartYear
FROM Leases;

-- 11. Count leases per status
SELECT Status, COUNT(*) AS TotalLeases
FROM Leases
GROUP BY Status;

-- 12. Pending leases
SELECT * 
FROM Leases
WHERE Status = 'Pending';

-- 13. Subquery: Clients with multiple leases
SELECT * 
FROM Leases
WHERE ClientID IN (
  SELECT ClientID
  FROM Leases
  GROUP BY ClientID
  HAVING COUNT(*) > 1
);

-- 14. Leases with agreements not signed
SELECT * 
FROM Leases
WHERE AgreementSigned = FALSE;

-- 15. UDF: Calculate lease duration in days
CREATE FUNCTION LeaseDuration(start_date DATE, end_date DATE) RETURNS INT DETERMINISTIC
RETURN DATEDIFF(end_date, start_date);

SELECT LeaseID, LeaseDuration(StartDate, EndDate) AS LeaseDays
FROM Leases
WHERE EndDate IS NOT NULL;

-- 16. Leases for properties in a specific city
SELECT * 
FROM Leases
WHERE PropertyID IN (
  SELECT PropertyID FROM PropertyListings WHERE City = 'Mumbai'
);

-- 17. Top 5 leases by rent amount
SELECT * 
FROM Leases
ORDER BY RentAmount DESC
LIMIT 5;

-- 18. Leases expiring in next 60 days
SELECT * 
FROM Leases
WHERE EndDate BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL 60 DAY;

-- 19. Subquery: Leases with rent above average of their city
SELECT * 
FROM Leases
WHERE RentAmount > (
  SELECT AVG(RentAmount)
  FROM Leases l2
  JOIN PropertyListings p2 ON l2.PropertyID = p2.PropertyID
  WHERE p2.City = (SELECT City FROM PropertyListings p1 WHERE p1.PropertyID = Leases.PropertyID)
);

-- 20. Leases sorted by status and start date
SELECT * 
FROM Leases
ORDER BY Status ASC, StartDate DESC;


-- Table 18. LegalDocument 

-- 1. All verified documents
SELECT * 
FROM LegalDocuments
WHERE Status = 'Verified';

-- 2. Documents expiring in next 90 days
SELECT * 
FROM LegalDocuments
WHERE ExpiryDate BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL 90 DAY;

-- 3. Join with PropertyListings to get property info
SELECT ld.DocumentID, ld.DocumentType, p.PropertyName
FROM LegalDocuments ld
JOIN PropertyListings p ON ld.PropertyID = p.PropertyID;

-- 4. Count documents per type
SELECT DocumentType, COUNT(*) AS TotalDocuments
FROM LegalDocuments
GROUP BY DocumentType;

-- 5. Pending verification documents
SELECT * 
FROM LegalDocuments
WHERE Status = 'Pending';

-- 6. Subquery: Documents for properties in a specific city
SELECT * 
FROM LegalDocuments
WHERE PropertyID IN (
  SELECT PropertyID
  FROM PropertyListings
  WHERE City = 'Mumbai'
);

-- 7. Documents uploaded this year
SELECT * 
FROM LegalDocuments
WHERE EXTRACT(YEAR FROM UploadDate) = EXTRACT(YEAR FROM CURRENT_DATE);

-- 8. Built-in function: extract month from issue date
SELECT DocumentID, EXTRACT(MONTH FROM IssueDate) AS IssueMonth
FROM LegalDocuments;

-- 9. Documents verified by a specific employee
SELECT * 
FROM LegalDocuments
WHERE VerifiedBy = 301;

-- 10. Count documents per status
SELECT Status, COUNT(*) AS Total
FROM LegalDocuments
GROUP BY Status;

-- 11. Subquery: Documents for properties with high price
SELECT * 
FROM LegalDocuments
WHERE PropertyID IN (
  SELECT PropertyID
  FROM PropertyListings
  WHERE Price > 1000000
);

-- 12. Join with MaintenanceRequests to find properties with pending requests
SELECT ld.DocumentID, ld.DocumentType, mr.Status AS RequestStatus
FROM LegalDocuments ld
LEFT JOIN MaintenanceRequests mr ON ld.PropertyID = mr.PropertyID
WHERE mr.Status = 'Pending';

-- 13. Top 5 recently uploaded documents
SELECT * 
FROM LegalDocuments
ORDER BY UploadDate DESC
LIMIT 5;

-- 14. Subquery: Documents for clients with multiple properties
SELECT * 
FROM LegalDocuments
WHERE PropertyID IN (
  SELECT PropertyID
  FROM PropertyListings
  WHERE OwnerID IN (
    SELECT ClientID
    FROM PropertyListings
    GROUP BY ClientID
    HAVING COUNT(PropertyID) > 1
  )
);

-- 15. UDF: Calculate document validity in days
CREATE FUNCTION DocValidity(issue_date DATE, expiry_date DATE) RETURNS INT DETERMINISTIC
RETURN DATEDIFF(expiry_date, issue_date);

SELECT DocumentID, DocValidity(IssueDate, ExpiryDate) AS ValidityDays
FROM LegalDocuments;

-- 16. Documents sorted by status and issue date
SELECT * 
FROM LegalDocuments
ORDER BY Status ASC, IssueDate DESC;

-- 17. Subquery: Latest document per property
SELECT * 
FROM LegalDocuments ld1
WHERE UploadDate = (
  SELECT MAX(UploadDate)
  FROM LegalDocuments ld2
  WHERE ld2.PropertyID = ld1.PropertyID
);

-- 18. Documents with remarks containing 'valid'
SELECT * 
FROM LegalDocuments
WHERE Remarks LIKE '%valid%';

-- 19. Count documents verified by each employee
SELECT VerifiedBy, COUNT(*) AS TotalVerified
FROM LegalDocuments
GROUP BY VerifiedBy;

-- 20. Window function: rank documents by upload date
SELECT DocumentID, UploadDate,
       RANK() OVER (PARTITION BY PropertyID ORDER BY UploadDate DESC) AS RankPerProperty
FROM LegalDocuments;


-- Table 19. Permit
 
-- 1. All approved permits
SELECT * 
FROM Permits
WHERE Status = 'Approved';

-- 2. Permits expiring this year
SELECT * 
FROM Permits
WHERE EXTRACT(YEAR FROM ExpiryDate) = EXTRACT(YEAR FROM CURRENT_DATE);

-- 3. Join with Sites to get site info
SELECT p.PermitID, p.Type, s.SiteName
FROM Permits p
JOIN Sites s ON p.SiteID = s.SiteID;

-- 4. Count permits per type
SELECT Type, COUNT(*) AS TotalPermits
FROM Permits
GROUP BY Type;

-- 5. Pending permits
SELECT * 
FROM Permits
WHERE Status = 'Pending';

-- 6. Subquery: Permits issued by 'Municipal Authority'
SELECT * 
FROM Permits
WHERE IssuedBy = (
  SELECT DISTINCT IssuedBy 
  FROM Permits 
  WHERE IssuedBy LIKE '%Municipal%'
);

-- 7. Permits issued in last 6 months
SELECT * 
FROM Permits
WHERE IssueDate BETWEEN CURRENT_DATE - INTERVAL 6 MONTH AND CURRENT_DATE;

-- 8. Built-in function: extract month from expiry date
SELECT PermitID, EXTRACT(MONTH FROM ExpiryDate) AS ExpiryMonth
FROM Permits;

-- 9. Permits verified by employee 301
SELECT * 
FROM Permits
WHERE VerifiedBy = 301;

-- 10. Count permits per status
SELECT Status, COUNT(*) AS Total
FROM Permits
GROUP BY Status;

-- 11. Subquery: Permits for sites in a specific city
SELECT * 
FROM Permits
WHERE SiteID IN (
  SELECT SiteID
  FROM Sites
  WHERE City = 'Delhi'
);

-- 12. Join with ConstructionPhases to find permits for active phases
SELECT prm.PermitID, prm.Type, cp.Status AS PhaseStatus
FROM Permits prm
JOIN ConstructionPhases cp ON prm.SiteID = cp.ProjectID
WHERE cp.Status = 'In Progress';

-- 13. Top 5 recent permits
SELECT * 
FROM Permits
ORDER BY IssueDate DESC
LIMIT 5;

-- 14. UDF: Calculate permit validity
CREATE FUNCTION PermitValidity(issue_date DATE, expiry_date DATE) RETURNS INT DETERMINISTIC
RETURN DATEDIFF(expiry_date, issue_date);

SELECT PermitID, PermitValidity(IssueDate, ExpiryDate) AS ValidityDays
FROM Permits;

-- 15. Subquery: Permits for projects with budget > 500000
SELECT * 
FROM Permits
WHERE SiteID IN (
  SELECT ProjectID
  FROM ConstructionPhases
  WHERE Budget > 500000
);

-- 16. Permits sorted by status and issue date
SELECT * 
FROM Permits
ORDER BY Status ASC, IssueDate DESC;

-- 17. Subquery: Latest permit per site
SELECT * 
FROM Permits prm1
WHERE IssueDate = (
  SELECT MAX(IssueDate)
  FROM Permits prm2
  WHERE prm2.SiteID = prm1.SiteID
);

-- 18. Permits with notes containing 'review'
SELECT * 
FROM Permits
WHERE Notes LIKE '%review%';

-- 19. Count permits verified by each employee
SELECT VerifiedBy, COUNT(*) AS TotalVerified
FROM Permits
GROUP BY VerifiedBy;

-- 20. Window function: rank permits by issue date per type
SELECT PermitID, Type, IssueDate,
       RANK() OVER (PARTITION BY Type ORDER BY IssueDate DESC) AS RankPerType
FROM Permits;


-- Table 20. ConstructionPhase

-- 1. All completed phases
SELECT * 
FROM ConstructionPhases
WHERE Status = 'Completed';

-- 2. Phases in progress
SELECT * 
FROM ConstructionPhases
WHERE Status = 'In Progress';

-- 3. Join with Projects to get project name
SELECT cp.PhaseID, cp.PhaseName, pr.ProjectName
FROM ConstructionPhases cp
JOIN Projects pr ON cp.ProjectID = pr.ProjectID;

-- 4. Count phases per project
SELECT ProjectID, COUNT(*) AS TotalPhases
FROM ConstructionPhases
GROUP BY ProjectID;

-- 5. Subquery: Phases with actual cost higher than budget
SELECT * 
FROM ConstructionPhases
WHERE ActualCost > Budget;

-- 6. Built-in function: extract month from start date
SELECT PhaseID, EXTRACT(MONTH FROM StartDate) AS StartMonth
FROM ConstructionPhases;

-- 7. Top 5 expensive phases by actual cost
SELECT * 
FROM ConstructionPhases
ORDER BY ActualCost DESC
LIMIT 5;

-- 8. Average budget per supervisor
SELECT SupervisorID, AVG(Budget) AS AvgBudget
FROM ConstructionPhases
GROUP BY SupervisorID;

-- 9. Join with Permits to check required permits
SELECT cp.PhaseID, cp.PhaseName, prm.Status AS PermitStatus
FROM ConstructionPhases cp
LEFT JOIN Permits prm ON cp.ProjectID = prm.SiteID;

-- 10. Subquery: Phases starting this month
SELECT * 
FROM ConstructionPhases
WHERE StartDate BETWEEN DATE_TRUNC('month', CURRENT_DATE) AND CURRENT_DATE;

-- 11. Window function: rank phases by budget per project
SELECT PhaseID, ProjectID, Budget,
       RANK() OVER (PARTITION BY ProjectID ORDER BY Budget DESC) AS BudgetRank
FROM ConstructionPhases;

-- 12. Phases pending and budget > 100000
SELECT * 
FROM ConstructionPhases
WHERE Status = 'Pending' AND Budget > 100000;

-- 13. Subquery: Phases under supervisor handling multiple projects
SELECT * 
FROM ConstructionPhases
WHERE SupervisorID IN (
  SELECT SupervisorID
  FROM ConstructionPhases
  GROUP BY SupervisorID
  HAVING COUNT(DISTINCT ProjectID) > 1
);

-- 14. Total actual cost per project
SELECT ProjectID, SUM(ActualCost) AS TotalCost
FROM ConstructionPhases
GROUP BY ProjectID;

-- 15. UDF: Calculate phase duration in days
CREATE FUNCTION PhaseDuration(start_date DATE, end_date DATE) RETURNS INT DETERMINISTIC
RETURN DATEDIFF(end_date, start_date);

SELECT PhaseID, PhaseDuration(StartDate, EndDate) AS DurationDays
FROM ConstructionPhases
WHERE EndDate IS NOT NULL;

-- 16. Latest phase per project
SELECT * 
FROM ConstructionPhases cp1
WHERE EndDate = (
  SELECT MAX(EndDate)
  FROM ConstructionPhases cp2
  WHERE cp2.ProjectID = cp1.ProjectID
);

-- 17. Phases sorted by status and start date
SELECT * 
FROM ConstructionPhases
ORDER BY Status ASC, StartDate ASC;

-- 18. Phases with remarks containing 'planned'
SELECT * 
FROM ConstructionPhases
WHERE Remarks LIKE '%planned%';

-- 19. Subquery: Phases for projects with approved permits
SELECT * 
FROM ConstructionPhases
WHERE ProjectID IN (
  SELECT SiteID
  FROM Permits
  WHERE Status = 'Approved'
);

-- 20. Count phases per status
SELECT Status, COUNT(*) AS TotalPhases
FROM ConstructionPhases
GROUP BY Status;


-- Table 21. Task

-- 1. All tasks in progress
SELECT * FROM Tasks WHERE Status='In Progress';

-- 2. Completed tasks
SELECT * FROM Tasks WHERE Status='Completed';

-- 3. Tasks assigned to employee 301
SELECT * FROM Tasks WHERE AssignedTo=301;

-- 4. Count tasks per phase
SELECT PhaseID, COUNT(*) AS TotalTasks FROM Tasks GROUP BY PhaseID;

-- 5. Pending tasks
SELECT * FROM Tasks WHERE Status='Pending';

-- 6. Join with ConstructionPhases to get phase names
SELECT t.TaskID, t.TaskName, cp.PhaseName 
FROM Tasks t
JOIN ConstructionPhases cp ON t.PhaseID = cp.PhaseID;

-- 7. Subquery: Tasks for high priority phases
SELECT * FROM Tasks 
WHERE PhaseID IN (SELECT PhaseID FROM ConstructionPhases WHERE Budget > 200000);

-- 8. Built-in function: calculate task duration
SELECT TaskID, DATEDIFF(EndDate, StartDate) AS DurationDays FROM Tasks;

-- 9. Tasks with progress > 50%
SELECT * FROM Tasks WHERE ProgressPercent > 50;

-- 10. Count tasks per status
SELECT Status, COUNT(*) AS Total FROM Tasks GROUP BY Status;

-- 11. Subquery: Tasks for projects handled by Supervisor 101
SELECT * FROM Tasks 
WHERE PhaseID IN (SELECT PhaseID FROM ConstructionPhases WHERE SupervisorID = 101);

-- 12. Join with Employees to get assignee name
SELECT t.TaskID, t.TaskName, e.Name AS AssignedEmployee 
FROM Tasks t
JOIN Employees e ON t.AssignedTo = e.EmployeeID;

-- 13. Top 5 latest tasks by start date
SELECT * FROM Tasks ORDER BY StartDate DESC LIMIT 5;

-- 14. UDF: Task completion percentage remaining
CREATE FUNCTION RemainingProgress(progress INT) RETURNS INT DETERMINISTIC RETURN 100-progress;
SELECT TaskID, RemainingProgress(ProgressPercent) AS RemainingPercent FROM Tasks;

-- 15. Tasks sorted by priority and start date
SELECT * FROM Tasks ORDER BY Priority DESC, StartDate ASC;

-- 16. Subquery: Tasks for completed phases only
SELECT * FROM Tasks 
WHERE PhaseID IN (SELECT PhaseID FROM ConstructionPhases WHERE Status='Completed');

-- 17. Tasks with remarks containing 'delay'
SELECT * FROM Tasks WHERE Remarks LIKE '%delay%';

-- 18. Count tasks per employee
SELECT AssignedTo, COUNT(*) AS TotalTasks FROM Tasks GROUP BY AssignedTo;

-- 19. Window function: rank tasks by progress per phase
SELECT TaskID, PhaseID, ProgressPercent, 
RANK() OVER (PARTITION BY PhaseID ORDER BY ProgressPercent DESC) AS RankPerPhase
FROM Tasks;

-- 20. Subquery: Tasks for phases with budget above average
SELECT * FROM Tasks 
WHERE PhaseID IN (
  SELECT PhaseID FROM ConstructionPhases WHERE Budget > (SELECT AVG(Budget) FROM ConstructionPhases)
);


-- Table 22. Equipment

-- 1. Active equipment
SELECT * FROM Equipment WHERE Status='Active';

-- 2. Equipment in use
SELECT * FROM Equipment WHERE Status='In Use';

-- 3. Equipment assigned to site 1
SELECT * FROM Equipment WHERE AssignedToSite=1;

-- 4. Count equipment per type
SELECT Type, COUNT(*) AS Total FROM Equipment GROUP BY Type;

-- 5. Equipment under repair
SELECT * FROM Equipment WHERE Status='Under Repair';

-- 6. Join with Sites to get site names
SELECT e.EquipmentID, e.Name, s.SiteName 
FROM Equipment e
JOIN Sites s ON e.AssignedToSite = s.SiteID;

-- 7. Subquery: Equipment purchased after 2023-05-01
SELECT * FROM Equipment WHERE PurchaseDate > '2023-05-01';

-- 8. Built-in function: extract month of purchase
SELECT EquipmentID, EXTRACT(MONTH FROM PurchaseDate) AS PurchaseMonth FROM Equipment;

-- 9. Equipment with quantity more than 5
SELECT * FROM Equipment WHERE Quantity > 5;

-- 10. Count equipment per status
SELECT Status, COUNT(*) AS Total FROM Equipment GROUP BY Status;

-- 11. Subquery: Equipment assigned to sites in Mumbai
SELECT * FROM Equipment 
WHERE AssignedToSite IN (SELECT SiteID FROM Sites WHERE City='Mumbai');

-- 12. Join with Vendors to get vendor name
SELECT e.EquipmentID, e.Name, v.VendorName 
FROM Equipment e
JOIN Vendors v ON e.VendorID = v.VendorID;

-- 13. Top 5 recently purchased equipment
SELECT * FROM Equipment ORDER BY PurchaseDate DESC LIMIT 5;

-- 14. UDF: Days until next maintenance
CREATE FUNCTION DaysToMaintenance(maint_date DATE) RETURNS INT DETERMINISTIC RETURN DATEDIFF(maint_date, CURRENT_DATE);
SELECT EquipmentID, DaysToMaintenance(MaintenanceDate) AS DaysLeft FROM Equipment;

-- 15. Equipment sorted by type and quantity
SELECT * FROM Equipment ORDER BY Type, Quantity DESC;

-- 16. Subquery: Equipment for phases with budget > 500000
SELECT * FROM Equipment WHERE AssignedToSite IN 
(SELECT ProjectID FROM ConstructionPhases WHERE Budget>500000);

-- 17. Equipment with remarks containing 'backup'
SELECT * FROM Equipment WHERE Remarks LIKE '%backup%';

-- 18. Count equipment per vendor
SELECT VendorID, COUNT(*) AS Total FROM Equipment GROUP BY VendorID;

-- 19. Window function: rank equipment by quantity per type
SELECT EquipmentID, Type, Quantity,
RANK() OVER (PARTITION BY Type ORDER BY Quantity DESC) AS RankPerType
FROM Equipment;

-- 20. Subquery: Equipment with maintenance overdue
SELECT * FROM Equipment WHERE MaintenanceDate < CURRENT_DATE;


-- Table 23. SiteVisits

-- 1. All site visits
SELECT * FROM SiteVisits;

-- 2. Visits guided by employee 101
SELECT * FROM SiteVisits WHERE GuidedBy=101;

-- 3. Visits in July 2023
SELECT * FROM SiteVisits WHERE EXTRACT(MONTH FROM VisitDate)=7 AND EXTRACT(YEAR FROM VisitDate)=2023;

-- 4. Count visits per site
SELECT SiteID, COUNT(*) AS TotalVisits FROM SiteVisits GROUP BY SiteID;

-- 5. Visits with duration > 60 minutes
SELECT * FROM SiteVisits WHERE DurationMinutes>60;

-- 6. Join with Sites to get site names
SELECT sv.VisitID, sv.VisitorName, s.SiteName 
FROM SiteVisits sv
JOIN Sites s ON sv.SiteID = s.SiteID;

-- 7. Subquery: Visits for sites in Mumbai
SELECT * FROM SiteVisits WHERE SiteID IN (SELECT SiteID FROM Sites WHERE City='Mumbai');

-- 8. Built-in function: weekday of visit
SELECT VisitID, DAYNAME(VisitDate) AS Weekday FROM SiteVisits;

-- 9. Completed visits
SELECT * FROM SiteVisits WHERE Status='Completed';

-- 10. Count visits per guided employee
SELECT GuidedBy, COUNT(*) AS Total FROM SiteVisits GROUP BY GuidedBy;

-- 11. Subquery: Visits for sites with active projects
SELECT * FROM SiteVisits 
WHERE SiteID IN (SELECT ProjectID FROM ConstructionPhases WHERE Status='In Progress');

-- 12. Join with Employees to get guide name
SELECT sv.VisitID, sv.VisitorName, e.Name AS GuideName 
FROM SiteVisits sv
JOIN Employees e ON sv.GuidedBy=e.EmployeeID;

-- 13. Top 5 longest visits
SELECT * FROM SiteVisits ORDER BY DurationMinutes DESC LIMIT 5;

-- 14. UDF: convert duration to hours
CREATE FUNCTION DurationHours(minutes INT) RETURNS DECIMAL(5,2) DETERMINISTIC RETURN minutes/60.0;
SELECT VisitID, DurationHours(DurationMinutes) AS Hours FROM SiteVisits;

-- 15. Visits sorted by status and date
SELECT * FROM SiteVisits ORDER BY Status ASC, VisitDate DESC;

-- 16. Subquery: Visits for clients with feedback rating >=4
SELECT * FROM SiteVisits WHERE SiteID IN 
(SELECT PropertyID FROM Feedback WHERE Rating>=4);

-- 17. Visits with notes containing 'inspection'
SELECT * FROM SiteVisits WHERE Notes LIKE '%inspection%';

-- 18. Count visits per month
SELECT EXTRACT(MONTH FROM VisitDate) AS Month, COUNT(*) AS TotalVisits 
FROM SiteVisits GROUP BY EXTRACT(MONTH FROM VisitDate);

-- 19. Window function: rank visits by duration per site
SELECT VisitID, SiteID, DurationMinutes,
RANK() OVER (PARTITION BY SiteID ORDER BY DurationMinutes DESC) AS RankPerSite
FROM SiteVisits;

-- 20. Subquery: visits for projects with budget above average
SELECT * FROM SiteVisits 
WHERE SiteID IN (SELECT ProjectID FROM Budgets WHERE Amount > (SELECT AVG(Amount) FROM Budgets));


-- Table 24. Budget

-- 1. All approved budgets
SELECT * FROM Budgets WHERE Status='Approved';

-- 2. Pending budgets
SELECT * FROM Budgets WHERE Status='Pending';

-- 3. Budgets above 100000
SELECT * FROM Budgets WHERE Amount>100000;

-- 4. Count budgets per category
SELECT Category, COUNT(*) AS Total FROM Budgets GROUP BY Category;

-- 5. Sum of budget per project
SELECT ProjectID, SUM(Amount) AS TotalBudget FROM Budgets GROUP BY ProjectID;

-- 6. Join with Projects to get project names
SELECT b.BudgetID, p.ProjectName, b.Amount 
FROM Budgets b
JOIN Projects p ON b.ProjectID = p.ProjectID;

-- 7. Subquery: Budgets approved by employee 101
SELECT * FROM Budgets WHERE ApprovedBy IN (SELECT EmployeeID FROM Employees WHERE EmployeeID=101);

-- 8. Built-in function: Year difference since approval
SELECT BudgetID, TIMESTAMPDIFF(YEAR, ApprovalDate, CURRENT_DATE) AS YearsSinceApproval FROM Budgets;

-- 9. Budgets for 2024 only
SELECT * FROM Budgets WHERE Year=2024;

-- 10. Count budgets per status
SELECT Status, COUNT(*) AS Total FROM Budgets GROUP BY Status;

-- 11. Subquery: Budgets for projects with more than 2 phases
SELECT * FROM Budgets 
WHERE ProjectID IN (SELECT ProjectID FROM ConstructionPhases GROUP BY ProjectID HAVING COUNT(*)>2);

-- 12. Join with Employees to get approver name
SELECT b.BudgetID, b.Amount, e.Name AS ApprovedByName 
FROM Budgets b
JOIN Employees e ON b.ApprovedBy=e.EmployeeID;

-- 13. Top 5 largest budgets
SELECT * FROM Budgets ORDER BY Amount DESC LIMIT 5;

-- 14. UDF: Budget in thousands
CREATE FUNCTION BudgetInThousands(amount DECIMAL(12,2)) RETURNS DECIMAL(12,2) DETERMINISTIC RETURN amount/1000;
SELECT BudgetID, BudgetInThousands(Amount) AS AmountInThousands FROM Budgets;

-- 15. Budgets sorted by category and amount
SELECT * FROM Budgets ORDER BY Category ASC, Amount DESC;

-- 16. Subquery: Budgets for completed phases only
SELECT * FROM Budgets 
WHERE PhaseID IN (SELECT PhaseID FROM ConstructionPhases WHERE Status='Completed');

-- 17. Budgets with remarks containing 'roof'
SELECT * FROM Budgets WHERE Remarks LIKE '%roof%';

-- 18. Count budgets per year
SELECT Year, COUNT(*) AS Total FROM Budgets GROUP BY Year;

-- 19. Window function: rank budgets by amount per year
SELECT BudgetID, Year, Amount,
RANK() OVER (PARTITION BY Year ORDER BY Amount DESC) AS RankPerYear
FROM Budgets;

-- 20. Subquery: Budgets above average per category
SELECT * FROM Budgets 
WHERE Amount > (SELECT AVG(Amount) FROM Budgets WHERE Category='Mechanical');


-- Table 25. Invoices

-- 1. All invoices
SELECT * FROM Invoices;

-- 2. Paid invoices
SELECT * FROM Invoices WHERE Status='Paid';

-- 3. Unpaid invoices
SELECT * FROM Invoices WHERE PaidAmount<TotalAmount;

-- 4. Total invoice amount per vendor
SELECT VendorID, SUM(TotalAmount) AS TotalInvoiceAmount FROM Invoices GROUP BY VendorID;

-- 5. Count invoices per status
SELECT Status, COUNT(*) AS Total FROM Invoices GROUP BY Status;

-- 6. Join with PurchaseOrders to get order details
SELECT i.InvoiceID, po.OrderDate, i.TotalAmount 
FROM Invoices i
JOIN PurchaseOrders po ON i.OrderID=po.OrderID;

-- 7. Subquery: Invoices for projects with budget > 200000
SELECT * FROM Invoices 
WHERE OrderID IN (SELECT OrderID FROM PurchaseOrders WHERE ProjectID IN 
                 (SELECT ProjectID FROM Budgets WHERE Amount>200000));

-- 8. Built-in function: Days overdue
SELECT InvoiceID, DATEDIFF(DueDate, InvoiceDate) AS PaymentDays FROM Invoices;

-- 9. Top 5 highest invoices
SELECT * FROM Invoices ORDER BY TotalAmount DESC LIMIT 5;

-- 10. Join with Vendors to get vendor name
SELECT i.InvoiceID, i.TotalAmount, v.VendorName 
FROM Invoices i
JOIN Vendors v ON i.VendorID=v.VendorID;

-- 11. Subquery: Invoices generated by employee 101
SELECT * FROM Invoices WHERE GeneratedBy=101;

-- 12. UDF: Outstanding amount
CREATE FUNCTION OutstandingAmount(total DECIMAL(12,2), paid DECIMAL(12,2)) RETURNS DECIMAL(12,2) DETERMINISTIC RETURN total-paid;
SELECT InvoiceID, OutstandingAmount(TotalAmount,PaidAmount) AS PendingAmount FROM Invoices;

-- 13. Invoices sorted by due date
SELECT * FROM Invoices ORDER BY DueDate ASC;

-- 14. Subquery: Invoices for orders with more than 3 items
SELECT * FROM Invoices 
WHERE OrderID IN (SELECT OrderID FROM PurchaseOrders WHERE Quantity>3);

-- 15. Invoices in July 2023
SELECT * FROM Invoices WHERE EXTRACT(MONTH FROM InvoiceDate)=7 AND EXTRACT(YEAR FROM InvoiceDate)=2023;

-- 16. Window function: rank invoices by amount per vendor
SELECT InvoiceID, VendorID, TotalAmount,
RANK() OVER (PARTITION BY VendorID ORDER BY TotalAmount DESC) AS RankPerVendor
FROM Invoices;

-- 17. Invoices with notes containing 'delivery'
SELECT * FROM Invoices WHERE Notes LIKE '%delivery%';

-- 18. Sum paid amount per month
SELECT EXTRACT(MONTH FROM InvoiceDate) AS Month, SUM(PaidAmount) AS TotalPaid 
FROM Invoices GROUP BY EXTRACT(MONTH FROM InvoiceDate);

-- 19. Subquery: Invoices for vendors from Mumbai
SELECT * FROM Invoices WHERE VendorID IN (SELECT VendorID FROM Vendors WHERE City='Mumbai');

-- 20. Join with Employees to get who generated invoice
SELECT i.InvoiceID, i.TotalAmount, e.Name AS GeneratedByName 
FROM Invoices i
JOIN Employees e ON i.GeneratedBy=e.EmployeeID;

-- 1. All feedback
SELECT * FROM Feedback;

-- 2. Resolved feedback
SELECT * FROM Feedback WHERE Resolved=TRUE;

-- 3. Pending feedback
SELECT * FROM Feedback WHERE Resolved=FALSE;

-- 4. Average rating per property
SELECT PropertyID, AVG(Rating) AS AvgRating FROM Feedback GROUP BY PropertyID;

-- 5. Count feedback per agent
SELECT AgentID, COUNT(*) AS Total FROM Feedback GROUP BY AgentID;

-- 6. Join with Clients to get client name
SELECT f.FeedbackID, c.Name AS ClientName, f.Rating 
FROM Feedback f
JOIN Clients c ON f.ClientID=c.ClientID;

-- 7. Subquery: Feedback with rating <3
SELECT * FROM Feedback WHERE Rating <3;

-- 8. Built-in function: length of comments
SELECT FeedbackID, LENGTH(Comments) AS CommentLength FROM Feedback;

-- 9. Feedback for property 1
SELECT * FROM Feedback WHERE PropertyID=1;

-- 10. Count feedback per rating
SELECT Rating, COUNT(*) AS Total FROM Feedback GROUP BY Rating;

-- 11. Subquery: Feedback for agents handling more than 2 properties
SELECT * FROM Feedback WHERE AgentID IN (SELECT AgentID FROM PropertyListings GROUP BY AgentID HAVING COUNT(*)>2);

-- 12. Join with Agents to get agent name
SELECT f.FeedbackID, f.Rating, a.Name AS AgentName 
FROM Feedback f
JOIN Agents a ON f.AgentID=a.AgentID;

-- 13. Top 5 highest ratings
SELECT * FROM Feedback ORDER BY Rating DESC LIMIT 5;

-- 14. UDF: Is feedback positive
CREATE FUNCTION IsPositive(r INT) RETURNS VARCHAR(10) DETERMINISTIC RETURN IF(r>=4,'Yes','No');
SELECT FeedbackID, IsPositive(Rating) AS Positive FROM Feedback;

-- 15. Feedback sorted by date
SELECT * FROM Feedback ORDER BY SubmittedDate DESC;

-- 16. Subquery: Feedback for properties in Mumbai
SELECT * FROM Feedback WHERE PropertyID IN (SELECT PropertyID FROM PropertyListings WHERE City='Mumbai');

-- 17. Feedback with comments containing 'delayed'
SELECT * FROM Feedback WHERE Comments LIKE '%delayed%';

-- 18. Count feedback per month
SELECT EXTRACT(MONTH FROM SubmittedDate) AS Month, COUNT(*) AS Total 
FROM Feedback GROUP BY EXTRACT(MONTH FROM SubmittedDate);

-- 19. Window function: rank feedback by rating per agent
SELECT FeedbackID, AgentID, Rating,
RANK() OVER (PARTITION BY AgentID ORDER BY Rating DESC) AS RankPerAgent
FROM Feedback;

-- 20. Subquery: Feedback from clients who gave multiple feedbacks
SELECT * FROM Feedback WHERE ClientID IN 
(SELECT ClientID FROM Feedback GROUP BY ClientID HAVING COUNT(*)>1);


