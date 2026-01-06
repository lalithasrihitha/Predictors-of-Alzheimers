#  Predictors of Alzheimer’s

## Overview
This project investigates the cognitive and behavioral predictors of Alzheimer’s disease using statistical analysis techniques. The primary objective is to identify which factors—particularly **MMSE scores** and selected **behavioral symptoms**—are most strongly associated with an Alzheimer’s diagnosis.

---

## Dataset
- **Source:** Alzheimer’s Disease Dataset (Kaggle)
- **Sample Size:** 2,149 patients
- **Variables:** 35 features including demographics, lifestyle, cognitive scores, and behavioral symptoms
- **Target Variable:**  
  - `Diagnosis` (0 = No Alzheimer’s, 1 = Alzheimer’s)

---

## Predictors Analyzed
- **Cognitive:**  
  - Mini-Mental State Examination (MMSE)
- **Behavioral:**  
  - Memory complaints  
  - Confusion  
  - Forgetfulness  
  - Difficulty completing tasks  

---

## Methods
- Exploratory Data Analysis (EDA)
- Normality testing (Shapiro–Wilk, Q–Q plot)
- Spearman correlation
- Chi-square tests
- Mann–Whitney U test
- Logistic regression
- Odds ratio analysis
- Predicted probability modeling
- Proportion test

All analyses were conducted using **R**.

---

## Key Findings
- **MMSE score** is a strong negative predictor: lower scores are associated with a higher likelihood of Alzheimer’s diagnosis.
- **Memory complaints** significantly increase the odds of diagnosis (≈5×).
- Other behavioral symptoms (confusion, forgetfulness, difficulty completing tasks) were not statistically significant predictors.
- The logistic regression model showed a significant improvement over the null model.

---

## Conclusion
The study demonstrates that **MMSE scores and memory complaints** are the most informative predictors of Alzheimer’s disease in this dataset. These findings support the importance of cognitive screening and patient-reported memory issues in early identification efforts.

---

## Repository Contents
- `*.R` – R script for data preprocessing, statistical testing, modeling, and visualization  
- `AS REPORT.pdf` – Detailed project report  
- `AS PROJECT.pdf` – Project presentation slides  

---

## Academic Context
- **Course:** INFO-B518 – Applied Statistics in Biomedical Informatics  
- **Institution:** Indiana University Indianapolis  
- **Project Type:** Team-based academic project
