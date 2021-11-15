-- looking at total cases vs total deaths
USE Portfolio_project;
update Covid19_deaths$
set total_deaths =nullif(total_deaths, 0)
update Covid19_deaths$
set total_cases =nullif(total_cases, 0)
select location, date, total_cases, (total_deaths), (total_deaths)/(total_cases) *100 as deathpercentage from Covid19_deaths$  where location = 'united states'
order by 1,2 desc

-- looking at country with highest  case  as at date
USE Portfolio_project;
select location, date, total_cases, total_deaths from Covid19_deaths$ 
where date ='2021-11-11 00:00:00:000' and total_cases is not null and total_deaths is not null
order by 3 desc

-- or use max function to look at country with highest  case  as at date
USE Portfolio_project;
select location, max(date) as YTD, population , max(total_cases) as total_cases, (max(total_cases)/population)*100 as casePERpopulation from Covid19_deaths$ 
where continent is not null
group by location, population 
order by 4 desc

-- looking at country with highest death per case percentage as at date
USE Portfolio_project;
select location, date, total_cases, total_deaths,(total_deaths)/(total_cases) *100 as death_per_case_percentage from Covid19_deaths$ 
where date ='2021-11-11 00:00:00:000' and (total_deaths)/(total_cases) *100 is not null 
order by 5 desc

-- looking at total cases vs population
-- shows  what percentage of population got covid4
USE Portfolio_project;
select location, date, population, total_cases, (total_cases)/(population) *100 as case_percentage  from Covid19_deaths$ where location in ( 'nigeria','united states')
order by 1,2 desc

 -- looking at deathcount
USE Portfolio_project;
select location, max(date) as YTD, population , max(total_cases) as total_cases, max(cast(total_deaths as int))as death_count from Covid19_deaths$ 
where continent is not null
group by location, population 
order by 5 desc

-- looking at deathcount by continent
USE Portfolio_project;
select continent, max(date) as YTD, max(total_cases) as total_cases, max(cast(total_deaths as int))as death_count from Covid19_deaths$ 
where continent is not null
group by continent
order by 4 desc

-- Looking at total population vs vaccinations
USE Portfolio_project; 
select dea.continent, dea.location, dea.date, dea.population, sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as totalvacc
from Covid19_deaths$ dea join Covid19_vaccinations$ vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null

-- looking at population vs vaccinations with CTE

with popvsvac (continent, location, date, population, new_vaccinations, totalvacc) as
( select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as totalvacc
from Portfolio_project..Covid19_deaths$ dea join Portfolio_project..Covid19_vaccinations$ vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null)




