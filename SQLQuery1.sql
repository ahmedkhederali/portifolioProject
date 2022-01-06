select *
from portifolio..covidDeath
where continent is not null
order by 3,4
--select  Data  from covidVacination
select *
from portifolio..covidVacination
where continent is not null
order by 3,4


select *
from portifolio..covidVacination
where continent is not null  
and location  like '%egy%'
order by 3,4

--select  Data  from covidDeath

select *
from portifolio..covidDeath
where continent is not null  
and location  like '%egy%'
order by 3,4

--select  Data  that we are going to using 

select location ,date,total_cases,new_cases,total_deaths,population
from portifolio..covidDeath
where continent is not null
order by 1,2

-- total cases VS total death

select location ,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
from portifolio..covidDeath
where location like '%egy%'
and continent is not null
order by 1,2

-- total cases VS  population
select location ,date,population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
from portifolio..covidDeath
where location like '%egy%'
order by 1,2 

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population)*100) as PercentPopulationInfected
From portifolio..covidDeath
--Where location like '%egy%'
Group by Location, Population
order by PercentPopulationInfected desc



-- Countries with Highest Death Population
--casting to convert data type of column 

Select Location, Population, MAX(cast(total_deaths as int)) as HighestTotalDeathCount 
From portifolio..covidDeath
--Where location like '%egy%'
where continent is not null
Group by Location, Population
order by HighestTotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) as HighestTotalDeathCount 
From portifolio..covidDeath
where continent is not null
Group by continent
order by HighestTotalDeathCount desc


-- Showing contintents with the highest Infected count per population

Select continent, MAX(cast(total_cases as int)) as HighestTotalInfectedCount 
From portifolio..covidDeath
where continent is not null
Group by continent
order by HighestTotalInfectedCount desc



--global number


select date , sum(new_cases) as total_cases , sum( cast(new_deaths as int)) as total_depth , sum(cast(new_deaths as int))/sum(new_cases) *100 as DeathPercentage
from portifolio..covidDeath
where continent is not null
group by date
order by 1,2


-- join tables 

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From portifolio..covidDeath dea
Join portifolio..covidVacination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From portifolio..covidDeath dea
Join portifolio..covidVacination vac
	On dea.location = vac.location
	and dea.date = vac.date

Select *
From #PercentPopulationVaccinated
