-- ============================================================
-- DITTO INSURANCE FUNNEL — Advance Eploratory Data Analysis
-- Tool: MySQL
-- Import: ditto_insurance_funnel.csv via Table Data Import Vizard
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- 1. LEAD QUALITY SCORING
--    "Quality Lead" = NPS_Score >= 8 AND Policy_Bind = 'Yes'
--    Metric: Quality Lead Rate per Lead_Source
-- ────────────────────────────────────────────────────────────
SELECT
    lead_Source,
    COUNT(*)  AS Total_Leads,
    SUM(CASE WHEN Policy_Bind = 'Yes' THEN 1 ELSE 0 END) AS Total_Conversions,
    SUM(CASE WHEN NPS_Score >= 8 THEN 1 ELSE 0 END) AS High_NPS_Leads,
    SUM(CASE WHEN NPS_Score >= 8 AND Policy_Bind = 'Yes' THEN 1 ELSE 0 END) AS Quality_Leads,
    ROUND(100.0 * SUM(CASE WHEN Policy_Bind = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Conversion_Rate_Pct,
    ROUND(100.0 * SUM(CASE WHEN NPS_Score >= 8 AND Policy_Bind = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Quality_Lead_Rate_Pct
FROM ditto_funnel
GROUP BY Lead_Source
ORDER BY Quality_Lead_Rate_Pct DESC;

-- ────────────────────────────────────────────────────────────
-- 2. ADVISORY SUCCESS RATE
--    Advisory Success Rate = Purchased / Total Consultations
-- ────────────────────────────────────────────────────────────
SELECT
    Consultation_Channel,
    COUNT(*) AS Total_Consultations,
    SUM(CASE WHEN Policy_Bind = 'Yes' THEN 1 ELSE 0 END) AS Policies_Sold,
    ROUND(100.0 * SUM(CASE WHEN Policy_Bind = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Advisory_Success_Rate_Pct
FROM insurance_funnel
GROUP BY Consultation_Channel;

-- ────────────────────────────────────────────────────────────
-- 3. CONSULTATION DURATION SWEET SPOT
--    Bucket durations to find optimal "time investment" range
-- ────────────────────────────────────────────────────────────
SELECT
    CASE
        WHEN Consultation_Duration BETWEEN 1  AND 10 THEN '01-10 mins'
        WHEN Consultation_Duration BETWEEN 11 AND 20 THEN '11-20 mins'
        WHEN Consultation_Duration BETWEEN 21 AND 30 THEN '21-30 mins'
        WHEN Consultation_Duration BETWEEN 31 AND 45 THEN '31-45 mins'
        ELSE '45+ mins'
    END AS Duration_Bucket,
    COUNT(*) AS Total_Consultations,
    ROUND(AVG(NPS_Score), 2) AS Avg_NPS,
    ROUND(100.0 * SUM(CASE WHEN Policy_Bind = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Conversion_Rate_Pct
FROM insurance_funnel
GROUP BY Duration_Bucket
ORDER BY Duration_Bucket;

-- ────────────────────────────────────────────────────────────
-- 4. CITY TIER ANALYSIS — Market Penetration
-- ────────────────────────────────────────────────────────────
SELECT
    City_Tier,
    Product_Type,
    COUNT(*) AS Total_Leads,
    ROUND(AVG(age), 1) AS Avg_User_Age,
    ROUND(100.0 * SUM(CASE WHEN Policy_Bind = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Conversion_Rate_Pct,
    ROUND(AVG(NPS_Score), 2) AS Avg_NPS
FROM insurance_funnel
GROUP BY City_Tier, Product_Type
ORDER BY City_Tier, Conversion_Rate_Pct DESC;

