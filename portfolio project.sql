select*
from [dbo].[covid19deaths]

select*
from [dbo].[CovidVaccinations]


--looking for total cases vs population
--shows what percentage got covid
select location,date,total_cases_per_million,total_deaths,
(total_deaths/nullif(total_cases_per_million,0)) as deathspercentage
from [dbo].[covid19deaths]
where location like 'Africa'
order by 1,2

--looking at countries with highest infection rate compare to population
select location,population,max(total_cases_per_million)as highestinfectioncount
,max((total_cases_per_million/nullif(population,0)))*100 as percentagerinfpop 
from [dbo].[covid19deaths]
--where location like 'Africa'
group by location,population
order by percentagerinfpop desc


--showing countries with highest deathscount per population
select location,max(total_deaths) as totaldeathscount
from [dbo].[covid19deaths]
--where location like 'Africa'
where continent is not null
group by location,population
order by totaldeathscount desc


--lets break things by continent


select continent,max(total_deaths) as totaldeathscount
from [dbo].[covid19deaths]
--where location like 'Africa'
where continent is not null
group by continent
order by totaldeathscount desc

--continent with highest death count

select continent,max(total_deaths) as totaldeathscount
from [Portfolioproject1]..[covid19deaths]
--where location like 'Africa'
where continent is not null
group by continent
order by totaldeathscount desc

--global numbers

select sum(new_cases) as total_cases,sum(new_deaths) as total_deaths,sum(new_deaths)/sum
(nullif(new_cases,0))*100 as deeathpercentage
from [dbo].[covid19deaths]
where continent is not null
--group by date
order by 1,2


select *
from CovidVaccinations

--looking at tatol population vs varcination
  
select dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations )) over (partition by dea.location  order by dea.location,dea.date)
as rollingpoeplevaccinated
from [Portfolioproject1]..covid19deaths dea
 join [Portfolioproject1]..CovidVaccinations vac
 on dea.location =vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

 --using CTE
 with popvsvac (continent,location,date,population, vac_new_vaccinations,rollingpoeplevaccinated)
 as
 (
 select dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations )) over (partition by dea.location  order by dea.location,dea.date)
as rollingpoeplevaccinated
from [Portfolioproject1]..covid19deaths dea
 join [Portfolioproject1]..CovidVaccinations vac
 on dea.location =vac.location
 and dea.date = vac.date
 where dea.continent is not null
  --order by 2,3
 )

 select*,(rollingpoeplevaccinated/nullif(population,0))*100
 from popvsvac 

 --temp table
drop table if exists  #percentagepopulationvaccination
 create table #percentagepopulationvaccination
 (
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 rollingpoeplevaccinated numeric
)

 insert into #percentagepopulationvaccination
  select dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations )) over (partition by dea.location  order by dea.location,dea.date)
as rollingpoeplevaccinated
from [Portfolioproject1]..covid19deaths dea
 join [Portfolioproject1]..CovidVaccinations vac
 on dea.location =vac.location
 and dea.date = vac.date
 where dea.continent is not null
  --order by 2,3

  
 select*,(rollingpoeplevaccinated/nullif(population,0))*100
 from #percentagepopulationvaccination


 ---creating view to store data for latter visualization
 create view percentagepopulationvaccination as
  select dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations )) over (partition by dea.location  order by dea.location,dea.date)
as rollingpoeplevaccinated
from [Portfolioproject1]..covid19deaths dea
 join [Portfolioproject1]..CovidVaccinations vac
 on dea.location =vac.location
 and dea.date = vac.date
 where dea.continent is not null

 select *
 from percentagepopulationvaccination