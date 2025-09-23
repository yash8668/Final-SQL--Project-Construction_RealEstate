use  Construction_RealEstate;

--  1.Projects

-- View of all ongoing projects
CREATE VIEW OngoingProjects AS
SELECT ProjectID, Name, Budget, Location
FROM Projects
WHERE Status = 'Ongoing';

-- View showing average budget by type
CREATE VIEW AvgBudgetByType AS
SELECT Type, AVG(Budget) AS AvgBudget
FROM Projects
GROUP BY Type;

-- Display all project names one by one
DELIMITER //
CREATE PROCEDURE ShowProjectNames()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE pname VARCHAR(100);
  DECLARE proj_cursor CURSOR FOR SELECT Name FROM Projects;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN proj_cursor;
  read_loop: LOOP
    FETCH proj_cursor INTO pname;
    IF done THEN
      LEAVE read_loop;
    END IF;
    SELECT pname;
  END LOOP;
  CLOSE proj_cursor;
END;
//
DELIMITER ;

-- Increase budget for a given location
DELIMITER //
CREATE PROCEDURE IncreaseBudgetByLocation(IN loc VARCHAR(100), IN inc DECIMAL(12,2))
BEGIN
  UPDATE Projects
  SET Budget = Budget + inc
  WHERE Location = loc;
END;
//
DELIMITER ;

-- Rank projects by budget
SELECT ProjectID, Name, Budget,
       RANK() OVER (ORDER BY Budget DESC) AS BudgetRank
FROM Projects;

-- Rank projects by start date within type
SELECT ProjectID, Name, Type, StartDate,
       DENSE_RANK() OVER (PARTITION BY Type ORDER BY StartDate) AS TypeRank
FROM Projects;

-- Compare each project’s budget with previous one
SELECT ProjectID, Name, Budget,
       LAG(Budget, 1) OVER (ORDER BY StartDate) AS PrevBudget
FROM Projects;

-- Compare each project’s budget with next one
SELECT ProjectID, Name, Budget,
       LEAD(Budget, 1) OVER (ORDER BY StartDate) AS NextBudget
FROM Projects;

-- Divide projects into 4 budget groups
SELECT ProjectID, Name, Budget,
       NTILE(4) OVER (ORDER BY Budget DESC) AS BudgetGroup
FROM Projects;

-- Give access on Projects
GRANT SELECT, UPDATE ON Projects TO 'user1'@'localhost';

-- Remove access on Projects
REVOKE UPDATE ON Projects FROM 'user1'@'localhost';

-- Transaction to transfer funds between projects
START TRANSACTION;
UPDATE Projects SET Budget = Budget - 500000 WHERE ProjectID = 1;
UPDATE Projects SET Budget = Budget + 500000 WHERE ProjectID = 2;
COMMIT;

-- Transaction rollback example
START TRANSACTION;
UPDATE Projects SET Budget = Budget - 1000000 WHERE ProjectID = 3;
ROLLBACK;

-- Savepoint example
START TRANSACTION;
UPDATE Projects SET Budget = Budget - 200000 WHERE ProjectID = 4;
SAVEPOINT sp1;
UPDATE Projects SET Budget = Budget + 200000 WHERE ProjectID = 5;
ROLLBACK TO sp1;
COMMIT;

-- Audit table for Projects
CREATE TABLE ProjectAudit (
  AuditID INT AUTO_INCREMENT PRIMARY KEY,
  ProjectID INT,
  Action VARCHAR(50),
  ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Record new project insertions
CREATE TRIGGER after_project_insert
AFTER INSERT ON Projects
FOR EACH ROW
INSERT INTO ProjectAudit(ProjectID, Action)
VALUES (NEW.ProjectID, 'INSERT');

-- Record project deletions
CREATE TRIGGER after_project_delete
AFTER DELETE ON Projects
FOR EACH ROW
INSERT INTO ProjectAudit(ProjectID, Action)
VALUES (OLD.ProjectID, 'DELETE');

-- Prevent negative budget updates
DELIMITER //
CREATE TRIGGER before_budget_update
BEFORE UPDATE ON Projects
FOR EACH ROW
BEGIN
  IF NEW.Budget < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Budget cannot be negative';
  END IF;
END;
//
DELIMITER ;

-- 2. 

-- 1. View of all cleared sites
CREATE VIEW ClearedSites AS
SELECT SiteID, ProjectID, Address, City, Status
FROM Sites
WHERE Status = 'Cleared';

-- 2. View showing total area by city
CREATE VIEW TotalAreaByCity AS
SELECT City, SUM(AreaSqFt) AS TotalArea
FROM Sites
GROUP BY City;

-- 3. Procedure to display all site addresses
DELIMITER //
CREATE PROCEDURE ShowSiteAddresses()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE saddr TEXT;
    DECLARE site_cursor CURSOR FOR SELECT Address FROM Sites;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN site_cursor;
    read_loop: LOOP
        FETCH site_cursor INTO saddr;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT saddr;
    END LOOP;
    CLOSE site_cursor;
END;
//
DELIMITER ;

-- 4. Procedure to update status of sites by city
DELIMITER //
CREATE PROCEDURE UpdateSiteStatus(IN c VARCHAR(50), IN st VARCHAR(30))
BEGIN
    UPDATE Sites
    SET Status = st
    WHERE City = c;
END;
//
DELIMITER ;

-- 5. Rank sites by area
SELECT SiteID, Address, AreaSqFt,
       RANK() OVER (ORDER BY AreaSqFt DESC) AS AreaRank
FROM Sites;

-- 6. Dense rank sites within city by area
SELECT SiteID, Address, City, AreaSqFt,
       DENSE_RANK() OVER (PARTITION BY City ORDER BY AreaSqFt DESC) AS CityRank
FROM Sites;

-- 7. Compare each site’s area with previous one
SELECT SiteID, Address, AreaSqFt,
       LAG(AreaSqFt,1) OVER (ORDER BY AreaSqFt) AS PrevArea
FROM Sites;

-- 8. Compare each site’s area with next one
SELECT SiteID, Address, AreaSqFt,
       LEAD(AreaSqFt,1) OVER (ORDER BY AreaSqFt) AS NextArea
FROM Sites;

-- 9. Divide sites into 4 groups based on area
SELECT SiteID, Address, AreaSqFt,
       NTILE(4) OVER (ORDER BY AreaSqFt DESC) AS AreaGroup
FROM Sites;

-- 10. Grant select access to user1
GRANT SELECT ON Sites TO 'user1'@'localhost';

-- 11. Revoke access
REVOKE SELECT ON Sites FROM 'user1'@'localhost';

-- 12. Transaction: Update multiple site statuses
START TRANSACTION;
UPDATE Sites SET Status='Surveyed' WHERE SiteID IN (1,3);
UPDATE Sites SET Status='Cleared' WHERE SiteID IN (6,17);
COMMIT;

-- 13. Transaction rollback example
START TRANSACTION;
UPDATE Sites SET AreaSqFt = AreaSqFt + 500 WHERE SiteID = 2;
ROLLBACK;

-- 14. Savepoint example
START TRANSACTION;
UPDATE Sites SET AreaSqFt = AreaSqFt - 200 WHERE SiteID = 5;
SAVEPOINT sp1;
UPDATE Sites SET AreaSqFt = AreaSqFt + 300 WHERE SiteID = 8;
ROLLBACK TO sp1;
COMMIT;

-- 15. Create audit table for site changes
CREATE TABLE SiteAudit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    SiteID INT,
    Action VARCHAR(50),
    ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 16. Trigger after insert
CREATE TRIGGER after_site_insert
AFTER INSERT ON Sites
FOR EACH ROW
INSERT INTO SiteAudit(SiteID, Action)
VALUES (NEW.SiteID, 'INSERT');

-- 17. Trigger after delete
CREATE TRIGGER after_site_delete
AFTER DELETE ON Sites
FOR EACH ROW
INSERT INTO SiteAudit(SiteID, Action)
VALUES (OLD.SiteID, 'DELETE');

-- 18. Trigger before update to prevent negative area
DELIMITER //
CREATE TRIGGER before_area_update
BEFORE UPDATE ON Sites
FOR EACH ROW
BEGIN
    IF NEW.AreaSqFt <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Area must be positive';
    END IF;
END;
//
DELIMITER ;

-- 19. Select sites in a particular state
SELECT * FROM Sites WHERE State='Maharashtra';

-- 20. Count number of sites per LandType
SELECT LandType, COUNT(*) AS TotalSites
FROM Sites
GROUP BY LandType;

-- 3. Contractors

-- 1. View of active contractors
CREATE VIEW ActiveContractors AS
SELECT ContractorID, Name, Specialization, Rating, Status
FROM Contractors
WHERE Status='Active';

-- 2. View showing average rating by specialization
CREATE VIEW AvgRatingBySpecialization AS
SELECT Specialization, AVG(Rating) AS AvgRating
FROM Contractors
GROUP BY Specialization;

-- 3. Procedure to display all contractor names
DELIMITER //
CREATE PROCEDURE ShowContractorNames()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cname VARCHAR(100);
    DECLARE cont_cursor CURSOR FOR SELECT Name FROM Contractors;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cont_cursor;
    read_loop: LOOP
        FETCH cont_cursor INTO cname;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT cname;
    END LOOP;
    CLOSE cont_cursor;
END;
//
DELIMITER ;

-- 4. Procedure to increase rating for experienced contractors
DELIMITER //
CREATE PROCEDURE IncreaseRating(IN expYears INT, IN inc DECIMAL(3,2))
BEGIN
    UPDATE Contractors
    SET Rating = Rating + inc
    WHERE ExperienceYears >= expYears;
END;
//
DELIMITER ;

-- 5. Rank contractors by experience
SELECT ContractorID, Name, ExperienceYears,
       RANK() OVER (ORDER BY ExperienceYears DESC) AS ExpRank
FROM Contractors;

-- 6. Dense rank contractors within specialization by rating
SELECT ContractorID, Name, Specialization, Rating,
       DENSE_RANK() OVER (PARTITION BY Specialization ORDER BY Rating DESC) AS SpecRank
FROM Contractors;

-- 7. Compare each contractor’s rating with previous one
SELECT ContractorID, Name, Rating,
       LAG(Rating,1) OVER (ORDER BY ExperienceYears DESC) AS PrevRating
FROM Contractors;

-- 8. Compare each contractor’s rating with next one
SELECT ContractorID, Name, Rating,
       LEAD(Rating,1) OVER (ORDER BY ExperienceYears DESC) AS NextRating
FROM Contractors;

-- 9. Divide contractors into 4 rating groups
SELECT ContractorID, Name, Rating,
       NTILE(4) OVER (ORDER BY Rating DESC) AS RatingGroup
FROM Contractors;

-- 10. Grant SELECT access to user1
GRANT SELECT ON Contractors TO 'user1'@'localhost';

-- 11. Revoke access
REVOKE SELECT ON Contractors FROM 'user1'@'localhost';

-- 12. Transaction to update multiple contractor ratings
START TRANSACTION;
UPDATE Contractors SET Rating = Rating + 0.2 WHERE ContractorID IN (1,3);
UPDATE Contractors SET Rating = Rating - 0.1 WHERE ContractorID IN (5,7);
COMMIT;

-- 13. Transaction rollback example
START TRANSACTION;
UPDATE Contractors SET Rating = Rating + 0.5 WHERE ContractorID = 2;
ROLLBACK;

-- 14. Savepoint example
START TRANSACTION;
UPDATE Contractors SET ExperienceYears = ExperienceYears + 1 WHERE ContractorID = 4;
SAVEPOINT sp1;
UPDATE Contractors SET ExperienceYears = ExperienceYears + 2 WHERE ContractorID = 6;
ROLLBACK TO sp1;
COMMIT;

-- 15. Create audit table for Contractors
CREATE TABLE ContractorAudit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    ContractorID INT,
    Action VARCHAR(50),
    ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 16. Trigger after insert
CREATE TRIGGER after_contractor_insert
AFTER INSERT ON Contractors
FOR EACH ROW
INSERT INTO ContractorAudit(ContractorID, Action)
VALUES (NEW.ContractorID, 'INSERT');

-- 17. Trigger after delete
CREATE TRIGGER after_contractor_delete
AFTER DELETE ON Contractors
FOR EACH ROW
INSERT INTO ContractorAudit(ContractorID, Action)
VALUES (OLD.ContractorID, 'DELETE');

-- 18. Trigger before update to prevent invalid rating
DELIMITER //
CREATE TRIGGER before_rating_update
BEFORE UPDATE ON Contractors
FOR EACH ROW
BEGIN
    IF NEW.Rating < 0 OR NEW.Rating > 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Rating must be between 0 and 5';
    END IF;
END;
//
DELIMITER ;

-- 19. Select contractors with experience > 10 years
SELECT * FROM Contractors WHERE ExperienceYears > 10;

-- 20. Count contractors by specialization
SELECT Specialization, COUNT(*) AS TotalContractors
FROM Contractors
GROUP BY Specialization;
 
-- 4. Clients

-- 1. View of all clients registered in 2024
CREATE VIEW Clients2024 AS
SELECT ClientID, FullName, Email, City, State, RegistrationDate
FROM Clients
WHERE YEAR(RegistrationDate) = 2024;

-- 2. View showing count of clients by city
CREATE VIEW ClientsByCity AS
SELECT City, COUNT(*) AS TotalClients
FROM Clients
GROUP BY City;

-- 3. Procedure to display all client names
DELIMITER //
CREATE PROCEDURE ShowClientNames()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cname VARCHAR(100);
    DECLARE client_cursor CURSOR FOR SELECT FullName FROM Clients;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN client_cursor;
    read_loop: LOOP
        FETCH client_cursor INTO cname;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT cname;
    END LOOP;
    CLOSE client_cursor;
END;
//
DELIMITER ;

-- 4. Procedure to update preferred type for a given city
DELIMITER //
CREATE PROCEDURE UpdatePreferredType(IN c_city VARCHAR(50), IN newType VARCHAR(50))
BEGIN
    UPDATE Clients
    SET PreferredType = newType
    WHERE City = c_city;
END;
//
DELIMITER ;

-- 5. Rank clients by registration date
SELECT ClientID, FullName, RegistrationDate,
       RANK() OVER (ORDER BY RegistrationDate ASC) AS RegRank
FROM Clients;

-- 6. Dense rank clients by city
SELECT ClientID, FullName, City,
       DENSE_RANK() OVER (PARTITION BY City ORDER BY RegistrationDate) AS CityRank
FROM Clients;

-- 7. Compare each client's registration date with previous one
SELECT ClientID, FullName, RegistrationDate,
       LAG(RegistrationDate,1) OVER (ORDER BY RegistrationDate) AS PrevRegDate
FROM Clients;

-- 8. Compare each client's registration date with next one
SELECT ClientID, FullName, RegistrationDate,
       LEAD(RegistrationDate,1) OVER (ORDER BY RegistrationDate) AS NextRegDate
FROM Clients;

-- 9. Divide clients into 4 groups based on RegistrationDate
SELECT ClientID, FullName, RegistrationDate,
       NTILE(4) OVER (ORDER BY RegistrationDate) AS RegGroup
FROM Clients;

-- 10. Grant SELECT access on Clients
GRANT SELECT ON Clients TO 'user1'@'localhost';

-- 11. Revoke access
REVOKE SELECT ON Clients FROM 'user1'@'localhost';

-- 12. Transaction to update multiple client preferred types
START TRANSACTION;
UPDATE Clients SET PreferredType='Commercial' WHERE ClientID IN (2,8);
UPDATE Clients SET PreferredType='Residential' WHERE ClientID IN (1,3);
COMMIT;

-- 13. Transaction rollback example
START TRANSACTION;
UPDATE Clients SET PreferredType='Mixed-Use' WHERE ClientID = 5;
ROLLBACK;

-- 14. Savepoint example
START TRANSACTION;
UPDATE Clients SET City='New Delhi' WHERE ClientID = 16;
SAVEPOINT sp1;
UPDATE Clients SET City='Delhi' WHERE ClientID = 19;
ROLLBACK TO sp1;
COMMIT;

-- 15. Create audit table for Clients
CREATE TABLE ClientAudit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    ClientID INT,
    Action VARCHAR(50),
    ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 16. Trigger after insert
CREATE TRIGGER after_client_insert
AFTER INSERT ON Clients
FOR EACH ROW
INSERT INTO ClientAudit(ClientID, Action)
VALUES (NEW.ClientID, 'INSERT');

-- 17. Trigger after delete
CREATE TRIGGER after_client_delete
AFTER DELETE ON Clients
FOR EACH ROW
INSERT INTO ClientAudit(ClientID, Action)
VALUES (OLD.ClientID, 'DELETE');

-- 18. Trigger before update to prevent empty email
DELIMITER //
CREATE TRIGGER before_client_update
BEFORE UPDATE ON Clients
FOR EACH ROW
BEGIN
    IF NEW.Email IS NULL OR NEW.Email = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email cannot be empty';
    END IF;
END;
//
DELIMITER ;

-- 19. Select clients from Maharashtra
SELECT * FROM Clients WHERE State='Maharashtra';

-- 20. Count clients by preferred type
SELECT PreferredType, COUNT(*) AS TotalClients
FROM Clients
GROUP BY PreferredType;

-- 5.Agents 

-- 1. View of all active agents
CREATE VIEW ActiveAgents AS
SELECT AgentID, Name, Email, Phone, Specialization, Rating
FROM Agents
WHERE Status = 'Active';

-- 2. View showing average rating by specialization
CREATE VIEW AvgRatingBySpecialization AS
SELECT Specialization, AVG(Rating) AS AvgRating
FROM Agents
GROUP BY Specialization;

-- 3. Procedure to display all agent names
DELIMITER //
CREATE PROCEDURE ShowAgentNames()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE aname VARCHAR(100);
    DECLARE agent_cursor CURSOR FOR SELECT Name FROM Agents;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN agent_cursor;
    read_loop: LOOP
        FETCH agent_cursor INTO aname;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT aname;
    END LOOP;
    CLOSE agent_cursor;
END;
//
DELIMITER ;

-- 4. Procedure to increase commission for agents of a specialization
DELIMITER //
CREATE PROCEDURE IncreaseCommission(IN spec VARCHAR(100), IN inc DECIMAL(5,2))
BEGIN
    UPDATE Agents
    SET CommissionRate = CommissionRate + inc
    WHERE Specialization = spec;
END;
//
DELIMITER ;

-- 5. Rank agents by rating
SELECT AgentID, Name, Rating,
       RANK() OVER (ORDER BY Rating DESC) AS RatingRank
FROM Agents;

-- 6. Dense rank agents by experience years within specialization
SELECT AgentID, Name, Specialization, ExperienceYears,
       DENSE_RANK() OVER (PARTITION BY Specialization ORDER BY ExperienceYears DESC) AS ExpRank
FROM Agents;

-- 7. Compare each agent’s rating with previous agent
SELECT AgentID, Name, Rating,
       LAG(Rating,1) OVER (ORDER BY Rating DESC) AS PrevRating
FROM Agents;

-- 8. Compare each agent’s rating with next agent
SELECT AgentID, Name, Rating,
       LEAD(Rating,1) OVER (ORDER BY Rating DESC) AS NextRating
FROM Agents;

-- 9. Divide agents into 4 groups by rating
SELECT AgentID, Name, Rating,
       NTILE(4) OVER (ORDER BY Rating DESC) AS RatingGroup
FROM Agents;

-- 10. Grant SELECT access on Agents
GRANT SELECT ON Agents TO 'user1'@'localhost';

-- 11. Revoke access
REVOKE SELECT ON Agents FROM 'user1'@'localhost';

-- 12. Transaction to increase commission for multiple agents
START TRANSACTION;
UPDATE Agents SET CommissionRate = CommissionRate + 0.50 WHERE AgentID IN (1,3,6);
UPDATE Agents SET CommissionRate = CommissionRate + 0.75 WHERE AgentID IN (2,4,8);
COMMIT;

-- 13. Transaction rollback example
START TRANSACTION;
UPDATE Agents SET Rating = Rating + 0.5 WHERE AgentID = 5;
ROLLBACK;

-- 14. Savepoint example
START TRANSACTION;
UPDATE Agents SET Status='Inactive' WHERE AgentID=10;
SAVEPOINT sp1;
UPDATE Agents SET Status='Inactive' WHERE AgentID=12;
ROLLBACK TO sp1;
COMMIT;

-- 15. Create audit table for Agents
CREATE TABLE AgentAudit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    AgentID INT,
    Action VARCHAR(50),
    ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 16. Trigger after insert
CREATE TRIGGER after_agent_insert
AFTER INSERT ON Agents
FOR EACH ROW
INSERT INTO AgentAudit(AgentID, Action)
VALUES (NEW.AgentID, 'INSERT');

-- 17. Trigger after delete
CREATE TRIGGER after_agent_delete
AFTER DELETE ON Agents
FOR EACH ROW
INSERT INTO AgentAudit(AgentID, Action)
VALUES (OLD.AgentID, 'DELETE');

-- 18. Trigger before update to prevent negative commission
DELIMITER //
CREATE TRIGGER before_commission_update
BEFORE UPDATE ON Agents
FOR EACH ROW
BEGIN
    IF NEW.CommissionRate < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Commission cannot be negative';
    END IF;
END;
//
DELIMITER ;

-- 19. Select agents with rating above 4.5
SELECT * FROM Agents WHERE Rating > 4.5;

-- 20. Count agents by specialization
SELECT Specialization, COUNT(*) AS TotalAgents
FROM Agents
GROUP BY Specialization;

-- 6.PropertyListings

-- 1. View of all available properties
CREATE VIEW AvailableProperties AS
SELECT PropertyID, Title, Type, Area, Price, Status
FROM PropertyListings
WHERE Status = 'Available';

-- 2. View showing average price by property type
CREATE VIEW AvgPriceByType AS
SELECT Type, AVG(Price) AS AvgPrice
FROM PropertyListings
GROUP BY Type;

-- 3. Procedure to display all property titles
DELIMITER //
CREATE PROCEDURE ShowPropertyTitles()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE ptitle VARCHAR(100);
    DECLARE prop_cursor CURSOR FOR SELECT Title FROM PropertyListings;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN prop_cursor;
    read_loop: LOOP
        FETCH prop_cursor INTO ptitle;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT ptitle;
    END LOOP;
    CLOSE prop_cursor;
END;
//
DELIMITER ;

-- 4. Procedure to increase price of properties by type
DELIMITER //
CREATE PROCEDURE IncreasePriceByType(IN ptype VARCHAR(50), IN inc DECIMAL(12,2))
BEGIN
    UPDATE PropertyListings
    SET Price = Price + inc
    WHERE Type = ptype;
END;
//
DELIMITER ;

-- 5. Rank properties by price
SELECT PropertyID, Title, Price,
       RANK() OVER (ORDER BY Price DESC) AS PriceRank
FROM PropertyListings;

-- 6. Dense rank properties by area within type
SELECT PropertyID, Title, Type, Area,
       DENSE_RANK() OVER (PARTITION BY Type ORDER BY Area DESC) AS AreaRank
FROM PropertyListings;

-- 7. Compare each property’s price with previous property
SELECT PropertyID, Title, Price,
       LAG(Price,1) OVER (ORDER BY Price DESC) AS PrevPrice
FROM PropertyListings;

-- 8. Compare each property’s price with next property
SELECT PropertyID, Title, Price,
       LEAD(Price,1) OVER (ORDER BY Price DESC) AS NextPrice
FROM PropertyListings;

-- 9. Divide properties into 4 price groups
SELECT PropertyID, Title, Price,
       NTILE(4) OVER (ORDER BY Price DESC) AS PriceGroup
FROM PropertyListings;

-- 10. Grant SELECT and UPDATE access on PropertyListings
GRANT SELECT, UPDATE ON PropertyListings TO 'user1'@'localhost';

-- 11. Revoke UPDATE access
REVOKE UPDATE ON PropertyListings FROM 'user1'@'localhost';

-- 12. Transaction to adjust prices for multiple properties
START TRANSACTION;
UPDATE PropertyListings SET Price = Price + 50000 WHERE PropertyID IN (1,3,6);
UPDATE PropertyListings SET Price = Price + 75000 WHERE PropertyID IN (2,4,7);
COMMIT;

-- 13. Transaction rollback example
START TRANSACTION;
UPDATE PropertyListings SET Price = Price - 100000 WHERE PropertyID = 5;
ROLLBACK;

-- 14. Savepoint example
START TRANSACTION;
UPDATE PropertyListings SET Status='Sold' WHERE PropertyID=10;
SAVEPOINT sp1;
UPDATE PropertyListings SET Status='Sold' WHERE PropertyID=12;
ROLLBACK TO sp1;
COMMIT;

-- 15. Create audit table for PropertyListings
CREATE TABLE PropertyAudit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT,
    Action VARCHAR(50),
    ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 16. Trigger after insert
CREATE TRIGGER after_property_insert
AFTER INSERT ON PropertyListings
FOR EACH ROW
INSERT INTO PropertyAudit(PropertyID, Action)
VALUES (NEW.PropertyID, 'INSERT');

-- 17. Trigger after delete
CREATE TRIGGER after_property_delete
AFTER DELETE ON PropertyListings
FOR EACH ROW
INSERT INTO PropertyAudit(PropertyID, Action)
VALUES (OLD.PropertyID, 'DELETE');

-- 18. Trigger before update to prevent negative price
DELIMITER //
CREATE TRIGGER before_price_update
BEFORE UPDATE ON PropertyListings
FOR EACH ROW
BEGIN
    IF NEW.Price < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Price cannot be negative';
    END IF;
END;
//
DELIMITER ;

-- 19. Select properties with area greater than 1000 sq.ft
SELECT * FROM PropertyListings WHERE Area > 1000;

-- 20. Count properties by status
SELECT Status, COUNT(*) AS TotalProperties
FROM PropertyListings
GROUP BY Status;

-- 7.Sales

-- 1. Create a simple view of completed sales
CREATE VIEW CompletedSales AS
SELECT SaleID, PropertyID, ClientID, FinalPrice, SaleDate
FROM Sales
WHERE Status='Completed';

-- 2. Total sales per agent using window function
SELECT AgentID, SUM(FinalPrice) AS TotalSales,
       RANK() OVER (ORDER BY SUM(FinalPrice) DESC) AS SalesRank
FROM Sales
GROUP BY AgentID;

-- 3. Stored procedure to fetch sale by SaleID
DELIMITER //
CREATE PROCEDURE GetSale(IN sID INT)
BEGIN
    SELECT * FROM Sales WHERE SaleID = sID;
END //
DELIMITER ;

-- 4. Cursor example: List pending sales
DELIMITER //
CREATE PROCEDURE ListPendingSales()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE sID INT;
    DECLARE cur CURSOR FOR SELECT SaleID FROM Sales WHERE Status='Pending';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO sID;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT * FROM Sales WHERE SaleID = sID;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

-- 5. Trigger: Auto-update Status to 'Completed' if AgreementSigned is TRUE
DELIMITER //
CREATE TRIGGER trg_UpdateStatus
BEFORE UPDATE ON Sales
FOR EACH ROW
BEGIN
    IF NEW.AgreementSigned = TRUE THEN
        SET NEW.Status = 'Completed';
    END IF;
END //
DELIMITER ;

-- 6. Grant SELECT on Sales to user 'agent_user'
GRANT SELECT ON Sales TO 'agent_user'@'localhost';

-- 7. Revoke DELETE permission from 'agent_user'
REVOKE DELETE ON Sales FROM 'agent_user'@'localhost';

-- 8. Transaction: Insert sale with rollback example
START TRANSACTION;
INSERT INTO Sales(SaleID, PropertyID, ClientID, AgentID, SaleDate, FinalPrice, Status)
VALUES (21, 21, 21, 1, '2025-07-01', 8500000, 'Pending');
ROLLBACK;

-- 9. Count total sales per month
SELECT MONTH(SaleDate) AS SaleMonth, COUNT(*) AS TotalSales
FROM Sales
GROUP BY SaleMonth;

-- 10. Update a sale amount safely
UPDATE Sales SET FinalPrice = FinalPrice * 1.05 WHERE SaleID = 1;

-- 11. Delete cancelled sales
DELETE FROM Sales WHERE Status='Cancelled';

-- 12. View for high-value sales
CREATE VIEW HighValueSales AS
SELECT SaleID, FinalPrice FROM Sales WHERE FinalPrice > 9000000;

-- 13. Select sales with payment mode 'Online'
SELECT * FROM Sales WHERE PaymentMode='Online';

-- 14. Count completed vs pending
SELECT Status, COUNT(*) AS CountStatus FROM Sales GROUP BY Status;

-- 15. Max sale per agent
SELECT AgentID, MAX(FinalPrice) AS MaxSale FROM Sales GROUP BY AgentID;

-- 16. Trigger: Log each delete in Sales
DELIMITER //
CREATE TRIGGER trg_SalesDeleteLog
AFTER DELETE ON Sales
FOR EACH ROW
BEGIN
    INSERT INTO SalesLog(SaleID, DeletedDate) VALUES (OLD.SaleID, NOW());
END //
DELIMITER ;

-- 17. Rollback example with multiple inserts
START TRANSACTION;
INSERT INTO Sales(SaleID, PropertyID, ClientID, AgentID, SaleDate, FinalPrice, Status)
VALUES (22, 22, 22, 2, '2025-07-02', 9500000, 'Pending');
INSERT INTO Sales(SaleID, PropertyID, ClientID, AgentID, SaleDate, FinalPrice, Status)
VALUES (23, 23, 23, 3, '2025-07-03', 10500000, 'Pending');
ROLLBACK;

-- 18. Select top 5 sales
SELECT * FROM Sales ORDER BY FinalPrice DESC LIMIT 5;

-- 19. Update remarks for completed sales
UPDATE Sales SET Remarks='Checked by manager' WHERE Status='Completed';

-- 20. Transaction: Update and commit
START TRANSACTION;
UPDATE Sales SET Status='Pending' WHERE SaleID=2;
COMMIT;

-- 8.Leads

-- 1. View: High priority leads
CREATE VIEW HighPriorityLeads AS
SELECT LeadID, ClientID, Status, Priority FROM Leads WHERE Priority='High';

-- 2. Count leads by source
SELECT Source, COUNT(*) AS TotalLeads FROM Leads GROUP BY Source;

-- 3. Stored procedure: Fetch lead by ID
DELIMITER //
CREATE PROCEDURE GetLead(IN lID INT)
BEGIN
    SELECT * FROM Leads WHERE LeadID=lID;
END //
DELIMITER ;

-- 4. Cursor: List new leads
DELIMITER //
CREATE PROCEDURE ListNewLeads()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE lID INT;
    DECLARE cur CURSOR FOR SELECT LeadID FROM Leads WHERE Status='New';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;
    
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO lID;
        IF done THEN LEAVE read_loop; END IF;
        SELECT * FROM Leads WHERE LeadID=lID;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

-- 5. Trigger: Set status to 'Followed Up' on update
DELIMITER //
CREATE TRIGGER trg_LeadsUpdate
BEFORE UPDATE ON Leads
FOR EACH ROW
BEGIN
    IF NEW.FollowUpDate IS NOT NULL THEN
        SET NEW.Status='Followed Up';
    END IF;
END //
DELIMITER ;

-- 6. Transaction: Insert multiple leads
START TRANSACTION;
INSERT INTO Leads(LeadID, ClientID, PropertyID, Source, Status, AssignedAgentID, InquiryDate)
VALUES (21, 21, 21, 'Website', 'New', 1, '2025-07-01');
ROLLBACK;

-- 7. Grant SELECT on Leads to user
GRANT SELECT ON Leads TO 'agent_user'@'localhost';

-- 8. Revoke UPDATE permission from user
REVOKE UPDATE ON Leads FROM 'agent_user'@'localhost';

-- 9. Select leads assigned to agent 5
SELECT * FROM Leads WHERE AssignedAgentID=5;

-- 10. Count leads by status
SELECT Status, COUNT(*) AS Total FROM Leads GROUP BY Status;

-- 11. Window function: rank leads by InquiryDate
SELECT LeadID, ClientID, InquiryDate,
       RANK() OVER (ORDER BY InquiryDate ASC) AS RankByDate
FROM Leads;

-- 12. Delete old leads before 2024
DELETE FROM Leads WHERE InquiryDate < '2024-01-01';

-- 13. Update priority for specific client
UPDATE Leads SET Priority='High' WHERE ClientID=3;

-- 14. Trigger: Log new lead insert
DELIMITER //
CREATE TRIGGER trg_LeadsInsert
AFTER INSERT ON Leads
FOR EACH ROW
BEGIN
    INSERT INTO LeadsLog(LeadID, ActionDate, ActionType)
    VALUES (NEW.LeadID, NOW(), 'Inserted');
END //
DELIMITER ;

-- 15. Select leads needing follow-up
SELECT * FROM Leads WHERE Status='Followed Up' AND FollowUpDate < CURDATE();

-- 16. View: Leads by source
CREATE VIEW LeadsBySource AS
SELECT Source, COUNT(*) AS Total FROM Leads GROUP BY Source;

-- 17. Transaction: Update status safely
START TRANSACTION;
UPDATE Leads SET Status='Contacted' WHERE LeadID=2;
COMMIT;

-- 18. Stored procedure: Update assigned agent
DELIMITER //
CREATE PROCEDURE AssignAgent(IN lID INT, IN aID INT)
BEGIN
    UPDATE Leads SET AssignedAgentID=aID WHERE LeadID=lID;
END //
DELIMITER ;

-- 19. Select top 3 newest leads
SELECT * FROM Leads ORDER BY InquiryDate DESC LIMIT 3;

-- 20. Update follow-up date
UPDATE Leads SET FollowUpDate=DATE_ADD(CURDATE(), INTERVAL 7 DAY)
WHERE Status='New';

-- 9.Employees

-- 1. View: Active employees
CREATE VIEW ActiveEmployees AS
SELECT EmployeeID, FullName, Department, Role FROM Employees WHERE Status='Active';

-- 2. Count employees per department
SELECT Department, COUNT(*) AS Total FROM Employees GROUP BY Department;

-- 3. Stored procedure: Get employee by ID
DELIMITER //
CREATE PROCEDURE GetEmployee(IN eID INT)
BEGIN
    SELECT * FROM Employees WHERE EmployeeID=eID;
END //
DELIMITER ;

-- 4. Cursor: List all managers
DELIMITER //
CREATE PROCEDURE ListManagers()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE eID INT;
    DECLARE cur CURSOR FOR SELECT EmployeeID FROM Employees WHERE Role='Manager';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO eID;
        IF done THEN LEAVE read_loop; END IF;
        SELECT * FROM Employees WHERE EmployeeID=eID;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

-- 5. Trigger: Set default status to Active on insert
DELIMITER //
CREATE TRIGGER trg_EmployeesInsert
BEFORE INSERT ON Employees
FOR EACH ROW
BEGIN
    IF NEW.Status IS NULL THEN
        SET NEW.Status='Active';
    END IF

-- 10.Vendors
-- 1. View: Active vendors
CREATE VIEW ActiveVendors AS
SELECT VendorID, VendorName, ContactPerson, City, Status
FROM Vendors
WHERE Status='Active';

-- 2. Count vendors by city
SELECT City, COUNT(*) AS TotalVendors FROM Vendors GROUP BY City;

-- 3. Stored procedure: Fetch vendor by ID
DELIMITER //
CREATE PROCEDURE GetVendor(IN vID INT)
BEGIN
    SELECT * FROM Vendors WHERE VendorID=vID;
END //
DELIMITER ;

-- 4. Cursor: List vendors with pending contracts
DELIMITER //
CREATE PROCEDURE ListPendingVendors()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE vID INT;
    DECLARE cur CURSOR FOR SELECT VendorID FROM Vendors WHERE Status='Pending';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO vID;
        IF done THEN LEAVE read_loop; END IF;
        SELECT * FROM Vendors WHERE VendorID=vID;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

-- 5. Trigger: Update status to 'Approved' if contract signed
DELIMITER //
CREATE TRIGGER trg_VendorContract
BEFORE UPDATE ON Vendors
FOR EACH ROW
BEGIN
    IF NEW.ContractSigned=TRUE THEN
        SET NEW.Status='Approved';
    END IF;
END //
DELIMITER ;

-- 6. Grant SELECT on Vendors to procurement user
GRANT SELECT ON Vendors TO 'procurement_user'@'localhost';

-- 7. Revoke DELETE permission
REVOKE DELETE ON Vendors FROM 'procurement_user'@'localhost';

-- 8. Transaction: Insert vendor with rollback
START TRANSACTION;
INSERT INTO Vendors(VendorID, VendorName, ContactPerson, City, Phone, Email, Status, ContractSigned)
VALUES (21, 'GreenBuild Ltd', 'Ramesh Kumar', 'Mumbai', '9876543210', 'ramesh@greenbuild.com', 'Pending', FALSE);
ROLLBACK;

-- 9. Select vendors with email domain 'gmail.com'
SELECT * FROM Vendors WHERE Email LIKE '%@gmail.com';

-- 10. Count vendors by status
SELECT Status, COUNT(*) AS Total FROM Vendors GROUP BY Status;

-- 11. Window function: Rank vendors by number of materials supplied
SELECT VendorID, VendorName, COUNT(MaterialID) AS TotalMaterials,
       RANK() OVER (ORDER BY COUNT(MaterialID) DESC) AS RankBySupply
FROM Materials
GROUP BY VendorID;

-- 12. Delete inactive vendors
DELETE FROM Vendors WHERE Status='Inactive';

-- 13. Update contact person for vendor
UPDATE Vendors SET ContactPerson='Anil Sharma' WHERE VendorID=3;

-- 14. View: Vendors in Mumbai
CREATE VIEW MumbaiVendors AS
SELECT VendorID, VendorName, ContactPerson FROM Vendors WHERE City='Mumbai';

-- 15. Transaction: Update vendor and commit
START TRANSACTION;
UPDATE Vendors SET Status='Active' WHERE VendorID=2;
COMMIT;

-- 16. Trigger: Log vendor insert
DELIMITER //
CREATE TRIGGER trg_VendorInsert
AFTER INSERT ON Vendors
FOR EACH ROW
BEGIN
    INSERT INTO VendorLog(VendorID, ActionType, ActionDate)
    VALUES (NEW.VendorID, 'Inserted', NOW());
END //
DELIMITER ;

-- 17. Select vendors without contract signed
SELECT * FROM Vendors WHERE ContractSigned=FALSE;

-- 18. Stored procedure: Update vendor city
DELIMITER //
CREATE PROCEDURE UpdateVendorCity(IN vID INT, IN vCity VARCHAR(50))
BEGIN
    UPDATE Vendors SET City=vCity WHERE VendorID=vID;
END //
DELIMITER ;

-- 19. Select top 5 vendors with max materials supplied
SELECT VendorID, VendorName, COUNT(MaterialID) AS TotalSupplied
FROM Materials
GROUP BY VendorID
ORDER BY TotalSupplied DESC
LIMIT 5;

-- 20. Update vendor phone
UPDATE Vendors SET Phone='9123456780' WHERE VendorID=5;

-- 11.Materials 
-- 1. View: Materials with quantity < 50
CREATE VIEW LowStockMaterials AS
SELECT MaterialID, MaterialName, VendorID, Quantity FROM Materials WHERE Quantity<50;

-- 2. Count materials by category
SELECT Category, COUNT(*) AS TotalMaterials FROM Materials GROUP BY Category;

-- 3. Stored procedure: Fetch material by ID
DELIMITER //
CREATE PROCEDURE GetMaterial(IN mID INT)
BEGIN
    SELECT * FROM Materials WHERE MaterialID=mID;
END //
DELIMITER ;

-- 4. Cursor: List all materials low in stock
DELIMITER //
CREATE PROCEDURE ListLowStock()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE mID INT;
    DECLARE cur CURSOR FOR SELECT MaterialID FROM Materials WHERE Quantity<20;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO mID;
        IF done THEN LEAVE read_loop; END IF;
        SELECT * FROM Materials WHERE MaterialID=mID;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

-- 5. Trigger: Auto-update status to 'Reorder' if quantity < 20
DELIMITER //
CREATE TRIGGER trg_MaterialReorder
BEFORE UPDATE ON Materials
FOR EACH ROW
BEGIN
    IF NEW.Quantity<20 THEN
        SET NEW.Status='Reorder';
    END IF;
END //
DELIMITER ;

-- 6. Grant SELECT on Materials
GRANT SELECT ON Materials TO 'procurement_user'@'localhost';

-- 7. Revoke UPDATE permission
REVOKE UPDATE ON Materials FROM 'procurement_user'@'localhost';

-- 8. Transaction: Insert new material with rollback
START TRANSACTION;
INSERT INTO Materials(MaterialID, MaterialName, VendorID, Category, Quantity, PricePerUnit, Status)
VALUES (21, 'Cement Bag', 3, 'Construction', 100, 350, 'Available');
ROLLBACK;

-- 9. Select materials by vendor 2
SELECT * FROM Materials WHERE VendorID=2;

-- 10. Count materials by status
SELECT Status, COUNT(*) AS Total FROM Materials GROUP BY Status;

-- 11. Window function: Rank materials by quantity
SELECT MaterialID, MaterialName, Quantity,
       RANK() OVER (ORDER BY Quantity ASC) AS StockRank
FROM Materials;

-- 12. Delete discontinued materials
DELETE FROM Materials WHERE Status='Discontinued';

-- 13. Update material price
UPDATE Materials SET PricePerUnit=360 WHERE MaterialID=5;

-- 14. View: Materials in category 'Electrical'
CREATE VIEW ElectricalMaterials AS
SELECT MaterialID, MaterialName, Quantity FROM Materials WHERE Category='Electrical';

-- 15. Transaction: Update quantity safely
START TRANSACTION;
UPDATE Materials SET Quantity=Quantity+50 WHERE MaterialID=2;
COMMIT;

-- 16. Trigger: Log material insert
DELIMITER //
CREATE TRIGGER trg_MaterialInsert
AFTER INSERT ON Materials
FOR EACH ROW
BEGIN
    INSERT INTO MaterialLog(MaterialID, ActionType, ActionDate)
    VALUES (NEW.MaterialID, 'Inserted', NOW());
END //
DELIMITER ;

-- 17. Select materials with quantity between 50 and 100
SELECT * FROM Materials WHERE Quantity BETWEEN 50 AND 100;

-- 18. Stored procedure: Update material status
DELIMITER //
CREATE PROCEDURE UpdateMaterialStatus(IN mID INT, IN mStatus VARCHAR(20))
BEGIN
    UPDATE Materials SET Status=mStatus WHERE MaterialID=mID;
END //
DELIMITER ;

-- 19. Top 5 expensive materials
SELECT * FROM Materials ORDER BY PricePerUnit DESC LIMIT 5;

-- 20. Update category for a material
UPDATE Materials SET Category='Hardware' WHERE MaterialID=8;

-- 12.PurchaseOrders
-- 1. View: Pending purchase orders
CREATE VIEW PendingPO AS
SELECT PurchaseOrderID, VendorID, OrderDate, Status, TotalAmount
FROM PurchaseOrders
WHERE Status='Pending';

-- 2. Count POs by vendor
SELECT VendorID, COUNT(*) AS TotalPO FROM PurchaseOrders GROUP BY VendorID;

-- 3. Stored procedure: Fetch PO by ID
DELIMITER //
CREATE PROCEDURE GetPO(IN poID INT)
BEGIN
    SELECT * FROM PurchaseOrders WHERE PurchaseOrderID=poID;
END //
DELIMITER ;

-- 4. Cursor: List overdue POs
DELIMITER //
CREATE PROCEDURE ListOverduePO()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE poID INT;
    DECLARE cur CURSOR FOR SELECT PurchaseOrderID FROM PurchaseOrders WHERE DueDate<CURDATE() AND Status<>'Completed';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO poID;
        IF done THEN LEAVE read_loop; END IF;
        SELECT * FROM PurchaseOrders WHERE PurchaseOrderID=poID;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

-- 5. Trigger: Update status to 'Completed' on full payment
DELIMITER //
CREATE TRIGGER trg_POStatus
BEFORE UPDATE ON PurchaseOrders
FOR EACH ROW
BEGIN
    IF NEW.AmountPaid>=NEW.TotalAmount THEN
        SET NEW.Status='Completed';
    END IF;
END //
DELIMITER ;

-- 6. Grant SELECT on PurchaseOrders
GRANT SELECT ON PurchaseOrders TO 'procurement_user'@'localhost';

-- 7. Revoke DELETE permission
REVOKE DELETE ON PurchaseOrders FROM 'procurement_user'@'localhost';

-- 8. Transaction: Insert PO with rollback
START TRANSACTION;
INSERT INTO PurchaseOrders(PurchaseOrderID, VendorID, OrderDate, DueDate, TotalAmount, AmountPaid, Status)
VALUES (21, 2, '2025-08-01', '2025-08-15', 500000, 0, 'Pending');
ROLLBACK;

-- 9. Select POs with pending payment
SELECT * FROM PurchaseOrders WHERE AmountPaid<TotalAmount;

-- 10. Count POs by status
SELECT Status, COUNT(*) AS Total FROM PurchaseOrders GROUP BY Status;

-- 11. Window function: Rank POs by total amount
SELECT PurchaseOrderID, VendorID, TotalAmount,
       RANK() OVER (ORDER BY TotalAmount DESC) AS AmountRank
FROM PurchaseOrders;

-- 12. Delete canceled POs
DELETE FROM PurchaseOrders WHERE Status='Cancelled';

-- 13. Update due date for PO
UPDATE PurchaseOrders SET DueDate='2025-08-20' WHERE PurchaseOrderID=3;

-- 14. View: Large POs above 1,00,000
CREATE VIEW LargePO AS
SELECT * FROM PurchaseOrders WHERE TotalAmount>100000;

-- 15. Transaction: Update amount paid
START TRANSACTION;
UPDATE PurchaseOrders SET AmountPaid=AmountPaid+50000 WHERE PurchaseOrderID=2;
COMMIT;

-- 16. Trigger: Log PO insert
DELIMITER //
CREATE TRIGGER trg_POInsert
AFTER INSERT ON PurchaseOrders
FOR EACH ROW
BEGIN
    INSERT INTO POLog(PurchaseOrderID, ActionType, ActionDate)
    VALUES (NEW.PurchaseOrderID, 'Inserted', NOW());
END //
DELIMITER ;

-- 17. Select POs due this month
SELECT * FROM PurchaseOrders WHERE MONTH(DueDate)=MONTH(CURDATE());

-- 18. Stored procedure: Update PO status
DELIMITER //
CREATE PROCEDURE UpdatePOStatus(IN poID INT, IN poStatus VARCHAR(20))
BEGIN
    UPDATE PurchaseOrders SET Status=poStatus WHERE PurchaseOrderID=poID;
END //
DELIMITER ;

-- 19. Top 5 vendors by PO amount
SELECT VendorID, SUM(TotalAmount) AS TotalPOAmount
FROM PurchaseOrders
GROUP BY VendorID
ORDER BY TotalPOAmount DESC
LIMIT 5;

-- 20. Update total amount for a PO
UPDATE PurchaseOrders SET TotalAmount=550000 WHERE PurchaseOrderID=5;

-- 13. Payments

-- 1. View: Pending payments
CREATE VIEW PendingPayments AS
SELECT PaymentID, BillID, PaymentDate, AmountPaid, Status
FROM Payments
WHERE Status='Pending';

-- 2. Count payments by mode
SELECT Mode, COUNT(*) AS TotalPayments FROM Payments GROUP BY Mode;

-- 3. Stored procedure: Fetch payment by ID
DELIMITER //
CREATE PROCEDURE GetPayment(IN pID INT)
BEGIN
    SELECT * FROM Payments WHERE PaymentID=pID;
END //
DELIMITER ;

-- 4. Cursor: List payments above 5000
DELIMITER //
CREATE PROCEDURE ListHighPayments()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE payID INT;
    DECLARE cur CURSOR FOR SELECT PaymentID FROM Payments WHERE AmountPaid>5000;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO payID;
        IF done THEN LEAVE read_loop; END IF;
        SELECT * FROM Payments WHERE PaymentID=payID;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

-- 5. Trigger: Update status to 'Completed' if full amount paid
DELIMITER //
CREATE TRIGGER trg_PaymentStatus
BEFORE INSERT ON Payments
FOR EACH ROW
BEGIN
    DECLARE BillAmt DECIMAL(12,2);
    SELECT Amount INTO BillAmt FROM Bill WHERE BillID=NEW.BillID;
    IF NEW.AmountPaid>=BillAmt THEN
        SET NEW.Status='Completed';
    END IF;
END //
DELIMITER ;

-- 6. Grant SELECT on Payments
GRANT SELECT ON Payments TO 'account_user'@'localhost';

-- 7. Revoke DELETE permission
REVOKE DELETE ON Payments FROM 'account_user'@'localhost';

-- 8. Transaction: Insert payment with rollback
START TRANSACTION;
INSERT INTO Payments(PaymentID, BillID, PaymentDate, AmountPaid, Mode, Status)
VALUES (21, 3, '2025-08-10', 10000, 'Online', 'Pending');
ROLLBACK;

-- 9. Select payments for a specific month
SELECT * FROM Payments WHERE MONTH(PaymentDate)=8;

-- 10. Count payments by status
SELECT Status, COUNT(*) AS Total FROM Payments GROUP BY Status;

-- 11. Window function: Rank payments by amount
SELECT PaymentID, AmountPaid,
       RANK() OVER (ORDER BY AmountPaid DESC) AS RankByAmount
FROM Payments;

-- 12. Delete failed payments
DELETE FROM Payments WHERE Status='Failed';

-- 13. Update payment mode
UPDATE Payments SET Mode='Cheque' WHERE PaymentID=5;

-- 14. View: Online payments
CREATE VIEW OnlinePayments AS
SELECT * FROM Payments WHERE Mode='Online';

-- 15. Transaction: Update status after confirmation
START TRANSACTION;
UPDATE Payments SET Status='Completed' WHERE PaymentID=2;
COMMIT;

-- 16. Trigger: Log payment insert
DELIMITER //
CREATE TRIGGER trg_PaymentInsert
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    INSERT INTO PaymentLog(PaymentID, ActionType, ActionDate)
    VALUES (NEW.PaymentID, 'Inserted', NOW());
END //
DELIMITER ;

-- 17. Select payments greater than average
SELECT * FROM Payments WHERE AmountPaid > (SELECT AVG(AmountPaid) FROM Payments);

-- 18. Stored procedure: Update payment status
DELIMITER //
CREATE PROCEDURE UpdatePaymentStatus(IN pID INT, IN pStatus VARCHAR(20))
BEGIN
    UPDATE Payments SET Status=pStatus WHERE PaymentID=pID;
END //
DELIMITER ;

-- 19. Top 5 highest payments
SELECT * FROM Payments ORDER BY AmountPaid DESC LIMIT 5;

-- 20. Update amount paid for a payment
UPDATE Payments SET AmountPaid=12000 WHERE PaymentID=3;

-- 14. Inspections

-- 1. View: Pending inspections
CREATE VIEW PendingInspections AS
SELECT InspectionID, ProjectID, InspectorID, DateScheduled, Status
FROM Inspections
WHERE Status='Pending';

-- 2. Count inspections by inspector
SELECT InspectorID, COUNT(*) AS TotalInspections FROM Inspections GROUP BY InspectorID;

-- 3. Stored procedure: Fetch inspection by ID
DELIMITER //
CREATE PROCEDURE GetInspection(IN iID INT)
BEGIN
    SELECT * FROM Inspections WHERE InspectionID=iID;
END //
DELIMITER ;

-- 4. Cursor: List inspections scheduled this week
DELIMITER //
CREATE PROCEDURE ListThisWeekInspections()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE inspID INT;
    DECLARE cur CURSOR FOR SELECT InspectionID FROM Inspections WHERE WEEK(DateScheduled)=WEEK(CURDATE());
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO inspID;
        IF done THEN LEAVE read_loop; END IF;
        SELECT * FROM Inspections WHERE InspectionID=inspID;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

-- 5. Trigger: Update status to 'Completed' if all issues resolved
DELIMITER //
CREATE TRIGGER trg_InspectionStatus
BEFORE UPDATE ON Inspections
FOR EACH ROW
BEGIN
    IF NEW.IssuesResolved=TRUE THEN
        SET NEW.Status='Completed';
    END IF;
END //
DELIMITER ;

-- 6. Grant SELECT on Inspections
GRANT SELECT ON Inspections TO 'quality_user'@'localhost';

-- 7. Revoke DELETE permission
REVOKE DELETE ON Inspections FROM 'quality_user'@'localhost';

-- 8. Transaction: Insert inspection with rollback
START TRANSACTION;
INSERT INTO Inspections(InspectionID, ProjectID, InspectorID, DateScheduled, Status)
VALUES (21, 5, 3, '2025-08-25', 'Pending');
ROLLBACK;

-- 9. Select inspections for a specific project
SELECT * FROM Inspections WHERE ProjectID=2;

-- 10. Count inspections by status
SELECT Status, COUNT(*) AS Total FROM Inspections GROUP BY Status;

-- 11. Window function: Rank inspections by date
SELECT InspectionID, DateScheduled,
       RANK() OVER (ORDER BY DateScheduled ASC) AS InspectionRank
FROM Inspections;

-- 12. Delete canceled inspections
DELETE FROM Inspections WHERE Status='Cancelled';

-- 13. Update inspection date
UPDATE Inspections SET DateScheduled='2025-08-28' WHERE InspectionID=3;

-- 14. View: Completed inspections
CREATE VIEW CompletedInspections AS
SELECT * FROM Inspections WHERE Status='Completed';

-- 15. Transaction: Update status safely
START TRANSACTION;
UPDATE Inspections SET Status='Completed' WHERE InspectionID=2;
COMMIT;

-- 16. Trigger: Log inspection insert
DELIMITER //
CREATE TRIGGER trg_InspectionInsert
AFTER INSERT ON Inspections
FOR EACH ROW
BEGIN
    INSERT INTO InspectionLog(InspectionID, ActionType, ActionDate)
    VALUES (NEW.InspectionID, 'Inserted', NOW());
END //
DELIMITER ;

-- 17. Select inspections scheduled in next 7 days
SELECT * FROM Inspections WHERE DateScheduled BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY);

-- 18. Stored procedure: Update inspection status
DELIMITER //
CREATE PROCEDURE UpdateInspectionStatus(IN iID INT, IN iStatus VARCHAR(20))
BEGIN
    UPDATE Inspections SET Status=iStatus WHERE InspectionID=iID;
END //
DELIMITER ;

-- 19. Top 5 inspectors by inspections
SELECT InspectorID, COUNT(*) AS TotalInspections
FROM Inspections
GROUP BY InspectorID
ORDER BY TotalInspections DESC
LIMIT 5;

-- 20. Update issues resolved flag
UPDATE Inspections SET IssuesResolved=TRUE WHERE InspectionID=4;

-- 15.MaintenanceRequests

-- 1. View: Pending maintenance requests
CREATE VIEW PendingMaintenance AS
SELECT RequestID, ProjectID, StaffID, DateRequested, Status
FROM MaintenanceRequests
WHERE Status='Pending';

-- 2. Count requests by staff
SELECT StaffID, COUNT(*) AS TotalRequests FROM MaintenanceRequests GROUP BY StaffID;

-- 3. Stored procedure: Fetch request by ID
DELIMITER //
CREATE PROCEDURE GetMaintenanceRequest(IN rID INT)
BEGIN
    SELECT * FROM MaintenanceRequests WHERE RequestID=rID;
END //
DELIMITER ;

-- 4. Cursor: List overdue maintenance requests
DELIMITER //
CREATE PROCEDURE ListOverdueMaintenance()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE rID INT;
    DECLARE cur CURSOR FOR SELECT RequestID FROM MaintenanceRequests WHERE DueDate<CURDATE() AND Status<>'Completed';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO rID;
        IF done THEN LEAVE read_loop; END IF;
        SELECT * FROM MaintenanceRequests WHERE RequestID=rID;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

-- 5. Trigger: Update status to 'Completed' if resolved
DELIMITER //
CREATE TRIGGER trg_MaintenanceStatus
BEFORE UPDATE ON MaintenanceRequests
FOR EACH ROW
BEGIN
    IF NEW.Resolved=TRUE THEN
        SET NEW.Status='Completed';
    END IF;
END //
DELIMITER ;

-- 6. Grant SELECT on MaintenanceRequests
GRANT SELECT ON MaintenanceRequests TO 'maintenance_user'@'localhost';

-- 7. Revoke DELETE permission
REVOKE DELETE ON MaintenanceRequests FROM 'maintenance_user'@'localhost';

-- 8. Transaction: Insert request with rollback
START TRANSACTION;
INSERT INTO MaintenanceRequests(RequestID, ProjectID, StaffID, DateRequested, Status)
VALUES (21, 2, 4, '2025-08-18', 'Pending');
ROLLBACK;

-- 9. Select requests for a specific project
SELECT * FROM MaintenanceRequests WHERE ProjectID=3;

-- 10. Count requests by status
SELECT Status, COUNT(*) AS Total FROM MaintenanceRequests GROUP BY Status;

-- 11. Window function: Rank requests by date
SELECT RequestID, DateRequested,
       RANK() OVER (ORDER BY DateRequested ASC) AS RequestRank
FROM MaintenanceRequests;

-- 12. Delete canceled requests
DELETE FROM MaintenanceRequests WHERE Status='Cancelled';

-- 13. Update request date
UPDATE MaintenanceRequests SET DateRequested='2025-08-22' WHERE RequestID=3;

-- 14. View: Completed maintenance requests
CREATE VIEW CompletedMaintenance AS
SELECT * FROM MaintenanceRequests WHERE Status='Completed';

-- 15. Transaction: Update status safely
START TRANSACTION;
UPDATE MaintenanceRequests SET Status='Completed' WHERE RequestID=2;
COMMIT;

-- 16. Trigger: Log maintenance request insert
DELIMITER //
CREATE TRIGGER trg_MaintenanceInsert
AFTER INSERT ON MaintenanceRequests
FOR EACH ROW
BEGIN
    INSERT INTO MaintenanceLog(RequestID, ActionType, ActionDate)
    VALUES (NEW.RequestID, 'Inserted', NOW());
END //
DELIMITER ;

-- 17. Select requests due this week
SELECT * FROM MaintenanceRequests WHERE DueDate BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY);

-- 18. Stored procedure: Update request status
DELIMITER //
CREATE PROCEDURE UpdateMaintenanceStatus(IN rID INT, IN rStatus VARCHAR(20))
BEGIN
    UPDATE MaintenanceRequests SET Status=rStatus WHERE RequestID=rID;
END //
DELIMITER ;

-- 19. Top 5 staff by maintenance requests
SELECT StaffID, COUNT(*) AS TotalRequests
FROM MaintenanceRequests
GROUP BY StaffID
ORDER BY TotalRequests DESC
LIMIT 5;

-- 20. Update resolved flag
UPDATE MaintenanceRequests SET Resolved=TRUE WHERE RequestID=5;

-- 16.Leases
-- 1. Create a View to show Active Leases
CREATE VIEW ActiveLeases AS
SELECT LeaseID, PropertyID, ClientID, StartDate, EndDate, RentAmount, Status
FROM Leases
WHERE Status = 'Active';

-- 2. View for Leases with Deposit > 50000
CREATE VIEW HighDepositLeases AS
SELECT LeaseID, PropertyID, ClientID, DepositAmount, Status
FROM Leases
WHERE DepositAmount > 50000;

-- 3. Window Function: Rank leases by RentAmount
SELECT LeaseID, ClientID, RentAmount,
       RANK() OVER (ORDER BY RentAmount DESC) AS RentRank
FROM Leases;

-- 4. Window Function: Row number partitioned by Status
SELECT LeaseID, ClientID, Status,
       ROW_NUMBER() OVER (PARTITION BY Status ORDER BY StartDate) AS RowNum
FROM Leases;

-- 5. Stored Procedure to get lease details by ClientID
DELIMITER //
CREATE PROCEDURE GetLeaseByClient(IN p_ClientID INT)
BEGIN
    SELECT * FROM Leases WHERE ClientID = p_ClientID;
END //
DELIMITER ;

-- 6. Stored Procedure to update lease status
DELIMITER //
CREATE PROCEDURE UpdateLeaseStatus(IN p_LeaseID INT, IN p_Status VARCHAR(30))
BEGIN
    UPDATE Leases SET Status = p_Status WHERE LeaseID = p_LeaseID;
END //
DELIMITER ;

-- 7. Cursor: Display leases starting after a specific date
DELIMITER //
CREATE PROCEDURE LeasesAfterDate(IN p_Date DATE)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE lID INT;
    DECLARE lStart DATE;
    DECLARE lease_cursor CURSOR FOR 
        SELECT LeaseID, StartDate FROM Leases WHERE StartDate > p_Date;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN lease_cursor;
    read_loop: LOOP
        FETCH lease_cursor INTO lID, lStart;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT('LeaseID: ', lID, ' StartDate: ', lStart) AS LeaseInfo;
    END LOOP;
    CLOSE lease_cursor;
END //
DELIMITER ;

-- 8. Trigger: Auto-update Status to 'Expired' when EndDate < CURDATE()
DELIMITER //
CREATE TRIGGER trg_LeaseExpire
BEFORE UPDATE ON Leases
FOR EACH ROW
BEGIN
    IF NEW.EndDate IS NOT NULL AND NEW.EndDate < CURDATE() THEN
        SET NEW.Status = 'Expired';
    END IF;
END //
DELIMITER ;

-- 9. Trigger: Prevent deletion of Active leases
DELIMITER //
CREATE TRIGGER trg_PreventActiveDelete
BEFORE DELETE ON Leases
FOR EACH ROW
BEGIN
    IF OLD.Status = 'Active' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete active lease';
    END IF;
END //
DELIMITER ;

-- 10. DCL: Grant SELECT on Leases to user 'manager'
GRANT SELECT ON Leases TO 'manager'@'localhost';

-- 11. DCL: Revoke UPDATE on Leases from user 'intern'
REVOKE UPDATE ON Leases FROM 'intern'@'localhost';

-- 12. TCL: Start transaction to update rent and deposit
START TRANSACTION;
UPDATE Leases SET RentAmount = RentAmount * 1.05 WHERE Status = 'Active';
UPDATE Leases SET DepositAmount = DepositAmount * 1.05 WHERE Status = 'Active';
COMMIT;

-- 13. TCL: Rollback example
START TRANSACTION;
UPDATE Leases SET RentAmount = 999999 WHERE LeaseID = 1;
ROLLBACK;

-- 14. Select leases ending in next 30 days using DATEDIFF
SELECT * FROM Leases
WHERE EndDate IS NOT NULL AND DATEDIFF(EndDate, CURDATE()) <= 30;

-- 15. Count of leases per Status
SELECT Status, COUNT(*) AS LeaseCount
FROM Leases
GROUP BY Status;

-- 16. Max RentAmount per Status using Window Function
SELECT LeaseID, Status, RentAmount,
       MAX(RentAmount) OVER (PARTITION BY Status) AS MaxRent
FROM Leases;

-- 17. List all leases with NULL EndDate (Pending/Processing)
SELECT * FROM Leases WHERE EndDate IS NULL;

-- 18. Update Status to 'Active' for leases with AgreementSigned = TRUE
UPDATE Leases
SET Status = 'Active'
WHERE AgreementSigned = TRUE;

-- 19. Delete leases with Status = 'Expired'
DELETE FROM Leases WHERE Status = 'Expired';

-- 20. View to summarize Lease amounts per Client
CREATE VIEW LeaseSummary AS
SELECT ClientID, COUNT(*) AS TotalLeases,
       SUM(RentAmount) AS TotalRent, SUM(DepositAmount) AS TotalDeposit
FROM Leases
GROUP BY ClientID;

-- 17.LegalDocuments 

-- 1. Create a view to show verified documents
CREATE OR REPLACE VIEW VerifiedDocs AS
SELECT DocumentID, DocumentType, Status, VerifiedBy
FROM LegalDocuments
WHERE Status = 'Verified';

-- 2. View to list documents expiring within 1 year
CREATE OR REPLACE VIEW ExpiringDocs AS
SELECT DocumentID, DocumentType, ExpiryDate
FROM LegalDocuments
WHERE ExpiryDate BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 1 YEAR);

-- 3. Stored Procedure to insert new document
DELIMITER $$
CREATE PROCEDURE AddLegalDocument (
    IN pPropertyID INT,
    IN pDocType VARCHAR(50),
    IN pIssueDate DATE,
    IN pExpiryDate DATE,
    IN pFilePath VARCHAR(255),
    IN pVerifiedBy INT,
    IN pStatus VARCHAR(30),
    IN pUploadDate DATE,
    IN pRemarks TEXT
)
BEGIN
    INSERT INTO LegalDocuments(PropertyID, DocumentType, IssueDate, ExpiryDate, FilePath, VerifiedBy, Status, UploadDate, Remarks)
    VALUES (pPropertyID, pDocType, pIssueDate, pExpiryDate, pFilePath, pVerifiedBy, pStatus, pUploadDate, pRemarks);
END $$
DELIMITER ;

-- 4. Stored Procedure to update document status
DELIMITER $$
CREATE PROCEDURE UpdateDocStatus (
    IN pDocumentID INT,
    IN pStatus VARCHAR(30)
)
BEGIN
    UPDATE LegalDocuments
    SET Status = pStatus
    WHERE DocumentID = pDocumentID;
END $$
DELIMITER ;

-- 5. Cursor to display pending documents
DELIMITER $$
CREATE PROCEDURE ListPendingDocs()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE dID INT;
    DECLARE dType VARCHAR(50);
    DECLARE cur1 CURSOR FOR SELECT DocumentID, DocumentType FROM LegalDocuments WHERE Status='Pending';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur1;
    read_loop: LOOP
        FETCH cur1 INTO dID, dType;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT('Pending Document ID: ', dID, ', Type: ', dType) AS PendingDoc;
    END LOOP;
    CLOSE cur1;
END $$
DELIMITER ;

-- 6. Trigger before insert to validate ExpiryDate
DELIMITER $$
CREATE TRIGGER CheckExpiryBeforeInsert
BEFORE INSERT ON LegalDocuments
FOR EACH ROW
BEGIN
    IF NEW.ExpiryDate IS NOT NULL AND NEW.ExpiryDate <= NEW.IssueDate THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ExpiryDate must be after IssueDate';
    END IF;
END $$
DELIMITER ;

-- 7. Trigger after update to log status change
DELIMITER $$
CREATE TRIGGER LogStatusChange
AFTER UPDATE ON LegalDocuments
FOR EACH ROW
BEGIN
    IF OLD.Status <> NEW.Status THEN
        INSERT INTO LegalDocuments_Log(DocumentID, OldStatus, NewStatus, ChangedOn)
        VALUES (NEW.DocumentID, OLD.Status, NEW.Status, NOW());
    END IF;
END $$
DELIMITER ;

-- 8. Window function: row number by DocumentType
SELECT DocumentID, DocumentType, Status,
       ROW_NUMBER() OVER(PARTITION BY DocumentType ORDER BY IssueDate) AS RowNum
FROM LegalDocuments;

-- 9. Window function: rank by IssueDate
SELECT DocumentID, DocumentType, IssueDate,
       RANK() OVER(ORDER BY IssueDate DESC) AS RecentRank
FROM LegalDocuments;

-- 10. DCL: Grant SELECT permission
GRANT SELECT ON LegalDocuments TO 'viewer_user'@'localhost';

-- 11. DCL: Revoke DELETE permission
REVOKE DELETE ON LegalDocuments FROM 'viewer_user'@'localhost';

-- 12. TCL: Transaction to update multiple statuses
START TRANSACTION;
UPDATE LegalDocuments SET Status='Verified' WHERE Status='Pending';
UPDATE LegalDocuments SET Status='Rejected' WHERE Status='Rejected';
COMMIT;

-- 13. Select all documents with 'Tax' in type
SELECT * FROM LegalDocuments
WHERE DocumentType LIKE '%Tax%';

-- 14. Select latest 5 uploaded documents
SELECT * FROM LegalDocuments
ORDER BY UploadDate DESC
LIMIT 5;

-- 15. Count documents by status
SELECT Status, COUNT(*) AS Total
FROM LegalDocuments
GROUP BY Status;

-- 16. Update ExpiryDate for a document
UPDATE LegalDocuments
SET ExpiryDate = '2035-01-01'
WHERE DocumentID = 1;

-- 17. Delete documents with Rejected status
DELETE FROM LegalDocuments
WHERE Status='Rejected';

-- 18. Alter table to add new column
ALTER TABLE LegalDocuments
ADD COLUMN ReviewedBy INT;

-- 19. Select documents with NULL ExpiryDate
SELECT * FROM LegalDocuments
WHERE ExpiryDate IS NULL;

-- 20. Select first 3 characters of Remarks
SELECT DocumentID, LEFT(Remarks,3) AS RemarkSnippet
FROM LegalDocuments;

-- 18. Permits

-- 1. Create view for approved permits
CREATE OR REPLACE VIEW ApprovedPermits AS
SELECT PermitID, Type, IssuedBy, Status
FROM Permits
WHERE Status='Approved';

-- 2. View for permits expiring in next 6 months
CREATE OR REPLACE VIEW ExpiringPermits AS
SELECT PermitID, Type, ExpiryDate
FROM Permits
WHERE ExpiryDate BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 6 MONTH);

-- 3. Stored Procedure to add new permit
DELIMITER $$
CREATE PROCEDURE AddPermit (
    IN pSiteID INT,
    IN pType VARCHAR(50),
    IN pIssuedBy VARCHAR(100),
    IN pIssueDate DATE,
    IN pExpiryDate DATE,
    IN pStatus VARCHAR(30),
    IN pFilePath VARCHAR(255),
    IN pVerifiedBy INT,
    IN pNotes TEXT
)
BEGIN
    INSERT INTO Permits(SiteID, Type, IssuedBy, IssueDate, ExpiryDate, Status, FilePath, VerifiedBy, Notes)
    VALUES (pSiteID, pType, pIssuedBy, pIssueDate, pExpiryDate, pStatus, pFilePath, pVerifiedBy, pNotes);
END $$
DELIMITER ;

-- 4. Stored Procedure to update permit status
DELIMITER $$
CREATE PROCEDURE UpdatePermitStatus(
    IN pPermitID INT,
    IN pStatus VARCHAR(30)
)
BEGIN
    UPDATE Permits
    SET Status = pStatus
    WHERE PermitID = pPermitID;
END $$
DELIMITER ;

-- 5. Cursor to list pending permits
DELIMITER $$
CREATE PROCEDURE ListPendingPermits()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE pID INT;
    DECLARE pType VARCHAR(50);
    DECLARE cur1 CURSOR FOR SELECT PermitID, Type FROM Permits WHERE Status='Pending';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur1;
    read_loop: LOOP
        FETCH cur1 INTO pID, pType;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT('Pending Permit ID: ', pID, ', Type: ', pType) AS PendingPermit;
    END LOOP;
    CLOSE cur1;
END $$
DELIMITER ;

-- 6. Trigger before insert to validate ExpiryDate
DELIMITER $$
CREATE TRIGGER CheckPermitExpiryBeforeInsert
BEFORE INSERT ON Permits
FOR EACH ROW
BEGIN
    IF NEW.ExpiryDate IS NOT NULL AND NEW.ExpiryDate <= NEW.IssueDate THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ExpiryDate must be after IssueDate';
    END IF;
END $$
DELIMITER ;

-- 7. Trigger after update to log status changes
DELIMITER $$
CREATE TRIGGER LogPermitStatusChange
AFTER UPDATE ON Permits
FOR EACH ROW
BEGIN
    IF OLD.Status <> NEW.Status THEN
        INSERT INTO Permits_Log(PermitID, OldStatus, NewStatus, ChangedOn)
        VALUES (NEW.PermitID, OLD.Status, NEW.Status, NOW());
    END IF;
END $$
DELIMITER ;

-- 8. Window function: row number by Type
SELECT PermitID, Type, Status,
       ROW_NUMBER() OVER(PARTITION BY Type ORDER BY IssueDate) AS RowNum
FROM Permits;

-- 9. Window function: rank by IssueDate
SELECT PermitID, Type, IssueDate,
       RANK() OVER(ORDER BY IssueDate DESC) AS RecentRank
FROM Permits;

-- 10. DCL: Grant SELECT permission
GRANT SELECT ON Permits TO 'viewer_user'@'localhost';

-- 11. DCL: Revoke DELETE permission
REVOKE DELETE ON Permits FROM 'viewer_user'@'localhost';

-- 12. TCL: Transaction to update multiple permit statuses
START TRANSACTION;
UPDATE Permits SET Status='Approved' WHERE Status='Pending';
UPDATE Permits SET Status='Rejected' WHERE Status='Rejected';
COMMIT;

-- 13. Select all permits issued by 'Municipal Authority'
SELECT * FROM Permits
WHERE IssuedBy='Municipal Authority';

-- 14. Select latest 5 permits by IssueDate
SELECT * FROM Permits
ORDER BY IssueDate DESC
LIMIT 5;

-- 15. Count permits by Status
SELECT Status, COUNT(*) AS Total
FROM Permits
GROUP BY Status;

-- 16. Update ExpiryDate for a permit
UPDATE Permits
SET ExpiryDate = '2029-01-01'
WHERE PermitID = 1;

-- 17. Delete permits with Rejected status
DELETE FROM Permits
WHERE Status='Rejected';

-- 18. Alter table to add ReviewedBy column
ALTER TABLE Permits
ADD COLUMN ReviewedBy INT;

-- 19. Select permits with NULL ExpiryDate
SELECT * FROM Permits
WHERE ExpiryDate IS NULL;

-- 20. Select first 5 characters of Notes
SELECT PermitID, LEFT(Notes,5) AS NoteSnippet
FROM Permits;


-- 19.ConstructionPhases 

-- 1. Create view for completed phases
CREATE OR REPLACE VIEW CompletedPhases AS
SELECT PhaseID, PhaseName, Status
FROM ConstructionPhases
WHERE Status='Completed';

-- 2. View for phases over budget
CREATE OR REPLACE VIEW OverBudgetPhases AS
SELECT PhaseID, PhaseName, Budget, ActualCost
FROM ConstructionPhases
WHERE ActualCost > Budget;

-- 3. Stored Procedure to add a new phase
DELIMITER $$
CREATE PROCEDURE AddPhase(
    IN pProjectID INT,
    IN pPhaseName VARCHAR(100),
    IN pStartDate DATE,
    IN pEndDate DATE,
    IN pStatus VARCHAR(30),
    IN pSupervisorID INT,
    IN pBudget DECIMAL(12,2),
    IN pActualCost DECIMAL(12,2),
    IN pRemarks TEXT
)
BEGIN
    INSERT INTO ConstructionPhases(ProjectID, PhaseName, StartDate, EndDate, Status, SupervisorID, Budget, ActualCost, Remarks)
    VALUES (pProjectID, pPhaseName, pStartDate, pEndDate, pStatus, pSupervisorID, pBudget, pActualCost, pRemarks);
END $$
DELIMITER ;

-- 4. Procedure to update phase status
DELIMITER $$
CREATE PROCEDURE UpdatePhaseStatus(IN pPhaseID INT, IN pStatus VARCHAR(30))
BEGIN
    UPDATE ConstructionPhases
    SET Status=pStatus
    WHERE PhaseID=pPhaseID;
END $$
DELIMITER ;

-- 5. Cursor to list pending phases
DELIMITER $$
CREATE PROCEDURE ListPendingPhases()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE pID INT;
    DECLARE pName VARCHAR(100);
    DECLARE cur1 CURSOR FOR SELECT PhaseID, PhaseName FROM ConstructionPhases WHERE Status='Pending';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;
    OPEN cur1;
    read_loop: LOOP
        FETCH cur1 INTO pID, pName;
        IF done THEN LEAVE read_loop; END IF;
        SELECT CONCAT('Pending Phase ID: ', pID, ', Name: ', pName) AS PendingPhase;
    END LOOP;
    CLOSE cur1;
END $$
DELIMITER ;

-- 6. Trigger before insert to validate EndDate
DELIMITER $$
CREATE TRIGGER CheckEndDateBeforeInsert
BEFORE INSERT ON ConstructionPhases
FOR EACH ROW
BEGIN
    IF NEW.EndDate IS NOT NULL AND NEW.EndDate < NEW.StartDate THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='EndDate must be after StartDate';
    END IF;
END $$
DELIMITER ;

-- 7. Trigger after update to log status changes
DELIMITER $$
CREATE TRIGGER LogPhaseStatusChange
AFTER UPDATE ON ConstructionPhases
FOR EACH ROW
BEGIN
    IF OLD.Status <> NEW.Status THEN
        INSERT INTO Phase_Log(PhaseID, OldStatus, NewStatus, ChangedOn)
        VALUES (NEW.PhaseID, OLD.Status, NEW.Status, NOW());
    END IF;
END $$
DELIMITER ;

-- 8. Window function: row number per ProjectID
SELECT PhaseID, ProjectID, PhaseName,
       ROW_NUMBER() OVER(PARTITION BY ProjectID ORDER BY StartDate) AS RowNum
FROM ConstructionPhases;

-- 9. Window function: rank by Budget
SELECT PhaseID, PhaseName, Budget,
       RANK() OVER(ORDER BY Budget DESC) AS BudgetRank
FROM ConstructionPhases;

-- 10. DCL: Grant SELECT permission
GRANT SELECT ON ConstructionPhases TO 'viewer_user'@'localhost';

-- 11. DCL: Revoke DELETE permission
REVOKE DELETE ON ConstructionPhases FROM 'viewer_user'@'localhost';

-- 12. TCL: Update multiple phase statuses in a transaction
START TRANSACTION;
UPDATE ConstructionPhases SET Status='In Progress' WHERE Status='Pending';
UPDATE ConstructionPhases SET Status='Completed' WHERE Status='Completed';
COMMIT;

-- 13. Select all phases supervised by SupervisorID 301
SELECT * FROM ConstructionPhases WHERE SupervisorID=301;

-- 14. Select latest 5 phases by StartDate
SELECT * FROM ConstructionPhases
ORDER BY StartDate DESC
LIMIT 5;

-- 15. Count phases by Status
SELECT Status, COUNT(*) AS TotalPhases
FROM ConstructionPhases
GROUP BY Status;

-- 16. Update ActualCost for a phase
UPDATE ConstructionPhases
SET ActualCost=105000.00
WHERE PhaseID=1;

-- 17. Delete all pending phases
DELETE FROM ConstructionPhases WHERE Status='Pending';

-- 18. Alter table to add RiskLevel column
ALTER TABLE ConstructionPhases ADD COLUMN RiskLevel VARCHAR(20);

-- 19. Select phases where ActualCost is NULL
SELECT * FROM ConstructionPhases WHERE ActualCost IS NULL;

-- 20. Select first 5 characters of Remarks
SELECT PhaseID, LEFT(Remarks,5) AS RemarkSnippet
FROM ConstructionPhases;

-- 20. Tasks

-- 1. Create view for completed tasks
CREATE OR REPLACE VIEW CompletedTasks AS
SELECT TaskID, TaskName, Status
FROM Tasks
WHERE Status='Completed';

-- 2. View for high priority tasks
CREATE OR REPLACE VIEW HighPriorityTasks AS
SELECT TaskID, TaskName, Priority
FROM Tasks
WHERE Priority='High';

-- 3. Procedure to add new task
DELIMITER $$
CREATE PROCEDURE AddTask(
    IN pPhaseID INT,
    IN pTaskName VARCHAR(100),
    IN pAssignedTo INT,
    IN pStartDate DATE,
    IN pEndDate DATE,
    IN pStatus VARCHAR(30),
    IN pProgress INT,
    IN pRemarks TEXT,
    IN pPriority VARCHAR(20)
)
BEGIN
    INSERT INTO Tasks(PhaseID, TaskName, AssignedTo, StartDate, EndDate, Status, ProgressPercent, Remarks, Priority)
    VALUES(pPhaseID, pTaskName, pAssignedTo, pStartDate, pEndDate, pStatus, pProgress, pRemarks, pPriority);
END $$
DELIMITER ;

-- 4. Procedure to update task status
DELIMITER $$
CREATE PROCEDURE UpdateTaskStatus(IN pTaskID INT, IN pStatus VARCHAR(30))
BEGIN
    UPDATE Tasks SET Status=pStatus WHERE TaskID=pTaskID;
END $$
DELIMITER ;

-- 5. Cursor to list tasks in progress
DELIMITER $$
CREATE PROCEDURE ListInProgressTasks()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tID INT;
    DECLARE tName VARCHAR(100);
    DECLARE cur1 CURSOR FOR SELECT TaskID, TaskName FROM Tasks WHERE Status='In Progress';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;
    OPEN cur1;
    read_loop: LOOP
        FETCH cur1 INTO tID, tName;
        IF done THEN LEAVE read_loop; END IF;
        SELECT CONCAT('Task ID: ', tID, ', Name: ', tName) AS InProgressTask;
    END LOOP;
    CLOSE cur1;
END $$
DELIMITER ;

-- 6. Trigger before insert to validate ProgressPercent
DELIMITER $$
CREATE TRIGGER CheckProgressBeforeInsert
BEFORE INSERT ON Tasks
FOR EACH ROW
BEGIN
    IF NEW.ProgressPercent <0 OR NEW.ProgressPercent>100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='ProgressPercent must be between 0 and 100';
    END IF;
END $$
DELIMITER ;

-- 7. Trigger after update to log status changes
DELIMITER $$
CREATE TRIGGER LogTaskStatusChange
AFTER UPDATE ON Tasks
FOR EACH ROW
BEGIN
    IF OLD.Status<>NEW.Status THEN
        INSERT INTO Task_Log(TaskID, OldStatus, NewStatus, ChangedOn)
        VALUES(NEW.TaskID, OLD.Status, NEW.Status, NOW());
    END IF;
END $$
DELIMITER ;

-- 8. Window function: row number per PhaseID
SELECT TaskID, PhaseID, TaskName,
       ROW_NUMBER() OVER(PARTITION BY PhaseID ORDER BY StartDate) AS RowNum
FROM Tasks;

-- 9. Window function: rank by ProgressPercent
SELECT TaskID, TaskName, ProgressPercent,
       RANK() OVER(ORDER BY ProgressPercent DESC) AS ProgressRank
FROM Tasks;

-- 10. DCL: Grant SELECT permission
GRANT SELECT ON Tasks TO 'viewer_user'@'localhost';

-- 11. DCL: Revoke DELETE permission
REVOKE DELETE ON Tasks FROM 'viewer_user'@'localhost';

-- 12. TCL: Transaction to update task statuses
START TRANSACTION;
UPDATE Tasks SET Status='Completed' WHERE ProgressPercent=100;
UPDATE Tasks SET Status='In Progress' WHERE ProgressPercent<100;
COMMIT;

-- 13. Select tasks assigned to employee 301
SELECT * FROM Tasks WHERE AssignedTo=301;

-- 14. Select top 5 tasks by ProgressPercent
SELECT * FROM Tasks
ORDER BY ProgressPercent DESC
LIMIT 5;

-- 15. Count tasks by Status
SELECT Status, COUNT(*) AS TotalTasks
FROM Tasks
GROUP BY Status;

-- 16. Update ProgressPercent for a task
UPDATE Tasks SET ProgressPercent=85 WHERE TaskID=15;

-- 17. Delete completed tasks
DELETE FROM Tasks WHERE Status='Completed';

-- 18. Alter table to add TaskCategory column
ALTER TABLE Tasks ADD COLUMN TaskCategory VARCHAR(50);

-- 19. Select tasks with NULL EndDate
SELECT * FROM Tasks WHERE EndDate IS NULL;

-- 20. Select first 5 characters of Remarks
SELECT TaskID, LEFT(Remarks,5) AS RemarkSnippet FROM Tasks;

-- 21.Equipment

-- 1. Create view of active equipment
CREATE OR REPLACE VIEW ActiveEquipment AS
SELECT EquipmentID, Name, Type, Status
FROM Equipment
WHERE Status='Active';

-- 2. View for equipment needing maintenance
CREATE OR REPLACE VIEW MaintenanceDue AS
SELECT EquipmentID, Name, MaintenanceDate
FROM Equipment
WHERE MaintenanceDate <= CURDATE();

-- 3. Procedure to add new equipment
DELIMITER $$
CREATE PROCEDURE AddEquipment(
    IN pName VARCHAR(100), IN pType VARCHAR(50), IN pQuantity INT, 
    IN pPurchaseDate DATE, IN pStatus VARCHAR(30), IN pAssignedToSite INT,
    IN pMaintenanceDate DATE, IN pVendorID INT, IN pRemarks TEXT)
BEGIN
    INSERT INTO Equipment(Name, Type, Quantity, PurchaseDate, Status, AssignedToSite, MaintenanceDate, VendorID, Remarks)
    VALUES(pName, pType, pQuantity, pPurchaseDate, pStatus, pAssignedToSite, pMaintenanceDate, pVendorID, pRemarks);
END $$
DELIMITER ;

-- 4. Procedure to update equipment status
DELIMITER $$
CREATE PROCEDURE UpdateEquipmentStatus(IN pEquipmentID INT, IN pStatus VARCHAR(30))
BEGIN
    UPDATE Equipment SET Status=pStatus WHERE EquipmentID=pEquipmentID;
END $$
DELIMITER ;

-- 5. Cursor to list all heavy equipment
DELIMITER $$
CREATE PROCEDURE ListHeavyEquipment()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE eID INT; DECLARE eName VARCHAR(100);
    DECLARE cur1 CURSOR FOR SELECT EquipmentID, Name FROM Equipment WHERE Type='Heavy';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;
    OPEN cur1;
    read_loop: LOOP
        FETCH cur1 INTO eID, eName;
        IF done THEN LEAVE read_loop; END IF;
        SELECT CONCAT('Heavy Equipment: ', eName, ' (ID: ', eID, ')') AS EquipmentInfo;
    END LOOP;
    CLOSE cur1;
END $$
DELIMITER ;

-- 6. Trigger before insert to ensure Quantity >= 0
DELIMITER $$
CREATE TRIGGER CheckEquipmentQuantity
BEFORE INSERT ON Equipment
FOR EACH ROW
BEGIN
    IF NEW.Quantity < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Quantity cannot be negative';
    END IF;
END $$
DELIMITER ;

-- 7. Trigger after update to log status change
DELIMITER $$
CREATE TRIGGER LogEquipmentStatusChange
AFTER UPDATE ON Equipment
FOR EACH ROW
BEGIN
    IF OLD.Status<>NEW.Status THEN
        INSERT INTO Equipment_Log(EquipmentID, OldStatus, NewStatus, ChangedOn)
        VALUES(NEW.EquipmentID, OLD.Status, NEW.Status, NOW());
    END IF;
END $$
DELIMITER ;

-- 8. Window function: row number by Type
SELECT EquipmentID, Name, Type,
       ROW_NUMBER() OVER(PARTITION BY Type ORDER BY PurchaseDate) AS RowNum
FROM Equipment;

-- 9. Window function: rank by Quantity
SELECT EquipmentID, Name, Quantity,
       RANK() OVER(ORDER BY Quantity DESC) AS QuantityRank
FROM Equipment;

-- 10. DCL: Grant SELECT privilege
GRANT SELECT ON Equipment TO 'viewer_user'@'localhost';

-- 11. DCL: Revoke DELETE privilege
REVOKE DELETE ON Equipment FROM 'viewer_user'@'localhost';

-- 12. TCL: Transaction to update statuses
START TRANSACTION;
UPDATE Equipment SET Status='In Use' WHERE Status='Active';
UPDATE Equipment SET Status='Under Repair' WHERE Status='Under Repair';
COMMIT;

-- 13. Select equipment assigned to site 1
SELECT * FROM Equipment WHERE AssignedToSite=1;

-- 14. Select top 5 recently purchased equipment
SELECT * FROM Equipment ORDER BY PurchaseDate DESC LIMIT 5;

-- 15. Count equipment by Type
SELECT Type, COUNT(*) AS TotalEquipment FROM Equipment GROUP BY Type;

-- 16. Update MaintenanceDate for equipment ID 1
UPDATE Equipment SET MaintenanceDate='2024-08-01' WHERE EquipmentID=1;

-- 17. Delete all inactive equipment
DELETE FROM Equipment WHERE Status='Inactive';

-- 18. Alter table to add WarrantyEndDate column
ALTER TABLE Equipment ADD COLUMN WarrantyEndDate DATE;

-- 19. Select equipment with NULL Remarks
SELECT * FROM Equipment WHERE Remarks IS NULL;

-- 20. Select first 5 characters of Remarks
SELECT EquipmentID, LEFT(Remarks,5) AS RemarkSnippet FROM Equipment;

-- 22.SiteVisits

-- 1. Create view for completed visits
CREATE OR REPLACE VIEW CompletedVisits AS
SELECT VisitID, SiteID, VisitorName, VisitDate
FROM SiteVisits
WHERE Status='Completed';

-- 2. View for long duration visits (>60 min)
CREATE OR REPLACE VIEW LongVisits AS
SELECT VisitID, VisitorName, DurationMinutes
FROM SiteVisits
WHERE DurationMinutes>60;

-- 3. Procedure to add new site visit
DELIMITER $$
CREATE PROCEDURE AddSiteVisit(
    IN pSiteID INT, IN pVisitorName VARCHAR(100), IN pVisitDate DATE,
    IN pPurpose VARCHAR(100), IN pGuidedBy INT, IN pDuration INT,
    IN pFeedback TEXT, IN pStatus VARCHAR(30), IN pNotes TEXT)
BEGIN
    INSERT INTO SiteVisits(SiteID, VisitorName, VisitDate, Purpose, GuidedBy, DurationMinutes, Feedback, Status, Notes)
    VALUES(pSiteID, pVisitorName, pVisitDate, pPurpose, pGuidedBy, pDuration, pFeedback, pStatus, pNotes);
END $$
DELIMITER ;

-- 4. Procedure to update visit status
DELIMITER $$
CREATE PROCEDURE UpdateVisitStatus(IN pVisitID INT, IN pStatus VARCHAR(30))
BEGIN
    UPDATE SiteVisits SET Status=pStatus WHERE VisitID=pVisitID;
END $$
DELIMITER ;

-- 5. Cursor to list visits longer than 60 mins
DELIMITER $$
CREATE PROCEDURE ListLongVisits()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE vID INT; DECLARE vName VARCHAR(100);
    DECLARE cur1 CURSOR FOR SELECT VisitID, VisitorName FROM SiteVisits WHERE DurationMinutes>60;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;
    OPEN cur1;
    read_loop: LOOP
        FETCH cur1 INTO vID, vName;
        IF done THEN LEAVE read_loop; END IF;
        SELECT CONCAT('Long Visit by ', vName, ' (ID: ', vID, ')') AS VisitInfo;
    END LOOP;
    CLOSE cur1;
END $$
DELIMITER ;

-- 6. Trigger before insert to check DurationMinutes >=0
DELIMITER $$
CREATE TRIGGER CheckVisitDuration
BEFORE INSERT ON SiteVisits
FOR EACH ROW
BEGIN
    IF NEW.DurationMinutes<0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='DurationMinutes must be >=0';
    END IF;
END $$
DELIMITER ;

-- 7. Trigger after update to log Status changes
DELIMITER $$
CREATE TRIGGER LogVisitStatusChange
AFTER UPDATE ON SiteVisits
FOR EACH ROW
BEGIN
    IF OLD.Status<>NEW.Status THEN
        INSERT INTO Visit_Log(VisitID, OldStatus, NewStatus, ChangedOn)
        VALUES(NEW.VisitID, OLD.Status, NEW.Status, NOW());
    END IF;
END $$
DELIMITER ;

-- 8. Window function: row number by SiteID
SELECT VisitID, SiteID, VisitorName,
       ROW_NUMBER() OVER(PARTITION BY SiteID ORDER BY VisitDate) AS RowNum
FROM SiteVisits;

-- 9. Window function: rank by DurationMinutes
SELECT VisitID, VisitorName, DurationMinutes,
       RANK() OVER(ORDER BY DurationMinutes DESC) AS DurationRank
FROM SiteVisits;

-- 10. DCL: Grant SELECT privilege
GRANT SELECT ON SiteVisits TO 'viewer_user'@'localhost';

-- 11. DCL: Revoke DELETE privilege
REVOKE DELETE ON SiteVisits FROM 'viewer_user'@'localhost';

-- 12. TCL: Update statuses in transaction
START TRANSACTION;
UPDATE SiteVisits SET Status='Completed' WHERE DurationMinutes<=60;
UPDATE SiteVisits SET Status='Extended' WHERE DurationMinutes>60;
COMMIT;

-- 13. Select visits guided by employee 101
SELECT * FROM SiteVisits WHERE GuidedBy=101;

-- 14. Select top 5 latest visits
SELECT * FROM SiteVisits ORDER BY VisitDate DESC LIMIT 5;

-- 15. Count visits by Status
SELECT Status, COUNT(*) AS TotalVisits FROM SiteVisits GROUP BY Status;

-- 16. Update Feedback for VisitID 1
UPDATE SiteVisits SET Feedback='Excellent' WHERE VisitID=1;

-- 17. Delete canceled visits
DELETE FROM SiteVisits WHERE Status='Canceled';

-- 18. Alter table to add Weather column
ALTER TABLE SiteVisits ADD COLUMN Weather VARCHAR(50);

-- 19. Select visits with NULL Notes
SELECT * FROM SiteVisits WHERE Notes IS NULL;

-- 20. Select first 5 characters of Feedback
SELECT VisitID, LEFT(Feedback,5) AS FeedbackSnippet FROM SiteVisits;
 
-- 23.Budgets
 
 -- 1. Create view of approved budgets
CREATE OR REPLACE VIEW ApprovedBudgets AS
SELECT BudgetID, ProjectID, Amount, Status
FROM Budgets
WHERE Status='Approved';

-- 2. View of pending budgets
CREATE OR REPLACE VIEW PendingBudgets AS
SELECT BudgetID, ProjectID, Amount, ApprovalDate
FROM Budgets
WHERE Status='Pending';

-- 3. Procedure to add new budget
DELIMITER $$
CREATE PROCEDURE AddBudget(
    IN pProjectID INT, IN pPhaseID INT, IN pAmount DECIMAL(12,2),
    IN pApprovedBy INT, IN pApprovalDate DATE, IN pRemarks TEXT,
    IN pCategory VARCHAR(50), IN pYear INT, IN pStatus VARCHAR(30))
BEGIN
    INSERT INTO Budgets(ProjectID, PhaseID, Amount, ApprovedBy, ApprovalDate, Remarks, Category, Year, Status)
    VALUES(pProjectID, pPhaseID, pAmount, pApprovedBy, pApprovalDate, pRemarks, pCategory, pYear, pStatus);
END $$
DELIMITER ;

-- 4. Procedure to update budget status
DELIMITER $$
CREATE PROCEDURE UpdateBudgetStatus(IN pBudgetID INT, IN pStatus VARCHAR(30))
BEGIN
    UPDATE Budgets SET Status=pStatus WHERE BudgetID=pBudgetID;
END $$
DELIMITER ;

-- 5. Cursor to list all budgets > 200,000
DELIMITER $$
CREATE PROCEDURE ListLargeBudgets()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE bID INT; DECLARE amt DECIMAL(12,2);
    DECLARE cur1 CURSOR FOR SELECT BudgetID, Amount FROM Budgets WHERE Amount>200000;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;
    OPEN cur1;
    read_loop: LOOP
        FETCH cur1 INTO bID, amt;
        IF done THEN LEAVE read_loop; END IF;
        SELECT CONCAT('Budget ID: ', bID, ', Amount: ', amt) AS BudgetInfo;
    END LOOP;
    CLOSE cur1;
END $$
DELIMITER ;

-- 6. Trigger before insert to check Amount >= 0
DELIMITER $$
CREATE TRIGGER CheckBudgetAmount
BEFORE INSERT ON Budgets
FOR EACH ROW
BEGIN
    IF NEW.Amount < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Amount must be >= 0';
    END IF;
END $$
DELIMITER ;

-- 7. Trigger after update to log status change
DELIMITER $$
CREATE TRIGGER LogBudgetStatusChange
AFTER UPDATE ON Budgets
FOR EACH ROW
BEGIN
    IF OLD.Status<>NEW.Status THEN
        INSERT INTO Budget_Log(BudgetID, OldStatus, NewStatus, ChangedOn)
        VALUES(NEW.BudgetID, OLD.Status, NEW.Status, NOW());
    END IF;
END $$
DELIMITER ;

-- 8. Window function: row number by ProjectID
SELECT BudgetID, ProjectID, Amount,
       ROW_NUMBER() OVER(PARTITION BY ProjectID ORDER BY Amount DESC) AS RowNum
FROM Budgets;

-- 9. Window function: rank by Amount
SELECT BudgetID, ProjectID, Amount,
       RANK() OVER(ORDER BY Amount DESC) AS AmountRank
FROM Budgets;

-- 10. DCL: Grant SELECT privilege
GRANT SELECT ON Budgets TO 'viewer_user'@'localhost';

-- 11. DCL: Revoke DELETE privilege
REVOKE DELETE ON Budgets FROM 'viewer_user'@'localhost';

-- 12. TCL: Transaction example
START TRANSACTION;
UPDATE Budgets SET Status='Approved' WHERE Status='Pending';
UPDATE Budgets SET Amount=Amount*1.05 WHERE Category='Construction';
COMMIT;

-- 13. Select budgets for ProjectID 1
SELECT * FROM Budgets WHERE ProjectID=1;

-- 14. Select top 5 highest budgets
SELECT * FROM Budgets ORDER BY Amount DESC LIMIT 5;

-- 15. Count budgets by Category
SELECT Category, COUNT(*) AS TotalBudgets FROM Budgets GROUP BY Category;

-- 16. Update Remarks for BudgetID 1
UPDATE Budgets SET Remarks='Updated initial budget' WHERE BudgetID=1;

-- 17. Delete budgets with Amount < 50,000
DELETE FROM Budgets WHERE Amount<50000;

-- 18. Alter table to add column LastModified
ALTER TABLE Budgets ADD COLUMN LastModified DATETIME;

-- 19. Select budgets with NULL Remarks
SELECT * FROM Budgets WHERE Remarks IS NULL;

-- 20. Select first 5 characters of Remarks
SELECT BudgetID, LEFT(Remarks,5) AS RemarkSnippet FROM Budgets;
 
-- 24.Invoices

-- 1. Create view for paid invoices
CREATE OR REPLACE VIEW PaidInvoices AS
SELECT InvoiceID, OrderID, TotalAmount, Status
FROM Invoices
WHERE Status='Paid';

-- 2. View for pending invoices
CREATE OR REPLACE VIEW PendingInvoices AS
SELECT InvoiceID, OrderID, TotalAmount, DueDate
FROM Invoices
WHERE Status='Pending';

-- 3. Procedure to add new invoice
DELIMITER $$
CREATE PROCEDURE AddInvoice(
    IN pOrderID INT, IN pVendorID INT, IN pInvoiceDate DATE, IN pDueDate DATE,
    IN pTotalAmount DECIMAL(12,2), IN pPaidAmount DECIMAL(12,2),
    IN pStatus VARCHAR(30), IN pGeneratedBy INT, IN pNotes TEXT)
BEGIN
    INSERT INTO Invoices(OrderID, VendorID, InvoiceDate, DueDate, TotalAmount, PaidAmount, Status, GeneratedBy, Notes)
    VALUES(pOrderID, pVendorID, pInvoiceDate, pDueDate, pTotalAmount, pPaidAmount, pStatus, pGeneratedBy, pNotes);
END $$
DELIMITER ;

-- 4. Procedure to update invoice status
DELIMITER $$
CREATE PROCEDURE UpdateInvoiceStatus(IN pInvoiceID INT, IN pStatus VARCHAR(30))
BEGIN
    UPDATE Invoices SET Status=pStatus WHERE InvoiceID=pInvoiceID;
END $$
DELIMITER ;

-- 5. Cursor to list invoices > 100,000
DELIMITER $$
CREATE PROCEDURE ListHighValueInvoices()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE iID INT; DECLARE amt DECIMAL(12,2);
    DECLARE cur1 CURSOR FOR SELECT InvoiceID, TotalAmount FROM Invoices WHERE TotalAmount>100000;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;
    OPEN cur1;
    read_loop: LOOP
        FETCH cur1 INTO iID, amt;
        IF done THEN LEAVE read_loop; END IF;
        SELECT CONCAT('InvoiceID: ', iID, ', TotalAmount: ', amt) AS InvoiceInfo;
    END LOOP;
    CLOSE cur1;
END $$
DELIMITER ;

-- 6. Trigger before insert to check TotalAmount >=0
DELIMITER $$
CREATE TRIGGER CheckInvoiceAmount
BEFORE INSERT ON Invoices
FOR EACH ROW
BEGIN
    IF NEW.TotalAmount < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='TotalAmount must be >=0';
    END IF;
END $$
DELIMITER ;

-- 7. Trigger after update to log Status change
DELIMITER $$
CREATE TRIGGER LogInvoiceStatusChange
AFTER UPDATE ON Invoices
FOR EACH ROW
BEGIN
    IF OLD.Status<>NEW.Status THEN
        INSERT INTO Invoice_Log(InvoiceID, OldStatus, NewStatus, ChangedOn)
        VALUES(NEW.InvoiceID, OLD.Status, NEW.Status, NOW());
    END IF;
END $$
DELIMITER ;

-- 8. Window function: row number by VendorID
SELECT InvoiceID, VendorID, TotalAmount,
       ROW_NUMBER() OVER(PARTITION BY VendorID ORDER BY InvoiceDate) AS RowNum
FROM Invoices;

-- 9. Window function: rank by TotalAmount
SELECT InvoiceID, VendorID, TotalAmount,
       RANK() OVER(ORDER BY TotalAmount DESC) AS AmountRank
FROM Invoices;

-- 10. DCL: Grant SELECT privilege
GRANT SELECT ON Invoices TO 'viewer_user'@'localhost';

-- 11. DCL: Revoke DELETE privilege
REVOKE DELETE ON Invoices FROM 'viewer_user'@'localhost';

-- 12. TCL: Transaction example
START TRANSACTION;
UPDATE Invoices SET PaidAmount=TotalAmount WHERE Status='Paid';
UPDATE Invoices SET Status='Overdue' WHERE DueDate<CURDATE() AND Status='Pending';
COMMIT;

-- 13. Select invoices generated by user 101
SELECT * FROM Invoices WHERE GeneratedBy=101;

-- 14. Select top 5 latest invoices
SELECT * FROM Invoices ORDER BY InvoiceDate DESC LIMIT 5;

-- 15. Count invoices by Status
SELECT Status, COUNT(*) AS TotalInvoices FROM Invoices GROUP BY Status;

-- 16. Update Notes for InvoiceID 1
UPDATE Invoices SET Notes='Checked and cleared' WHERE InvoiceID=1;

-- 17. Delete fully paid invoices
DELETE FROM Invoices WHERE TotalAmount=PaidAmount;

-- 18. Alter table to add column PaymentMode
ALTER TABLE Invoices ADD COLUMN PaymentMode VARCHAR(50);

-- 19. Select invoices with NULL Notes
SELECT * FROM Invoices WHERE Notes IS NULL;

-- 20. Select first 5 characters of Notes
SELECT InvoiceID, LEFT(Notes,5) AS NoteSnippet FROM Invoices;

-- 25. Feedback

-- 1. Create view for resolved feedbacks
CREATE OR REPLACE VIEW ResolvedFeedback AS
SELECT FeedbackID, ClientID, PropertyID, Rating, Status
FROM Feedback
WHERE Status='Resolved';

-- 2. View for pending feedbacks
CREATE OR REPLACE VIEW PendingFeedback AS
SELECT FeedbackID, ClientID, SubmittedDate, Comments
FROM Feedback
WHERE Status='Pending';

-- 3. Procedure to add new feedback
DELIMITER $$
CREATE PROCEDURE AddFeedback(
    IN pClientID INT, IN pPropertyID INT, IN pSubmittedDate DATE, IN pRating INT,
    IN pComments TEXT, IN pAgentID INT, IN pResolved BOOLEAN, IN pResponse TEXT, IN pStatus VARCHAR(30))
BEGIN
    INSERT INTO Feedback(ClientID, PropertyID, SubmittedDate, Rating, Comments, AgentID, Resolved, Response, Status)
    VALUES(pClientID, pPropertyID, pSubmittedDate, pRating, pComments, pAgentID, pResolved, pResponse, pStatus);
END $$
DELIMITER ;

-- 4. Procedure to update feedback status
DELIMITER $$
CREATE PROCEDURE UpdateFeedbackStatus(IN pFeedbackID INT, IN pStatus VARCHAR(30))
BEGIN
    UPDATE Feedback SET Status=pStatus WHERE FeedbackID=pFeedbackID;
END $$
DELIMITER ;

-- 5. Cursor to list feedbacks with Rating <=3
DELIMITER $$
CREATE PROCEDURE ListLowRatingFeedback()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE fID INT; DECLARE fRating INT;
    DECLARE cur1 CURSOR FOR SELECT FeedbackID, Rating FROM Feedback WHERE Rating<=3;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;
    OPEN cur1;
    read_loop: LOOP
        FETCH cur1 INTO fID, fRating;
        IF done THEN LEAVE read_loop; END IF;
        SELECT CONCAT('FeedbackID: ', fID, ', Rating: ', fRating) AS FeedbackInfo;
    END LOOP;
    CLOSE cur1;
END $$
DELIMITER ;

-- 6. Trigger before insert to ensure rating between 1 and 5
DELIMITER $$
CREATE TRIGGER CheckFeedbackRating
BEFORE INSERT ON Feedback
FOR EACH ROW
BEGIN
    IF NEW.Rating < 1 OR NEW.Rating > 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Rating must be between 1 and 5';
    END IF;
END $$
DELIMITER ;

-- 7. Trigger after update to log status change
DELIMITER $$
CREATE TRIGGER LogFeedbackStatusChange
AFTER UPDATE ON Feedback
FOR EACH ROW
BEGIN
    IF OLD.Status<>NEW.Status THEN
        INSERT INTO Feedback_Log(FeedbackID, OldStatus, NewStatus, ChangedOn)
        VALUES(NEW.FeedbackID, OLD.Status, NEW.Status, NOW());
    END IF;
END $$
DELIMITER ;

-- 8. Window function: row number by ClientID
SELECT FeedbackID, ClientID, Rating,
       ROW_NUMBER() OVER(PARTITION BY ClientID ORDER BY SubmittedDate DESC) AS RowNum
FROM Feedback;

-- 9. Window function: rank by Rating
SELECT FeedbackID, ClientID, Rating,
       RANK() OVER(ORDER BY Rating DESC) AS RatingRank
FROM Feedback;

-- 10. DCL: Grant SELECT privilege
GRANT SELECT ON Feedback TO 'viewer_user'@'localhost';

-- 11. DCL: Revoke DELETE privilege
REVOKE DELETE ON Feedback FROM 'viewer_user'@'localhost';

-- 12. TCL: Transaction example
START TRANSACTION;
UPDATE Feedback SET Resolved=TRUE WHERE Status='Pending';
UPDATE Feedback SET Status='Resolved' WHERE Rating>=4;
COMMIT;

-- 13. Select feedback for PropertyID 1
SELECT * FROM Feedback WHERE PropertyID=1;

-- 14. Select top 5 highest rated feedbacks
SELECT * FROM Feedback ORDER BY Rating DESC LIMIT 5;

-- 15. Count feedbacks by Status
SELECT Status, COUNT(*) AS TotalFeedback FROM Feedback GROUP BY Status;

-- 16. Update Response for FeedbackID 1
UPDATE Feedback SET Response='Thank you for feedback!' WHERE FeedbackID=1;

-- 17. Delete feedbacks with Rating <=2
DELETE FROM Feedback WHERE Rating<=2;

-- 18. Alter table to add column LastReviewed
ALTER TABLE Feedback ADD COLUMN LastReviewed DATETIME;

-- 19. Select feedbacks with NULL Response
SELECT * FROM Feedback WHERE Response IS NULL;

-- 20. Select first 10 characters of Comments
SELECT FeedbackID, LEFT(Comments,10) AS CommentSnippet FROM Feedback;

