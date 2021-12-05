/*11. Which playlists have no Latin tracks?*/
SELECT Playlist.Name AS Playlist
 FROM Playlist
 LEFT JOIN PlaylistTrack  ON 
 PlaylistTrack.PlaylistId = Playlist.PlaylistId
 INNER JOIN Track ON 
 PlaylistTrack.TrackId= Track.TrackId
 INNER JOIN Genre ON 
 Genre.GenreId=Track.GenreId
 WHERE NOT Genre.Name LIKE'%Latin%' 
 GROUP BY Playlist.Name;

/*12. What is the space, in bytes, occupied by the playlist “Grunge*/
SELECT  Playlist.Name,SUM(Track.Bytes) AS space_occupied
 FROM Playlist
 INNER JOIN PlaylistTrack ON Playlist.PlaylistId=PlaylistTrack.PlaylistId
 INNER JOIN Track ON PlaylistTrack.TrackId=Track.TrackId
 WHERE Playlist.Name ='Grunge'
 GROUP BY  Playlist.Name;

/*13. Which playlists do not contain any tracks for the artists 
     “Black Sabbath” nor “Chico Buarque”?*/
SELECT DISTINCT P.Name 
FROM Playlist P
 INNER JOIN PlaylistTrack PT ON P.PlaylistId=PT.PlaylistId
 INNER JOIN Track T ON T.TrackId=PT.TrackId
 INNER JOIN Album Al ON Al.AlbumId=T.AlbumId
 INNER JOIN Artist Ar ON Ar.ArtistId= Al.ArtistId 
 WHERE NOT Ar.Name =' Black Sabbath' AND NOT  Ar.Name ='Chico Buarque';

 /*14. Which playlist(s) contain the largest number of pop tracks.*/
SELECT  P.Name AS Playlists, G.Name AS Geners, COUNT (T.TrackId) AS Tracks
FROM Playlist P
 INNER JOIN PlaylistTrack PT ON PT.PlaylistId=P.PlaylistId
 INNER JOIN Track T ON T.TrackId=PT.TrackId
 INNER JOIN Genre G ON G.GenreId=T.GenreId
 WHERE G.Name LIKE '%Pop%'
 GROUP BY P.Name,G.Name
 ORDER BY COUNT (T.TrackId) DESC;


/*15. Which artist(s) has the most tracks classified as Jazz.*/
SELECT  Ar.Name,COUNT(T.TrackId) AS Tracks 
FROM Track T
INNER JOIN Genre G  ON T.GenreId =G.GenreId 
LEFT JOIN Album Al ON T.AlbumId=Al.AlbumId
INNER JOIN Artist Ar  ON Al.ArtistId=Ar.ArtistId
WHERE G.Name LIKE '%Jazz%'
GROUP BY Ar.Name
ORDER BY  COUNT(T.TrackId) DESC


/*16. List the name and age of the employees who support more than 5 customers */
SELECT DISTINCT E.FirstName,E.LastName,E.BirthDate,
 Datediff(yy,BirthDate,GETDATE()) AS AGE
 FROM Employee E
 JOIN Customer C On C.SupportRepId=E.EmployeeId
 GROUP BY C.SupportRepId,E.FirstName,E.LastName,E.BirthDate,
 Datediff(yy,BirthDate,GETDATE()) 
 HAVING COUNT(C.SupportRepId)>=5;


/*17. List the name of the artists with more than 5 tracks */
SELECT Ar.Name AS Artists, COUNT (T.Trackid) AS Tracks
 FROM Artist Ar
 JOIN Album Al ON Al.ArtistId=Ar.ArtistId
 JOIN Track T ON T.AlbumId=Al.AlbumId
 Group BY Ar.Name
 HAVING COUNT(T.TrackId)>=5
 ORDER BY COUNT(T.TrackID) DESC;


/*18. Find audio tracks which have a length longer than
      the average length of all the audio tracks*/
SELECT  T.Name AS Tracks , T.Milliseconds AS Length
 FROM Track T
 INNER JOIN MediaType MT ON MT.MediaTypeId=T.MediaTypeId
 WHERE MT.Name LIKE'% audio %' AND Milliseconds > 
           (SELECT AVG(Milliseconds) FROM Track)
 ORDER BY T.Milliseconds DESC;

/*19.Find the name of the German customer(s) who has paid the most in 
     total and is not associated with a company.*/
SELECT DISTINCT C.FirstName,C.LastName,C.Country,I.Total,C.Company
 FROM Customer C
 INNER JOIN Invoice I ON C.CustomerId=I.CustomerId
 INNER JOIN InvoiceLine IL ON I.InvoiceId=IL.InvoiceId
 WHERE C.Country ='Germany' AND C.Company IS NULL AND I.Total=
 (SELECT TOP 1 MAX(Total)
 FROM Customer C
 INNER JOIN Invoice I ON C.CustomerId=I.CustomerId
 INNER JOIN InvoiceLine IL ON I.InvoiceId=IL.InvoiceId
 WHERE C.Country ='Germany' 
 Group BY Total
 ORDER BY Total DESC);

/*20. Find the playlist(s) which contains most tracks by artist 'AC/DC' */
SELECT TOP 1 P.Name AS Playlists, T.Name,Ar.Name AS Artist
 FROM Playlist P
 INNER JOIN PlaylistTrack PT
 ON P.PlaylistId = PT.PlaylistId
 INNER JOIN Track T
 ON PT.TrackId = T.TrackId
 INNER JOIN Album Al
 ON T.AlbumId = Al.AlbumId
 INNER JOIN Artist Ar 
 ON Ar.ArtistId=Al.ArtistId
 WHERE Ar.Name LIKE '%AC/DC%'
 GROUP BY P.PlayListId, P.Name, Ar.Name,T.Name
 ORDER BY COUNT(*) DESC;


/*21. List the genre of tracks which is contained in the most playlist */
SELECT Genre.Name AS Geners ,COUNT (*) AS counts
FROM Genre
INNER JOIN Track T ON T.GenreId=Genre.GenreId
INNER JOIN PlaylistTrack PT ON PT.TrackId=T.TrackId
GROUP BY Genre.Name
ORDER BY counts DESC;


/*22.Find the artist name who is the most profitable commercially ? 
     (his/her tracks have been sold the most)*/
SELECT    A.Name ,MAX(IL.Quantity*Il.UnitPrice)
 FROM Artist A 
 INNER JOIN Album AB ON A.ArtistId = AB.ArtistId
 INNER JOIN Track T ON T.AlbumId = AB.AlbumId
 INNER JOIN InvoiceLine IL ON IL.TrackId = T.TrackId
 GROUP BY A.Name
 ORDER BY MAX(IL.Quantity*Il.UnitPrice) DESC
