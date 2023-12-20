--Индекс для ускорения запроса по средней компенсации вакансий:
CREATE INDEX idx_area_id ON vacancies (area_id);
CREATE INDEX idx_compensation_to ON vacancies (compensation_to);
CREATE INDEX idx_compensation_from ON vacancies (compensation_from);

explain analyse
SELECT area_id,
       AVG(compensation_to)                           AS avg_compensation_to,
       AVG(compensation_from)                         AS avg_compensation_from,
       AVG((compensation_from + compensation_to) / 2) AS avg_compensation
FROM vacancies
GROUP BY area_id;

--Индексы для ускорения запроса по дате публикации вакансий и резюме(на удивление не помогли,видимо потому что мало уникальных дат вида YYYY-MM):
CREATE INDEX idx_published_date ON vacancies (published_date);
CREATE INDEX idx_response_date ON resumes (published_date);

explain analyse
SELECT TO_CHAR(published_date, 'YYYY-MM') AS year_month,
       COUNT(*)                           AS count_vacancies
FROM vacancies
GROUP BY year_month
ORDER BY count_vacancies DESC
LIMIT 1;

explain analyse
SELECT TO_CHAR(published_date, 'YYYY-MM') AS year_month,
       COUNT(*)                           AS count_resumes
FROM resumes
GROUP BY year_month
ORDER BY count_resumes DESC
LIMIT 1;

--индексы для ускорения запроса по количеству откликов на вакансий:
CREATE INDEX idx_response_date ON responses (response_date);
CREATE INDEX idx_vacancy_id_responses ON responses (vacancy_id);
CREATE INDEX idx_published_date_vacancies ON vacancies (published_date);

explain analyse
SELECT v.vacancy_id,
       v.title
FROM vacancies v
         JOIN
     responses r ON v.vacancy_id = r.vacancy_id
WHERE r.response_date BETWEEN v.published_date AND v.published_date + INTERVAL '7 days'
GROUP BY v.vacancy_id, v.title
HAVING COUNT(r.response_id) > 5;

