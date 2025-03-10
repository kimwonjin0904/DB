--�ý��� ���� 
DECLARE
 v_num NUMBER :=0;
BEGIN
 v_num := 10 /0;
 DBMS_OUTPUT.PUT_LINE('����ó��');
EXCEPTION   WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('������ ã�� �� ����');
            WHEN ZERO_DIVIDE THEN
                    DBMS_OUTPUT.PUT_LINE('���� zero divide');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('�����߻�');
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;



/*
-------------------------------------------------------------------------------------------------------------------------------------
 1.����� ���� ����
-------------------------------------------------------------------------------------------------------------------------------------
   �ý��� ���� �̿ܿ� ����ڰ� ���� ���ܸ� ���� 
   �����ڰ� ���� ���ܸ� �����ϴ� ���.
-------------------------------------------------------------------------------------------------------------------------------------
[1] ����� ���� ���ǹ�� 
 (1) ���� ���� : �����_����_���ܸ� EXCEPTION;
 (2) ���ܹ߻���Ű�� : RAISE �����_����_���ܸ�;
                    �ý��� ���ܴ� �ش� ���ܰ� �ڵ����� ���� ������, ����� ���� ���ܴ� ���� ���ܸ� �߻����Ѿ� �Ѵ�.
                  RAISE ���ܸ� ���·� ����Ѵ�.
 (3) �߻��� ���� ó�� : EXCEPTION WHEN �����_����_���ܸ� THEN ..
*/
    CREATE OR REPLACE PROCEDURE ch10_ins_emp_proc ( 
                      p_emp_name       employees.emp_name%TYPE,
                      p_department_id  departments.department_id%TYPE )
    IS
       vn_employee_id  employees.employee_id%TYPE;
       vd_curr_date    DATE := SYSDATE;
       vn_cnt          NUMBER := 0;
       ex_invalid_depid EXCEPTION; -- (1) �߸��� �μ���ȣ�� ��� ���� ����
    BEGIN
	     -- �μ����̺��� �ش� �μ���ȣ �������� üũ
	     SELECT COUNT(*)
	       INTO vn_cnt
	       FROM departments
	      WHERE department_id = p_department_id;
	     IF vn_cnt = 0 THEN
	        RAISE ex_invalid_depid; -- (2) ����� ���� ���� �߻�
	     END IF;
	     -- employee_id�� max ���� +1
	     SELECT MAX(employee_id) + 1
	       INTO vn_employee_id
	       FROM employees; 
	     -- ����ڿ���ó�� �����̹Ƿ� ��� ���̺� �ּ��� �����͸� �Է���
	     INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
                  VALUES ( vn_employee_id, p_emp_name, vd_curr_date, p_department_id );
       COMMIT;        
          
    EXCEPTION WHEN ex_invalid_depid THEN --(3) ����� ���� ���� ó������ 
                   DBMS_OUTPUT.PUT_LINE('�ش� �μ���ȣ�� �����ϴ�');
              WHEN OTHERS THEN
                   DBMS_OUTPUT.PUT_LINE(SQLERRM);              
    END;                	

EXEC ch10_ins_emp_proc ('ȫ�浿', 20);      --���� �μ� ����� ���� ����ó����    
EXEC ch10_ins_emp_proc ('ȫ�浿', 999);     --�ִ� �μ� ����ó���Ǿ� ������ �����.


select *
from employees;


/*
--[2]�ý��� ���ܿ� �̸� �ο��ϱ�----------------------------------------------------------------------------------------------
 �ý��� ���ܿ��� ZERO_DIVIDE, INVALID_NUMBER .... �Ͱ��� ���ǵ� ���ܰ� �ִ� ������ �̵�ó�� ���ܸ��� �ο��� ���� 
 �ý��� ���� �� �ؼҼ��̰� �������� �����ڵ常 �����Ѵ�. �̸��� ���� �ڵ忡 �̸� �ο��ϱ�.

	1.����� ���� ���� ���� 
	2.����� ���� ���ܸ�� �ý��� ���� �ڵ� ���� (PRAGMA EXCEPTION_INIT(����� ���� ���ܸ�, �ý���_����_�ڵ�)

		/*
		   PRAGMA �����Ϸ��� ����Ǳ� ���� ó���ϴ� ��ó���� ���� 
		   PRAGMA EXCEPTION_INIT(���ܸ�, ���ܹ�ȣ)
		   ����� ���� ���� ó���� �� �� ���Ǵ°����� 
		   Ư�� ���ܹ�ȣ�� ����ؼ� �����Ϸ��� �� ���ܸ� ����Ѵٴ� ���� �˸��� ���� 
		   (�ش� ���ܹ�ȣ�� �ش�Ǵ� �ý��� ������ �߻�) 
		*/
	3.�߻��� ���� ó��:EXCEPTION WHEN ����� ���� ���ܸ� THEN ....
*/

CREATE OR REPLACE PROCEDURE ch10_ins_emp_proc ( 
                  p_emp_name       employees.emp_name%TYPE,
                  p_department_id  departments.department_id%TYPE,
                  p_hire_month  VARCHAR2  )
IS
   vn_employee_id  employees.employee_id%TYPE;
   vd_curr_date    DATE := SYSDATE;
   vn_cnt          NUMBER := 0;
   ex_invalid_depid EXCEPTION; -- �߸��� �μ���ȣ�� ��� ���� ����
   ex_invalid_month EXCEPTION; -- �߸��� �Ի���� ��� ���� ����
   PRAGMA EXCEPTION_INIT (ex_invalid_month, -1843); -- ���ܸ�� �����ڵ� ����
BEGIN
	 -- �μ����̺��� �ش� �μ���ȣ �������� üũ
	 SELECT COUNT(*)
	   INTO vn_cnt
	   FROM departments
	 WHERE department_id = p_department_id;
	 IF vn_cnt = 0 THEN
	    RAISE ex_invalid_depid; -- ����� ���� ���� �߻�
	 END IF;
	 -- �Ի�� üũ (1~12�� ������ ������� üũ)
	 IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
	    RAISE ex_invalid_month; -- ����� ���� ���� �߻�
	 END IF;
	 -- employee_id�� max ���� +1
	 SELECT MAX(employee_id) + 1
	   INTO vn_employee_id
	   FROM employees;
	 -- ����ڿ���ó�� �����̹Ƿ� ��� ���̺� �ּ��� �����͸� �Է���
	 INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
              VALUES ( vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );
   COMMIT;              
EXCEPTION WHEN ex_invalid_depid THEN -- ����� ���� ���� ó��
               DBMS_OUTPUT.PUT_LINE('�ش� �μ���ȣ�� �����ϴ�');
          WHEN ex_invalid_month THEN -- �Ի�� ����� ���� ����
               DBMS_OUTPUT.PUT_LINE(SQLCODE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               DBMS_OUTPUT.PUT_LINE('1~12�� ������ ��� ���Դϴ�');               
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);              	
END;    
EXEC ch10_ins_emp_proc ('ȫ�浿', 110, '201314');
/*
 [3].����� ���ܸ� �ý��� ���ܿ� ���ǵ� ���ܸ��� ���----------------------------------------------------------------------------------------------
      RAISE ����� ���� ���� �߻��� 
      ����Ŭ���� ���� �Ǿ� �ִ� ���ܸ� �߻� ��ų�� �ִ�. 
*/
CREATE OR REPLACE PROCEDURE ch10_raise_test_proc ( p_num NUMBER)
IS
BEGIN
	IF p_num <= 0 THEN
	   RAISE INVALID_NUMBER;
  END IF;
  DBMS_OUTPUT.PUT_LINE(p_num);
EXCEPTION WHEN INVALID_NUMBER THEN
               DBMS_OUTPUT.PUT_LINE('����� �Է¹��� �� �ֽ��ϴ�');
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
EXEC ch10_raise_test_proc (-10);   

/*
[4].���ܸ� �߻���ų �� �ִ� ���� ���ν��� ----------------------------------------------------------------------------------------------
  RAISE_APPLICATOIN_ERROR(�����ڵ�, ���� �޼���);
  ���� �ڵ�� �޼����� ����ڰ� ���� ����  -20000 ~ -20999 ������ �� ��밡�� 
   �ֳĸ� ����Ŭ���� �̹� ����ϰ� �ִ� ���ܵ��� �� ��ȣ ������ ������� �ʰ� �ֱ� ������)
*/
CREATE OR REPLACE PROCEDURE ch10_raise_test_proc ( p_num NUMBER)
IS
BEGIN
	IF p_num <= 0 THEN
	   RAISE_APPLICATION_ERROR (-20000, '����� �Է¹��� �� �ִ� ���Դϴ�!');
	END IF;  
  DBMS_OUTPUT.PUT_LINE(p_num);
EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLCODE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
EXEC ch10_raise_test_proc (-10);  




--========================================================
--========================================================

/*
  Ʈ����� Transaction '�ŷ�'
  ���࿡�� �Աݰ� ����� �ϴ� �� �ŷ��� ���ϴ� �ܾ�� 
  ���α׷��� �� ����Ŭ���� ���ϴ� Ʈ����ǵ� �� ���信�� �����Ѱ� 

  A ���� (��� �Ͽ� �۱�) -> B ���� 
  �۱� �߿� ������ �߻� 
  A ���� ���¿��� ���� ���������� 
  B ���� ���¿� �Աݵ��� ����.

  ������ �ľ��Ͽ� A���� ��� ��� or ��ݵ� ��ŭ B �������� �ٽ� �۱�
  but � �������� �ľ��Ͽ� ó���ϱ⿡�� ���� �������� �ִ�. 

  �׷��� ���� �ذ�å -> �ŷ��� ���������� ��� ���� �Ŀ��� �̸� ������ �ŷ��� ����, 
                 �ŷ� ���� ���� ������ �߻����� ���� �� �ŷ��� ó������ ������ �ŷ��� �ǵ�����. 

  �ŷ��� �������� Ȯ���ϴ� ����� �ٷ� Ʈ�����
*/


-- COMMIT �� ROLLBACK

CREATE TABLE ch10_sales (
       sales_month   VARCHAR2(8),
       country_name  VARCHAR2(40),
       prod_category VARCHAR2(50),
       channel_desc  VARCHAR2(20),
       sales_amt     NUMBER );
       
-- (1) commit ���� ------------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE iud_ch10_sales_proc 
            ( p_sales_month ch10_sales.sales_month%TYPE )
IS

BEGIN
	INSERT INTO ch10_sales (sales_month, country_name, prod_category, channel_desc, sales_amt)
	SELECT A.SALES_MONTH, 
       C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC,
       SUM(A.AMOUNT_SOLD)
  FROM SALES A, CUSTOMERS B, COUNTRIES C, PRODUCTS D, CHANNELS E
 WHERE A.SALES_MONTH = p_sales_month
   AND A.CUST_ID = B.CUST_ID
   AND B.COUNTRY_ID = C.COUNTRY_ID
   AND A.PROD_ID = D.PROD_ID
   AND A.CHANNEL_ID = E.CHANNEL_ID
 GROUP BY A.SALES_MONTH, 
         C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC;

 COMMIT;
 --ROLLBACK;

END;            

EXEC iud_ch10_sales_proc ( '199901');



-- sqlplus �����Ͽ� ��ȸ 
-- �Ǽ��� 0
SELECT COUNT(*)
FROM ch10_sales ;

TRUNCATE TABLE ch10_sales;

-- (2) ���� ������ �� ----------------------------------------------------------------------------------------------


ALTER TABLE ch10_sales ADD CONSTRAINTS pk_ch10_sales PRIMARY KEY (sales_month, country_name, prod_category, channel_desc);
-- �������� ���� �� �׽�Ʈ 

CREATE OR REPLACE PROCEDURE iud_ch10_sales_proc 
            ( p_sales_month ch10_sales.sales_month%TYPE )
IS

BEGIN
	
	INSERT INTO ch10_sales (sales_month, country_name, prod_category, channel_desc, sales_amt)	   
	SELECT A.SALES_MONTH, 
       C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC,
       SUM(A.AMOUNT_SOLD)
  FROM SALES A, CUSTOMERS B, COUNTRIES C, PRODUCTS D, CHANNELS E
 WHERE A.SALES_MONTH = p_sales_month
   AND A.CUST_ID = B.CUST_ID
   AND B.COUNTRY_ID = C.COUNTRY_ID
   AND A.PROD_ID = D.PROD_ID
   AND A.CHANNEL_ID = E.CHANNEL_ID
 GROUP BY A.SALES_MONTH, 
         C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC;

 -- �� ó���ǰ� ������ ������ Ŀ�� 
 COMMIT;

EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               ROLLBACK;

END;   


---------------------------------------------------------------------------------------------------------------------
--����ó�� ���� ����
CREATE TABLE error_log(
     error_seq NUMBER
    ,prog_name VARCHAR2(20)
    ,prog_code NUMBER
    ,error_message VARCHAR2(300)
    ,error_line VARCHAR2(100)
    ,error_date DATE DEFAULT SYSDATE
);
--������
CREATE SEQUENCE error_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 999999
NOCYCLE
NOCACHE;
--��������
CREATE OR REPLACE PROCEDURE error_log_proc(
    p_name     error_log.prog_name%TYPE
   ,p_code     error_log.error_code%TYPE
   ,p_message  error_log.error_message%TYPE
   ,p_line     error_log.error_line%TYPE
)
IS
BEGIN
    INSERT INTO error_log(error_seq, prog_name, error_code, error_message, error_line)
    VALUES(error_seq.NEXTVAL, p_name, p_code, p_message, p_line);
    COMMIT;
END;


------------------------------------------------
CREATE OR REPLACE PROCEDURE error_log_proc(
    p_name     error_log.prog_name%TYPE,
    p_code     error_log.error_code%TYPE,
    p_message  error_log.error_message%TYPE,
    p_line     error_log.error_line%TYPE
)
IS
BEGIN
    INSERT INTO error_log (error_seq, prog_name, error_code, error_message, error_line)
    VALUES (error_seq.NEXTVAL, p_name, p_code, p_message, p_line);
    COMMIT;
END;



--
CREATE OR REPLACE PROCEDURE ch10_ins_emp2_proc ( 
                  p_emp_name       employees.emp_name%TYPE,
                  p_department_id  departments.department_id%TYPE,
                  p_hire_month     VARCHAR2 )
IS
   vn_employee_id  employees.employee_id%TYPE;
   vd_curr_date    DATE := SYSDATE;
   vn_cnt          NUMBER := 0;
   
   ex_invalid_depid EXCEPTION; -- �߸��� �μ���ȣ�� ��� ���� ����
   PRAGMA EXCEPTION_INIT ( ex_invalid_depid, -20000); -- ���ܸ�� �����ڵ� ����

   ex_invalid_month EXCEPTION; -- �߸��� �Ի���� ��� ���� ����
   PRAGMA EXCEPTION_INIT ( ex_invalid_month, -1843); -- ���ܸ�� �����ڵ� ����
   
   v_err_code error_log.error_code%TYPE;
   v_err_msg  error_log.error_message%TYPE;
   v_err_line error_log.error_line%TYPE;
BEGIN
 -- �μ����̺��� �ش� �μ���ȣ �������� üũ
 SELECT COUNT(*)
   INTO vn_cnt
   FROM departments
  WHERE department_id = p_department_id;
	  
 IF vn_cnt = 0 THEN
    RAISE ex_invalid_depid; -- ����� ���� ���� �߻�
 END IF;

-- �Ի�� üũ (1~12�� ������ ������� üũ)
 IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
    RAISE ex_invalid_month; -- ����� ���� ���� �߻�
 END IF;

 -- employee_id�� max ���� +1
 SELECT MAX(employee_id) + 1
   INTO vn_employee_id
   FROM employees;
 
-- ����ڿ���ó�� �����̹Ƿ� ��� ���̺� �ּ��� �����͸� �Է���
INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
            VALUES ( vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );              
 COMMIT;

EXCEPTION WHEN ex_invalid_depid THEN -- ����� ���� ���� ó��
               v_err_code := SQLCODE;
               v_err_msg  := '�ش� �μ��� �����ϴ�';
               v_err_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
               ROLLBACK;
               error_log_proc ( 'ch10_ins_emp2_proc', v_err_code, v_err_msg, v_err_line); 
          WHEN ex_invalid_month THEN -- �Ի�� ����� ���� ���� ó��
               v_err_code := SQLCODE;
               v_err_msg  := SQLERRM;
               v_err_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
               ROLLBACK;
               error_log_proc ( 'ch10_ins_emp2_proc', v_err_code, v_err_msg, v_err_line); 
          WHEN OTHERS THEN
               v_err_code := SQLCODE;
               v_err_msg  := SQLERRM;
               v_err_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
               ROLLBACK;  
               error_log_proc ( 'ch10_ins_emp2_proc', v_err_code, v_err_msg, v_err_line);        	
END;
---==

EXEC ch10_ins_emp2_proc ('HONG', 1000, '201401'); 
-- �߸��� �μ�
EXEC ch10_ins_emp2_proc ('HONG', 100 , '201413'); -- �߸��� ��


SELECT *
FROM  error_log ;

delete error_log;
commit;

/*
    SAVEPOINT 
    ���� ROLLBACK�� ����ϸ� INSERT, DELETE, UPDATE, MERGE 
    �۾� ��ü�� ��ҵǴµ� ��ü�� �ƴ� Ư�� �κп��� Ʈ������� ��ҽ�ų �� �ִ�. 
    �̷��� �Ϸ��� ����Ϸ��� ������ ����� ��, �� �������� �۾��� ����ϴ� 
    ������ ����ϴµ� �� ������ SAVEPOINT��� �Ѵ�. 
*/
CREATE TABLE ex_save(
    ex_no NUMBER
    ,ex_nm VARCHAR2(100)
);
CREATE OR REPLACE PROCEDURE save_proc(flag VARCHAR2)
IS
    point1 EXCEPTION;
    point2 EXCEPTION;
    v_num NUMBER;
BEGIN
    INSERT INTO ex_save VALUES(1, 'POINT1 BEFORE');
      SAVEPOINT mysavepoint1;
    INSERT INTO ex_save VALUES(2, 'POINT1 AFTER');
    INSERT INTO ex_save VALUES(3, 'POINT2 BEFORE');
      SAVEPOINT mysavepoint2;
    INSERT INTO ex_save VALUES(4, 'POINT2 AFTER');
    
    IF flag = '1' THEN 
        RAISE point1; 
    ELSIF flag = '2' THEN
        RAISE point2;
    ELSIF flag = '3' THEN
        v_num := 10 / 0; 
    END IF;   
    COMMIT;

EXCEPTION 
    WHEN point1 THEN 
        ROLLBACK TO mysavepoint1;
    WHEN point2 THEN
        ROLLBACK TO mysavepoint2;
    WHEN OTHERS THEN
        ROLLBACK;
END;


EXEC save_proc('1');        --���̺� ����Ʈ 1���� �ѹ� �� Ŀ��
EXEC save_proc('2');        --���̺� ����Ʈ 2���� �ѹ� �� Ŀ��   
EXEC save_proc('3');        --�� �ѹ�
EXEC save_proc('4');        --���� ó���Ǿ� �� ����� �� Ŀ��

select *
from ex_save;

delete ex_save;




-------------------------------------------------------
CREATE TABLE ch10_country_month_sales (
               sales_month   VARCHAR2(8),
               country_name  VARCHAR2(40),
               sales_amt     NUMBER,
               PRIMARY KEY (sales_month, country_name) );
              
CREATE OR REPLACE PROCEDURE iud_ch10_sales_proc 
            ( p_sales_month  ch10_sales.sales_month%TYPE, 
              p_country_name ch10_sales.country_name%TYPE )
IS

BEGIN
	
	--���� ������ ����
	DELETE ch10_sales
	 WHERE sales_month  = p_sales_month
	   AND country_name = p_country_name;
	      
	-- �űԷ� ��, ������ �Ű������� �޾� INSERT 
	-- DELETE�� �����ϹǷ� PRIMARY KEY �ߺ��� �߻�ġ ����
	INSERT INTO ch10_sales (sales_month, country_name, prod_category, channel_desc, sales_amt)	   
	SELECT A.SALES_MONTH, 
       C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC,
       SUM(A.AMOUNT_SOLD)
  FROM SALES A, CUSTOMERS B, COUNTRIES C, PRODUCTS D, CHANNELS E
 WHERE A.SALES_MONTH  = p_sales_month
   AND C.COUNTRY_NAME = p_country_name
   AND A.CUST_ID = B.CUST_ID
   AND B.COUNTRY_ID = C.COUNTRY_ID
   AND A.PROD_ID = D.PROD_ID
   AND A.CHANNEL_ID = E.CHANNEL_ID
 GROUP BY A.SALES_MONTH, 
         C.COUNTRY_NAME, 
       D.PROD_CATEGORY,
       E.CHANNEL_DESC;
       
 -- SAVEPOINT Ȯ���� ���� UPDATE

  -- ����ð����� �ʸ� ������ ���ڷ� ��ȯ�� �� * 10 (�Ź� �ʴ� �޶����Ƿ� ���������� ���� �� �� ���� �Ź� �޶���)
 UPDATE ch10_sales
    SET sales_amt = 10 * to_number(to_char(sysdate, 'ss'))
  WHERE sales_month  = p_sales_month
	   AND country_name = p_country_name;
	   
       
       
 -- SAVEPOINT ����      
 SAVEPOINT mysavepoint;      
 
 
 
 
 -- ch10_country_month_sales ���̺� INSERT
 -- �ߺ� �Է� �� PRIMARY KEY �ߺ���
 INSERT INTO ch10_country_month_sales 
       SELECT sales_month, country_name, SUM(sales_amt)
         FROM ch10_sales
        WHERE sales_month  = p_sales_month
	        AND country_name = p_country_name
	      GROUP BY sales_month, country_name;         
       
 COMMIT;

EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               ROLLBACK TO mysavepoint; -- SAVEPOINT ������ ROLLBACK
               COMMIT; -- SAVEPOINT ���������� COMMIT

	
END;   

TRUNCATE TABLE ch10_sales;

EXEC iud_ch10_sales_proc ( '199901', 'Italy');

SELECT DISTINCT sales_amt
FROM ch10_sales;



EXEC iud_ch10_sales_proc ( '199901', 'Italy');

SELECT DISTINCT sales_amt
FROM ch10_sales;


------------------------------------------------------------------------------------
--=========================������ ��ȣȭ=======================================================
/*
    ������ ��ȣȭ 
    ����Ŭ �����ͺ��̽����� ���� ���� ������ ������ ���� ũ�� 2���� 
    1. ����ڿ� ���õ� ����.
      - ����� ����, ��й�ȣ ������ �������, ���Ѱ� �� ( �̴� DBA�� ó����)
    2. ������ ��ü�� ���� ����.
      - �����ͺ����� �����ڰ� ó��.
      
    ������ ������ ��ȭ �ϴ� �� ���� ����� ������ ��ȣȭ.
    
    - ������ ��ȣȭ�� �ΰ��ϰ� �߿��� �����͸� ��ȣȭ�ؼ� ���̺� �����ϰ� �̸� ��ȸ�� �� �ٽ� ��ȣȭ�� �ϴ� �Ϸ��� ����.
    - ��ȣȭ�� �����ʹ� ��ȣȭ ������ ���ٸ� �ǹ� ���� ������ 
    - �����Ͱ� ��°�� ����Ǿ ��ȣȭ ���п� 1������ �������� Ȯ���Ǿ��ٰ� �� �� �ִ�

    ����Ŭ 10g ���� ������ DBMS_CRYPTO ��Ű��
    

    ����� �˰��� : ��ȣȭ, ��ȣȭ ����
    (��ĪŰ,���ĪŰ)

    �ܹ��� �˰��� : ��ȭȭ ����, ��ȣȭ �Ұ�
    (hash)


    ��ȣȭ�� ���� ���� �˰����� �̿��� ó���ϴµ�  
    DBMS_CRYPTO ��Ű���� Ȱ���� ���� ������ ��ȣȭ �˰����� 
    --https://docs.oracle.com/cd/B19306_01/appdev.102/b14258/d_crypto.htm#i1004143 ����
    1.DES(Data Encryption Standard) : �̱� ����ǥ�ر�������ҿ��� �̱� ǥ������ ���ߴ� 56��Ʈ ��ĪŰ�� ����� �˰���(������� �߰ߵ� ǥ�ؿ��� ���ܵ�)
    2.3DES (DES 3�� �ݺ� ����˰���) 
    3.AES(Advanced Encryption Standard) : DES�� ��ü�ϱ� ���� ������� �˰��� ���� �̱� ǥ������ ��� (��Ī�� �˰���) 
    4.MD5(Message-Digest algorithm5) : 128��Ʈ ��ȣȭ �ؽ� �Լ��� ���α׷��̳� ������ ���� �״������ Ȯ���ϴ� ���Ἲ �˻� � ��� (��ȣȭ�� ���������� ��ȣȭ�� �ſ� �����)(�ܹ���)
    5.SHA-1(Secure Hash Algorithm-1) : 160��Ʈ �ؽ� ���� ������ ��ȣȭ �ؽ� �Լ���  MD5���� �Ѵܰ� ���� ����(�ܹ���)
    6.MAC(Message Authentication Code, �޼��������ڵ�) : MD5, SHA-1 ���� �ܹ��� ��ȣȭ �ؽ� �Լ��ε� �ٸ����� ���Ű�� �Է� �޾� ���.
    
    
    DBMS_CRYPTO ��Ű�� 
    
    �پ��� ��ȣȭ ��İ� �˰����� ����ϱ� ������ 
    ��Ű�� ����� ������ ����ϴµ� �̴� ���  PLS_INTEGER Ÿ���̴�.
    
    1.��ȣȭ �˰��� ��� 
      ENCRYPY_AES128 AES ��� ��ȣȭ�� 128 ��Ʈ Ű�� ���
      ENCRYPY_AES192 AES ��� ��ȣȭ�� 192 ��Ʈ Ű�� ���
      ENCRYPY_AES256 AES ��� ��ȣȭ�� 256 ��Ʈ Ű�� ���    

    2.��� ��ȣȭ ��� ���� ���
       ��� ��ȣ(Block Cipher)�� ���� ��� ������ ��ȣȭ�ϴ� ��ĪŰ ��ȣ �ý����Դϴ�.
       CHAIN_CBC : CBC(Chipher Block Chaing) ��� 

    3.�е� ���� ���
      PAD_PKCS5: PKCS5(��й�ȣ ��� ��ȣȭ ǥ������ �̷���� �е�)
      PAD_NONE: �е��� ������ �ǹ�
      PAD_ZERO: 0���� �̷���� �е�       

    4.��ȣȭ ��Ʈ ���� ��� 
      ��ȣ �˰��� + ��ȣȭ ��� + �е� ���յȰ�
      DBMS_CRYPYO ��Ű���� ��ȣȭ ���� �Լ��� ���ν����� �̷� ��ȣȭ ��Ʈ�� �Ű������� �޾� �����͸� ��ȣȭ �Ѵ�. 

    5.��ȣȭ �ؽ� �Լ� ���� ��� 
      HASH_MD4 :MD4 128��Ʈ �ؽ�
      HASH_MD4 :MD5 128��Ʈ �ؽ�
      HASH_SH1 :SH1 160��Ʈ �ؽ�

    6.MAC �Լ� ���� ��� 
      HMAC_MD5 : �ؽ� ���� �����ϱ� ���� ���Ű�� �����(�������� MD5�� ����)
      HMAC_SH1 : �ؽ� ���� �����ϱ� ���� ���Ű�� �����(�������� SHA1�� ����)
    


    -----------------------------------------------------------------------------
    ENCRYPT �Լ��� key�� �Է� �޾� �����͸� ��ȣȭ ��Ʈ ������� ��ȣȭ�� ����� ��ȯ(����� RAW Ÿ������ ��ȯ)
    src : ��ȣȭ�� ������
    typ : ��ȣȭ�� ���� ��Ʈ
    key : ��ȣȭ Ű
    iv : �ʱ�ȭ ����
    -----------------------------------------------------------------------------
    DECRYPT �Լ��� ��ȣȭ�� �����͸� �Ű������� �޾� ��ȣȭ ����� ��ȯ�ϴ� �Լ�.
    src : ��ȣȭ ������
    typ : ��ȣȭ�� ���� ��ȣȭ ��Ʈ
    key : ��ȣȭ Ű
    iv  : �ʱ�ȭ ����
     -----------------------------------------------------------------------------   
    RAWŸ������ �޾� ���������� ��ȯ

    
    HASH �Լ� 
    md4,md5,sha-1 �� ����� �ؽ� ���� ���� ��ȯ�ϴ� �Լ�. 
    
    MAC �Լ� 
    hash �Լ��� ����ϳ� �Ű������� ����� ���Ű�� �� �Է¹޴´�. 
*/




/*
 ��ȣȭ ���� �׽�Ʈ�� ���� 
 sqlplus ����
 sys as sysdba ���� 
 grant execute on DBMS_CRYPTO to java;
 -----------------------------------------------------��� ���� 
 */

grant execute on DBMS_CRYPTO to public;


DECLARE
  input_string  VARCHAR2 (200) := 'The Oracle';  -- ��ȣȭ�� VARCHAR2 ������
  output_string VARCHAR2 (200); -- ��ȣȭ�� VARCHAR2 ������ 
  encrypted_raw RAW (2000); -- ��ȣȭ�� ������ 
  decrypted_raw RAW (2000); -- ��ȣȭ�� ������ 
  num_key_bytes NUMBER := 256/8; -- ��ȣȭ Ű�� ���� ���� (256 ��Ʈ, 32 ����Ʈ)
  key_bytes_raw RAW (32);        -- ��ȣȭ Ű 

  -- ��ȣȭ ��Ʈ 
  encryption_type PLS_INTEGER; 
  
BEGIN
	 -- ��ȣȭ ��Ʈ ����
	 encryption_type := DBMS_CRYPTO.ENCRYPT_AES256 + -- 256��Ʈ Ű�� ����� AES ��ȣȭ 
	                    DBMS_CRYPTO.CHAIN_CBC +      -- CBC ��� 
	                    DBMS_CRYPTO.PAD_PKCS5;       -- PKCS5�� �̷���� �е�
	
   DBMS_OUTPUT.PUT_LINE ('���� ���ڿ�: ' || input_string);

   -- RANDOMBYTES �Լ��� ����� ��ȣȭ Ű ���� 
   key_bytes_raw := DBMS_CRYPTO.RANDOMBYTES (num_key_bytes);
   
   -- ENCRYPT �Լ��� ��ȣȭ�� �Ѵ�. ���� ���ڿ��� UTL_I18N.STRING_TO_RAW�� ����� RAW Ÿ������ ��ȯ�Ѵ�. 
   encrypted_raw := DBMS_CRYPTO.ENCRYPT ( src => UTL_I18N.STRING_TO_RAW (input_string, 'AL32UTF8'),   
                                          typ => encryption_type,
                                          key => key_bytes_raw
                                        );
                                        
   -- ��ȣȭ�� RAW �����͸� �ѹ� ����غ���
   DBMS_OUTPUT.PUT_LINE('��ȣȭ�� RAW ������: ' || encrypted_raw);                                     
   -- ��ȣȭ �� �����͸� �ٽ� ��ȣȭ ( ��ȣȭ�ߴ� Ű�� ��ȣȭ ��Ʈ�� �����ϰ� ����ؾ� �Ѵ�. )
   decrypted_raw := DBMS_CRYPTO.DECRYPT ( src => encrypted_raw,
                                          typ => encryption_type,
                                          key => key_bytes_raw
                                        );
   
   -- ��ȣȭ�� RAW Ÿ�� �����͸� UTL_I18N.RAW_TO_CHAR�� ����� �ٽ� VARCHAR2�� ��ȯ 
   output_string := UTL_I18N.RAW_TO_CHAR (decrypted_raw, 'AL32UTF8');
   -- ��ȣȭ�� ���ڿ� ��� 
   DBMS_OUTPUT.PUT_LINE ('��ȣȭ�� ���ڿ�: ' || output_string);
END;



-- �ܹ��� ��ȣȭ �ؽ� �Լ��� HASH, MAC �Լ��� �ܹ������� ��ȣȭ�� �ſ� ��ư� 
-- ��� �Է� ���� ���� ��ȣȭ�� �����͸� �������ν� �Է� ���� �����ϴµ� ���ȴ�. 
-- ex ��й�ȣ üũ 
-- HASH, MAC �Լ�

DECLARE

  input_string  VARCHAR2 (200) := 'The Oracle';  -- �Է� VARCHAR2 ������
  input_raw     RAW(128);                        -- �Է� RAW ������ 

  encrypted_raw RAW (2000); -- ��ȣȭ ������ 
  
  key_string VARCHAR2(8) := 'secret';  -- MAC �Լ����� ����� ��� Ű
  raw_key RAW(128) := UTL_RAW.CAST_TO_RAW(CONVERT(key_string,'AL32UTF8','US7ASCII')); -- ���Ű�� RAW Ÿ������ ��ȯ
  
BEGIN
	-- VARCHAR2�� RAW Ÿ������ ��ȯ
	input_raw := UTL_I18N.STRING_TO_RAW (input_string, 'AL32UTF8');
	
	
  DBMS_OUTPUT.PUT_LINE('----------- HASH �Լ� -------------');
  encrypted_raw := DBMS_CRYPTO.HASH( src => input_raw,
                                     typ => DBMS_CRYPTO.HASH_SH1);
                                     
  DBMS_OUTPUT.PUT_LINE('�Է� ���ڿ��� �ؽð� : ' || RAWTOHEX(encrypted_raw));   
    
  
  DBMS_OUTPUT.PUT_LINE('----------- MAC �Լ� -------------'); 
  encrypted_raw := DBMS_CRYPTO.MAC( src => input_raw,
                                    typ => DBMS_CRYPTO.HMAC_MD5,
                                    key => raw_key);   
                                    
  DBMS_OUTPUT.PUT_LINE('MAC �� : ' || RAWTOHEX(encrypted_raw));
END;

-------------------------------------------------------------------------------
--------------------------------------------------
CREATE OR REPLACE FUNCTION fn_encode(input_pw VARCHAR2)
RETURN VARCHAR2
IS 
  input_raw     RAW(2000);   -- UTF-8 ��ȯ�� �Է°� ����
  encrypted_raw RAW(2000);   -- ��ȣȭ�� ��� ����
BEGIN
    -- �Է� ���ڿ��� UTF-8 ���ڵ��� RAW �����ͷ� ��ȯ
    input_raw := UTL_I18N.STRING_TO_RAW(input_pw, 'AL32UTF8');
    
    -- SHA-1 �ؽ� ���� (�ؽ� Ÿ���� ���� '2'�� ���)
    encrypted_raw := DBMS_CRYPTO.HASH(
                        src => input_raw,
                        typ => 2);  -- SHA-1 �˰���

    -- �ؽõ� ����� 16���� ���ڿ��� ��ȯ�Ͽ� ��ȯ
    RETURN RAWTOHEX(encrypted_raw);
END;



-----
select fn_encode('�ȳ��ϼ���')
from dual;

--------------------
create table member_test AS
select   mem_name
        ,mem_id
        ,fn_encode(mem_pass) mem_pass
FROm member;
select *
FROm member;
select *
from member_test
where mem_id = 'a001'
and   mem_pass = fn_encode('asdfasdf');



-------------------------------------
--------
DECLARE

  input_string  VARCHAR2 (200) := 'The Oracle';  -- �Է� VARCHAR2 ������
  input_raw     RAW(128);                        -- �Է� RAW ������ 
  encrypted_raw RAW (2000); -- ��ȣȭ ������   
  key_string VARCHAR2(8) := 'secret';  -- MAC �Լ����� ����� ��� Ű
  raw_key RAW(128) := UTL_RAW.CAST_TO_RAW(CONVERT(key_string,'AL32UTF8','US7ASCII')); -- ���Ű�� RAW Ÿ������ ��ȯ  
BEGIN
	input_raw := UTL_I18N.STRING_TO_RAW (input_string, 'AL32UTF8');
    encrypted_raw := DBMS_CRYPTO.MAC( src => input_raw,
                                    typ => DBMS_CRYPTO.HMAC_MD5,
                                    key => raw_key);                                     
  DBMS_OUTPUT.PUT_LINE('MAC �� : ' || RAWTOHEX(encrypted_raw));
END;




-- ���̵�� ��й�ȣ�� �Է��ϸ� �̸� üũ�� �α����ϴ� ���α׷� 
-- ��������̺��� ���̵�� ��й�ȣ�� �����ϴµ� �̶� ��й�ȣ�� �Էµ� ��ȣ �״�� �����ϴ� ���� �ƴ϶� 
-- ����ڰ� �Է��� ���� ������ �ٸ� ���� ������ �̸� HASH, MAC �Լ��� �Է� ������ �޾� ��ȯ�� ��� ���� ��й�ȣ �÷��� ����. 
-- �ý��� �����ڵ� ���̺��� ��ȣȭ�� ���� �˼� ���� ���� ����ڸ� �� �� �ִ�. 

-- ��й�ȣ�� �н� �ߴٸ�? 
-- �������� �űԺ�й�ȣ�� ������ hash, mac �Լ��� �¿� ��ȯ�� ���� ��й�ȣ �÷��� �����ϰ� ����ڿ��� �ű� ��й�ȣ�� �ο� 
-- ���ο� ����� �����ϰ� ������. 
-- ����ڰ� ���� �ű� ��й�ȣ�� HASH�� MAC �Լ��� �Ű������� �޾� �� ��ȯ ���� ��й�ȣ �÷��� ���������� ����. 




���������� ������ Ȯ����ġ ����(���������ΰ�� ��2011-43ȣ, 2011.9.30 ����)

 
����������ȣ���� ��й�ȣ �Ϲ��� ��ȣȭ �� �н����� ���� �ַ��
�н������� �Ϲ��� ��ȣȭ�� ���Ǵ� HASH �Լ�
��7��(���������� ��ȣȭ)
�翵 ��21�� �� �� ��30����1����3ȣ�� ���� ��ȣȭ�Ͽ��� �ϴ� ���������� �����ĺ�����, ��й�ȣ �� ���̿������� ���Ѵ�.
�谳������ó���ڴ� ��1�׿� ���� ���������� ������Ÿ��� ���Ͽ� ��.�����ϰų� ���������ü ���� ���Ͽ� �����ϴ� ��쿡�� �̸� ��ȣȭ�Ͽ��� �Ѵ�.
�鰳������ó���ڴ� ��й�ȣ �� ���̿������� ��ȣȭ�Ͽ� �����Ͽ��� �Ѵ�. �� ��й�ȣ�� �����ϴ� ��쿡�� ��ȣȭ���� �ƴ��ϵ��� �Ϲ��� ��ȣȭ�Ͽ� �����Ͽ��� �Ѵ�.
�갳������ó���ڴ� ���ͳ� ���� �� ���ͳ� ������ ���θ��� �߰� ����(DMZ : Demilitarized Zone)�� �����ĺ������� �����ϴ� ��쿡�� �̸� ��ȣȭ�Ͽ��� �Ѵ�.


