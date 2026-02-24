-- DASC5306_Fall25_S001_T2 
--  1. INSERT new user, artist, and podcast (with themes)
INSERT INTO DASC5306_Fall25_S001_T2_UTA_Engage_User
VALUES ('NET26','jack','pwdJ51','CSE','88 Forest Ln','Apt 4','Tarrant','76109','USA',
DATE '2002-12-12',DATE '2021-08-20',3.50);

INSERT INTO DASC5306_Fall25_S001_T2_User_Email (netID, email)
VALUES ('NET26','jack@uta.edu');

INSERT INTO DASC5306_Fall25_S001_T2_User_Phone (netID, phone_number)
VALUES ('NET26','8175550051');

INSERT INTO DASC5306_Fall25_S001_T2_Artist (artistID, netID, number_of_followers, subcount)
VALUES (26,'NET26',50,80);

-- New podcast for this artist
INSERT INTO DASC5306_Fall25_S001_T2_Podcast
VALUES (126,26,'AI Talks',SYSDATE,'Ethics, safety and future of AI',400);

-- Themes for the new podcast
INSERT INTO DASC5306_Fall25_S001_T2_Podcast_Theme VALUES (126,'Educational');
INSERT INTO DASC5306_Fall25_S001_T2_Podcast_Theme VALUES (126,'Technology');

COMMIT;


--  2. UPDATE existing artist's stats (affects analytics queries)
UPDATE DASC5306_Fall25_S001_T2_Artist
SET number_of_followers = number_of_followers + 200,
    subcount = subcount + 300
WHERE artistID = 20;

-- Update a user's GPA
UPDATE DASC5306_Fall25_S001_T2_UTA_Engage_User
SET cumGPA = 3.95
WHERE netID = 'NET15';

COMMIT;


--  3. DELETE a podcast (and cascade remove its episodes and ads)
-- Use a valid existing podcastID (example: 5)
DELETE FROM DASC5306_Fall25_S001_T2_Podcast
WHERE podcastID = 5;

COMMIT;


--  4. UPDATE advertisements (financial adjustments)
UPDATE DASC5306_Fall25_S001_T2_Advertisement
SET rate_per_view = rate_per_view * 1.25,
    category = 'Premium Technology'
WHERE advertiserID IN (6,7,8);

COMMIT;


--  5. DELETE a patron (to test cascade/follow/subscription)
DELETE FROM DASC5306_Fall25_S001_T2_Patron
WHERE patron_id = 'PAT05';

COMMIT;


--  6. INSERT new episode for existing podcast (AI Talks)
-- Manually assign unique episodeID = 26
INSERT INTO DASC5306_Fall25_S001_T2_Episode
(episodeID, episodeNo, podcastID, title, source_URL, format_FIELD, upload_datetime, duration, views_count, likes_count, dislikes_count)
VALUES (26, 3, 126, 'Future Tech Trends', 'http://cdn.uta.edu/126/ep3.mp3', 'Audio',
CURRENT_TIMESTAMP, 30.0, 1500, 380, 8);

COMMIT;


--  7. ADD new themes to existing podcasts (valid podcastIDs only)
INSERT INTO DASC5306_Fall25_S001_T2_Podcast_Theme VALUES (1, 'Technology');
INSERT INTO DASC5306_Fall25_S001_T2_Podcast_Theme VALUES (10, 'Business');
INSERT INTO DASC5306_Fall25_S001_T2_Podcast_Theme VALUES (15, 'Entertainment');

COMMIT;


--  8. MODIFY advertisement display cost (affects revenue calculations)
UPDATE DASC5306_Fall25_S001_T2_Associated_with
SET display_cost = display_cost + 5.00
WHERE adID BETWEEN 10 AND 15;

COMMIT;


--  9. DELETE one artist (cascade deletes their podcasts & episodes)
DELETE FROM DASC5306_Fall25_S001_T2_Artist
WHERE artistID = 14;

COMMIT;


--  10. INSERT new advertiser and ad (Tesla)
-- Manually assign unique advertiserID = 26 and adID = 26
INSERT INTO DASC5306_Fall25_S001_T2_Advertiser (advertiserID, advertiser_name, headquarters_city, employees_count)
VALUES (26,'Tesla','Austin',7500);

INSERT INTO DASC5306_Fall25_S001_T2_Advertisement 
(adID, advertiserID, podcastID, product_type, hyperlink, rate_per_view, category, ad_duration)
VALUES (26,
        (SELECT advertiserID FROM DASC5306_Fall25_S001_T2_Advertiser WHERE advertiser_name='Tesla'),
        126, 'Electric Car', 'http://tesla.com', 1.50, 'Automobile', 45);

COMMIT;




