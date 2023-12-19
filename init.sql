CREATE TABLE vacancies
(
    vacancy_id        SERIAL PRIMARY KEY,
    title             VARCHAR(255),
    description       TEXT,
    compensation_from NUMERIC,
    compensation_to   NUMERIC,
    area_id           INTEGER,
    published_date    DATE
);
CREATE TABLE resumes
(
    resume_id      SERIAL PRIMARY KEY,
    name           VARCHAR(255),
    experience     TEXT,
    skills         TEXT,
    area_id        INTEGER,
    published_date DATE
);
CREATE TABLE responses
(
    response_id   SERIAL PRIMARY KEY,
    vacancy_id    INTEGER REFERENCES vacancies (vacancy_id),
    resume_id     INTEGER REFERENCES resumes (resume_id),
    response_date DATE
);
CREATE TABLE specializations
(
    specialization_id SERIAL PRIMARY KEY,
    name              VARCHAR(255)
);
CREATE TABLE vacancy_specializations
(
    vacancy_id        INTEGER REFERENCES vacancies (vacancy_id),
    specialization_id INTEGER REFERENCES specializations (specialization_id),
    PRIMARY KEY (vacancy_id, specialization_id)
);

INSERT INTO vacancies (title, description, compensation_from, compensation_to, area_id, published_date)
SELECT 'Vacancy ' || generate_series,
       'Description for vacancy ' || generate_series,
       (random() * 50000 + 50000)::numeric(10, 2),
       (random() * 50000 + 100000)::numeric(10, 2),
       (random() * 5 + 1)::int,
       CURRENT_DATE - (random() * 365)::INTEGER
FROM generate_series(1, 10000);

INSERT INTO resumes (name, skills, experience, area_id, published_date)
SELECT 'Applicant ' || generate_series,
       'Skills for applicant ' || generate_series,
       'Experience for applicant ' || generate_series,
       (random() * 5 + 1)::int,
       CURRENT_DATE - (random() * 365)::INTEGER
FROM generate_series(1, 100000);

INSERT INTO responses (vacancy_id, resume_id, response_date)
SELECT (random() * 9999 + 1)::int,
       (random() * 99999 + 1)::int,
       CURRENT_DATE - (random() * 365)::INTEGER
FROM generate_series(1, 10000);

INSERT INTO specializations (name)
SELECT 'Specialization ' || generate_series
FROM generate_series(1, 100);

INSERT INTO vacancy_specializations (vacancy_id, specialization_id)
SELECT DISTINCT (random() * 9999 + 1)::int AS vacancy_id,
                (random() * 99 + 1)::int   AS specialization_id
FROM generate_series(1, 50000);





