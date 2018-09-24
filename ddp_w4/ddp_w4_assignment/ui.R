fluidPage(
  # Application title
  titlePanel("Word Cloud")
  
  ,hr()
  ,p("In a survey there are several ways in which a person can write a category.")
  ,p("This word-cloud shows how many ways each category is written.")
  ,hr()
  ,p("The categories are the chilean originary people groups ('pueblos originarios').")
  ,hr()
  ,p("This page allows for scaling of the numbers, you can choose between showing the original number (Quantity), or apply functions to that number: logarithm (log()) or square root (sqrt())")
  
  ,sidebarLayout(
    # Sidebar with a slider and selection inputs
    sidebarPanel(
      selectInput("selection", "Choose a book:",
                  choices = funcs),
      actionButton("update", "Change"),
      hr(),
      sliderInput("freq",
                  "Minimum Frequency:",
                  min = 1,  max = 50, value = 2),
      sliderInput("max",
                  "Maximum Number of Words:",
                  min = 1,  max = 30,  value = 20)
    ),
    
    # Show Word Cloud
    mainPanel(
      plotOutput("plot")
    )
  )
)
