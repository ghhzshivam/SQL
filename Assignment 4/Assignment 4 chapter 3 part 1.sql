--Chapter 3 SQL Assignment � Part 1

USE [Spring_2023_BaseBall]
-- 1. Using the Pitching table, write a query that select the playerid, teamid, Wins (W), Loss (L) and Earned Run Average (ERA) for every player (Slide 15). This query should return 49,430 rows.

select playerID,teamID,W,L,ERA from Pitching;


-- 2. Modify the query you wrote in #1 to be sorted by playerid in descending order and the teamid in ascending order (Slide 34). This query should return 49,430 rows.

select playerID, teamID,W,L,ERA from pitching order by playerID desc,teamid;


-- 3. You decide you want to know the name of every team and the park they played in. Using the TEAMS table write a query that returns the team name (name) and the park name (park) sorted by the team name in ascending order. Your query should return only 1 row for each team name and park combination (Slide 16 Distinct ). This query should return 321 rows.

select distinct(name),park from teams order by name asc;


-- 4. A friend is wonder how many bases a player �touches� in a given year. Write a query using the BATTING that calculates the bases touched for each player and team they played for each year they played. You can calculate this by multiplying B2 *2, B3*3 and HR *4 and then adding all these calculated values to the values in BB and H. (Slide 17) Rename the calculated column Total_Bases_Touched. Your output should include the playerid, yearid and teamid in addition to the Totlal_Bases_Touched column. This query should return 110,495 rows.

SELECT playerID, yearID, teamID, ((B2 * 2) + (B3 * 3) + (HR * 4) + BB)+ H AS Total_Bases_Touched FROM Batting;


-- 5. Since we are in the New York area, we�re only interested in the NY teams, Modify the query you wrote for #4 by adding a where statement (Slide 22) that only select the 2 NY teams, the Yankees and the Mets  (Teamid equals NYA or NYN) so that only the information for the NY teams is returned.  Your results must be sorted by Total_Bases_Touched in descending order then by the playerid in ascending order. This query should return 7,140  rows.

SELECT playerID, yearID, teamID, ((B2 * 2) + (B3 * 3) + (HR * 4) + BB)+ H AS Total_Bases_Touched FROM Batting
where teamID in ('NYA','NYN')
order by Total_Bases_Touched desc,playerID;


-- 6. Your curious how a player�s �bases touched �compares to the teams for a given year. You do this by adding the Teams table to the query (Slide 24) and calculating a Teams_Bases_Touched columns using the same formula for the H, HR, BB, B2 and B3 columns in the teams table. You also want to know the percentage of the teams touched bases each payer was responsible for. Calculated the Touched_% column and use the FORMAT statement for show the results as a % and with commas (Slide 20 and 29). Only select the 2 NY teams, the Yankees and the Mets (Teamid equals NYA or NYN) so that only the information for the NY teams is returned. Write your query with a FROM statement that uses the format FROM BATTING, TEAMS. The FROM parameter should be in the format FROM table1, table2 and the join parameters need to be in the WHERE parameter. Your results should be sorted by Touched_% in descending order then by playerid in ascending order. Your query should return 7,140 rows.

SELECT playerID, yearID, teamID, ((B2 * 2) + (B3 * 3) + (HR * 4) + BB)+ H AS Total_Bases_Touched FROM Batting
where teamID in ('NYA','NYN') order by Total_Bases_Touched desc,playerID;


-- 6. Your curious how a player�s �bases touched �compares to the teams for a given year. You do this by adding the Teams table to the query (Slide 24) and calculating a Teams_Bases_Touched columns using the same formula for the H, HR, BB, B2 and B3 columns in the teams table. You also want to know the percentage of the teams touched bases each payer was responsible for. Calculated the Touched_% column and use the FORMAT statement for show the results as a % and with commas (Slide 20 and 29). Only select the 2 NY teams, the Yankees and the Mets (Teamid equals NYA or NYN) so that only the information for the NY teams is returned. Write your query with a FROM statement that uses the format FROM BATTING, TEAMS. The FROM parameter should be in the format FROM table1, table2 and the join parameters need to be in the WHERE parameter. Your results should be sorted by Touched_% in descending order then by playerid in ascending order. Your query should return 7,140 rows.

SELECT B.playerID, B.yearID, B.teamID, ((B.B2 * 2) + (B.B3 * 3) + (B.HR * 4) + B.BB)+ B.H AS Total_Bases_Touched ,T.Teams_Total_Bases_Touched from Batting B, 
(SELECT teamID, yearID,( H+ HR*4+BB+ B2*2 + B3*3) AS Teams_Total_Bases_Touched  from Teams) T
 where B.yearID = T.yearID
 and B.teamID = T.teamID
 AND B.teamID in ('NYA','NYN')
 order by Teams_Total_Bases_Touched DESC, playerID


-- 7.	Rewrite the query in #6 using a JOIN parameter in the from statement. The results will be the same. 

SELECT B.playerID, B.yearID, B.teamID, ((B.B2 * 2) + (B.B3 * 3) + (B.HR * 4) + B.BB)+ B.H AS Total_Bases_Touched ,T.Teams_Total_Bases_Touched from Batting B
left join (SELECT teamID, yearID, ( H+ HR*4+BB+ B2*2 + B3*3) AS Teams_Total_Bases_Touched  from Teams) T
 on  B.teamID = T.teamID
 and B.yearID = T.yearID
 where B.teamID in ('NYA','NYN')
 order by Teams_Total_Bases_Touched DESC, playerID


-- 8.	Using the PEOPLE table, write a query lists the playerid, the first, last and given names for all players that use their initials as their first name (Hint: nameFirst or namegiven contains at least 1 period(.)(See slide 32). Examples would be Thomas J. ( Tom ) Doran and David Jonathan ( J. D. ) Drew. Also, concatenate the nameGiven, nameFirst and nameLast into an additional single column called Full Name putting the nameFirst in parenthesis. For example: James (Jim) Markulic (Slide 35) and their batting average for each year. Batting Average is calculated using H/AB from the batting table. The batting_average needs to be formatted with 4 digits behind the decimal point (research Convert to decimal using Google).  Only select the Boston Red Sox and the NY Giants  (teamids BOS and NY1) . I did not include null batting averages  and my query returned 152 rows. If you use a nullif in the batting average calculation, your query will return 159 rows.

select P.playerID, nameGiven + ' ( ' + nameFirst + ' ) ' + nameLast as Fullname, B.Batting_Average  from People p,
(select playerID, teamID,  CONVERT(DECIMAL(5,4), (H*1.0/AB)) AS Batting_Average  from batting where AB>0) B
where P.playerID = B.playerID
	and P.namegiven+P.nameFirst like ('%.%')
	and B.teamID in ('BOS', 'NY1')


-- 9.	Using a Between clause in the where statement (Slide 38) to return the same data as #8, but only where the batting averages that are between .2 and .4999. The results need also the teamid and yearid added and are to be sorted by batting_average in descending order and then playerid and yearid in ascending order. Your query should return 93 rows

select P.playerID, nameGiven + ' ( ' + nameFirst + ' ) ' + nameLast as Fullname, B.teamID, yearID, Batting_Average  from People p,
(select playerID, teamID, yearID,  CONVERT(DECIMAL(5,4), (H*1.0/AB)) AS Batting_Average  from batting where AB>0) B
where P.playerID = B.playerID
	and P.namegiven+P.nameFirst like ('%.%')
	and B.teamID in ('BOS', 'NY1')
	and B.Batting_Average between .2 and .499
ORDER BY B.Batting_Average DESC, playerID, yearID


--10.	Now you decide to pull all the information you�ve developed together. Write a query that shows the player�s Total_bases_touched from question #5, the batting_averages from #9 (between .2and .4999) and the player�s name as formatted in #8. You also want to add the teamid and the team�s batting average for the year. The teams batting average should 
-- be calculated using the columns with the same names, but from the TEAMS table.  As a final piece of information, calculate the percentage of the team�s batting average divided by the player�s batting average. Also replace the Teamid with the team name in your ourput. Note, a percentage over 100% indicates the player is better than the average batter on the team.  
-- Additionally, rename the tables to only use the first letter of the table so you can use that the select and where statement (ex: FROM TEAMS T). This saves a considerable amount of typing and makes the query easier to read. Order the results by batting average in descending order then playerid and yearid id ascending order. Also, eliminate any results where the player has an AB less than 50. Your query should return 44,493 rows. 

select P.playerID, nameGiven + ' ( ' + nameFirst + ' ) ' + nameLast as Fullname, B.yearID, T.Team_Name,B.Batting_Average, 
B.Total_Bases_Touched, T.Team_Batting_Average, CAST(CONVERT(decimal(5,2), (B.Batting_Average/T.Team_Batting_Average)*100 ) as varchar(8)) + '%' AS Team_BA_percentage
from People p,
(select playerID, teamID,AB, yearID, ((B2 * 2) + (B3 * 3) + (HR * 4) + BB)+ H AS Total_Bases_Touched, 
	CONVERT(DECIMAL(5,4), (H*1.0/AB)) AS Batting_Average  from batting where AB>0) B, --and AB < 50) B,
(select teamid,name as Team_Name, AB,yearID,CONVERT(DECIMAL(5,4), (H*1.0/AB)) AS Team_Batting_Average from Teams) T
	where P.playerID = B.playerID
	and T.teamID = B.teamID
	and T.yearID = B.yearID
	and B.Batting_Average between .2 and .499
order by B.Batting_Average DESC, P.playerID, B.yearID


