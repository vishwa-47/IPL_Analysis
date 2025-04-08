drop table if exists IPL;

create table IPL(
	id	bigint,
	season varchar(20),
	city varchar(25),
	date date,
	match_type varchar(20),
	player_of_match varchar(25),
	venue varchar(100),
	team1 varchar(40),
	team2 varchar(40),
	toss_winner varchar(40),
	toss_decision varchar(40),
	winner varchar(40),
	result varchar(40),
	result_margin varchar(20),
	target_runs varchar(20),
	target_overs varchar(20),
	super_over varchar(20),
	method varchar(20),
	umpire1 varchar(40),
	umpire2 varchar(40)
	

)

select * from IPL




-- find the top 5 umpire based on the total number of matches they worked on




with t1 as(
	select umpire1,
	count(id) as count1
from IPL
	group by 1
),


t2 as(
	select umpire2,
	count(id) as count2
from IPL
	group by 1
)

select umpire1, 
	(count1+count2) as total_number_of_matches 
	from t1 
inner join t2 
on t1.umpire1 = t2.umpire2

group by umpire1,2
order  by 2 desc



---find the topp 5 teams with most wins



select winner,
	count(id)
from IPL
group by winner
order by 2 desc
limit 5




--- find out the team who have  won many times in this particular day every year(april 10th)




select winner,count(id) from(	
select winner,date,
extract(month from date) as month,
extract (day from date) as day,
	id 
from IPL
	group by 4,3,2,1,5
order by 4
)
where month = 4 and day= 10
group by 1
order by 2 desc




--- find the 5 player with most number of player of the match



select player_of_match,
	count(id) as total_POM
from  IPL
group by 1
order by 2 desc
limit 5 





---find the top 5 teams which won the toss and even the match






select winner,
	count(id)
from(
select id,
	toss_winner,
	winner,
case
	when toss_winner = winner then 'same'
	else 'different'
end as toss_and_match_winner
from IPL
) where toss_and_match_winner = 'same'
group by 1
order  by 2 desc








---find the teams which won the  most by choosing to bowl first 


select winner,
	count(bowl_match_winner)
	from(
select toss_winner,
	winner,
	toss_decision,
case
	when toss_winner = winner and toss_decision = 'field' then 'wow'
	else 'not wow'
end as bowl_match_winner
from IPL
) where bowl_match_winner = 'wow'
group by 1
order  by 2 desc



---find the teams that won most number of toss and match but the match should have  been to super  over





select winner,
	count(id),
	super_over
from(
select id,
	toss_winner,
	winner,
case
	when toss_winner = winner then 'same'
	else 'different'
end as toss_and_match_winner,
	super_over
from IPL
) where toss_and_match_winner = 'same' and  super_over = 'Y'
group by 1,3
order  by 2 desc






--find the total number of times each team reached finals



select split_part(teams,'$',1) as teams,
	count(id) as number_of_times_teams_reached_finals
	from(
select concat(team1,'$',team2) as teams,
	id
from IPL
where match_type = 'Final'
) as t1
group by 1
order by 2 desc




---rank the team based on total number of wins till now


select winner,
	count(id),
	dense_rank()over(order by (count(id))desc )
from IPL
where match_type = 'League'
group by winner
limit 5 






---find out in which stadium most matches were played


select venue,
count(id)
from  IPL
group by 1
order by 2 desc



















