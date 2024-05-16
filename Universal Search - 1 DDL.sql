--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!
DATABASE
	AND SCHEMA (DDL)

-- Create a Database (Optional)
CREATE
	OR REPLACE DATABASE SalesDB;

-- Use the Database
USE SalesDB;

-- Create a Schema
CREATE
	OR REPLACE SCHEMA Customers;

TABLE Creation(DDL)

-- Customer Table
CREATE TABLE Customer (
	CustomerID INT PRIMARY KEY
	,FirstName VARCHAR(50)
	,LastName VARCHAR(50)
	,Email VARCHAR(100)
	,HomeLocation VARCHAR(200)
	,ZipCode VARCHAR(10)
	);

-- Buyer Table
CREATE TABLE Buyer (
	BuyerID INT PRIMARY KEY
	,CustomerID INT REFERENCES Customer(CustomerID)
	,-- Link to Customer
	FirstName VARCHAR(50)
	,LastName VARCHAR(50)
	,Email VARCHAR(100)
	,Address VARCHAR(200)
	,PostalCode VARCHAR(10)
	);

-- Client Table
CREATE TABLE Client (
	ClientID INT PRIMARY KEY
	,BuyerID INT REFERENCES Buyer(BuyerID)
	,-- Link to Buyer
	ContractStartDate DATE
	,ContractValue DECIMAL(10, 2)
	);

-- Opportunities Table
CREATE TABLE Opportunities (
	OpportunityID INT PRIMARY KEY
	,CustomerID INT REFERENCES Customer(CustomerID)
	,BuyerID INT REFERENCES Buyer(BuyerID)
	,-- Optional, if Buyer is identified
	LeadSource VARCHAR(50)
	,SalesStage VARCHAR(20)
	,ExpectedCloseDate DATE
	,Amount DECIMAL(10, 2)
	);

Sample Data Insertion(DDL)

-- Customer
INSERT INTO Customer (
	CustomerID
	,FirstName
	,LastName
	,Email
	,HomeLocation
	,ZipCode
	)
VALUES (
	1
	,'Alice'
	,'Johnson'
	,'alice.johnson@example.com'
	,'123 Oak St'
	,'94105'
	)
	,(
	2
	,'Bob'
	,'Smith'
	,'bob.smith@example.com'
	,'456 Elm St'
	,'10001'
	)
	,(
	3
	,'Eva'
	,'Davis'
	,'eva.davis@example.com'
	,'789 Maple Ave'
	,'20001'
	);

-- Buyer (Some might not be clients yet)
INSERT INTO Buyer (
	BuyerID
	,CustomerID
	,FirstName
	,LastName
	,Email
	,Address
	,PostalCode
	)
VALUES (
	101
	,1
	,'Alice'
	,'Johnson'
	,'alice.johnson@example.com'
	,'123 Oak St'
	,'94105'
	)
	,(
	102
	,2
	,'Bob'
	,'Smith'
	,'bob.smith@example.com'
	,'456 Elm St'
	,'10001'
	)
	,(
	103
	,NULL
	,'David'
	,'Lee'
	,'david.lee@example.com'
	,'987 Pine St'
	,'33101'
	);-- Potential buyer, not yet a customer

-- Client (Only buyers who've signed a contract)
INSERT INTO Client (
	ClientID
	,BuyerID
	,ContractStartDate
	,ContractValue
	)
VALUES (
	201
	,101
	,'2024-01-15'
	,50000
	)
	,(
	202
	,102
	,'2023-12-01'
	,85000
	);

-- Opportunities (Linked to either Customer or Buyer, depending on stage)
INSERT INTO Opportunities (
	OpportunityID
	,CustomerID
	,BuyerID
	,LeadSource
	,SalesStage
	,ExpectedCloseDate
	,Amount
	)
VALUES (
	1001
	,1
	,NULL
	,'Partner Referral'
	,'Negotiation'
	,'2024-06-30'
	,120000
	)
	,(
	1002
	,2
	,102
	,'Web Form'
	,'Closed Won'
	,'2023-12-01'
	,85000
	)
	,(
	1003
	,3
	,NULL
	,'Outbound Call'
	,'Qualification'
	,'2024-05-20'
	,75000
	)
	,(
	1004
	,NULL
	,103
	,'Trade Show'
	,'Proposal'
	,'2024-06-10'
	,90000
	);-- Opportunity for potential buyer

Sample Comments Insertion(DDL)

-- Customer Table
ALTER TABLE Customer COMMENT = 'Stores information about our potential and existing customers, including contact details and location.';

ALTER TABLE Customer MODIFY COMMENT ON COLUMN HomeLocation IS 'The customer''s primary residence address.';

-- Buyer Table
ALTER TABLE Buyer COMMENT = 'Tracks information about customers who have made a purchase, including their new address and postal code.';

ALTER TABLE Buyer MODIFY COMMENT ON COLUMN Address IS 'The buyer''s preferred shipping or billing address.';

ALTER TABLE Buyer MODIFY COMMENT ON COLUMN PostalCode IS 'The buyer''s postal code, which may differ from their home location zip code.';

-- Client Table
ALTER TABLE Client COMMENT = 'Stores details about customers who have signed contracts, including contract start date and value.';

ALTER TABLE Client MODIFY COMMENT ON COLUMN ContractValue IS 'The total monetary value of the signed contract.';

-- Opportunities Table
ALTER TABLE Opportunities COMMENT = 'Tracks the progress of sales opportunities, including lead source, current sales stage, expected close date, and potential value.';

ALTER TABLE Opportunities MODIFY COMMENT ON COLUMN LeadSource IS 'How the lead was initially acquired (e.g., referral, web form, cold call).';

ALTER TABLE Opportunities MODIFY COMMENT ON COLUMN SalesStage IS 'The current stage of the opportunity in the sales pipeline.';

CREATE
	AND
APPLY Tags SQL

-- Create Tag for Personally Identifiable Information (PII)
CREATE TAG PII ALLOWED_VALUES (
	'Name'
	,'Email'
	,'Address'
	) COMMENT = 'Indicates personally identifiable information';

-- Create Tag for Lead Source
CREATE TAG Lead_Source ALLOWED_VALUES (
	'Partner Referral'
	,'Web Form'
	,'Outbound Call'
	,'Trade Show'
	) COMMENT = 'Indicates the source of the lead or opportunity';

-- Create Tag for Sales Stage
CREATE TAG Sales_Stage ALLOWED_VALUES (
	'Prospecting'
	,'Qualification'
	,'Proposal'
	,'Negotiation'
	,'Closed Won'
	,'Closed Lost'
	) COMMENT = 'Indicates the current stage of the sales opportunity';

-- Add Tags to Tables and Columns
-- Customer Table
ALTER TABLE Customer

SET TAG PII = 'Name'
FOR COLUMN FirstName;

ALTER TABLE Customer

SET TAG PII = 'Name'
FOR COLUMN LastName;

ALTER TABLE Customer

SET TAG PII = 'Email'
FOR COLUMN Email;

-- Buyer Table
ALTER TABLE Buyer

SET TAG PII = 'Name'
FOR COLUMN FirstName;

ALTER TABLE Buyer

SET TAG PII = 'Name'
FOR COLUMN LastName;

ALTER TABLE Buyer

SET TAG PII = 'Email'
FOR COLUMN Email;

ALTER TABLE Buyer

SET TAG PII = 'Address'
FOR COLUMN Address;

-- Client Table
ALTER TABLE Client

SET TAG PII = 'Address'
FOR COLUMN Address;

-- Opportunities Table
ALTER TABLE Opportunities

SET TAG Lead_Source = LeadSource;-- Apply the tag with the same name as the column

ALTER TABLE Opportunities

SET TAG Sales_Stage = SalesStage;-- Apply the tag with the same name as the column

CREATE
	AND
APPLY RBAC PRIVILEGES

USE ROLE ACCOUNTADMIN;-- Or a role with sufficient privileges

CREATE ROLE SalesRep;

CREATE ROLE SalesManager;

GRANT USAGE
	ON DATABASE SalesDB
	TO ROLE SalesRep;

GRANT USAGE
	ON DATABASE SalesDB
	TO ROLE SalesManager;

GRANT USAGE
	ON SCHEMA SalesDB.customer
	TO ROLE SalesRep;

GRANT USAGE
	ON SCHEMA SalesDB.customer
	TO ROLE SalesManager;

GRANT SELECT
	ON TABLE SalesDB.customer.Customer
	TO ROLE SalesRep;

GRANT SELECT
	ON ALL TABLES IN SCHEMA SalesDB.customer
	TO ROLE SalesManager;-- More access

CREATE Functions
	,Stored Procedures
	AND VIEWS
FOR Deeper Analysis

-- Functions SQL
-- Function to calculate the total value of closed opportunities for a given customer
CREATE
	OR REPLACE FUNCTION customer_closed_won_value (customer_id INT)
RETURNS DECIMAL(10, 2) AS $$

SELECT SUM(o.Amount)
FROM SalesDB.customer.Opportunities o
JOIN SalesDB.customer.Customer c ON o.CustomerID = c.CustomerID
WHERE c.CustomerID = customer_id
	AND o.SalesStage = 'Closed Won';$$;

-- Function to categorize customers based on their total value of closed opportunities
CREATE
	OR REPLACE FUNCTION categorize_customer (customer_id INT)
RETURNS VARCHAR(20) AS $$

DECLARE total_value DECIMAL(10, 2) : = customer_closed_won_value(customer_id);

BEGIN
	IF total_value >= 100000 THEN
		RETURN 'High Value';

	ELSIF total_value >= 50000 THEN

	RETURN 'Medium Value';ELSE

	RETURN 'Low Value';
END

IF ;$$;
	-- Stored Procedure SQL
	-- Stored procedure to update the sales stage of an opportunity
	CREATE
		OR REPLACE PROCEDURE update_opportunity_stage (
		opportunity_id INT
		,new_stage VARCHAR
		) AS $$

BEGIN
	UPDATE SalesDB.customer.Opportunities
	SET SalesStage = new_stage
	WHERE OpportunityID = opportunity_id;
END;$$;

-- Stored procedure to assign a new buyer to a customer
CREATE
	OR REPLACE PROCEDURE assign_buyer_to_customer (
	customer_id INT
	,buyer_id INT
	) AS $$

BEGIN
	UPDATE SalesDB.customer.Customer
	SET BuyerID = buyer_id
	WHERE CustomerID = customer_id;
END;$$;

--Views SQL
-- View to display high-value customers
CREATE
	OR REPLACE VIEW high_value_customers AS

SELECT c.*
	,customer_closed_won_value(c.CustomerID) AS TotalValue
FROM SalesDB.customer.Customer c
WHERE categorize_customer(c.CustomerID) = 'High Value';

-- View to display opportunities likely to close in the next month
CREATE
	OR REPLACE VIEW opportunities_likely_to_close AS

SELECT *
FROM SalesDB.customer.Opportunities
WHERE SalesStage IN (
		'Negotiation'
		,'Proposal'
		)
	AND ExpectedCloseDate BETWEEN CURRENT_DATE
		AND DATEADD(month, 1, CURRENT_DATE);
