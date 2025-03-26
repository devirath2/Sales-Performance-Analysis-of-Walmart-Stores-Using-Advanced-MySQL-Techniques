create database assignment2 ;

select * from sales ;
select * from games ;

alter table games modify ReleaseDate date ;

commit ;

-- Q1 BELOW :
insert into games values ( 151, "Future Racing", "Racing", "2024-10-01","Speed Studios") ;

-- Q2 BELOW : 
update sales set Price=60 where GameID=2 ;

-- Q3 BELOW : 
delete from sales where GameID=5 ;

-- Q4 BELOW : 
SELECT g.GameTitle, SUM(s.UnitsSold) AS Total_Units_Sold
FROM Sales s
left JOIN Games g ON s.GameID = g.GameID
GROUP BY g.GameTitle;

-- Q5. BELOW : 
select  g.GameTitle, sum(s.UnitsSold) as Max_units_sold from sales s 
left join games g on s.GameID=g.GameID 
where s.SalesRegion = "North America"
group by g.gameTitle order by Max_units_sold desc LIMIT 1 ;

-- Q6. BELOW : 
select g.GameTitle,s.Platform,s.SalesRegion, s.UnitsSold as Total_Units
from Games g left join Sales s on g.GameID=s.GameID order by Total_Units desc ;

-- Q7. BELOW : 
select g.GameTitle,g.GameID,s.UnitsSold,s.Platform from
Games g left join Sales s on g.GameID=s.GameID ;

-- Q8. BELOW :
select g.GameTitle,g.GameID,s.UnitsSold,s.Platform from
Games g left join Sales s on g.GameID=s.GameID where g.GameTitle is null or g.GameID is null ;

-- Q9. BELOW : 
select DISTINCT g.GameTitle,g.GameID,s.UnitsSold,s.Platform , s.SalesRegion,s.Price from
Games g left join Sales s on g.GameID=s.GameID where s.SalesRegion in ("North America","Europe") ;

-- Q10. BELOW : (same query just remove the distinct keyword )

select  g.GameTitle,g.GameID,s.UnitsSold,s.Platform , s.SalesRegion,s.Price from
Games g left join Sales s on g.GameID=s.GameID where s.SalesRegion in ("North America","Europe") ;









