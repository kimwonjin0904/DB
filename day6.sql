--17002 
--lsnrctl status ���� Ȯ����
--lsnrctl start ����

/*
    �����Լ��� �׷����
    �����Լ� ��� �����Ϳ� ���� ���� , ���, �ִ�, �ּڰ� ���� ���ϴ� �Լ� p 177
*/

SELECT COUNT(*)                         --null����   *�� ��ü���� ����
    ,COUNT(department_id)               --default all
    ,COUNT(ALL department_id)           --�ߺ� o, nullx
    ,COUNT(DISTINCT department_id)      --�ߺ� x, nullx
    ,COUNT(employee_id)
FROM employees;



SELECT   SUM(salary)            as �հ�
        ,MAX(salary)            as �ִ�
        ,MIN(salary)            as �ּ�
        ,ROUND(AVG(salary),2)   as ���                       --ROUND??
FROM employees;



--�μ��� ����
SELECT  department_id
        ,SUM(salary)            as �հ�
        ,MAX(salary)            as �ִ�
        ,MIN(salary)            as �ּ�
        ,ROUND(AVG(salary),2)   as ���           
        ,COUNT(employee_id)     as  ������
FROM employees
WHERE department_id IS NOT NULL
AND department_id IN (30, 60 ,90)
GROUP BY department_id
ORDER BY 1;


------------�μ���, ���� ����----
SELECT  department_id
        ,job_id
        ,SUM(salary)            as �հ�
        ,MAX(salary)            as �ִ�
        ,MIN(salary)            as �ּ�
        ,ROUND(AVG(salary),2)   as ���           
        ,COUNT(employee_id)     as  ������
FROM employees
WHERE department_id IS NOT NULL                             --??
AND department_id IN (30, 60 ,90)
GROUP BY department_id, job_id
ORDER BY 1;
--select�� ���� ����
--FROM -> WEHRE -> GROUP -> HAVING -> SELECT -> ORDER BY



--member�� ȸ������ ���ϸ����� �հ�,����� ����Ͻÿ�
SELECT   COUNT(mem_id)                       as ȸ����
        ,COUNT(*)                       as ȸ����2
        ,SUM(mem_mileage)               as ���ϸ��� ����
        ,ROUND(AVG(mem_mileage,2)       as ���
FROM member;    


----------
SELECT *
FROM member;

--������, ȸ����, ���ϸ��� �ղ�,���(���ϸ������ ��������)
SELECT mem_job, 
       COUNT(mem_id)              AS ȸ����,
       SUM(mem_mileage)           AS ���ϸ���_�հ�,
       ROUND(AVG(mem_mileage), 2) AS ���ϸ������
FROM member
GROUP BY mem_job
ORDER BY ���ϸ������ DESC;


--������ ���ϸ��� ����� 3000�̻��� ������ ������ ȸ������ ���
SELECT   mem_job, 
         COUNT(mem_id)               AS ȸ����
         ,SUM(mem_mileage)            AS ���ϸ���_�հ�
        ,ROUND(AVG(mem_mileage), 2)  AS ���ϸ������
FROM member
GROUP BY mem_job
HAVING AVG(mem_mileage) >= 3000 --�������� ���ؼ� �˻����� �߰��Ҷ� ���
ORDER BY ���ϸ������ DESC;


--kor_loan_status (java����) ���̺��� 
--2013�⵵ �Ⱓ�� ������ �� ����ܾ��� ����Ͻÿ�
--1.���� �� �ʿ��� �÷� ����� 
--2.�˻� ���� �߰�
--3. ���� �� ��� üũ (�׷���������� ����Ʈ ���� ����ϴ� ǥ�� �״�� ��밡��)

---����----
desc kor_loan_status;
SELECT SUBSTR(period,1,4)            as �⵵
        ,region                      as ����
        ,SUM(loan_jan_amt)           as ������
FROM kor_loan_status
WHERE SUBSTR(period,1,4) = '2013'
GROUP BY  SUBSTR(period,1,4),region;



-----�� Ǯ��----------

desc kor_loan_status;
SELECT SUBSTR(period,1,4),region, LOAN_JAN_AMT
FROM kor_loan_status
HAVING AVG()
ORDER BY


SELECT *
FROM kor_loan_status;





--������ �����ܾ��ղ��� 200000 �̻��� ������ ����Ͻÿ�
--�����ܾ� ��������

--��---
SELECT region, SUM(loan_jan_amt)
FROM kor_loan_status
GROUP BY region
HAVING SUM(loan_jan_amt) >=30000
ORDER BY 2 DESC
;

---�� Ǯ��-----
SELECT   region       as  ����
       -- ,loan_jan_amt as ������
        ,SUM(loan_jan_amt)  as ������
HAVING 
FROM kor_loan_status;


--����, ����, �λ��� �⵵�� ���� �հ迡��
--������ ���� 60000�� �Ѵ� ����� ����Ͻÿ�
--����:������������, ������ ��������
--��--
SELECT SUBSTR(period, 1, 4)  AS �⵵
       ,region                AS ����
       ,SUM(loan_jan_amt)     AS �հ�
FROM kor_loan_status
WHERE region IN ('����', '����', '�λ�')
GROUP BY SUBSTR(period, 1, 4), region
HAVING SUM(loan_jan_amt) >= 60000
ORDER BY ���� ASC, �հ� DESC;


---GROUP BY ROLLUP---�ѰԸ� ���� 
SELECT region
        ,SUM(loan_jan_amt)
FROM kor_loan_status
GROUP BY ROLLUP(region);

-----NVL-----
SELECT NVL(region,'�Ѱ�')
        ,SUM(loan_jan_amt)
FROM kor_loan_status
GROUP BY ROLLUP(region);


--�⵵�� ������ �հ�� �Ѱ�
SELECT *
FROM kor_loan_status;

SELECT SUBSTR(period,1,4)  as �⵵
      ,SUM(loan_jan_amt)   as �հ�
FROM kor_loan_status
GROUP BY ROLLUP(SUBSTR(period,1,4));




--employees �������� ������ڸ�(hire_date)�� Ȱ���Ͽ� �Ի�⵵(TO_CHAR)�� ������(COUNT)�� ����Ͻÿ�
--(���� �Ի�⵵ ��������)
SELECT *
FROM employees;

SELECT TO_CHAR(hire_date,'YYYY') as �⵵
       ,COUNT(*) as ������ 
FROM employees
GROUP BY TO_CHAR(hire_date,'YYYY')
ORDER BY 1 asc;

--employees �������� ������ڸ�(hire_date)Ȱ�� �Ի��� ���� ������ �������� ���
--(������ ��, �� ~> ��)
SELECT  TO_CHAR(hire_date, 'DAY') as ����
       ,COUNT(*) as ������   
FROM employees
GROUP BY TO_CHAR(hire_date, 'DAY'), TO_CHAR(hire_data,'d')
ORDER BY TO_CHAR(hire_data,'d') asc;



--customers ȸ���� ��ü ȸ����, ���� ȸ����, ���� ȸ������ ����Ͻÿ�
--����, ���ڶ�� �÷��� ����
--customers ���̺��� �÷��� Ȱ���ؼ� ��������
SELECT COUNT(DECODE(cust_gender, 'F', '����')) as ����
,SUM(DECODE(cust_gender, 'F', 1,0)) as ����
,COUNT(DECODE(cust_gender, 'M', '����')) as ����
,SUM(DECODE(cust_gender, 'M', 1,0)) as ����
,COUNT(cust_gender) as ��ü
FROM customers;



























