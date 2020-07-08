
GROUP 함수의 특징
1. NULL은 그룹함수 연산에서 제외가 된다.
부서번호별 사원의 sal, comm 컬럼의 총 합을 구하기

SELECT deptno, SUM(sal + comm), SUM(sal + NVL(comm, 0)) + SUM(sal) + SUM(comm)   --SUM 안에서 계산할때의 null값은?
FROM emp
GROUP BY deptno;   -----------------

30	7800	23200
20  null    null
10  null    null		

--NULL 값은 행간 무시,,, 컬럼간은 무시X

SELECT deptno, SUM(sal) + NVL(SUM(comm), 0),    --커미션을 받고 마지막 결과에만 NVL
               SUM(sal) + SUM(NVL(comm, 0))
FROM emp
GROUP BY deptno;  ------------------- 함수의 

30	11600	11600
20	10875	10875
10	8750	8750

-- 칠거지악3. Decode 또는 Case를 사용시에 새끼를 증손자 이상 낳치 마라. (decode(decode...)) 중첩X
-- 이렇게 증손자 이상으로 들어가면 연산자 개산에 cost가 발생해서 처리 속도가 떨리집니다.


p.193 실습 grp1
emp테이블을 이용하여 다음을 구하시오   --전체행을 그룹화할때 GROUP BY는 기술하지 않는다!!
직원중 가장 높은 급여
직원중 가장 낮은 급여
직원의 급여 평균(소수점 두자리까지 나오도록 반올림)
직원의 급여 합
직원중 급여가 있는 직원의 수(null 제외)
직원중 상급자가 있는 직원의 수(null 제외)
전체 직원의 수
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, 
       SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp;


p.194 실습 grp2
emp테이블을 이용하여 다음을 구하시오   --전체행을 그룹화할때 GROUP BY는 기술하지 않는다!!
부서기준 직원중 가장 높은 급여
부서기준 직원중 가장 낮은 급여
부서기준 직원의 급여 평균(소수점 두자리까지 나오도록 반올림)
부서기준 직원의 급여 합
부서의 직원중 급여가 있는 직원의 수(null 제외)
부서의 직원중 상급자가 있는 직원의 수(null 제외)
부서의 직원의 수
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, 
       SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno;


p.195 실습 grp3
emp 테이블을 이용하여 다음을 구하시오
grp2에서 작성한 쿼리를 활용하여 deptno 대신에 부서명이 나올수 있도록 수정하시오
--좋은예(코드가 짧음)
SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 'DDIT') dname, 
       MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, 
       SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY deptno;

SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 'DDIT') dname, 
       MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, 
       SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
FROM emp
GROUP BY DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 'DDIT'); --GROUP BY에 DECODE
--GROUP BY(별칭X) - SELECT - ORDER BY(별칭O)

--안좋은예
SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 'DDIT') dname, 
        max_sal, min_sal, avg_sal, sum_sal, count_sal, count_mgr, count_all
FROM(SELECT deptno, 
            MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, 
            SUM(sal) sum_sal, COUNT(sal) count_sal, COUNT(mgr) count_mgr, COUNT(*) count_all
     FROM emp
     GROUP BY deptno); 
--칠거지악5. In Line View 또는 out of temp를 사용할 때 진정 필요한 In Line View인지를 확인하라.


p.196 실습 grp4
emp테이블을 이용하여 다음을 구하시오
직원의 입사 년월별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요
SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

p.197 실습 grp5
emp테이블을 이용하여 다음을 구하시오
직원의 입사 년별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요
SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY');

p.198 실습 grp6
회사에 존재하는 부서의 개수는 몇개인지 조회하는 쿼리를 작성
(dept 테이블 사용)
select *
FROM dept;

SELECT COUNT(*) cnt    --행의 수를 구할때는 이름 보다는 * 사용
FROM dept;       --행전체를 하나로 묶을때는 GROUP BY 절 사용 안함

p.199 실습 grp7
직원이 속한 부서의 개수를 조회하는 쿼리를 작성하시오
(emp 테이블 사용)
SELECT COUNT(*) cnt            --인라인뷰
FROM
    (SELECT deptno    
     FROM emp
     GROUP BY deptno);

--다른방법     
SELECT COUNT(COUNT(deptno)) cnt   
FROM emp
GROUP BY deptno;



데이터 결합
JOIN : 컬럼을 확장하는 방법 (데이터를 연결한다)
       다른 테이블의 컬럼을 가져온다.
RDBMS가 중복을 최소화하는 구조 이기 때문에
하나의 테이블에 데이터를 전부 담지 않고, 목적에 맞게 설계한 테이블에
데이터가 분산이 된다.
하지만 데이터를 조회 할때 다른 테이블의 데이터를 연결하여 컬럼을 가져올 수 있다.

ANSI-SQL : American National Standards Institute-SQL
ORACLE-SQL 문법

JOIN : ANSI-SQL
       ORACLE-SQL의 차이가 다소 발생

       
ANSI-SQL JOIN
NATURAL JOIN : 조인하고자 하는 테이블간 컬럼명이 동일할 경우 해당 컬럼으로
               행을 연결
               컬럼 이름 뿐만 아니라 데이터 타입도 동일 해야함.
문법 :
SELECT 컬럼...
FROM 테이블1, NATURAL JOIN 테이블2

emp, dept 두테이블의 공통된 이름을 갖는 컬럼 : deptno

조인 조건으로 사용된 컬럼은 테이블 한정자를 붙이면 에러(ANSI-SQL)
SELECT emp.empno, emp.ename, deptno, dept.dname
FROM emp NATURAL JOIN dept;
-- 두 테이블에 동일한 이름의 컬럼(deptno)이 있을때? ==> 한정자

위의 쿼리를 ORACLE 버전으로 수정
오라클에서는 조인 조건을 WHERE절에 기술
행을 제한하는 조건, 조인 조건 ==> WHERE절에 기술

SELECT *
FROM emp, dept
WHERE deptno = deptno;         -- 에러 'column ambiguously defined'

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;    --이름이 동일한 컬럼이 있을 때는 한정자를 붙인다
-- 중복된 컬럼이 다 나옴   deptno, deptno_1

SELECT deptno         -- 에러 'column ambiguously defined'
FROM emp, dept
WHERE emp.deptno = dept.deptno;    

SELECT emp.*, emp.deptno, dname         -- 한쪽 테이블에만 있는 컬럼(dname)은 한정자 없이 사용 가능
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT emp.*, emp.deptno, dname         
FROM emp, dept
WHERE emp.deptno != dept.deptno;        --부서번호가 10이면 20,30,40과 연결 ==> 42개


ANSI-SQL : JOIN WITH USING
조인 테이블간 동일한 이름의 컬럼이 복수개 인데
이름이 같은 컬럼중 일부로만 조인하고 싶을 때 사용

SELECT *
FROM emp JOIN dept USING (deptno);

위의 쿼리를 ORACLE 조인으로 변경하면??    --오라클 SQL은 한가지
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;


ANSI-SQL : JOIN with ON
위에서 배운 NATURAL JOIN, JOIN with USING의 경우 조인 테이블의 조인컬럼이
이름이 같아야 한다는 제약 조건이 있음
설계상 두 테이블의 컬럼 이름이 다를수도 있음. 컬럼 이름이 다를 경우
개발자가 직접 조인 조건을 기술할 수 있도록 제공해주는 문법

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

ORACLE-SQL로 작성해보기
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;


SELF-JOIN : 동일한 테이블끼리 조인 할 때 지칭하는 명칭
            (별도의 키워드가 아니다)

SELECT 사원번호, 사원이름, 사원의 상사 사원번호, 사원의 상사 이름    --사원의 상사 이름은 테이블에 없음
FROM emp

KING의 경우 상사가 없이 때문에 조인에 실패한다
총 행의 수는 13건이 조회된다
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON ( e.mgr = m.empno );    --사원번호 가져올 곳 e, 상사이름 가져올 곳 m

사원중 사원의 번호가 7369~7698인 사원만 대상으로 해당 사원의
사원번호, 이름, 상사의 사원번호, 상사의 이름

SELECT *
FROM emp;

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON ( e.mgr = m.empno )
WHERE e.empno BETWEEN 7369 AND 7698;

SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON ( e.mgr = m.empno )
WHERE e.empno >= 7369                 -- 연산자 사용
  AND e.empno <= 7698;

SELECT a.*, emp.ename                 -- 인라인뷰 사용하여 ORACLE문법 ==> 절차확인
FROM
    (SELECT empno, ename, mgr
     FROM emp 
     WHERE empno BETWEEN 7369 AND 7698) a, emp
WHERE a.mgr = emp.empno ;

ANSI-SQL로 작성하기
SELECT a.*, emp.ename                 
FROM
    (SELECT empno, ename, mgr
     FROM emp 
     WHERE empno BETWEEN 7369 AND 7698) a JOIN emp ON (a.mgr = emp.empno);
     

NON-EQUI-JOIN : 조인 조건이 = 이 아닌 조인      --외울 필요는 없음! 논리적으로 생각해요
  != 값이 다를 때 연결

SELECT empno, ename, sal, grade --급여등급
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal;
--각 행 간에 중복되는 값이 있으면 안됨

SELECT *
FROM salgrade;
-- 선분연결?? 나열했을때 빠지는 숫자가 없는
1	700	    1200
2	1201	1400
3	1401	2000
4	2001	3000
5	3001	9999

p.215 실습 join0
emp,dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

p.216 실습 join0_1
emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리 작성
(부서번호가 10, 30인 데이터만 조회)
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno 
  AND emp.deptno IN (10, 30);
--AND dept.deptno IN (10, 30);   동일한 결과. 의미는 없음

p.217 실습 join0_2
emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성
(급여가 2500 초과)
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND sal > 2500;


p.218 실습 join0_3
emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성
(급여 2500초과, 사번이 7600보다 큰 직원)
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND sal > 2500
  AND empno > 7600;

p.219 실습 join0_4
emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성
(급여 2500 초과, 사번이 7600보다 크고, RESEARCH 부서에 속하는 직원)
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND sal > 2500
  AND empno > 7600
  AND dname = 'RESEARCH';


