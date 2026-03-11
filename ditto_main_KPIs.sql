
-- Querying Ditto's Main KPIs
-- Tool: MySQL
-- Import: ditto_insurance_funnel.csv via Table Data Import Vizard
-- ============================================================

-- Core Funnel KPIs to Measure
-- ==================================================

-- 1. Total Leads

SELECT 
    COUNT(*) AS total_leads
FROM insurance_funnel;

-- 2. Quote Rate (%) = Quotes Generated / Total Leads

SELECT 
    COUNT(*) AS total_leads,
    SUM(quote_generated) AS total_quotes,
    ROUND(SUM(quote_generated) / COUNT(*) * 100, 2) AS quote_rate_percent
FROM insurance_funnel;

-- 3. Bind Rate (%) = Policies Bound / Quotes Generated 
-- Most critical KPI.

SELECT 
    SUM(quote_generated) AS total_quotes,
    SUM(policy_bind) AS total_binds,
    ROUND(SUM(policy_bind) / SUM(quote_generated) * 100, 2) AS bind_rate_percent  
FROM insurance_funnel;

-- 4. Overall Conversion Rate (%) = Policies Bound / Total Leads 

SELECT 
    COUNT(*) AS total_leads,
    SUM(policy_bind) AS total_binds, 
    ROUND(SUM(policy_bind) / COUNT(*) * 100, 2) 
        AS overall_conversion_rate_percent
FROM insurance_funnel;

-- ==================================================
-- Advisory KPIs to Measure
-- ==================================================

-- 1. Average Consultation Duration

SELECT 
    ROUND(AVG(consultation_duration), 2) 
        AS avg_consultation_duration_minutes
FROM insurance_funnel;

-- 2. Bind Rate by Duration Bucket
-- Business Logic: Which consultation duration range performs best?

SELECT 
    CASE 
        WHEN consultation_duration < 10 THEN '0-10 min'
        WHEN consultation_duration BETWEEN 10 AND 20 THEN '10-20 min'
        WHEN consultation_duration BETWEEN 21 AND 30 THEN '21-30 min'
        ELSE '30+ min'
    END AS duration_bucket,
    COUNT(*) AS total_leads,
    SUM(policy_bind) AS total_binds,
    ROUND(SUM(policy_bind) / COUNT(*) * 100, 2) AS bind_rate_percent     
FROM insurance_funnel
GROUP BY duration_bucket
ORDER BY bind_rate_percent DESC;


-- 3. Average NPS Score

SELECT 
    ROUND(AVG(nps_score), 2) AS avg_nps_score
FROM insurance_funnel;

-- 4. Bind Rate by NPS Category
-- Business Logic: Does customer satisfaction drive conversion?

SELECT 
    CASE 
        WHEN nps_score <= 6 THEN 'Detractor (0-6)'
        WHEN nps_score BETWEEN 7 AND 8 THEN 'Passive (7-8)'
        ELSE 'Promoter (9-10)'
    END AS nps_category,
    COUNT(*) AS total_leads,
    SUM(policy_bind) AS total_binds,
    ROUND(SUM(policy_bind) / COUNT(*) * 100, 2) AS bind_rate_percent 
FROM insurance_funnel
GROUP BY nps_category
ORDER BY bind_rate_percent DESC;

-- ==================================================
-- Quick Conversion KPIs to Measure
-- ==================================================

-- 1. Average Days to Convert

SELECT 
    ROUND(AVG(days_to_convert), 2) AS avg_days_to_convert
FROM insurance_funnel
WHERE policy_bind = 1;

-- 2. Fastest & Slowest Conversion Time

SELECT 
    MIN(days_to_convert) AS fastest_conversion_days,
    MAX(days_to_convert) AS slowest_conversion_days
FROM insurance_funnel
WHERE policy_bind = 1;

-- 4. Conversion Time by Channel
-- Business Logic: Which advisory channel closes deals faster?

SELECT 
    consultation_channel,
    COUNT(*) AS total_converted_leads,
    ROUND(AVG(days_to_convert), 2) AS avg_days_to_convert
FROM insurance_funnel
WHERE policy_bind = 1
GROUP BY consultation_channel
ORDER BY avg_days_to_convert ASC;

-- 5. Bind Rate by Consultation Duration
-- Business Logic: Does more time consulting drive conversion?

SELECT 
    CASE 
        WHEN consultation_duration <= 10 THEN "0-10 mins"
        WHEN consultation_duration BETWEEN 10 AND 20 THEN "10-20 mins"
        ELSE "30 mins"
    END AS consultation_bucket,
    COUNT(*) AS total_leads,
    SUM(policy_bind) AS total_binds,
    ROUND(SUM(policy_bind) / COUNT(*) * 100, 2) AS bind_rate_percent 
FROM insurance_funnel
GROUP BY consultation_bucket
ORDER BY consultation_bucket


