# Brief Description

We designed data warehouse for hospitals that tracks patients currently getting treatment in the hospital, their prescribed medication, their illnesses and doctors attending them.

# Design

- Raw layer - raw datasets with uncleaned data
- Stage layer - data after cleaning and normalising
- Mart layer - our mart layer implements *star schema* because it allows to run analytics on the data
