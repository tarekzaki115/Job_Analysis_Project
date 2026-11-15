
create table public.company_dim
(
    company_id int primary key,
    name TEXT,
    link TEXT,
    link_google TEXT,
    thumbnail TEXT
);


Create TABLE public.skills_dim
(
    skill_id int primary key,
    skills TEXT,
    type TEXT
);

Create table public.job_postings_fact
(
    job_id int primary key,
    company_id int,
    job_title_short Varchar(255),
    job_title TEXT,
    job_location TEXT,
    job_via TEXT,
    job_schedule_type TEXT,
    job_work_from_home boolean,
    search_location TEXT,
    job_posted_date date,
    job_no_degree_mention boolean,
    job_health_insurance boolean,
    job_country TEXT,
    salary_rate TEXT,
    salary_year_avg numeric,
    salary_hour_avg numeric,
    Foreign key (company_id) references public.company_dim(company_id)
);

create TABLE public.skills_job_dim
(
    job_id int,
    skill_id int,
    Foreign key (job_id) references public.job_postings_fact(job_id),
    Foreign key (skill_id) references public.skills_dim(skill_id)
);

ALter table public.company_dim Owner to postgres;
ALter table public.skills_dim Owner to postgres;
ALter table public.job_postings_fact Owner to postgres;
ALter table public.skills_job_dim Owner to postgres;

Create INDEX idx_company_id on public.job_postings_fact(company_id);
create INDEX idx_skill_id on public.skills_job_dim(skill_id);
create INDEX idx_job_id on public.skills_job_dim(job_id);


\copy company_dim from
'C:\Users\Tarek\ME\DB\DB Demo\company_dim.csv' 
DELIMITER ',' CSV HEADER;

\copy skills_dim from
'C:\Users\Tarek\ME\DB\DB Demo\skills_dim.csv'
DELIMITER ',' CSV HEADER;

\copy job_postings_fact from
'C:\Users\Tarek\ME\DB\DB Demo\job_postings_fact.csv'
DELIMITER ',' CSV HEADER;

\copy skills_job_dim from
'C:\Users\Tarek\ME\DB\DB Demo\skills_job_dim.csv'
DELIMITER ',' CSV HEADER;


select 
    count(job_id) as Total_Jobs,
    Extract (month from job_posted_date) as Month
    Extract (year from job_posted_date) as Year,
    job_location as Location,
    job_title_short as Job_Title
FROM job_postings_fact

where 
    job_title_short like '%Data%'
    or
    job_title_short like '%analyst%'
Group BY
    month


Create table jan_jobs as
select *
from job_postings_fact
where EXTRACT
    (month from job_posted_date) = 1;

Create table feb_jobs as
select *
from job_postings_fact
where EXTRACT
    (month from job_posted_date) = 2;


Create table mar_jobs as
select *
from job_postings_fact
where EXTRACT
    (month from job_posted_date) = 3;*/

select 
    count(job_id) as Total_Jobs,
    job_title_short as Job_Title,
    case
        when job_location ='Anywhere' then 'Remote'
        when job_location like '%New York%' then 'Local'
        else 'Onsite'
    end as Location_Type
from job_postings_fact
where 
    job_title_short like '%Data%'
group BY
    job_title_short, location_Type;

select
    count(*) as Jobs,
    skill_id,
    skills

from skills_job_dim 

Inner join skills_dim using (skill_id)
Inner join job_postings_fact using (job_id)

where job_postings_fact.job_work_from_home = true

group by skills, skill_id

order by Jobs desc

limit 5;


Create table jan_jobs as
select *
from job_postings_fact
where EXTRACT
    (month from job_posted_date) = 1;

Create table feb_jobs as
select *
from job_postings_fact
where EXTRACT
    (month from job_posted_date) = 2;


Create table mar_jobs as
select *
from job_postings_fact
where EXTRACT
    (month from job_posted_date) = 3;*/


select 
    Job_Title,
    salary_year_avg,
    job_location,  
    job_posted_date::Date
from (
    select * from jan_jobs
    union all
    select * from feb_jobs
    union all
    select * from mar_jobs
) as quarter_jobs
where salary_year_avg > 70000
and job_title_short = 'Data Analyst'
order by salary_year_avg desc
;

