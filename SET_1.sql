/*1. List out all the  artist names with relevant album count for each of them*/
USE MusicDB;

SELECT Artist.Name, COUNT (Album.AlbumId) AS ALBUM
 FROM Artist
 INNER JOIN Album ON Artist.ArtistId=Album.ArtistId
GROUP BY Artist.ArtistId, Artist.Name;

/*2. Find total number of albums composed by all artist put together */
SELECT COUNT (Album.AlbumId) AS Totalalbums
FROM Album ;

/*3. List the artist names which start with “M”*/
SELECT * FROM Artist
WHERE Name LIKE('M%');

/*4. List the album name which starts with S and ends with A */
SELECT * FROM Album
WHERE Title LIKE('S%A');

/*5. Which album has most number of tracks */
SELECT TOP 1 COUNT(Track.TrackId)AS Mostno_oftracks, 
 Album.Title AS Albums
 FROM Track
 INNER JOIN Album  ON Track.AlbumId =Album.AlbumId
 GROUP BY Album.AlbumId,Album.Title
 ORDER BY COUNT(Track.AlbumId) DESC;

/* 6. Find most expensive album based on price */
SELECT  TOP 1 Album.Title AS Album, SUM(Track.UnitPrice) AS Price
 FROM Album
 INNER JOIN Track ON Album.AlbumId=Track.AlbumId
 GROUP BY  Album.Title
 ORDER BY SUM(Track.UnitPrice) DESC;

 /*7. Which artists did not make any albums at all? 
      Include their names in your answer*/
SELECT Artist.Name ,Album.Title
 FROM Artist
 LEFT JOIN Album
 ON Artist.ArtistId = Album.ArtistId
 WHERE Album.Title IS NULL;

 /*8a. Which track is the longest?*/
SELECT TOP 1 Track.Name ,Track.Milliseconds 
 FROM Track
 ORDER BY Track.Milliseconds DESC;

/*8b. Which video track is the longest ?*/
SELECT   Track.Name ,Track.Milliseconds ,MediaType.Name
 FROM Track
 INNER JOIN MediaType ON MediaType.MediaTypeId=Track.MediaTypeId
 WHERE MediaType.Name LIKE'% video %'
 ORDER BY Track.Milliseconds DESC;

 /*9. Find the names of customers who live in the same city 
      as the top employee*/
SELECT C.FirstName  , C.Lastname
 FROM Customer C 
 WHERE C.City = (SELECT E.City
 FROM Employee E 
 WHERE ReportsTo IS NULL);

/*10. How many audio tracks in total were bought by German customers? 
     And what was the total price paid for them?*/
SELECT COUNT(IL.Quantity) AS Total_Tracks  ,
 SUM(I.Total) AS Total_price_paid
  FROM InvoiceLine IL 
 INNER JOIN Invoice I 
  ON IL.InvoiceId = I.InvoiceId 
 INNER JOIN Customer C 
  ON C.CustomerId = I.CustomerId 
  WHERE C.Country = 'Germany';

