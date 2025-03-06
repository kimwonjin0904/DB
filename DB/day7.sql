-- ���� ������ UNION ------------------------------------------------------------------------

CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('�ѱ�', 1, '�������� ������');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 2, '�ڵ���');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 3, '��������ȸ��');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 4, '����');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 6,  '�ڵ�����ǰ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 7,  '�޴���ȭ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 8,  'ȯ��źȭ����');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 9,  '�����۽ű� ���÷��� �μ�ǰ');
INSERT INTO exp_goods_asia VALUES ('�ѱ�', 10,  'ö �Ǵ� ���ձݰ�');

INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 1, '�ڵ���');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 2, '�ڵ�����ǰ');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 3, '��������ȸ��');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 4, '����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 5, '�ݵ�ü������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 6, 'ȭ����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 7, '�������� ������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 8, '�Ǽ����');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 9, '���̿���, Ʈ��������');
INSERT INTO exp_goods_asia VALUES ('�Ϻ�', 10, '����');


/*
    ����� ���� UNION, UNION ALL, MINUS, INTERSECT
    �÷��� ���� Ÿ�� ��ġ�ؾ���. ������ ����������
*/

SELECT goods, seq
FROM exp_goods_asia
WHERE country ='�ѱ�';

SELECT goods, seq
FROM exp_goods_asia
WHERE country ='�Ϻ�';

---------UNION �ߺ� ���� �� ����---------
SELECT goods
FROM exp_goods_asia
WHERE country ='�ѱ�'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country ='�Ϻ�';



----�Ʒ��� ���� ����Ʈ���� ��ģ�� �ѱ�+�Ϻ�(�ߺ� �������)--------------
SELECT goods
FROM exp_goods_asia
WHERE country ='�ѱ�'
UNION ALL
SELECT goods
FROM exp_goods_asia
WHERE country ='�Ϻ�'
ORDER BY 1;     --���������� ���������� ��밡��


------MINUS(�ߺ��� ���� �ʴ� �� ���)-----------
SELECT goods
FROM exp_goods_asia
WHERE country ='�ѱ�'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country ='�Ϻ�';


---------INTERSECT(�ΰ��� �࿡ ������ �ִ� �� ���)--------------------------
SELECT goods
FROM exp_goods_asia
WHERE country ='�ѱ�'
INTERSECT           --������
SELECT goods
FROM exp_goods_asia
WHERE country ='�Ϻ�';



--------------------------
SELECT goods, seq
FROM exp_goods_asia
WHERE country ='�ѱ�'
UNION
SELECT goods, seq
FROM exp_goods_asia
WHERE country ='�Ϻ�';
 

--------------
SELECT gubun
      ,SUM(loan_jan_amt)��
FROM kor_loan_status
GROUP BY ROLLUP(gubun);

--ROLLUP ���� �ʰ� �������--UNION����
SELECT   gubun 
        ,SUM(loan_jan_amt)��
FROM kor_loan_status
GROUP BY gubun
UNION
SELECT '�հ�',SUM(loan_jan_amt)
FROM kor_loan_status




/*
    1.�������� INNER JOIN ���� ���� EQUI-JOIN �̶���.
        WHERE ������ = ��ȣ ���� ����Ͽ� ������.
        A�� B���̺� ����� ���� ���� �÷��� ������ ���� ������ True��
        ��� ���� ���� ���� ����
*/
SELECT *
FROM �л�,��������
WHERE �л�.�й� = ��������.�й�
AND �л�.�̸� = '�ּ���';


----
*/
SELECT *
FROM �л� a, �������� b        --���̺� ��Ī
WHERE a.�й� = b.�й�
AND a.�̸� = '�ּ���';
-----------------------------
SELECT  a.�й�
       ,a.�̸�
       ,b.����������ȣ
       ,b.�����ȣ
       ,b.�������
FROM �л� a, �������� b        --���̺� ��Ī
WHERE a.�й� = b.�й�
AND a.�̸� = '�ּ���';


--�ּ��澾�� �� ���� ���� �Ǽ��� ����Ͻÿ�--
SELECT   a.�̸�                               --�̸� ���
        ,COUNT(b.����������ȣ)                --�������� �Ǽ��̱⶧���� COUNT
FROM �л� a, �������� b        
WHERE a.�й� = b.�й�
AND a.�̸� = '�ּ���'
GROUP BY a.�й�, a.�̸�;


---------�� Ǯ��-------------------
SELECT a.�̸�       
       ,b.����������ȣ          
FROM �л� a, �������� b        
WHERE a.�й� = b.�й�
AND a.�̸� = '�ּ���'
GROUP BY ����������ȣ;        --���� Ʋ��




-----------------------------------------------
SELECT   a.�̸�
        ,a.�й�
        ,b.���ǽ�
        ,c.�����̸�
FROM �л� a, �������� b, ���� c
WHERE a.�й� = b.�й�
AND b.�����ȣ = c.�����ȣ
AND a.�̸� = '�ּ���';


--�ּ��澾�� �� ���������� ����ϼ���--
SELECT   a.�̸�
        ,a.�й�
        ,COUNT(b.����������ȣ)   �����Ǽ�
        ,SUM(c.����)                      �Ѽ�������
FROM �л� a, �������� b, ���� c
WHERE a.�й� = b.�й�
AND b.�����ȣ = c.�����ȣ
--AND a.�̸� = '�ּ���'
GROUP BY  a.�̸� ,a.�й�;


------�������� ���� �̷°Ǽ��� ����Ͻÿ�(���ǰǼ� ��������)-------------
SELECT �����̸�, ������ȣ   
FROM ����;

SELECT ���ǳ�����ȣ, ������ȣ
FROM ���ǳ���;



-- ������ ���� �Ǽ� ��ȸ
SELECT 
    ���ǳ���.������ȣ,
    COUNT(���ǳ���.���ǳ�����ȣ) AS ���ǰǼ�
FROM ���ǳ���
GROUP BY ���ǳ���.������ȣ;
-- ������ ���� ���� ��ȸ �� ����
SELECT 
    ����.�����̸�,
    ���ǳ���.���ǳ�����ȣ
FROM ����
JOIN ���ǳ��� ON ����.������ȣ = ���ǳ���.������ȣ
ORDER BY ���ǳ���.���ǳ�����ȣ DESC;




/*
    2.�ܺ����� OUTER JOIN
        null ���� �����͵� �����ؾ� �Ҷ�
        null ���� ���Ե� ���̺� ���̹��� (+)��ȣ ���
        �ܺ������� �ߴٸ� ��� ���̺��� ���ǿ� �ɾ������.
*/
--��ȸ
SELECT *
FROM �л� a, �������� b
WHERE a.�й� = b.�й�;
---------------
SELECT a.�̸�
    ,a.�й�
    ,COUNT(b.����������ȣ) �����Ǽ�
FROM �л� a, �������� b
WHERE a.�й� = b.�й�(+)
GROUP BY a.�̸�, a.�й�;


-----------------��������
SELECT *
FROM �л� a, �������� b
WHERE a.�й� = b.�й�;
---------------
SELECT a.�̸�
      ,a.�й�
      ,b.����������ȣ  �����Ǽ�
      ,c.�����̸�
FROM �л� a, �������� b, ���� c
WHERE a.�й� = b.�й�(+)
AND b.�����ȣ = c.�����ȣ(+)


----��� ������ �����Ǽ��� ����Ͻÿ� --
SELECT *
FROM ����;

SELECT 
    ����.�����̸�,
    COUNT(���ǳ���.���ǳ�����ȣ) AS ���ǰǼ�
FROM ����
LEFT JOIN ���ǳ��� ON ����.������ȣ = ���ǳ���.������ȣ
GROUP BY ����.������ȣ, ����.�����̸�
ORDER BY ���ǰǼ� DESC;


------īƮ �̷�---------------
SELECT *
FROM member;

SELECT *
FROM cart;

SELECT a.mem_id
        ,a.mem_name
        ,COUNT(b.cart_no) as īƮ�̷�
FROM member a, cart b
WHERE a.mem_id = b.cart_member(+)
GROUP BY a.mem_id ,
         a.mem_name ;





--�����뾾�� ��ǰ �����̷� ���--
SELECT   a.mem_id
        ,a.mem_name
        ,b.cart_no as īƮ�̷�
        ,b.cart_prod
        ,b.cart_qty
     --   ,c.*  --�ش� ���̺� ��ü �÷�
        ,c.prod_name
FROM member a, cart b, prod c
WHERE   a.mem_id = b.cart_member(+)
AND     b.cart_prod = c.prod_id(+)
AND     a.mem_name = '������';


/*
    ��� ���� �����̷��� ����Ͻÿ�
    ���� �����̷��� ����Ͻÿ�
    ����ھ��̵�, �̸�, īƮ���Ƚ��, ��ǰǰ��, ��ü��ǰ���ż�, �ѱ��űݾ�
    member, cart, prod ���̺� ���(���� �ݾ��� prod_price)�� ���
    ����(īƮ���Ƚ��)
*/
SELECT   
    a.mem_id,                    
    a.mem_name,                         
    COUNT(DISTINCT b.cart_no)                        AS īƮ���Ƚ��,
    COUNT(DISTINCT b.cart_prod)                      AS ��ǰǰ���,
    SUM(NVL(b.cart_qty, 0))                          AS ��ǰ���ż�, 
    SUM(NVL(b.cart_qty, 0) * NVL(c.prod_price, 0))   AS �ѱ��űݾ�
FROM member a, cart b, prod c
WHERE a.mem_id = b.cart_member(+)
AND b.cart_prod = c.prod_id(+)
GROUP BY a.mem_id, a.mem_name
ORDER BY īƮ���Ƚ�� DESC;




