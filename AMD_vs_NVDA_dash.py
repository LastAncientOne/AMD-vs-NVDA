# -*- coding: utf-8 -*-
"""
Created on Thu Dec 21 17:10:19 2023

@author: Tin Hang
"""
# Use this link http://127.0.0.1:8050/
import dash
from dash import dcc, html
import yfinance as yf

# Download data
symbols = ['AMD', 'NVDA']
market = '^GSPC'
start = '2018-01-01'
end = '2023-08-01'

df = yf.download(symbols + [market], start=start, end=end)['Adj Close']

# Calculate daily returns for stocks and the market
df['Daily Return AMD'] = df['AMD'].pct_change()
df['Daily Return NVDA'] = df['NVDA'].pct_change()
df['Daily Return Market'] = df[market].pct_change()

# Normalize closing prices for stocks and market benchmark
normalized_df = (df - df.min()) / (df.max() - df.min())

# Create Dash app
app = dash.Dash(__name__)

# Define app layout
app.layout = html.Div([
    html.H1("Stock Data Dashboard"),
    dcc.Graph(
        id='line-plot',
        figure={
            'data': [
                {'x': df.index, 'y': df['AMD'], 'type': 'line', 'name': 'AMD'},
                {'x': df.index, 'y': df['NVDA'], 'type': 'line', 'name': 'NVDA'},
                {'x': df.index, 'y': df[market], 'type': 'line', 'name': 'Market'}
            ],
            'layout': {
                'title': 'Stock Prices Over Time'
            }
        }
    ),
    dcc.Graph(
        id='normalized-plot',
        figure={
            'data': [
                {'x': normalized_df.index, 'y': normalized_df['AMD'], 'type': 'line', 'name': 'AMD'},
                {'x': normalized_df.index, 'y': normalized_df['NVDA'], 'type': 'line', 'name': 'NVDA'},
                {'x': normalized_df.index, 'y': normalized_df[market], 'type': 'line', 'name': 'Market'}
            ],
            'layout': {
                'title': 'Normalized Stock Prices Over Time'
            }
        }
    )
])

# Run the app
if __name__ == '__main__':
    app.run_server(debug=True)