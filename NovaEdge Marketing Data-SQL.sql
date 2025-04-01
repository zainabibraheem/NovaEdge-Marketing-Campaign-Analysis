SELECT * FROM  Marketing_Data;

-- I WANT TO CHECK FOR DUPLICATE --
SELECT *, COUNT(*) FROM Marketing_Data
GROUP BY Campaign,Date,City_Location,Channel,Device,Ad,Impressions,CTR,Clicks,Daily_Average_CPC,Spend_GBP,Conversions,Total_conversion_value_GBP,Likes_Reactions,Shares,Comments,Latitude,Longitude
HAVING COUNT(*) > 1
-- No Duplicate Detected--

-- CHANGING IMPRESSION FROM FLOAT TO INTEGER--
ALTER TABLE Marketing_Data
ALTER COLUMN Impressions INT;
-- SUCCESSFULLY CHANGE DATATYPE FROM FLOAT TO INTEGER--

--CONVERTING DAILY_AVERAGE_CPC and TOTAL_CONVERSION_VALUE_GBP--
UPDATE Marketing_Data
SET Daily_Average_CPC = ROUND (Daily_Average_CPC, 3);

UPDATE Marketing_Data
SET Total_conversion_value_GBP = ROUND (Total_conversion_value_GBP, 4);

--	Which campaign generated the highest number of impressions, clicks, and conversions--
SELECT Campaign, 
SUM(Impressions) as Impressions,
SUM(Clicks) as Clicks,
SUM(Conversions) as Conversions
FROM Marketing_Data
GROUP BY Campaign
ORDER BY Impressions DESC

--	What is the average cost-per-click (CPC)  and click-through rate (CTR) for each campaign?--
SELECT Campaign,
AVG(Daily_Average_CPC) as AVG_CPC
FROM Marketing_Data
GROUP BY Campaign

-- Converting click-through rate (CTR) from % to decimal
UPDATE Marketing_Data
SET CTR = REPLACE(CTR, '%', ' ');

UPDATE Marketing_Data
SET CTR = CAST(CTR as Decimal(16,2)) / 100;

ALTER TABLE Marketing_Data
ALTER COLUMN CTR DECIMAL(16, 4);

-- Calculate average CPC
ALTER TABLE Marketing_Data
ALTER COLUMN Clicks TINYINT

ALTER TABLE Marketing_Data
ALTER COLUMN Spend_GBP MONEY

SELECT Campaign, COALESCE(SUM(Spend_GBP), 0) / NULLIF(COALESCE(SUM(clicks),0), 0) as CPC 
FROM Marketing_Data
GROUP BY Campaign

SELECT Campaign,Spend_GBP,clicks, NULLIF(Spend_GBP, 0) / NULLIF(clicks, 0) as CPC 
FROM Marketing_Data
GROUP BY Campaign,Spend_GBP,clicks



SELECT Campaign, NULLIF(SUM(Spend_GBP), 0) / NULLIF(SUM(clicks), 0) as CPC 
FROM Marketing_Data
GROUP BY Campaign

SELECT Campaign, SUM(Spend_GBP) / SUM(clicks) as CPC, AVG(CTR) AS AVERAGE_CTR
FROM Marketing_Data
GROUP BY Campaign

--question 2-- 
-- which channel has the highest ROI--

SELECT * FROM  Marketing_Data;

SELECT Campaign, (SUM(Total_conversion_value_GBP) - SUM(Spend_GBP)) / SUM(Spend_GBP) as ROI
FROM Marketing_Data
GROUP BY Campaign

--How impressions, clicks, and conversions vary across different  channels?--
SELECT Channel, SUM(Impressions) as Impressions, SUM(Clicks) as Clicks, SUM(Conversions) as Conversions
FROM Marketing_Data
GROUP BY Channel

--Geographical Insights--
ALTER TABLE Marketing_Data
ALTER COLUMN Conversions INT

ALTER TABLE Marketing_Data
ALTER COLUMN Clicks INT


--Which cities have the highest engagement rates (likes, shares, comments)?--
SELECT City_Location,SUM(Likes_Reactions) AS Likes,SUM(Shares) AS Shares,SUM(Comments) AS Comments, 
(SUM(Likes_Reactions) + SUM(Shares) + SUM(Comments)) AS Engagement
FROM [Marketing_Data ]
GROUP BY City_Location 
ORDER BY Likes DESC



--What is the conversion rate by city?--
SELECT City_Location, CAST(SUM(Conversions) AS decimal(10,3)) /SUM(CLICKS) * 100 AS Conversion_Rate
FROM [Marketing_Data ]
GROUP BY City_Location

--Device Performance:--
--How do ad performances compare across different devices (mobile, desktop, tablet)?--
SELECT Device,Ad, SUM(Likes_Reactions) AS Likes,SUM(Shares) AS Shares,SUM(Comments) AS Comments
FROM [Marketing_Data ]
GROUP BY Device,Ad
ORDER BY Likes DESC


--Which device type generates the highest conversion rates?--
SELECT Device, CAST(SUM(Conversions) AS decimal(10,3)) /SUM(CLICKS) * 100 AS Conversion_Rate
FROM [Marketing_Data ]
GROUP BY Device


--Ad-Level Analysis:--
--Which specific ads are performing best in terms of engagement and conversions?--
SELECT Ad, SUM(Likes_Reactions) AS Likes,SUM(Shares) AS Shares,SUM(Comments) AS Comments, 
(SUM(Shares) + SUM(Comments) + SUM(Likes_Reactions)) AS Engagements,
SUM(Conversions) AS Conversions
FROM [Marketing_Data ]
GROUP BY Ad
ORDER BY Likes DESC

SELECT Campaign, Channel, Ad, SUM(Likes_Reactions) AS Likes,SUM(Shares) AS Shares,SUM(Comments) AS Comments, SUM(Conversions) AS Conversions
FROM [Marketing_Data ]
GROUP BY Campaign, Channel, Ad
ORDER BY Likes DESC

SELECT Channel, Ad, SUM(Likes_Reactions) AS Likes,SUM(Shares) AS Shares,SUM(Comments) AS Comments, SUM(Conversions) AS Conversions
FROM [Marketing_Data ]
GROUP BY Channel, Ad
ORDER BY Likes DESC


--What are the common characteristics of high-performing ads?--
SELECT Ad, SUM(Likes_Reactions) AS Likes,SUM(Shares) AS Shares,SUM(Comments) AS Comments, SUM(Conversions) AS Conversions
FROM [Marketing_Data ]
GROUP BY Ad
HAVING Ad = 'Discount'
ORDER BY Likes DESC

SELECT Ad, Likes_Reactions AS Likes, Shares AS Shares, Comments AS Comments, Conversions AS Conversions
FROM [Marketing_Data ]
ORDER BY Likes DESC

--ROI Calculation:--
--What is the ROI for each campaign, and how does it compare across different channels and devices?--

SELECT Campaign, Channel, Device, (SUM(Total_conversion_value_GBP) - SUM(Spend_GBP)) / SUM(Spend_GBP) as ROI
FROM Marketing_Data
GROUP BY Campaign,Channel,Device
ORDER BY ROI DESC


--How does spend correlate with conversion value across different campaigns?--
SELECT Campaign, SUM(Spend_GBP) AS Spend_GBP, SUM(Total_conversion_value_GBP) AS Total_conversion_value_GBP, SUM(Total_conversion_value_GBP)/SUM(Spend_GBP) AS Spend_per_Convertion
FROM [Marketing_Data ]
GROUP BY Campaign
ORDER BY Spend_per_Convertion

--Time Series Analysis:--
--Are there any noticeable trends or seasonal effects in ad performance over time?--

SELECT DATENAME(MONTH, DATE) AS MONTH, SUM(Spend_GBP) AS Spend_GBP, SUM(Total_conversion_value_GBP) AS Total_conversion_value_GBP, SUM(Conversions) AS CONVERSIONS
FROM [Marketing_Data ]
GROUP BY DATENAME(MONTH, DATE)
ORDER BY MONTH

SELECT DATEPART(MONTH, DATE) AS MONTH, DATENAME(MONTH, DATE) AS MONTH_NAME, SUM(Spend_GBP) AS Spend_GBP, SUM(Total_conversion_value_GBP) AS Total_conversion_value_GBP, SUM(Conversions) AS CONVERSIONS
FROM [Marketing_Data ]
GROUP BY DATEPART(MONTH, DATE), DATENAME(MONTH, DATE) 
ORDER BY MONTH



