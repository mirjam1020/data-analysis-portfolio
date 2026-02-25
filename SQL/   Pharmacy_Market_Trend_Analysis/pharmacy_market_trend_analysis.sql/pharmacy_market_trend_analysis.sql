/* 
Pharmacy Market Trend Analysis
Author: Mirjam Riivald

This analysis explores:
1. Openings and closures trends
2. Impact by pharmacy size
3. Healthcare access implications
4. Distance sellers vs physical pharmacies
*/

-- 1. What is the trend in pharmacy openings and closures over time? -- 
-- monthly trend --
SELECT
    YEAR,
    MONTH,
    (SMALL_PHARMACIES_OPENED + MEDIUM_PHARMACIES_OPENED + LARGE_PHARMACIES_OPENED) AS total_opened,
    (SMALL_PHARMACIES_CLOSED + MEDIUM_PHARMACIES_CLOSED + LARGE_PHARMACIES_CLOSED) AS total_closed
FROM [dbo].[Pharmacy Dataset]
ORDER BY YEAR, MONTH;
-- yearly trend --
SELECT
    YEAR,
    (SMALL_PHARMACIES_OPENED + MEDIUM_PHARMACIES_OPENED + LARGE_PHARMACIES_OPENED) AS total_opened,
    (SMALL_PHARMACIES_CLOSED + MEDIUM_PHARMACIES_CLOSED + LARGE_PHARMACIES_CLOSED) AS total_closed,
    (SMALL_PHARMACIES_NET_CHANGE + MEDIUM_PHARMACIES_NET_CHANGE + LARGE_PHARMACIES_NET_CHANGE) AS total_net_change
FROM [dbo].[Pharmacy Dataset]
ORDER BY YEAR;
-- 2. Are closures disproportionately affecting certain pharmacy sizes? --
SELECT
    v.pharmacy_size,
    SUM(v.closed) AS total_closed
FROM [dbo].[Pharmacy Dataset] d
CROSS APPLY (VALUES
    ('Small',  d.SMALL_PHARMACIES_CLOSED),
    ('Medium', d.MEDIUM_PHARMACIES_CLOSED),
    ('Large',  d.LARGE_PHARMACIES_CLOSED)
) v(pharmacy_size, closed)
GROUP BY v.pharmacy_size;
-- 3. What are the implications for healthcare access? --
-- trend in total pharmacies --
SELECT
[YEAR],
MAX(TOTAL_PHARMACIES) AS totalpharmacies_end_of_year
FROM [dbo].[Pharmacy Dataset]
GROUP BY [YEAR]
ORDER BY [YEAR];
-- net change over time --
SELECT
    YEAR,
    SUM(
        SMALL_PHARMACIES_NET_CHANGE +
        MEDIUM_PHARMACIES_NET_CHANGE +
        LARGE_PHARMACIES_NET_CHANGE
    ) AS yearly_net_change,
    SUM(
        SUM(
            SMALL_PHARMACIES_NET_CHANGE +
            MEDIUM_PHARMACIES_NET_CHANGE +
            LARGE_PHARMACIES_NET_CHANGE
        )
    ) OVER (ORDER BY YEAR) AS cumulative_change
FROM [dbo].[Pharmacy Dataset]
GROUP BY YEAR
ORDER BY YEAR;
-- 4. Are distance sellers replacing physical pharmacies? --
SELECT
    YEAR,
    SUM(DISTANCE_SELLERS_NET_CHANGE) AS distance_change,
    SUM(
        SMALL_PHARMACIES_NET_CHANGE +
        MEDIUM_PHARMACIES_NET_CHANGE +
        LARGE_PHARMACIES_NET_CHANGE
    ) AS physical_change,
    SUM(DISTANCE_SELLERS_NET_CHANGE)
    +
    SUM(
        SMALL_PHARMACIES_NET_CHANGE +
        MEDIUM_PHARMACIES_NET_CHANGE +
        LARGE_PHARMACIES_NET_CHANGE
    ) AS total_market_change
FROM [dbo].[Pharmacy Dataset]
GROUP BY YEAR
ORDER BY YEAR;


