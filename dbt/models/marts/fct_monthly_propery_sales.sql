select
    transaction_month,
    district,
    property_type,
    count(*) as transaction_count,
    round(avg(price)) as average_price,
    percentile_cont(0.5)
        within group (order by price) as median_price
from {{ ref('int_property_sales_with_periods') }}
group by 1, 2, 3