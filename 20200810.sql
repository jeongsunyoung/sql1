
���ν����� : avgdt

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
		psuedo code(���� �ڵ�, �ǻ� �ڵ�)
		int diffSum = 0;
		for(int i = 0; i+1 < numberList.length; i++){
			diffSum += numberList[i] - numberList[i+1];
		}
		System.out.println("average : " + diffSum / (numberList.length-1) );

		LOOP : i+1�� �־��� �迭�� �ε����� ���� �� �� ����
			1] i, i+1��° �ε����� ���� �����´�
			2] i���� i+1���� ���� ���� : ������ ��
			3] ������ ���� ������ �����ش�
		END LOOP

		������ ��, ������ ���� ==> ��������/������ ����
****************************************************************


�������� �����͸� �������� ��� 2����
1. ���̺� Ÿ�� ������ �츮�� �ʿ�� �ϴ� ��ü ���̺��� �����͸� ���� ��Ƽ� ó��
2. cursor : ���� - open - fetch 1�Ǿ� - close

SET SERVEROUTPUT ON;

 CREATE OR REPLACE PROCEDURE avgdt IS
    TYPE t_dt IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dt t_dt;
 BEGIN
    SELECT * BULK COLLECT INTO v_dt
    FROM dt;
    
    FOR i IN 1..v_dt.count LOOP
        DBMS_OUTPUT.PUT_LINE(v_dt(i).dt);   --i��° �࿡ dt��� �÷��� �����ͼ� ����
    END LOOP;
 END;
 
EXEC avgdt;


--������ �հ�
 CREATE OR REPLACE PROCEDURE avgdt IS
    TYPE t_dt IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dt t_dt;
    v_diffSum NUMBER := 0;
 BEGIN
    SELECT * BULK COLLECT INTO v_dt
    FROM dt;
    
    FOR i IN 1..v_dt.count-1 LOOP
--		LOOP : i+1�� �־��� �迭�� �ε����� ���� �� �� ����
--		    1] i, i+1��° �ε����� ���� �����´�
--		    2] i���� i+1���� ���� ���� : ������ ��
--		    3] ������ ���� ������ �����ش�
--		END LOOP
        v_diffSum := v_diffSum + v_dt(i).dt - v_dt(i+1).dt;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('v_diffSum : ' || v_diffSum);
 END;

EXEC avgdt;


--������ ���
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



--�м��Լ��� �̿��Ͽ� lead_dt, diff �÷� ����
SELECT dt, LEAD(dt) OVER (ORDER BY dt DESC) lead_dt,
       dt - LEAD(dt) OVER (ORDER BY dt DESC) diff
FROM dt;


--diff�� ��� ���ϱ� (�ζ��κ� ���)
SELECT AVG(diff)
FROM
    (SELECT dt - LEAD(dt) OVER (ORDER BY dt DESC) diff
     FROM dt);

--�ִ밪, �ּҰ�, �����ǰ���
SELECT MAX(dt), MIN(dt), MAX(dt) - MIN(dt) diff, (MAX(dt) - MIN(dt)) / (COUNT(*)-1) avg
FROM dt;


--����
SELECT *
FROM dt
ORDER BY DBMS_RANDOM.VALUE;



PL/SQL function : java method
������ �۾��� �Ѵ��� ����� �����ִ� PL/SQL block
����
CREATE [OR REPLACE] FUNCTION �Լ��� [(�Ķ����)] RETURN TYPE IS
BEGIN
END;
/
RETURN TYPE ����� �� SIZE ������ ������� ����
VARCHAR2(2000) X ==> VARCHAR2


����� �Է� �޾Ƽ�(�Ķ����) �ش� ����� �̸��� ��ȯ�ϴ� �Լ� getEmpName ����
function1]
CREATE OR REPLACE FUNCTION getEmpName ( p_empno emp.empno%TYPE ) RETURN VARCHAR2 IS
    v_ename emp.ename%TYPE;   --���� ����
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
function : getdeptname �ۼ�
�Ķ���� : �μ���ȣ
���ϰ� : �Ķ���ͷ� ���� �μ���ȣ�� �μ��̸�

CREATE OR REPLACE FUNCTION getDeptName ( p_deptno dept.deptno%TYPE ) RETURN VARCHAR2 IS
    v_dname dept.dname%TYPE;   --���� ����
BEGIN
    SELECT dname INTO v_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    RETURN v_dname;
END;
/

SELECT empno, deptno, getdeptname(deptno)
FROM emp;



package ��Ű�� : ������ PL/SQL ���� �����ϴ� ��ü
��ǥ���� ����Ŭ ���� ��Ű�� : DBMS_OUTPUT.

package ���� �ܰ�� 2�ܰ�� ������ ����
1. �����          : interface
CREATE OR REPLACE PACKAGE ��Ű���� AS 
    FUNCTION �Լ��̸� (����) RETURN ��ȯŸ��;
END ��Ű����;
/

2. body(������)    : class
CREATE OR REPLACE PACKAGE BODY names AS
    FUNCTION �Լ��̸� (����) RETURN ��ȯŸ�� IS
        --�����
    BEGIN
        --�����
        RETURN
    END;
END;
/


getempname, getdeptname
names��� �̸��� ��Ű���� �����Ͽ� ���

1. ��Ű�� ����� ����
CREATE OR REPLACE PACKAGE names AS
    FUNCTION getempname (p_empno emp.empno%TYPE) RETURN VARCHAR2;
    FUNCTION getdeptname (p_deptno dept.deptno%TYPE) RETURN VARCHAR2;
END names;
/

2. ��Ű�� �ٵ� ����
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
        v_dname dept.dname%TYPE;   --���� ����
    BEGIN
        SELECT dname INTO v_dname
        FROM dept
        WHERE deptno = p_deptno;
    
        RETURN v_dname;
    END;
    
END;
/

--������� NAMES. ��Ű�� ���
SELECT NAMES.GETDEPTNAME(deptno)
FROM emp;



TRIGGER : ��Ƽ�
�̺�Ʈ �ڵ鷯 : �̺�Ʈ�� �ٷ�� �༮

web : Ŭ��, ��ũ�Ѹ�, Ű�Է�
dbms : Ư�� ���̺� ������ �ű��Է�, ���� ������ ����, ���� ������ ����
        ==> �ļ��۾�
        
Ʈ���� : ������ �̺�Ʈ�� ���� �ڵ����� ����Ǵ� PL/SQL ��
        �̺�Ʈ ���� : ������ �ű��Է�, ���� ������ ����, ���� ������ ����

�ó����� : users ���̺��� pass �÷�(��й�ȣ)�� ����
         Ư�� ������ ���� users���̺��� pass �÷��� ������ �Ǹ�
         users_history ���̺� ���� �� pass ���� Ʈ���Ÿ� ���� ����

SELECT *
FROM users;

1. users_history ���̺� ����
CREATE TABLE users_history AS
    SELECT userid, pass, sysdate reg_dt
    FROM users
    WHERE 1 = 2;

DESC users_history;

SELECT *
FROM users_history;

users ���̺��� ������ �����Ͽ� ������ Ʈ���Ÿ� ����
���� �׸� : users ���̺��� pass �÷��� ������ �Ǿ��� ��
���� �� ���� ���� : ���� �� pass ���� users_history�� ����

����
CREATE OR REPLACE TRIGGER make_history --Ʈ���Ÿ�
    BEFORE UPDATE ON users  --���� ���� users ���̺��� �����ϱ� ���� ����. AFTER�� ����
    FOR EACH ROW  --���� �ٲ� �� ���� ������ �ϰڴ�
    
    BEGIN
        --users ���̺��� Ư�� ���� update�� �Ǿ��� ��� ����
        --:OLD.�÷��� ==> ���� ��
        --:NEW.�÷��� ==> ���� ��
        IF :OLD.pass != :NEW.pass THEN
            --userid, pass, reg_dt
            INSERT INTO users_history VALUES (:OLD.userid, :OLD.pass, SYSDATE);
        END IF;
    END;
    /
    
SELECT *
FROM users;


Ʈ���ſ� ������ �÷��� ������ �� �׽�Ʈ
UPDATE users SET usernm = 'brown'
WHERE userid = 'brown';

SELECT *
FROM users_history;
--users_history ���̺� ���� �ȵ�


Ʈ���ſ� ���õ� �÷��� ������ �� �׽�Ʈ
UPDATE users SET pass = '1234'
WHERE userid = 'brown';

SELECT *
FROM users_history;
--users ���̺��� �����ߴµ� Ʈ���ſ� ���ؼ� users_history ���̺��� ������

SELECT *
FROM users;


�ǹ�
�ű԰��� : ������
            �ڹ��ڵ� �Ƚᵵ �Ǳ� ������ ���� �����ϴ� ���� ����
�������� : ��������
            ������������ �鿡���� ����ȭ�� �� �ȵǾ� ���� ��� �ڵ� ���ۿ� ���� ���ذ� �������



���� : EXCEPTION 
        JAVA : exception, error
                - checked exception : �ݵ�� ����ó���� �ؾ��ϴ� ����
                - unchecked exception : ����ó���� ���ص� �Ǵ� ����
        
PL/SQL : PL/SQL ���� ����Ǵ� ���� �߻��� ����
������ ����
1. ���� ���� ���� (predefined oracle exception)
    . java ARITHMATIC EXCEPTION
    . ����Ŭ�� ������ ������ ��Ȳ���� �߻��ϴ� ����

2. ����� ���� ����
    . ����, Ŀ��ó�� PL/SQL ���� ����ο� �����ڰ� ���� ������ ����
      RAISE Ű���带 ���� �����ڰ� ���� ���ܸ� ������
      (java : throw new RuntimeException();)
      
PL/SQL ������ ���ܰ� �߻��ϸ�...
���ܰ� �߻��� �������� �ڵ� �ߴ�(����)

��, PL/SQL ������ ����ó�� �κ��� �����ϸ� (EXCEPTION ��)
EXCEPTION ���� ����� �ڵ尡 ����




