
�͸� block : �����Ͱ� �ѰǸ� ���;� �ϴ� ��Ȳ

SET SERVEROUTPUT ON;

DECLARE
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename INTO v_ename
    FROM emp
    WHERE empno = 7369;
END;
/

--����ó�� ��� -> EXCEPTION
DECLARE
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename INTO v_ename
    FROM emp;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS');
END;
/

���������ϱ�
���ܸ� ��� ����ڰ� ������ ���ο� ���ܷ� ������ �۾�

SELECT ename
FROM emp
WHERE empno = -99999;
NO_DATA_FOUND ==> NO_EMP


����� ���� ���� ����
���ܸ� EXCEPTION;

DECLARE
    NO_EMP EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN
    BEGIN
        SELECT ename INTO v_ename
        FROM emp
        WHERE empno = -99999;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
        RAISE NO_EMP; --java : throw new Exception();
    END;
EXCEPTION
    WHEN NO_EMP THEN
        DBMS_OUTPUT.PUT_LINE('NO_EMP');
END;
/







