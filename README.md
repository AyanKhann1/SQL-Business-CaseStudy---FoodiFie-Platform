# sql_foodiefi_portfolio_project

Introduction:
Danny identified a market gap and launched Foodie-Fi, a streaming service exclusively for food-related content, 
like Netflix but dedicated to cooking shows.

Foodie-Fi offers monthly and annual subscriptions, providing unlimited on-demand access to exclusive food videos 
worldwide. With a data-driven approach, Danny aimed to make informed investment decisions and develop new features
using subscription-style digital data. This case study emphasizes the use of data to address crucial business inquiries.


Table1: PLANS
-- Customers choose plans (Basic or Pro) when signing up for Foodie-Fi.
-- Basic plan: Limited access, monthly subscription at $9.90.
-- Pro plan: No watch time limits, offline video downloads. Monthly subscription starts at $19.90 or annual subscription at $199.
-- Customers get a 7-day free trial, automatically continuing with Pro monthly unless they cancel, downgrade to Basic, or upgrade to Annual Pro.
-- When customers cancel, they have a churn plan record with null price but continue until the billing period ends.


Table2: SUBSCRICTIONS
-- Customer subscriptions have start dates corresponding to their specific "plan_id". 
-- Downgrades or cancellations of subscriptions result in the higher plan remaining in place until the current period ends. 
-- "start_date" in the subscriptions table reflects the date when the plan change occurs.
-- Upgrades from a basic plan to a pro or annual pro plan take effect immediately. 
-- Churned customers retain access until the end of their billing period. 
-- The "start_date" technically represents the day they decided to cancel the service.
