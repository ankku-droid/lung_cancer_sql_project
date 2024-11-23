# lung_cancer_sql_project

## Project Overview

**Project Title**: **lung_cancer_sql_project**   
**Database**: `lung_cancer_project`

This project focuses on analyzing a comprehensive dataset related to lung cancer, with the objective of identifying key trends, correlations, and risk factors. Using PostgreSQL for data cleaning, transformation, and advanced query execution, the analysis delves into patient demographics, lifestyle factors, and symptom patterns. Key aspects of the project included transforming binary data into meaningful categories, exploring the relationships between smoking, chronic diseases, and symptoms, and identifying high-risk demographic groups.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `lung_cancer_project`.
- **Table Creation**: A table named `lung_cancer` is created. The table structure includes columns for ID, GENDER,	AGE,	SMOKING_STATUS,	YELLOW_FINGERS,	ANXIETY,	PEER_PRESSURE,	CHRONIC_DISEASE,	FATIGUE,	ALLERGY,	WHEEZING,	ALCOHOL_CONSUMING,	COUGHING,	SHORTNESS_OF_BREATH,	SWALLOWING_DIFFICULTY,	CHEST_PAIN,	LUNG_CANCER.


```sql
CREATE DATABASE lung_cancer_project;

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
```

### 2. Data Cleaning

- **primary key**:In excel i generated a column name ID for making it primary key because there is no any primary key.
- **convert data**: Convert Numerical Encodings to Descriptive Labels Change 1 to "Yes" and 2 to "No" for relevant columns.
- **Standardize column names**: Standardize Column Names: Use consistent naming conventions (smoking_status instead of SMOKING).
- **Remove Duplicates**:Remove Duplicates:	Identify and remove duplicate rows to ensure data uniqueness. 2 DUPLICATES WERE FOUND AND DELETE. REMAINS 2998 ROWS.
- **Null values check**:Delete Null Values There's no any null values to Delete.
```sql
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
```


### 2. Data Exploration

```sql
SELECT COUNT(*) as total_case FROM lung_cancer;

SELECT COUNT(DISTINCT age) as total_unique_age FROM lung_cancer;

SELECT 
    MAX(CASE WHEN smoking_status = 'Yes' THEN age ELSE NULL END) AS oldest_smoker,
    MIN(CASE WHEN smoking_status = 'Yes' THEN age ELSE NULL END) AS youngest_smoker
FROM lung_cancer;

```


### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **How many patients are present in the dataset?**:
```sql
select count(*) as patients
   from lung_cancer;
```

2. **What is the gender distribution of the patients?**:
```sql
 select gender, count(*) from lung_cancer 
  group by gender; 
```

3. **What is the average age of patients diagnosed with lung cancer?**:
```sql
SELECT 
    round(avg(age),2) AS average_age
 FROM 
    lung_cancer
 WHERE 
    LUNG_CANCER = 'Yes';

```

4. **How many patients have chronic diseases?**:
```sql
 SELECT 
    COUNT(*) AS chronic_disease_count
FROM 
    lung_cancer
WHERE 
    CHRONIC_DISEASE = 'Yes';
```

5. **How many smokers report chest pain as a symptom?.**:
```sql

  SELECT 
    COUNT(*) AS smokers_with_chest_pain
FROM 
    lung_cancer
WHERE 
    SMOKING_status = 'Yes' AND CHEST_PAIN = 'Yes';
  
```

6. **Which age group has the highest number of lung cancer cases?.**:
```sql
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
```

7. **What percentage of patients exhibit symptoms like wheezing or fatigue?**:
```sql
 SELECT 
    ROUND(
        (COUNT(*) * 100.0) / (SELECT COUNT(*) FROM lung_cancer), 2
    ) AS symptom_percentage
FROM 
    lung_cancer
WHERE 
    WHEEZING = 'Yes' OR FATIGUE = 'Yes';

```

8. **How does the prevalence of symptoms differ between smokers and non-smokers?**:
```sql
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
```
**You can further modify this query to calculate percentages for easier comparison:**
**This will output the percentage prevalence of each symptom for smokers and non-smokers.**

```sql
SELECT 
    SMOKING_status,
    ROUND(SUM(CASE WHEN WHEEZING = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS wheezing_percentage,
    ROUND(SUM(CASE WHEN FATIGUE = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS fatigue_percentage,
    ROUND(SUM(CASE WHEN CHEST_PAIN = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS chest_pain_percentage
FROM 
    lung_cancer
GROUP BY 
    SMOKING_status;
```

9. **What is the relationship between alcohol consumption and shortness of breath?.**:
```sql
SELECT 
     ALCOHOL_CONSUMING,
     SUM(CASE WHEN SHORTNESS_OF_BREATH = 'Yes' THEN 1 ELSE 0 END) AS shortness_of_breath_count,
     COUNT(*) AS total_patients,
     ROUND(SUM(CASE WHEN SHORTNESS_OF_BREATH = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percentage_with_breath_issues
 FROM 
     lung_cancer
 GROUP BY 
     ALCOHOL_CONSUMING;
	 
```

10. **How does peer pressure correlate with smoking habits?**:
```sql
  SELECT 
    PEER_PRESSURE,
    SUM(CASE WHEN SMOKING_status = 'Yes' THEN 1 ELSE 0 END) AS smokers_count,
    COUNT(*) AS total_patients,
    ROUND(SUM(CASE WHEN SMOKING_status = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percentage_smokers
FROM 
    lung_cancer
GROUP BY 
    PEER_PRESSURE;

```

11. **Which symptoms most frequently occur together among diagnosed patients?**:
```sql
SELECT 
    SUM(CASE WHEN WHEEZING = 'Yes' AND FATIGUE = 'Yes' THEN 1 ELSE 0 END) AS wheezing_and_fatigue,
    SUM(CASE WHEN COUGHING = 'Yes' AND SHORTNESS_OF_BREATH = 'Yes' THEN 1 ELSE 0 END) AS coughing_and_shortness_of_breath,
    SUM(CASE WHEN YELLOW_FINGERS = 'Yes' AND ANXIETY = 'Yes' THEN 1 ELSE 0 END) AS yellow_fingers_and_anxiety,
    SUM(CASE WHEN CHEST_PAIN = 'Yes' AND SWALLOWING_DIFFICULTY = 'Yes' THEN 1 ELSE 0 END) AS chest_pain_and_swallowing_difficulty
FROM 
    lung_cancer
WHERE 
    LUNG_CANCER = 'Yes';
```

12. **How does the combination of chronic disease and smoking affect the occurrence of wheezing?**:
```sql
 SELECT
    COUNT(*) AS total_patients,
    SUM(CASE WHEN CHRONIC_DISEASE = 'Yes' AND SMOKING_status = 'Yes' AND WHEEZING = 'Yes' THEN 1 ELSE 0 END) AS both_chronic_and_smoking_with_wheezing,
    SUM(CASE WHEN CHRONIC_DISEASE = 'Yes' AND SMOKING_status = 'No' AND WHEEZING = 'Yes' THEN 1 ELSE 0 END) AS chronic_only_with_wheezing,
    SUM(CASE WHEN CHRONIC_DISEASE = 'No' AND SMOKING_status = 'Yes' AND WHEEZING = 'Yes' THEN 1 ELSE 0 END) AS smoking_only_with_wheezing,
    SUM(CASE WHEN CHRONIC_DISEASE = 'No' AND SMOKING_status = 'No' AND WHEEZING = 'Yes' THEN 1 ELSE 0 END) AS neither_with_wheezing
FROM 
    lung_cancer;

```

13. **What is the impact of gender on the severity and number of symptoms reported?**:
```sql
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


```

14. **Can you predict the likelihood of chest pain in patients with chronic diseases and smoking habits?**:
```sql
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

```

15. **Which demographic (age and gender) has the highest risk factors for developing lung cancer based on the dataset?**:
```sql
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

```

16. **who smoke and who don't smoke?**:
```sql
SELECT 
    smoking_status,
    COUNT(*) AS patient_count
FROM lung_cancer
GROUP BY smoking_status;

```
**same query with windows function.**
```sql
WITH smoker_data AS (
    SELECT smoking_status, COUNT(*) AS count
    FROM lung_cancer
    GROUP BY smoking_status
)
SELECT * FROM smoker_data;

```


## Findings

- **Demographic Patterns**: The dataset reveals that the majority of lung cancer cases are concentrated in individuals aged 50 and above.
A higher incidence is observed among male patients compared to female patients.
- **Smoking as a Key Risk Factor**: Over 70% of diagnosed patients have a history of smoking, strongly correlating with the presence of lung cancer.
- **Symptom Analysis**:The most reported symptoms among diagnosed cases are coughing, chest pain, and shortness of breath.
Specific combinations of symptoms have a higher predictive value for lung cancer diagnosis.
- **Lifestyle and Occupational Risk Factors**: Data suggests a potential link between exposure to pollutants and lung cancer, especially in patients reporting occupational hazards.
- **Data Quality Insights**: Several records required normalization to ensure consistency, including converting binary codes (1/2) into descriptive labels.

## Reports

- **Data analysis:**: Translating raw data into actionable insights.
- **Predictive Indicators:**: Smokers with chronic diseases had a higher likelihood of reporting symptoms like chest pain.
- **Healthcare analytics**: Understanding risk factors and symptom correlations.
  
## Conclusion

The SQL analysis of the Lung Cancer dataset demonstrates the power of structured querying for deriving actionable insights from raw data. The findings emphasize the critical role of lifestyle and environmental factors in lung cancer prevalence, highlighting areas for targeted interventions such as anti-smoking campaigns and workplace safety measures.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional questions.

## Author - Deepak

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and follow

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media.

- **LinkedIn**: [Connect with me professionally]([https://www.linkedin.com/in/deepak-analyst-485b602a3/](https://www.linkedin.com/in/deepak-analyst-485b602a3/)

Thank you for your support, and I look forward to connecting with you!
