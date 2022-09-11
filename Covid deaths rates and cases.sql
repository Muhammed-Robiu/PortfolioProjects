select * from portfolioproject..CovidDeaths;

select * from portfolioproject..Covidvaccination;


--selecting data considered for this project

select location, date, total_cases, new_cases, total_deaths, population
from portfolioproject..CovidDeaths
order by 1,2;

--comparing total cases vs totat death to show the probability of dying from covid.

select location,  date, total_cases, total_deaths, (total_deaths/total_cases)*100 as [death percetage]
from portfolioproject..CovidDeaths
where continent is null
order by 1,2;


--displaying death percentage result for afghanistan 
select location,  date, total_cases, total_deaths, (total_deaths/total_cases)*100 as [death percetage]
from portfolioproject..CovidDeaths
where location like '%afghanistan%' and total_deaths is not null
order by  [death percetage] desc;

--displaying death percentage result for Nigeria
select location,  date, total_cases, total_deaths, (total_deaths/total_cases)*100 as [death percetage]
from portfolioproject..CovidDeaths
where location='Nigeria' and total_deaths is not null
order by  [death percetage] desc;

--displaying cases per population percentage result for all locations 
select location,  date, total_cases, population, (total_cases/population)*100 as [cases per population]
from portfolioproject..CovidDeaths
where total_cases is not null and population is not null
order by  [cases per population] desc;


--looking at countries with highest infecton rate at a certain date 
select top(5) location, max(total_cases) as [total cases]
from portfolioproject..CovidDeaths
where continent is not null
group by location
order by [total cases] desc;

--looking at total cases per countries showing top 5
select top(5) location, sum(total_cases) as [total cases]
from portfolioproject..CovidDeaths
where continent is not null
group by location
order by [total cases] desc;

--looking at total cases per continent compared to population. 
select location, population, max(total_cases) as [total cases], max((total_cases/population))*100 as [cases per poppulation]
from portfolioproject..CovidDeaths
--where continent is null
group by location, population;


--showing continent with highest death count at a given date..
select location, max(cast(total_deaths as int)) as [death rate]
from portfolioproject..CovidDeaths
--where continent is null
group by location
order by [death rate] desc;

-- showing results for total date rate per countries.
select location, sum (cast(total_deaths as int)) as [death rate]
from portfolioproject..CovidDeaths
where continent is not null
group by location
order by 1 desc;


--showing continent with highest death rate.
select continent, max(cast(total_deaths as int)) as [death rate per contintent]
from portfolioproject..CovidDeaths
where continent is not null
group by continent
order by 2;


--showing the total death rate per continents.
select continent, sum(cast(total_deaths as int)) as [death rate per continent]
from portfolioproject..CovidDeaths
where continent is not null
group by continent
order by 2;

select continent, date, sum(total_cases) as [cases per continent],
 sum(cast(total_deaths as int)) as [death rate per continent]
from portfolioproject..CovidDeaths
where continent is not null
group by continent, date
order by 2;



--looking at global cases

select sum(new_cases) as total_cases, sum(convert(int, new_deaths)) as total_deaths,
sum(convert(int, new_deaths))/sum(new_cases)*100 as death_percentage
FROM portfolioproject..CovidDeaths
order by 1,2;


select location, date, total_cases, new_cases, total_deaths, population
from portfolioproject..CovidDeaths
where location='world' and continent is null
order by 1,2;

select location, population, sum(cast(total_deaths as int)) as [world death], sum(total_cases) as [total world cases],
sum(cast(total_deaths as int))/ sum(total_cases)*100 as [percentage death  rate]
from portfolioproject..CovidDeaths
where location='world'
group by location, population
order by 1,2;


select location, population, max(total_cases) as [total cases], max((total_cases/population))*100 as [cases per poppulation]
from portfolioproject..CovidDeaths
where location='world'
group by location, population
order by 4 desc;


--looking at total population vs total vaccination
select cd.continent,cd.location, cd.date, cd.population, cv.new_vaccinations,
sum(convert(int, cv.new_vaccinations)) over (partition by cd.location, cd.date) as [rolling vaccinatedd]
from portfolioproject..CovidDeaths cd
join portfolioproject..CovidVaccination cv
	on cd.location=cv.location and	cd.date=cv.date
--where cd.continent is not null
order by 2,3;


SELECT cd.location, cd.date, cv.total_vaccinations, cd.new_cases
--SUM(CAST(cv.new_vaccinations as int)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date)
FROM PortfolioProject..CovidDeaths cd
JOIN PortfolioProject..CovidVaccination cv
		ON cd.location = cv.location
		AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY cd.location, cv.date



--creating view for later visual 
create view [Cases & Deaths rate] as
select location, date, total_cases, new_cases, total_deaths, population
from portfolioproject..CovidDeaths
where location='world' and continent is null;




create view [probability of dying from covid] as
select location,  date, total_cases, total_deaths, (total_deaths/total_cases)*100 as [death percetage]
from portfolioproject..CovidDeaths
where continent is null;

create view [Total world details] as
select location, population, sum(cast(total_deaths as int)) as [world death], sum(total_cases) as [total world cases],
sum(cast(total_deaths as int))/ sum(total_cases)*100 as [percentage death  rate]
from portfolioproject..CovidDeaths
where location='world'
group by location, population;

create view [Geographical representation of cases] as
select location, population, max(total_cases) as [total cases], max((total_cases/population))*100 as [cases per poppulation]
from portfolioproject..CovidDeaths
--where continent is null
group by location, population;


create view [New cases per vaccination] as
SELECT cd.location, cd.date, cv.total_vaccinations, cd.new_cases
FROM PortfolioProject..CovidDeaths cd
JOIN PortfolioProject..CovidVaccination cv
		ON cd.location = cv.location
		AND cd.date = cv.date
WHERE cd.continent IS NOT NULL;