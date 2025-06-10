/* ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
Database Load Issues (follow if receiving permission denied when running SQL code below)

NOTE: If you are having issues with permissions. And you get error: 

'could not open file "[your file path]\job_postings_fact.csv" for reading: Permission denied.'

1. Open pgAdmin
2. In Object Explorer (left-hand pane), navigate to `sql_course` database
3. Right-click `sql_course` and select `PSQL Tool`
    - This opens a terminal window to write the following code
4. Get the absolute file path of your csv files
    1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
5. Paste the following into `PSQL Tool`, (with the CORRECT file path)

\copy company_dim FROM '[Insert File Path]/company_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_dim FROM '[Insert File Path]/skills_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy job_postings_fact FROM '[Insert File Path]/job_postings_fact.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

\copy skills_job_dim FROM '[Insert File Path]/skills_job_dim.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

*/

-- NOTE: This has been updated from the video to fix issues with encoding

COPY company_dim
FROM 'C:\Program Files\PostgreSQL\16\data\Datasets\sql_course\company_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_dim
FROM 'C:\Program Files\PostgreSQL\16\data\Datasets\sql_course\skills_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY job_postings_fact
FROM 'C:\Program Files\PostgreSQL\16\data\Datasets\sql_course\job_postings_fact.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY skills_job_dim
FROM 'C:\Program Files\PostgreSQL\16\data\Datasets\sql_course\skills_job_dim.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');


-- 1. Insert into company_dim
INSERT INTO company_dim (company_id, name, link, link_google, thumbnail)
SELECT company_id, name, link, link_google, thumbnail
FROM company_dim_staging
ON CONFLICT (company_id) DO NOTHING;


-- 2. Insert into skills_dim
INSERT INTO skills_dim (skill_id, skills, type)
SELECT skill_id, skills, type
FROM skills_dim_staging
ON CONFLICT (skill_id) DO NOTHING;

-- 3. Insert into skills_job_dim
INSERT INTO skills_job_dim (job_id, skill_id)
SELECT job_id, skill_id
FROM skills_job_dim_staging
ON CONFLICT (job_id, skill_id) DO NOTHING;

-- 4. Insert into job_postings_fact
INSERT INTO job_postings_fact (
    job_id, company_id,job_title_short,job_title, job_location,
    job_via, job_schedule_type, job_work_from_home,
    search_location, job_posted_date, job_no_degree_mention,
    job_health_insurance, job_country, salary_rate,
    salary_year_avg
)
SELECT
    job_id, company_id,job_title_short,job_title, job_location,
    job_via, job_schedule_type, job_work_from_home,
    search_location, job_posted_date, job_no_degree_mention,
    job_health_insurance, job_country, salary_rate,
    salary_year_avg
FROM job_postings_fact_staging
ON CONFLICT (job_id) DO NOTHING;


SELECT column_name
FROM information_schema.columns
WHERE table_name = 'job_postings_fact'
ORDER BY ordinal_position;

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'company_dim'
ORDER BY ordinal_position;



SELECT column_name
FROM information_schema.columns
WHERE table_name = 'skills_job_dim'
ORDER BY ordinal_position;



SELECT *
FROM job_postings_fact
LIMIT 100


SELECT 
    job_posted_date
FROM
    job_postings_fact
LIMIT
    10;

SELECT
    '2023-02-19':: DATE,
    '123' :: INTEGER,
    'true' :: BOOLEAN,
    '3.14' :: REAL;

SELECT
 job_title_short AS title,
 job_location AS location,
 job_posted_date
FROM
    job_postings_fact;


SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date ::date AS date_time
FROM
    job_postings_fact


SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
FROM
    job_postings_fact
LIMIT 5;

SELECT
    job_title_short AS title,
    job_location AS location,
    EXTRACT(MONTH FROM job_posted_date) AS Date_month,
    EXTRACT (YEAR FROM job_posted_date) AS year
FROM
    job_postings_fact
LIMIT 5;

SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS MONTH
FROM
    job_postings_fact
WHERE
    job_title_short='Data Analyst'
GROUP BY
    MONTH
ORDER BY
    job_posted_count DESC;

SELECT 
    COUNT(job_id) AS job_count_posted,
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST') AS month_posted
FROM
    job_postings_fact
GROUP BY
    month_posted
ORDER BY
    month_posted DESC;


--PRACTICE PROBLEM







