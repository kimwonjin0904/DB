/*
    ANSI(American NAtional Standards Institute)
    ANSI ǥ���� �����ͺ��̽� �����ý��ۿ��� ����ϴ� SQL ǥ��
    INNER JOIN, LEFT OUTER JOIN, RIGHT JOIN, OUTER JOIN
*/

--�Ϲ� inner join
SELECT a.employee_id
        ,a.emp_name
        ,a.job_id
        ,b.department_name
FROM employees a    
    ,departments b
WHERE a.department_id = b.department_id;
--INNER
SELECT   a.employee_id
        ,a.emp_name
        ,a.job_id        
        ,b.department_name
FROM employees a 
INNER JOIN departments b
ON a.department_id = b.department_id 
WHERE a.department_id =30;      --�˻������� �ִٸ� ���α��� �Ʒ�
--USING ���� �÷����� ������ ���
SELECT   a.employee_id
        ,a.emp_name
        ,a.job_id       
        ,b.department_name
FROM employees a 
INNER JOIN departments b
USING (department_id) 
WHERE department_id =30;            --USING ���� ����� �÷��� ���̺�� ���� �ȵ�

--�Ϲ� outer join 
SELECT   a.employee_id
        ,a.emp_name         --���� ���̺� �ִ� �÷�(a. �� �ٿ��� ��)
        ,b.job_id
FROM employees a
        ,job_history b
WHERE a.job_id = b.job_id(+)
AND a.department_id = b.department_id(+);
--LEFT
SELECT   a.employee_id
        ,a.emp_name         --���� ���̺� �ִ� �÷�(a. �� �ٿ��� ��)
        ,b.job_id
FROM employees a
LEFT OUTER JOIN job_history b               --OUTER �� �� ��� ��
ON (a.job_id = b.job_id
    AND a.department_id = b.department_id);
--LIGHT JOIN
SELECT   a.employee_id
        ,a.emp_name        
        ,b.job_id
FROM job_history b
RIGHT JOIN employees a            
ON (a.job_id = b.job_id
    AND a.department_id = b.department_id);

--���̺�
CREATE TABLE tb_a (emp_id NUMBER);
CREATE TABLE tb_b (emp_id NUMBER);
INSERT INTO tb_a VALUES(10);
INSERT INTO tb_a VALUES(20);
INSERT INTO tb_a VALUES(40);


INSERT INTO tb_b VALUES(10);
INSERT INTO tb_b VALUES(20);
INSERT INTO tb_b VALUES(30);
COMMIT;
--FULL OUTER(�Ϲ� ������ ���� ����(+) �ȵ�)
SELECT a.emp_id, b.emp_id
FROM tb_a a
FULL OUTER JOIN tb_b b
ON(a.emp_id = b.emp_id);
--CORSS JOIN
SELECT *
FROM tb_a, tb_b;  --3*3�� ��µ�
--ANSI
SELECT *
FROM tb_a
CROSS JOIN tb_b;



--�л��� ���� ������ ����Ͻÿ� LEFT OUTER JOIN ���
SELECT *
FROM �л�;

SELECT a.�̸� ,b.���ǽ�, b.�����ȣ, c.�����̸�
FROM �л� a
LEFT OUTER JOIN �������� b
ON a.�й� = b.�й�
LEFT OUTER JOIN ���� C
ON b.�����ȣ = c.�����ȣ;


--��(VIEW) ���� �����ʹ� �並 �����ϴ� ���̺� ��� ����
--������ : ������ ���� ����, �����ϰ� ���ֻ���ϴ� ������ �����ϰ� 
--�� ���� ������ ���ٸ�
--DBA������ �ִ� system �������� GRANT CREATE VIEW TO ��Ʈ�� �����Ͽ� ���� �ο�
--GRANT CREATE VIEW TO ����;
GRANT CREATE VIEW TO java;
CREATE OR REPLACE VIEW emp_dept AS
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a
    ,departments b
WHERE a.department_id = b.department_id;


--java�������� member �������� �� ��ȸ ���� �ο�
GRANT SELECT ON emp_dept TO member;
--member���� �Ʒ� ����
SELECT *
FROM java.emp_dept;         --��Ű��. ���, 
/*
    ��Ű�� 
    �����ͺ��̽� ������ ���� ���ǿ� ���� �������� ���� ����� ��Ÿ������ ����
    �����ͺ��̽� �𵨸� ������ ���� �ܺ�, ����, ���� ��Ű���� ������
    ������ ����ڰ� ������ ��� �����ͺ��̽� ��ü���� ���ϸ�
    ����� ������ ����. java �������� java��Ű�� 
*/

--VIEW�� �ܼ���(�ϳ��� ���̺�� ����)
         -- INSERT/UPDATE/DELETE ����
--       ���պ�(������ ���̺�� ����)
         -- INSERT/UPDATE/DELETE ����
         
/*  �ó�� Synonym ���Ǿ�, ��ü ������ ������ �̸��� ���Ǿ ����°�
    PUBLIC ��� ����� ���ٰ���, PRIVATE Ư������ڸ�
    �ó�� ������ default private�̸�
    public�� DBA������ �ִ� ����ڸ� ���� �� ���� ����
*/
--������ �ο��ϱ� ���ؼ�
GRANT CREATE SYNONYM To java;       --�ý��۰������� ����
CREATE OR REPLACE SYNONYM emp1      --java�������� ����
FOR employees;                      --private �ó��

SELECT *
FROM emp1;

GRANT SELECT ON emp1 TO member;     --java���� ����
--member���� ����
SELECT *
FROM java.emp1;

CREATE OR REPLACE PUBLIC SYNONYM emp2 --�ý��۰������� ����
FOR java.employees;

SELECT *
FROM emp2;

/*
    ������ SEQUUENCE �ڵ� ������ ��ȯ�ϴ� �����ͺ��̽� ��ü
    ������ ��Ģ�� ���� ������ ����
*/
CREATE SEQUENCE my_seq1
INCREMENT BY 1  -- 1�� ����
START WITH   1    -- 1���� ����
MINVALUE     1      -- �ּҰ� 1
MAXVALUE    10     -- �ִ밪 10
NOCYCLE         -- �ִ밪(10)�� �����ϸ� ���� (�ݺ����� ����)
NOCACHE;        -- ĳ�� ���� (�޸𸮿� �̸� �Ҵ����� ����)

--����
SELECT my_seq1.NEXTVAL
FROM dual;
--����
SELECT my_seq1.CURRVAL
FROM dual;



CREATE SEQUENCE my_seq2
INCREMENT BY 100        -- 100�� ����
START WITH   1          -- 1���� ����
MINVALUE     1          -- �ּҰ� 1
MAXVALUE    1000000     -- �ִ밪 10
NOCYCLE                 -- �ִ밪(10)�� �����ϸ� ���� (�ݺ����� ����)
NOCACHE;                -- ĳ�� ���� (�޸𸮿� �̸� �Ҵ����� ����)

SELECT my_seq2.NEXTVAL  --����� 100������ ���ؾȵ�???????????????????????
FROM dual;
INSERT INTO tb_a VALUES(my_seq2.NEXTVAL);
SELECT *
FROM tb_a;

--IDENTITY oracle 12�����̻󿡼� ������
CREATE TABLE my_tb(
    my_id NUMBER GENERATED ALWAYS AS IDENTITY
    ,my_nm VARCHAR2(100)
    ,CONSTRAINT my_pk PRIMARY KEY(my_id)
);
INSERT INTO my_tb(my_nm) VALUES('�ؼ�');
INSERT INTO my_tb(my_nm) VALUES('����');
INSERT INTO my_tb(my_nm) VALUES('����');
SELECT * 
FROM my_tb;

-----------------------
CREATE TABLE my_tb2(
    my_id NUMBER GENERATED ALWAYS AS IDENTITY
    (START WITH 1 INCREMENT BY 2 NOCACHE)
    ,my_nm VARCHAR2(100)
    ,CONSTRAINT my_pk2 PRIMARY KEY(my_id)
);
INSERT INTO my_tb2(my_nm) VALUES('�ؼ�');
INSERT INTO my_tb2(my_nm) VALUES('����');
INSERT INTO my_tb2(my_nm) VALUES('����');

SELECT * 
FROM my_tb2;


/*  MERGE Ư¡ ���ǿ� ���� �ٸ� ������ ������ �� ��밡��
*/
--'����' ���̺� �ӽŷ��� ������ ������ ������ 2�� ����
--�ִٸ� ������ 3���� ������Ʈ 
MERGE INTO ���� s
USING DUAL                         --�� ���̺� dual�� ���� ���̺��϶�
ON(s.�����̸� = '�ӽŷ���')         --mathch����(�ӽŷ��� ������ �ִ���)
WHEN MATCHED THEN
        UPDATE SET s.���� = 3
WHEN NOT MATCHED THEN
    INSERT (s.�����ȣ, s.�����̸�, s.����)
    VALUES ((SELECT NVL(MAX(�����ȣ), 0) +1
    FROM ����), '�ӽŷ���', 2);
---------------2--------------
MERGE INTO ���� s
USING (SELECT '�ӽŷ���' AS �����̸� FROM DUAL) d  -- `�ӽŷ���`�� �� ��� ���̺�� ����
ON (s.�����̸� = d.�����̸�)  -- `�ӽŷ���`�� ���� ���̺� �����ϴ��� Ȯ��
WHEN MATCHED THEN
    UPDATE SET s.���� = 3  -- ������ �����ϸ� ������ 3���� ������Ʈ
WHEN NOT MATCHED THEN
    INSERT (s.�����ȣ, s.�����̸�, s.����)
    VALUES ((SELECT NVL(MAX(�����ȣ), 0) + 1 FROM ����), '�ӽŷ���', 2);  -- ������ ������ �߰�



SELECT *
FROM ����;



/*  2000�⵵ �Ǹ�(�ݾ�)���� ������ ����Ͻÿ� (sales, employees)    
    �ǸŰ��� �÷�(amount_sold, quantity_sold, slaes_date)
    (��Į�� ����������, �ζ��� �並 ����غ�����)
*/
SELECT    a.employee_id
        ,(SELECT emp_name FROM employees
          WHERE employee_id = a.employee_id) as �����̸�
        ,TO_CHAR(�Ǹűݾ�, '999,999,999,99')    �Ǹűݾ�
        ,�Ǹż���
FROM (SELECT employee_id, SUM(amount_sold)  as �Ǹűݾ�
            ,SUM(quantity_sold)             as �Ǹż���
      FROM sales
      WHERE TO_CHAR(sales_date, 'YYYY') = '2000'
      GROUP BY employee_id
      ORDER BY 2 DESC) a
WHERE ROWNUM <= 1;


select count(*)
from sales;

