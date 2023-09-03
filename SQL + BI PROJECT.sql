create database project;
Use project;
select * from hr;

Alter Table hr
Change column ï»¿id emp_id varchar (20) null;
Describe hr;
select birthdate, hire_date, termdate from hr;
Set sql_safe_updates =0;
UPDATE hr
SET birthdate = CASE
WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'m/%d/%Y'),'%Y-%m-%d')
WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
ELSE NULL
END;

AlTER TABLE hr
MODIFY COLUMN birthdate DATE;
SELECT birthdate FROM hr;
SELECT hire_date FROM hr;

UPDATE hr
SET hire_date = CASE
WHEN  hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

SET sql_mode='';
SET sql_mode = 'NO_ZERO_DATE';
SET sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO';
SET sql_mode = '';

UPDATE hr
SET termdate = '0000-00-00'
WHERE termdate IS NULL;

SELECT termdate FROM hr;

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

SELECT age FROM hr;

ALTER TABLE hr ADD COLUMN age INT;

UPDATE hr
SET age = timestampdiff(YEAR,birthdate,CURDATE());

SELECT 
min(age) AS youngest,
max(age) AS oldest
FROM hr;

SELECT count(*) FROM hr WHERE age<18;

SELECT * FROM hr;
-- WHAT IS THE GENDER BREAKDOWN OF EMPLOYEES IN THE COMPANY?
SELECT gender,count(*) AS Count
FROM hr
WHERE age>18 AND termdate = '0000-00-00'
GROUP BY gender;

-- WHAT IS RACE & ETHINICITY BREAKDOWN OF EMPLOYEES IN THE COMPANY?
SELECT race, count(*) AS RACE_COUNT
FROM hr
WHERE age>18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY count(*)DESC;

-- WHAT IS THE AGE DISTRIBUTION OF EMPLOYEES IN COMPANY?
SELECT 
min(age) AS youngest,
max(age) AS oldest
FROM hr
WHERE age>18 AND termdate = '0000-00-00';

SELECT
CASE
WHEN age>= 18 AND age<= 24 THEN '18-24'
WHEN age>= 25 AND age<= 34 THEN '25-34'
WHEN age>= 35 AND age<= 44 THEN '35-44'
WHEN age>= 45 AND age<= 54 THEN '45-54'
WHEN age>= 55 AND age<= 64 THEN '55-64'
ELSE '65+'
END AS Age_Group,
count(*) AS Count
FROM hr
WHERE age>18 AND termdate = '0000-00-00'
GROUP BY age_group
ORDER by age_group;

 SELECT
CASE
WHEN age>= 18 AND age<= 24 THEN '18-24'
WHEN age>= 25 AND age<= 34 THEN '25-34'
WHEN age>= 35 AND age<= 44 THEN '35-44'
WHEN age>= 45 AND age<= 54 THEN '45-54'
WHEN age>= 55 AND age<= 64 THEN '55-64'
ELSE '65+'
END AS Age_Group, gender, 
count(*) AS Count
FROM hr
WHERE age>18 AND termdate = '0000-00-00'
GROUP BY age_group, gender
ORDER by age_group,gender ;

-- HOW MANY EMPLOYEES WORK AT HEADQUATERS VERSUS REMOTE
 SELECT location, count(*) AS count
 FROM hr
 WHERE age>18 AND termdate = '0000-00-00'
GROUP BY Location;

-- WHAT IS THE AVERAGE LENGHT OF EMPLOYEMENT OF EMPLOYEES WHO HAVE BEEN TERMINATED?
SELECT
 round(avg(datediff(termdate,hire_date))/365,0) AS Avg_LENGTH_EMPLOYMENT
FROM hr
WHERE termdate<=curdate() AND termdate <>'0000-00-00' AND age >=18; 

-- HOW DOES GENDER DISTRIBUTION VARY ACROSS DEPARTMENTS?
SELECT department, gender, count(*) AS count
FROM hr
WHERE age>18 AND termdate = '0000-00-00'
GROUP BY department, gender
ORDER BY department;

-- HOW DOES GENDER DISTRIBUTION VARY ACROSS JOB TITLES?
SELECT jobtitle, count(*) AS count
FROM hr
WHERE age>18 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- WHICH DEPARTMENT HAS THE HIGHEST TURNOVER RATE?
SELECT department,
total_count,
terminated_count,
terminated_count/total_count AS termination_rate
FROM(
SELECT department,
count(*) AS total_count,
SUM(CASE WHEN termdate <>'0000-00-00' AND termdate <=curdate() THEN 1 ELSE 0 END) AS terminated_count
FROM hr
WHERE age>=18
GROUP BY department) AS subquery
ORDER BY termination_rate DESC;

-- WHAT IS THE DISTRIBUTION OF EMPLOYEES ACROSS LOCATION BY CITY & STATE
SELECT location_state, count(*) AS count
FROM hr
WHERE age>=18 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY count DESC;

-- HOW HAS EMPLOYEE COUNT CHANGED OVER TIME BASED ON HIRE & TERM DATES?
SELECT
  year,
  hires,
  terminations,
  hires-terminations AS net_change,
  round(( hires-terminations)/hires*100) AS net_change_percent
FROM(
 SELECT 
  YEAR(hire_date) AS year,
  count(*) AS hires,
  SUM(CASE WHEN termdate <>'0000-00-00' AND termdate <=curdate() THEN 1 ELSE 0 END) AS Terminations
  FROM hr
  WHERE age>=18
  GROUP BY YEAR(hire_date)
  ) AS subquery
ORDER BY year ASC;

-- WHAT IS THE TENURE DISTRIBUTION OF EACH DEPARTMENT?
SELECT department, round(avg(datediff(termdate,hire_date)/365),0) AS avg_tenure
FROM hr
WHERE termdate<=curdate() AND termdate <>'0000-00-00' AND age >=18
GROUP BY department;
