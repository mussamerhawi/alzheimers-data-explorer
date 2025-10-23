# This is the single-file structure for the Alztool Shiny App.

# Load required packages
library(shiny)
library(ggplot2)
library(dplyr)
library(Alztool) # Your custom package is essential!

# --- Data Setup (Runs once when the app starts) --------------------------------

# We are using a simplified, simulated data setup, as discussed,
# to keep the app quick and portable for deployment.

sim_data <- data.frame(
  patient_id = 1:200,
  bmi = runif(200, 15, 45),
  mmse = sample(c(NA, 15:30), 200, replace = TRUE),
  gender = sample(c("Male", "Female"), 200, replace = TRUE)
)

# Apply your custom functions to process the data immediately upon app start
processed_data <- sim_data %>%
  Alztool::classify_bmi() %>%
  Alztool::standardize_mmse()

# Define min/max BMI for the slider (Runs once)
min_bmi <- floor(min(processed_data$bmi, na.rm = TRUE))
max_bmi <- ceiling(max(processed_data$bmi, na.rm = TRUE))


# --- 1. Define UI (User Interface) ---------------------------------------------
ui <- fluidPage(
  # Application title
  titlePanel("Alztool: Clinical Data Explorer"),
  
  # Sidebar with controls for plotting
  sidebarLayout(
    sidebarPanel(
      # Input 1: Selection for the variable to plot (X-axis for the bar chart)
      selectInput("y_var",
                  "Select Variable to Analyze:",
                  choices = c("BMI Category" = "bmi_category",
                              "Cognitive Status" = "cognitive_status"),
                  selected = "bmi_category"),
      
      # Input 2: Filter by gender
      radioButtons("gender_filter",
                   "Filter by Gender:",
                   choices = c("All", "Male", "Female"),
                   selected = "All"),
      
      # Input 3: Filter by BMI Range
      hr(), # Horizontal rule for separation
      sliderInput("bmi_range", 
                  "Filter by Continuous BMI Range:",
                  min = min_bmi, 
                  max = max_bmi, 
                  value = c(min_bmi, max_bmi)) # Default to full range
    ),
    
    # Show a plot of the generated analysis
    mainPanel(
      # New Output: Summary Statistics Text
      h4("Summary Statistics for Filtered Population (BMI)"),
      textOutput("summaryStats"), 
      hr(),
      # Existing Plot Output
      plotOutput("analysisPlot")
    )
  )
)

# --- 2. Define Server Logic ----------------------------------------------------
server <- function(input, output) {
  
  # The reactive expression that filters the data based on user input
  # This data is used by BOTH the plot and the summary statistics.
  filtered_data <- reactive({
    data_to_filter <- processed_data
    
    # 1. Gender Filtering
    if (input$gender_filter != "All") {
      data_to_filter <- data_to_filter %>%
        filter(gender == input$gender_filter)
    }
    
    # 2. BMI Range Filtering
    min_b <- input$bmi_range[1] 
    max_b <- input$bmi_range[2] 
    
    data_to_filter <- data_to_filter %>%
      filter(bmi >= min_b & bmi <= max_b)
    
    return(data_to_filter)
  })
  
  # NEW: The output definition for the summary statistics
  output$summaryStats <- renderText({
    data <- filtered_data() # Access the filtered data
    
    # 1. Calculate statistics
    mean_bmi <- mean(data$bmi, na.rm = TRUE)
    sd_bmi <- sd(data$bmi, na.rm = TRUE)
    n_subjects <- nrow(data)
    
    # 2. Format the output string
    paste0("Subjects in Filtered Group (n): ", n_subjects, 
           "<br>Mean BMI: ", round(mean_bmi, 2), 
           "<br>Standard Deviation (SD): ", round(sd_bmi, 2))
  })
  
  # The output definition for the plot
  output$analysisPlot <- renderPlot({
    
    # 1. Get the filtered data
    data <- filtered_data()
    
    # 2. Get the variable selected by the user (from the UI)
    y_column <- input$y_var
    
    # 3. Create a bar chart showing the count of each category
    data %>%
      ggplot(aes(x = .data[[y_column]], fill = .data[[y_column]])) +
      geom_bar() +
      labs(title = paste("Distribution of", y_column, "by Count"),
           x = y_column,
           y = "Count") +
      theme_minimal(base_size = 14) +
      theme(legend.position = "none")
  })
  
}

# --- 3. Run the application ----------------------------------------------------
shinyApp(ui = ui, server = server)