select 
    skills,
    round(AVG(salary_year_avg),2) as average_salary,
    count(*) as skill_count
from job_postings_fact
inner JOIN skills_job_dim using (job_id)
inner JOIN skills_dim using (skill_id)
where
    job_title_short = 'Data Analyst' and
    salary_year_avg is not null
group by skills
order by average_salary desc, skill_count desc