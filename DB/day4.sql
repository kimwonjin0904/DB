--1.member ������ ���弼��
        --user id : member, password: member
        --���ѵ� �ο��ؾ� ����&���̺� ���� ����
ALTER SESSION SET "_ORACLE_SCRIPT" = true;        
CREATE USER member IDENTIFIED BY member;    
GRANT CONNECT, RESOURCE TO member;
GRANT UNLIMITED TABLESPACE TO member;
--2.�ش� �������� ����(java����)
        --java�������� (3)�� �������� ���ÿ�

--3.member_table(utf-8).sql ���� �����Ͽ� (���̺� ���� �� ������ ����)
        --SELECT *
        --FROM member
        --WHERE mem_id= 'a001';


/*������ ���۾� DMl
  Data Mainpulation Language
  ���̺� ������ �˻�, ���� ,���� ,������ ���
  SELECT< INSERT, UPDATE, DELETE, MERGE(����)
  */
--�� ������ >, < , >=, <=, <>. !=, ^= 
SELECT *FROM employees WHERE salary = 2600;      --����
SELECT *FROM employees WHERE salary <> 2600;     --���� �ʴ�
SELECT *FROM employees WHERE salary != 2600;     --���� �ʴ�
SELECT *FROM employees WHERE salary ^= 2600;     --���� �ʴ�
SELECT *FROM employees WHERE salary < 2600;      --�̸�
SELECT *FROM employees WHERE salary > 2600;      --�ʰ�
SELECT *FROM employees WHERE salary <= 2600;     --����
SELECT *FROM employees WHERE salary >= 2600;     --�̻�

--�� �����ڸ� �̿��Ͽ� PRODUCTS ���̺���(�ݾ� ��������)
--��ǰ �����ݾ�(prod_min_price)�� 30 '�̻�' 50 '�̸�'�� '��ǰ��'�� ��ȸ�Ͻÿ�.
SELECT *
FROM products;

desc products;

    SELECT prod_name                   --��ǰ��
        ,prod_min_price                --����
FROM products
WHERE prod_min_price >=30              --30�̻�
AND prod_min_price   < 50              --50�̸� ���� �߰��Ҷ��� AND
ORDER BY prod_min_price, prod_name;

--���� ī�װ��� 'CD-ROM'�� ���� �߰�(AND)
  SELECT prod_name                     --��ǰ��
        ,prod_min_price                --����
FROM products
WHERE prod_min_price >=30              --30�̻�
AND prod_min_price   < 50              --50�̸� ���� �߰��Ҷ��� AND
AND prod_subcategory = 'CD-ROM'        --���� ī�װ��� 'cd-rom'�� ���� �߰�
ORDER BY prod_min_price, prod_name;


----������ 10, 20�� �μ��� ������ ��ȸ�Ͻÿ�(�̸�, �μ���ȣ, ����) AND ���� OR ���
SELECT emp_name
     , department_id
     , salary
FROM employees
WHERE department_id = 10
OR    department_id = 20;       or�Ǵ�

--ǥ���� CASE��(END�� �������ؾ���)
--table�� ���� Ư�� ���ǿ� ���� �ٸ��� ǥ���ϰ� ������ ���
--salary�� 5000���� C���, 5000�ʰ� 15000���� B���, 15000�ʰ� A���
SELECT emp_name
      ,salary
      ,CASE WHEN salary <= 5000 THEN 'C���'    
            WHEN salary >  5000 AND salary <= 15000 THEN 'B���'
        ELSE 'A���'                           --�� �ۿ�~
       END as salary_grade
FROM employees
ORDER BY salary DESC;                          --DESC�� ���ϴ°�???

--�� ���ǽ� AND OR NOT
SELECT emp_name
      ,salary
FROM employees
WHERE NOT (salary >= 2500);                     --NOT �ݴ�Ǵ� ���� 2500�� �ƴҶ�

--IN ����(OR �� ������)
SELECT emp_name, department_id
FROM employees
WHERE department_id IN(10, 20, 30, 40)         --�Ǵ� ������ ������ ���
WHERE department_id NOT IN(10, 20, 30, 40);     --�ش� ������ �ƴ� (NOT)



--BETWEEN a AND b ���ǽ� a~b����
SELECT emp_name, salary
FROM employees
WHERE salary BETWEEN 2000 AND 2500;



--LIKE ������ % <-- ���
SELECT emp_name
FROM employees
--WHERE emp_name LIKE 'A%';                       --A�� �����ϴ� ��� ~
--WHERE emp_name LIKE '%a';                      --%�� �տ� ������ a�� ������ ���~
WHERE emp_name LIKE '%a%';                        --a�� �ִ� ���

CREATE TABLE ex2_1(                                     --ex_1���̺� �����
    nm VARCHAR2(30)
);
INSERT INTO ex2_1 VALUES('���ؼ�');                        --�࿡ ����
INSERT INTO ex2_1 VALUES('�ؼ�');
INSERT INTO ex2_1 VALUES('�ؼ���');
INSERT INTO ex2_1 VALUES('�����ؼ�');

SELECT *
FROM ex2_1
WHERE nm Like '�ؼ�_';                               --�ڸ��� _


--member ���̺� ȸ�� �� �达 ������(���̵�, �̸�, ���ϸ���, ����) ��ȸ�Ͻÿ�
SELECT mem_id
      ,mem_name
      ,mem_mileage
      ,mem_bir
FROM member
WHERE mem_name LIKE '��%';



--memberȸ���� ������ ��ȸ�ϼ���
--�� mem_mileage 6000�̻� vip
--6000�̸� 3000�̻� gold 
--�׹ۿ� silver�� ���(grade)
--���̵�,�̸�, ����, ��� ,�ּ� (add1 + add2)���(addr)
SELECT mem_id
      ,mem_name
      ,mem_job
      ,mem_mileage
      ,CASE WHEN mem_mileage >= 6000 THEN   'VIP'
            WHEN mem_mileage <= 6000 AND mem_mileage >= 3000 THEN 'GOLD'
            ELSE'SILVER'
            END as grade
      ,mem_add1 || mem_add2 as addr                 --�ּ����
FROM member
ORDER BY mem_mileage DESC;
--ORDER BY 4 DESC, 2 ASC; --���ڴ� select ���� ���� ������ ��밡��



--null ��ȸ�� IS NULL or IS NOT NULL�� ����
SELECT prod_name
      ,pord_size
FROM prod
WHERE prod_size IS NULL;          --null�� ������ �˻�    
--WHERE prod_size = null;         --x�˻��ȵ�
--WHERE prod_size IS NOT null;         --null�� �ƴ� ������ �˻�

     
    
 --���� �ߴ� Ǯ��    
-- CASE WHEN mileage >  6000 THEN 'VIP'
--     WHEN mileage <  6000
--   AND  mileage >= 3000 THEN 'gold'
-- ELSE 'sliver'
--END as mileage_grade
--FROM member
--ORDER BY mileage DESC;




--���� �Լ�
SELECT ABS(10)
      ,ABS(-10)
FROM dual;              -- <--dual�ӽ� ���̺�� ����
                        --(sql ��� ������ from �ڿ��� table �����ؾ��ؼ� ���)

--CEIL �ø�, FLOOR ����, ROUND �ݿø�
SELECT CEIL(10.01)
        ,ROUND(10.01)
        ,FLOOR(10.01)
FROM dual;
--ROUND(n, i) �Ű����� n�� �Ҽ��� i+1 ��°���� �ݿø��� ����� ����
--          i�� ����Ʈ 0, i �� ������ �Ҽ����� �������� ���� i��°���� �ݿø�
SELECT ROUND(10.154, 1)         --10.2���
      ,ROUND(10.154, 2)         --10.15���
      ,ROUND(10.154, -1)        --10���
FROM dual;



--mod(m,n) m�� n���� ���������� ������ ��ȯ      0��µ�
SELECT MOD(4,2)
      ,MOD(4,2)
FROM dual;


--SQRT n�� ������ ��ȯ
SELECT SQRT(4)
      ,SQRT(8)
      ,ROUND(SQRT(8), 2)                --2.83��µ�.
FROM dual;



--�����Լ�
SELECT LOWER('HI')              --�ҹ��ڷ� ����
      ,UPPER('hi')              --�빮�ڷ� ����
FROM dual;

--�����Լ� ����1. (�˻��ɶ� ��ҹ��� ����)
SELECT   emp_name
        ,LOWER(emp_name)
        ,UPPER(emp_name)
FROM employees;

--�̸��� smith�� �ִ� ���� ��ȸ
--nm <--�˻����ǿ� :������ (���ε� �׽�Ʈ�� ������ ���� ���̽��� �׽�Ʈ�Ҷ� ���)
SELECT emp_name             --�̸���ȸ
FROM employees                
--WHERE LOWER(emp_name) LIKE '%' || LOWER('%smIth%') || '%';
WHERE LOWER(emp_name) LIKE '%' || LOWER(:nm) || '%';            --:nm�� ���� ������Է¹���(�����̸��� ����)





SELECT SUBSTR('ABCDEFG', 1, 4)       --a���� 4�ڸ� 
      ,SUBSTR('ABCDEFG', -4, 3)
      ,SUBSTR('ABCDEFG', -4, 1)
      ,SUBSTR('ABCDEFG', 5)          --5��°���� �� ���
FROM dual;
--substr(char, pos, len) char�� pos��° ���ں��� len ���̸�ŭ �ڸ� �� ��ȯ
--len�� ������ pos���� ������ 
--len�� ������ �ڿ��� ���� 



--ȸ���� ������ ����Ͻÿ�
--�̸�, ���� (�ֹι�ȣ ���ڸ� ù° �ڸ� Ȧ�� (����), ¦�� (����))
SELECT mem_name
      ,mem_regno2
      ,SUBSTR(mem_regno2, 1,1)
      ,MOD(SUBSTR(mem_regno2, 1,1) ,2)
      ,CASE WHEN MOD(SUBSTR(mem_regno2, 1,1) ,2) = 0 THEN '����'
      ELSE '����'
      END as gender
FROM member;





/*       ���ǳ���, ����, ����, ��������, �л� ���̺��� ����ð� �Ʒ��� ���� ���� ������ �� �� 
        (1)'�л�' ���̺��� PK Ű��  '�й�'���� ����ش� 
        (2)'��������' ���̺��� PK Ű�� '����������ȣ'�� ����ش� 
        (3)'����' ���̺��� PK Ű�� '�����ȣ'�� ����ش� 
        (4)'����' ���̺��� PK Ű�� '������ȣ'�� ����ش�
        (5)'���ǳ���'�� PK�� '���ǳ�����ȣ'�� ����ش�. 

        (6)'�л�' ���̺��� PK�� '��������' ���̺��� '�й�' �÷��� �����Ѵ� FK Ű ����
        (7)'����' ���̺��� PK�� '��������' ���̺��� '�����ȣ' �÷��� �����Ѵ� FK Ű ���� 
        (8)'����' ���̺��� PK�� '���ǳ���' ���̺��� '������ȣ' �÷��� �����Ѵ� FK Ű ����
        (9)'����' ���̺��� PK�� '���ǳ���' ���̺��� '�����ȣ' �÷��� �����Ѵ� FK Ű ����
            �� ���̺� ���� �����͸� ����Ʈ 

    ex) ALTER TABLE �л� ADD CONSTRAINT PK_�л�_�й� PRIMARY KEY (�й�);
        
        ALTER TABLE �������� 
        ADD CONSTRAINT FK_�л�_�й� FOREIGN KEY(�й�)
        REFERENCES �л�(�й�);

*/
CREATE TABLE ���ǳ��� (
     ���ǳ�����ȣ NUMBER(3)
    ,������ȣ NUMBER(3)
    ,�����ȣ NUMBER(3)
    ,���ǽ� VARCHAR2(10)
    ,����  NUMBER(3)
    ,�����ο� NUMBER(5)
    ,��� date
);

CREATE TABLE ���� (
     �����ȣ NUMBER(3)
    ,�����̸� VARCHAR2(50)
    ,���� NUMBER(3)
);

CREATE TABLE ���� (
     ������ȣ NUMBER(3)
    ,�����̸� VARCHAR2(20)
    ,���� VARCHAR2(50)
    ,���� VARCHAR2(50)
    ,�ּ� VARCHAR2(100)
);

CREATE TABLE �������� (
    ����������ȣ NUMBER(3)
    ,�й� NUMBER(10)
    ,�����ȣ NUMBER(3)
    ,���ǽ� VARCHAR2(10)
    ,���� NUMBER(3)
    ,������� VARCHAR(10)
    ,��� DATE 
);

CREATE TABLE �л� (
     �й� NUMBER(10)
    ,�̸� VARCHAR2(50)
    ,�ּ� VARCHAR2(100)
    ,���� VARCHAR2(50)
    ,������ VARCHAR2(500)
    ,������� DATE
    ,�б� NUMBER(3)
    ,���� NUMBER
);


COMMIT;

      -- ���ǳ���, ����, ����, ��������, �л� ���̺��� ����ð� �Ʒ��� ���� ���� ������ �� �� 
      --  (1)'�л�' ���̺��� PK Ű��  '�й�'���� ����ش�
        ALTER TABLE �л� ADD CONSTRAINT PK_�л�_�й� PRIMARY KEY (�й�);
       -- (2)'��������' ���̺��� PK Ű�� '����������ȣ'�� ����ش� 
        ALTER TABLE �������� ADD CONSTRAINT PK_�л�_�������� PRIMARY KEY (��������);
       -- (3)'����' ���̺��� PK Ű�� '�����ȣ'�� ����ش� 
       ALTER TABLE ���� ADD CONSTRAINT PK_�л�_�����ȣ PRIMARY KEY (�����ȣ);
        --(4)'����' ���̺��� PK Ű�� '������ȣ'�� ����ش�
        ALTER TABLE ���� ADD CONSTRAINT PK_�л�_������ȣ PRIMARY KEY (������ȣ);
        --(5)'���ǳ���'�� PK�� '���ǳ�����ȣ'�� ����ش�. 
        ALTER TABLE ���ǳ��� ADD CONSTRAINT PK_�л�_���ǳ�����ȣ PRIMARY KEY (���ǳ�����ȣ);
        --(6)'�л�' ���̺��� PK�� '��������' ���̺��� '�й�' �÷��� �����Ѵ� FK Ű ����
         ADD CONSTRAINT FK_�л�_�й� FOREIGN KEY(�й�)
        --(7)'����' ���̺��� PK�� '��������' ���̺��� '�����ȣ' �÷��� �����Ѵ� FK Ű ���� 
        ADD CONSTRAINT FK_�л�_���� FOREIGN KEY(����)
        --(8)'����' ���̺��� PK�� '���ǳ���' ���̺��� '������ȣ' �÷��� �����Ѵ� FK Ű ����
        ADD CONSTRAINT FK_�л�_���� FOREIGN KEY(������ȣ)
        --(9)'����' ���̺��� PK�� '���ǳ���' ���̺��� '�����ȣ' �÷��� �����Ѵ� FK Ű ����
        ADD CONSTRAINT FK_�л�_���� FOREIGN KEY(�����ȣ)
         --   �� ���̺� ���� �����͸� ����Ʈ 

   
       
        REFERENCES �л�(�й�);



        







