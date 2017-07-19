library(DT)
library(shiny)
library(googleVis)
shinyServer(function(input, output){
    output$map2 <- renderGvis({
        gvisGeoChart(hospitalgroup, "State", input$selected,
                     options=list(region="US", displayMode="regions", 
                                  resolution="provinces",
                                  width="auto", height="auto", colorAxis="{colors:['red', 'purple', 'blue']}"))
    })
    output$map <- renderGvis({
      gvisGeoChart(hospitalgroup, "State", input$selected2,
                   options=list(region="US", displayMode="regions", 
                                resolution="provinces",
                                width="auto", height="auto", colorAxis="{colors:['red', 'purple', 'blue']}"))
    })
    
    output$scatter <- renderGvis({
      gvisScatterChart(hospitalgroup[,c(input$selected,
                                         input$selected2)])
    })
    
    output$plot <- renderPlotly({
      plot_ly(hospitalgroup, x = ~get(input$selected),
              y = ~get(input$selected2),
              text= ~paste("State: ", State),
              height = 300) %>% 
        layout(xaxis = list(title = input$selected), yaxis = list(title = input$selected2))
    })



    output$pie4 <- renderPlotly({
      #prep for pie
      belowhosp = hospital  %>% filter(.,get(input$selected3) =='Below the National average')  %>% group_by(.,Hospital.overall.rating)  %>% summarise(total=n())   
      samehosp = hospital  %>% filter(.,get(input$selected3) =='Same as the National average')  %>% group_by(.,Hospital.overall.rating)  %>% summarise(total=n())
      abovehosp = hospital  %>% filter(.,get(input$selected3) =='Above the National average')  %>% group_by(.,Hospital.overall.rating)  %>% summarise(total=n())
      p <- plot_ly() %>%
        add_pie(data = belowhosp,labels = ~Hospital.overall.rating, values = ~total,
                name = 'below', domain = list(x = c(0, 0.4), y = c(0.4, 1))) %>%
        add_pie(data = samehosp, labels = ~Hospital.overall.rating, values = ~total,
                name = "same", domain = list(x = c(0.25, 0.75), y = c(0, 0.6))) %>%
        add_pie(data = abovehosp, labels = ~Hospital.overall.rating, values = ~total,
                name = "above", domain = list(x = c(0.6, 1), y = c(0.4, 1))) %>%
        layout(title = "Overall Rating Distribution by Comparison Values", showlegend = F,
               xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
               yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    })
    
    output$heat <- renderPlotly({
      a=cor(hospitalgroup1[,2:9], use="pairwise.complete.obs")
      plot_ly(
        
        x = colnames(a), y = colnames(a),
        z = a, type = "heatmap", colors = colorRamp(c("orange", "yellow","green"))
      ) %>% 
        layout(title="Correlation Heatmap", margin=list(
          l = 90,
          r = 50,
          b = 100,
          t = 100,
          pad = 4
        )
        )
    })
    
    #output$table <- DT::renderDataTable({
      #datatable(hospitalgroup3, rownames=FALSE) #%>% 
        #formatStyle(input$selected, background="skyblue", fontWeight='bold')
    #})
    
    output$plot2 <- renderPlotly({
      hospitalgroup4 = hospital2 %>% group_by(., State) %>%
        summarise("total"=sum(!is.na(get(input$selected4)))) %>% 
        inner_join(.,hospitalgroup)
      plot_ly(hospitalgroup4, x = ~total,
              y = ~get(input$selected4),
              text= ~paste("State: ", State),
              height = 300) %>% 
        layout(xaxis = list(title = "Number of Hospitals"), yaxis = list(title = input$selected4))
    })
    
    output$table <- DT::renderDataTable({
      hospitalgroup5 = hospital2 %>% group_by(., State) %>%
        summarise("total"=sum(!is.na(get(input$selected5)))) %>% 
        inner_join(.,hospitalgroup) %>% 
        select('State', input$selected5,"total")
      datatable(hospitalgroup5, rownames=FALSE) %>% 
      formatStyle(input$selected5, background="skyblue", fontWeight='bold')
      })
    
})

    
  
    
   
    # show histogram using googleVis
    # output$hist <- renderGvis({
    #     gvisHistogram(hospitalgroup[,input$selected, drop=FALSE])
    # })
    
    #show data using DataTable
     
     

   
    #show statistics using infoBox
    # output$maxBox <- renderInfoBox({
    #     max_value <- max(hospitalgroup[,input$selected])
    #     max_state <-
    #         hospitalgroup$State[hospitalgroup[,input$selected] == max_value]
    #     infoBox(max_state, max_value, icon = icon("hand-o-up"))
    # })
    # output$minBox <- renderInfoBox({
    #     min_value <- min(hospitalgroup[,input$selected])
    #     min_state <-
    #         hospitalgroup$State[hospitalgroup[,input$selected] == min_value]
    #     infoBox(min_state, min_value, icon = icon("hand-o-down"))
    # })
    # output$avgBox <- renderInfoBox(
    #     infoBox(paste("AVG.", input$selected),
    #             mean(hospitalgroup[,input$selected]),
    #             icon = icon("calculator"), fill = TRUE))
