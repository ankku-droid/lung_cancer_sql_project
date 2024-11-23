--Sql lung cancer project 
CREATE DATABASE lung_cancer_project;

--Create Table 
create table lung_cancer (
	   ID int primary key , 
       GENDER varchar (3),	
       AGE int ,
       SMOKING_STATUS varchar (3),	
       YELLOW_FINGERS varchar (3),	
       ANXIETY varchar (3),	
       PEER_PRESSURE	varchar (3),	
       CHRONIC_DISEASE varchar (3),	
       FATIGUE varchar (3),	
       ALLERGY varchar (3),	
       WHEEZING varchar (3),	
       ALCOHOL_CONSUMING varchar (3),	
       COUGHING varchar (3),	
       SHORTNESS_OF_BREATH varchar (3),	
       SWALLOWING_DIFFICULTY varchar (3),	
       CHEST_PAIN	varchar (3),	
       LUNG_CANCER varchar (3) );


--Check the data --	   
select * from lung_cancer 
limit 10 ;


--Data Cleaning 
-- In excel i generated a column name ID for making it primary key because there is no any primary key.
-- Convert Numerical Encodings to Descriptive Labels Change 1 to "Yes" and 2 to "No" for relevant columns.
-- Standardize Column Names: Use consistent naming conventions (smoking_status instead of SMOKING).
-- Remove Duplicates:	Identify and remove duplicate rows to ensure data uniqueness. 2 DUPLICATES WERE FOUND AND DELETE. REMAINS 2998 ROWS.
-- Delete Null Values There's no any null values to Delete.


-- Check Null Values __
SELECT * FROM LUNG_CANCER
WHERE ID IS NULL OR
GENDER IS NULL OR 
AGE IS NULL OR 
SMOKING_STATUS IS NULL OR 
YELLOW_FINGERS IS NULL OR 
ANXIETY IS NULL OR 
PEER_PRESSURE IS NULL OR
CHRONIC_DISEASE IS NULL OR
FATIGUE IS NULL OR
ALLERGY IS NULL OR
WHEEZING IS NULL OR	   
ALCOHOL_CONSUMING IS NULL OR	   
COUGHING IS NULL OR
SHORTNESS_OF_BREATH IS NULL OR
SWALLOWING_DIFFICULTY IS NULL OR
CHEST_PAIN IS NULL OR
LUNG_CANCER IS NULL  ;


-- Data Exploration


-- How many Data we have?
SELECT COUNT(*) as total_case FROM lung_cancer;

-- How many unique age we have ?

SELECT COUNT(DISTINCT age) as total_unique_age FROM lung_cancer;

--Identify extreme values for specific groups like olders_smoker and Youngest_smoker.
SELECT 
    MAX(CASE WHEN smoking_status = 'Yes' THEN age ELSE NULL END) AS oldest_smoker,
    MIN(CASE WHEN smoking_status = 'Yes' THEN age ELSE NULL END) AS youngest_smoker
FROM lung_cancer;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 How many patients are present in the dataset?
-- Q.2 What is the gender distribution of the patients?
-- Q.3 What is the average age of patients diagnosed with lung cancer?
-- Q.4 How many patients have chronic diseases?
-- Q.5 How many smokers report chest pain as a symptom?
-- Intrmediate Questions:
-- Q.6 Which age group has the highest number of lung cancer cases?
-- Q.7 What percentage of patients exhibit symptoms like wheezing or fatigue?
-- Q.8 How does the prevalence of symptoms differ between smokers and non-smokers?
-- Q.9 What is the relationship between alcohol consumption and shortness of breath?
-- Q.10 How does peer pressure correlate with smoking habits?
-- Advanced Questions:
-- Q.11 Which symptoms most frequently occur together among diagnosed patients?
-- Q.12 How does the combination of chronic disease and smoking affect the occurrence of wheezing?
-- Q.13 What is the impact of gender on the severity and number of symptoms reported?
-- Q.14 Can you predict the likelihood of chest pain in patients with chronic diseases and smoking habits?
-- Q.15 Which demographic (age and gender) has the highest risk factors for developing lung cancer based on the dataset?
-- Q16. who smoke and who don't smoke?


--Q.1 How many patients are present in the dataset?
 
 select count(*) as patients
   from lung_cancer;


--Q.2 What is the gender distribution of the patients?
  
  select gender, count(*) from lung_cancer 
  group by gender; 
  
  
--Q.3 What is the average age of patients diagnosed with lung cancer? 
  
 SELECT 
    round(avg(age),2) AS average_age
 FROM 
    lung_cancer
 WHERE 
    LUNG_CANCER = 'Yes';


--Q.4 How many patients have chronic diseases?
 
 SELECT 
    COUNT(*) AS chronic_disease_count
FROM 
    lung_cancer
WHERE 
    CHRONIC_DISEASE = 'Yes';


--Q.5 How many smokers report chest pain as a symptom?
  
  SELECT 
    COUNT(*) AS smokers_with_chest_pain
FROM 
    lung_cancer
WHERE 
    SMOKING_status = 'Yes' AND CHEST_PAIN = 'Yes';
  

--Q.6 Which age group has the highest number of lung cancer cases?
   
  SELECT 
    CASE 
        WHEN AGE BETWEEN 0 AND 30 THEN '0-30'
        WHEN AGE BETWEEN 31 AND 50 THEN '31-50'
        WHEN AGE BETWEEN 51 AND 70 THEN '51-70'
        ELSE '71+'
    END AS age_group,
    COUNT(*) AS lung_cancer_cases
FROM 
    lung_cancer
WHERE 
    LUNG_CANCER = 'Yes'
GROUP BY 
    age_group
ORDER BY 
    lung_cancer_cases DESC;


--Q.7 What percentage of patients exhibit symptoms like wheezing or fatigue?

  SELECT 
    ROUND(
        (COUNT(*) * 100.0) / (SELECT COUNT(*) FROM lung_cancer), 2
    ) AS symptom_percentage
FROM 
    lung_cancer
WHERE 
    WHEEZING = 'Yes' OR FATIGUE = 'Yes';


--Q.8 How does the prevalence of symptoms differ between smokers and non-smokers?

SELECT 
    SMOKING_status,
    SUM(CASE WHEN WHEEZING = 'Yes' THEN 1 ELSE 0 END) AS wheezing_count,
    SUM(CASE WHEN FATIGUE = 'Yes' THEN 1 ELSE 0 END) AS fatigue_count,
    SUM(CASE WHEN CHEST_PAIN = 'Yes' THEN 1 ELSE 0 END) AS chest_pain_count,
    COUNT(*) AS total_patients
FROM 
    lung_cancer
GROUP BY 
    SMOKING_status;
--You can further modify this query to calculate percentages for easier comparison:
--This will output the percentage prevalence of each symptom for smokers and non-smokers.
	
	SELECT 
    SMOKING_status,
    ROUND(SUM(CASE WHEN WHEEZING = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS wheezing_percentage,
    ROUND(SUM(CASE WHEN FATIGUE = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fatigue_percentage,
    ROUND(SUM(CASE WHEN CHEST_PAIN = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS chest_pain_percentage
FROM 
    lung_cancer
GROUP BY 
    SMOKING_status;

--Q.9 What is the relationship between alcohol consumption and shortness of breath?

 SELECT 
     ALCOHOL_CONSUMING,
     SUM(CASE WHEN SHORTNESS_OF_BREATH = 'Yes' THEN 1 ELSE 0 END) AS shortness_of_breath_count,
     COUNT(*) AS total_patients,
     ROUND(SUM(CASE WHEN SHORTNESS_OF_BREATH = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percentage_with_breath_issues
 FROM 
     lung_cancer
 GROUP BY 
     ALCOHOL_CONSUMING;
	 

--Q.10 How does peer pressure correlate with smoking habits?

   SELECT 
    PEER_PRESSURE,
    SUM(CASE WHEN SMOKING_status = 'Yes' THEN 1 ELSE 0 END) AS smokers_count,
    COUNT(*) AS total_patients,
    ROUND(SUM(CASE WHEN SMOKING_status = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percentage_smokers
FROM 
    lung_cancer
GROUP BY 
    PEER_PRESSURE;


--Q.11 Which symptoms most frequently occur together among diagnosed patients?
   
   SELECT 
    SUM(CASE WHEN WHEEZING = 'Yes' AND FATIGUE = 'Yes' THEN 1 ELSE 0 END) AS wheezing_and_fatigue,
    SUM(CASE WHEN COUGHING = 'Yes' AND SHORTNESS_OF_BREATH = 'Yes' THEN 1 ELSE 0 END) AS coughing_and_shortness_of_breath,
    SUM(CASE WHEN YELLOW_FINGERS = 'Yes' AND ANXIETY = 'Yes' THEN 1 ELSE 0 END) AS yellow_fingers_and_anxiety,
    SUM(CASE WHEN CHEST_PAIN = 'Yes' AND SWALLOWING_DIFFICULTY = 'Yes' THEN 1 ELSE 0 END) AS chest_pain_and_swallowing_difficulty
FROM 
    lung_cancer
WHERE 
    LUNG_CANCER = 'Yes';

   
-- Q.12 How does the combination of chronic disease and smoking affect the occurrence of wheezing?

 SELECT
    COUNT(*) AS total_patients,
    SUM(CASE WHEN CHRONIC_DISEASE = 'Yes' AND SMOKING_status = 'Yes' AND WHEEZING = 'Yes' THEN 1 ELSE 0 END) AS both_chronic_and_smoking_with_wheezing,
    SUM(CASE WHEN CHRONIC_DISEASE = 'Yes' AND SMOKING_status = 'No' AND WHEEZING = 'Yes' THEN 1 ELSE 0 END) AS chronic_only_with_wheezing,
    SUM(CASE WHEN CHRONIC_DISEASE = 'No' AND SMOKING_status = 'Yes' AND WHEEZING = 'Yes' THEN 1 ELSE 0 END) AS smoking_only_with_wheezing,
    SUM(CASE WHEN CHRONIC_DISEASE = 'No' AND SMOKING_status = 'No' AND WHEEZING = 'Yes' THEN 1 ELSE 0 END) AS neither_with_wheezing
FROM 
    lung_cancer;


-- Q.13 What is the impact of gender on the severity and number of symptoms reported?

SELECT
    GENDER,
    COUNT(*) AS total_patients,
    SUM(
        CASE WHEN WHEEZING = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN FATIGUE = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN CHEST_PAIN = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN SHORTNESS_OF_BREATH = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN COUGHING = 'Yes' THEN 1 ELSE 0 END
    ) AS total_symptoms_reported,
    Round(AVG(
        CASE WHEN WHEEZING = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN FATIGUE = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN CHEST_PAIN = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN SHORTNESS_OF_BREATH = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN COUGHING = 'Yes' THEN 1 ELSE 0 END
    ),2) AS avg_symptoms_per_patient
FROM 
    lung_cancer
GROUP BY
    GENDER;

-- Q.14 Can you predict the likelihood of chest pain in patients with chronic diseases and smoking habits?

SELECT
    COUNT(*) AS total_patients_with_chronic_disease_and_smoking,
    SUM(CASE WHEN CHEST_PAIN = 'Yes' THEN 1 ELSE 0 END) AS patients_with_chest_pain,
    ROUND(
        CAST(SUM(CASE WHEN CHEST_PAIN = 'Yes' THEN 1 ELSE 0 END) AS NUMERIC) /
        NULLIF(COUNT(*), 0) * 100, 2
    ) AS likelihood_of_chest_pain_percentage
FROM 
    lung_cancer
WHERE
    CHRONIC_DISEASE = 'Yes' AND SMOKING_status = 'Yes';


-- Q.15 Which demographic (age and gender) has the highest risk factors for developing lung cancer based on the dataset?

  SELECT 
    AGE_GROUP,
    GENDER,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN LUNG_CANCER = 'Yes' THEN 1 ELSE 0 END) AS lung_cancer_cases,
    ROUND(
        CAST(SUM(CASE WHEN LUNG_CANCER = 'Yes' THEN 1 ELSE 0 END) AS NUMERIC) /
        NULLIF(COUNT(*), 0) * 100, 2
    ) AS lung_cancer_percentage
FROM 
    (
        SELECT 
            *,
            CASE
                WHEN AGE BETWEEN 0 AND 20 THEN '0-20'
                WHEN AGE BETWEEN 21 AND 40 THEN '21-40'
                WHEN AGE BETWEEN 41 AND 60 THEN '41-60'
                ELSE '60+'
            END AS AGE_GROUP
        FROM 
            lung_cancer
    ) AS age_grouped_data
GROUP BY 
    AGE_GROUP, GENDER
ORDER BY 
    lung_cancer_percentage DESC;


-- Q16. who smoke and who don't smoke?

SELECT 
    smoking_status,
    COUNT(*) AS patient_count
FROM lung_cancer
GROUP BY smoking_status;

-- same query with windows function.
WITH smoker_data AS (
    SELECT smoking_status, COUNT(*) AS count
    FROM lung_cancer
    GROUP BY smoking_status
)
SELECT * FROM smoker_data;

-- end of project.