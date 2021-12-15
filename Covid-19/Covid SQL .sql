-- Getting the CovidDeaths Table
SELECT * FROM CovidProject..CovidDeaths
ORDER BY 1;

-- Getting the CovidVaccination Table
SELECT * FROM CovidProject..CovidVaccination
ORDER BY 1;


-- Finding the probability of dying if people get COVID
SELECT 
  location, 
  date, 
  population, 
  total_cases, 
  total_deaths, 
  ROUND((total_deaths / total_cases), 4)* 100 as deathpercentage, -- Getting the likelihood of dying if you caught COVID19
  ROUND((total_cases/population),5)*100 percentageofpeopleinfected -- Getting the percentage of people infected
FROM 
  CovidProject..CovidDeaths 
  ORDER BY date ASC


-- Finding the percentage of people infected in each country
SELECT 
  location, 
  population, 
  MAX(total_cases) as total_cases, 
  MAX(CAST(total_deaths as int)) as total_deaths,
  MAX(ROUND((total_cases/population),4)*100) as percentageofpeopleinfected -- Getting the percentage of people infected
FROM CovidProject..CovidDeaths 
--  WHERE location LIKE '%India%'
  GROUP BY location,population
  ORDER BY percentageofpeopleinfected DESC



-- Probability of dying if you get Covid19
SELECT 
  location, 
  population, 
  MAX(total_cases) as total_cases, 
  MAX(CAST(total_deaths as int)) as total_deaths,
  MAX(ROUND((total_deaths / total_cases), 6)* 100) as deathpercentage -- Getting the likelihood of dying if you caught COVID19
FROM CovidProject..CovidDeaths 
--  WHERE location LIKE '%India%'
  GROUP BY location,population
  ORDER BY deathpercentage DESC


-- The day when highest number of Covid deaths recorded
SELECT   
  date,
  population, 
  MAX(total_cases) as total_cases, 
  MAX(CAST(total_deaths as int)) as total_deaths
FROM CovidProject..CovidDeaths 
  WHERE location LIKE '%India%'
  GROUP BY date,population
  ORDER BY total_deaths DESC


-- Finding the percentage of people fully vaccinated 
SELECT location,
	MAX(people_fully_vaccinated) as people_fully_vaccinated,
	MAX(population) as population,
	MAX(ROUND((people_fully_vaccinated/population),4)*100) as percentageofpeoplevaccinated
FROM CovidProject..CovidVaccination
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY population DESC


-- Getting the data together
CREATE VIEW Covid19 as
SELECT CD.date,
	CD.location,
	CD.population,
	CD.total_cases,
	CD.new_cases,
	CD.total_deaths,
	CD.new_deaths,
	ROUND((CD.total_deaths / CD.total_cases), 4)* 100 as deathpercentage, -- Getting the likelihood of dying if you caught COVID19
    ROUND((CD.total_cases/CD.population),5)*100 as percentageofpeopleinfected, -- Getting the percentage of people infected
	CV.tests_units,
	CV.total_vaccinations,
	CV.people_vaccinated,
	ROUND((CV.people_fully_vaccinated/CD.population),4)*100 as percentageofpeoplevaccinated, -- Getting the percentage of people fully vaccinated 
	CV.people_fully_vaccinated,
	CV.total_boosters,
	CV.new_vaccinations

FROM CovidProject..CovidDeaths AS CD
JOIN CovidProject..CovidVaccination AS CV ON CD.date = CV.date and CD.location = CV.location

-- Splitting the columns into different table for the needs of dashboards
-- 
SELECT location,
date,
MAX(population) as population,
MAX(total_cases) as total_cases,
MAX(total_deaths) as total_deaths,
MAX(total_vaccinations) as total_vaccinations,
MAX(people_fully_vaccinated) as people_fully_vaccinated,
MAX(people_vaccinated) as people_vaccinated
FROM Covid19
GROUP BY location, date

SELECT population From Covid19
