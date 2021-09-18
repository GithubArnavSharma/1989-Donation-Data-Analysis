-- DATA ANALYSIS ON THE CLEAN DONATION DATASET

--Get data on which states donate and withdraw the most from campaigns

SELECT DISTINCT([STATE]), COUNT(CMTE_ID)
FROM itcont
GROUP BY [STATE]
ORDER BY COUNT(CMTE_ID) DESC;

/* Results: California(1432914), Texas(678979), and Florida(619569) all transact the most amount of times,
 * Puerto Rico(2982), North Dakota(12649), and Wyoming(15351) all transact the least */

--Get data on which states have the lowest and highest average donation amount

SELECT DISTINCT([STATE]), AVG(TRANSACTION_AMT)
FROM itcont
WHERE TRANSACTION_AMT > 0
GROUP BY [STATE]
ORDER BY AVG(TRANSACTION_AMT) DESC;

/* Results: DC($947), Puerto Rico($282), and Nevada($260) all have the highest mean donation amount, 
 * while Hawaii($70), West Virginia($82), and Oregon($83) all have the lowest mean donation amount */

--Get data on which states have the lowest and highest average withdrawal amount

SELECT DISTINCT([STATE]), AVG(TRANSACTION_AMT)
FROM itcont
WHERE TRANSACTION_AMT < 0
GROUP BY [STATE]
ORDER BY AVG(TRANSACTION_AMT) ASC;

/* Results: DC($-596), Puerto Rico($-499), and Missouri($-419) all have the highest average withdrawal
 * amount, while Vermont($-55), Mississippi($-71), and South Dakota($-90) all have the lowest */

-- Get data on the number of transactions per city

SELECT DISTINCT([CITY]), COUNT(CMTE_ID)
FROM itcont
GROUP BY [CITY]
HAVING COUNT(CMTE_ID) > 200
ORDER BY COUNT(CMTE_ID) DESC;

/* Results: Although most transactions(313831) are conducted by non-popular cities, New York(174161), 
 * Washington(99821), Houston(86799), Los Angeles(93695) and Chicago(68696) are the top 5 highest
 * transacting cities */

-- Get data on which cities transact the most amount of money on average

SELECT DISTINCT([CITY]), AVG(TRANSACTION_AMT)
FROM itcont
WHERE TRANSACTION_AMT > 0 AND TRANSACTION_AMT < 1000000
GROUP BY [CITY]
HAVING COUNT(CMTE_ID) > 2500
ORDER BY AVG(TRANSACTION_AMT) DESC;

/* RESULTS: Greenwich($1490), Little Rock($1200), Palm Beach($900), Miami Beach($786) and Los altos
($700) are all the cities with the highest average donation amoun */

-- Get data on the types of elections, how common they were, and the average donation amount

SELECT DISTINCT(TRANSACTION_PGI), COUNT(TRANSACTION_PGI), AVG(TRANSACTION_AMT)
FROM itcont
GROUP BY TRANSACTION_PGI
HAVING COUNT(TRANSACTION_PGI) > 1000
ORDER BY COUNT(TRANSACTION_PGI) DESC;

/* Results: Primary election transactions occured 4400421 times with an average transaction of $226. For
 * Runoff elections, it was 410516 and $65. For general elections, it was 177695 and $450. For conventions,
 * it as 10563 and $332. For special elections, it was 10504 and $636. For recount elections, it was 
 * 8619 and $639 */

-- Get data on how different types of employers affect the average transaction amount

SELECT DISTINCT(EMPLOYER), COUNT(CMTE_ID), AVG(TRANSACTION_AMT)
FROM itcont
GROUP BY EMPLOYER
HAVING COUNT(CMTE_ID) > 15000
ORDER BY COUNT(CMTE_ID) DESC;

/* Results: People not currently employed and retired people donate an average amount of $83. Self employed
 * people donate an average of $193, while homemakers donate $378. Members of the Northrop Grunman
 * Corporation were the next most common, donating an average of $42. Boeing employees were also common
 * donators, donating an average of $66 */

-- Get data on how different occupations affect transaction amounts

SELECT DISTINCT(OCCUPATION), COUNT(CMTE_ID), AVG(TRANSACTION_AMT)
FROM itcont
GROUP BY OCCUPATION
HAVING COUNT(CMTE_ID) > 1000
ORDER BY COUNT(CMTE_ID) DESC;

/* Results: The most popular occupations for donating are attorneys, physicians, engineers, professors, 
 * and consultants. Attorneys donate an average of $420, physicians $185, engineers, $145, professors
 * $112, and consultants $331 */
