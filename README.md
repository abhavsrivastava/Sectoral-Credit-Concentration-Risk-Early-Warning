# Sectoral Credit Concentration & Risk Early Warning
This project provides an interactive risk matrix and monitoring tool designed to detect systemic risk, over-leveraged sub-sectors, and rapid credit expansion across different sectors of the Indian economy (e.g. *Agriculture*, *Industries*, *Services* and *Personal Loans*) based on the sectoral data provided by The Reserve Bank of India (RBI). 

### About The Reserve Bank of India		
	
The [Reserve Bank of India](https://rbi.org.in/Scripts/AboutUsDisplay.aspx) is India's central bank, and the regulatory organisation for the Indian banking system and Indian currency. It is owned by the Ministry of Finance, Government of the Republic of India, it is responsible for the control, issue, and supply of the Indian rupee. It also manages the country's main payment systems and maintains its credit system.

## Data Sources & Origin
The dataset used in this project is sourced directly from the official financial statistics released by the central bank of India:
* **Source Authority:** [Reserve Bank of India (RBI)](https://www.rbi.org.in/)
* **Dataset Name:** *Sectoral Deployment of Bank Credit* (Statements I & II)
* **Dataset Information:** Monthly data on sectoral deployment of bank credit for the month of May 2026, collected from 41
select scheduled commercial banks (SCBs) which together account for about 95 per cent of
the total non-food credit by all SCBs

## Prerequisites & Environment Setup

To run the data processing scripts or interact with the dashboard, follow the installation steps below for **R**, **RStudio**, and **Tableau**.

### 1. Installing R & RStudio (Data Processing & Plotting)

R is used for data cleaning, aggregation, and generating initial exploratory plots (such as ggplot2 scatter plots).

#### Download & Install R
1. Go to the official CRAN website: [https://cran.r-project.org/](https://cran.r-project.org/)
2. Select your operating system (**Download R for Windows**, **Download R for macOS**, or **Linux**).
3. Click on **base** (or *install R for the first time*) and download the latest installer.
4. Run the installer executable and follow the default setup prompts.

#### Download & Install RStudio Desktop
1. Go to the Posit download page: [https://posit.co/download/rstudio-desktop/](https://posit.co/download/rstudio-desktop/)
2. Click **Download RStudio Desktop for Windows**,**macOS**,**Linux**.
3. Run the installer and complete the setup.
4. Open RStudio and verify R is recognized by running:
   ```R
   sessionInfo()

### 2. Installing Tableau (Interactive Dashboard)
1. Go to [Tableau Desktop](https://www.tableau.com/products/desktop/download) or [Tableau Public](https://public.tableau.com/)
2. Download the installer for Windows or macOS.
3. Activate using your license key (*In case of Tableau Desktop*)
4. Enter your email and run the downloaded installation wizard (*In case of Tableau Public*)

## Experimental Goals & Core Objectives

This project was built to simulate a quantitative risk assessment environment for commercial banking and macro-prudential oversight. The main experimental goals include:

1. **Quantify Sectoral Concentration Risk:** 
	* Evaluate credit exposure distribution across major industrial, service, retail, and agricultural categories to identify capital heavy-reliance and concentration vulnerabilities.

2. **Implement Dynamic Early-Warning Indicator (EWI) Thresholds:**
	* Test how varying Year-over-Year (YoY) credit growth rate thresholds (*Risk Threshold*) shift sectors between "Normal Growth" and "Great Growth" states in real time.

3. **Isolate High-Risk Growth Quadrants (Risk Matrix Analysis):**
	* Map sectors into a 4-quadrant exposure-growth matrix to differentiate between high-exposure/high-growth systemic risks (e.g., *Services*, *Housing*) versus niche high-growth outliers (e.g., *Loans against Gold Jewellery*).

4. **Establish Interactive Visual Cross-Filtering:**
	* Build an integrated multi-sheet dashboard (Heatmap, Scatter plot, and Ranking Bar Chart) where filtering or highlighting a sector instantly reflects across all visual dimensions.

## **Detailed Report** 
For complete granular tabular metrics, dynamic heatmaps, and exhaustive sector-by-sector systemic risk breakdowns, inspect the full executive report in [SUMMARY](./SUMMARY.md).
