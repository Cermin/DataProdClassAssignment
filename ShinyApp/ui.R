library(shiny)

shinyUI(fluidPage(
            navbarPage("Coursera Data Products Class Assignment"),
            
            titlePanel("Violent Crime Rates by US State"),
            h4("This data set contains statistics, in arrests per 100,000 
               residents for assault, murder, and rape in each of the 50 US states in 1973"),
            sidebarLayout(
                        sidebarPanel(
            headerPanel("US Arrest"),
            selectInput("var", label = h5("Choose a crime to display "), 
                                    choices = c("Murder", "Assault",
                                                   "Rape",
                                                   "AllThree"), selected = "Murder"),
            
            includeHTML("USCrimeRateApp.Rhtml")
            ),
            
                   
            mainPanel( textOutput("text1"),
                       plotOutput("map1",width="80%"),
                       
                        tabsetPanel(type = "tabs", 
                                tabPanel("UrbanPop", plotOutput("map2",width="80%")), 
                                tabPanel("UrbanPop and Crime Type",plotOutput("plot")),
                                tabPanel("Summary", verbatimTextOutput("summary")), 
                                tabPanel("USArrests Data", tableOutput("table"))
                               
                                    
                        ) )                       
                                    
                        )
            
            
))