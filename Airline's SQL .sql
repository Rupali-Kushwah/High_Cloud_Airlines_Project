use airline;
select * from calendar;
# Date
INSERT INTO calendar 
    (Datekey,
    year,
    month,
    day,
    week,
    monthname,
    weekday,
    yearmonth,
    dayname,
    quarters,
    Financial_Month,
    Financial_Quarters
)
SELECT DISTINCT
    STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d') AS Datekey,
    year,
    month,
    day,
    WEEK(STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d')) AS week,
    MONTHNAME(STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d')) AS monthname,
    DAYOFWEEK(STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d')) AS weekday,
    DATE_FORMAT(STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d'), '%Y-%b') AS yearmonth,
    DAYNAME(STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d')) AS dayname,
    CONCAT('Q', QUARTER(STR_TO_DATE(CONCAT(year, '-', month, '-', day), '%Y-%m-%d'))) AS quarters,
    CASE
        WHEN month >= 4 THEN month - 3
        ELSE month + 9
    END AS Financial_Month,
    CASE
        WHEN month BETWEEN 4 AND 6 THEN 'Q1'
        WHEN month BETWEEN 7 AND 9 THEN 'Q2'
        WHEN month BETWEEN 10 AND 12 THEN 'Q3'
        ELSE 'Q4'
    END AS Financial_Quarters
FROM maindata;
# show calendar table
select * from calendar;

# Total Number of Airlines
SELECT COUNT(DISTINCT `Unique Carrier`) AS total_airlines
FROM maindata;

#Total Passengers Transported by Each Carrier
SELECT `Unique Carrier`, SUM(`# Transported Passengers`) AS total_passengers
FROM maindata
GROUP BY `Unique Carrier`
ORDER BY total_passengers DESC;

#Load Factor % by Year, Quarter, Month
 # Yearly Load factor
SELECT 
  year, 
  ROUND(SUM(`# Transported Passengers`) * 100.0 / SUM(`# Available Seats`), 2) AS Load_Factor_Percentage
FROM maindata
GROUP BY year
ORDER BY year;

 # Monthly Load factor 
SELECT 
  year, month, 
  ROUND(SUM(`# Transported Passengers`) * 100.0 / SUM(`# Available Seats`), 2) AS Load_Factor_Percentage
FROM maindata
GROUP BY year, month
ORDER BY year, month;

# Quarterly Load factor

SELECT 
    c.quarters AS quarter,
    SUM(m.`# transported passengers`) AS total_passengers,
    SUM(m.`# available seats`) AS total_seats,
    ROUND((SUM(m.`# transported passengers`) / SUM(m.`# available seats`)) * 100, 2) AS load_factor_percentage
FROM maindata m
JOIN calendar c
    ON STR_TO_DATE(CONCAT(m.year, '-', m.month, '-', m.day), '%Y-%m-%d') = c.Datekey
GROUP BY c.quarters
ORDER BY c.quarters;


# Top 5 Origin Cities by Passenger Traffic
SELECT `Origin City`, SUM(`# Transported Passengers`) AS total_passengers
FROM maindata
GROUP BY `Origin City`
ORDER BY total_passengers DESC
LIMIT 5;

#Carrier-wise Total Freight Transported
SELECT `Carrier Name`, SUM(`# Transported Freight`) AS total_freight
FROM maindata
GROUP BY `Carrier Name`
ORDER BY total_freight DESC;


#Monthly Passenger Trends (across all years)
SELECT `Month (#)` AS month, SUM(`# Transported Passengers`) AS total_passengers
FROM maindata
GROUP BY `Month (#)`
ORDER BY month;

#Passenger Load Between Two Countries\
SELECT `Origin Country`, `Destination Country`, SUM(`# Transported Passengers`) AS passengers
FROM maindata
GROUP BY `Origin Country`, `Destination Country`
ORDER BY passengers DESC;

#Top 5 Busiest Airport Pairs (From-To)
SELECT `From - To Airport Code`, SUM(`# Transported Passengers`) AS total_passengers
FROM maindata
GROUP BY `From - To Airport Code`
ORDER BY total_passengers DESC
LIMIT 5;

#Load Factor (Passenger per Available Seat) by Carrier
SELECT 
    `Carrier Name`,
    CONCAT(ROUND(SUM(`# Transported Passengers`) / SUM(`# Available Seats`) * 100, 2), '%') AS load_factor
FROM 
    maindata GROUP BY `Carrier Name`
ORDER BY 
    SUM(`# Transported Passengers`) / SUM(`# Available Seats`) DESC;


#Year-wise Total Departures Scheduled
SELECT `Year`, SUM(`# Departures Scheduled`) AS total_departures
FROM maindata
GROUP BY `Year`
ORDER BY `Year`;

# highest passenger traffic by day
SELECT c.dayname, SUM(m.`# Transported Passengers`) AS total_passengers
FROM maindata m
JOIN calendar c 
  ON STR_TO_DATE(CONCAT(m.year, '-', m.month, '-', m.day), '%Y-%m-%d') = c.Datekey
GROUP BY c.dayname
ORDER BY total_passengers DESC;

# Passengers by Country
SELECT `Origin Country`, SUM(`# Transported Passengers`) AS total_passengers
FROM maindata
GROUP BY `Origin Country`
ORDER BY total_passengers DESC;

#Peak Months (Across All Years)
SELECT 
  month, 
  MONTHNAME(STR_TO_DATE(CONCAT('2020-', month, '-01'), '%Y-%m-%d')) AS month_name,
  SUM(`# Transported Passengers`) AS total_passengers
FROM maindata
GROUP BY month
ORDER BY total_passengers DESC;


