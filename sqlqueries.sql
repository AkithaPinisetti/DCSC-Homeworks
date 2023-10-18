1. SELECT
    animal_type,
    COUNT(DISTINCT animal_id) AS num_animals_with_outcomes
FROM
    fct_animal
GROUP BY
    animal_type;

2. SELECT COUNT(animal_id) AS num_animals_with_more_than_one_outcome
FROM (
    SELECT animal_id
    FROM fct_animal
    GROUP BY animal_id
    HAVING COUNT(DISTINCT outcome_id) > 1
) AS subquery;

3. SELECT 
    TO_CHAR(datetime, 'Month') AS month_name, 
    COUNT(*) AS outcome_count
FROM 
    dim_time
GROUP BY 
    month_name
ORDER BY 
    outcome_count DESC
LIMIT 5;

4.i. WITH age_categories AS (
    SELECT
        CASE
            WHEN date_part('year', age(current_date, date_of_birth)) < 1 THEN 'Kitten'
            WHEN date_part('year', age(current_date, date_of_birth)) >= 1 AND date_part('year', age(current_date, date_of_birth)) <= 10 THEN 'Adult'
            WHEN date_part('year', age(current_date, date_of_birth)) > 10 THEN 'Senior'
            ELSE 'Unknown'
        END AS age_category,
        outcome_type
    FROM dim_animal
    WHERE animal_type = 'Cat'
)
SELECT
    age_category,
    COUNT(*) AS total_count,
    (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()) AS percentage
FROM age_categories
WHERE outcome_type = 'Adopted'
GROUP BY age_category;

4.ii. SELECT
    COUNT(CASE WHEN age_category = 'Kitten' THEN 1 END) AS kittens_count,
    COUNT(CASE WHEN age_category = 'Adult' THEN 1 END) AS adults_count,
    COUNT(CASE WHEN age_category = 'Senior' THEN 1 END) AS seniors_count,
    COUNT(*) AS total_count,
    (COUNT(CASE WHEN age_category = 'Kitten' THEN 1 END) * 100.0 / COUNT(*)) AS kittens_percentage,
    (COUNT(CASE WHEN age_category = 'Adult' THEN 1 END) * 100.0 / COUNT(*)) AS adults_percentage,
    (COUNT(CASE WHEN age_category = 'Senior' THEN 1 END) * 100.0 / COUNT(*)) AS seniors_percentage
FROM (
    SELECT
        d.name AS animal_name,
        d.date_of_birth AS date_of_birth,
        a.outcome_type AS outcome_type,
        CASE
            WHEN EXTRACT(YEAR FROM AGE(d.date_of_birth, a.datetime)) < 1 THEN 'Kitten'
            WHEN EXTRACT(YEAR FROM AGE(d.date_of_birth, a.datetime)) BETWEEN 1 AND 6 THEN 'Adult'
            ELSE 'Senior'
        END AS age_category
    FROM
        dim_animal AS d
    INNER JOIN
        fct_animal AS a ON d.animal_id = a.animal_id
    WHERE
        d.animal_type = 'Cat' AND a.outcome_type = 'Adopted'
) AS cat_adoptions;

5. SELECT
  datetime,
  outcome_type,
  SUM(COUNT(outcome_type)) OVER (ORDER BY datetime) AS cumulative_total
FROM
  outcomes
GROUP BY
  datetime, outcome_type
ORDER BY
  datetime, outcome_type;
