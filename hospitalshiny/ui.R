library(DT)
library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(
    dashboardHeader(title = "My Dashboard"),
    dashboardSidebar(
        
        sidebarUserPanel("Will Markowitz",
                         image = "https://yt3.ggpht.com/-04uuTMHfDz4/AAAAAAAAAAI/AAAAAAAAAAA/Kjeupp-eNNg/s100-c-k-no-rj-c0xffffff/photo.jpg"),
        sidebarMenu(
            menuItem("Map", tabName = "map2", icon = icon("map")),
            menuItem("Data", tabName = "data", icon = icon("database")),
            menuItem("Pies", tabName= "pies", icon = icon("pie-chart"))
        )#,
        # selectizeInput("selected4",
        #                "Select Item to Display",
        #                choice), #this is an input called selected
        # selectizeInput("selected420",
        #                "Select Item to Display2",
        #                choice)
    ),
    dashboardBody( #BO
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
        ),
        tabItems(
            tabItem(tabName = "map2",
                    fluidRow(infoBoxOutput("maxBox"),
                             infoBoxOutput("minBox"),
                             infoBoxOutput("avgBox")),
                    fluidRow(box(htmlOutput("map2"), height = 300),
                             box(htmlOutput("map"), height = 300),
                             box(htmlOutput("scatter"))),
                    fluidRow(
                      selectizeInput("selected",
                                     "Select Item to Display1",
                                     choice)
                    ),
                    fluidRow(
                      selectizeInput("selected2",
                                     "Select Item to Display23",
                                     choice)
                    )
                             ),
            tabItem(tabName = "data",
                    fluidRow(box(DT::dataTableOutput("table"), width = 12))),
            tabItem(tabName = "pies",
                    fluidRow(
                      selectizeInput("selected3",
                                     "Select Item to Display",
                                     choice[2:8])
                    ),
                    fluidRow(
                      
                      plotlyOutput("pie4")
                    
                    
                    )
                    
                    )
          
        )
        )
    )
)