with top_paying_jobs as (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name
    FROM 
        job_postings_fact
    left join company_dim using (company_id)
    WHERE 
        job_title_short = 'Data Analyst' and
        job_location = 'Anywhere' and
        salary_year_avg is NOT NULL
    order by salary_year_avg desc
    limit 10
)

select 
    count(*) as skill_count,
    skills,
    round(avg(salary_year_avg), 2) as avg_salary
from top_paying_jobs
inner join skills_job_dim using (job_id)
inner join skills_dim using (skill_id)
group by skills
order by skill_count desc, avg_salary desc