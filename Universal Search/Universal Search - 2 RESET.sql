/*
------------------------------------------------------------------------------
-- Snowflake Demo Script: Sales Data Model and Universal Search Exploration
-- 
-- Author:      Fru N.
-- Website:     DemoHub.dev
-- Date:        May 15, 2024
--
-- Copyright (c) 2024 DemoHub.dev. All rights reserved. 
--
-- Disclaimer:  
-- This script is for educational and demonstration purposes only. It is not
-- affiliated with or endorsed by Snowflake Computing. Use this code at your 
-- own risk.
------------------------------------------------------------------------------
*/


USE ROLE ACCOUNTADMIN;  -- Or a role with sufficient privileges

-- Drop the database
DROP DATABASE IF EXISTS SalesDB CASCADE;

-- Drop the roles
DROP ROLE IF EXISTS SalesRep;
DROP ROLE IF EXISTS SalesManager;
