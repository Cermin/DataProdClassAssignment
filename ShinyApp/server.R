
library(shiny)
library(maps)      # required for map_data function
library(datasets)  # required for USArrest dataset
library(ggplot2)


#This creates a column name called state with lower case names of states: can be 
#easily referenced
crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)
crimes$AllThree<-crimes$Murder+crimes$Assault + crimes$Rape


# load the function for calculating the stateRateMap
source("stateRateMap.R")

shinyServer(function(input, output){
            
            output$text1 <- renderText({ 
                        paste("You have selected", input$var)
            })
            
            # Reactive map of US States based on user selection of crime
            output$map1 <- renderPlot({
                        data <- switch(input$var,
                                       "Murder" = crimes[,c("state", "Murder")],
                                       "Assault" = crimes[,c("state", "Assault")],
                                       "Rape" = crimes[,c("state", "Rape")],
                                       "AllThree" = crimes[,c("state","AllThree")])
                        
                        color <- switch(input$var,
                                        "Murder" = "darkred",
                                        "Assault" = "darkgreen",
                                        "Rape" = "blue",
                                        "AllThree" = "purple")
                        gname <- "Per 100,000 People"
            
            
            
            # calling RateMap function to create choropleth maps
            stateRateMap(data, color, gname)
                      
            
                                       
            # Generate an HTML table view of the data
            output$table <- renderTable(crimes)
            
            # prepare the data to do a summary for the summary tab
            ncrimes<- crimes[,c("Murder","Assault","Rape","AllThree")]
            output$summary <- renderPrint({apply(ncrimes,2,summary)})
            
 })
            #Plot the urban population choropleth map
            output$map2 <-renderPlot({
                          data<- crimes[,c("state", "UrbanPop")]
                          color<- "orange"
                          gname<- "Percent Urban Population"

            # calling RateMap function to create choropleth maps
            stateRateMap(data, color,gname)

            })
            
            # For plotting the relationship plots based on user selection
            output$plot <- renderPlot({
                        crimeValue<-switch(input$var,
                               "Murder" =  crimes$Murder,
                               "Assault" = crimes$Assault,
                               "Rape" = crimes$Rape,
                               "AllThree" = crimes$AllThree)
                        
                        color <- switch(input$var,
                                        "Murder" = "darkred",
                                        "Assault" = "darkgreen",
                                        "Rape" = "blue",
                                        "AllThree" = "purple")
                        
                        crimeType<-switch(input$var,
                                          "Murder" = "Murder",
                                          "Assault" = "Assault",
                                          "Rape" = "Rape",
                                          "AllThree" = "AllThree")
            
                        
                        ggplot(crimes, aes(x=UrbanPop, y=crimeValue)) +
                        geom_point(shape=1,colour=color) +  # Use hollow circles
                        geom_smooth(method=lm,colour=color) +
                        labs(x="Percent Urban Population",y=crimeType)
            })
            
            
            
})