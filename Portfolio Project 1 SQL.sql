SELECT *
FROM [Portfolio Project 1]..CovidDeaths
Order By 3,4

Select * 
From [Portfolio Project 1]..CovidVaccines
Order By 3,4

--Select Data that I will be using

Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project 1].. CovidDeaths
order by 1,2

--Looking at Total Cases vs Population in Chad AND Afghanistan
-- Shows what perecentage of both populations got Covid

Select Location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
From [Portfolio Project 1].. CovidDeaths
WHERE Location = 'Afghanistan'
Order by 1,2

Select Location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
From [Portfolio Project 1].. CovidDeaths
WHERE Location = 'Chad'
Order by 1,2


--Looking at what countries have the highest infection rate compared to Population

Select Location, MAX(total_cases) AS HighestInfectionCount, population, MAX((total_cases/population))*100 as PercentagePopulationInfected
From [Portfolio Project 1].. CovidDeaths
Group by location, population
Order by 1,2

--changing the order

Select Location, MAX(total_cases) AS HighestInfectionCount, population, MAX((total_cases/population))*100 as PercentagePopulationInfected
From [Portfolio Project 1].. CovidDeaths
Group by location, population
Order by PercentagePopulationInfected DESC

-- The highest is Andorra at an astonishing rate of over 17%


--Looking at Total Population vs Vaccinations; the 'dea' and 'vac' specifies which table we are looking at or else there will be an error
SELECT *
FROM [Portfolio Project 1]..CovidDeaths dea
JOIN [Portfolio Project 1]..CovidVaccines vac
ON dea.location = vac.location
AND dea.date = vac.date


SELECT dea.continent, dea.location, dea.date, vac.new_vaccinations
FROM [Portfolio Project 1]..CovidDeaths dea
JOIN [Portfolio Project 1]..CovidVaccines vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
order by 2,3


--Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition by dea.location)
FROM [Portfolio Project 1]..CovidDeaths dea
JOIN [Portfolio Project 1]..CovidVaccines vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
order by 2,3

--including the order by location AND DATE gives us specifics 

SELECT dea.continent, dea.location, dea.date, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM [Portfolio Project 1]..CovidDeaths dea
JOIN [Portfolio Project 1]..CovidVaccines vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
order by 2,3



--USING A CTE

WITH PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM [Portfolio Project 1]..CovidDeaths dea
JOIN [Portfolio Project 1]..CovidVaccines vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100 
FROM PopVsVac

-- 12% of Albania is vaccinated


--Creating views to store for later data visualisations
-- Views are like miniature tables of specified data used for visualsations (just easier access than writing new queries)
CREATE VIEW PopVsVac as
SELECT dea.continent, dea.location, dea.date, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM [Portfolio Project 1]..CovidDeaths dea
JOIN [Portfolio Project 1]..CovidVaccines vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3


CREATE VIEW HighestInfectionCount as
Select Location, MAX(total_cases) AS HighestInfectionCount, population, MAX((total_cases/population))*100 as PercentagePopulationInfected
From [Portfolio Project 1].. CovidDeaths
Group by location, population
--Order by PercentagePopulationInfected DESC


CREATE VIEW DeathPercentage as
Select Location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
From [Portfolio Project 1].. CovidDeaths
WHERE continent LIKE '%Africa'
--Order by 1,2