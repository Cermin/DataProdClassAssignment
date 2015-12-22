stateRateMap <- function(data, color,gname,max,min){
            
            states_map <- map_data("state")
            
            #aggregate data to get mean latitude and mean longitude for each state
            snames <- aggregate(cbind(long, lat) ~ region, data=states_map, 
                                FUN=function(x) mean(range(x)))
            
            
            #state.abb data set has the abbreviations for the state.
            sabb<-state.abb
            
            # remove Alaska and Hawaii from the list
            drop <-c("AK","HI")
            sabb <-sabb[ - which(sabb %in% drop)]
            
            #add DC to the state abbreviation to match the order in snames
            sabb<- append(sabb,"DC",7)
           
            
            # add the state abbreviation as a column to snames
            snames_new <-cbind(snames,sabb)
            
            # rename the sabb column so we can use the column name and not confuse
            # using the sabb vector as well as the column region to state
            colnames(snames_new)[4] <- "StateAbb"
            colnames(snames_new)[1] <- "state" 
            
            
            # create a vector with values of the selected crimedata
            value <- data[,2]
            crime <- colnames(data) # to be used for the title 
            
            
            
            #plot the graph based on the values selected.
            gg <- ggplot(data, aes(map_id=state), environment=environment()) 
            gg <- gg + geom_map(aes(fill = value), 
                        map = states_map) +
                        expand_limits(x = states_map$long, y = states_map$lat) + 
                        theme(legend.position = "bottom",
                            axis.ticks = element_blank(), 
                            axis.title = element_blank(), 
                            axis.text =  element_blank()) +
                        scale_fill_gradient(low="white", high= color, 
                                            name = gname) + 
                        guides(fill = guide_colorbar(barwidth = 10, 
                                                     barheight = .5)) +  
                       ggtitle(paste0("Choropleth Map for ",crime[[2]])) +
                      geom_text(data=snames_new, aes(long, lat, label = StateAbb),
                                size=3) 
                                 
            print(gg)
}

