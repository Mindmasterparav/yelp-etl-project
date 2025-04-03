-- 1:  No of businesses in each category

WITH CATEGORY_COUNT AS(
SELECT TRIM(A.value) AS category,BUSINESS_ID
FROM tbl_yelp_business
CROSS JOIN LATERAL SPLIT_TO_TABLE(categories,',') AS A)

SELECT category,COUNT(BUSINESS_ID)  AS NO_OF_BUSINESSES
FROM CATEGORY_COUNT
GROUP BY category
ORDER BY NO_OF_BUSINESSES DESC;


--2:   FIND TOP 10 USERS WHO HAVE REVIEWED MOST BUSINESSES IN RESTRAUNT CATEGORY
WITH CATEGORIES AS (
    SELECT DISTINCT(b.business_id),A.value AS category, r.user_id
    FROM tbl_yelp_business AS b
    INNER JOIN tbl_yelp_reviews AS r
    ON b.business_id = r.business_id
    CROSS JOIN LATERAL SPLIT_TO_TABLE(b.categories, ',') AS A
)
SELECT user_id, COUNT(user_id) AS review_count
FROM CATEGORIES
WHERE category ILIKE '%Restaurant%'  -- Correct spelling if necessary
GROUP BY user_id
ORDER BY review_count DESC
LIMIT 10

SELECT * FROM tbl_yelp_business LIMIT 10
SELECT * FROM TBL_YELP_REVIEWS LIMIT 10


--3: FIND MOST POPULAR CATEGORIES OF BUSINESS BASED ON NO OF REVIEWS

WITH business_category AS(
  SELECT business_id, TRIM(a.value) AS Category, review_count
  FROM tbl_yelp_business
  CROSS JOIN LATERAL SPLIT_TO_TABLE(categories,',') AS a
)

SELECT Category, COUNT(review_count) AS Total_Reviews
FROM business_category  AS b
INNER JOIN tbl_yelp_reviews AS r
ON b.business_id=r.business_id
GROUP BY Category
ORDER BY Total_Reviews DESC;

--4: FIND TOP 3 MOST RECENT REVIEWS FOR EACH BUSINESS

WITH cte as(
    SELECT r.*,b.name AS name,ROW_NUMBER() OVER(PARTITION BY r.business_id ORDER BY r.REVIEW_DATE DESC) AS review_number
    FROM tbl_yelp_business AS b
    INNER JOIN tbl_yelp_reviews AS r
    ON b.business_id=r.business_id
)
SELECT name,review_number,review_date
FROM cte
WHERE review_number<=3

--5: FIND MONTH WITH HIGHEST NO OF REVIEWS

SELECT MONTH(review_Date) as month,COUNT(*) as count
FROM tbl_yelp_reviews
GROUP BY month
ORDER BY count desc
LIMIT 1

-- 6: FIND PERCENTGE OF 5 STAR REVIEWS FOR EACH BUSINESS
WITH stars AS (
    SELECT b.name,r.business_id, COUNT(*) AS TOTAL,COUNT(CASE WHEN REVIEW_STARS=5 THEN 1 ELSE NULL END)AS 
    five_STARS
    FROM TBL_YELP_REVIEWS AS r
    INNER JOIN TBL_YELP_BUSINESS AS b
    ON r.business_id=b.business_id
    GROUP BY b.name,r.business_id
    HAVING TOTAL>0
)

SELECT name,TOTAL,five_STARS,round(five_stars*100/TOTAL,2) AS five_star_percentage
FROM stars


--7:  FIND TOP 5 MOST REVIEWED BUSINESSES IN EACH CITY

with reviewed_city as(
SELECT b.CITY,r.BUSINESS_ID,b.name,COUNT(*) as count
,row_number() OVER(PARTITION BY b.CITY ORDER BY count DESC) AS review_count
FROM tbl_yelp_business as b
INNER JOIN tbl_yelp_reviews as r
on b.business_id=r.business_id
GROUP BY b.city,r.business_id,b.name
)

SELECT city,name,count
FROM reviewed_city
WHERE review_count<=5

--8:  FInd THE AVERAGE RATING OF BUSINESSES THAT HAVE ATLEAST 100  REVIEWS
with cte as(
SELECT r.business_id,b.review_count as business_review_count,b.name AS business_name,r.review_stars as rating
FROM tbl_yelp_reviews as r
INNER JOIN tbl_yelp_business as b
ON r.business_id=b.business_id
WHERE b.review_count>=100
)

SELECT business_name,ROUND(AVG(rating),2) as avg_rating
FROM cte
GROUP BY business_name


--9:   LIST THE TOP 10 USERS WHO HAVE WRITTEN MOST REVIEWS, ALONG WITH BUSINESSES THEY REVIEWED
with cte AS (
SELECT r.USER_ID,r.BUSINESS_ID,b.NAME as business_name
FROM tbl_yelp_reviews as r
INNER JOIN tbl_yelp_business as b
ON r.business_id=b.business_id
)

SELECT USER_ID,count(*) as review_count
FROM cte
GROUP BY USER_ID
ORDER BY review_count DESC
LIMIT 10


--10:   FIND TOP 10 BUSINESSES WITH HIGHEST POSITIVE SENTIMENT REVIEWS

with cte AS (
SELECT r.BUSINESS_ID,b.NAME as business_name,r.sentiments AS sentiment
FROM tbl_yelp_reviews as r
INNER JOIN tbl_yelp_business as b
ON r.business_id=b.business_id 
)
SELECT business_name,count(*) as TOTAL_POSITIVE
FROM cte
WHERE sentiment='Positive'
GROUP BY business_name,business_id
ORDER BY TOTAL_POSITIVE DESC
LIMIT 10

