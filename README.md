# Rice Variety Classification: Cammeo vs Osmancik

This repository contains a Data Mining project focused on the classification of two certified rice varieties from Turkey: **Cammeo** and **Osmancik**.

## Project Overview

The goal is to build a predictive model capable of distinguishing between the two rice species based on 7 morphological features extracted from high-resolution images.

### Dataset Description

The dataset includes 3,810 grain images. For each grain, the following features were measured:

\- **Area**: Number of pixels within the boundaries of the grain.

\- **Perimeter**: Distance around the grain boundary.

\- **Major_Axis_Length**: The longest line that can be drawn through the grain.

\- **Minor_Axis_Length**: The shortest line perpendicular to the major axis.

\- **Eccentricity**: Measurement of how circular or elliptical the grain is.

\- **Convex_Area**: Area of the smallest convex shell that fits the grain.

\- **Extent**: Ratio of the area of the grain to its bounding box.

**TARGET:** `Class` (Cammeo vs Osmancik).

## Repository Content

-   `Rice_Analysis_Report.Rmd`: RMarkdown file with data cleaning, exploratory analysis (EDA), and model building.
-   `Rice_Analysis_Report.html`: Final compiled report with visualizations and comments.
-   `rice.arff`: The raw data in ARFF format.
-   `Rice_Analysis`: Script

## Methodology

1.  **Data Preprocessing**: Conversion of the target variable into a binary format (1 for Cammeo, 0 for Osmancik).
2.  **Feature Scaling**: Applied Min-Max normalization for distance-based algorithms.
3.  **Model Selection**:
    -   Comparison between **K-Nearest Neighbors (K-NN)** and **Logistic Regression**.
    -   Hyperparameter tuning for K-NN using a validation set.
4.  **Evaluation**: Final assessment using Accuracy, F1-Score, Log-Loss, and ROC Curve analysis.

## Key Results

The **Logistic Regression** model outperformed K-NN, showing high robustness in separating the two classes. Detailed metrics and threshold analysis are available in the `.html` report.

## Data Source

The dataset used in this project is the **Rice (Cammeo and Osmancik) Dataset**, sourced from the **UCI Machine Learning Repository**.

\- **Original Authors**: Cinar, I., & Koklu, M. (2019).

\- **Link**: [UCI Machine Learning Repository - Rice Dataset] ([https://archive.ics.uci.edu/ml/datasets/Rice+(Cammeo+and+Osmancik)](https://archive.ics.uci.edu/ml/datasets/Rice+(Cammeo+and+Osmancik)){.uri})

\- **Citation**: Cinar, I., & Koklu, M. (2019). Classification of Rice Varieties Using Artificial Intelligence Methods. International Journal of Intelligent Systems and Applications in Engineering.

--- *Developed for the Data Mining University Course.*
