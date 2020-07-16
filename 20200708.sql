
1. GROUP BY (여러개의 행을 하나의 행으로 묶는 행위)
2. JOIN
3. 서브쿼리
    1. 사용위치
    2. 반환하는 행, 컬럼의 개수
    3. 상호연관 / 비상호연관
        -> 메인쿼리의 컬럼을 서브쿼리에서 사용하는지(참조하는지) 유무에 따른 분류
        : 비상호연관 서브쿼리의 경우 단독으로 실행 가능 (실행순서 정해져 있지 않음)
        : 상호연관 서브쿼리의 경우 실행하기 위해서 메인쿼리의 컬럼을 사용하기 때문에
          단독으로 실행이 불가능 (실행순서 정해져있음: 메인쿼리->서브쿼리)
          
sub2 : 사원들의 급여평균보다 높은 급여를 받는 직원

SELECT *                  --메인쿼리
FROM emp
WHERE sal > (SELECT AVG(sal)   --서브쿼리에서 메인쿼리 사용X -> 비상호연관
             FROM emp);
            
사원이 속한 부서의 급여 평균보다 높은 급여를 받는 사원 정보 조회
(참고, 스칼라 서브쿼리를 이용해서 해당 사원이 속한 부서의
       부서이름을 가져오도록 작성 해봄)
       
전체사원의 정보를 조회, 조인 없이 해당 사원이 속한 부서의 부서이름 가져오기
SELECT empno, ename, deptno, 부서명
FROM emp;

SELECT empno, ename, deptno, 
       (SELECT dname FROM dept WHERE deptno = emp.deptno) --스칼라: ()안에 deptno컬럼을 사용할 수 있다(상호연관:단독실행x)
FROM emp;


SELECT empno, ename, deptno, 
       (SELECT dname FROM dept WHERE deptno = emp.deptno)  
FROM emp
WHERE sal > 2073;

각각 부서
SELECT AVG(sal)
FROM emp
WHERE deptno = 10;

SELECT AVG(sal)
FROM emp
WHERE deptno = 20;

SELECT empno, ename, deptno, sal,
       (SELECT dname FROM dept WHERE deptno = emp.deptno) dname
FROM emp
WHERE sal > (SELECT AVG(sal) 
             FROM emp
             WHERE deptno = :deptno);

SELECT empno, ename, deptno, sal,
       (SELECT dname FROM dept WHERE deptno = emp.deptno) dname
FROM emp
WHERE sal > (SELECT AVG(sal) 
             FROM emp
             WHERE deptno = (SELECT deptno            
                            FROM emp
                            WHERE ename = :dname));
                            
                            
--요거                            
SELECT *
FROM emp 
WHERE sal > (SELECT AVG(sal) 
             FROM emp
             WHERE deptno = emp.deptno);   --emp.deptno 부서번호,,,  1 = 1  항상 참 ==>전체직원의 급여평균을 구함

SELECT *
FROM emp e
WHERE sal > (SELECT AVG(sal) 
             FROM emp s
             WHERE s.deptno = e.deptno);  --상호연관(실행순서 정해져있음, 메인쿼리의 컬럼을 가져다 씀) 메인쿼리 실행 후 서브쿼리 실행
             
             
p.268 실습 sub3
SMITH와 WARD사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리 작성
SMITH : 20, WARD : 30

SELECT *
FROM emp 
WHERE deptno IN (20, 30);        --하드코딩

단일 값비교는 =
복수행(단일컬럼) 비교는 IN

SELECT *
FROM emp 
WHERE deptno IN (SELECT deptno              --왼쪽: 단일값, 오른쪽: 단일값 ==> 단일값끼리 비교
                 FROM emp                   -- (=) 비교는 단일값 - 서브쿼리의 결과가 2개 행 ==> X
                 WHERE ename IN ('SMITH', 'WARD') );
                 

** IN, NOT IN 이용시 NULL값의 존재 유무에 따라 원하지 않는 결과가 나올수 도 있다
NULL 과 IN, NULL과 NOT IN
IN ==> OR
NOT IN ==> AND

WHERE mgr IN (7902, null)
==> mgr = 7902 OR mgr = null
==> mgr값이 7902 이거나 (mgr 값이 null인 데이터)   --앞에서 참 => 참
SELECT *
FROM emp
WHERE mgr IN (7902, NULL);

WHERE mgr NOT IN (7902, null)
==> NOT (mgr = 7902 OR mgr = null)
==> mgr != 7902 AND mgr != null
SELECT *
FROM emp
WHERE mgr NOT IN (7902, null);            --결과 안나온다
             

pairwise, non-pairwise

한행의 컬럼 값을 하나씩 비교하는 것 : non-pairwise
SELECT *
FROM emp
WHERE job IN ('MANAGER', 'CLERK');

한행의 복수 컬럼을 비교하는 것 : pairwise
7698, 30
7839, 10

SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));          --pairwise : 6건

SELECT *
FROM emp  
WHERE mgr IN (SELECT mgr
              FROM emp
              WHERE empno IN (7499, 7782))
  AND deptno IN (SELECT deptno
                FROM emp
                WHERE empno IN (7499, 7782) );                  --non-pairwise : 7건  (BLAKE 추가)

pairwise                        
7698, 30
7839, 10
non-pairwise
7698, 30
7698, 10
7839, 30
7839, 10
-- 경우의 수 같은 문제
                
                        
p.281 실습 sub4
dept 테이블에는 신규 등록된 99번 부서에 속한 사람은 없음
직원이 속하지 않은 부서를 조회하는 쿼리 작성

INSERT INTO dept VALUES (99, 'ddit', 'daejeon');

SELECT *
FROM dept
WHERE deptno 10번이 아니고 20번이 아니고 30번이 아닌거;

SELECT *
FROM dept
WHERE deptno가 emp 테이블에 등록된 사원들이 소속된 부서가 아닌것;
WHERE deptno != 10 AND deptno != 20 AND deptno != 30;
WHERE deptno NOT IN (10, 20, 30);

--서브쿼리 만들기
SELECT deptno
FROM emp;     --여러개의 행

   --여러개의 행을 중복을 없애기
SELECT deptno
FROM emp
GROUP BY deptno;  

답1.
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                    FROM emp
                    GROUP BY deptno);

답2. -- (10,20,30,20,10..) OR 임 -> GROUP BY 안해도 값이 동일하다
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                    FROM emp);
                    

p.281 실습 sub5
cycle, product 테이블을 이용하여 
cid=1인 고객이 애음하지 않는 제품을 조회하는 쿼리 작성
-- 식
SELECT *
FROM product
WHERE ;

-- 1번 고객이 먹는 제품
SELECT pid
FROM cycle
WHERE cid = 1;

--하드코딩
SELECT *
FROM product
WHERE pid NOT IN (100, 400, 400, 100);

--답
SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);


