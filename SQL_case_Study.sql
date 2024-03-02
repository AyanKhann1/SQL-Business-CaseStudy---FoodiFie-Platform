-- 1) How many customers has Foodie-Fi ever had?

select
    count(distinct customer_id) as total_customers

from
    subscriptions

-- 2) What is the monthly distribution of trial plan start_date values for our dataset use the start of the month as the group by value?

with trial_plans as (
select
    plan_id
from
    plans
where
    plan_name = 'trial' and price = 0 )

select
    extract (month from start_date) as month_number, 
    count(customer_id) as total_customers
from
    subscriptions join trial_plans
    on (subscriptions.plan_id = trial_plans.plan_id)
group by
    month_number
order by
    month_number;


-- 3) What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name?

select
    subscriptions.plan_id,
    plans.plan_name,
    count(start_date) as total_events
from
    subscriptions join plans
    on (subscriptions.plan_id = plans.plan_id)
where
    extract(year from start_date) > '2020'
group by
    plan_id,
    plans.plan_name

order by
    plan_id;

-- 4) What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

select
    count(distinct customer_id) as total_customers,
    count(case when plan_name = 'churn' then 1 end) as churn_customers,
    round((count(case when plan_name = 'churn' then 1 end) /
    count(distinct customer_id) 100), 1) as churn_rate
from
    subscriptions join plans
    on (subscriptions.plan_id = plans.plan_id);

-- 5) How many customers have churned straight after their initial free trial what percentage is this rounded to the nearest whole number?

with ranking as (
select *,
    rank() over(partition by customer_id order by start_date) as rp
from
    subscriptions )

select
    count(case when rp 2 and plan_name = 'churn' then 1 end) as churn_customers, 
    round(count(case when xp = 2 and plan_name = 'churn' then 1 end) / count(distinct customer_id) * 100) as churn_rate
from
    ranking join plans 
    on ranking.plan_id = plans.plan_id;

-6) What is the number and percentage of customer plans after their initial free trial?

with ranking as (
select *,
    rank() over(partition by customer_id order by start_date) as ranking
from
    subscriptions)

select
    plans.plan_id,
    plan_name,
    count(plans.plan_id) as conversions,
    round((cast(count(plans.plan_id) as decimal) / (select count(plan_id) from ranking where ranking 2) 100), 1) as conversion_percentage
from
    ranking join plans
    on (ranking.plan_id = plans.plan_id)
where
    ranking = 2
group by
    plans.plan_id,
    plan_name
order by
    plan_id;

-- 7) What is the customer count and percentage breakdown of all 5 plan_name values

at 2020-12-31?

with ranking as (
select *,
    rank() over(partition by customer id order by start_date desc) as rank
from
    subscriptions
where
    start_date '2020-12-31')

select
    plan_name,
    count(plans.plan_id) as customer_count,
    round(cast(count(plans.plan_id) as decimal) / (select count(customer_id) from ranking where rank = 1) 100, 1) as customer_percentage
from
    ranking join plans on (ranking.plan_id = plans.plan_id)
where
    rank = 1
group by
    plan_name
order by
    customer_count desc;

-- 8) How many customers have upgraded to an annual plan in 2020?

select
    count(distinct customer_id) as total_customers
from
    subscriptions join plans
    on (subscriptions.plan_id = plans.plan_id)
where
    subscriptions.plan_id = 3 and plan_name = 'pro annual' and extract(year from start_date) = '2020';

-- 9) How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

with trial_info as (
select
    customer_id,
    start_date as trial days
from
    subscriptions join plans
    on (subscriptions.plan_id = plans.plan_id)
where
    subscriptions.plan_id = 0),
    annual info as ( select customer_id, start_date as annual_days 
                    from subscriptions join plans on (subscriptions.plan_id = plans.plan_id)
                    where subscriptions.plan_id = 3)

select
    round(avg(DATEDIFF(annual_days, trial_days)), 0) as avg_days
from
    trial_info join annual_info 
    on (trial_info.customer_id= annual_info.customer_id);

-- 10) Can you further breakdown this average value into 30 day periods? (1.e. 8-30 days, 31-60 days etc)

with trial_info as (
select
    customer id,
    start date as trial days
from
    subscriptions
where
    plan_id =
),

annual info as (
select
    customer_id,
    start date as annual_days
from
    subscriptions
where
    plan_id = 3
),

buckets as (
select
    floor(datediff(annual days, trial days)/30) as avg days
from
    trial info join annual info 
    on trial info.customer_id= annual_info.customer_id)

select
    concat((avg_days 30), '', ((avg_days 1) 30), days') as breakdown, count(*) as customers
from
    buckets
group by
    avg_days
order by
    avg_days;

-- 11) How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

with next_plan_cte as (
select
    customer_id,
    plan_id,
    start_date,
    lead(plan_id, 1) over (partition by customer_id order by plan_id) as next_plan
from
    subscriptions)

select
    count(*) as downgraded_customers
from
    next_plan_cte
where
    start_date = '2020-12-31' and plan_id = 2 and next_plan = 1;

    