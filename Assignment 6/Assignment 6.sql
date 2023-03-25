use Spring_2023_BaseBall

-- Creating table leagues

CREATE TABLE League(
	lgID VARCHAR(255), 
	teamID VARCHAR(255),
	yearID INT,
PRIMARY KEY (lgID) 
)

--- Finding Distinct LgID ---
select distinct(lgid) from teams

--- Inserting LgID into League Table ---
INSERT INTO League (lgID)
VALUES ('UA'),('NA'),('AL'),('AA'),('NL'),('FL'),('PL')


-- Creating table teamsFranchise as not in database --
CREATE TABLE teamsFranchises(
	franchID VARCHAR(255), 
	franchises VARCHAR(255),
)

drop table teamsFranchises

select * from teamsFranchises

INSERT INTO teamsFranchises (franchID)
VALUES ('fran1'),('fran2'),('fran3'),('fran4'),('fran5')

--- Foreign Key 1.1 ---
--- column name : franchID ---
--- primary key table : teamsFranchises ---
--- foreign key table : Teams ---

ALTER TABLE teamsFranchises ALTER COLUMN franchID VARCHAR(255) not null
ALTER TABLE teamsFranchises ADD CONSTRAINT tf_Primary_Key PRIMARY KEY(franchID)

--- Creating Foreign Key ---
ALTER TABLE teams ADD FOREIGN KEY(franchID) REFERENCES teamsFranchises(franchID)


--- Foreign Key 1.2 ---
--- column name : lgID ---
--- primary key table : League ---
--- foreign key table : Teams ---

ALTER TABLE Teams ADD FOREIGN KEY(lgID) REFERENCES League(lgID);



--- Foreign Key 2.1 ---
--- column name : playerID ---
--- primary key table : People ---
--- foreign key table : AllstarFull ---

ALTER TABLE AllstarFull ALTER COLUMN playerID VARCHAR(255) not null
ALTER TABLE People ALTER COLUMN playerID VARCHAR(255) not null

ALTER TABLE People
ADD CONSTRAINT [PK_people] PRIMARY KEY ( [playerID] )

ALTER TABLE AllstarFull ADD FOREIGN KEY(playerID) REFERENCES People (playerID)


--- Foreign Key 2.2 ---
--- column name : YearID, LgID, Teamid ---
--- primary key table : Teams ---
--- foreign key table : AllstarFull ---

ALTER TABLE AllstarFull ALTER COLUMN yearID INT not null
ALTER TABLE AllstarFull ALTER COLUMN lgID VARCHAR(255) not null
ALTER TABLE AllstarFull ALTER COLUMN teamID VARCHAR(255) not null

ALTER TABLE Teams ADD CONSTRAINT Teams_Primary_Key PRIMARY KEY(yearID,lgID,teamID)

ALTER TABLE AllstarFull ADD FOREIGN KEY(yearID, lgID, teamID) REFERENCES Teams (yearID, lgID, teamID)

--- Foreign Key 3.1 ---
--- column name : playerID ---
--- primary key table : People ---
--- foreign key table : Appearances ---

ALTER TABLE Appearances ADD FOREIGN KEY(playerID) REFERENCES People (playerID)


--- Foreign Key 3.2 ---
--- column name : YearID, LgID, Teamid ---
--- primary key table : Teams ---
--- foreign key table : Appearances ---

ALTER TABLE Appearances ALTER COLUMN lgID varchar(255) not null

ALTER TABLE Appearances ADD FOREIGN KEY(yearID, lgID, teamID) REFERENCES Teams (yearID, lgID, teamID)

--- Foreign Key 4.1 ---
--- column name : YearID, LgID, Teamid ---
--- primary key table : Teams ---
--- foreign key table : HomeGames ---

ALTER TABLE HomeGames ALTER COLUMN lgID VARCHAR(255) NOT NULL
 
ALTER TABLE HomeGames ADD FOREIGN KEY(yearID, lgID, teamID) REFERENCES Teams (yearID, lgID, teamID)


--- Foreign Key 4.2 ---
--- column name : YearID, LgID, Teamid ---
--- primary key table : Parks ---
--- foreign key table : HomeGames ---
--- Fixing Parks Table and making park_key Primary key ---
ALTER TABLE Parks ALTER COLUMN park_key VARCHAR(255) not null
ALTER TABLE Parks ADD CONSTRAINT Parks_Primary_Key PRIMARY KEY (park_key)

--- Creating Foreign Key ---
ALTER TABLE HomeGames ADD FOREIGN KEY(parkID) REFERENCES Parks(park_key)


--- Foreign Key 5.1 ---
--- column name : playerID ---
--- primary key table : People ---
--- foreign key table : Managers ---

ALTER TABLE Managers ADD FOREIGN KEY(playerID) REFERENCES People (playerID)


--- Foreign Key 5.2 ---
--- column names : yearID, lgID, teamID ---
--- primary key table : Teams ---
--- foreign key table : Managers ---

ALTER TABLE Managers ALTER COLUMN lgID VARCHAR(255) not null

--Creating Foregin key-- 
ALTER TABLE Managers ADD FOREIGN KEY(yearID, lgID, teamID) REFERENCES Teams (yearID, lgID, teamID)


--- Foreign Key 6.1 ---
--- column name : lgID ---
--- primary key table : leagues ---
--- foreign key table : AwardsManagers  ---

select * from AwardsManagers
	WHERE lgID NOT IN
	(SELECT lgID from League)

--- Fixing Errors ---
INSERT INTO League (lgID)
VALUES ('ML')

--- Creating Foreign Key ---
ALTER TABLE AwardsManagers ADD FOREIGN KEY(lgID) REFERENCES League (lgID)


--- Foreign Key 6.2 ---
--- column name : PlayerID ---
--- primary key table : People ---
--- foreign key table : AwardsManagers  ---

ALTER TABLE AwardsManagers ADD FOREIGN KEY(playerID) REFERENCES People (playerID)















