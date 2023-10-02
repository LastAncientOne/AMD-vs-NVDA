# Load required libraries
library(quantmod)

# Suppress warnings
options(warn=-1)

# Define the stock symbols and market benchmark
symbols <- c("AMD", "NVDA")
start_date <- "2018-01-01"
end_date <- "2023-08-01"

# Download stock data
getSymbols(symbols, from = start_date, to = end_date)

# Loop through the symbols and extract monthly data
for (symbol in symbols) {
  # Extract the data for the symbol
  stock_data <- get(symbol)
  
  # Convert to monthly data
  monthly_data <- to.monthly(stock_data, indexAt = 'lastof', OHLC = FALSE)
  
  # Print the symbol name
  cat("Symbol:", symbol, "\n")
  
  # Print the monthly data
  print(monthly_data)
  
  # You can perform additional analysis on 'monthly_data' here
}