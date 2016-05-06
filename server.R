library(ggplot2)

# Loading dataset
data <- read.csv("./data/TemperaturesByCountry.csv")

shinyServer(function(input, output, session) {
        
        # Calculating the available year's range for selected country
        observe({
                country <- input$country
                min_year <- min(data[data$Country == country, ]$Year)
                max_year <- max(data[data$Country == country, ]$Year)
                
                # Updating the sliderInput control (range of years)
                updateSliderInput(session, "years",
                                  min = min_year, max = max_year)
        })

        # Extracting the data by country name and range of years
        warming_data <- reactive({
                
                # Choosing data for selected country and range of years 
                temps <- data[data$Country == input$country &
                              data$Year >= input$years[1] &
                              data$Year <= input$years[2],]

                # Celsius to Fahrenheit transformation
                if (input$tempscale == 2) {
                        temps$avgTemp <- (9/5)*temps$avgTemp + 32
                        tempSuff = "F"
                } else {
                        tempSuff = "C"
                }
                
                # Temperature at the left and right bounds of the year interval
                startTemp <- temps[temps$Year == input$years[1], ]$avgTemp
                endTemp <- temps[temps$Year == input$years[2], ]$avgTemp
                
                # Min and max temperatures during the year interval
                minTemp <- min(temps$avgTemp)
                maxTemp <- max(temps$avgTemp)
                minYear <- median(temps[temps$avgTemp == minTemp, ]$Year)
                maxYear <- median(temps[temps$avgTemp == maxTemp, ]$Year)
                
                list(temperatures = temps,
                     startTemp = startTemp,
                     endTemp = endTemp,
                     minTemp = minTemp,
                     maxTemp = maxTemp,
                     minYear = minYear,
                     maxYear = maxYear,
                     suffTemp = tempSuff)
        })
        
        # Plotting the selected data
        output$warmingPlot <- renderPlot({
                gg <- ggplot(warming_data()$temperatures,
                             aes(x = Year, y = avgTemp, colour = avgTemp)) +
                        geom_point(size = 2) +
                        scale_colour_gradient(high = "red", low = "blue",
                                              name = "") +
                        stat_smooth() +
                        labs(title = paste0(
                                input$country, ", ",
                                input$years[1], " - ", input$years[2], "\n"),
                             x = "Year",
                             y = paste0("Annual Average Temperature, ",
                                        warming_data()$suffTemp,
                                        "\n")) +
                        theme(plot.title = element_text(size = 22),
                              text = element_text(size = 16))
                print(gg)
        })
        
        # Summing up the data
        output$titleSummary <- renderText({
                paste0(input$country, ", ",
                       input$years[1], " - ", input$years[2])
        })
        output$startTemp <- renderText({
                paste0("- from ",
                       tags$b(paste(round(warming_data()$startTemp, 1),
                                    warming_data()$suffTemp),
                       " in the ", input$years[1]," year"))
        })
        output$endTemp <- renderText({
                paste0("- to ",
                       tags$b(paste(round(warming_data()$endTemp, 1),
                                    warming_data()$suffTemp),
                              " in the ", input$years[2]," year"))
        })
        output$diffTemp <- renderText({
                paste("- change:",
                      tags$b(paste(round(warming_data()$endTemp - 
                                         warming_data()$startTemp, 1),
                                   warming_data()$suffTemp)))
        })
        output$minTemp <- renderText({
                paste(" - min. ", 
                      tags$b(paste(round(warming_data()$minTemp, 1),
                                   warming_data()$suffTemp)),
                      " in the ", tags$b(warming_data()$minYear), " year")
        })
        output$maxTemp <- renderText({
                paste("- max. ",
                      tags$b(paste(round(warming_data()$maxTemp, 1),
                                   warming_data()$suffTemp)),
                      " in the ", tags$b(warming_data()$maxYear), " year")
        })
        output$adiffTemp <- renderText({
                paste("- difference:",
                      tags$b(paste(round(warming_data()$maxTemp - 
                                         warming_data()$minTemp, 1),
                                   warming_data()$suffTemp)))
        })
})
