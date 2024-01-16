use music_store_data;
select * from playlist_tracK;

#easy Questions
#1Who  is the senior most employee based on job title?
select * from employee  order by levels desc limit 2;

#2Which countries has most Invoices?
select count(*) as c,billing_country from invoice group by billing_country order by c desc;

#3what are top 3 values of Total invoice?
Select * from invoice order by totaL desc limit 3;

#4 Which city has the best customers?. We would like to throw a promotional Music Festival in the city we made the most money. 
#Write a query that returns the highest sum of the invoice totals.Return both the city name and sum  of all invoice totals?.
select sum(total) as s,billing_city from invoice  group by billing_city order by s  desc ;

#5 Who is the best customer?.The customer who has spent the most money will be declared the best customer.
-- Write a query that returns the person who has spent the most money?
select customer.customer_id ,customer.first_name ,customer.last_name ,sum(invoice.total) as total
from customer join invoice on customer.customer_id=invoice.customer_id group by customer.customer_id,
customer.first_name, customer.last_name order by total desc limit 1;


#Moderate Questions:
#1 write a query  to return the email, first name ,last name, & Genre of all Rock Music Listeners.
-- Return your list  ordered alphabetically by email starting with A
 select distinct email, first_name,last_name from customer join invoice on customer.customer_id=invoice.customer_id join 
 INVOICE_line on invoice.invoice_id=invoice_line.invoice_id where track_id in(select track_id from track 
 join genre on track.genre_id=genre.genre_id where genre.name Like 'Rock') order by email;
 
#2) Lets invite the artists who have written the most rock music in our dataset. Write a query 
--  that returns the Artist name and total count  of the top  10 rock bands.
select artist.artist_id,artist.name,count(artist.artist_id) as number_of_songs from track join album on track.album_id=album.album_id
join artist on artist.artist_id=album.artist_id join genre on track.genre_id=genre.genre_id where
 genre.name like 'Rock'  group by artist.artist_id ,artist.name order by number_of_songs Desc limit 10;


#3) Return all the track names that have a song length longer than the average song length.alter
-- Return the name and  Milli Seconds for each track. Order by the song length with the longest song 
-- listed first?
select track.name, track.milliseconds  from track 
where milliseconds>(select avg(milliseconds) as avg_mill_seconds from track) order by milliseconds desc;

#Advance
#Q1) find how much amount spent by each customer on artists?
-- write  a query  to return customer name, artist name and total spent 


with best_selling_artist as (select artist.artist_id as artist_id,artist.name as artist_name, 
sum(invoice_line.unit_price*invoice_line.quantity) as total_money  from invoice_line 
join track on invoice_line.track_id=track.track_id join album on track.album_id=album.album_id 
join artist on artist.artist_id=album.artist_id group by 1,artist_name order by 3 desc limit 1 )
 
select c.customer_id,c.first_name,c.last_name,bsa.artist_name ,sum(ila.unit_price*ila.quantity) as total_spent from invoice i join
customer c on i.customer_id=c.customer_id join invoice_line ila on i.invoice_id=ila.invoice_id join track t on ila.track_id=t.track_id
join album alb on t.album_id=alb.album_id join best_selling_artist bsa on alb.artist_id=bsa.artist_id group by 1,2,3,4
  order by 5 Desc limit 5;
  
  
#Q2) We want  to find out the most popular music genre for each country. We determine the most popular genre as the genre with highest 
-- amount of purchases.write  a query that returns each country along  with the top genre, For countries where the maximum number of purchases 
-- shared return all Genres?.
with popular_genre As (
select count(invoice_line.quantity) as purchases , customer.country, genre.name ,genre.genre_id ,
ROW_NUMBER() OVER (partition By customer.country order by count(invoice_line.quantity) Desc )as Row_no
from invoice_line join invoice on invoice_line.invoice_id=invoice.invoice_id join customer on invoice.customer_id=customer.customer_id 
join track on invoice_line .track_id=track.track_id join genre on track.genre_id=genre.genre_id
group by customer.customer_id , customer.country, genre.name , genre.genre_id order by customer.country asc,purchases desc)
 select * from popular_genre where Row_no <=1;