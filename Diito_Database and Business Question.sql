-- Table created and Data Imported using Import Data Wizard tool
-- ==================================================

-- CREATE TABLE insurance_funnel (
--     
--     lead_id VARCHAR(50) PRIMARY KEY,
--     lead_source VARCHAR(50),
--     product_type VARCHAR(50),
--     age INT,
--     city_tier VARCHAR(20),
--     consultation_channel VARCHAR(30),    
--     advisor_id INT,
--     consultation_duration INT,  -- in minutes
--     nps_score INT,
--     quote_generated BOOLEAN,
--     policy_bind BOOLEAN,
--     days_to_convert INT
-- );


-- EDA & Answering Business Questions
-- ==================================================

-- ==================================================
-- Funnel Efficiency Business Questions
-- ==================================================

-- 1. What is the overall Quote-to-Bind Ratio?
-- Business Meaning: Out of all leads who received a quote, how many actually purchased the policy?


SELECT 
    COUNT(*) AS total_leads,
    SUM(quote_generated) AS total_quotes,
    SUM(policy_bind) AS total_binds,
    ROUND(SUM(policy_bind) / SUM(quote_generated) * 100, 2) AS quote_to_bind_ratio_percent
FROM insurance_funnel;

-- total_leads: 1000
-- total_quotes: 742
-- total_binds: 484
-- quote_to_bind_ratio_percent: 65.23%

-- 2. Which Lead Sources Generate the Highest Bind Rate?
-- Business Meaning: Identify high-quality acquisition channels.

SELECT 
    lead_source, 
    COUNT(*) AS total_leads,
    SUM(policy_bind) AS total_binds,
    ROUND(SUM(policy_bind) / COUNT(*) * 100, 2) 
        AS bind_rate_percent
FROM insurance_funnel
GROUP BY lead_source
ORDER BY bind_rate_percent DESC;

-- 3. Which Product Type Converts Better?
-- Business Meaning: Is Health Insurance or Term Insurance easier to sell?

SELECT 
    product_type,
    COUNT(*) AS total_leads,
    SUM(policy_bind) AS total_binds,
    ROUND(SUM(policy_bind) / COUNT(*) * 100, 2) 
        AS conversion_rate_percent
FROM insurance_funnel
GROUP BY product_type
ORDER BY conversion_rate_percent DESC;

-- ==================================================
-- Advisory Optimization Business Questions
-- ==================================================

-- 1. Does Consultation Duration Impact Bind Rate?
-- Business Meaning: Are longer calls converting better? Or are advisors wasting time?

SELECT 
    ROUND(AVG(consultation_duration), 2) AS avg_duration_minutes,
    ROUND(AVG(CASE WHEN policy_bind = 1 THEN consultation_duration END), 2) AS avg_duration_for_binds,   
    ROUND(AVG(CASE WHEN policy_bind = 0 THEN consultation_duration END), 2) AS avg_duration_for_non_binds
FROM insurance_funnel;

-- 2. What Consultation Duration Range Performs Best?
-- We bucket duration into ranges for deeper analysis.

SELECT 
    CASE 
        WHEN consultation_duration < 10 THEN '0-10 min'
        WHEN consultation_duration BETWEEN 10 AND 20 THEN '10-20 min'
        WHEN consultation_duration BETWEEN 21 AND 30 THEN '21-30 min'
        ELSE '30+ min'
    END AS duration_bucket,
    COUNT(*) AS total_leads,
    SUM(policy_bind) AS total_binds,
    ROUND(SUM(policy_bind) / COUNT(*) * 100, 2) 
        AS bind_rate_percent
FROM insurance_funnel
GROUP BY duration_bucket
ORDER BY bind_rate_percent DESC;

-- 3. Does NPS Score Influence Policy Bind Probability?
-- Business Meaning: Is advisory quality (customer satisfaction) driving revenue?

SELECT 
    CASE 
        WHEN nps_score <= 6 THEN 'Detractor (0-6)'
        WHEN nps_score BETWEEN 7 AND 8 THEN 'Passive (7-8)'
        ELSE 'Promoter (9-10)'
    END AS nps_category,
    COUNT(*) AS total_leads,
    SUM(policy_bind) AS total_binds,
    ROUND(SUM(policy_bind) / COUNT(*) * 100, 2) 
        AS bind_rate_percent
FROM insurance_funnel
GROUP BY nps_category
ORDER BY bind_rate_percent DESC;

-- ==================================================
-- Conversion Velocity Business Questions
-- ==================================================

-- 1. What Is the Average Time Taken to Convert?
-- Business Meaning: How long does it take from first consultation to policy issuance?

SELECT 
    COUNT(*) AS total_leads,
    SUM(policy_bind) AS total_converted_leads,
    ROUND(AVG(CASE WHEN policy_bind = 1 THEN days_to_convert END), 2) AS avg_days_to_convert,
    MIN(CASE WHEN policy_bind = 1 THEN days_to_convert END) AS fastest_conversion_days,
    MAX(CASE WHEN policy_bind = 1 THEN days_to_convert END) AS slowest_conversion_days
FROM insurance_funnel;

-- 2. Which Channel Converts Faster?
-- Business Meaning: Is Phone advisory faster than WhatsApp?

SELECT 
    consultation_channel,
    COUNT(*) AS total_leads,
    SUM(policy_bind) AS total_binds,
    ROUND(AVG(CASE WHEN policy_bind = 1 THEN days_to_convert END), 2) AS avg_days_to_convert,
    ROUND(SUM(policy_bind) / COUNT(*) * 100, 2) AS conversion_rate_percent   
FROM insurance_funnel
GROUP BY consultation_channel
ORDER BY avg_days_to_convert ASC;

-- 3. Which Product Type Has Faster Buying Cycles?
-- Business Meaning: Do customers buy Health insurance faster than Term insurance?

SELECT 
    product_type,
    COUNT(*) AS total_leads,
    SUM(policy_bind) AS total_binds,
    ROUND(AVG(CASE WHEN policy_bind = 1 THEN days_to_convert END), 2) AS avg_days_to_convert,
    ROUND(SUM(policy_bind) / COUNT(*) * 100, 2) AS conversion_rate_percent    
FROM insurance_funnel
GROUP BY product_type
ORDER BY avg_days_to_convert ASC;






