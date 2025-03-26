create database assignment3 ;
use assignment3 ;
select * from titanic ;
-- Q1. 
select concat(first_name,' ',last_name) as Full_Name,age from titanic where age in ( select max(age) from titanic) ;

-- Q2. 
create view survival_status as select concat(first_name,' ',last_name) as Full_name , survived, class,age, fare from titanic ;

-- Q3. 
Delimiter //
create procedure age_range(in min_age int, in max_age int)
begin
select first_name,last_name,age from titanic where age between min_age and max_age ;
end  //
delimiter ;
call age_range(25,45) ;

-- Q4. 
select concat(first_name,' ',last_name) as Full_Name, fare,
case 
when fare > 50000 then "High"
when fare < 35000 then "Low" else "Medium"
end as Category
from titanic ;

-- Q5. 
select Passenger_No, concat(first_name,' ',last_name) as Full_Name, fare, lead(fare,1,"LAST PASSENGER") OVER
( order by Passenger_No) as next_passenger_fare from titanic ;

-- Q6. 
select Passenger_No, concat(first_name,' ',last_name) as Full_Name, age, lag(age,1,"1ST PASSENGER") OVER
( order by Passenger_No) as next_passenger_fare from titanic ;

-- Q7.  
select concat(first_name,' ',last_name) as Full_Name, fare, rank() over
 ( order by fare desc) as Rankings from titanic ;
 
 -- Q8. 
select concat(first_name,' ',last_name) as Full_Name, fare, dense_rank() over
 ( order by fare desc) as Rankings from titanic ;
 
 -- Q9. 
select concat(first_name,' ',last_name) as Full_Name, fare, row_number() over
 ( order by fare desc) as Rankings from titanic ;
 
 -- Q10. 
 
 with average_fare as ( 
 select avg(fare) as average_price from titanic)
 select Passenger_No, first_name, last_name,fare from titanic t join average_fare a on t.fare>a.average_price  ;
 