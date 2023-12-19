--What is the average spending by Categories?
create view Total_spending_on_categories as 
select 
	category,
	sum(spend) as total_spend
from 
	fact_spends 
group by 
	category
order by 
	total_spend desc


--which occupation spends the most?
create view Spending_nature_by_occupation as 
select 
	c.occupation,
	sum(f.spend) Total_spends
from 
	dim_customers c
	join fact_spends f on c.customer_id = f.customer_id
group by 
	c.occupation
order by 
	Total_spends desc

--which category customers spends the most by occupation?
create view Primary_spending_Categories_by_occupation as 
select 
	c.occupation,
	f.category,
	sum(f.spend) Total_spends
from 
	dim_customers c
	join fact_spends f on c.customer_id = f.customer_id
group by 
	f.category,
	c.occupation
order by 
	Total_spends desc


--What is the average Income Utilisation of Customers?
create view Avg_income_utilization as 
with cte as (
select 
	c.customer_id,
	avg(f.spend) as avg_spend,
	avg(c.avg_income) as avg_income,
	cast(cast(avg(f.spend) as decimal(10,1)) /
		cast(avg(c.avg_income) as decimal(10,1)) * 100 as decimal(10,2)) as income_utilization_per
from 
	fact_spends f
join dim_customers c on f.customer_id = c.customer_id
group by 
	c.customer_id

)
	select 
		cast(avg(income_utilization_per) as decimal (10,2)) income_utilization_percent
	from cte


--Who is the Most Spending Age Group?
create view most_spending_age_group as
select 
	c.age_group,
	sum(f.spend) as total_spend
from 
	fact_spends f
join dim_customers c on f.customer_id = c.customer_id
group by 
	c.age_group
order by 
	total_spend desc



--What is the prefered Mode Of Payment of most spending age group?
create view Prefered_Mode_Of_Payment_of_most_spending_age_group as 
select 
	f.payment_type,
	sum(f.spend) as total_spend
from 
	dim_customers c
	join fact_spends f on c.customer_id = f.customer_id 
where 
	c.age_group in ('25-34','35-45')
group by 
	f.payment_type
order by 
	total_spend desc



--Most Spending Gender
create view Most_spending_gender as 
select 
	c.gender,
	sum(f.spend) as total_spend
from 
	fact_spends f
join dim_customers c on f.customer_id = c.customer_id
group by 
	c.gender
order by 
	total_spend desc

--Most spending month
create view Most_spending_month as 
select 
	month,
	sum(spend) as total_spend
from 
	fact_spends 
group by 
	month
order by 
	total_spend desc



--Nature of spending based on genders (male)
create view Male_spending_nature as 

	select 
	c.gender,
	f.category,
	avg(f.spend) as total_spend
from 
	fact_spends f
join dim_customers c on f.customer_id = c.customer_id
where 
	gender = 'male'
group by 
	c.gender,
	f.category
order by 
	total_spend desc

--nature of spending based on genders (female)
create view Female_spending_nature as 

	select 
	c.gender,
	f.category,
	avg(f.spend) as total_spend
from 
	fact_spends f
join dim_customers c on f.customer_id = c.customer_id
where 
	gender = 'female'
group by 
	c.gender,
	f.category
order by 
	total_spend desc



