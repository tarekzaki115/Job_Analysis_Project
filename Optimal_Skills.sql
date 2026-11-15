with skill_demand AS(
    select
        skill_id,
        count(*) as skill_count,
        skills
    from job_postings_fact
    inner JOIN skills_job_dim using (job_id)
    inner JOIN skills_dim using (skill_id)
    where
        job_title_short = 'Data Analyst' and
        job_location = 'Anywhere' and
        salary_year_avg is not null
    group by skill_id, skills
), average_salary as(
    select 
        skill_id,
        skills,
        round(AVG(salary_year_avg),2) as average_salary
    from job_postings_fact
    inner JOIN skills_job_dim using (job_id)
    inner JOIN skills_dim using (skill_id)
    where
        job_title_short = 'Data Analyst' and
        salary_year_avg is not null
    group by skill_id, skills
)

select 
    skill_demand.skills,
    skill_demand.skill_id,
    skill_demand.skill_count,
    average_salary.average_salary
from
skill_demand
inner join average_salary on skill_demand.skill_id = average_salary.skill_id
where
    skill_demand.skill_count > 10
order by average_salary desc, skill_count desc
