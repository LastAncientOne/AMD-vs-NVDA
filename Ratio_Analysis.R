Load necessary libraries
library(quantmod)

# Suppress warnings
options(warn = -1)

# Define the stock symbols, market symbol, start date, and end date
symbols <- c('AMD', 'NVDA')
market <- 'GSPC'
start <- '2018-01-01'
end <- '2023-08-01'

# Download the stock data
getSymbols(symbols, from = start, to = end)
getSymbols(market, from = start, to = end)

# Create a data frame to store the results
results <- data.frame(
  Stock = character(0),
  Avg_Return = numeric(0),
  Std_Deviation = numeric(0),
  Annual_Trading = numeric(0),
  Beta = numeric(0),
  Alpha = numeric(0),
  R_Squared = numeric(0),
  Decrease_Count = numeric(0),
  Increase_Count = numeric(0),
  Total_Rows = numeric(0),
  Sharpe_Ratio = numeric(0),
  Sharpe_Ratio_Trading = numeric(0),
  ROI = numeric(0),
  CAGR = numeric(0),
  Loss_Rate = numeric(0),
  Win_Rate = numeric(0)
)

# Loop through each stock symbol
for (symbol in symbols) {
  stock_data <- get(symbol)
  market_data <- get(market)
  
  # Calculate the required metrics
  returns <- dailyReturn(stock_data)
  market_returns <- dailyReturn(market_data)
  excess_returns <- returns - market_returns
  risk_free_rate <- 0.001  # Replace with the appropriate risk-free rate
  
  avg_return <- mean(returns, na.rm = TRUE)
  std_deviation <- sd(returns, na.rm = TRUE)
  annual_trading <- sqrt(252) * avg_return
  beta <- lm(excess_returns ~ market_returns)$coefficients[2]
  alpha <- mean(excess_returns) - beta * mean(market_returns)
  r_squared <- summary(lm(excess_returns ~ market_returns))$r.squared
  decrease_count <- sum(diff(returns) < 0, na.rm = TRUE)
  increase_count <- sum(diff(returns) > 0, na.rm = TRUE)
  total_rows <- nrow(stock_data)
  sharpe_ratio <- (avg_return - risk_free_rate) / std_deviation
  sharpe_ratio_trading <- sharpe_ratio * sqrt(252)
  roi <- prod(1 + returns) - 1
  cagr <- (prod(1 + returns)^(252/total_rows)) - 1
  loss_rate <- decrease_count / total_rows
  win_rate <- increase_count / total_rows
  
  # Add the results to the data frame
  results <- rbind(results, data.frame(
    Stock = symbol,
    Avg_Return = avg_return,
    Std_Deviation = std_deviation,
    Annual_Trading = annual_trading,
    Beta = beta,
    Alpha = alpha,
    R_Squared = r_squared,
    Decrease_Count = decrease_count,
    Increase_Count = increase_count,
    Total_Rows = total_rows,
    Sharpe_Ratio = sharpe_ratio,
    Sharpe_Ratio_Trading = sharpe_ratio_trading,
    ROI = roi,
    CAGR = cagr,
    Loss_Rate = loss_rate,
    Win_Rate = win_rate
  ))
}

# Print the results
print(results)
