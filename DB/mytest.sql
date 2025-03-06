create_dt DATE DEFAULT SYSDATE  -- create���� �߰��ϸ� ���൹����¥�� ��


--ex1_4��ü �� ������Ʈ ��
UPDATE ex1_4
SET age = 10   --set�Լ��� ���� �����Ҷ�  
WHERE mem_id = 'a001';

--a001 age ����(�����Ǿ����� Ȯ��)
SELECT *
FROM ex1_4
WHERE mem_id= 'a001';

--��ȸ--
SELECT *
FROM employees;
------------------

DESC employees;
-----------------

SELECT emp_name
FROM employees;
----------------
--DISTINCT�� �ߺ� ����
SELECT DISTINCT emp_name
FROM employees;

SELECT emp_name
FROM employees;


--ORDER BY(�������� ������ ������ Ŀ��)--
SELECT manager_id
FROM employees
ORDER BY manager_id;




--DESC(�������� ���� ������ Ŀ��)--
SELECT manager_id
FROM employees
ORDER BY manager_id DESC;




--ASC--
SELECT manager_id, employee_id
FROM employees
ORDER BY manager_id  ASC, employee_id DESC;     //manager_id(��������)   employee_id(��������)




--WHERE(���ϴ� �κи� �˻�)--
--manager_id�� 124�ΰ͸� �˻�--
SELECT *
FROM employees
WHERE manager_id = 124;

--WHERE ������ 3000�̻� ���Ҷ�
SELECT *
FROM employees
WHERE salary >= 3000;


--AND ������ ���� ���--(�� �ȳ�����????????????????????????????????)
SELECT *
FROM employees
WHERE SALARY >2660 
AND SALARY < 4800;


--WHERE, AND(2000~3000���� ������ ���)--
SELECT salary
FROM employees
WHERE salary > 2000
AND salary < 3000;
--BETWEEN A AND B ������(2000~3000���� ������ ���)--
SELECT salary
FROM employees
WHERE salary BETWEEN 2000 AND 3000;





--OR---
SELECT   salary 
        ,manager_id
FROM employees
WHERE salary = 4800
OR manager_id = 124 ;

--OR�����ڸ� �̿��ؼ� ������ ���� (�� 3�� ����)
SELECT *
FROM employees
WHERE salary = 2600
OR  salary = 10000
OR  salary = 6000;





----NOT IN ������----2600,600,10000�� ������ ������ ���
SELECT salary
FROM employees
WHERE salary NOT IN (2600, 6000, 10000);


--IN (2600,600,10000�� �������� ���)
SELECT salary
FROM employees
WHERE salary IN (2600, 6000, 10000);



--LIKE ������(D�ν����ϴ� �̸� �˻��Ͽ� ���)--
--����˻����--
SELECT *
FROM employees
WHERE emp_name LIKE 'D%';
--�� ��° ���ڰ� D�� ���ã��  '_D%'
SELECT *
FROM employees
WHERE emp_name LIKE '_D%';
--NOT LIKE�� ���� D�� ��� ���� �˻��Ͽ� ���
SELECT emp_name
FROM employees
WHERE emp_name NOT LIKE 'D%';



--UNION ������(�ߺ�������)--
//1.
SELECT goods
FROM exp_goods_asia
WHERE country ='�ѱ�'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country ='�Ϻ�';
//2.
SELECT emp_name, email, salary, manager_id
FROM employees
WHERE manager_id = 101
UNION
SELECT emp_name, email, salary, manager_id
FROm employees
WHERE manager_id = 100
;
---OR(�ߺ��״�����)
SELECT emp_name, email, salary, manager_id
FROM employees
WHERE manager_id = 100
OR manager_id = 101
;


SELECT *
from employees;
--UNION�� �̿��Ͽ� D��P�� �̸��� �ִ� ��� ã��
SELECT emp_name, email, salary, manager_id
FROM employees
WHERE emp_name LIKE  'D%'
UNION
SELECT emp_name, email, salary, manager_id
FROM employees 
WHERE emp_name LIKE '%P'
;


--UNION ALL(��°���� ������)
--�ߺ�  �����Ͽ� ���
SELECT *
FROM employees
WHERE email Like '%D'
UNION ALL
SELECT *
FROM employees
WHERE email Like '%D'
;


--MINUS �� 2�� �϶�
--NOT IN�� 1�� �������϶� 

//1.NOT IN(2600���� ���)
SELECT salary
FROM employees
WHERE salary NOT IN 2600;
//2.MINUS(2600���� ���)
SELECT salary
FROM employees
MINUS 
SELECT salary
FROM employees
WHERE salary = 2600
;



--INTERSECT ���տ�����(������� ���������͸� ���)
SELECT salary
FROM employees
INTERSECT
SELECT salary
FROM employees
WHERE salary = 2600
;



--UPPER, LOWER, INITCAP(���ڿ�)
--�빮��,�ҹ���,ù���ڴ� �빮�� �������� �ҹ��ڷ� ��ȯ�Լ�
SELECT UPPER(emp_name), LOWER(emp_name),INITCAP(emp_name)
FROm employees;
-------donald oconnell�˻� �� INITCAP�� �̿��Ͽ� �ٲٱ� ----------
SELECT INITCAP(emp_name) 
FROM employees
WHERE INITCAP(emp_name) LIKE INITCAP('%donald oconnell%');






--���ڿ� ���� ���ϴ� LENGTH �Լ�--
SELECT emp_name, LENGTH(emp_name)
FROM employees
WHERE LENGTH(emp_name)  = 12             --���ڿ� 12 �� emp_name���ڿ� ���� ã��
OR    LENGTH(emp_name) = 11
ORDER BY LENGTH(emp_name) DESC            --�������� �������� ORDER BY DESC�� ���� �޶���
;


--SUBSTR(���ڿ� �Ϻ� ����)
SELECT SUBSTR(emp_name, 1,3)  -- emp_name�� ������ ��� 
FROM employees;
SELECT SUBSTR(emp_name, 3)  -- emp_name�� ����° ���ں��� ������ ���
FROM employees;


--SUBSTR�� LENGTH ��� ����ϱ� (���� ���� �ȵ�)
SELECT 
       SUBSTR(emp_name , LENGTH(emp_name),1)
      ,SUBSTR(emp_name,-LENGTH(emp_name),2)
      , SUBSTR(emp_name ,2, LENGTH(emp_name))
FROm employees;


--INSTR(Ư�� ���ڿ� ��ġ ã��)--   
SELECT 
     INSTR('HELLO,oracle', 'L')   �� -- 'L'�� ó�� �����ϴ� ��ġ
    ,INSTR('HELLO,oracle', 'L', 5)  ��-- 5��° ���ں��� �˻�
    ,INSTR('HELLO,oracle', 'L', 2, 2) �� -- 2��° ���ں��� 2��°�� �����ϴ� 'L' ã��
FROM DUAL;                                --DUAL��  ���̺��� �������������� ���



--INSTR�� D�� �ִ� �� ���ϱ�
SELECT emp_name
FROM employees
WHERE INSTR(emp_name, 'D') > 0
;
--LIKE�� �̿��Ͽ� D�� �� ��� ���ϱ�
SELECT emp_name 
FROM employees
WHERE emp_name LIKE '%D%';

--REPLACE--p139
--REPLACE(���ڿ�, ã�°�, �ٲٰ� �� ���� )--
SELECT '010-6305-9403' AS ��ȣ
    ,REPLACE('010-6305-9403', '-',' ') AS replace1          -- -�� ���ְ� ������ ����
    ,REPLACE('010-6305-9403', '-') AS replace2              -- -�� ���� �߰� x
FROM DUAL;

--RPAD �� ������ Ư�����ڷ� ä���--p141
SELECT   
    RPAD('971225-' , 14 ,'*') AS �ֹ�,  -- '971225-' �ڿ� '*'�� �߰��Ͽ� �� 14�ڸ��� ���� (���: '971225-*******')
    RPAD('010-12334' , 13, '*') AS ��   -- '010-12334' �ڿ� '*'�� �߰��Ͽ� �� 13�ڸ��� ���� (���: '010-12334****')
FROM dual;


--CONCAT(142p)
--�ο� ���̿� �ݷ� �ְ� �����ϱ�--
SELECT CONCAT('�����', '��') AS ����_���ڿ�,  
       CONCAT(CONCAT('kimwonjin', ':'),'�����') AS ����_���� -- ? `CONCAT()`�� �ϳ��� ���ڸ� ���� �� ���� (���� �߻�)
FROM dual;
-----CONCAT ����---
SELECT   CONCAT(emp_name, email)               -- emp_name + email ����
        ,CONCAT(emp_name, CONCAT(':',email))   --emp_name : email (:����)
FROM employees
WHERE emp_name LIKE '%D%';

/* 
    TRIM(p142) 
    Ư�� ���� �����
    �ٽ� ���� ??????????????????
*/
SELECT '[' || TRIM('__Oracle__') || ']' AS TRIM                  --��� : [__Oracle__]
      ,'[' || TRIM(LEADING FROM'__Oracle__') || ']' AS TRIM
FROM DUAL;


/*
    ROUND(146p)
    Ư�� ��ġ���� �ݿø� ���ִ� �Լ�
*/
SELECT ROUND(1234.5678)      as ROUND       --1235
      ,ROUND(1234.5678, 1 )  as ROUND2      --1234.6
      ,ROUND(1234.5678, -1)  as round3      --1230
      FROM dual;
      
/*
    MOD
    ������ ���� ���ϴ� �Լ�
    MOD(����1, ����2)
    ����1	���� ���� (salary)
    ����2	���� �� (20)
    ��ȯ��	����1�� ����2�� ���� ������
*/
SELECT  MOD(15,6)       --3
       ,MOD(10,2)       --0
       ,MOD(11,2)       --1
FROM dual;



/*
    SYSDATE(150p)
    ��¥ ����ϱ�
*/
SELECT  SYSDATE      ����
       ,SYSDATE -1   ����
       ,SYSDATE +2   ����
FROM dual;
      
      
/*
    ADD_MONTHS(151p)
    �� ���� ���� ��¥�� ���ϴ� �Լ�
 */ 
SELECT SYSDATE                AS ���ó�¥, 
       ADD_MONTHS(SYSDATE, 3) AS ������            --(SYSDATE, 3) ���糯¥,������
FROM dual;
--���� 1�ֳ� �Ǵ»�� ã��--
SELECT hire_date, 
       SYSDATE AS ���ó�¥, 
       ADD_MONTHS(hire_date, 12) AS "1�ֳ�"    --�ѱۻ��� ""�ʿ���
FROM employees;
//Like ��� (TO_CHAR, EXTRACT���)     
SELECT hire_date, 
       SYSDATE AS "���ó�¥", 
       ADD_MONTHS(hire_date, 12) AS "1�ֳ�"
FROM employees
WHERE TO_CHAR(ADD_MONTHS(hire_date, 12), 'YYYY') LIKE TO_CHAR(EXTRACT(YEAR FROM SYSDATE) + 1);

/*
    MOTHS_BETWEEN(152p)
    �� ��¥���� ���� �� ���� ���ϴ� �Լ�
*/
SELECT  update_date, hire_date,
        MONTHS_BETWEEN(hire_date,update_date)
FROM employees;
--floor(148p),mod,MONTH_BEWTWEEN ���--
SELECT update_date, hire_date,
       FLOOR(MONTHS_BETWEEN(update_date, hire_date) / 12)     || '�� ' ||
       MOD(FLOOR(MONTHS_BETWEEN(update_date, hire_date)), 12) || '����' AS �ټӱⰣ
FROM employees;


/*
    ���ڿ� ���ڿ� ���ϱ�(157p)
*/


/*
    TO_CHAR(158p)
    ��¥ ���� �����͸� ���� �����ͷ� ��ȯ
*/
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') as ���糯¥�ð�
FROM dual;
--
SELECT TO_CHAR(SYSDATE, 'YYYY') as �̹�����    --���: 2025
FROM employees;
--
SELECT SYSDATE
    ,TO_CHAR(SYSDATE, 'MM')  as mm
FROM dual;




/*
    TO_DATE(164p)
    ���� ������ -> ��¥ �����ͷ�
*/
SELECT TO_DATE('2018-07-14', 'YYYY-MM-DD') AS TODATE1,
       TO_DATE('20180714'  ,   'YYYYMMDD') AS TODATE2
FROM dual;
--
SELECT hire_date
FROM employees
WHERE hire_date >TO_DATE('2004-07','YYYY/MM') ;

/*
    NVL(167p)
*/

/*
    DECODE(170p)
*/
SELECT emp_name, job_id, 
       DECODE(job_id, 
              'MANAGER', '������', 
              'ENGINEER', '�����Ͼ�', 
              'CLERK', '�繫��', 
              '��Ÿ')                  AS ���޼���
FROM employees;


/*
    CASE��(172p)
    CASE	���ǹ� ����
    WHEN	���� ����
    THEN	������ ���̸� ��ȯ�� ��
    ELSE	��� ������ ������ �� ��ȯ�� ��
    END	CASE�� ����
    AS ��Ī	��� �÷��� ��Ī(�̸�) ����
*/
SELECT emp_name, salary, 
       CASE 
           WHEN salary >= 5000 THEN '��� ����'
           WHEN salary >= 3000 THEN '�߰� ����'
           ELSE '������'
       END AS �޿����
FROM employees;

/*
    SUM(177)
    distinct �ߺ�����
*/
select SUM(salary)  --salary�� �ִ� �͵��� �� ���� ���� ���
from employees;

select   sum(distinct salary)         --salary������ distinct�� ���� �ߺ��� ���� ����
        ,sum(all salary)
        ,sum(salary)
from employees;

/*
    COUNT(180)
    ���̺� ������ ���� ����
*/
select count(emp_name) --employees�� �ִ� �����ٿ��ִ� ���� ���
from employees;
//
select distinct count(salary)   --�ߺ��Ȱ� ���� ������ ���� ���
,count(salary)                  -- ������ ���� ���
from employees;

/*
    MIN,MAX(183)
*/
SELECT max(salary) AS �ִ�, 
       min(salary) AS �ּڰ�, 
       max(salary) - min(salary) AS �޿�����,
       avg((salary)) as ��ձ޿�,  
       ROUND(avg(salary),2) as ��ձ޿�2
FROM employees;
-----------
select max(hire_date)
from employees
where Max(salary);

-------------
SELECT hire_date, MAX(salary) AS highest_salary
FROM employees
WHERE hire_date = '05/09/30' -- ���ϴ� �Ի� ��¥
GROUP BY hire_date;

--------GROUP BY----------------
SELECT max(salary), hire_date   --2005-09-30��¥�� �Ի��� ����� ���� ���� ���� �޴� ��� ���
FROM employees
WHERE hire_date = '2005-09-30' 
GROUP BY hire_date;

---------HAVING COUNT(-���� �Ի��� ����� 2���̻��� ��¥ ���)-----------------------
SELECT hire_date           
FROM employees
GROUP BY hire_date
HAVING COUNT(hire_date) > 2; --���:02/06/07

--02/06/07��¥ ã�ƺ��� ���� �˻�--
SELECT hire_date            
FROM employees
where hire_date = '02/06/07';
--
select hire_date
from employees
group by hire_date
having count(hire_date) > 1;

-----------

select hire_date
form employees
where hire_date = '07/02/07'
and hire date = '02/06/07'
;

----SELECT hire_date            
FROM employees
where hire_date = '02/06/07';
--

