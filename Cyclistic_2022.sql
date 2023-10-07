Create TABLE Cyclistic_2022
(
    ride_id VARCHAR(255),
    rideable_type VARCHAR(255),
    started_at VARCHAR(255),
    ended_at VARCHAR(255),
	ride_length DateTime,
	day_of_week VARCHAR(255),
    start_station_name VARCHAR(255),
    start_station_id VARCHAR(255),
    end_station_name VARCHAR(255),
    end_station_id VARCHAR(255),
    start_lat NUMERIC,
    start_lng NUMERIC,
    end_lat NUMERIC,
    end_lng NUMERIC,
    member_casual VARCHAR(255)
);


INSERT INTO CYCLISTIC_2022 (ride_id, rideable_type, started_at, ended_at, ride_length, day_of_week,
start_station_name, start_station_id, end_station_name, end_station_id, start_lat, start_lng, 
end_lat, end_lng, member_casual)
SELECT *
FROM PortfolioProject.dbo.Jan$
UNION ALL
SELECT *
FROM PortfolioProject.dbo.Feb$
UNION ALL
SELECT *
FROM PortfolioProject.dbo.Mar$
UNION ALL
SELECT *
FROM PortfolioProject.dbo.Apr$
UNION ALL
SELECT *
FROM PortfolioProject.dbo.May$
UNION ALL
SELECT *
FROM PortfolioProject.dbo.Jun$
UNION ALL
SELECT *
FROM PortfolioProject.dbo.July$
UNION ALL
SELECT *
FROM PortfolioProject.dbo.Aug$
UNION ALL
SELECT *
FROM PortfolioProject.dbo.Sep$
UNION ALL
SELECT *
FROM PortfolioProject.dbo.Oct$
UNION ALL
SELECT *
FROM PortfolioProject.dbo.Nov$
UNION ALL
SELECT *
FROM PortfolioProject.dbo.Dec$;



------------Updated ride length format------------

-----#This was to check the ride length times matched spreadsheet data------------

SELECT CONVERT(VARCHAR(8), ride_length, 108) AS formatted_ride_length
FROM cyclistic.dbo.Cyclistic_2022


SELECT ride_id, rideable_type, started_at, ended_at, day_of_week, member_casual, 
CONVERT(VARCHAR(8), ride_length, 108) AS formatted_ride_length
FROM cyclistic.dbo.Cyclistic_2022
ORDER BY formatted_ride_length



-----------Calculated difference between start_time and end_time----------

SELECT DATEDIFF (MINUTE, started_at, ended_at) AS diff,
ride_id
FROM PortfolioProject.dbo.Dec$
ORDER BY diff


SELECT ride_id, started_at, ended_at, ride_length, member_casual,
DATEDIFF (MINUTE, started_at, ended_at)/60.00 AS time_duration
FROM cyclistic.dbo.Cyclistic_2022
WHERE ride_length > '00:00:59' and started_at < ended_at
ORDER BY time_duration



----------#Finding max values------------------------------------------

SELECT
    DATEPART(MONTH, started_at) AS month,
	  member_casual,
    MAX(time_duration) AS max_value
FROM cyclistic.dbo.Cyclistic_2022
GROUP BY DATEPART(YEAR, started_at), DATEPART(MONTH, started_at), member_casual
ORDER BY month



-----------#Finding mode values----------------------

WITH ModeCTE AS(
	SELECT
		day_of_week AS Mode,
		COUNT(*) AS frequency,
		DATEPART(MONTH, started_at) AS month, member_casual
	FROM cyclistic.dbo.Cyclistic_2022
	WHERE member_casual LIKE '%casual%'
	GROUP BY day_of_week, DATEPART(MONTH, started_at), member_casual
),
RankedModeCTE AS(
	SELECT
		Mode,
		frequency,
		month,
		member_casual,
		ROW_NUMBER() OVER(PARTITION BY month ORDER BY frequency DESC) AS rn
	FROM ModeCTE
)
SELECT
    Mode,
	frequency,
    month,
	member_casual
FROM RankedModeCTE
WHERE rn = 1
ORDER BY month



------#This query shows the total rides per weekday by member/casual rider---------

Select member_casual, day_of_week, 
COUNT(day_of_week) AS Total_per_weekday
FROM cyclistic.dbo.Cyclistic_2022
GROUP BY member_casual, day_of_week
ORDER BY day_of_week
