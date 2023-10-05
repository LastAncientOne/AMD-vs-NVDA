# Load necessary libraries
library(quantmod)
library(ggplot2)

# Define the stock symbols, market symbol, start date, and end date
symbols <- c('AMD', 'NVDA')
market <- 'SPY'  # S&P 500 market symbol
start <- '2018-01-01'
end <- '2023-08-01'

# Download the stock data
getSymbols(symbols, from = start, to = end)
getSymbols(market, from = start, to = end)

# Extract adjusted closing prices
amd_adj_close <- Ad(AMD)
nvda_adj_close <- Ad(NVDA)
spy_adj_close <- Ad(get(market))

# Create a data frame with the adjusted closing prices
data <- data.frame(AMD = amd_adj_close, NVDA = nvda_adj_close, SPY = spy_adj_close)

# Fit linear regression models for AMD and NVDA against SPY
model_amd <- lm(AMD ~ SPY, data = data)
model_nvda <- lm(NVDA ~ SPY, data = data)

# Summary of regression models
summary(model_amd)
summary(model_nvda)

# Calculate residuals for both models
residuals_amd <- residuals(model_amd)
residuals_nvda <- residuals(model_nvda)

# Calculate MAE for both models
mae_amd <- mean(abs(residuals_amd))
mae_nvda <- mean(abs(residuals_nvda))

# Calculate MSE for both models
mse_amd <- mean(residuals_amd^2)
mse_nvda <- mean(residuals_nvda^2)

# Calculate RMSE for both models
rmse_amd <- sqrt(mse_amd)
rmse_nvda <- sqrt(mse_nvda)

# Print the results
cat("AMD Model:\n")
cat("MAE:", mae_amd, "\n")
cat("MSE:", mse_amd, "\n")
cat("RMSE:", rmse_amd, "\n")

cat("\nNVDA Model:\n")
cat("MAE:", mae_nvda, "\n")
cat("MSE:", mse_nvda, "\n")
cat("RMSE:", rmse_nvda, "\n")

# Make predictions using the linear regression models
predicted_amd <- predict(model_amd, newdata = data)
predicted_nvda <- predict(model_nvda, newdata = data)

# Create a new DataFrame with actual and predicted values
prediction_df <- data.frame(
  Date = index(data),
  Actual_AMD = data$AMD,
  Predicted_AMD = predicted_amd,
  Actual_NVDA = data$NVDA,
  Predicted_NVDA = predicted_nvda
)

# Print the DataFrame
print(prediction_df)
