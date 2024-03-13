DROP TABLE IF EXISTS brands;
CREATE TABLE brands 
(
    brand1      VARCHAR(20),
    brand2      VARCHAR(20),
    year        INT,
    custom1     INT,
    custom2     INT,
    custom3     INT,
    custom4     INT
);
INSERT INTO brands VALUES ('apple', 'samsung', 2020, 1, 2, 1, 2);
INSERT INTO brands VALUES ('samsung', 'apple', 2020, 1, 2, 1, 2);
INSERT INTO brands VALUES ('apple', 'samsung', 2021, 1, 2, 5, 3);
INSERT INTO brands VALUES ('samsung', 'apple', 2021, 5, 3, 1, 2);
INSERT INTO brands VALUES ('google', NULL, 2020, 5, 9, NULL, NULL);
INSERT INTO brands VALUES ('oneplus', 'nothing', 2020, 5, 9, 6, 3);

SELECT * FROM brands;
WITH cte AS (
    SELECT *,
           CASE WHEN brand1 < brand2 THEN CONCAT(brand1, brand2, year)
                ELSE CONCAT(brand2, brand1, year)
           END AS pair_id
    FROM brands
),
cte_rn AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY pair_id ORDER BY pair_id) AS rn
    FROM cte
)
SELECT c1.brand1, c1.brand2, c1.year, c1.custom1, c1.custom2, c1.custom3, c1.custom4
FROM cte_rn c1
LEFT JOIN cte_rn c2 ON c1.pair_id = c2.pair_id AND c2.rn > 1
WHERE c1.rn = 1 OR 
      (c1.rn > 1 AND (c1.custom1 <> c2.custom1 OR c1.custom2 <> c2.custom2));


