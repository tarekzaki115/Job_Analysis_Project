select
    count(*) as skill_count,
    skills
from job_postings_fact
inner JOIN skills_job_dim using (job_id)
inner JOIN skills_dim using (skill_id)
where
    job_title_short = 'Data Analyst' and
    job_location = 'Anywhere'
group by skills
order by skill_count desc
limit 10
