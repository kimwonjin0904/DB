/*
    PL/SQL ���� & ������ ����� Ư¡�� ��� ������ ����
    DB���ο� ������� �Ϲ� ���α׷��� ���� ����
    �Լ�,���ν���, Ʈ����...�� ���� �� ����.
*/
SET SERVEROUTPUT ON; --��ũ��Ʈ�� ����Ϸ���

DECLARE                         --�͸���
    v_num NUMBER;               --�����
BEGIN                   
    v_num := 100;               --�����
    DBMS_OUTPUT.PUT_LINE(v_num);
END;

DECLARE
    emp_nm VARCHAR(80);
    dep_nm departments.department_name%TYPE; --���̺��� �÷� Ÿ��
BEGIN
    SELECT a.emp_name, b.department_name
    INTO emp_nm, dep_nm
    FROM employees a, departments b
    WHERE a.department_id = b.department_id
    AND a.employee_id = 100;
    DBMS_OUTPUT.PUT_LINE(emp_nm || ':' || dep_nm);
END;

--�ܼ� ����--
--(������)--
DECLARE
    dan NUMBER := 2;
    su  NUMBER := 1;
BEGIN
    LOOP
     DBMS_OUTPUT.PUT_LINE(dan || 'x' || su || '=' || dan * su);
     su  := su + 1;
     EXIT WHEN su > 9;      --�ܼ������� ������ �ʿ�(Ż������)
    END LOOP;
END;
    
--������ ��� 2~9�� (Ż�� ���� �߿�)
DECLARE
    dan NUMBER := 2;
    su  NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(dan || '��');
        su :=1;
             LOOP
             DBMS_OUTPUT.PUT_LINE(dan || 'x' || su || '=' || dan * su);
             su  := su + 1;
             EXIT WHEN su > 9;      --�ܼ������� ������ �ʿ�(Ż������)
        END LOOP;
        dan:= dan +1;
    EXIT WHEN dan > 9;
    END LOOP;
END;
    

--for��--
DECLARE

    dan NUMBER :=2;
BEGIN
    FOR I IN 1..9
    LOOP
     CONTINUE WHEN i =5;        --2 x 5�� �����
     DBMS_OUTPUT.PUT_LINE(dan || '*' || i || '=' || dan * i);
    END LOOP;
END;


--mem_id�� �Է¹޾� ����� �����ϴ� �Լ�
--vip :5000�̻� 
--GOLD :5000 �̸� 3000�̻�
--SILVER : ������ 
--INPUT VARCHAR2, OUTPUT VARCHAR2
CREATE OR REPLACE FUNCTION fn_grade(p_id VARCHAR2)
 RETURN VARCHAR2
IS 
 m_mileage NUMBER;
 m_grade VARCHAR2(30);
BEGIN
 SELECT mem_mileage
  INTO m_mileage
 FROM member
 WHERE mem_id = p_id;
 
 IF m_mileage >= 5000 THEN
    m_grade := 'VIP';
 ELSIF m_mileage < 5000 AND m_mileage >= 3000 THEN
    m_grade := 'GOLD';
 ELSE
    m_grade := 'SILVER';
 END IF;
 
 RETURN m_grade;
END;
    --=============
select fn_grade('a001')
from dual;
  --====================  
 select fn_grade(mem_id)
 from member;
 
 
CREATE OR REPLACE PROCEDURE test_proc(
    p_v1 IN VARCHAR2, 
    p_v2 OUT VARCHAR2, 
    p_v3 IN OUT VARCHAR2
)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('p_v1: ' || p_v1);
    DBMS_OUTPUT.PUT_LINE('p_v3: ' || p_v3);  -- p_v2�� OUT�̹Ƿ� ��¹����� ����

    p_v2 := '����2';
    p_v3 := '����3';
END;


                                      
                            
DECLARE
    p1 VARCHAR2(10) := '�Է�1';
    p2 VARCHAR2(10) := '�Է�2';
    p3 VARCHAR2(10) := '�Է�3';
BEGIN
    TEST_PROC(p1, p2, p3); --���ν��� ȣ��
    DBMS_OUTPUT.PUT_LINE(p2 || ',' || p3);
END;

/*
    �й����� �Լ��� ������ּ���
    ���Ի��� ���Խ��ϴ�.
    �л����̺���  �й��� ���� ū �й���  ���ڸ� (4�ڸ�)�� ���� �⵵��� + 1
    �ƴ϶�� ���س⵵ +000001 �� ��ȣ�� �������ּ���!
    ex) 2002110112 ->> ���� �ƴ� 202500001
        2025000001 ->> ���� +1 : 202500002
        �� a = b
*/
select fn_make_hakno
from dual
;

CREATE OR REPLACE FUNCTION fn_make_hakno 
 RETURN NUMBER
IS 
 make_no NUMBER;
 this_year VARCHAR2(4) :=TO_CHAR(SYSDATE,'YYYY');
BEGIN
--1.���� ū �й� ��ȸ
--2.���ؿ� ��
-- ���ǿ� ���� ��ȣ ����
 RETURN meke_no;
END;

    