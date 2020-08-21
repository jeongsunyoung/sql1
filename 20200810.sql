
프로시저명 : avgdt

CREATE TABLE dt AS
SELECT SYSDATE dt FROM dual UNION ALL
SELECT SYSDATE - 5 FROM dual UNION ALL
SELECT SYSDATE - 10 FROM dual UNION ALL
SELECT SYSDATE - 15 FROM dual UNION ALL
SELECT SYSDATE - 20 FROM dual UNION ALL
SELECT SYSDATE - 25 FROM dual UNION ALL
SELECT SYSDATE - 30 FROM dual UNION ALL
SELECT SYSDATE - 35 FROM dual;

SELECT *
FROM dt;

****************************************************************
		psuedo code(가상 코드, 의사 코드)
		int diffSum = 0;
		for(int i = 0; i+1 < numberList.length; i++){
			diffSum += numberList[i] - numberList[i+1];
		}
		System.out.println("average : " + diffSum / (numberList.length-1) );

		LOOP : i+1이 주어진 배열의 인덱스와 같아 질 때 까지
			1] i, i+1번째 인덱스의 값을 가져온다
			2] i번과 i+1번의 값을 뺀다 : 간격의 값
			3] 간격의 값을 변수에 더해준다
		END LOOP

		간격의 합, 간격의 개수 ==> 간격의합/간격의 개수
****************************************************************


여러행의 데이터를 가져오는 방법 2가지
1. 테이블 타입 변수에 우리가 필요로 하는 전체 테이블의 데이터를 전부 담아서 처리
2. cursor : 선언 - open - fetch 1건씩 - close

SET SERVEROUTPUT ON;

 CREATE OR REPLACE PROCEDURE avgdt IS
    TYPE t_dt IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dt t_dt;
 BEGIN
    SELECT * BULK COLLECT INTO v_dt
    FROM dt;
    
    FOR i IN 1..v_dt.count LOOP
        DBMS_OUTPUT.PUT_LINE(v_dt(i).dt);   --i번째 행에 dt라는 컬럼을 가져와서 실행
    END LOOP;
 END;
 
EXEC avgdt;


--차이의 합계
 CREATE OR REPLACE PROCEDURE avgdt IS
    TYPE t_dt IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dt t_dt;
    v_diffSum NUMBER := 0;
 BEGIN
    SELECT * BULK COLLECT INTO v_dt
    FROM dt;
    
    FOR i IN 1..v_dt.count-1 LOOP
--		LOOP : i+1이 주어진 배열의 인덱스와 같아 질 때 까지
--		    1] i, i+1번째 인덱스의 값을 가져온다
--		    2] i번과 i+1번의 값을 뺀다 : 간격의 값
--		    3] 간격의 값을 변수에 더해준다
--		END LOOP
        v_diffSum := v_diffSum + v_dt(i).dt - v_dt(i+1).dt;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('v_diffSum : ' || v_diffSum);
 END;

EXEC avgdt;


--간격의 평균
 CREATE OR REPLACE PROCEDURE avgdt IS
    TYPE t_dt IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dt t_dt;
    v_diffSum NUMBER := 0;
 BEGIN
    SELECT * BULK COLLECT INTO v_dt
    FROM dt;
    
    FOR i IN 1..v_dt.count-1 LOOP
        v_diffSum := v_diffSum + v_dt(i).dt - v_dt(i+1).dt;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE( v_diffSum / (v_dt.count-1) );
 END;

EXEC avgdt;



--분석함수를 이용하여 lead_dt, diff 컬럼 생성
SELECT dt, LEAD(dt) OVER (ORDER BY dt DESC) lead_dt,
       dt - LEAD(dt) OVER (ORDER BY dt DESC) diff
FROM dt;


--diff의 평균 구하기 (인라인뷰 사용)
SELECT AVG(diff)
FROM
    (SELECT dt - LEAD(dt) OVER (ORDER BY dt DESC) diff
     FROM dt);

--최대값, 최소값, 간격의개수
SELECT MAX(dt), MIN(dt), MAX(dt) - MIN(dt) diff, (MAX(dt) - MIN(dt)) / (COUNT(*)-1) avg
FROM dt;


--랜덤
SELECT *
FROM dt
ORDER BY DBMS_RANDOM.VALUE;



PL/SQL function : java method
정해진 작업을 한다음 결과를 돌려주는 PL/SQL block
문법
CREATE [OR REPLACE] FUNCTION 함수명 [(파라미터)] RETURN TYPE IS
BEGIN
END;
/
RETURN TYPE 명시할 때 SIZE 정보는 명시하지 않음
VARCHAR2(2000) X ==> VARCHAR2


사번을 입력 받아서(파라미터) 해당 사원의 이름을 반환하는 함수 getEmpName 생성
function1]
CREATE OR REPLACE FUNCTION getEmpName ( p_empno emp.empno%TYPE ) RETURN VARCHAR2 IS
    v_ename emp.ename%TYPE;   --변수 선언
BEGIN
    SELECT ename INTO v_ename
    FROM emp
    WHERE empno = p_empno;
    
    RETURN v_ename;
END;
/

SELECT empno, getEmpName(empno)
FROM emp;


function2]
function : getdeptname 작성
파라미터 : 부서번호
리턴값 : 파라미터로 들어온 부서번호의 부서이름

CREATE OR REPLACE FUNCTION getDeptName ( p_deptno dept.deptno%TYPE ) RETURN VARCHAR2 IS
    v_dname dept.dname%TYPE;   --변수 선언
BEGIN
    SELECT dname INTO v_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    RETURN v_dname;
END;
/

SELECT empno, deptno, getdeptname(deptno)
FROM emp;



package 패키지 : 연관된 PL/SQL 블럭을 관리하는 객체
대표적인 오라클 내장 패키지 : DBMS_OUTPUT.

package 생성 단계는 2단계로 나누어 생성
1. 선언부          : interface
CREATE OR REPLACE PACKAGE 패키지명 AS 
    FUNCTION 함수이름 (인자) RETURN 반환타입;
END 패키지명;
/

2. body(구현부)    : class
CREATE OR REPLACE PACKAGE BODY names AS
    FUNCTION 함수이름 (인자) RETURN 반환타입 IS
        --선언부
    BEGIN
        --실행부
        RETURN
    END;
END;
/


getempname, getdeptname
names라는 이름의 패키지를 생성하여 등록

1. 패키지 선언부 생성
CREATE OR REPLACE PACKAGE names AS
    FUNCTION getempname (p_empno emp.empno%TYPE) RETURN VARCHAR2;
    FUNCTION getdeptname (p_deptno dept.deptno%TYPE) RETURN VARCHAR2;
END names;
/

2. 패키지 바디 생성
CREATE OR REPLACE PACKAGE BODY names AS

    FUNCTION getEmpName ( p_empno emp.empno%TYPE ) RETURN VARCHAR2 IS
        v_ename emp.ename%TYPE;
    BEGIN
        SELECT ename INTO v_ename
        FROM emp
        WHERE empno = p_empno;
    
        RETURN v_ename;
    END;
    
    FUNCTION getDeptName ( p_deptno dept.deptno%TYPE ) RETURN VARCHAR2 IS
        v_dname dept.dname%TYPE;   --변수 선언
    BEGIN
        SELECT dname INTO v_dname
        FROM dept
        WHERE deptno = p_deptno;
    
        RETURN v_dname;
    END;
    
END;
/

--만들어진 NAMES. 패키지 사용
SELECT NAMES.GETDEPTNAME(deptno)
FROM emp;



TRIGGER : 방아쇠
이벤트 핸들러 : 이벤트를 다루는 녀석

web : 클릭, 스크롤링, 키입력
dbms : 특정 테이블에 데이터 신규입력, 기존 데이터 변경, 기존 데이터 삭제
        ==> 후속작업
        
트리거 : 설정한 이벤트에 따라 자동으로 실행되는 PL/SQL 블럭
        이벤트 종류 : 데이터 신규입력, 기존 데이터 삭제, 기존 데이터 변경

시나리오 : users 테이블의 pass 컬럼(비밀번호)이 존재
         특정 쿼리에 의해 users테이블의 pass 컬럼이 변경이 되면
         users_history 테이블에 변경 전 pass 값을 트리거를 통해 저장

SELECT *
FROM users;

1. users_history 테이블 생성
CREATE TABLE users_history AS
    SELECT userid, pass, sysdate reg_dt
    FROM users
    WHERE 1 = 2;

DESC users_history;

SELECT *
FROM users_history;

users 테이블의 변경을 감지하여 실행할 트리거를 생성
감지 항목 : users 테이블의 pass 컬럼이 변경이 되었을 때
감지 시 실행 로직 : 변경 전 pass 값을 users_history에 저장

문법
CREATE OR REPLACE TRIGGER make_history --트리거명
    BEFORE UPDATE ON users  --실행 시점 users 테이블을 변경하기 전에 실행. AFTER도 가능
    FOR EACH ROW  --행이 바뀔 때 마다 실행을 하겠다
    
    BEGIN
        --users 테이블의 특정 행이 update가 되었을 경우 실행
        --:OLD.컬럼명 ==> 기존 값
        --:NEW.컬럼명 ==> 갱신 값
        IF :OLD.pass != :NEW.pass THEN
            --userid, pass, reg_dt
            INSERT INTO users_history VALUES (:OLD.userid, :OLD.pass, SYSDATE);
        END IF;
    END;
    /
    
SELECT *
FROM users;


트리거와 무관한 컬럼을 변경할 시 테스트
UPDATE users SET usernm = 'brown'
WHERE userid = 'brown';

SELECT *
FROM users_history;
--users_history 테이블 수정 안됨


트리거와 관련된 컬럼을 변경할 시 테스트
UPDATE users SET pass = '1234'
WHERE userid = 'brown';

SELECT *
FROM users_history;
--users 테이블을 변경했는데 트리거에 의해서 users_history 테이블이 수정됨

SELECT *
FROM users;


실무
신규개발 : 좋아함
            자바코드 안써도 되기 때문에 빨리 개발하는 것이 가능
유지보수 : 안좋아함
            유지보수적인 면에서는 문서화가 잘 안되어 있을 경우 코드 동작에 대한 이해가 힘들어짐



예외 : EXCEPTION 
        JAVA : exception, error
                - checked exception : 반드시 예외처리를 해야하는 예외
                - unchecked exception : 예외처리를 안해도 되는 예외
        
PL/SQL : PL/SQL 블럭이 실행되는 동안 발생한 에러
예외의 종류
1. 사전 정의 예외 (predefined oracle exception)
    . java ARITHMATIC EXCEPTION
    . 오라클이 사전에 정의한 상황에서 발생하는 예외

2. 사용자 정의 예외
    . 변수, 커서처럼 PL/SQL 블럭의 선언부에 개발자가 직접 선언한 예외
      RAISE 키워드를 통해 개발자가 직접 예외를 던진다
      (java : throw new RuntimeException();)
      
PL/SQL 블럭에서 예외가 발생하면...
예외가 발생된 지점에서 코드 중단(에러)

단, PL/SQL 블럭에서 예외처리 부분이 존재하면 (EXCEPTION 절)
EXCEPTION 절에 기술한 코드가 실행




