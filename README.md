#  Alzheimer’s Data Explorer

An interactive **Shiny web application** that allows users to explore Alzheimer’s disease data through visualizations and tables.  
This app uses the custom R package **[Alztool](https://github.com/mussamerhawi/Alztool)** — also created by the author — to add analytical columns such as BMI categories and standardized MMSE scores.

---

##  Features

- **Dynamic filtering and visualization** of Alzheimer’s diagnosis versus family history  
- **BMI category analysis** against diagnostic outcomes  
- **Cognitive status grouping** based on standardized MMSE scores  
- **Full dataset viewer** with searchable, scrollable data table  
- Built entirely with **R Shiny**, **ggplot2**, and **dplyr**

---

##  Requirements

Before running the app, make sure you have the following R packages installed:

```r
# Install from CRAN
install.packages(c("shiny", "dplyr", "DT", "ggplot2", "here", "pacman"))

# Install the custom Alztool package from GitHub
if (!require(remotes)) install.packages("remotes")
remotes::install_github("mussamerhawi/Alztool")
```
## Data Acknowledgement
The Alzheimer’s dataset used in this app was provided by McGill University for educational and demonstration purposes.  
And this repository is for academic practice only.
