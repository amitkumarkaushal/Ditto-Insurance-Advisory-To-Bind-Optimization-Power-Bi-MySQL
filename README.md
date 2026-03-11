**Project Title**

Ditto's Advisory-to-Bind Funnel Optimization | Power BI + MySQL

⚠️ 𝗤𝘂𝗶𝗰𝗸 𝗱𝗶𝘀𝗰𝗹𝗮𝗶𝗺𝗲𝗿:

This is a portfolio project using a synthetic dataset created only to showcase my data analysis and storytelling skills. It is not an evaluation of the real performance of Ditto Insurance

**Business Context**

This project is inspired by the advisory-led model of Ditto Insurance, where customers speak with insurance advisors before purchasing a policy.

Unlike traditional insurance sales funnels, conversion here depends on:

1. Consultation quality
2. Customer satisfaction
3. Advisory duration
4. Lead acquisition channel
5. Customer demographics

**Business Problem**

The company is generating leads, but not all leads convert into policies. Leadership wants to understand:

1. Which consultations lead to conversions?
2. Whether longer consultations improve bind rate?
3. If customer satisfaction influences buying decisions?
4. Which lead sources generate high-quality customers?
5. Which customer segments convert fastest?

**Business Objective**

Optimize the Advisory → Quote → Policy Bind funnel to:

1. Increase Bind Rate
2. Reduce Days to Convert
3. Improve Advisor Effectiveness
4. Identify High-Value Customer Segments

**Tech Stack**

1. Power BI – Dashboard & Data Storytelling
2. MySQL – Database Creation & Exploratory Analysis
3. DAX – KPI calculations

**What Skills This Project Demonstrates**

1. KPI Design
2. SQL-based EDA
3. Data Storytelling
4. Business problem framing
5. Funnel analysis
6. Customer segmentation
7. Advisor performance analytics
8. Executive storytelling with Power BI

**Dataset**

It's synthetically generated using Tonic Fabricate AI containing 1000 records and 12 columns. Columns include: 

Lead_ID; Lead_Source; Product_Type; User_Age; City_Tier; Consultation_Channel; Advisor_ID; Consultation_Duration_Mins; NPS_Score; Quote_Generated; Policy_Bind; Days_to_Convert; 

**Key Insights**

1. Consultations above 30 minutes convert at ~50.5%, compared to ~43% for 10–20 minutes, suggesting deeper advisory improves trust.
2. Customers aged 36–45 convert fastest (~7.8 days), indicating strong purchase intent.
3. Referral & Newsletter leads convert ~58.5% vs ~33% for Google, showing trust-driven acquisition produces higher intent customers.
4. Matching the 𝗿𝗶𝗴𝗵𝘁 𝗽𝗿𝗼𝗱𝘂𝗰𝘁 𝘁𝘆𝗽𝗲 with the 𝗿𝗶𝗴𝗵𝘁 𝗮𝗰𝗾𝘂𝗶𝘀𝗶𝘁𝗶𝗼𝗻 𝗰𝗵𝗮𝗻𝗻𝗲𝗹 can significantly improve quote-to-bind efficiency.
5. City-tier analysis helps identify where advisory-led insurance adoption is strongest, enabling 𝘀𝗺𝗮𝗿𝘁𝗲𝗿 𝗿𝗲𝗴𝗶𝗼𝗻𝗮𝗹 𝗺𝗮𝗿𝗸𝗲𝘁𝗶𝗻𝗴 𝗮𝗹𝗹𝗼𝗰𝗮𝘁𝗶𝗼𝗻.
6. Average 𝗰𝗮𝗹𝗹𝘀 𝗹𝗮𝘀𝘁 𝟮𝟱 𝗺𝗶𝗻𝘂𝘁𝗲𝘀. Structuring consultations with clear frameworks could improve decision clarity.

**Dashboards**

* Executive Overview: 

<img width="1371" height="853" alt="Ditto_Executive_Overview_Dashboard" src="https://github.com/user-attachments/assets/f938d0d2-cd97-48db-a7fa-5254300d1aa3" />

Tracks:

1. Total Leads
2. Bind Rate
3. Avg NPS
4. Avg Consultation Duration
5. Avg Days to Convert

* Advisory Performance Analysis

<img width="1457" height="820" alt="Ditto_Adviory_Performance_Analysis" src="https://github.com/user-attachments/assets/2337f42e-060e-40d5-9e04-b31f8844ea86" />

Analyzes:

1. Consultation Duration vs Bind
2. Advisor Bind Rate
3. NPS vs Conversion

* Customer Segmentation Insights

<img width="1452" height="822" alt="Ditto_Customer_Segmentation_Analysis" src="https://github.com/user-attachments/assets/8e3e6850-5ef1-424b-afa4-49f2e3c32c89" />

Identifies:

1. High-conversion age groups
2. City tier performance
3. Lead source vs product type

**SQL Exploratory Data Analysis**

Example queries included:

**1. Database & Table Creation**

CREATE DATABASE ditto_insurance_analytics;

USE ditto_insurance_analytics;

CREATE TABLE insurance_funnel (
   
     lead_id VARCHAR(50) PRIMARY KEY,
     lead_source VARCHAR(50),
     product_type VARCHAR(50),
     age INT,
     city_tier VARCHAR(20),
     consultation_channel VARCHAR(30),    
     advisor_id INT,
     consultation_duration INT,  -- in minutes
     nps_score INT,
     quote_generated BOOLEAN,
     policy_bind BOOLEAN,
     days_to_convert INT
);

**2. Bind Rate (%) = Policies Bound / Quotes Generated **

SELECT 

    SUM(quote_generated) AS total_quotes,    
    SUM(policy_bind) AS total_binds,
    ROUND(SUM(policy_bind) / SUM(quote_generated) * 100, 2) AS bind_rate_percent  
    
FROM insurance_funnel;
