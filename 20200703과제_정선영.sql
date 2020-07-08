hr

(과제)
P.229 실습 join8
countries, regions테이블을 이용하여
지역별 소속 국가를 다음과 같은 결과가 나오도록 쿼리 작성
(지역은 유럽만 한정)
SELECT region_id, regions.region_name, countries.country_name
FROM countries NATURAL JOIN regions
WHERE region_name = 'Europe';


p.230 실습 join9
countries, regions, locations 테이블을 이용하여 
지역별 소속 국가, 국가에 소속된 도시 이름을 다음과 같이 작성
(지역은 유럽만 한정) 
SELECT r.region_id, r.region_name, c.country_name, l.city
FROM countries c JOIN regions r ON (c.region_id = r.region_id)
                 JOIN locations l ON (c.country_id = l.country_id)
WHERE region_name = 'Europe';


p.231 실습 join10
countries, regions, locations, departments 테이블을 이용하여
지역별 소속 국가, 국가에 소속된 도시 이름 및 도시에 있는 부서를 작성
(지역은 유럽 한정) 
SELECT r.region_id, r.region_name, c.country_name, l.city, d.department_name
FROM regions r JOIN countries c ON (r.region_id = c.region_id)
               JOIN locations l ON (c.country_id = l.country_id)
               JOIN departments d ON (l.location_id = d.location_id)
WHERE region_name = 'Europe';


p.232 실습 join11 
countries, regions, locations, departments, employees 테이블을 이용하여
지역별 소속 국가, 국가에 소속된 도시 이름 및 도시에 있는 부서, 부서에 소속된 직원 정보
(지역: 유럽)
SELECT c.region_id, r.region_name, c.country_name, l.city, 
       d.department_name, e.first_name || e.last_name name
FROM regions r JOIN countries c ON (r.region_id = c.region_id)
               JOIN locations l ON (c.country_id = l.country_id)
               JOIN departments d ON (l.location_id = d.location_id)
               JOIN employees e ON (d.department_id = e.department_id)
WHERE region_name = 'Europe';


p.233 실습 join12
employees, jobs 테이블을 이용하여
직원의 담당업무 명칭을 포함하여 다음과 같은 결과가 나오도록 쿼리 작성
SELECT e.employee_id, e.first_name || e.last_name name, j.job_id, j.job_title
FROM employees e JOIN jobs j ON (e.job_id = j.job_id);


p.234 실습 join13
employees, jobs 테이블을 이용하여
직원의 담당업무 명칭, 직원의 매니저 정보를 포함하여 다음과 같은 쿼리 작성
SELECT e.manager_id mgr_id, e.first_name || e.last_name mgr_name, e.employee_id, 
       e.first_name || e.last_name name, j.job_id, j.job_title
FROM jobs j JOIN employees e ON (e.job_id = j.job_id)
            JOIN employees o ON (e.manager_id = o.employee_id);
        
