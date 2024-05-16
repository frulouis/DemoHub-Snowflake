
/*
------------------------------------------------------------------------------
-- Snowflake Demo Script: Sales Data Model and Universal Search Exploration
-- 
-- Description: 
-- This script sets up a sales data model in Snowflake and explores universal 
-- search capabilities. It includes the creation of tables for customers, buyers,
-- clients, and opportunities, along with sample data insertion and tagging of 
-- columns for PII, lead source, and sales stage. Additionally, it defines RBAC 
-- privileges, functions, stored procedures, and views for analysis purposes.
--
-- Author: Fru N.
-- Website: DemoHub.dev
--
-- Date: May 15, 2024
--
-- Copyright: (c) 2024 DemoHub.dev. All rights reserved.
--
-- Disclaimer:  
-- This script is for educational and demonstration purposes only. It is not
-- affiliated with or endorsed by Snowflake Computing. Use this code at your 
-- own risk.
------------------------------------------------------------------------------
*/

-- 1. Database Setup:
-- Creates a new database named "SalesDB".
CREATE OR REPLACE DATABASE SalesDB;

-- Use the newly created database.
USE SalesDB;

-- Create a schema within the database.
CREATE OR REPLACE SCHEMA Custs;

-- 2. Table Creation:
-- Create tables for storing customer, buyer, client, and opportunity data.

-- Customer Table
CREATE OR REPLACE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    HomeLocation VARCHAR(200),
    ZipCode VARCHAR(10)
);

-- Buyer Table
CREATE OR REPLACE TABLE Buyer (
    BuyerID INT PRIMARY KEY,
    CustomerID INT REFERENCES Customer(CustomerID),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Address VARCHAR(200),
    PostalCode VARCHAR(10)
);

-- Client Table
CREATE OR REPLACE TABLE Client (
    ClientID INT PRIMARY KEY,
    BuyerID INT REFERENCES Buyer(BuyerID),
    ContractStartDate DATE,
    ContractValue DECIMAL(10, 2)
);

-- Opportunities Table
CREATE OR REPLACE TABLE Opportunities (
    OpportunityID INT PRIMARY KEY,
    CustomerID INT REFERENCES Customer(CustomerID),
    BuyerID INT REFERENCES Buyer(BuyerID),
    LeadSource VARCHAR(50),
    SalesStage VARCHAR(20),
    ExpectedCloseDate DATE,
    Amount DECIMAL(10, 2)
);

-- 3. Sample Data Insertion:
-- Insert sample data into the created tables.

-- Customer Data Insertion
INSERT INTO Customer (CustomerID, FirstName, LastName, Email, HomeLocation, ZipCode)
VALUES 
    (1, 'Alice', 'Johnson', 'alice.johnson@example.com', '123 Oak St', '94105'),
    (2, 'Bob', 'Smith', 'bob.smith@example.com', '456 Elm St', '10001'),
    (3, 'Eva', 'Davis', 'eva.davis@example.com', '789 Maple Ave', '20001');

-- Buyer Data Insertion
INSERT INTO Buyer (BuyerID, CustomerID, FirstName, LastName, Email, Address, PostalCode)
VALUES 
    (101, 1, 'Alice', 'Johnson', 'alice.johnson@example.com', '123 Oak St', '94105'),
    (102, 2, 'Bob', 'Smith', 'bob.smith@example.com', '456 Elm St', '10001'),
    (103, NULL, 'David', 'Lee', 'david.lee@example.com', '987 Pine St', '33101'); -- Potential buyer, not yet a customer

-- Client Data Insertion
INSERT INTO Client (ClientID, BuyerID, ContractStartDate, ContractValue)
VALUES 
    (201, 101, '2024-01-15', 50000),
    (202, 102, '2023-12-01', 85000);

-- Opportunities Data Insertion
INSERT INTO Opportunities (OpportunityID, CustomerID, BuyerID, LeadSource, SalesStage, ExpectedCloseDate, Amount)
VALUES 
    (1001, 1, NULL, 'Partner Referral', 'Negotiation', '2024-06-30', 120000),
    (1002, 2, 102, 'Web Form', 'Closed Won', '2023-12-01', 85000),
    (1003, 3, NULL, 'Outbound Call', 'Qualification', '2024-05-20', 75000),
    (1004, NULL, 103, 'Trade Show', 'Proposal', '2024-06-10', 90000); -- Opportunity for potential buyer

-- 4. Sample Comments Insertion:
-- Add comments to tables and columns for better understanding.

-- Customer Table Comments
COMMENT ON TABLE Customer IS 'Stores information about our potential and existing customers, including contact details and location.';
COMMENT ON COLUMN Customer.HomeLocation IS 'The customer''s primary residence address.';

-- Buyer Table Comments
COMMENT ON TABLE Buyer IS 'Tracks information about customers who have made a purchase, including their new address and postal code.';
COMMENT ON COLUMN Buyer.Address IS 'The buyer''s preferred shipping or billing address.';
COMMENT ON COLUMN Buyer.PostalCode IS 'The buyer''s postal code, which may differ from their home location zip code.';

-- Client Table Comments
COMMENT ON TABLE Client IS 'Stores details about customers who have signed contracts, including contract start date and value.';
COMMENT ON COLUMN Client.ContractValue IS 'The total monetary value of the signed contract.';

-- Opportunities Table Comments
COMMENT ON TABLE Opportunities IS 'Tracks the progress of sales opportunities, including lead source, current sales stage, expected close date, and potential value.';
COMMENT ON COLUMN Opportunities.LeadSource IS 'How the lead was initially acquired (e.g., referral, web form, cold call).';
COMMENT ON COLUMN Opportunities.SalesStage IS 'The current stage of the opportunity in the sales pipeline.';



-- -- 5. Tags Creation and Application:
-- -- Define tags for PII, lead source, and sales stage and apply them to relevant columns.

-- create tag cost_center
--     allowed_values 'finance', 'engineering';

-- -- Create Tag for Personally Identifiable Information (PII)
-- CREATE TAG PII ALLOWED_VALUES 'Name', 'Email', 'Address' COMMENT = 'Indicates personally identifiable information';

-- -- Create Tag for Lead Source
-- CREATE TAG Lead_Source ALLOWED_VALUES ('Partner Referral', 'Web Form', 'Outbound Call', 'Trade Show') COMMENT = 'Indicates the source of the lead or opportunity';

-- -- Create Tag for Sales Stage
-- CREATE TAG Sales_Stage ALLOWED_VALUES ('Prospecting', 'Qualification', 'Proposal', 'Negotiation', 'Closed Won', 'Closed Lost') COMMENT = 'Indicates the current stage of the sales opportunity';

-- -- Apply Tags to Tables and Columns

-- -- Customer Table
-- ALTER TABLE Customer SET TAG PII = 'Name' FOR COLUMN FirstName;
-- ALTER TABLE Customer SET TAG PII = 'Name' FOR COLUMN LastName;
-- ALTER TABLE Customer SET TAG PII = 'Email' FOR COLUMN Email;

-- -- Buyer Table
-- ALTER TABLE Buyer SET TAG PII = 'Name' FOR COLUMN FirstName;
-- ALTER TABLE Buyer SET TAG PII = 'Name' FOR COLUMN LastName;
-- ALTER TABLE Buyer SET TAG PII = 'Email' FOR COLUMN Email;
-- ALTER TABLE Buyer SET TAG PII = 'Address' FOR COLUMN Address;

-- -- Client Table
-- ALTER TABLE Client SET TAG PII = 'Address' FOR COLUMN Address;

-- -- Opportunities Table
-- ALTER TABLE Opportunities SET TAG Lead_Source = LeadSource; -- Apply the tag with the same name as the column
-- ALTER TABLE Opportunities SET TAG Sales_Stage = SalesStage; -- Apply the tag with the same name as the column


-- 6. RBAC Privileges Setup:
-- Define roles and grant privileges for role-based access control.

-- Use a role with sufficient privileges
USE ROLE ACCOUNTADMIN;

-- Create Roles
CREATE OR REPLACE ROLE SalesRep;
CREATE OR REPLACE ROLE SalesManager;

-- Grant Usage on Database to Roles
GRANT USAGE ON DATABASE SalesDB TO ROLE SalesRep;
GRANT USAGE ON DATABASE SalesDB TO ROLE SalesManager;

-- Grant Usage on Schema to Roles
GRANT USAGE ON SCHEMA SalesDB.custs TO ROLE SalesRep;
GRANT USAGE ON SCHEMA SalesDB.custs TO ROLE SalesManager;

-- Grant Select on Tables to Roles
GRANT SELECT ON TABLE Customer TO ROLE SalesRep;
GRANT SELECT ON ALL TABLES IN SCHEMA custs TO ROLE SalesManager; -- More access

-- 7. Functions, Stored Procedures, and Views Creation:
-- Define functions, stored procedures, and views for analysis purposes.

-- Function to calculate the total value of closed opportunities for a given customer
CREATE OR REPLACE FUNCTION customer_closed_won_value(customer_id INT) RETURNS NUMBER(19,4) LANGUAGE SQL
AS
$$
SELECT SUM(o.Amount)
FROM Opportunities o
JOIN Customer c ON o.CustomerID = c.CustomerID
WHERE o.CustomerID = customer_id
AND o.SalesStage = 'Closed Won'
$$;

-- -- Function to categorize customers based on their total value of closed opportunities
-- CREATE OR REPLACE FUNCTION categorize_customer (customer_id INT)
-- RETURNS VARCHAR(20) AS $$
-- DECLARE 
--     total_value DECIMAL(10, 2) := customer_closed_won_value(customer_id);
-- BEGIN
--     IF total_value >= 100000 THEN
--         RETURN 'High Value';
--     ELSIF total_value >= 50000 THEN
--         RETURN 'Medium Value';
--     ELSE
--         RETURN 'Low Value';
--     END IF;
-- END;
-- $$;


-- Stored procedure to update the sales stage of an opportunity
CREATE OR REPLACE PROCEDURE update_opportunity_stage (opportunity_id INT, new_stage VARCHAR)
  RETURNS STRING
  LANGUAGE SQL
AS $$
BEGIN
    UPDATE SalesDB.customer.Opportunities
    SET SalesStage = new_stage
    WHERE OpportunityID = opportunity_id;
    RETURN 'Success'; -- or any message you want to return upon successful execution
END;
$$;


-- Stored procedure to assign a new buyer to a customer
CREATE OR REPLACE PROCEDURE assign_buyer_to_customer (customer_id INT, buyer_id INT)
  RETURNS STRING
  LANGUAGE SQL
AS $$
BEGIN
    UPDATE SalesDB.customer.Customer
    SET BuyerID = buyer_id
    WHERE CustomerID = customer_id;
END;
$$;

-- View to display high-value customers
CREATE OR REPLACE VIEW high_value_customers AS
SELECT c.*, customer_closed_won_value(c.CustomerID) AS TotalValue
FROM Customer c;
--WHERE categorize_customer(c.CustomerID) = 'High Value';

-- View to display opportunities likely to close in the next month
CREATE OR REPLACE VIEW opportunities_likely_to_close AS
SELECT *
FROM Opportunities
WHERE SalesStage IN ('Negotiation', 'Proposal')
AND ExpectedCloseDate BETWEEN CURRENT_DATE AND DATEADD(month, 1, CURRENT_DATE);


-- 8. Switch to the ACCOUNTADMIN role (or a role with user management privileges)
-- When Demo'ing or testing this; switch to the user called DEMO. Make sure to switch the role from default to SALESREP. Perform Search with universal search
USE ROLE ACCOUNTADMIN;

-- Grant the SalesRep role to the Demo user
GRANT ROLE SalesRep TO USER Demo;
