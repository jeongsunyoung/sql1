2p.113 실습 idx4 (과제)
--나의 과제
CREATE UNIQUE INDEX idx_u_emp_01 ON emp (empno);
CREATE UNIQUE INDEX idx_u_dept_02 ON dept (deptno);
CREATE INDEX idx_nu_emp_03 ON emp (deptno, empno, sal);
CREATE INDEX idx_nu_emp_04 ON emp (deptno);


--선생님
emp : 1. empno
      2. deptno, empno, sal
      [2. deptno, empno
       3. deptno,sal]

dept : 1. deptno, loc
       2. loc

1. emp : empno (=) (e.1)
2. dept : deptno (=) (d.1)
3. emp : deptno(=), empno(like)
   dept : deptno (=) (d.1)
4. emp : deptno (=), sal(between)
5. emp : deptno(=)
   dept : deptno(=), [loc(=)] (d.1)

   emp : empno(=) (e.1)
   dept : loc(=) (d.2)
   
   
   
   
개발자가 SQL을 dbms에 요청을 하더라도
1. 오라클 서버가 항상 최적의 실행계획을 선택할 수는 없음
   (응답성이 중요 하기 때문 : OLT - 온라인 트랜잭션 프로세싱(많이 사용)
    전체 처리 시간이 중요   : OLAP -  Online Analytical Processing
                            은행이자 ==> 실행계획 세우는 30분 이상이 소요 되기도 함)
   
2. 항상 실행계획을 세우지 않음
   만약 동일한 SQL이 이미 실행된적이 있으면 해당 SQL의 실행계획을 새롭게 세우지 않고
   Shared pool(메모리)에 존재하는 실행계획을 재사용
   
   동일한 SQL : 문자가 완벽하게 동일한 SQL  --시험에 잘나옴
               SQL의 실행결과가 같다고 해서 동일한 SQL이 아님
               대소문자를 가리고, 공백도 문자로 취급
    EX : SELECT * FROM emp;
         select * FROM emp; 두개의 sql이 서로 다른 sql로 인식

SYSTEM 계정에서 조회
SELECT *
FROM v$sql
WHERE sql_text LIKE '%plan_test%';


SELECT /* plan_test */ *        
FROM emp
WHERE empno = 7698;

select /* plan_test */ *        
FROM emp
WHERE empno = 7698;
         
select /* plan_test */ *        
FROM emp
WHERE empno = 7369; 
--결과 또 조회
   
select /* plan_test */ *        
FROM emp
WHERE empno = :empno;   
--바인드 변수를 사용하는 이유(다른값을 조회해도 한 번만 나옴)



실행계획 PPT
INDEX JOIN
 nested
 hash
 sort merge



DCL : Data Control Language - 시스템 권한 또는 객체 권한을 부여 / 회수

부여
GRANT 권한명 | 롤명 TO 사용자;

회수
REVOKE 권한명 | 롤명 FROM 사용자;



DATA DICTIONARY
오라클 서버가 사용자 정보를 관리하기 위해 저장한 데이터를 볼 수 있는 view

CATEGORY(접두어)
USER_ : 해당 사용자가 소유한 객체 조회
ALL_ : 해당 사용자가 소유한 객체 + 권한을 부여받은 객체 조회
DBA_ : 데이터베이스에 설치된 모든 객체(DBA 권한이 있는 사용자만 가능-SYSTEM)
v$ : 성능, 모니터와 관련된 특수 view

SELECT COUNT(*)
FROM dictionary;

SELECT *
FROM dictionary;
   
SELECT *
FROM user_tables;  

SELECT *
FROM all_tables;  
   
SELECT *
FROM dba_tables;     
-- able or view does not exist  ==> 시스템 계정에서 조회 가능
   
   
   
   
   
   
   
   
   
   
   