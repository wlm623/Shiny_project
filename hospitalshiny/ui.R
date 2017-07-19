library(DT)
library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(
    dashboardHeader(title = "My Dashboard"),
    dashboardSidebar(
        
        sidebarUserPanel("Will Markowitz",
                         image = "https://yt3.ggpht.com/-04uuTMHfDz4/AAAAAAAAAAI/AAAAAAAAAAA/Kjeupp-eNNg/s100-c-k-no-rj-c0xffffff/photo.jpg"),
        sidebarMenu(
            menuItem("Correlation", tabName = "corr", icon= icon("th")),
            menuItem("Map", tabName = "map2", icon = icon("map")),
            menuItem("Pie Chart", tabName= "pies", icon = icon("pie-chart")),
            menuItem("Data", tabName = "dat", icon = icon("database")),
            menuItem("Scatter Plot", tabName = "scatter", icon = icon("ellipsis-v"))
            
        )
    ),
    dashboardBody( 
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ),
        tabItems(
            tabItem(tabName = "corr",
                    fluidRow(plotlyOutput("heat"))
                    ),
            tabItem(tabName = "map2",
                    
                    fluidRow(
                      selectizeInput("selected",
                                     "Select Item to Display on Left",
                                     choice),
                      selectizeInput("selected2",
                                     "Select Item to Display on Right",
                                     choice)
                    ),
                    
                    
                    
                    fluidRow(infoBoxOutput("maxBox"),
                             infoBoxOutput("minBox"),
                             infoBoxOutput("avgBox")),
                    fluidRow(box(htmlOutput("map2"), height = 300),
                             box(htmlOutput("map"), height = 300)),
                    fluidRow(
                      plotlyOutput("plot")
                    )
                             ),
            tabItem(tabName = "scatter",
                    fluidRow(
                      selectizeInput("selected4",
                                     "Select Item to Display",
                                     choice)
                    ),
                    fluidRow(
                      plotlyOutput("plot2")
                    )
                    ),
            
            tabItem(tabName = "pies",
                    fluidRow(
                      selectizeInput("selected3",
                                     "Select Item to Display",
                                     choice[2:8])
                    ),
                    fluidRow(
                      
                      plotlyOutput("pie4")
                    
                    
                    )
                    ),
            tabItem(tabName = "dat",
                    fluidRow(
                      selectizeInput("selected5",
                                     "Select Item to Display",
                                     choice[1:8])),
                      fluidRow(box(DT::dataTableOutput("table"), width = 12))
                    )
            
              
            )
          
        )
        )
    )
