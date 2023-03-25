
use Spring_2023_BaseBall

-- drop table parks

-- 1.	Write the DDL to create the Parks table. The script should include an IF statement (see script for creating the baseball database for examples) so that it could be run several times without changing anything in the script. See the 00 - Create Database.sql script for examples.

IF OBJECT_ID (N'dbo.Parks', N'U') IS NOT NULL
DROP TABLE [dbo].[TeamsFranchises]
GO

CREATE TABLE Parks(
	ParkID varchar(10) NOT NULL,
    ParkName varchar(60),
	Venue varchar(80),
	City varchar(50),
    States varchar(20),
	Country varchar(3),
);


-- 2. Adding appropriate primary key 

ALTER TABLE [Parks]
ADD CONSTRAINT [Parks_PK]
PRIMARY KEY CLUSTERED ([ParkID] ASC);


-- 3. Adding A check statement to check that the country column contains one of these values:  AU, CA, JP, MX, PR, UK, US  

ALTER TABLE [Parks]
ADD CONSTRAINT [Parks_Country_Check]
CHECK ([Country] IN ('AU', 'CA', 'JP', 'MX', 'PR', 'UK', 'US')
);




