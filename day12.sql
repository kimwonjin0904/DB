/*
    WITH��(oracle 9 �̻� ����)
    ��Ī���� ����� SELECT ���� �ٸ� SELECT������ ������ ����
    �ݺ��Ǵ� ������ �ִٸ� ȿ������
    ��������� Ʃ���Ҷ� ���� ���
    1.temp��� �ӽ� ���̺��� ����ؼ� ��ð� �ɸ��� ������ ����� ������ ����
    ������ ���� �����͸� �������ϱ� ������ ������ ���� �� ����.
*/
--���� ����
--��ǰ�� ����
--���Ϻ� ���� ��� Ž���Ҷ� ����


--�μ��� ����
--��ü ���� ��ȸ
WITH A AS(SELECT employee_id
                  ,emp_name
                  ,department_id
                  ,job_id
                  ,salary
            FROM employees
)  , B AS(SELECT department_id
               ,SUM(salary)          as dep_sum
               ,count(department_id) as dep_cnt
        FROM a
        GROUP BY department_id
) ,  C AS(SELECT job_id
                ,SUM(salary) as job_sum
                ,COUNT(job_id) as job_cnt
         FROM a
         GROUP BY job_id
)
SELECT a.employee_id, a.emp_name, a.salary, b.dep_sum
        ,ROUND(a.salary/b.dep_sum * 100,2) as dep_ratio        --b.dep_cnt, c.job_sum, c.job_cnt
FROM a, b, c
WHERE a.department_id = b.department_id
AND   a.job_id        = c.job_id;

--kor_loan_status ���̺��� Ȱ���Ͽ� "������" ������(��������)���� 
--���� ������ ���� ���� ���ÿ� �ܾ����
--1.������ ����: 2011���� �����⵵�� �������� 12�������� 2013�� 11����. (������ ���� ū ���� ����)
--2.������ �������� ������� �����ܾ��� ���� ū �ݾ��� ���� (1���� ���� �������� ���� ū �ܾ��� ����)
--3.����, ������ �����ܾװ� 2�� ����� ���� �ݾ��� ���� ���� ���

--������ 
SELECT MAX(period)
FROM kor_loan_status
GROUP BY substr(period, 1, 4);
--���������� �ܾ�
SELECT period, region, SUM(loan_jan_amt) as jan_amt
FROM kor_loan_status
GROUP BY period, region;

--������ �����ܾ� max��
SELECT b.period
      ,MAX(b.jan_amt)    as max_jan_amt
FROM (SELECT MAX(period) as max_month
FROM kor_loan_status
GROUP BY substr(period, 1, 4)) a
    ,(SELECT period, region, SUM(loan_jan_amt) as jan_amt
FROM kor_loan_status
GROUP BY period, region) b
WHERE a.max_month = b.period
GROUP BY b.period;

---------------------------------
SELECT b2.*
FROM (SELECT period, region, SUM(loan_jan_amt) as jan_amt
FROM kor_loan_status
GROUP BY period, region) b2
    ,(SELECT b.period
      ,MAX(b.jan_amt)    as max_jan_amt
FROM (SELECT MAX(period) as max_month
FROM kor_loan_status
GROUP BY substr(period, 1, 4)) a
    ,(SELECT period, region, SUM(loan_jan_amt) as jan_amt
FROM kor_loan_status
GROUP BY period, region) b
WHERE a.max_month = b.period
GROUP BY b.period) c
WHERE b2.period  = c.period
AND   b2.jan_amt = c.max_jan_amt;


--with
WITH b AS (
    SELECT period, region, SUM(loan_jan_amt) AS jan_amt
    FROM kor_loan_status  
    GROUP BY period, region
),   
c AS (
    SELECT b.period, MAX(b.jan_amt) AS max_jan_amt
    FROM b,
        (SELECT MAX(period) AS max_month
         FROM kor_loan_status 
         GROUP BY SUBSTR(period, 1, 4)) a
    WHERE b.period = a.max_month
    GROUP BY b.period
)
SELECT b.*
FROM b, c
WHERE b.period = c.period
AND b.jan_amt = c.max_jan_amt;

-------------------------------
//1.
SELECT *
FROM member;
//2.
WITH a AS( SELECT '�ѱ�'    as texts FROM DUAL
           UNION
           SELECT '�ѱ�ABC' as texts FROM DUAL
           UNION
           SELECT 'ABC'     as texts FROM DUAL
)
SELECT * 
FROM a
WHERE REGEXP_LIKE(texts,'^[��-��]+$');


SELECT period
      ,region
      ,sum(loan_jan_amt) jan_amt
FROM kor_loan_status
WHERE period= '201112'
GROUP by period, region;

-------
/*
    �м��Լ�
    ���̺� �ִ� �ο쿡 ���� Ư�� �׷캰�� ���� ���� �����Ҷ� ���
    ���� �Լ��� �ٸ����� �ο� �ս� ���� ���ʹ��� ���� �� �� ����
    �м��Լ��� �ڿ��� ���� �Һ��ϱ� ������ 
    ���� �м��Լ��� ���ÿ� ����� ���(patiton, order �����ϰ� �ϸ� ����)
    �ִ��� ���� �������� ���, �������������� ��� X
    
    �м��Լ�(�Ű�����) OVER(parition by expr1,..
                          ORDER BY expr2...
                          WINDOW ��...)
    ����: AVG,SUM, COUNT, DENSE_RANK, RANK, ROW_NUMBER, PERCENT_RANK, LAG, LEAD..
    PARITION BY ��: ��� ��� �׷�
    ORDER BY      : ��� �׷쿡 ���� ����
    WINDOW        : ��Ƽ������ ���ҵ� �׷쿡 ���� �� ���� �׷����� ����(��, ��)
*/
--�μ��� salary ���� ���� ���� ���.
SELECT   emp_name, department_id, salary
        ,RANK() OVER(PARTITION BY department_id
                     ORDER BY salary DESC) as rnk
FROM employees ; 
                
SELECT emp_name, department_id, salary,
       RANK() OVER(PARTITION BY department_id 
                    ORDER BY salary DESC) AS rnk,                                      --������ ���� ������� 1,2,2,4                
       DENSE_RANK() OVER(PARTITION BY department_id
                    ORDER BY salary DESC) AS dense_rnk, --������ ���� ������� 1,2,2,3
       ROW_NUMBER() OVER(PARTITION BY department_id
                    ORDER BY salary DESC) AS runm --rownum ����
FROM employees;
   
SELECT department_id
      ,emp_name
      ,salary
      ,SUM(salary) OVER(PARTITION BY department_id) as �μ��հ�
      ,ROUND(AVG(salary) OVER(PARTITION BY department_id),2) as �μ����
      ,MIN(salary) OVER(PARTITION BY department_id) as �μ��ּ�
      ,MAX(salary) OVER(PARTITION BY department_id) as �μ��ִ�
      ,COUNT(employee_id) OVER() as ������
FROM employees;
--�μ��� salary ���������������� ��ŷ 1���� ����Ͻÿ�
SELECT *
FROM(    
        SELECT department_id, emp_name, salary
               ,DENSE_RANK() OVER(PARTITION BY department_id
                             ORDER BY salary DESC) AS dense_rnk
FROM employees
)
WHERE dense_rnk = 1;

--ȸ���� ������ ���ϸ��� ������ ����Ͻÿ�(member)
SELECT mem_name,mem_job, mem_mileage
      ,RANK() OVER(PARTITION BY mem_job
       ORDER BY mem_mileage DESC) AS RANK
FROm member;

--LAG ����ο��� ���� �����ͼ� ��ȯ
--LEAD ����ο��� ���� �����ͼ� ��ȯ
SELECT  mem_name,mem_job, mem_mileage           --mem_name�� ���, 1�� ���� , ������� ���
       ,LAG(mem_name, 1,'�������') OVER (PARTITION BY mem_job
                                          ORDER BY mem_mileage DESC) lags
       ,LEAD(mem_name, 1,'���峷��') OVER (PARTITION BY mem_job
                                          ORDER BY mem_mileage DESC) leads                                   
FROM member; 

--�л����� ������ �� �л��� ������ �Ѵܰ� ���� �л����� ���� ���̸� ����Ͻÿ�
SELECT �̸�, ����, ���� AS ��������,
       LAG(�̸�, 1, '1��')  OVER(PARTITION BY ���� ORDER BY ���� DESC)        AS ����̸�,
       LAG(����, 1, ����)   OVER(PARTITION BY ���� ORDER BY ���� DESC) - ���� AS ����
FROM �л�;


--CART, PROD�� Ȱ���Ͽ� ��ǰ�� PROD_SALE �հ� ������ ����Ͻÿ� (���� ���� �ǳʶ�)
--�����Լ�,�м��Լ� ���
SELECT a.*
        ,RANK() OVER(ORDER BY sale_sum DESC) as rnk
FROM(
    SELECT b.prod_id
          ,b.prod_name
          ,SUM(b.prod_price * a.cart_qty) as sale_sum
    FROM cart a, prod b
    WHERE a.cart_prod = b.prod_id
    GROUP BY b.prod_id
        ,b.prod_name
)   a;
---------------------------------------
SELECT b.prod_id
          ,b.prod_name
          ,SUM(b.prod_price * a.cart_qty) as sale_sum
          ,RANK() OVER(ORDER BY SUM(b.prod_price * a.cart_qty) DESC) as rnk
FROM cart a, prod b
WHERE a.cart_prod = b.prod_id
GROUP BY b.prod_id
        ,b.prod_name;









