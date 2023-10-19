# Load the necessary libraries
library(quantmod)
library(forecast)

# Define the stock symbols, market symbol, start date, and end date
symbols <- c('AMD', 'NVDA')
start <- '2018-01-01'
end <- '2023-08-01'

# Fetch stock data
getSymbols(symbols, from = start, to = end)

# Create a list to store forecasts and plots
forecast_list <- list()

# Loop through each stock symbol
for (symbol in symbols) {
  # Extract adjusted closing prices
  prices <- Ad(get(symbol))
  
  # Create a time series object
  ts_data <- ts(prices, frequency = 12)
  
  # Fit ARIMA model
  arima_model <- auto.arima(ts_data)
  
  # Forecast future prices
  forecast_result <- forecast(arima_model, h = 12)  # Forecasting 12 months ahead
  
  # Add the forecast result to the list
  forecast_list[[symbol]] <- forecast_result
  
  # Plot original data
  plot(ts_data, main = paste("Original Data for", symbol), ylab = "Price")
  
  # Plot forecast
  plot(forecast_result, main = paste("Forecast for", symbol))
}

# Print the forecasts for each symbol
for (symbol in symbols) {
  cat("Forecast for", symbol, ":\n")
  print(forecast_list[[symbol]])
  cat("\n")
}

