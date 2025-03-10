--시스템 예외 
DECLARE
 v_num NUMBER :=0;
BEGIN
 v_num := 10 /0;
 DBMS_OUTPUT.PUT_LINE('정상처리');
EXCEPTION   WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('데이터 찾을 수 없음');
            WHEN ZERO_DIVIDE THEN
                    DBMS_OUTPUT.PUT_LINE('오류 zero divide');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('오류발생');
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;



/*
-------------------------------------------------------------------------------------------------------------------------------------
 1.사용자 정의 예외
-------------------------------------------------------------------------------------------------------------------------------------
   시스템 예외 이외에 사용자가 직접 예외를 정의 
   개발자가 직접 예외를 정의하는 방법.
-------------------------------------------------------------------------------------------------------------------------------------
[1] 사용자 예외 정의방법 
 (1) 예외 정의 : 사용자_정의_예외명 EXCEPTION;
 (2) 예외발생시키기 : RAISE 사용자_정의_예외명;
                    시스템 예외는 해당 예외가 자동으로 검출 되지만, 사용자 정의 예외는 직접 예외를 발생시켜야 한다.
                  RAISE 예외명 형태로 사용한다.
 (3) 발생된 예외 처리 : EXCEPTION WHEN 사용자_정의_예외명 THEN ..
*/
    CREATE OR REPLACE PROCEDURE ch10_ins_emp_proc ( 
                      p_emp_name       employees.emp_name%TYPE,
                      p_department_id  departments.department_id%TYPE )
    IS
       vn_employee_id  employees.employee_id%TYPE;
       vd_curr_date    DATE := SYSDATE;
       vn_cnt          NUMBER := 0;
       ex_invalid_depid EXCEPTION; -- (1) 잘못된 부서번호일 경우 예외 정의
    BEGIN
	     -- 부서테이블에서 해당 부서번호 존재유무 체크
	     SELECT COUNT(*)
	       INTO vn_cnt
	       FROM departments
	      WHERE department_id = p_department_id;
	     IF vn_cnt = 0 THEN
	        RAISE ex_invalid_depid; -- (2) 사용자 정의 예외 발생
	     END IF;
	     -- employee_id의 max 값에 +1
	     SELECT MAX(employee_id) + 1
	       INTO vn_employee_id
	       FROM employees; 
	     -- 사용자예외처리 예제이므로 사원 테이블에 최소한 데이터만 입력함
	     INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
                  VALUES ( vn_employee_id, p_emp_name, vd_curr_date, p_department_id );
       COMMIT;        
          
    EXCEPTION WHEN ex_invalid_depid THEN --(3) 사용자 정의 예외 처리구간 
                   DBMS_OUTPUT.PUT_LINE('해당 부서번호가 없습니다');
              WHEN OTHERS THEN
                   DBMS_OUTPUT.PUT_LINE(SQLERRM);              
    END;                	

EXEC ch10_ins_emp_proc ('홍길동', 20);      --없는 부서 사용자 정의 예외처리됨    
EXEC ch10_ins_emp_proc ('홍길동', 999);     --있는 부서 정상처리되어 직원이 저장됨.


select *
from employees;


/*
--[2]시스템 예외에 이름 부여하기----------------------------------------------------------------------------------------------
 시스템 예외에는 ZERO_DIVIDE, INVALID_NUMBER .... 와같이 정의된 예외가 있다 하지만 이들처럼 예외명이 부여된 것은 
 시스템 예외 중 극소수이고 나머지는 예외코드만 존재한다. 이름이 없는 코드에 이름 부여하기.

	1.사용자 정의 예외 선언 
	2.사용자 정의 예외명과 시스템 예외 코드 연결 (PRAGMA EXCEPTION_INIT(사용자 정의 예외명, 시스템_예외_코드)

		/*
		   PRAGMA 컴파일러가 실행되기 전에 처리하는 전처리기 역할 
		   PRAGMA EXCEPTION_INIT(예외명, 예외번호)
		   사용자 정의 예외 처리를 할 때 사용되는것으로 
		   특정 예외번호를 명시해서 컴파일러에 이 예외를 사용한다는 것을 알리는 역할 
		   (해당 예외번호에 해당되는 시스템 에러시 발생) 
		*/
	3.발생된 예외 처리:EXCEPTION WHEN 사용자 정의 예외명 THEN ....
*/

CREATE OR REPLACE PROCEDURE ch10_ins_emp_proc ( 
                  p_emp_name       employees.emp_name%TYPE,
                  p_department_id  departments.department_id%TYPE,
                  p_hire_month  VARCHAR2  )
IS
   vn_employee_id  employees.employee_id%TYPE;
   vd_curr_date    DATE := SYSDATE;
   vn_cnt          NUMBER := 0;
   ex_invalid_depid EXCEPTION; -- 잘못된 부서번호일 경우 예외 정의
   ex_invalid_month EXCEPTION; -- 잘못된 입사월인 경우 예외 정의
   PRAGMA EXCEPTION_INIT (ex_invalid_month, -1843); -- 예외명과 예외코드 연결
BEGIN
	 -- 부서테이블에서 해당 부서번호 존재유무 체크
	 SELECT COUNT(*)
	   INTO vn_cnt
	   FROM departments
	 WHERE department_id = p_department_id;
	 IF vn_cnt = 0 THEN
	    RAISE ex_invalid_depid; -- 사용자 정의 예외 발생
	 END IF;
	 -- 입사월 체크 (1~12월 범위를 벗어났는지 체크)
	 IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
	    RAISE ex_invalid_month; -- 사용자 정의 예외 발생
	 END IF;
	 -- employee_id의 max 값에 +1
	 SELECT MAX(employee_id) + 1
	   INTO vn_employee_id
	   FROM employees;
	 -- 사용자예외처리 예제이므로 사원 테이블에 최소한 데이터만 입력함
	 INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
              VALUES ( vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );
   COMMIT;              
EXCEPTION WHEN ex_invalid_depid THEN -- 사용자 정의 예외 처리
               DBMS_OUTPUT.PUT_LINE('해당 부서번호가 없습니다');
          WHEN ex_invalid_month THEN -- 입사월 사용자 정의 예외
               DBMS_OUTPUT.PUT_LINE(SQLCODE);
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               DBMS_OUTPUT.PUT_LINE('1~12월 범위를 벗어난 월입니다');               
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);              	
END;    
EXEC ch10_ins_emp_proc ('홍길동', 110, '201314');
/*
 [3].사용자 예외를 시스템 예외에 정의된 예외명을 사용----------------------------------------------------------------------------------------------
      RAISE 사용자 정의 예외 발생시 
      오라클에서 정의 되어 있는 예외를 발생 시킬수 있다. 
*/
CREATE OR REPLACE PROCEDURE ch10_raise_test_proc ( p_num NUMBER)
IS
BEGIN
	IF p_num <= 0 THEN
	   RAISE INVALID_NUMBER;
  END IF;
  DBMS_OUTPUT.PUT_LINE(p_num);
EXCEPTION WHEN INVALID_NUMBER THEN
               DBMS_OUTPUT.PUT_LINE('양수만 입력받을 수 있습니다');
          WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
EXEC ch10_raise_test_proc (-10);   

/*
[4].예외를 발생시킬 수 있는 내장 프로시저 ----------------------------------------------------------------------------------------------
  RAISE_APPLICATOIN_ERROR(예외코드, 예외 메세지);
  예외 코드와 메세지를 사용자가 직접 정의  -20000 ~ -20999 번까지 만 사용가능 
   왜냐면 오라클에서 이미 사용하고 있는 예외들이 위 번호 구간은 사용하지 않고 있기 때문에)
*/
CREATE OR REPLACE PROCEDURE ch10_raise_test_proc ( p_num NUMBER)
IS
BEGIN
	IF p_num <= 0 THEN
	   RAISE_APPLICATION_ERROR (-20000, '양수만 입력받을 수 있단 말입니다!');
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
  트랜잭션 Transaction '거래'
  은행에서 입금과 출금을 하는 그 거래를 말하는 단어로 
  프로그래밍 언어나 오라클에서 말하는 트랜잭션도 이 개념에서 차용한것 

  A 은행 (출금 하여 송금) -> B 은행 
  송금 중에 오류가 발생 
  A 은행 계좌에서 돈이 빠져나가고 
  B 은행 계좌에 입금되지 않음.

  오류를 파악하여 A계좌 출금 취소 or 출금된 만큼 B 은행으로 다시 송금
  but 어떤 오류인지 파악하여 처리하기에는 많은 문제점이 있다. 

  그래서 나온 해결책 -> 거래가 성공적으로 모두 끝난 후에야 이를 완전한 거래로 승인, 
                 거래 도중 뭔가 오류가 발생했을 때는 이 거래를 처음부터 없었던 거래로 되돌린다. 

  거래의 안정성을 확보하는 방법이 바로 트랜잭션
*/


-- COMMIT 과 ROLLBACK

CREATE TABLE ch10_sales (
       sales_month   VARCHAR2(8),
       country_name  VARCHAR2(40),
       prod_category VARCHAR2(50),
       channel_desc  VARCHAR2(20),
       sales_amt     NUMBER );
       
-- (1) commit 없음 ------------------------------------------------------------------------------------------------

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



-- sqlplus 접속하여 조회 
-- 건수가 0
SELECT COUNT(*)
FROM ch10_sales ;

TRUNCATE TABLE ch10_sales;

-- (2) 오류 생겼을 시 ----------------------------------------------------------------------------------------------


ALTER TABLE ch10_sales ADD CONSTRAINTS pk_ch10_sales PRIMARY KEY (sales_month, country_name, prod_category, channel_desc);
-- 제약조건 설정 후 테스트 

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

 -- 다 처리되고 오류가 없을시 커밋 
 COMMIT;

EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               ROLLBACK;

END;   


---------------------------------------------------------------------------------------------------------------------
--예외처리 정보 저장
CREATE TABLE error_log(
     error_seq NUMBER
    ,prog_name VARCHAR2(20)
    ,prog_code NUMBER
    ,error_message VARCHAR2(300)
    ,error_line VARCHAR2(100)
    ,error_date DATE DEFAULT SYSDATE
);
--시퀀스
CREATE SEQUENCE error_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 999999
NOCYCLE
NOCACHE;
--오류저장
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
   
   ex_invalid_depid EXCEPTION; -- 잘못된 부서번호일 경우 예외 정의
   PRAGMA EXCEPTION_INIT ( ex_invalid_depid, -20000); -- 예외명과 예외코드 연결

   ex_invalid_month EXCEPTION; -- 잘못된 입사월인 경우 예외 정의
   PRAGMA EXCEPTION_INIT ( ex_invalid_month, -1843); -- 예외명과 예외코드 연결
   
   v_err_code error_log.error_code%TYPE;
   v_err_msg  error_log.error_message%TYPE;
   v_err_line error_log.error_line%TYPE;
BEGIN
 -- 부서테이블에서 해당 부서번호 존재유무 체크
 SELECT COUNT(*)
   INTO vn_cnt
   FROM departments
  WHERE department_id = p_department_id;
	  
 IF vn_cnt = 0 THEN
    RAISE ex_invalid_depid; -- 사용자 정의 예외 발생
 END IF;

-- 입사월 체크 (1~12월 범위를 벗어났는지 체크)
 IF SUBSTR(p_hire_month, 5, 2) NOT BETWEEN '01' AND '12' THEN
    RAISE ex_invalid_month; -- 사용자 정의 예외 발생
 END IF;

 -- employee_id의 max 값에 +1
 SELECT MAX(employee_id) + 1
   INTO vn_employee_id
   FROM employees;
 
-- 사용자예외처리 예제이므로 사원 테이블에 최소한 데이터만 입력함
INSERT INTO employees ( employee_id, emp_name, hire_date, department_id )
            VALUES ( vn_employee_id, p_emp_name, TO_DATE(p_hire_month || '01'), p_department_id );              
 COMMIT;

EXCEPTION WHEN ex_invalid_depid THEN -- 사용자 정의 예외 처리
               v_err_code := SQLCODE;
               v_err_msg  := '해당 부서가 없습니다';
               v_err_line := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
               ROLLBACK;
               error_log_proc ( 'ch10_ins_emp2_proc', v_err_code, v_err_msg, v_err_line); 
          WHEN ex_invalid_month THEN -- 입사월 사용자 정의 예외 처리
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
-- 잘못된 부서
EXEC ch10_ins_emp2_proc ('HONG', 100 , '201413'); -- 잘못된 월


SELECT *
FROM  error_log ;

delete error_log;
commit;

/*
    SAVEPOINT 
    보통 ROLLBACK을 명시하면 INSERT, DELETE, UPDATE, MERGE 
    작업 전체가 취소되는데 전체가 아닌 특정 부분에서 트랜잭션을 취소시킬 수 있다. 
    이렇게 하려면 취소하려는 지점을 명시한 뒤, 그 지점까지 작업을 취소하는 
    식으로 사용하는데 이 지점을 SAVEPOINT라고 한다. 
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


EXEC save_proc('1');        --세이브 포인트 1까지 롤백 후 커밋
EXEC save_proc('2');        --세이브 포인트 2까지 롤백 후 커밋   
EXEC save_proc('3');        --다 롤백
EXEC save_proc('4');        --정상 처리되어 다 저장된 후 커밋

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
	
	--기존 데이터 삭제
	DELETE ch10_sales
	 WHERE sales_month  = p_sales_month
	   AND country_name = p_country_name;
	      
	-- 신규로 월, 국가를 매개변수로 받아 INSERT 
	-- DELETE를 수행하므로 PRIMARY KEY 중복이 발생치 않음
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
       
 -- SAVEPOINT 확인을 위한 UPDATE

  -- 현재시간에서 초를 가져와 숫자로 변환한 후 * 10 (매번 초는 달라지므로 성공적으로 실행 시 이 값은 매번 달라짐)
 UPDATE ch10_sales
    SET sales_amt = 10 * to_number(to_char(sysdate, 'ss'))
  WHERE sales_month  = p_sales_month
	   AND country_name = p_country_name;
	   
       
       
 -- SAVEPOINT 지정      
 SAVEPOINT mysavepoint;      
 
 
 
 
 -- ch10_country_month_sales 테이블에 INSERT
 -- 중복 입력 시 PRIMARY KEY 중복됨
 INSERT INTO ch10_country_month_sales 
       SELECT sales_month, country_name, SUM(sales_amt)
         FROM ch10_sales
        WHERE sales_month  = p_sales_month
	        AND country_name = p_country_name
	      GROUP BY sales_month, country_name;         
       
 COMMIT;

EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(SQLERRM);
               ROLLBACK TO mysavepoint; -- SAVEPOINT 까지만 ROLLBACK
               COMMIT; -- SAVEPOINT 이전까지는 COMMIT

	
END;   

TRUNCATE TABLE ch10_sales;

EXEC iud_ch10_sales_proc ( '199901', 'Italy');

SELECT DISTINCT sales_amt
FROM ch10_sales;



EXEC iud_ch10_sales_proc ( '199901', 'Italy');

SELECT DISTINCT sales_amt
FROM ch10_sales;


------------------------------------------------------------------------------------
--=========================데이터 암호화=======================================================
/*
    데이터 암호화 
    오라클 데이터베이스에서 보안 관련 사항은 관점에 따라 크게 2가지 
    1. 사용자와 관련된 사항.
      - 사용자 계정, 비밀번호 관리와 인증방식, 권한과 롤 ( 이는 DBA가 처리함)
    2. 데이터 자체에 대한 보안.
      - 데이터보안은 개발자가 처리.
      
    데이터 보안을 강화 하는 한 가지 방법은 데이터 암호화.
    
    - 데이터 암호화란 민감하고 중요한 데이터를 암호화해서 테이블에 저장하고 이를 조회할 때 다시 복호화를 하는 일련의 과정.
    - 암호화된 데이터는 복호화 과정이 없다면 의미 없는 데이터 
    - 데이터가 통째로 유출되어도 암호화 덕분에 1차적인 안정망은 확복되었다고 볼 수 있다

    오라클 10g 부터 제공한 DBMS_CRYPTO 패키지
    

    양방향 알고리즘 : 암호화, 복호화 가능
    (대칭키,비대칭키)

    단방향 알고리즘 : 암화화 가능, 복호화 불가
    (hash)


    암호화는 여러 가지 알고리즘을 이용해 처리하는데  
    DBMS_CRYPTO 패키지를 활용해 구현 가능한 암호화 알고리즘은 
    --https://docs.oracle.com/cd/B19306_01/appdev.102/b14258/d_crypto.htm#i1004143 참조
    1.DES(Data Encryption Standard) : 미국 국립표준기술연구소에서 미국 표준으로 정했던 56비트 대칭키를 사용한 알고리즘(취약점이 발견되 표준에서 제외됨)
    2.3DES (DES 3번 반복 적용알고리즘) 
    3.AES(Advanced Encryption Standard) : DES를 대체하기 위해 만들어진 알고리즘 현재 미국 표준으로 사용 (대칭형 알고리즘) 
    4.MD5(Message-Digest algorithm5) : 128비트 암호화 해시 함수로 프로그램이나 파일이 원본 그대로인지 확인하는 무결성 검사 등에 사용 (암호화는 가능하지만 복호화가 매우 어려움)(단방향)
    5.SHA-1(Secure Hash Algorithm-1) : 160비트 해시 값을 만들어내는 암호화 해시 함수로  MD5보다 한단계 높은 버전(단방향)
    6.MAC(Message Authentication Code, 메세지인증코드) : MD5, SHA-1 같은 단방향 암호화 해시 함수인데 다른점은 비밀키를 입력 받아 사용.
    
    
    DBMS_CRYPTO 패키지 
    
    다양항 암호화 방식과 알고리즘을 사용하기 때문에 
    패키지 상수를 정의해 사용하는데 이는 모두  PLS_INTEGER 타입이다.
    
    1.암호화 알고리즘 상수 
      ENCRYPY_AES128 AES 블록 암호화로 128 비트 키를 사용
      ENCRYPY_AES192 AES 블록 암호화로 192 비트 키를 사용
      ENCRYPY_AES256 AES 블록 암호화로 256 비트 키를 사용    

    2.블록 암호화 모드 관련 상수
       블록 암호(Block Cipher)란 평문을 블록 단위로 암호화하는 대칭키 암호 시스템입니다.
       CHAIN_CBC : CBC(Chipher Block Chaing) 모드 

    3.패딩 관련 상수
      PAD_PKCS5: PKCS5(비밀번호 기반 암호화 표준으로 이루어진 패딩)
      PAD_NONE: 패딩이 없음을 의미
      PAD_ZERO: 0으로 이루어진 패딩       

    4.암호화 슈트 관련 상수 
      암호 알고리즘 + 암호화 모드 + 패딩 결합된것
      DBMS_CRYPYO 패키지의 암호화 관련 함수와 프로시저는 이런 암호화 슈트를 매개변수로 받아 데이터를 암호화 한다. 

    5.암호화 해시 함수 관련 상수 
      HASH_MD4 :MD4 128비트 해시
      HASH_MD4 :MD5 128비트 해시
      HASH_SH1 :SH1 160비트 해시

    6.MAC 함수 관련 상수 
      HMAC_MD5 : 해시 값을 검증하기 위해 비밀키를 사용함(나머지는 MD5와 같음)
      HMAC_SH1 : 해시 값을 검증하기 위해 비밀키를 사용함(나머지는 SHA1과 같음)
    


    -----------------------------------------------------------------------------
    ENCRYPT 함수는 key를 입력 받아 데이터를 암호화 슈트 방식으로 암호화한 결과를 반환(결과는 RAW 타입으로 반환)
    src : 암호화될 데이터
    typ : 암호화에 사용될 슈트
    key : 암호화 키
    iv : 초기화 벡터
    -----------------------------------------------------------------------------
    DECRYPT 함수는 암호화된 데이터를 매개변수로 받아 복호화 결과를 반환하는 함수.
    src : 복호화 데이터
    typ : 복호화에 사용될 암호화 슈트
    key : 암호화 키
    iv  : 초기화 백터
     -----------------------------------------------------------------------------   
    RAW타입으로 받아 문자형으로 반환

    
    HASH 함수 
    md4,md5,sha-1 을 사용해 해시 값을 생성 반환하는 함수. 
    
    MAC 함수 
    hash 함수와 비슷하나 매개변수로 사용할 비밀키를 더 입력받는다. 
*/




/*
 암호화 권한 테스트를 위해 
 sqlplus 엔터
 sys as sysdba 엔터 
 grant execute on DBMS_CRYPTO to java;
 -----------------------------------------------------비번 변경 
 */

grant execute on DBMS_CRYPTO to public;


DECLARE
  input_string  VARCHAR2 (200) := 'The Oracle';  -- 암호화할 VARCHAR2 데이터
  output_string VARCHAR2 (200); -- 복호화된 VARCHAR2 데이터 
  encrypted_raw RAW (2000); -- 암호화된 데이터 
  decrypted_raw RAW (2000); -- 복호화할 데이터 
  num_key_bytes NUMBER := 256/8; -- 암호화 키를 만들 길이 (256 비트, 32 바이트)
  key_bytes_raw RAW (32);        -- 암호화 키 

  -- 암호화 슈트 
  encryption_type PLS_INTEGER; 
  
BEGIN
	 -- 암호화 슈트 설정
	 encryption_type := DBMS_CRYPTO.ENCRYPT_AES256 + -- 256비트 키를 사용한 AES 암호화 
	                    DBMS_CRYPTO.CHAIN_CBC +      -- CBC 모드 
	                    DBMS_CRYPTO.PAD_PKCS5;       -- PKCS5로 이루어진 패딩
	
   DBMS_OUTPUT.PUT_LINE ('원본 문자열: ' || input_string);

   -- RANDOMBYTES 함수를 사용해 암호화 키 생성 
   key_bytes_raw := DBMS_CRYPTO.RANDOMBYTES (num_key_bytes);
   
   -- ENCRYPT 함수로 암호화를 한다. 원본 문자열을 UTL_I18N.STRING_TO_RAW를 사용해 RAW 타입으로 변환한다. 
   encrypted_raw := DBMS_CRYPTO.ENCRYPT ( src => UTL_I18N.STRING_TO_RAW (input_string, 'AL32UTF8'),   
                                          typ => encryption_type,
                                          key => key_bytes_raw
                                        );
                                        
   -- 암호화된 RAW 데이터를 한번 출력해보자
   DBMS_OUTPUT.PUT_LINE('암호화된 RAW 데이터: ' || encrypted_raw);                                     
   -- 암호화 한 데이터를 다시 복호화 ( 암호화했던 키와 암호화 슈트는 동일하게 사용해야 한다. )
   decrypted_raw := DBMS_CRYPTO.DECRYPT ( src => encrypted_raw,
                                          typ => encryption_type,
                                          key => key_bytes_raw
                                        );
   
   -- 복호화된 RAW 타입 데이터를 UTL_I18N.RAW_TO_CHAR를 사용해 다시 VARCHAR2로 변환 
   output_string := UTL_I18N.RAW_TO_CHAR (decrypted_raw, 'AL32UTF8');
   -- 복호화된 문자열 출력 
   DBMS_OUTPUT.PUT_LINE ('복호화된 문자열: ' || output_string);
END;



-- 단방향 암호화 해시 함수인 HASH, MAC 함수는 단방향으로 복호화가 매우 어렵고 
-- 통상 입력 값에 따라 암호화된 데이터를 비교함으로써 입력 값을 검증하는데 사용된다. 
-- ex 비밀번호 체크 
-- HASH, MAC 함수

DECLARE

  input_string  VARCHAR2 (200) := 'The Oracle';  -- 입력 VARCHAR2 데이터
  input_raw     RAW(128);                        -- 입력 RAW 데이터 

  encrypted_raw RAW (2000); -- 암호화 데이터 
  
  key_string VARCHAR2(8) := 'secret';  -- MAC 함수에서 사용할 비밀 키
  raw_key RAW(128) := UTL_RAW.CAST_TO_RAW(CONVERT(key_string,'AL32UTF8','US7ASCII')); -- 비밀키를 RAW 타입으로 변환
  
BEGIN
	-- VARCHAR2를 RAW 타입으로 변환
	input_raw := UTL_I18N.STRING_TO_RAW (input_string, 'AL32UTF8');
	
	
  DBMS_OUTPUT.PUT_LINE('----------- HASH 함수 -------------');
  encrypted_raw := DBMS_CRYPTO.HASH( src => input_raw,
                                     typ => DBMS_CRYPTO.HASH_SH1);
                                     
  DBMS_OUTPUT.PUT_LINE('입력 문자열의 해시값 : ' || RAWTOHEX(encrypted_raw));   
    
  
  DBMS_OUTPUT.PUT_LINE('----------- MAC 함수 -------------'); 
  encrypted_raw := DBMS_CRYPTO.MAC( src => input_raw,
                                    typ => DBMS_CRYPTO.HMAC_MD5,
                                    key => raw_key);   
                                    
  DBMS_OUTPUT.PUT_LINE('MAC 값 : ' || RAWTOHEX(encrypted_raw));
END;

-------------------------------------------------------------------------------
--------------------------------------------------
CREATE OR REPLACE FUNCTION fn_encode(input_pw VARCHAR2)
RETURN VARCHAR2
IS 
  input_raw     RAW(2000);   -- UTF-8 변환된 입력값 저장
  encrypted_raw RAW(2000);   -- 암호화된 결과 저장
BEGIN
    -- 입력 문자열을 UTF-8 인코딩된 RAW 데이터로 변환
    input_raw := UTL_I18N.STRING_TO_RAW(input_pw, 'AL32UTF8');
    
    -- SHA-1 해시 적용 (해시 타입을 숫자 '2'로 사용)
    encrypted_raw := DBMS_CRYPTO.HASH(
                        src => input_raw,
                        typ => 2);  -- SHA-1 알고리즘

    -- 해시된 결과를 16진수 문자열로 변환하여 반환
    RETURN RAWTOHEX(encrypted_raw);
END;



-----
select fn_encode('안녕하세요')
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

  input_string  VARCHAR2 (200) := 'The Oracle';  -- 입력 VARCHAR2 데이터
  input_raw     RAW(128);                        -- 입력 RAW 데이터 
  encrypted_raw RAW (2000); -- 암호화 데이터   
  key_string VARCHAR2(8) := 'secret';  -- MAC 함수에서 사용할 비밀 키
  raw_key RAW(128) := UTL_RAW.CAST_TO_RAW(CONVERT(key_string,'AL32UTF8','US7ASCII')); -- 비밀키를 RAW 타입으로 변환  
BEGIN
	input_raw := UTL_I18N.STRING_TO_RAW (input_string, 'AL32UTF8');
    encrypted_raw := DBMS_CRYPTO.MAC( src => input_raw,
                                    typ => DBMS_CRYPTO.HMAC_MD5,
                                    key => raw_key);                                     
  DBMS_OUTPUT.PUT_LINE('MAC 값 : ' || RAWTOHEX(encrypted_raw));
END;




-- 아이디와 비밀번호를 입력하면 이를 체크해 로그인하는 프로그램 
-- 사용자테이블의 아이디와 비밀번호를 저장하는데 이때 비밀번호를 입력된 번호 그대로 저장하는 것이 아니라 
-- 사용자가 입력한 값과 임의의 다른 값을 결합해 이를 HASH, MAC 함수의 입력 값으로 받아 반환된 결과 값을 비밀번호 컬럼에 저장. 
-- 시스템 관리자도 테이블의 암호화된 값을 알수 없고 오직 사용자만 알 수 있다. 

-- 비밀번호를 분실 했다면? 
-- 무작위로 신규비밀번호를 생성해 hash, mac 함수를 태워 변환된 값을 비밀번호 컬럼에 저장하고 사용자에게 신규 비밀번호를 부여 
-- 새로운 비번을 생성하게 유도함. 
-- 사용자가 만든 신규 비밀번호를 HASH나 MAC 함수의 매개변수로 받아 그 반환 값을 비밀번호 컬럼에 최종적으로 저장. 




개인정보의 안전성 확보조치 기준(안전행정부고시 제2011-43호, 2011.9.30 제정)

 
개인정보보호법의 비밀번호 일방향 암호화 및 패스워드 관리 솔루션
패스워드의 일방향 암호화에 사용되는 HASH 함수
제7조(개인정보의 암호화)
①영 제21조 및 영 제30조제1항제3호에 따라 암호화하여야 하는 개인정보는 고유식별정보, 비밀번호 및 바이오정보를 말한다.
②개인정보처리자는 제1항에 따른 개인정보를 정보통신망을 통하여 송.수신하거나 보조저장매체 등을 통하여 전달하는 경우에는 이를 암호화하여야 한다.
③개인정보처리자는 비밀번호 및 바이오정보는 암호화하여 저장하여야 한다. 단 비밀번호를 저장하는 경우에는 복호화되지 아니하도록 일방향 암호화하여 저장하여야 한다.
④개인정보처리자는 인터넷 구간 및 인터넷 구간과 내부망의 중간 지점(DMZ : Demilitarized Zone)에 고유식별정보를 저장하는 경우에는 이를 암호화하여야 한다.


