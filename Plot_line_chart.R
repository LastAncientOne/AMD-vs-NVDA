# Load required libraries
library(quantmod)

# Suppress warnings
options(warn = -1)

# Define the stock symbols and market benchmark
symbols <- c("AMD", "NVDA")
start_date <- "2018-01-01"
end_date <- "2023-08-01"

# Download stock data
getSymbols(symbols, from = start_date, to = end_date)

# Combine the closing prices of AMD and NVDA into a single data frame
stock_prices <- merge(Cl(AMD), Cl(NVDA))

# Create a time series plot using base R plotting functions
plot(index(stock_prices), stock_prices[, 1], type = "l", col = "red",
     ylim = range(stock_prices), xlab = "Date", ylab = "Price",
     main = "Stock Prices of AMD and NVDA")
lines(index(stock_prices), stock_prices[, 2], col = "green")
legend("topleft", legend = c("AMD", "NVDA"), col = c("red", "green"), lty = 1)


# Function to normalize data
normalize <- function(x) {
  return(x / x[1])
}

# Normalize stock prices
normalized_prices <- apply(stock_prices, MARGIN = 2, FUN = normalize)

# Convert to data frame
normalized_df <- data.frame(Date = index(normalized_prices), coredata(normalized_prices))
names(normalized_df) <- c("Date", "AMD", "NVDA")

# Melt data for ggplot
melted_data <- melt(normalized_df, id.vars = "Date")

# Plotting with ggplot
ggplot(melted_data, aes(x = Date, y = value, color = variable)) +
  geom_line() +
  labs(title = "Normalized Stock Prices of AMD and NVDA",
       y = "Normalized Price", x = "Date") +
  scale_color_manual(values = c("red", "green"), labels = c("AMD", "NVDA")) +
  theme_minimal()