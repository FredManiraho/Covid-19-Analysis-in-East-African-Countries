#Analyzing Covid-19 during the stringency_index of above 90%
SELECT 
	cod.covid_id,
    cod.stringency_index,
    cs.location,
    cs.`date`,
    cs.total_cases,
    cs.new_cases,
    cod.population,
    (cs.total_cases/cod.population)*100 AS per_of_infected_vs_population,
		CASE 
		WHEN (cs.total_cases/cod.population)*100 BETWEEN 0.000001 AND 0.000002 THEN '1 - 2 People out of 1M Population were infected'
        WHEN (cs.total_cases/cod.population)*100 BETWEEN 0.000003 AND 0.000004 THEN '3 - 4 People out of 1M Population were infected'
        WHEN (cs.total_cases/cod.population)*100 BETWEEN 0.000005 AND 0.00001 THEN '5 - 10 People out of 1M Population were infected'
		WHEN (cs.total_cases/cod.population)*100 BETWEEN 0.00005 AND 0.0001 THEN '50 - 100 People out of 1M Population were infected'
        ELSE 'Above 100 People out of 1M Popluation were infected'
        END AS perc_of_infected_vs_population,
	cd.total_deaths,
    (cd.total_deaths)/(cs.total_cases) `perc of deaths vs cases`,
    cv.people_fully_vaccinated
    

FROM portfolio_project_covid_rwanda.covid_cases cs
	INNER JOIN portfolio_project_covid_rwanda.cases_death cd ON cd.covid_id = cs.covid_id
    INNER JOIN portfolio_project_covid_rwanda.country_details cod ON cod.covid_id = cs.covid_id
    INNER JOIN portfolio_project_covid_rwanda.covid_vaccination cv ON cv.covid_id = cs.covid_id

WHERE EXISTS ( SELECT cod.stringency_index FROM  portfolio_project_covid_rwanda.country_details cod WHERE cod.covid_id = cs.covid_id AND cod.stringency_index > 90) #How to make this proper
   	AND cs.`date` BETWEEN '01/01/2020' AND '12/31/2020'
    AND cs.location IN ('Rwanda', 'Burundi', 'Uganda', 'Kenya', 'Tanzania')