Assignment 5

-- Using database
Use Spring_2023_BaseBall;

-- Q1 
-- Write a query that lists the playerid, birthcity, birthstate, Hits (H), At Bats (AB), salary and batting average for all players born in New Jersey sorted by first name and year in ascending order using the PEOPLE, SALARIES and BATTING tables. The joins must be made using the WHERE clause. Make sure values are properly formatted.
-- Note: your query should return 362 rows using the where statement to resolve divide by zero error or 453 rows using nullif. Also note that the order of the tables will give you different numbers of result rows.

select P.playerId, P.birthcity, P.birthstate, S.teamID, B.h, B.AB, B.yearID, FORMAT(salary, 'C', 'en-us') AS salary , CONVERT(DECIMAL(5,4), (H*1.0/AB)) AS [Batting Average] 
from People P, Salaries S, Batting B
where P.playerID = S.playerID
	AND B.AB > 0
	AND P.playerID = B.playerID
	AND S.salary > 0
	AND S.yearID = B.yearID
	AND S.teamID = B.teamID
	AND P.birthState = 'NJ'
ORDER BY P.nameFirst, S.yearID

--Q2
-- Write the same query as #2 but use LEFT JOINs using the PEOPLE table first. This time, sort by salary in descending order and then by first name and year in ascending order.    
select P.playerId, P.birthcity, P.birthstate, P.birthYear, B.yearID, 
FORMAT(salary, 'C', 'en-us') AS salary , CONVERT(DECIMAL(5,4), (H*1.0/AB)) AS [Batting Average]
from People P
left JOIN Salaries S ON P.playerID = S.playerID
left JOIN Batting B ON  P.playerID = B.playerID AND S.yearID = B.yearID AND S.teamID = B.teamID
WHERE P.birthState = 'NJ' AND B.AB > 0 AND S.salary > 0
ORDER BY S.salary desc, P.nameFirst, S.yearID

-- Q3
-- You get into a debate regarding the level of school that professional sports players attend. Your stance is that there are plenty of baseball players who attended Ivy League schools and were good batters in addition to being scholars. Write a query to support your argument using the CollegePlaying and HallofFame tables. You must use an IN clause in the WHERE clause to identify the Ivy League schools. Only include players that were indicted into the HallofFame (Inducted = Y). Your answer should return 2 rows and contain the columns below.  Note the yearid is the year for the batting average not the year in College Playing. The colleges in the Ivy League are Brown, Columbia, Cornell, Dartmouth, Harvard, Princeton, UPenn, and Yale. You will need to use the HallofFame and COLLEGEPLAYING tables.

Select DISTINCT playerID, schoolID from CollegePlaying
where  playerID in (select playerID from HallOfFame where inducted = 'Y')
	AND schoolID IN ('brown', 'columbia', 'cornell', 'dartmouth',  'princeton',  'UPenn', 'yale')

-- Q4
--You are now interested in the longevity of players careers. Using the BATTING table and the appropriate SET clause from slide 45 of the Chapter 3 PowerPoint presentation, find the players that played for the same teams in 2016 and 2021. Your query only needs to return the playerid and teamids. The query should return 138 rows.

(select playerID, teamID from BATTING where yearID=2016)
intersect
(select playerID, teamID from BATTING where yearID=2021)

-- Q5
-- Using the BATTING table and the appropriate SET clause from slide 45 of the Chapter 3 PowerPoint presentation, find the players that played for the different teams in 2016 and 2021 Your query only needs to return the playerids and the 2016 teamid. The query should return 1,344 rows.

(select playerID, teamID from BATTING where yearID=2016)
except
(select playerID, teamID from BATTING where yearID=2021)

-- Q6
-- Using the Salaries table, calculate the average and total salary for each player. Make sure the amounts are properly formatted and sorted by the total salary in descending order. Your query should return 6,246 rows.

select playerid, FORMAT(avg(salary), 'C', 'en-us') as Average_salary, 
FORMAT(sum(salary), 'C', 'en-us') as Total_salary from Salaries
GROUP BY playerID
ORDER BY sum(salary) DESC

-- Q7
-- Using the Batting  and People tables and a HAVING clause, write a query that lists the playerid, the players full name, the number of home runs (HR) for all players having more than 400 home runs and the number of years they played. The query should return 57 rows.

SELECT X.playerId, [Full Name], [Total Home Runs], [Years Played]
FROM (SELECT playerID, CONCAT(nameFirst, ' ( ', nameGiven,' ) ', nameLast) AS [Full Name] FROM People) X,
	 (SELECT P.playerID, SUM(B.HR) as [Total Home Runs], COUNT(yearID) AS [Years Played] FROM People P
		JOIN Batting B ON P.playerID = B.playerID  GROUP BY P.playerID  HAVING SUM(HR) > 400) Y
	WHERE X.playerID = Y.playerID
	ORDER BY [Total Home Runs] DESC

-- Q8 
-- Hitting 500 home runs is a hallmark achievement in baseball. You want to project if the players with under 500 but more than 400 home runs will have over 500 home runs, assuming they will play for a total of 22 years like the top players in question 7. To create your estimates, divide the total number of home runs by the years played and multiply by 22. Use a BETWEEN clause in the HAVING statement to identify players having between 400 and 499 home runs.  Only include playeris you estimate will reach the 500 HR goal. This will return 18 rows

select X.playerID, p.namegiven + ' (' + p.namefirst + ') ' + p.namelast AS [Full Name],
 X.Total_HR, X.Years_played, X.Projected_HR
from (
select playerid,  (sum(HR)/count(yearid))* 22 as Projected_HR, sum(HR) as Total_hr, count(yearid) as Years_played from Batting
group by playerid
having sum(hr) between 400 and 500
and (sum(HR)/count(yearid))* 22 > 500) X
join People P on p.playerID = X.playerID
order by X.Total_hr desc


-- Q9 
-- Using a subquery along with an IN clause in the WHERE statement, write a query that identifies all the playerids, the players full name and the team names who in 2021 that were playing on teams that existed prior to 1910. You should use the appearances table to identify the players years and the TEAMS table to identify the team name. Sort your results by players last name. Your query should return 613 rows.
SELECT A.playerID, CONCAT(nameFirst, ' ( ',nameGiven , ' ) ', nameLast) AS [Full Name], teamID 
FROM APPEARANCES A
JOIN People P ON A.playerID = P.playerID
WHERE yearID = 2021 
AND teamID IN (SELECT teamID FROM TEAMS WHERE yearID < 1910)
ORDER BY nameLast;

-- Q10 
-- Using the Salaries table, find the players full name, average salary and the last year they played  for each team they played for during their career. Also find the difference between the players salary and the average team salary. You must use subqueries in the FROM statement to get the team and player average salaries and calculate the difference in the SELECT statement. Sort your answer by the last year in descending order , the difference in descending order and the playerid in ascending order. The query should return 12,928 rows

SELECT Person.playerID, [Full Name], t.teamID, [Last Year], format([Player Average], 'c') as [Player Average], 
	 format([Team Average], 'C') as [Team Average], format([Player Average]-[Team Average], 'C') as [Difference]
FROM (SELECT teamID, avg(salary) as [Team Average] from Salaries group by teamID) t,
	 (SELECT teamID, playerID, avg(salary) as [Player Average], max(yearId) AS [Last Year]
		from Salaries group by teamID, playerID) p,
	 (SELECT  playerID, namegiven + ' (' + namefirst + ') ' + namelast AS [Full Name]
		 from People group by playerID, namegiven + ' (' + namefirst + ') ' + namelast ) Person
WHERE t.teamID = p.teamID
	  AND Person.playerID = p.playerID
ORDER BY [Last Year] DESC, [Difference] DESC ,playerID


-- Q11
--Rewrite the query in #11 using a WITH statement for the subqueries instead of having the subqueries in the from statement. The answer will be the same. Please make sure you put a GO statement before and after this problem. 5 points will be deducted if the GO statements are missing and I have to add them manually

With t as
	(SELECT teamID, avg(salary) as [Team Average] from Salaries group by teamID),
	p as
	(SELECT teamID, playerID, avg(salary) as [Player Average], max(yearId) AS [Last Year]
		from Salaries group by teamID, playerID),
	person as
	(SELECT  playerID, namegiven + ' (' + namefirst + ') ' + namelast AS [Full Name]
		 from People group by playerID, namegiven + ' (' + namefirst + ') ' + namelast )
SELECT person.playerID, [Full Name], t.teamID, [Last Year], format([Player Average], 'c') as [Player Average], 
	 format([Team Average], 'C') as [Team Average] , format([Player Average]-[Team Average], 'C') as [Difference]
FROM t, p, person
WHERE t.teamID = p.teamID
	  AND Person.playerID = p.playerID
ORDER BY [Last Year] DESC, [Difference] DESC ,playerID

-- Q13 
-- The player’s union has negotiated that players will start to have a 401K retirement plan. Using the [401K Contributions] column in the Salaries table,  populate this column for each row by updating it to contain 6% of the salary in the row. You must use an UPDATE query to fill in the amount. This query updates 32,862 rows. Use the column names given, do not create your own columns. Include a select query with the results sorted by playerid as part of your answer that results the rows shown below.

ALTER TABLE Salaries
ADD [401K Contributions] [int]
GO
UPDATE Salaries SET [401K Contributions] = salary * 0.06 

Select playerid, salary, [401k Contributions] from Salaries
ORDER BY playerID

-- Q14
-- Contract negotiations have proceeded and now the team owner will make a seperate contribution to each players 401K each year. If the player’s salary is under $1 million, the team will contribute another 5%. If the salary is over $1 million, the team will contribute 2.5%. You now need to write an UPDATE query for the [401K Team Contributions] column in the Salaries table to populate the team contribution with the correct amount. You must use a CASE clause in the UPDATE query to handle the different amounts contributed. This query updates 32,862 rows.

ALTER TABLE Salaries
ADD  [401K Team]  [int]
GO

UPDATE Salaries
SET [401K Team] = (
CASE 
WHEN (salary <1000000) THEN salary*0.05
WHEN (salary >= 1000000) THEN salary*0.025
ELSE NULL
END)
Select playerid, salary, [401k Contributions], [401K Team] from Salaries
ORDER BY playerID
 

-- Q15
-- You have now been asked to populate the columns to the PEOPLE table that contain the total number of HRs hit ( Total_HR column) by the player and the highest Batting Average the player had during any year they played ( High_BA column). Write a single query that correctly populates these columns. You will need to use a subquery to make is a single query. This query updates 17,593 rows if you use AB > 0 in the where statement. It updates 19,898 rows in nullif is used for batting average. After your update query, write a query that shows the playerid, Total HRs and Highest Batting Average for each player. The Batting Average must be formatted to only show 4 decimal places. Sort the results by playerid. The update query will update 17841 rows and the select query will return 20,370 rows.

ALTER TABLE People
ADD Total_HR int,
    Career_BA decimal(6,4)
GO
BEGIN TRAN
UPDATE People
	SET Total_HR =  (SELECT sum(HR) FROM Batting B WHERE B.playerID = P.playerID GROUP BY playerID)
		 FROM Batting B,People P 
		 WHERE P.playerID = B.playerID

COMMIT
BEGIN TRAN
UPDATE People
	SET Career_BA =  (select max(CONVERT(DECIMAL(5,4), (B.H*1.0/B.AB))) AS [Batting Average] FROM Batting B WHERE B.playerID = P.playerID and B.AB>0 GROUP BY playerID, yearID)
		FROM Batting B,People P 
		WHERE P.playerID = B.playerID AND
		B.AB > 0
COMMIT TRAN

SELECT playerID, Total_HR, Career_BA FROM People
ORDER BY playerID

-- Q16
--  You have also been asked to populate a column in the PEOPLE table ( Total_401K column) that contains the total value of the 401K for each player in the Salaries table.  Write the SQL that correctly populates the column. This query updates 5,981 rows.  Also, include a query that shows the playerid, the player full name and their 401K total from the people table. Only show players that have contributed to their 401Ks. Sort the results by playerid. . This query returns 5,981 rows. 

BEGIN
    ALTER TABLE People
    ADD [401K Total] [int]	
END
GO
BEGIN TRAN
UPDATE People
	SET [401K Total] =  (SELECT sum([401k Contributions])+sum([401K Team]) FROM Salaries S 
		WHERE S.playerID = P.playerID GROUP BY playerID)
		 FROM Salaries S,People P 
		 WHERE P.playerID = S.playerID

SELECT playerid, CONCAT(nameFirst, ' ( ', nameGiven,' ) ', nameLast) AS [Full Name],
[401K Total] FROM People

WHERE playerID in (SELECT playerID FROM Salaries WHERE [401K Contributions] > 0)
ORDER BY playerid


-- Q18
-- ⦁	As with any job, players are given raises each year, write a query that calculates the increase each player received and calculate the % increase that raise makes. You will only need to use the SALARIES  and PEOPLE tables. You answer should include the columns below. Include the players full name and sort your results by playerid in ascending order and year in descending order. This query returns 15,569 rows. You cannot use advanced aggregate functions such as LAG for this question. The answer can be written using only the SQL parameters you learned in this chapter.

Select People.playerID, 
	   namegiven + ' (' + namefirst + ') ' + namelast AS [Full Name],
	   yearID,
       FORMAT(salary, 'C') as [Current Salary], 
	   FORMAT(lag(salary)  over (partition by Salaries.playerID order by yearID),'C') AS [Prior Salary],
       FORMAT(salary - lag(salary) over (partition by Salaries.playerID order by yearID),'C') AS [Salary Difference],
	   FORMAT((salary - lag(salary) over (partition by Salaries.playerID order by Salaries.playerID))/salary,'P')
			AS [Salary Increase]
from Salaries, People
WHERE People.playerID = Salaries.playerID AND salary>0
ORDER BY playerID, yearID DESC



