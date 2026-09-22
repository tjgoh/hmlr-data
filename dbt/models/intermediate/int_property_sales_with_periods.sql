select
    *,
    date_trunc('month', date_of_transfer)::date as transaction_month,
    extract(year from date_of_transfer)::int as transaction_year
from {{ ref('stg_price_paid') }}