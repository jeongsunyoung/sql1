
OUTER JOIN <==> INNER JOIN

INNER JOIN : 조인 조건을 만족하는 (조인에 성공하는) 데이터만 조회
OUTER JOIN : 조인 조건을 만족하지 않더라도 (조인에 실패하더라도) 기준이 되는 테이블 쪽의
             데이터(컬럼)은 조회가 되도록 하는 조인 방식
             
OUTER JOIN :
    LEFT OUTER JOIN : 조인 키워드의 왼쪽에 위치하는 테이블을 기준삼아 OUTER JOIN 시행
    RIGHT OUTER JOIN : 조인 키워드의 오른쪽에 위치하는 테이블을 기준삼아 INNER JOIN 시행
    FULL OUTER JOIN : LEFT OUTER + RIGHT OUTER - 중복되는 것 제외 (사용 드물다)
    
ANSI-SQL
FROM 테이블1 LEFT OUTER JOIN 테이블2 ON (조인 조건)  --테이블1을 기준으로 삼겠다

ORACLE-SQL : 데이터가 없는데 나와야 하는 테이블의 컬럼
FROM 테이블1, 테이블2
WHERE 테이블1.컬럼 = 테이블2.컬럼(+)    -- +기호 : 데이터가 없는쪽에


ANSI-SQL OUTER
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);

ORACLE-SQL OUTER
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno(+);

OUTER JOIN 시 조인 조건(ON 절에 기술)과 일반 조건(WHERE 절에 기술) 적용시 주의 사항
: OUTER JOIN을 사용하는데 WHERE 절에 별도의 다른 조건을 기술할 경우 원하는 결과가 안나올 수 있다
    ==> OUTER JOIN의 결과가 무시

ANSI-SQL
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno AND m.deptno = 10);
-- m.deptno가 10인 아닌 애들은 null 로 발생 (14건) : OUTER JOIN이 정상적으로 성공

SELECT *
FROM emp;

ORACLE-SQL
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno(+) 
  AND m.deptno(+) = 10;   --데이터가 없는 m쪽 컬럼에 다 (+)를 붙여줌


조인 조건을 WHERE 절로 변경한 경우
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
WHERE m.deptno = 10;     --WHERE을 사용하는것 : 결과적으로 INNER JOIN한 것과 비슷
-- deptno가 10인 애들이 발생이 안됨 : OUTER JOIN 실패 : OUTER JOIN이랑 WHERE절이랑 분리해서 실행 

ORACLE-SQL
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno(+) 
  AND m.deptno = 10;   --부서번호쪽에 (+)를 안붙임 : INNER JOIN과 동일?

위의 쿼리는 OUTER JOIN을 사용하지 않은 아래 쿼리와 동일한 결과를 나타낸다
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE m.deptno = 10;    


RIGHT OUTER JOIN : 기준 테이블이 오른쪽
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno); 
-- RIGHT 매니저 밑에 직원이 여러명이기 때문에 데이터 건수가 많아짐


FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno); : 14건
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno); : 21건
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno); : 22건

FULL OUTER JOIN : LEFT OUTER + RIGHT OUTER - 중복제거

ANSI-SQL
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno); 

ORACLE SQL에서는 FULL OUTER 문법을 제공하지 않음
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr(+) = m.empno(+);
-- 에러


A : (1, 3, 5)
B : (2, 3, 4)
A U B : (1, 2, 3, 4, 5) 집합에서 중복의 개념은 없다

A : (1, 3)
B : (1, 3)
C : (1, 2, 3)
A-B : 공집합
A-C : 공집합
C-A : (2)

FULL OUTER 검증  -- 세개의 SQL을 행간 연산

SELECT e.empno, e.ename, m.empno, m.ename                -- 14개
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION   --합집합
SELECT e.empno, e.ename, m.empno, m.ename                -- 21개
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)    -- UNION 합집합 : 22개
MINUS
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);    -- FULL OUTER 빼면 : 0건 
-- 위의 합집합은 FULL보다 작음


SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
UNION   --합집합
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr = m.empno)   --22개
INTERSECT  --교집합
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON (e.mgr = m.empno);  --22개 : 그대로 나옴

중요한 키워드!!
WHERE : 행을 제한
JOIN : RDBMS의 특성 상 데이터가 분산되어 있기 때문에
GROUP FUNCTION : 내용을 잘 이해해야 활용 가능


도시발전지수
시도 : 서울특별시, 충청남도
시군구 : 강남구, 청주시
스토어 구분

발전지수 = (KFC + 버거킹 + 맥도날드) / 롯데리아
순위, 시도, 시군구, 버거 도시발전지수(소수점 2자리 까지)
정렬은 순위가 높은 행이 가장 먼저 나오도록
1. 서울특별시, 강남구, 5.32
2. 서울특별시, 서초구, 5.13
...

SELECT *
FROM fastfood
WHERE sido = '대전광역시';


(과제)
SELECT *
FROM buyprod;

p.248 실습 outerjoin1  
buyprod테이블에서 구매일자가 2005년 1월 25일인 데이터는 3품목 밖에 없다.
모든 품목이 나올 수 있도록 쿼리를 작성

SELECT TO_CHAR(b.buy_date, 'YY/MM/DD') buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
  AND b.buy_date(+) = '2005/01/25';


p.249 실습 outerjoin2
outerjoin1 이어서, buy_date 컬럼이 null인 항목이 안나오도록 
다음처럼 데이터를 채워지도록 쿼리 작성

SELECT NVL(TO_CHAR(b.buy_date, 'YY/MM/DD'), '05/01/25') buy_date, b.buy_prod, 
       p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
  AND b.buy_date(+) = '2005/01/25';


p.250 실습 outerjoin3
outerjoin2 이어서, buy_qty 컬럼이 null일 경우 
0으로 보이도록 쿼리 수정

SELECT NVL(TO_CHAR(b.buy_date, 'YY/MM/DD'), '05/01/25') buy_date, 
       b.buy_prod, p.prod_id, p.prod_name, NVL(b.buy_qty, 0) buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
  AND b.buy_date(+) = '2005/01/25';


p.251 실습 outerjoin4
cycle, product 테이블을 이용, 고객이 애음하는 제품 명칭을 표현하고,
애음하지 않는 제품도 다음과 같이 조회되도록 쿼리를 작성
(고객은 cid=1인 고객만 나오도록 제한, null처리)

SELECT p.pid, p.pnm, NVL(c.cid, 1) cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
FROM cycle c, product p
WHERE c.pid(+) = p.pid
  AND c.cid(+) = '1';
  

p.252 실습 couterjoin5
cycle, product, customer 테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고,
애음하지 않는 제품도 다음과 같이 조회되며 고객이름을 포함하여 쿼리 작성
(고객은 cid=1인 고객만 나오도록 제한, null처리)
SELECT *
FROM customer;

SELECT p.pid, p.pnm, NVL(c.cid, 1) cid, NVL(cnm, 'brown') cnm, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
FROM cycle c, product p, customer m
WHERE c.pid(+) = p.pid
  AND c.cid = m.cid(+)
  AND c.cid(+) = '1';


