--A)query1. 
--B)For each day of the week, what is the average listening hours spent by a patron?
--This is helpful for the artists to understand the patron activity and decide when to upload
--a new episode
--C)
SET LINESIZE 250
SET PAGESIZE 25
COLUMN DAY_OF_WEEK FORMAT A15 HEADING 'Day of Week'
COLUMN AVG_LISTEN_HOURS FORMAT 999,999.99 HEADING 'Avg Listening Hours'

-- Query: Average listening hours per day of week
SELECT 
    TRIM(TO_CHAR(l.listen_date, 'DAY', 'NLS_DATE_LANGUAGE=ENGLISH')) AS DAY_OF_WEEK,
    ROUND(AVG(l.listen_duration) / 60, 2) AS AVG_LISTEN_HOURS
FROM DASC5306_Fall25_S001_T2_Listening l
GROUP BY TRIM(TO_CHAR(l.listen_date, 'DAY', 'NLS_DATE_LANGUAGE=ENGLISH')),
         TO_CHAR(l.listen_date, 'D', 'NLS_DATE_LANGUAGE=ENGLISH')
ORDER BY TO_CHAR(l.listen_date, 'D', 'NLS_DATE_LANGUAGE=ENGLISH');

--D)output

Day of Week     Avg Listening Hours
--------------- -------------------
FRIDAY                          .56



--A)Query2. 
--B)List the top 10 artists who on an average have received the most number of likes across
--all their podcast episodes uploaded in 2024.
--Such a report helps the patrons to identify trending artists. Also, the ad display cost and
--rate per view can be adjusted for the episodes uploaded by such top artists
--C)
SET LINESIZE 250
SET PAGESIZE 25
COLUMN ARTIST_ID FORMAT 999 HEADING 'Artist ID'
COLUMN ARTIST_NAME FORMAT A25 HEADING 'Artist Username'
COLUMN AVG_LIKES FORMAT 999,999.99 HEADING 'Avg Likes (2024)'

SELECT 
    a.artistID AS ARTIST_ID,
    u.username AS ARTIST_NAME,
    ROUND(AVG(e.likes_count), 2) AS AVG_LIKES
FROM DASC5306_Fall25_S001_T2_Artist a
JOIN DASC5306_Fall25_S001_T2_Podcast p
    ON a.artistID = p.artistID
JOIN DASC5306_Fall25_S001_T2_Episode e
    ON p.podcastID = e.podcastID
JOIN DASC5306_Fall25_S001_T2_UTA_Engage_User u
    ON a.netID = u.netID
WHERE EXTRACT(YEAR FROM e.upload_datetime) = 2024
GROUP BY a.artistID, u.username
ORDER BY AVG_LIKES DESC
FETCH FIRST 10 ROWS ONLY;
--D)output
no rows selected




--A)Query3. 
--B)For each nationality and year of birth, list the most popular theme along with its average
--episode duration. The popularity of a theme is quantified based on the total number of
--views the related podcast receives.
--This report is helpful to gauge the listening pattern among different age groups belonging
--to diverse backgrounds. Based on such analysis, new patrons can be shown relevant
--content to keep them engaged and hooked to the platform.
--C)
SET LINESIZE 250
SET PAGESIZE 30
COLUMN NATIONALITY FORMAT A20 HEADING 'Nationality'
COLUMN BIRTH_YEAR FORMAT 9999 HEADING 'Birth Year'
COLUMN THEME FORMAT A25 HEADING 'Most Popular Theme'
COLUMN AVG_DURATION FORMAT 999,999.99 HEADING 'Avg Episode Duration (min)'
COLUMN TOTAL_VIEWS FORMAT 999,999 HEADING 'Total Views'

WITH ThemePopularity AS (
    SELECT 
        u.nationality,
        EXTRACT(YEAR FROM u.dob) AS birth_year,
        pt.theme,
        SUM(e.views_count) AS total_views,
        AVG(e.duration) AS avg_duration
    FROM DASC5306_Fall25_S001_T2_UTA_Engage_User u
    JOIN DASC5306_Fall25_S001_T2_Patron p ON u.netID = p.netID
    JOIN DASC5306_Fall25_S001_T2_Listening l ON p.patron_id = l.patron_id
    JOIN DASC5306_Fall25_S001_T2_Episode e ON l.episodeID = e.episodeID
    JOIN DASC5306_Fall25_S001_T2_Podcast pod ON e.podcastID = pod.podcastID
    JOIN DASC5306_Fall25_S001_T2_Podcast_Theme pt ON pod.podcastID = pt.podcastID
    GROUP BY u.nationality, EXTRACT(YEAR FROM u.dob), pt.theme
)
SELECT tp.nationality, tp.birth_year, tp.theme AS THEME,
       ROUND(tp.avg_duration, 2) AS AVG_DURATION,
       tp.total_views
FROM ThemePopularity tp
WHERE (tp.nationality, tp.birth_year, tp.total_views) IN (
    SELECT nationality, birth_year, MAX(total_views)
    FROM ThemePopularity
    GROUP BY nationality, birth_year
)
ORDER BY tp.nationality, tp.birth_year;
--D)output

Nationality          Birth Year Most Popular Theme        Avg Episode Duration (min) Total Views
-------------------- ---------- ------------------------- -------------------------- -----------
USA                        2000 Business                                       40.83       9,250




--Query4. 
--B)List the name, theme, number of episodes, and the average number of views per episode
--for the podcasts that have only been listened to by the students from the ‘CSE’
--department enrolled after July 2023. Order the list in the decreasing order of the average
--number of views per episode.
--Such listicles help to identify trending podcasts among a certain group of people.
--C)
SET LINESIZE 250
SET PAGESIZE 30
COLUMN PODCAST_NAME FORMAT A30 HEADING 'Podcast Name'
COLUMN THEME FORMAT A20 HEADING 'Theme'
COLUMN EPISODE_COUNT FORMAT 999 HEADING 'Episode Count'
COLUMN AVG_VIEWS FORMAT 999,999.99 HEADING 'Avg Views per Episode'

SELECT 
    p.name AS PODCAST_NAME,
    pt.theme AS THEME,
    COUNT(DISTINCT e.episodeID) AS EPISODE_COUNT,
    ROUND(AVG(e.views_count), 2) AS AVG_VIEWS
FROM DASC5306_Fall25_S001_T2_Podcast p
JOIN DASC5306_Fall25_S001_T2_Podcast_Theme pt ON p.podcastID = pt.podcastID
JOIN DASC5306_Fall25_S001_T2_Episode e ON p.podcastID = e.podcastID
JOIN DASC5306_Fall25_S001_T2_Listening l ON e.episodeID = l.episodeID
JOIN DASC5306_Fall25_S001_T2_Patron pat ON l.patron_id = pat.patron_id
JOIN DASC5306_Fall25_S001_T2_UTA_Engage_User u ON pat.netID = u.netID
WHERE u.enrolled_department = 'CSE'
  AND u.doe > DATE '2023-07-01'
  AND NOT EXISTS (
      SELECT 1
      FROM DASC5306_Fall25_S001_T2_Listening l2
      JOIN DASC5306_Fall25_S001_T2_Patron p2 ON l2.patron_id = p2.patron_id
      JOIN DASC5306_Fall25_S001_T2_UTA_Engage_User u2 ON p2.netID = u2.netID
      WHERE l2.episodeID = e.episodeID
        AND u2.enrolled_department <> 'CSE'
  )
GROUP BY p.name, pt.theme
ORDER BY AVG_VIEWS DESC;

--D) output
Podcast Name                   Theme                Episode Count Avg Views per Episode
------------------------------ -------------------- ------------- ---------------------
Podcast_25                     Technology                       1              2,250.00
Podcast_20                     Technology                       1              2,000.00
Podcast_15                     Technology                       1              1,750.00
Podcast_15                     Entertainment                    1              1,750.00
Podcast_10                     Business                         1              1,500.00
Podcast_10                     Technology                       1              1,500.00

6 rows selected.




--A)Query5. 
--B)Who are the student subscribers who have listened to every video episode of the
--technology or educational themed podcasts that have the phrase ‘large language model’
--appear somewhere in the description? Find their name, GPA, and email ID.
--Such a report identifies the enthusiasts who are listening to a specific type of content. This
--set of people can act as a group who have acquired enough relevant knowledge on a
--certain topic and thus can become a part of related research, survey and promotional
--teams, or can be contacted for creating related podcasts
--C)
SET LINESIZE 250
SET PAGESIZE 30
COLUMN STUDENT_NAME FORMAT A25 HEADING 'Student Name'
COLUMN GPA FORMAT 9.99 HEADING 'Cumulative GPA'
COLUMN EMAIL FORMAT A35 HEADING 'Email Address'

WITH TargetEpisodes AS (
    SELECT DISTINCT e.episodeID
    FROM DASC5306_Fall25_S001_T2_Episode e
    JOIN DASC5306_Fall25_S001_T2_Podcast p ON e.podcastID = p.podcastID
    JOIN DASC5306_Fall25_S001_T2_Podcast_Theme pt ON p.podcastID = pt.podcastID
    WHERE LOWER(p.description) LIKE '%large language model%'
      AND pt.theme IN ('Technology', 'Educational')
      AND e.format_FIELD = 'Video'
),
ListenerCount AS (
    SELECT l.patron_id, COUNT(DISTINCT l.episodeID) AS listened_count
    FROM DASC5306_Fall25_S001_T2_Listening l
    WHERE l.episodeID IN (SELECT episodeID FROM TargetEpisodes)
    GROUP BY l.patron_id
),
TotalTarget AS (
    SELECT COUNT(DISTINCT episodeID) AS total_needed FROM TargetEpisodes
)
SELECT u.username AS STUDENT_NAME, u.cumGPA AS GPA, ue.email AS EMAIL
FROM ListenerCount lc
JOIN TotalTarget tt ON lc.listened_count = tt.total_needed
JOIN DASC5306_Fall25_S001_T2_Patron p ON lc.patron_id = p.patron_id
JOIN DASC5306_Fall25_S001_T2_UTA_Engage_User u ON p.netID = u.netID
JOIN DASC5306_Fall25_S001_T2_User_Email ue ON u.netID = ue.netID
ORDER BY u.username;
--D)output
no rows selected



--A)Query6.	
--B)For each advertiser, calculate the total revenue generated from their ads across all podcast episodes in 2024, broken down by podcast theme. 
-- This helps advertisers understand which podcast themes (e.g., health, technology, storytelling) are most profitable for them and where they should focus future campaigns. 
C)

SET LINESIZE 250
SET PAGESIZE 25
COLUMN ADVERTISER_ID FORMAT 999 HEADING 'Advertiser ID'
COLUMN ADVERTISER_NAME FORMAT A25 HEADING 'Advertiser Name'
COLUMN PODCAST_THEME FORMAT A25 HEADING 'Podcast Theme'
COLUMN TOTAL_REVENUE FORMAT 999,999,999.99 HEADING 'Total Revenue ($)'

SELECT 
    adv.advertiserID AS ADVERTISER_ID,
    adv.advertiser_name AS ADVERTISER_NAME,
    pt.theme AS PODCAST_THEME,
    ROUND(SUM(aw.display_cost), 2) AS TOTAL_REVENUE
FROM DASC5306_Fall25_S001_T2_Advertiser adv
JOIN DASC5306_Fall25_S001_T2_Advertisement ad ON adv.advertiserID = ad.advertiserID
JOIN DASC5306_Fall25_S001_T2_Podcast p ON ad.podcastID = p.podcastID
JOIN DASC5306_Fall25_S001_T2_Podcast_Theme pt ON p.podcastID = pt.podcastID
JOIN DASC5306_Fall25_S001_T2_Associated_with aw ON ad.adID = aw.adID
JOIN DASC5306_Fall25_S001_T2_Episode e ON aw.episodeID = e.episodeID
WHERE EXTRACT(YEAR FROM e.upload_datetime) = 2024
GROUP BY adv.advertiserID, adv.advertiser_name, pt.theme
ORDER BY adv.advertiserID, TOTAL_REVENUE DESC;
--D) output

no rows selected


--Query7.	
--Identify the top 5 advertisements and list the patron demographics  that engaged with them the most. 
SET LINESIZE 250
SET PAGESIZE 30
COLUMN AD_ID FORMAT 999 HEADING 'Ad ID'
COLUMN ADVERTISER_NAME FORMAT A25 HEADING 'Advertiser Name'
COLUMN NATIONALITY FORMAT A20 HEADING 'Nationality'
COLUMN COUNTY FORMAT A20 HEADING 'County'
COLUMN ZIPCODE FORMAT A10 HEADING 'Zipcode'
COLUMN PATRON_COUNT FORMAT 9999 HEADING 'Patron Count'
COLUMN TOTAL_LISTENS FORMAT 999,999 HEADING 'Total Listens'

--A)Query 7: 
--B)Top 5 ads and patron demographics with highest engagement
--C)
WITH Ad_Engagement AS (
    SELECT 
        aw.adID,
        SUM(l.listen_count) AS total_engagement
    FROM DASC5306_Fall25_S001_T2_Associated_with aw
    JOIN DASC5306_Fall25_S001_T2_Episode e
        ON aw.episodeID = e.episodeID
    JOIN DASC5306_Fall25_S001_T2_Listening l
        ON e.episodeID = l.episodeID
    GROUP BY aw.adID
),
Top5Ads AS (
    SELECT adID
    FROM Ad_Engagement
    ORDER BY total_engagement DESC
    FETCH FIRST 5 ROWS ONLY
)
SELECT 
    a.adID AS AD_ID,
    adv.advertiser_name AS ADVERTISER_NAME,
    u.nationality AS NATIONALITY,
    u.county AS COUNTY,
    u.zipcode AS ZIPCODE,
    COUNT(DISTINCT l.patron_id) AS PATRON_COUNT,
    SUM(l.listen_count) AS TOTAL_LISTENS
FROM Top5Ads t
JOIN DASC5306_Fall25_S001_T2_Associated_with aw
    ON t.adID = aw.adID
JOIN DASC5306_Fall25_S001_T2_Episode e
    ON aw.episodeID = e.episodeID
JOIN DASC5306_Fall25_S001_T2_Listening l
    ON e.episodeID = l.episodeID
JOIN DASC5306_Fall25_S001_T2_Patron p
    ON l.patron_id = p.patron_id
JOIN DASC5306_Fall25_S001_T2_UTA_Engage_User u
    ON p.netID = u.netID
JOIN DASC5306_Fall25_S001_T2_Advertisement a
    ON t.adID = a.adID
JOIN DASC5306_Fall25_S001_T2_Advertiser adv
    ON a.advertiserID = adv.advertiserID
GROUP BY a.adID, adv.advertiser_name, u.nationality, u.county, u.zipcode
ORDER BY a.adID, TOTAL_LISTENS DESC;
--D) output

Ad ID Advertiser Name           Nationality          County               Zipcode    Patron Count Total Listens
----- ------------------------- -------------------- -------------------- ---------- ------------ -------------
    2 Advertiser_2              USA                  Tarrant              76002                 1             3
    8 Advertiser_8              USA                  Tarrant              76008                 1             3
   11 Advertiser_11             USA                  Tarrant              76011                 1             3
   17 Advertiser_17             USA                  Tarrant              76017                 1             3
   23 Advertiser_23             USA                  Tarrant              76023                 1             3