# Introduction

Greetings!
Welcome to my SQL Portfolio Project, where I dive into the data job market with a focus on data analyst roles. This project is a personal exploration in order to identifying the top-paying jobs, in-demand skills, and the intersection of high demand with high salary in the field of data analytics.

SQL queries? Check them out here [project_sql folder](/project_SQL/)

# Background

Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to identify the highest-paid and most in-demand skills, helping others streamline their search for optimal job opportunities.

Using a real world data set of 2025 data science job postings. This data has details on job titles, salaries, location and required skills. 

### The question I wanted to answer through my SQL queries were:

1.What are top_paying data analyst jobs?

2.What skills are required for these top paying jobs?

3.What skills are most in demand for data analysts?

4.Which skills are associated with higher salaries?

5.What are the most optical skills to learn

# Tools I Used

For my deep dive into data analyst job market, I harnessed the power of several key tools:

**SQL:** The backbone of my analysis, allowin me to query the database and unearth critical insights.

**PostgreSQL:** The chosen database management  system, ideal for handling the job posting data.

**Visual Studio Code:** My go to for database management  and executing SQL queries.

**Git and GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investiating specific aspects of the data analyst job market.
Here is how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest -paying roles. I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities  in the field.

```
SELECT
  job_id,
  job_title,
  job_location,
  job_schedule_type,
  salary_year_avg,
  job_posted_date,
  name AS company_name
FROM
  job_postings_fact
LEFT JOIN
  company_dim ON job_postings_fact.company_id=company_dim.company_id
WHERE
  job_title_short='Data Analyst' AND
  job_location='Anywhere' AND
  salary_year_avg IS NOT NULL
ORDER BY
  salary_year_avg DESC
LIMIT 10;
```
### 2. Skills for top paying jobs
In order to understand the skills required when it comes to top paying jobs. I joined job posting and skill data, to provide insights into what employers value for high compenstion role.

```
-- Gets the top 10 paying Data Analyst jobs
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg
    FROM
        job_postings_fact
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_location = 'Anywhere'
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT
    top_paying_jobs.job_id,
    top_paying_jobs.job_title,
    top_paying_jobs.salary_year_avg,
    skills_dim.skills
FROM
    top_paying_jobs
    INNER JOIN
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
    INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    top_paying_jobs.salary_year_avg DESC;
```

### 3. In demand skills for data analyst
This query helped me identify in demand skills that are always mentioned when it comes to data analyst job postings roles.

```
SELECT
  skills_dim.skills,
  COUNT(skills_job_dim.job_id) AS demand_count
FROM
  job_postings_fact
  INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
  INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY
  skills_dim.skills
ORDER BY
  demand_count DESC
LIMIT 5;
```
### 4. Skills based on salary
I decided to explore average salaries based on different skills hence revealing which skills are the highest paying.

```
SELECT
  skills_dim.skills AS skill,
  ROUND(AVG(job_postings_fact.salary_year_avg),2) AS avg_salary
FROM
  job_postings_fact
INNER JOIN
  skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
  skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_postings_fact.job_title_short = 'Data Analyst'
  AND job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY
  skills_dim.skills
ORDER BY
  avg_salary DESC;
```
### 5. Most high demand skills to learn
This query aimed to identify skills that are both on high demand and pay high as well, offering a strategic focus for skill development.

```
WITH skills_demand AS (
  SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
  FROM
    job_postings_fact
    INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
  WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    AND job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_location = 'Anywhere'
  GROUP BY
    skills_dim.skill_id
),
average_salary AS (
  SELECT
    skills_job_dim.skill_id,
    AVG(job_postings_fact.salary_year_avg) AS avg_salary
  FROM
    job_postings_fact
    INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
  WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    AND job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_location = 'Anywhere'
  GROUP BY
    skills_job_dim.skill_id
)
SELECT
  skills_demand.skills,
  skills_demand.demand_count,
  ROUND(average_salary.avg_salary, 2) AS avg_salary
FROM
  skills_demand
  INNER JOIN
  average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY
  demand_count DESC,
  avg_salary DESC
LIMIT 25;
```
Each query was designed not only to address a specific question but also to deepen my understanding of SQL and database analysis. This project enabled me to harness SQL’s robust data manipulation features to extract valuable insights from complex datasets.

# What I have learned
Throughout this project, I honed several essential SQL techniques and skills:

**Complex Query Construction:** Learning to build advanced SQL queries that combine multiple tables and utilize functions such as WITH clauses to create temporary result sets, improving both the clarity and efficiency of complex data analysis tasks.

**Data Aggregation:** Utilizing GROUP BY and aggregate functions like COUNT() and AVG() to summarize data effectively.

**Analytical Thinking:** Developing the ability to translate real-world questions into actionable SQL queries that got insightful answers.

# Insights 
From the analysis, several general insights emerged:

**1. Top paying data analyst jobs:** The highest-paying remote jobs for data analysts offer a wide salary range, with some roles reaching up to $650,000 annually

**2. Skills for top paying jobs:** High-paying data analyst roles often demand advanced proficiency in SQL, highlighting it as a critical skill for securing top-tier salaries

**3. Most in demand skills:** SQL is also the most in-demand skill in the data analyst job market, making it essential for anyone seeking a role in the field.

**4. Skills with higher salaries:** Specialized skills, such as typescript and graphql, are associated with the highest average salaries, indicating a premium on niche expertise.

**5. Optimal skills for job market value:** SQL leads in demand and offers a high average salary, positioning it as one of the most valuable skills for data analysts to learn in order to maximize their market value.

# Conclusion
This project not only enhanced my SQL skills but also provided valuable insights into the data analyst job market. The findings serve as a practical guide for prioritizing both skill development and job search strategies. Aspiring data analysts can strengthen their position in a competitive market by focusing on high-demand, high-paying skills such as SQL. Overall, this exploration underscores the importance of continuous learning and adapting to emerging trends in the evolving field of data analytics.