library(DT)
library(shiny)
library(googleVis)

shinyServer(function(input, output){
    # show map using googleVis
    output$map2 <- renderGvis({
        gvisGeoChart(hospitalgroup, "State", input$selected,
                     options=list(region="US", displayMode="regions", 
                                  resolution="provinces",
                                  width="auto", height="auto"))
    })
    
    output$map <- renderGvis({
      gvisGeoChart(hospitalgroup, "State", input$selected2,
                   options=list(region="US", displayMode="regions", 
                                resolution="provinces",
                                width="auto", height="auto"))
    })
    
    output$scatter <- renderGvis({
      gvisScatterChart(hospitalgroup[,c(input$selected, 
                                         input$selected2)])
    })
 
    
    
#prep for pie
belowhosp = hospital  %>% filter(.,Mortality.national.comparison=='Below the National average')  %>% group_by(.,Hospital.overall.rating)  %>% summarise(total=n())   
samehosp = hospital  %>% filter(.,Mortality.national.comparison=='Same as the National average')  %>% group_by(.,Hospital.overall.rating)  %>% summarise(total=n())
abovehosp = hospital  %>% filter(.,Mortality.national.comparison=='Above the National average')  %>% group_by(.,Hospital.overall.rating)  %>% summarise(total=n())
#SEE HOW YOU CAN USE DROPDOWN
   
    
    output$pie4 <- renderPlotly({
      p <- plot_ly() %>%
        add_pie(data = belowhosp, labels = ~Hospital.overall.rating, values = ~total,
                name = 'below', domain = list(x = c(0, 0.4), y = c(0.4, 1))) %>%
        add_pie(data = samehosp, labels = ~Hospital.overall.rating, values = ~total,
                name = "same", domain = list(x = c(0.25, 0.75), y = c(0, 0.6))) %>%
        add_pie(data = abovehosp, labels = ~Hospital.overall.rating, values = ~total,
                name = "above", domain = list(x = c(0.6, 1), y = c(0.4, 1))) %>%
        layout(title = "Pie Charts with Subplots", showlegend = F,
               xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
               yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    })
    
   
    # show histogram using googleVis
    # output$hist <- renderGvis({
    #     gvisHistogram(state_stat[,input$selected, drop=FALSE])
    # })
    
    # show data using DataTable
     output$table <- DT::renderDataTable({
         datatable(hospitalgroup, rownames=FALSE) %>% 
            formatStyle(input$selected, background="skyblue", fontWeight='bold')
     })
    
    # show statistics using infoBox
    # output$maxBox <- renderInfoBox({
    #     max_value <- max(state_stat[,input$selected])
    #     max_state <- 
    #         state_stat$state.name[state_stat[,input$selected] == max_value]
    #     infoBox(max_state, max_value, icon = icon("hand-o-up"))
    # })
    # output$minBox <- renderInfoBox({
    #     min_value <- min(state_stat[,input$selected])
    #     min_state <- 
    #         state_stat$state.name[state_stat[,input$selected] == min_value]
    #     infoBox(min_state, min_value, icon = icon("hand-o-down"))
    # })
    # output$avgBox <- renderInfoBox(
    #     infoBox(paste("AVG.", input$selected),
    #             mean(state_stat[,input$selected]), 
    #             icon = icon("calculator"), fill = TRUE))
})