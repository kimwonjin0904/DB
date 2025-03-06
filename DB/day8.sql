/*
    �������� SQL���� �ȿ� ������ ���Ǵ� �� �ٸ� SELECT��
    ���� ������ �������� ����
    1.������ ���� ��������, �ִ� ��������
    or ���¿� ���� 
    1.��Į�� �������� SELECT��
    2.�ζ��� ��     FROM��
    3.��ø ����     WHERE��
*/
--1.��Į�� ��������(���� �÷�, �������� ��ȯ), �������̺� row�� ��ŭ �����
SELECT *
FROM employees;     --��ȸ
--���̵��� �̸� ���
SELECT   a.emp_name
        ,a.employee_id
        ,a.department_id
        ,(SELECT department_name
         FROM departments
         WHERE department_id = a.department_id) as dep_name
        ,a.job_id
FROM employees a;

--job title ���--
SELECT   a.emp_name
        ,a.employee_id
        ,a.department_id
        ,a.job_id
        ,(SELECT job_id
         FROM jobs
         WHERE job_id = a.job_id) as job_title   
FROM employees a;

--�л� (�����ȣ�� �����̸��� ��������)
SELECT  a.�й�
       ,a.�̸�
       ,a.����
       ,b.����������ȣ
       ,(SELECT �����ȣ
       FROM ����
       WHERE �����ȣ = b.�����ȣ) as �����
       ,b.�������
FROM �л� a, �������� b       
WHERE a.�й� = b.�й�;

--2.�ζ��� �� (FROM ��) select ����� �ϳ��� ���̺� ó�� ���
SELECT *
FROM �л�;
SELECT *
FROM ����;

--ROWNUM ���̺��� ������ �ִ� ��ó�� ��밡���� �÷�(���ڰ� ��)
SELECT ROWNUM  as rnum
    ,a.*
FROM ���� a;
--�����̸� 1�� ����(WHERE ROWNUM = 1;)--
SELECT ROWNUM  as rnum
    ,a.*
FROM ���� a
WHERE ROWNUM = 1;


---------------------------
SELECT *
FROM (
        SELECT ROWNUM  as rnum
               ,a.* 
        FROM ���� a
)
WHERE rnum =2; --rnum�� �ζ��� ��� ���̺� �ִ� �÷� ó�� ��� 



  --1~10���� ��ȣ�� ���(WHERE rnum BETWEEN 1 AND 10;)--
SELECT *
FROM (
        SELECT ROWNUM  as rnum
               ,a.* 
        FROM ���� a
)
WHERE rnum BETWEEN 1 AND 10; 



--������ ������ rownum������ �ٲ�
SELECT ROWNUM  as rnum
    ,a.*
FROM ���� a
ORDER BY 3;     --���� ���� ����


--����� �� ������ �Ϸ��� + 1~10���� --
SELECT *
FROM(
     SELECT ROWNUM as rnum
            ,a.*
     FROM (
            SELECT *
            FROM     ����
            ORDER BY �����̸�
          ) a
    )
WHERE rnum BETWEEN 1 AND 10;

-------����(īƮ���Ƚ��)�� �������� ������ ����� 2~5���� ��ȸ�Ͻÿ�-----------
SELECT *
FROM (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY īƮ���Ƚ�� DESC) AS rnum, 
        a.mem_id,                    
        a.mem_name,                         
        COUNT(DISTINCT b.cart_no) AS īƮ���Ƚ��,
        COUNT(DISTINCT b.cart_prod) AS ��ǰǰ���,
        SUM(NVL(b.cart_qty, 0)) AS ��ǰ���ż�, 
        SUM(NVL(b.cart_qty, 0) * NVL(c.prod_price, 0)) AS �ѱ��űݾ�
    FROM member a, cart b, prod c
    WHERE a.mem_id = b.cart_member(+)
    AND b.cart_prod = c.prod_id(+)
    GROUP BY a.mem_id, a.mem_name
) 
WHERE rnum BETWEEN 2 AND 5;


--3.��ø����(���������� �������� ���� Ư�� ���� �ʿ��Ҷ� ���)
--��ü ������ ��� �޿� �̻��� ���� ��ȸ--
SELECT *
FROM employees;

SELECT AVG(salary) --��ձ��ϱ�(salary)
FROM employees;

SELECT *
FROM employees
WHERE salary >= 6461.831775700934579439252336448598130841;


SELECT emp_name, salary
FROM employees
WHERE salary >= (SELECT AVG(salary) --�ܼ� ���� �ʿ��� ��Ȳ
                 FROM employees);
                
--job_history �̷��� �ִ� ������ ��ȸ�Ͻÿ�
SELECT *
FROM job_history;
SELECT employee_id
FROM job_history;

SELECT *
FROM employees
WHERE employee_id IN (SELECT employee_id
                      FROM job_history);        --?? �� 7���� ���
                      
--���ÿ� 2�� �̻� �÷� ���� ���� �� ��ȸ
SELECT employee_id, emp_name, job_id
FROM employees
WHERE ( employee_id, job_id) IN (SELECT employee_id, job_id
                                   FROM job_history);
  --���--
--200	Jennifer Whalen	AD_ASST
--176	Jonathon Taylor	SA_REP




--salary ���� ���ų� ����(MAX , MIn)--
SELECT emp_name, salary
FROM employees
WHERE salary >= (SELECT MAX(salary) 
                 FROM employees);



--�����̷��� ���� �л� ��ȸ(NOT , IN)
SELECT *
FROM �л�
WHERE �й� NOT IN (SELECT �й�
               FROM ��������);




--�������� EXISTS(���������� ������ ����)
--�����ϳ� ���ϳ� NOT 
SELECT *
FROM �л� a
--exists �����ϴ��� üũ ���������� ������ true�� �ุ ���� ���̺��� ��ȸ
WHERE NOT EXISTS (SELECT 1                 --select���� ���� *�ǹ� ���� ���� �������Ǹ� üũ
                FROM ��������
                WHERE �й� = a.�й�);


--job_history ���̺� �����ϴ� ���� ������ ����Ͻÿ�
SELECT emp_name  
        ,(SELECT department_name
        FROM departments
        WHERE department_id = a.department_id) as dep_name
FROM employees a
WHERE EXISTS (SELECT *
                FROM job_history
                WHERE employee_id = a.employee_id);

------------------------------------------------------
--ROLLUP : �κ� ���踦 �����Ͽ� ���� �հ踦 ����


--CUBE: ��������� ������ ������(rollup���� �پ��� ����)
SELECT department_id, job_id, SUM(salary) as tot
FROM employees
WHERE department_id IS NOT NULL 
GROUP BY ROLLUP(department_id, job_id);
--department_id, job_id -> �μ��� ������ �հ�
--department_id, null   -> �μ��� ����
--null null             -> ��ü �հ�
--cube: ��� ������ ������ ������. (rollup ���� �پ��� ����)
SELECT department_id, job_id, SUM(salary) as tot
FROM employees
WHERE department_id IS NOT NULL 
GROUP BY CUBE(department_id, job_id);
--department_id, job_id �հ�
--department_id, null   �μ��� �հ�
--null          ,job_id ������ �հ�
--null null             ��ü   �հ�



--GROUPING SETS
--�������� �׷�ȭ ������ ���������� �����Ͽ� ����� ��ȯ
--�� �������� GROUP BY ������ ������ �Ͱ� ���� ȿ��
SELECT department_id, job_id, SUM(salary) as tot
FROM employees
WHERE department_id IS NOT NULL 
GROUP BY GROUPING SETS((department_id), (job_id), ());
--department_id -> �μ��� ����
--job_id        -> ������ ����
--()            -> ��ü


--grouping_id : �� ���� � ������ �׷�ȭ���� Ȯ���Ҷ� ���
SELECT department_id, job_id, SUM(salary) as tot
        ,GROUPING(department_id) as dep_id        
        ,GROUPING(job_id) as job_gid
        ,GROUPING_ID(department_id, job_id) as gr_id
FROM employees
WHERE department_id IS NOT NULL 
GROUP BY CUBE(department_id, job_id);
--GROUPING(department_id) 0�̸� �μ��� ����, 1�̸� �μ��� null(����)
--GROUPING(job_id) 0�̸� ������ ����, 1�̸� ������ null (���� ����)
--GROUPING_ID(department_id,job_id) GROUPING()���� �������� ��ȯ�� ��
--0 0-> 0 (���α׷�)
--0 1-> 1 (�μ�����)
--1 0-> 2 (��������)
--1 1-> 3 (��ü����)

--�Ѱ� �Ұ� �������--
SELECT department_id, job_id, tot
        ,DECODE(gr_id, 1 ,'�Ұ�', 3 ,'�Ѱ�', job_id) as job_id
        , tot               
FROM(
     SELECT department_id, job_id, SUM(salary) as tot
        ,GROUPING(department_id) as dep_id        
        ,GROUPING(job_id) as job_gid
        ,GROUPING_ID(department_id, job_id) as gr_id
     FROM employees
     WHERE department_id IS NOT NULL 
     GROUP BY ROLLUP(department_id, job_id)
);



--�л����� '������', '����'�� '���� ����' �л��� ������ ����Ͻÿ�
--��½� �й�,�̸�,�ּ�,����,������,�������,�б�,����--
SELECT *
FROM �л�
WHERE (����, �л�) IN (SELECT ����, MAX(����)
                        FROM �л�
                        GROUP BY ����);



SELECT *
FROM �л� s
WHERE (s.����, s.����) IN (
    SELECT ����, MAX(����)
    FROM �л�
    GROUP BY ����
);






