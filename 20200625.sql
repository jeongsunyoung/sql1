
expression : 컬럼값을 가공을 하거나, 존재하지 않는 새로운 상수값(정해진 값)을 표현
             연산을 통해 새로운 칼럼을 조회할 수 있다.
             연산을 하더라도 해당 SQL 조회 결과에만 나올 뿐이고 실제 테이블의 데이터에는
             영향을 주지 않는다.
             SELECT 구문은 테이블의 데이터에 영향을 주지 않음;
SELECT sal, sal + 500, sal - 500, sal/5, sal*5, 500
FROM emp;

SELECT *
FROM emp;

SELECT *
FROM dept;

날짜에 사칙연산 : 수학적으로 정의가 되어 있지 않음
SQL에서는 날짜데이터 +- 정수 ==> 정수를 일자 취급
'2020년 6월 25일' + 5 : 2020년 6월 25일부터 5일 지난 날짜
'2020년 6월 25일' - 5 : 2020년 6월 25일부터 5일 이전 날짜

데이터 베이스에서 주로 사용하는 데이터 타입 : 문자, 숫자, 날짜
empno : 숫자
ename : 문자
job : 문자
mgr : 숫자
hiredate : 날짜
sal : 숫자
comm : 숫자
deptno : 숫자

테이블의 컬럼구성 정보 확인 :
DESC 테이블명 (DESCRIBE 테이블명)

DESC emp;
(제약조건 : NOT NULL : NULL이 될 수 없다)
(VARCHAR2 : 문자, (10) : 10byte, (7,2) : 소수점)

SELECT hiredate, hiredate + 5, hiredate - 5
FROM emp;

* users 테이블의 컬럼, 타입을 확인하고
  reg_dt 컬럼 값에 5일 뒤 날짜를 새로운 컬럼으로 표현
  조회 컬럼 : userid, reg_dt, reg_dt의 5일 뒤 날짜

DESC users;

SELECT userid, reg_dt, reg_dt+5
FROM users;



NULL : 아직 모르는 값, 할당되지 않은 값
NULL과 숫자타입의 0은 다르다
NULL과 문자타입의 공백은 다르다

NULL의 중요한 특징
NULL을 피연산자로 하는 연산의 결과는 항상 NULL
EX: NULL + 500 = NULL

emp테이블에서 sal 컬럼과 comm컬럼의 합을 새로운 컬럼으로 표현
조회 컬럼 : emp, ename, sal, comm, sal, sal 컬럼과 comm컬럼의 합

ALIAS : 컬럼이나, EXPRESSION에 새로운 이름을 부여
적용 방법 : 컬럼, EXPRESSION에 [AS] 별칭명
별칭을 소문자로 적용 하고 싶은 경우, 공백을 넣고 싶은 경우 : 별칭명을 더블 쿼테이션으로 묶는다

SELECT empno, ename, sal s, 
       comm AS "commition", 
       sal + comm AS sal_plus_comm,
       sal + comm AS "sal plus comm"
FROM emp;


columm alias (실습 select2)
1. prod 테이블에서 prod_id, prod_name 두 컬럼을 조회하는 쿼리를 작성하시오.
   (단 prod_id -> id, prod_name -> name 으로 컬럼 별칭을 지정)
SELECT prod_id id, prod_name name
FROM prod;

2. lprod 테이블에서 lprod_gu, lprod_nm 두 컬럼을 조회하는 쿼리를 작성하시오.
   (단 lprod_gu -> gu, lprod_nm -> nm 으로 컬럼 별칭을 지정)
SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

3. buyer 테이블에서 buyer_id, buyer_name 두 컬럼을 조회하는 쿼리를 작성하시오.
    (단 buyer_id -> 바이어아이디, buyer_name -> 이름 으로 컬럼 별칭을 지정)
SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;


literal : 값 자체
literal 표기법 : 값을 표현하는 방법
ex : test 라는 문자열을 표기하는 방법
java : System.out.pirntln("test") , java에서는 더블 쿼테이션으로 문자열을 표기한다
       System.out.pirntln('test') 싱글 쿼테이션으로 표기하면 에러
SQL : 'test', sql에서는 싱글 쿼테이션으로 문자열을 표기

번외
int small = 10;
java 대입 연산자 :   =
pl/sql 대입 연산자 : :=

언어마다 연산자 표기, literal 표기법이 다르기 때문에 언어에서 지정하는 방식을 잘 따라야 한다

문자열 연산 : 결합
일상생활에서 문자열 결합 연산자가 존재??
java에서 문자열 결합 연산자 : +
sql에서 문자열 결합 연산자 : ||
sql에서 문자열 결합 함수 : CONCAT(문자열1, 문자열2) ==> 문자열1||문자열2
                        두개의 문자열을 인자로 받아서 결합결과를 리턴

USERS테이블의 userid 컬럼과 usernm 컬럼
SELECT userid, usernm, userid || usernm id_name, CONCAT(userid, usernm) concat_id_name
FROM users;

임의 문자열 결합 ( sal+500, '아이디 :' || userid)

SELECT '아이디 : ' || userid, 500, 'test'
FROM users;

p.67 실습 sel_con1
SELECT 'SELECT * FROM ' || TABLE_NAME || ';'
FROM user_tables;

CONCAT 함수만 이용해서
SELECT CONCAT(CONCAT('SELECT * FROM ', TABLE_NAME), ';' )
FROM user_tables;

보통 결합연산자(||)를 많이 사용



WHERE : 테이블에서 조회할 행의 조건을 기술(필터)
        WHERE 절에 기술한 조건이 참일 때 해당 행을 조회한다(*)
        SQL에서 가장 어려운 부분, 많은 응용이 발생하는 부분
        
SELECT *
FROM users
WHERE userid = 'brown';

emp 테이블에서 deptno 컬럼의 값이 30보다 크거나 같은 행을 조회, 컬럼은 모든 컬럼
SELECT *
FROM emp
WHERE deptno >= 30;

emp 총 행수 : 14  (컬럼이랑 비교하지 않아도 된다. 참인지 거짓인지 논리성만 생각하면 된다)
SELECT *
FROM emp
WHERE 1 = 1;    (참)
WHERE 1 = 2;    (거짓)


DATE 타입에 따른 WHERE절 조건 기술
emp 테이블에서 hiredate 값이 1982년 1월 1일 이후인 사원들만 조회

SQL 에서 DATE 리터럴 표기법 : 'RR/MM/DD'
단 서버 설정마다 표기법이 다르다
한국 : YY/MM/DD
미국 : MM/DD/YY

'12/11/01' ==> 국가별로 다르게 해석이 가능하기 때문에 DATE 리터럴 보다는
문자열을 DATE 타입으로 변경해주는 함수를 주로 사용
TO_DATE('날짜문자열','첫번째 인자의 형식')

DATE 리터럴 표기법으로 실행한 SQL
SELECT *
FROM emp
WHERE hiredate >= '82/01/01';

단위 확인
SELECT *
FROM NLS_SESSION_PARAMETERS;

TO_DATE를 통해 문자열을 DATE 타입으로 변경후 실행
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');


BETWEEN AND : 두 값 사이에 위치한 값을 참으로 인식
사용방법 : 비교값 BETWEEN 시작값 AND 종료값
비교값이 시작값과 종료값을 포함하여 사이에 있으면 참으로 인식

emp테이블에서 sal 값이 1000보다 크거나 같고 2000보다 작거나 같은 사원들만(행들만) 조회

SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

sal BETWEEN 1000 AND 2000 조건을 부등호로 나타내면(>=, <=, >, <)?

SELECT *
FROM emp
WHERE sal >= 1000 
  AND sal <= 2000;


p.82 실습 where1
emp 테이블에서 입사 일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전인 사원의
ename, hiredate 데이터를 조회하는 쿼리를 작성하시오(단 연산자는 between을 사용한다)
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101','YYYYMMDD') AND TO_DATE('19830101','YYYYMMDD');

p.83 실습 where2
emp 테이블에서 입사 일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전인 사원의
ename, hiredate 데이터를 조회하는 쿼리를 작성하시오(단 연산자는 비교연산자를 사용한다)
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101','YYYYMMDD') 
  AND hiredate <= TO_DATE('19830101','YYYYMMDD');


IN 연산자 : 비교값이 나열된 값에 포함될 때 참으로 인식
사용방법 : 비교값 IN (비교대상 값1, 비교대상 값2, 비교대상 값3)
 
사원의 소속 부서가 10번 혹은 20번인 사원을 조회하는 SQL을 IN 연산자로 작성
SELECT *
FROM emp
WHERE deptno IN (10, 20);

SELECT *
FROM emp
WHERE 10 IN (10, 20);

IN연산자를 사용하지 않고 OR 연산(논리 연산)을 통해서도 동일한 결과를 조회하는 SQL 작성 가능
SELECT *
FROM emp
WHERE deptno = 10
   OR deptno = 20;

AND로는??
SELECT *
FROM emp
WHERE deptno = 10
  AND deptno = 20;
-> 값 안나옴
WHERE 20 = 10
  AND 20 = 20;

SQL에서는 키워드는 대소문자를 가리지 않는다.
데이터는 대소문자를 가린다.

p.85 실습 where3 (과제)
SELECT userid 아이디, usernm 이름, alias AS 별명
FROM users
WHERE userid IN ('brown', 'cony', 'sally');



