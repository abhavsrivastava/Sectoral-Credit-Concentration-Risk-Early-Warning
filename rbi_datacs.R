#Structuring and cleaning the data to make it more clear
install.packages(c("readxl", "dplyr", "tidyr", "stringr", "tidyverse"))
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(tidyverse)
file_path <- "Downloads/SIBCS30062026.xlsx"
raw_data <- read_xlsx(file_path, sheet = "Statement 1", skip = 1)
colnames(raw_data) <- c("Sector", "Outstanding_May2024", "Outstanding_Mar2025", "Outstanding_May2025", 
  "Outstanding_Mar2026", "Outstanding_May2026","YoY_Growth_May2025", "YoY_Growth_May2026", 
  "FY_Growth_May2025", "FY_Growth_May2026"
)
clean_sectoral_data <- raw_data %>%
  slice(-c(1,2)) %>%
  filter(!is.na(Sector)) %>%
  mutate(across(starts_with("Outstanding"), as.numeric) ,
           across(starts_with("YoY"), as.numeric),
           across(starts_with("FY"), as.numeric)) %>%
           mutate(Sector = str_trim(Sector))
view(clean_sectoral_data)
write.csv(clean_sectoral_data, "RBI_Sectoral_Wide.csv", row.names = FALSE)
write.csv(tableau_data, "RBI_Sectoral_LTableau.csv", row.names = FALSE)
# You can use this data for analysis in R itself or you can use it in business intelligence tools like Tableau
#Sectoral Credit Concentration vs Growth Risk
major_sectors <- clean_sectoral_data %>%
  filter(!str_detect(Sector,"Bank Credit|Food Credit|Non-food Credit"))
ggplot(major_sectors, aes(x = Outstanding_May2026 / 1000, y = YoY_Growth_May2026, label = Sector))+
  geom_point(aes(size = Outstanding_May2026, color = YoY_Growth_May2026 > 15), alpha = 0.6) +
  geom_text(vjust = -0.7, size = 3, check_overlap = TRUE) +
  scale_color_manual(values = c("FALSE" = "darkblue", "TRUE" = "darkred"),
                     labels = c("Normal Growth", "Great Growth")) +
  geom_hline(yintercept = 15, linetype = "dashed", color = "red") +
  theme_minimal() +
  labs(
    title = "Sectoral Credit Concentration vs Growth Risk",
    x = "Outstanding Credit (in Thousand Crore)",
    y = "YoY Growth Rate (in %)",
    color = "Risk Level"
  )





    
    
  