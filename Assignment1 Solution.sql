create database ass1 ;
use ass1 ;

select * from netflix ;
/* Q1 Retrieve all Netflix Originals with an IMDb score greater than 7, 
runtime greater than 100 minutes, and the language is either English or Spanish. /*

select * from netflix where IMDBScore > 7 AND Runtime > 100 and Language in ("English","Spanish") ;

/* Q2 Find the total number of Netflix Originals in each language,
but only show those languages that have more than 5 titles. /*

select Language, count(*) as Total_Number  from netflix 
group by language having Total_Number > 5 order by Total_Number desc ;

/*Q3. Get the top 3 longest-running movies in Hindi language
sorted by IMDb score in descending order.
/*
select Title, Runtime, IMDBScore, Language from netflix 
where Language ="Hindi" order by IMDBScore desc limit 3;

/*Q4 Retrieve all titles that contain the word "House" in their name
and have an IMDb score greater than 6. /*

select Title, IMDBScore from netflix 
where Title LIKE "%house%" and IMDBScore >6 ;

/*Q5 Find all Netflix Originals released between the years 2018 and 2020 
that are in either English, Spanish, or Hindi. /*

select Title, Language, Premiere_Date from netflix
where Language IN ("English","Spanish","Hindi") AND 
Premiere_Date BETWEEN "2008-01-01" AND "2020-12-31" ;

/*BECAUSE IN THE Q6 DATATYPE OF PREMIERE_DATE HAS BEEN CHANGED TO DATE FORMAT SO IN THE Q5, 
I HAVE USED THE DATE FORMAT AS Y-M-D IN WHERE CLAUSE. /*

/*Q6 Find all movies that either have a runtime less than 60 minutes 
or an IMDb score less than 5, sorted by Premiere Date. /*

UPDATE netflix
SET Premiere_Date = STR_TO_DATE(Premiere_Date, '%d-%m-%Y');

Alter table netflix modify column Premiere_Date Date ;
 commit ;

select Title, Runtime, IMDBScore, Premiere_Date from netflix
WHERE Runtime < 60 OR IMDBScore < 5 order by Premiere_Date asc ;

/*7. Get the average IMDb score for each genre 
where the genre has at least 10 movies. /*

select GenreID, Round(AVG(IMDBScore),2) as Average_Score, COUNT(*) as Total_Movie_Count 
from netflix group by GenreID having Total_Movie_Count > 9  order by Average_Score desc ;

-- Q8. Retrieve the top 5 most common runtimes for Netflix Originals.

select Runtime, count(*) as Total_Watch_Count
from netflix group by Runtime 
order by Total_Watch_Count DESC LIMIT 5 ;

/* Q9 List all Netflix Originals that were released in 2020, grouped by language, 
and show the total count of titles for each language. /*

Select Language, Count(*) as Total_Movies
from netflix where Premiere_Date LIKE "2020%" group by Language ;

/*Q10 Create a new table that enforces a constraint on the IMDb score 
to be between 0 and 10 and the runtime to be greater than 30 minutes. /*

Create Table Netflix_Filtered as
select * from netflix where IMDBScore IS NOT NULL AND Runtime >30 ;

Alter table Netflix_Filtered MODIFY IMDBScore Decimal(3,1) NOT NULL ;

Alter table Netflix_Filtered add constraint check ( IMDBScore between 0 and 10) ;
Alter table Netflix_Filtered add constraint check ( Runtime >30) ;


select * from Netflix_Filtered ;

Commit ;

