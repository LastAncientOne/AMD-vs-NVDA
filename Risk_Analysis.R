# Load necessary libraries
library(quantmod)

# Suppress warnings
options(warn=-1)

# Define the stock symbols, market symbol, start date, and end date
symbols <- c('AMD', 'NVDA')
market <- 'GSPC'
start <- '2018-01-01'
end <- '2023-08-01'

# Download the stock data
getSymbols(symbols, from = start, to = end)
getSymbols(market, from = start, to = end)

# Create a loop to calculate metrics for each stock
for (symbol in symbols) {
  # Extract stock data
  stock_data <- get(symbol)
  
  # Calculate Investment Amount (Assuming equal investment in each stock)
  initial_investment <- 10000  # Change this to your desired initial investment
  shares_bought <- initial_investment / Ad(stock_data)[1]
  
  # Calculate Drawdown
  daily_returns <- dailyReturn(Cl(stock_data))
  cum_returns <- cumprod(1 + daily_returns)
  drawdown <- cum_returns / cummax(cum_returns) - 1
  average_drawdown <- mean(drawdown, na.rm = TRUE)
  min_drawdown <- min(drawdown, na.rm = TRUE)
  max_drawdown <- max(drawdown, na.rm = TRUE)
  
  # Calculate Standard Error and Standard Deviation
  standard_error <- sqrt(var(daily_returns, na.rm = TRUE))
  standard_deviation <- sd(daily_returns, na.rm = TRUE)
  
  # Calculate VaR (Value at Risk)
  confidence_level <- 0.95  # Change this to your desired confidence level
  var_amount <- quantile(daily_returns, 1 - confidence_level, na.rm = TRUE)
  
  # Calculate Conditional Value at Risk (CVaR)
  cvar_amount <- mean(daily_returns[daily_returns <= var_amount], na.rm = TRUE)
  
  # Print the results
  cat("Stock:", symbol, "\n")
  cat("Investment Amount:", initial_investment, "\n")
  cat("Average Drawdown:", average_drawdown, "\n")
  cat("Min Drawdown:", min_drawdown, "\n")
  cat("Max Drawdown:", max_drawdown, "\n")
  cat("Standard Error:", standard_error, "\n")
  cat("Standard Deviation:", standard_deviation, "\n")
  cat("VaR:", var_amount, "\n")
  cat("CVaR:", cvar_amount, "\n")
  cat("VaR Amount:", var_amount * shares_bought, "\n")
  cat("\n")
}
