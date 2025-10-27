/*

================================================================
Create Database and Scheas
================================================================
Script Purpose:
	This Script creates a new database named 'DataWarehouse' after checking if it already exists.
	If the database exists, it is dropped and recreated, Affitionally, the script sets up three schemas within the database: 'bronze', 'silver' and 'gold'.

WARNING:
	Running this script will drop the netire 'DataWarehouse' database if it exists.
	All data in the database will be permamntly deleted. proceed with caution
	and ensure you have porper backups before running this script.
*/

USE master;

-- Drio abd recreate tge 'DataWarehouse' database'
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
