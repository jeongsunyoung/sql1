

DECODE : 조건에 따라 반환값이 달라지는 함수        -- 잘안씀 / CASE보다 좋은점은 짧음 ==> 가독성+
        ==> 비교, JAVA (if), SQL - case와 비슷
        단 비교연산이 ( = )만 가능
        CASE의 WHEN절에 기술할 수 있는 코드는 참 거짓 판단할 수 있는 코드면 가능
        ex : sal > 1000
        이것과 다르게 DECODE 함수에서는 sal = 1000, sal = 2000
        
DECODE는 가변인자(인자의 갯수가 정해지지 않음, 상황에 따라 늘어날 수도 있다)를 갖는 함수
문법 : DECODE(기준값[col/expression],
              비교값1, 반환값1,
              비교값2, 반환값2,
              비교값3, 반환값3,
              옵션(기준값이 비교값 중에 일치하는 값이 없을 때 기본적으로 반환할 값))
==> java
if (기준값 == 비교값1)
    반환값1을 반환해준다
else if (기준값 == 비교값2)
    반환값2를 반환해준다
else if (기준값 == 비교값3)
    반환값3을 반환해준다
else
    마지막 인자가 있을 경우 마지막 인자를 반환하고
    마지막 인자가 없을 경우 null을 반환

어제 작성한 SQL을 DECODE
emp 테이블을 이용하여 deptno에 따라 부서명으로 변경 해서 다음과 같이 조회되는 쿼리 작성
SELECT *
FROM dept;

SELECT empno, ename, deptno, DECODE(deptno, 
                                    10, 'ACCOUNTING', 
                                    20, 'RESEARCH', 
                                    30, 'SALES', 
                                    40, 'OPERATIONS', 
                                    'DDIT') dname
FROM emp;
       
SELECT ename, job, sal, DECODE(job, 'SALESMAN', sal * 1.05, 
                                    'MANAGER', sal * 1.10, 
                                    'PRESIDENT', sal * 1.20, 
                                    sal * 1) bouns
FROM emp;


위의 문제처럼 job에 따라 sal를 인상을 한다
단 추가조건으로 job이 MANAGER이면서 소속부서가(deptno)가 30(SALES)이면 sal * 1.5

CASE로 우선 풀어보자
SELECT ename, job, sal, deptno,
    CASE
        WHEN job = 'SALESMAN' THEN sal * 1.05
        WHEN job = 'MANAGER' AND deptno = 30 THEN sal * 1.5   --순서 중요!! else if 
        WHEN job = 'MANAGER' THEN sal * 1.10
        WHEN job = 'PRESIDENT' THEN sal * 1.20
        ELSE sal       
    END inc_sal    
FROM emp;

SELECT ename, job, sal, deptno,
    CASE
        WHEN job = 'SALESMAN' THEN sal * 1.05
        WHEN job = 'MANAGER' THEN 
                                 CASE     --CASE 중첩가능
                                     WHEN deptno = 30 THEN sal * 1.5
                                     ELSE sal * 1.1
                                 END
        WHEN job = 'PRESIDENT' THEN sal * 1.20
        ELSE sal       
    END inc_sal    
FROM emp;


위의 문제를 DECODE로 변경
SELECT ename, job, sal, deptno,
                    DECODE(job, 
                              'SALESMAN', sal * 1.05,
                              'MANAGER', DECODE(deptno, 30, sal * 1.5, sal * 1.1),
                              'PRESIDENT', sal * 1.20, 
                              sal * 1) bouns
FROM emp;


p.178 실습 cond2
emp 테이블을 이용하여 hiredate에 따라 올해 건강보험 검진
대상자인지 조회하는 쿼리를 작성하세요
(생년을 기준으로 하나 여기서는 입사년도를 기준으로 한다)

해당사원이 홀수년도 입사인지, 짝수년도 입사인지 구분할 수 있는 값
짝수, 홀수 구분??
짝수 ==> 2로 나눴을 때 나머지가 항상 0
홀수 ==> 2로 나눴을 때 나머지가 항상 1

-- ㅠㅠ
SELECT empno, ename, hiredate,  
                      CASE
                        WHEN MOD(TO_CHAR(hiredate, 'YYYY'),2) = 0 THEN '건강검진 대상자'
                        ELSE '건강검진 비대상자'
                      END CONTACT_TO_DOCTOR
FROM emp;

--정답(년도 바뀌는거 적용 안함)
SELECT empno, ename, hiredate, 
        DECODE(MOD(TO_CHAR(hiredate, 'YYYY'), 2),
                        0, '건강검진 대상자',
                        1, '건강검진 비대상자') CONTACT_TO_DOCTOR
FROM emp;

--년도 바뀔 때도 적용  -----------------------
SELECT empno, ename, hiredate, 
        DECODE(MOD(TO_CHAR(hiredate, 'YYYY'), 2),
                          MOD(TO_CHAR(SYSDATE,'YYYY'), 2), '건강검진 대상자',
                          '건강검진 비대상자') CONTACT_TO_DOCTOR
FROM emp;


p.179 실습 cond3
usesrs 테이블을 이용하여 reg_dt에 따라 올해 건강보험 검진
대상자인지 조회하는 쿼리를 작성하세요
(생년을 기준으로 하나 여기서는 reg_dt를 기준으로 한다)

SELECT userid, usernm, reg_dt, 
        MOD(TO_CHAR(reg_dt, 'YYYY'), 2) mod,   -- MOD값 떼서 보기
        DECODE(MOD(TO_CHAR(reg_dt, 'YYYY'), 2),
                           MOD(TO_CHAR(SYSDATE, 'YYYY'), 2), '건강검진 대상자', -- 첫번째(MOD)=두번째(MOD)==>세번째인자
                           '건강검진 비대상자') CONTACT_TO_DOCTOR  --옵션(기준값이 비교값 중에 일치하는 값이 없을 때 기본적으로 반환할 값
FROM users;



-- 행 14개로 만들기

DELETE emp
WHERE empno = 9999;

COMMIT;

SELECT *
FROM emp;



그룹함수 : 여러개의 행을 입력으로 받아서 하나의 행으로 결과를 리턴하는 함수
SUM : 합계
COUNT : 행의 수
AVG : 평균
MAX : 그룹에서 가장 큰 값
MIN : 그룹에서 가장 작은 값

사용방법
SELECT 행들을 묶을 기준1, 행들을 묶을 기준2, 그룹함수
FROM 테이블
[WHERE]
GROUP BY 행들을 묶을 기준1, 행들을 묶을 기준2           --여러개 가능

1. 부서번호별 sal 컬럼의 합
==> 부서번호가 같은 행들을 하나의 행으로 만든다

2. 부서번호별 가장 큰 급여를 받는사람 급여액수      --MAX
3. 부서번호별 가장 작은 급여를 받는사람 급여액수     --MIN
4. 부서번호별 급여 평균액수(반올림 : 2자리까지)
5. 부서번호별 급여가 존재하는 사람의 수(sal 컬럼이 null이 아닌 행의 수)
                                   * : 그 그룹의 행수
 
SELECT deptno, SUM(sal), MAX(sal), MIN(sal), ROUND(AVG(sal), 2), 
       COUNT(sal),
       COUNT(comm),
       COUNT(*)       --일반적
FROM emp
GROUP BY deptno;


그룹함수의 특징 
그룹함수의 특징 1. null값을 무시
30번 부서의 사원 6명중 2명은 comm값이 NULL    --별도로 NULL값을 치환하거나 넣을 필요 없음

SELECT deptno, SUM(comm)
FROM emp
GROUP BY deptno;

그룹함수의 특징 2. GROUP BY를 적용 여러행을 하나의 행으로 묶게 되면은   -- 주의!!!!!!!
                 SELECT 절에 기술할 수 있는 컬럼이 제한됨
                 ==> SELECT 절에 기술되는 일반 컬럼들은 (그룹 함수를 적용하지 않은)
                 반드시 GROUP BY 절에 기술 되어야 한다.
                 * 단 그룹명에 영향을 주지 않는 고정된 상수, 함수는 기술하는 것이 가능하다
        
SELECT deptno, ename, SUM(sal)   --ename 논리적으로 맞지 않음 : 에러 'not a GROUP BY expression'
FROM emp
GROUP BY deptno;

-- 고치기
SELECT deptno, MAX(ename), SUM(sal)  --MAX
FROM emp
GROUP BY deptno;

SELECT deptno, ename, SUM(sal) 
FROM emp
GROUP BY deptno, ename;     --GROUP BY 절에 ename 기술  ==> 14건의 data가 나옴



SELECT deptno, 10, SYSDATE, SUM(sal)    --상수, SYSDATE ==> 그룹명에 영향을 주지 않기 때문에 기술 가능 
FROM emp
GROUP BY deptno;

그룹함수의 특징 3. 일반 함수를 WHERE절에서 사용하는게 가능
                 (WHERE UPPER('smith') = 'SMITH';)
                 그룹함수의 경우 WHERE 절에서 사용하는게 불가능
                 하지만 HAVING 절에 기술하여 동일한 결과를 나타낼 수 있다.   -- GROUP BY 다음에 WHERE 대신에 HAVING

SUM(sal) 값이 9000보다 큰 행들만 조회하고 싶은 경우
SELECT deptno, SUM(sal)
FROM emp
WHERE SUM(sal) > 9000
GROUP BY deptno;        --오류

SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno
HAVING SUM(sal) > 9000;     -- GROUP BY 다음에 WHERE 대신에 HAVING

위의 쿼리를 HAVING절 없이 SQL 생성
힌트 : 과거(6/29) 회상 페이징 처리할 때 ROWNUM 부분

SELECT *
    FROM(SELECT deptno, SUM(sal) sum_sal   --인라인뷰로 만들었으니까 앞에 FROM(
         FROM emp
         GROUP BY deptno)
WHERE sum_sal > 9000;               --컬럼이름을 바꾸고 새로운 테이블이라고 생각하고 사용

과거(6/29) 회상
SELECT *
FROM (SELECT ROWNUM rn, a.*       --안쪽에서 컬럼을 다른이름으로 치환하기
      FROM (SELECT empno, ename
           FROM emp
           ORDER BY ename) a) 
WHERE rn BETWEEN 11 AND 20;       --바깥에서 부여된 별칭을 가지고 조건을 줌


SELECT 쿼리 문법 총정리
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY

GROUP BY 절에 행을 그룹핑할 기준을 작성
EX : 부서번호별로 그룹을 만들경우
     GROUP BY deptno
     
전체행을 기준으로 그룹핑을 하려면 GROUP BY 절에 어떤 컬럼을 기술해야 할까??
emp 테이블에 등록된 14명의 사원 전체의 급여 합계를 구하려면?? ==> 결과는 1개의 행
==> GROUP BY 절을 기술하지 않는다

29025
SELECT SUM(sal)
FROM emp;

SELECT deptno, SUM(sal)             --deptno 추가 : 에러 'not a single-group group function'
FROM emp;

--에러해결
SELECT SUM(sal)            --deptno를 빼거나     
FROM emp;

SELECT deptno, SUM(sal)            
FROM emp
GROUP BY deptno;          --GROUP BY 추가

GROUP BY절에 기술한 컬럼을 SELECT 절에 기술하지 않은 경우??
SELECT SUM(sal)            
FROM emp
GROUP BY deptno;



그룹함수의 제한사항
부서번호별 가장 높은 급여를 받는 사람의 급여액
그래서 그 사람이 누군데??? (서브쿼리, 분석함수)...........두명일때는???

SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno;


그룹함수 이해하기 힘들다 ==> 엑셀에 데이터를 그려보자