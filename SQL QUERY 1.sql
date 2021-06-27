SELECT *
FROM newproject..covid_death
ORDER BY 3,4;



SELECT *
FROM newproject..covidvaccination
ORDER BY 3,4;

SELECT location, date, total_cases,total_deaths, population
FROM Newproject..covid_death
ORDER BY 1,2

--looking at total case vs total death next

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) AS death_percentage
FROM Newproject..covid_death
ORDER BY 1,2 ;

--lets convert to percentage to see what is the death percent if you get covid

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 AS death_percentage
FROM Newproject..covid_death
ORDER BY 1,2 ;

--to see covid cases from india

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 AS death_percentage
FROM Newproject..covid_death
WHERE location LIKE 'india%'
ORDER BY 1,2 ;


-- what percentage of population got covid

SELECT location, date, total_cases,total_deaths, (total_cases / population) * 100 AS Percentage_of_cases
FROM Newproject..covid_death
ORDER BY 1,2;

-- -- what percentage of population got covid IN INDIA


SELECT location, date, total_cases,total_deaths, (total_cases / population) * 100 AS Percentage_of_cases
FROM Newproject..covid_death
WHERE location LIKE 'india%'
ORDER BY 1,2;

-- we are looking at the highest percentage of covid cases from all over world

SELECT location, population, MAX(total_cases) AS  HIGHEST_CASE ,MAX((total_cases/population))*100 AS Percentage_of_cases
FROM Newproject..covid_death
GROUP BY location, population
ORDER BY 4 DESC;


-- highest number of death across country

SELECT location, MAX(cast(total_deaths AS int)) AS total_deathcount
FROM Newproject..covid_death
WHERE continent is null
GROUP BY location
ORDER BY total_deathcount DESC;

-- cases across globe

SELECT date, 
SUM(CAST(new_cases AS int)) as totalcase, 
SUM(CAST(new_deaths AS INT)) AS totaldeath, 
SUM(CAST(new_deaths AS INT)) / SUM(new_cases) *100 as death_percentage
FROM Newproject..covid_death
WHERE continent is not null
GROUP BY date
ORDER BY 1,2 ;

-- total death percentage all over the world

SELECT  
SUM(CAST(new_cases AS int)) as totalcase, 
SUM(CAST(new_deaths AS INT)) AS totaldeath, 
SUM(CAST(new_deaths AS INT)) / SUM(new_cases) *100 as death_percentage
FROM Newproject..covid_death
WHERE continent is not null;

SELECT * FROM Newproject..covidvaccination

-- Lets see vaccination details from another table

SELECT * 
FROM Newproject..covid_death  AS death
JOIN Newproject..covidvaccination  AS vaccination
ON death.date = vaccination.date
AND death.location = vaccination.location;


-- LETS SEE TOTAL VACCINATION

SELECT vaccination.location, 
vaccination.date, 
population, 
vaccination.total_vaccinations
FROM Newproject..covid_death  AS death
JOIN Newproject..covidvaccination  AS vaccination
ON death.date = vaccination.date
AND death.location = vaccination.location
WHERE death.continent IS NOT NULL 
order by 1,2,3;

--lets look total vaccination all over india (we can also select a particular country)

SELECT vaccination.location, 
vaccination.date, 
population, 
vaccination.total_vaccinations as vaccination_perday
FROM Newproject..covid_death  AS death
JOIN Newproject..covidvaccination  AS vaccination
ON death.date = vaccination.date
AND death.location = vaccination.location
WHERE death.continent IS NOT NULL 
AND death.location LIKE 'india%'
order by 1,2,3;



-- TO GET MORE CLEAR PICTURE

SELECT vaccination.location, 
vaccination.date, 
population, 
vaccination.total_vaccinations as vaccination_perday
FROM Newproject..covid_death  AS death
JOIN Newproject..covidvaccination  AS vaccination
ON death.date = vaccination.date
AND death.location = vaccination.location
WHERE death.continent IS NOT NULL 
AND death.location LIKE 'india%'
AND vaccination.total_vaccinations IS not null
order by 1,2,3;

-- lets add a windows function

SELECT vaccination.location, 
vaccination.date, 
population, 
vaccination.total_vaccinations as vaccination_perday,
SUM(CAST(vaccination.new_vaccinations AS INT)) OVER(PARTITION BY vaccination.location),
vaccination.total_vaccinations
FROM Newproject..covid_death  AS death
JOIN Newproject..covidvaccination  AS vaccination
ON death.date = vaccination.date
AND death.location = vaccination.location
WHERE death.continent IS NOT NULL 
AND vaccination.total_vaccinations IS not null
order by 1,2,3;



SELECT vaccination.location, 
vaccination.date, 
population, 
vaccination.total_vaccinations as vaccination_perday,
SUM(CAST(vaccination.new_vaccinations AS INT)) OVER(PARTITION BY vaccination.location ORDER BY vaccination.location, vaccination.date),
vaccination.total_vaccinations
FROM Newproject..covid_death  AS death
JOIN Newproject..covidvaccination  AS vaccination
ON death.date = vaccination.date
AND death.location = vaccination.location
WHERE death.continent IS NOT NULL 
AND vaccination.total_vaccinations IS not null
order by 1,2;
