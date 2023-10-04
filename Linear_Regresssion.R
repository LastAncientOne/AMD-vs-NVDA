# Load necessary libraries
library(quantmod)
library(ggplot2)

# Define the stock symbols, market symbol, start date, and end date
symbols <- c('AMD', 'NVDA')
market <- 'GSPC'  # S&P 500 market symbol
start <- '2018-01-01'
end <- '2023-08-01'

# Download the stock data
getSymbols(symbols, from = start, to = end)
getSymbols(market, from = start, to = end)

# Extract adjusted closing prices
amd_adj_close <- Ad(AMD)
nvda_adj_close <- Ad(NVDA)
gspc_adj_close <- Ad(get(market))

# Create a data frame with the adjusted closing prices
data <- data.frame(AMD = amd_adj_close, NVDA = nvda_adj_close, GSPC = gspc_adj_close)

# Fit linear regression models for AMD and NVDA against GSPC
model_amd <- lm(AMD ~ GSPC, data = data)
model_nvda <- lm(NVDA ~ GSPC, data = data)

# Summary of regression models
summary(model_amd)
summary(model_nvda)
