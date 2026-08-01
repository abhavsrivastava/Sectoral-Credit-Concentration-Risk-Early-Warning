install.packages(c("dplyr","tidyverse", "knitr"))
library(dplyr)
library(tidyverse)
library(knitr)
library(readr)
data_path <- read_csv("RBI_Sectoral_Wide.csv")
glimpse(data_path)
aggregate_rows <- c(
  "I. Bank Credit (II + III)", 
  "III. Non-food Credit", 
  "1. Agriculture and Allied Activities", 
  "2. Industry (Micro and Small, Medium and Large)", 
  "3. Services",
  "4. Personal Loans"
)
sector_data <- data_path %>%
  filter(!Sector %in% aggregate_rows) %>%
  mutate(
    Outstanding_May2026 = as.numeric(`Outstanding_May2026`),
    YoY_Growth_May2026  = as.numeric(`YoY_Growth_May2026`)
  ) %>%
  filter(!is.na(Outstanding_May2026) & !is.na(YoY_Growth_May2026))
view(sector_data)

risk_threshold <- if (trimws(userinput) == "") 15.0 else as.numeric(userinput)
if (interactive()) {
  userinput <- readline(prompt = "Enter YoY Growth Early Warning Threshold (in %)")
} else {
  userinput <- ""
}

if (is.na(risk_threshold)) {
  cat("Invalid input detected. Defaulting threshold to 15.0%\n")
  risk_threshold <- 15.0
}
cat("\n[Early Warning Growth Threshold set to:", risk_threshold, "%\n")

avg_exposure <- mean(sector_data$Outstanding_May2026, na.rm = TRUE)
risk_classified <- sector_data %>%
  mutate(
    Risk_Quadrant = case_when(
      YoY_Growth_May2026 >= risk_threshold & Outstanding_May2026 >= avg_exposure ~ "1: High Exposure - High Growth (Systemic Risk)",
      YoY_Growth_May2026 >= risk_threshold & Outstanding_May2026 < avg_exposure  ~ "2: Low Exposure - High Growth (Emerging)",
      YoY_Growth_May2026 < risk_threshold  & Outstanding_May2026 >= avg_exposure ~ "3: High Exposure - Stable Growth (Core)",
      YoY_Growth_May2026 < risk_threshold  & Outstanding_May2026 < avg_exposure  ~ "4: Low Exposure - Low Growth (Low Concern)"
    ),
    Alert_Status = ifelse(YoY_Growth_May2026 >= risk_threshold, "Great Growth", "Normal")
  )

gmean <- mean(risk_classified$YoY_Growth_May2026, na.rm = TRUE)  
gsd <- sd(risk_classified$YoY_Growth_May2026, na.rm = TRUE)
outlier <- risk_classified %>%
  mutate(ZScore = (YoY_Growth_May2026 - gmean) / gsd) %>%
  filter(abs(ZScore) > 2) %>%
  select(Sector, Outstanding_May2026, YoY_Growth_May2026, ZScore)
cat("\n--- SUMMARY ---\n")
cat("Risk Threshold   :", risk_threshold, "%\n")
cat("Total Sectors Analyzed   :", nrow(risk_classified), "\n")
cat("Average Sector Exposure (₹ '000 Cr)  :", round(avg_exposure, 2), "\n")
cat("Sectors Triggering Growth Alert       :", sum(risk_classified$Alert_Status == "Great Growth"), "\n\n")
cat("--- TOP SYSTEMIC RISK SECTORS (Q1) ---\n")
risk_classified %>%
  filter(str_detect(Risk_Quadrant, "Q1")) %>%
  select(Sector, Outstanding_May2026, YoY_Growth_May2026) %>%
  arrange(desc(Outstanding_May2026)) %>%
  print()
cat("\n--- OUTLIERS (|Z| > 2) ---\n")
print(outlier)

mdcontent <- paste0(
   "# Sectoral Credit Concentration & Risk Early Warning
   **Risk Threshold :** ", risk_threshold, "%  
   **Total Sectors Analyzed :** ", nrow(risk_classified), "  
   **Average Sector Exposure (₹ '000 Cr):** ", round(avg_exposure, 2), " Thousand Crore  
   **Sectors Triggering Growth Alert :** ", sum(risk_classified$Alert_Status == "Great Growth"), "
  ## Top Systemic Risk Sectors (High Exposure & High Growth)
    ", kable(
    risk_classified %>%
    filter(str_detect(Risk_Quadrant, "1")) %>%
    select(Sector, `Outstanding May2026` = Outstanding_May2026, `YoY Growth (in %)` = YoY_Growth_May2026, `Status` = Alert_Status) %>%
    arrange(desc(`Outstanding May2026`)),
    format = "markdown"
    ), "
 ## OUTLIERS (|Z| > 2)
 ", kable(
  outlier %>% select(Sector, `Outstanding May2026` = Outstanding_May2026, `YoY Growth (%)` = YoY_Growth_May2026, ZScore),
  format = "markdown"
 ), "
 "
 )
writeLines(mdcontent, "SUMMARY.md")
  

  
  