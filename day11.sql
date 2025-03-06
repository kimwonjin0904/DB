SELECT department_id
        ,LPAD('  ', 3*(LEVEL-1))  || department_name as �μ���
        --���� -���μ� Ʈ�� ������ � �ܰ迡 �ִ��� ��Ÿ���� ������
        ,parent_id                         
        ,LEVEL 
FROM departments
START WITH parent_id IS NULL                        --�ش� ���� �ο���� ����
CONNECT BY PRIOR department_id = parent_id;         --���� ������ � ������ ����Ǵ���
--      ���� �μ����� parent_id�� ã����

--�����ڿ� ����
SELECT a.employee_id
      ,LPAD('  ', 3*(LEVEL-1))  || a.emp_name
      ,LEVEL
      ,b.department_name
FROM employees   a
    ,departments b
WHERE a.department_id = b.department_id
--AND a.department_id = 30
START WITH a.manager_id IS NULL                     --�ֻ��� ������(CEO)���� ����
CONNECT BY PRIOR a.employee_id = a.manager_id;      --PRIOR a.employee_id(������)
--AND a.department_id = 30
/*
    1.������  ������ ���� ���� ó��
    2.START WITH ���� ������ �ֻ��� ���� �ο츦 ����
    3.CONNECT BY ���� ��õ� ������ ���� ������ ���� LEVEL ����
    4.�ڽ� �ο� ã�Ⱑ ������ ���� ������ ������ �˻� ���ǿ� �����ϴ� �ο츦 �ɷ���.
*/

--������ ������ ���������� ������ ������ Ʈ���� ����
--SIBLINGS�� �־������.
SELECT department_id
        ,LPAD('  ', 3*(LEVEL-1))  || department_name as �μ���
        ,parent_id                         
        ,LEVEL 
FROM departments
START WITH parent_id IS NULL                        --�ش� ���� �ο���� ����
CONNECT BY PRIOR department_id = parent_id
ORDER SIBLINGS BY department_name;  

--������ �������� ����� �� �ִ� �Լ�
SELECT   department_id
        ,parent_id
        ,LPAD('  ', 3*(LEVEL-1))  || department_name as �μ���
        ,SYS_CONNECT_BY_PATH(department_name, '|')   as �μ��� --��Ʈ ��忡�� ������ currnet row���� ���� ��ȯ
        ,CONNECT_BY_ISLEAF                                     --������ ���1, �ڽ��� ������ 0
        ,CONNECT_BY_ROOT department_name as root_nm            --�ֻ���
FROM departments
START WITH parent_id IS NULL                                   --�ش� ���� �ο���� ����
CONNECT BY PRIOR department_id = parent_id; 

--�ű� �μ��� ������ϴ�.
--IT �ؿ� 'SNS��'
--IT ���� ����Ʈ �μ� �ؿ� '��ۺδ�'
--�˸°� �����͸� �������ּ���
INSERT INTO departments (department_id, department_name, parent_id)
VALUES(280, 'SNS��',60);
INSERT INTO departments (department_id, department_name, parent_id)
VALUES(290, '��ۺδ�',230);

SELECT * 
FROM departments;

CREATE TABLE �� (
    ���̵� NUMBER, 
    �̸� VARCHAR2(100 CHAR), 
    ��å VARCHAR2(100 CHAR),
    ����_���̵� NUMBER  
);
--������ ���� ��µǵ��� �����͸� ���� �� ������ ������ �ۼ��Ͻÿ�
INSERT INTO ��(���̵�, �̸�, ��å)
VALUES(1, '�̻���', '����' );
INSERT INTO ��(���̵�, �̸�, ��å)
VALUES(2, '�����', '����' );
INSERT INTO ��(���̵�, �̸�, ��å)
VALUES(3, '������', '����' );
INSERT INTO ��(���̵�, �̸�, ��å)
VALUES(4, '�����', '����' );
INSERT INTO ��(���̵�, �̸�, ��å)
VALUES(5, '�̴븮', '�븮' );
INSERT INTO ��(���̵�, �̸�, ��å)
VALUES(6, '�ֻ��', '���' );
INSERT INTO ��(���̵�, �̸�, ��å)
VALUES(7, '�����', '���' );
INSERT INTO ��(���̵�, �̸�, ��å)
VALUES(8, '�ڰ���', '����' );
INSERT INTO ��(���̵�, �̸�, ��å)
VALUES(9, '��븮', '�븮' );
INSERT INTO ��(���̵�, �̸�, ��å)
VALUES(10, '�ֻ��', '���' );

--��






--(bottom-up) �Ųٷ� �ڽĿ��� �θ�� �Ʒ����� ����
SELECT department_id ,parent_id
      ,LPAD(' ', 3*(LEVEL-1)) || department_name as �μ���
      ,LEVEL
FROM departments
START WITH department_id = 280
CONNECT BY PRIOR parent_id = department_id;

--���������� ���� CONNECT BY���� LEVEL ���(���� �����Ͱ� �ʿ��Ҷ�)
SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= 12; --���� 12���� ���

-- 1~12�� ���
SELECT TO_CHAR(SYSDATE, 'YYYY') || LPAD(LEVEL, 2,'0') as yy
FROM dual
CONNECT BY LEVEL<= 12;

SELECT period as yy
      ,sum(loan_jan_amt) �հ�
fROM kor_loan_status
WHERE period Like '2013%'   
GROUP BY period
ORDER BY 1;
--
SELECT a.yy,
       NVL(b.�հ�, 0) AS �հ�
FROM (SELECT '2013' || LPAD(LEVEL, 2, '0') AS yy
      FROM dual
      CONNECT BY LEVEL <= 12) a -- 201301 ~ 201312 ����
LEFT JOIN (SELECT period AS yy,
                  SUM(loan_jan_amt) AS �հ�
           FROM kor_loan_status
           WHERE period LIKE '2013%'
           GROUP BY period) b
ON a.yy = b.yy
ORDER BY 1;


/*
    select a.yy
          ,b.�հ�
    from () a
        ,() b
    where a.yy = b.yy(+)
*/


--�������� ���ڸ� ���Ͽ� �ش� �� ��ŭ ����
SELECT TO_CHAR(SYSDATE)  as DATES
      ,LAST_DAY(SYSDATE) as DATES2
FROM dual
;
--------------------------
SELECT TO_CHAR(LAST_DAY(SYSDATE),'dd')      --dd�� ���ؼ� ��¥  ��°��: 31
    ,  TO_CHAR(LAST_DAY(SYSDATE))            --25/03/31
FROM dual
;
-------------
SELECT TO_DATE(TO_CHAR(SYSDATE,'YYYYMM') || LPAD(LEVEL, 2, '0')) as yyyymmdd
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE),'dd')
;


/*
    study����
    reservation ���̺��� reserv_date, cancel �÷��� Ȱ���Ͽ�
    ��õ '��'�� ��� ���Ϻ� ����Ǽ��� ����Ͻÿ� (��Ұ� ����)
*/














