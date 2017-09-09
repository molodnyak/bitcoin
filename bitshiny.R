library("shiny")
library("shinydashboard")
library("forecast")

## app.R ##

ui <- dashboardPage(skin = "black",
  dashboardHeader(title = "Crypto Pawnshop"),
  dashboardSidebar(sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")))),
  dashboardBody(
    tabItems(

    tabItem(tabName = "dashboard",
        
    fluidRow(
     
      box(title = "BTC : bitcoincharts.com", "Volume Weighted Average Price, USD", background = "black", width = 5, solidHeader = TRUE,
        plotOutput("forecast", height = 500, width = 655)),
      
      box(
        title = "Confidence level, %", background = "black", width = 2, 
        sliderInput("level", "", 68, 99, 95)), 
      
      box(
        title = "Credit period, days", background = "black", width = 2, 
        sliderInput("period", "", 10, 60, 20)), 
      
      box(
        title = "Year Rate of Return, %", background = "black", width = 2, 
        sliderInput("yield", "", 50, 200, 120)),
      
      box(title = "Current Price, USD", background = "aqua", width = 2,
          textOutput("current")),
      
      box(title = "Forward Price Estimation, USD", background = "yellow", width = 2,
          textOutput("forward")),
      
      box(title = "Discounted Price, USD", background = "maroon", width = 2,
          textOutput("discount"))
      
)))))

server <- function(input, output) {

  output$forecast <- renderPlot({
    farima <- forecast(auto.arima(y), h = input$period, level=c(input$level))
    plot(farima, col="#dc3912", lwd=2, lty=1, xlab="")
    
  })
  
  output$current <- renderText({
    round(y[length(y)], 3)
  })
  
  output$forward <- renderText({
      round(forecast(auto.arima(y), h = input$period, level=c((input$level)))$lower[nrow(forecast(auto.arima(y), h = input$period, level=c((input$level)))$lower)], 3)
    })
  
  output$discount <- renderText({
    round(forecast(auto.arima(y), h = input$period, level=c((input$level)))$lower[nrow(forecast(auto.arima(y), h = input$period, level=c((input$level)))$lower)]/(1+input$period/365*input$yield/100), 3)
  })
}

shinyApp(ui, server)