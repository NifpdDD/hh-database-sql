SELECT area_id,
       AVG(compensation_to)                           AS avg_compensation_to,
       AVG(compensation_from)                         AS avg_compensation_from,
       AVG((compensation_from + compensation_to) / 2) AS avg_compensation
FROM vacancies
GROUP BY area_id;

SELECT EXTRACT(MONTH FROM published_date) AS month,
       COUNT(*)                           AS count_vacancies
FROM vacancies
GROUP BY month
ORDER BY count_vacancies DESC
LIMIT 1;

SELECT EXTRACT(MONTH FROM published_date) AS month,
       COUNT(*)                           AS count_resumes
FROM resumes
GROUP BY month
ORDER BY count_resumes DESC
LIMIT 1;

SELECT v.vacancy_id,
       v.title
FROM vacancies v
         JOIN
     responses r ON v.vacancy_id = r.vacancy_id
WHERE r.response_date BETWEEN v.published_date AND v.published_date + INTERVAL '7 days'
GROUP BY v.vacancy_id, v.title
HAVING COUNT(r.response_id) > 5;

