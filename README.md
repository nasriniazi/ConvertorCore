# ConvertorCore

A description of this package.
- use coinRanking API -- #https://captain-eo.hashnode.dev/introduction-to-the-coinranking-api

The /coin/:uuid/price endpoint will return the price of a coin at a specific time alongside its timestamp.

Query Parameters

referenceCurrencyUuid (optional)    String    UUID of reference currency. This is the currency the price is shown in, which defaults to US Dollar 

Default value: yhjMzLPhuIDl
timestamp (optional)    Number    Timestamp. Epoch timestamp in seconds. If it is not provided this endpoint will get the latest price

- Retrieves the lastest price of Bitcoin
- for networking makes use of Local Networking Package


