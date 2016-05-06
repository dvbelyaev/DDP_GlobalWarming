# Loading dataset
data <- read.csv("./data/TemperaturesByCountry.csv")

# Making the list of countries for selectInput control
countries <- as.list(unique(data$Country))
names(countries) <- unique(data$Country)

# Selecting the year's range for sliderInput control
min_year <- min(data$Year)
max_year <- max(data$Year)

shinyUI(fluidPage(
        
        # Application title
        titlePanel("Global Warming"),

        # Control panel        
        sidebarLayout(sidebarPanel(
                
                # Selecting country name
                selectInput(
                        "country",
                        label = h4("Country:"),
                        choices = countries,
                        selected = 1
                ),
                
                # Selecting range of years for plotting
                sliderInput(
                        "years",
                        label = h4("Years:"),
                        min = min_year,
                        max = max_year,
                        value = c(min_year, max_year),
                        sep = ""
                ),
                
                # Selecting temperature scale
                radioButtons(
                        "tempscale",
                        label = h4("Temperature Scale:"),
                        choices = list("Celsius" = 1, "Fahrenheit" = 2),
                        selected = 1
                )
                
        ),
        
        mainPanel(
                tabsetPanel(type = "tabs",
                            
                            # Ploting the temperatures for selected 
                            # country and time period
                            tabPanel("Plot",
                                     br(),
                                     plotOutput("warmingPlot")
                                     ),
                            
                            # Summarizing of temperatures change for selected
                            # country and time period
                            tabPanel("Summary",
                                     h3(textOutput("titleSummary")),
                                     br(),
                                     h4("Relative annual average temperature change:"),
                                     p(htmlOutput("startTemp")),
                                     p(htmlOutput("endTemp")),
                                     p(htmlOutput("diffTemp")),
                                     br(),
                                     h4("Absolute annual average temperature difference:"),
                                     p(htmlOutput("minTemp")),
                                     p(htmlOutput("maxTemp")),
                                     p(htmlOutput("adiffTemp"))
                                     ),
                            
                            # Help panel
                            tabPanel("Help",
                                     br(),
                                     h3("To visualize data:"),
                                     p("- open panel ", strong("Plot")),
                                     p("- select ", strong("Country")),
                                     p("- choose the interval of ", strong("Years")),
                                     p("- set the ", strong("Temperature Scale")),
                                     br(),
                                     h3("To get data summary:"),
                                     p("- open panel ", strong("Summary"))
                                     )
                            )
                )
        )
))
