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
         REFERENCES �л�(�й�);
       -- (2)'��������' ���̺��� PK Ű�� '����������ȣ'�� ����ش� 
        ALTER TABLE �������� ADD CONSTRAINT PK_�л�_�������� PRIMARY KEY (��������);
         REFERENCES �л�(��������);
       -- (3)'����' ���̺��� PK Ű�� '�����ȣ'�� ����ش� 
       ALTER TABLE ���� ADD CONSTRAINT PK_�л�_�����ȣ PRIMARY KEY (�����ȣ);
        REFERENCES �л�(�����ȣ);
        --(4)'����' ���̺��� PK Ű�� '������ȣ'�� ����ش�
        ALTER TABLE ���� ADD CONSTRAINT PK_�л�_������ȣ PRIMARY KEY (������ȣ);
         REFERENCES �л�(������ȣ);
        --(5)'���ǳ���'�� PK�� '���ǳ�����ȣ'�� ����ش�. 
        ALTER TABLE ���ǳ��� ADD CONSTRAINT PK_�л�_���ǳ�����ȣ PRIMARY KEY (���ǳ�����ȣ);
         REFERENCES �л�(���ǳ�����ȣ);
        --(6)'�л�' ���̺��� PK�� '��������' ���̺��� '�й�' �÷��� �����Ѵ� FK Ű ����
         ADD CONSTRAINT FK_�л�_�й� FOREIGN KEY(�й�)
          REFERENCES �л�(�й�);
        --(7)'����' ���̺��� PK�� '��������' ���̺��� '�����ȣ' �÷��� �����Ѵ� FK Ű ���� 
        ADD CONSTRAINT FK_�л�_���� FOREIGN KEY(����)
        REFERENCES �л�(����);
        --(8)'����' ���̺��� PK�� '���ǳ���' ���̺��� '������ȣ' �÷��� �����Ѵ� FK Ű ����
        ADD CONSTRAINT FK_�л�_���� FOREIGN KEY(������ȣ)
         REFERENCES �л�(������ȣ);
        --(9)'����' ���̺��� PK�� '���ǳ���' ���̺��� '�����ȣ' �÷��� �����Ѵ� FK Ű ����
        ADD CONSTRAINT FK_�л�_���� FOREIGN KEY(�����ȣ)
         REFERENCES �л�(�����ȣ);
         --   �� ���̺� ���� �����͸� ����Ʈ 

   
       
---------------------------
--�������� TRIM LTRIM RTRIM
SELECT LTRIM(' ABC ') as l
      ,LTRIM(' ABC ') as r          --����   ���� ���� L
      ,RTRIM(' ABC ') as r          --������ ���� ����R
      ,TRIM('ABC') as al
FROM dual;


--���ڿ� �е�(LPAD, RPAD)
SELECT LPAD(123, 5, '0')     as lpl1         --LAPD(���, ����, �е�)���� ��ŭ
      ,LPAD(1,   5, '0')     as lpl2
      ,LPAD(123456, 5, '0')  as lpl3         --���� ���̸�ŭ(�Ѿ�� ���ŵ�)
      ,RPAD(2,5, '*')        as rp1          --R�� �����ʺ���  (???�ѹ��� ����)
FROM dual;


--REPLACE(���,ã��,����)
--TRANSLATE �ѱ��ھ� ��Ī
SELECT REPLACE  ('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?', '����', '�ʸ�') as re  --????
      ,TRANSLATE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?', '����', '�ʸ�') as tr --????
FROM dual;


--INSTR ���ڿ� ��ġ ã��(p1, p2, p3, p4) p1:����ڿ�,  p2:ã�� ���ڿ�, p3:����, p4 °
SELECT INSTR('�ȳ� ������ �ݰ���, �ȳ��� hi', '�ȳ�')        as ins1  -- �⺻�� (1,1)
      ,INSTR('�ȳ� ������ �ݰ���, �ȳ��� hi', '�ȳ�', 5)     as ins2  -- 5��° ���ں��� �˻�
      ,INSTR('�ȳ� ������ �ݰ���, �ȳ��� hi', '�ȳ�', 1, 2)  as ins3  -- 1��° ���ں���, 2��° '�ȳ�' ã��
      ,INSTR('�ȳ� ������ �ݰ���, �ȳ��� hi', 'hello')       as ins4  -- ������ 0 ��ȯ
FROM dual;



--tb_info �л��� �̸��� �ּҸ�(idm domain���� �и��Ͽ� ����Ͻÿ�)
--pangsu@gmail.com-->> id:pansu, domain:gmail.com

SELECT nm, email
        --,INSTR(email, '@') -1
        ,SUBSTR(email, 1, INSTR(email, '@') -1) as ���̵�
        ,SUBSTR(email, INSTR(email, '@')    +1) as ������
FROM tb_info;        
 
--���� Ǯ���� ��
SELECT nm, email
       ,SUBSTR('pangsu@gmail.com',6) as ���̵�
       ,SUBSTR('pangsu@gmail.com',8) as ������
FROM tb_info;

---------------------------------------------------
SELECT SUBSTR('ABCDEFG', 1, 4)       --a���� 4�ڸ� 
      ,SUBSTR('ABCDEFG', -4, 3)
      ,SUBSTR('ABCDEFG', -4, 1)
      ,SUBSTR('ABCDEFG', 5)          --5��°���� �� ���
FROM dual;
--substr(char, pos, len) char�� pos��° ���ں��� len ���̸�ŭ �ڸ� �� ��ȯ
--len�� ������ pos���� ������ 
--len�� ������ �ڿ��� ���� 
--shift tab





/* ��ȯ�Լ�(Ÿ��) ���� �����.(��¥ �ð� ���� TOCHAR)
TO_CHAR ���������� 
TO_DATE ��¥
TO_NUMBER ����~
*/
SELECT TO_CHAR(123456,  '999,999,999')              as ex1
      ,TO_CHAR(SYSDATE, 'YYYY-MM-DD')               as ex2
      ,TO_CHAR(SYSDATE, 'YYYYMMDD')                 as ex3
      ,TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')    as ex4
      ,TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')    as ex5
      ,TO_CHAR(SYSDATE, 'day')                      as ex6
      ,TO_CHAR(SYSDATE, 'YY')                       as ex7
      ,TO_CHAR(SYSDATE, 'DD')                       as ex8
      ,TO_CHAR(SYSDATE, 'd')                        as ex9  --����
FROM dual;


--TODATE 
SELECT TO_DATE('231229', 'YYMMDD')                              as ex1
      ,TO_DATE('2025 01 21 09:10:00', 'YYYY MM DD HH24:MI:SS') as ex2
      ,TO_DATE('45','YY')                                       as ex3
      ,TO_DATE('50', 'RR')                                      as ex4
      ,TO_DATE('49','RR')   --Y2k 2000�� ������ ���� ����å���� ���Ե�. 50-> 1950, 49-> 2049
FROM dual;


--ex5_1 ���̺� ����
CREATE TABLE ex5_1(
    seq1 VARCHAR2(100)
   ,seq2 NUMBER
);
--����p 160  TO NUMBER
INSERT INTO ex5_1 VALUES('1234','1234');
INSERT INTO ex5_1 VALUES('99','99');
INSERT INTO ex5_1 VALUES('195','195');
SELECT *
FROM ex5_1
ORDER BY TO_NUMBER(seq1) ASC;
//ORDER BY seq2 ASC;


--ex5_2���̺� ����
CREATE TABLE ex5_2(
     title VARCHAR2(100)
    ,d_day DATE
);
INSERT INTO ex5_2 VALUES('������','20250121');                 --VALUES�� ��� ���??? INSERT INTO???
INSERT INTO ex5_2 VALUES('������','2025.07.09');

SELECT *
FROM ex5_2;

INSERT INTO ex5_2 VALUES('ź�ұ���','2025.02.24');
INSERT INTO ex5_2 VALUES('���Ư��','2025.03.31 10:00:00');  --������
INSERT INTO ex5_2 VALUES('ź�ұ���',TO_DATE('2025.03.31 10:00:00', 'YYYY MM DD HH24:MI:SS'));



--ȸ���� ��������� �̿��Ͽ� ���̸� ����ϼ���
--���� �⵵�̿�(ex 2025- 2000) 25��
--������  mem_bir ��������.
--TO_CHAR
SELECT mem_name
     , mem_bir
     , TO_CHAR(mem_bir, 'YYYY') as ����⵵
     , TO_CHAR(SYSDATE, 'YYYY') as ����⵵
     , TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(mem_bir, 'YYYY') || '��' as ����
FROM member
ORDER BY mem_bir DESC;


SELECT *
FROM member;




/*��¥ ������ Ÿ�� ���� �Լ�
 ADD_MONTHS(��¥,1)���� ��
 LAST_DAY(��¥) �ش� ���� ������ ��
 NEXT_DAY('��¥', '����')����� �ش� ������ ��¥
*/
SELECT ADD_MONTHS(SYSDATE, 1)      as ex1      -- ������
      ,ADD_MONTHS(SYSDATE, -1)     as ex2      -- ����
      ,LAST_DAY(SYSDATE)           as ex3      -- �̹� ���� ������ ��
      ,NEXT_DAY(SYSDATE, '�ݿ���') as ex4      -- ���� �ݿ���
      ,NEXT_DAY(SYSDATE, '�����') as ex5      -- ���� �����
      ,SYSDATE  -1                 as ex6       --����  (-1�� �Ϸ� �� �Ϸ�����)
      ,ADD_MONTHS(SYSDATE, 1) - ADD_MONTHS(SYSDATE, -1) as ex7
FROM dual;



SELECT SYSDATE - mem_bir
      ,SYSDATE sy
      ,mem_bir
      ,TO_CHAR(SYSDATE, 'YYYYMMDD') - TO_CHAR(mem_bir, 'YYYYMMDD')                   as ex1 --���ڰ��
      ,TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) - TO_DATE(TO_CHAR(mem_bir, 'YYYYMMDD')) as ex2 --���ڰ��
FROM member;



--�׷� �̹� ���� ���� ���������?
--������ ��
SELECT LAST_DAY(SYSDATE) - SYSDATE
FROM dual;
--����Ǯ���Ѱ�
SELECT ADD_MONTHS(SYSDATE, 1)      as ex1      -- ������     
      ,LAST_DAY(SYSDATE)           as ex3      -- �̹� ���� ������ ��      
      ,SYSDATE  -1                 as ex6       --����  (-1�� �Ϸ� �� �Ϸ�����)
      ,ADD_MONTHS(SYSDATE, 0)      as ex7
      ,LAST_DAY(SYSDATE) - ADD_MONTHS(SYSDATE, 0) as ex8
FROM dual;



--20250709���� �󸶳� ���������?
-----------------��------------
SELECT TO_DATE('20250709')
     , TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'))
     , TO_DATE('20250709') - TO_DATE(TO_CHAR(SYSDATE,'YYYYMMDD')) as �����ϱ���
FROM dual;


-------------------���� �� Ǯ��--------------
--1.
SELECT ADD_MONTHS(SYSDATE, 5) -12      as ex1      --  7/9
      ,LAST_DAY(SYSDATE) - ADD_MONTHS(SYSDATE, 0) as ex8  --7��
      ,LAST_DAY(SYSDATE) + ADD_MONTHS(SYSDATE, 5) -12   as ex3  
FROM dual;
--2.
SELECT TO_DATE('20250709')
      ,SYSDATE
FROM dual;
--------------------------------------------------
SELECT ADD_MONTHS(SYSDATE, 1)      as ex1      -- ������
      ,ADD_MONTHS(SYSDATE, -1)     as ex2      -- ����
      ,LAST_DAY(SYSDATE)           as ex3      -- �̹� ���� ������ ��
      ,NEXT_DAY(SYSDATE, '�ݿ���') as ex4      -- ���� �ݿ���
      ,NEXT_DAY(SYSDATE, '�����') as ex5      -- ���� �����
      ,SYSDATE  -1                 as ex6       --����  (-1�� �Ϸ� �� �Ϸ�����)
      ,ADD_MONTHS(SYSDATE, 1) - ADD_MONTHS(SYSDATE, -1) as ex7
FROM dual;




--DECODE ǥ���� Ư�� ���϶� ǥ������
SELECT *            --��ȸ
FROM customers;

SELECT cust_id
      ,cust_name
      ,cust_gender
      ,DECODE(cust_gender, 'M', '����', '����') as gender  --cust_gender�� M�̸� (true) ����, �� �ۿ��� ����
      ,DECODE(cust_gender, 'M', '����', '����','!!?') as gender  --'!!?'�̰ǹ���??
FROM customers;


----------------------------------------
SELECT *            --products��ȸ
FROM products;

--DISTINCT (�ߺ� ����)
--�ߺ��� �����͸� �����ϰ� ������ ���� ��ȯ
SELECT DISTINCT prod_category
FROM products;
--�� ������ �ߺ����� �ʴ� �� ��ȯ
SELECT DISTINCT prod_category, prod_subcategory
FROM products
ORDER BY 1;                    //order by ���� �ٽú���


--NVL(�÷�, ��ȯ��) �÷� ���� null�� ��� ��ȯ�� ����
SELECT emp_name
      ,salary
      ,commission_pct
      ,salary + salary * commission_pct         AS �󿩱�����1  -- NULL �� �߻� ���� //salary *commission_pct��������?
      ,salary + salary * NVL(commission_pct, 0) AS �󿩱�����2  -- NULL ���� ó��
FROM employees;



/*  ����
    1.employess ������ �ټӳ���� 30�� �̻��� ������ ����Ͻÿ� (�ټӳ�� ��������)
    2.customers ���� ���̸� �������� 30��, 40��, 50�븦 �����Ͽ� ���(������ ���ɴ�� '��Ÿ')
     ����(���� ��������), �˻�����(1.����, 2.����⵵:1960~1990�� ��� 3. ��ȥ����:single 5.����:��)
*/
--1������
SELECT *  --��ȸ
FROM employees;

------��-----
SELECT emp_name, hire_date
        ,TO_CHAR(SYSDATE,   'YYYY')
        ,TO_CHAR(hire_date, 'YYYY')
        ,TO_CHAR(SYSDATE,   'YYYY') - ,TO_CHAR(hire_date, 'YYYY') as �ټӳ��
FROM employees
WHERE TO_CHAR(SYSDATE,   'YYYY') - ,TO_CHAR(hire_date, 'YYYY') >= 26;
ORDER BY �ټӳ�� DESC, hire_date ASC ;
------------
SELECT emp_name, 
       hire_date,
       TO_CHAR(SYSDATE, 'YYYY') AS ����⵵,
       TO_CHAR(hire_date, 'YYYY') AS �Ի�⵵,
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM hire_date) AS �ټӳ��
FROM employees
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM hire_date) >= 26
ORDER BY �ټӳ�� DESC, hire_date ASC;




--------------������Ǯ��-----------
SELECT emp_name
      ,hire_date
      ,ADD_MONTHS(hire_date ,360) as �ټӳ��
      ,TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(hire_date, 'YYYY') as �ټӳ��2
      ,SYSDATE
     --����  ,ADD_MONTHS(hire_date ,360) as �ټӳ�� - TO_CHAR(hire_date, 'YYYY') as �ټ�
     --����
FROM employees;




--2������--
------��-----
SELECT cust_name,
       cust_year_of_birth,
       TO_CHAR(SYSDATE, 'YYYY') - cust_year_of_birth AS age,
       DECODE(TRUNC((TO_CHAR(SYSDATE, 'YYYY') - cust_year_of_birth) / 10), 
              3, '30��', 
              4, '40��', 
              5, '50��', 
              '��Ÿ') AS ����,
       cust_gender,
       cust_marital_status,
       cust_city
FROM customers
WHERE cust_city = 'Aachen'
AND cust_gender = 'M'
AND cust_marital_status IS NOT NULL  -- NULL�� �ƴ� ���� ����
AND cust_year_of_birth BETWEEN 1960 AND 1990
ORDER BY cust_year_of_birth DESC;




------�� Ǯ��-----------
SELECT cust_name
      ,cust_year_of_birth
     -- ,TO_CHAR(cust_year_of_birth, 'YYYY') as ����⵵
      --,TO_CHAR(SYSDATE, 'YYYY') as ����⵵
    -- ,TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(cust_year_of_birth, 'YYYY')  || as ����
      
FROM customers
ORDER BY cust_year_of_birth


-------------------------------------
SELECT mem_name
     , mem_bir
     , TO_CHAR(mem_bir, 'YYYY') as ����⵵
     , TO_CHAR(SYSDATE, 'YYYY') as ����⵵
     , TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(mem_bir, 'YYYY') as ����
FROM member
ORDER BY mem_bir DESC;

---------------


SELECT *            --��ȸ
FROM customers;

