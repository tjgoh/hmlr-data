with source as (

    select * from {{ source('hmlr', 'price_paid') }}

),

renamed as (

    select
        transaction_id::text as transaction_id,
        price::bigint as price,
        date_of_transfer::date as date_of_transfer,
        case property_type
            when 'D' then 'Detached'
            when 'S' then 'Semi-Detached'
            when 'T' then 'Terraced'
            when 'F' then 'Flat/Maisonette'
            when 'O' then 'Other'
            else 'Unknown'
        end as property_type,
        case old_new  
            when 'Y' then 'New'
            when 'N' then 'Old'
            else 'Unknown'
        end as old_new,
        case duration  
            when 'F' then 'Freehold'
            when 'L' then 'Leasehold'
            else 'Unknown'
        end as duration,
        paon::text as primary_addressable_object_name,
        saon::text as secondary_addressable_object_name,
        postcode::text as postcode,
        street::text as street,
        locality::text as locality,
        town_city::text as town_city,
        district::text as district,
        county::text as county,
        case ppd_category  
            when 'A' then 'Standard'
            when 'B' then 'Additional'
            else 'Unknown'
        end as price_paid_category,
        record_status::text as record_status

    from source

)

select * from renamed