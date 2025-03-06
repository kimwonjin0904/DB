/*       강의내역, 과목, 교수, 수강내역, 학생 테이블을 만드시고 아래와 같은 제약 조건을 준 뒤 
        (1)'학생' 테이블의 PK 키를  '학번'으로 잡아준다 
        (2)'수강내역' 테이블의 PK 키를 '수강내역번호'로 잡아준다 
        (3)'과목' 테이블의 PK 키를 '과목번호'로 잡아준다 
        (4)'교수' 테이블의 PK 키를 '교수번호'로 잡아준다
        (5)'강의내역'의 PK를 '강의내역번호'로 잡아준다. 

        (6)'학생' 테이블의 PK를 '수강내역' 테이블의 '학번' 컬럼이 참조한다 FK 키 설정
        (7)'과목' 테이블의 PK를 '수강내역' 테이블의 '과목번호' 컬럼이 참조한다 FK 키 설정 
        (8)'교수' 테이블의 PK를 '강의내역' 테이블의 '교수번호' 컬럼이 참조한다 FK 키 설정
        (9)'과목' 테이블의 PK를 '강의내역' 테이블의 '과목번호' 컬럼이 참조한다 FK 키 설정
            각 테이블에 엑셀 데이터를 임포트 

    ex) ALTER TABLE 학생 ADD CONSTRAINT PK_학생_학번 PRIMARY KEY (학번);
        
        ALTER TABLE 수강내역 
        ADD CONSTRAINT FK_학생_학번 FOREIGN KEY(학번)
        REFERENCES 학생(학번);

*/
CREATE TABLE 강의내역 (
     강의내역번호 NUMBER(3)
    ,교수번호 NUMBER(3)
    ,과목번호 NUMBER(3)
    ,강의실 VARCHAR2(10)
    ,교시  NUMBER(3)
    ,수강인원 NUMBER(5)
    ,년월 date
);

CREATE TABLE 과목 (
     과목번호 NUMBER(3)
    ,과목이름 VARCHAR2(50)
    ,학점 NUMBER(3)
);

CREATE TABLE 교수 (
     교수번호 NUMBER(3)
    ,교수이름 VARCHAR2(20)
    ,전공 VARCHAR2(50)
    ,학위 VARCHAR2(50)
    ,주소 VARCHAR2(100)
);

CREATE TABLE 수강내역 (
    수강내역번호 NUMBER(3)
    ,학번 NUMBER(10)
    ,과목번호 NUMBER(3)
    ,강의실 VARCHAR2(10)
    ,교시 NUMBER(3)
    ,취득학점 VARCHAR(10)
    ,년월 DATE 
);

CREATE TABLE 학생 (
     학번 NUMBER(10)
    ,이름 VARCHAR2(50)
    ,주소 VARCHAR2(100)
    ,전공 VARCHAR2(50)
    ,부전공 VARCHAR2(500)
    ,생년월일 DATE
    ,학기 NUMBER(3)
    ,평점 NUMBER
);


COMMIT;

      -- 강의내역, 과목, 교수, 수강내역, 학생 테이블을 만드시고 아래와 같은 제약 조건을 준 뒤 
      --  (1)'학생' 테이블의 PK 키를  '학번'으로 잡아준다
        ALTER TABLE 학생 ADD CONSTRAINT PK_학생_학번 PRIMARY KEY (학번);
         REFERENCES 학생(학번);
       -- (2)'수강내역' 테이블의 PK 키를 '수강내역번호'로 잡아준다 
        ALTER TABLE 수강내역 ADD CONSTRAINT PK_학생_수강내역 PRIMARY KEY (수강내역);
         REFERENCES 학생(수강내역);
       -- (3)'과목' 테이블의 PK 키를 '과목번호'로 잡아준다 
       ALTER TABLE 과목 ADD CONSTRAINT PK_학생_과목번호 PRIMARY KEY (과목번호);
        REFERENCES 학생(과목번호);
        --(4)'교수' 테이블의 PK 키를 '교수번호'로 잡아준다
        ALTER TABLE 교수 ADD CONSTRAINT PK_학생_교수번호 PRIMARY KEY (교수번호);
         REFERENCES 학생(교수번호);
        --(5)'강의내역'의 PK를 '강의내역번호'로 잡아준다. 
        ALTER TABLE 강의내역 ADD CONSTRAINT PK_학생_강의내역번호 PRIMARY KEY (강의내역번호);
         REFERENCES 학생(강의내역번호);
        --(6)'학생' 테이블의 PK를 '수강내역' 테이블의 '학번' 컬럼이 참조한다 FK 키 설정
         ADD CONSTRAINT FK_학생_학번 FOREIGN KEY(학번)
          REFERENCES 학생(학번);
        --(7)'과목' 테이블의 PK를 '수강내역' 테이블의 '과목번호' 컬럼이 참조한다 FK 키 설정 
        ADD CONSTRAINT FK_학생_과목 FOREIGN KEY(과목)
        REFERENCES 학생(과목);
        --(8)'교수' 테이블의 PK를 '강의내역' 테이블의 '교수번호' 컬럼이 참조한다 FK 키 설정
        ADD CONSTRAINT FK_학생_교수 FOREIGN KEY(교수번호)
         REFERENCES 학생(교수번호);
        --(9)'과목' 테이블의 PK를 '강의내역' 테이블의 '과목번호' 컬럼이 참조한다 FK 키 설정
        ADD CONSTRAINT FK_학생_과목 FOREIGN KEY(과목번호)
         REFERENCES 학생(과목번호);
         --   각 테이블에 엑셀 데이터를 임포트 

   
       
---------------------------
--공백제거 TRIM LTRIM RTRIM
SELECT LTRIM(' ABC ') as l
      ,LTRIM(' ABC ') as r          --왼쪽   공백 제거 L
      ,RTRIM(' ABC ') as r          --오른쪽 공백 제거R
      ,TRIM('ABC') as al
FROM dual;


--문자열 패딩(LPAD, RPAD)
SELECT LPAD(123, 5, '0')     as lpl1         --LAPD(대상, 길이, 패드)길이 만큼
      ,LPAD(1,   5, '0')     as lpl2
      ,LPAD(123456, 5, '0')  as lpl3         --주의 길이만큼(넘어서면 제거됨)
      ,RPAD(2,5, '*')        as rp1          --R은 오른쪽부터  (???한번더 보기)
FROM dual;


--REPLACE(대상,찾는,변경)
--TRANSLATE 한글자씩 매칭
SELECT REPLACE  ('나는 너를 모르는데 너는 나를 알겠는가?', '나는', '너를') as re  --????
      ,TRANSLATE('나는 너를 모르는데 너는 나를 알겠는가?', '나는', '너를') as tr --????
FROM dual;


--INSTR 문자열 위치 찾기(p1, p2, p3, p4) p1:대상문자열,  p2:찾을 문자열, p3:시작, p4 째
SELECT INSTR('안녕 만나서 반가워, 안녕은 hi', '안녕')        as ins1  -- 기본값 (1,1)
      ,INSTR('안녕 만나서 반가워, 안녕은 hi', '안녕', 5)     as ins2  -- 5번째 문자부터 검색
      ,INSTR('안녕 만나서 반가워, 안녕은 hi', '안녕', 1, 2)  as ins3  -- 1번째 문자부터, 2번째 '안녕' 찾기
      ,INSTR('안녕 만나서 반가워, 안녕은 hi', 'hello')       as ins4  -- 없으면 0 반환
FROM dual;



--tb_info 학생의 이메일 주소를(idm domain으로 분리하여 출력하시오)
--pangsu@gmail.com-->> id:pansu, domain:gmail.com

SELECT nm, email
        --,INSTR(email, '@') -1
        ,SUBSTR(email, 1, INSTR(email, '@') -1) as 아이디
        ,SUBSTR(email, INSTR(email, '@')    +1) as 도메인
FROM tb_info;        
 
--내가 풀이한 것
SELECT nm, email
       ,SUBSTR('pangsu@gmail.com',6) as 아이디
       ,SUBSTR('pangsu@gmail.com',8) as 도메인
FROM tb_info;

---------------------------------------------------
SELECT SUBSTR('ABCDEFG', 1, 4)       --a부터 4자리 
      ,SUBSTR('ABCDEFG', -4, 3)
      ,SUBSTR('ABCDEFG', -4, 1)
      ,SUBSTR('ABCDEFG', 5)          --5번째이후 다 출력
FROM dual;
--substr(char, pos, len) char의 pos번째 문자부터 len 길이만큼 자른 뒤 반환
--len이 없으면 pos부터 끝까지 
--len이 음수면 뒤에서 부터 
--shift tab





/* 변환함수(타입) 많이 사용함.(날짜 시간 관련 TOCHAR)
TO_CHAR 문자형으로 
TO_DATE 날짜
TO_NUMBER 숫자~
*/
SELECT TO_CHAR(123456,  '999,999,999')              as ex1
      ,TO_CHAR(SYSDATE, 'YYYY-MM-DD')               as ex2
      ,TO_CHAR(SYSDATE, 'YYYYMMDD')                 as ex3
      ,TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')    as ex4
      ,TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')    as ex5
      ,TO_CHAR(SYSDATE, 'day')                      as ex6
      ,TO_CHAR(SYSDATE, 'YY')                       as ex7
      ,TO_CHAR(SYSDATE, 'DD')                       as ex8
      ,TO_CHAR(SYSDATE, 'd')                        as ex9  --요일
FROM dual;


--TODATE 
SELECT TO_DATE('231229', 'YYMMDD')                              as ex1
      ,TO_DATE('2025 01 21 09:10:00', 'YYYY MM DD HH24:MI:SS') as ex2
      ,TO_DATE('45','YY')                                       as ex3
      ,TO_DATE('50', 'RR')                                      as ex4
      ,TO_DATE('49','RR')   --Y2k 2000년 문제에 대한 댇응책으로 도입됨. 50-> 1950, 49-> 2049
FROM dual;


--ex5_1 테이블 생성
CREATE TABLE ex5_1(
    seq1 VARCHAR2(100)
   ,seq2 NUMBER
);
--정렬p 160  TO NUMBER
INSERT INTO ex5_1 VALUES('1234','1234');
INSERT INTO ex5_1 VALUES('99','99');
INSERT INTO ex5_1 VALUES('195','195');
SELECT *
FROM ex5_1
ORDER BY TO_NUMBER(seq1) ASC;
//ORDER BY seq2 ASC;


--ex5_2테이블 생성
CREATE TABLE ex5_2(
     title VARCHAR2(100)
    ,d_day DATE
);
INSERT INTO ex5_2 VALUES('시작일','20250121');                 --VALUES는 어떨때 사용??? INSERT INTO???
INSERT INTO ex5_2 VALUES('종료일','2025.07.09');

SELECT *
FROM ex5_2;

INSERT INTO ex5_2 VALUES('탄소교육','2025.02.24');
INSERT INTO ex5_2 VALUES('취업특강','2025.03.31 10:00:00');  --오류남
INSERT INTO ex5_2 VALUES('탄소교육',TO_DATE('2025.03.31 10:00:00', 'YYYY MM DD HH24:MI:SS'));



--회원의 생년월일을 이용하여 나이를 출력하세요
--올해 년도이용(ex 2025- 2000) 25세
--정렬은  mem_bir 내림차순.
--TO_CHAR
SELECT mem_name
     , mem_bir
     , TO_CHAR(mem_bir, 'YYYY') as 출생년도
     , TO_CHAR(SYSDATE, 'YYYY') as 현재년도
     , TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(mem_bir, 'YYYY') || '세' as 나이
FROM member
ORDER BY mem_bir DESC;


SELECT *
FROM member;




/*날짜 데이터 타입 관련 함수
 ADD_MONTHS(날짜,1)다음 달
 LAST_DAY(날짜) 해당 월의 마지막 날
 NEXT_DAY('날짜', '요일')가까운 해당 요일의 날짜
*/
SELECT ADD_MONTHS(SYSDATE, 1)      as ex1      -- 다음달
      ,ADD_MONTHS(SYSDATE, -1)     as ex2      -- 전달
      ,LAST_DAY(SYSDATE)           as ex3      -- 이번 달의 마지막 날
      ,NEXT_DAY(SYSDATE, '금요일') as ex4      -- 다음 금요일
      ,NEXT_DAY(SYSDATE, '토요일') as ex5      -- 다음 토요일
      ,SYSDATE  -1                 as ex6       --어제  (-1은 하루 즉 하루전날)
      ,ADD_MONTHS(SYSDATE, 1) - ADD_MONTHS(SYSDATE, -1) as ex7
FROM dual;



SELECT SYSDATE - mem_bir
      ,SYSDATE sy
      ,mem_bir
      ,TO_CHAR(SYSDATE, 'YYYYMMDD') - TO_CHAR(mem_bir, 'YYYYMMDD')                   as ex1 --숫자계산
      ,TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD')) - TO_DATE(TO_CHAR(mem_bir, 'YYYYMMDD')) as ex2 --날자계산
FROM member;



--그럼 이번 달은 몇일 남았을까요?
--선생님 답
SELECT LAST_DAY(SYSDATE) - SYSDATE
FROM dual;
--내가풀이한거
SELECT ADD_MONTHS(SYSDATE, 1)      as ex1      -- 다음달     
      ,LAST_DAY(SYSDATE)           as ex3      -- 이번 달의 마지막 날      
      ,SYSDATE  -1                 as ex6       --어제  (-1은 하루 즉 하루전날)
      ,ADD_MONTHS(SYSDATE, 0)      as ex7
      ,LAST_DAY(SYSDATE) - ADD_MONTHS(SYSDATE, 0) as ex8
FROM dual;



--20250709까지 얼마나 남았을까요?
-----------------답------------
SELECT TO_DATE('20250709')
     , TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'))
     , TO_DATE('20250709') - TO_DATE(TO_CHAR(SYSDATE,'YYYYMMDD')) as 종료일까지
FROM dual;


-------------------내가 한 풀이--------------
--1.
SELECT ADD_MONTHS(SYSDATE, 5) -12      as ex1      --  7/9
      ,LAST_DAY(SYSDATE) - ADD_MONTHS(SYSDATE, 0) as ex8  --7일
      ,LAST_DAY(SYSDATE) + ADD_MONTHS(SYSDATE, 5) -12   as ex3  
FROM dual;
--2.
SELECT TO_DATE('20250709')
      ,SYSDATE
FROM dual;
--------------------------------------------------
SELECT ADD_MONTHS(SYSDATE, 1)      as ex1      -- 다음달
      ,ADD_MONTHS(SYSDATE, -1)     as ex2      -- 전달
      ,LAST_DAY(SYSDATE)           as ex3      -- 이번 달의 마지막 날
      ,NEXT_DAY(SYSDATE, '금요일') as ex4      -- 다음 금요일
      ,NEXT_DAY(SYSDATE, '토요일') as ex5      -- 다음 토요일
      ,SYSDATE  -1                 as ex6       --어제  (-1은 하루 즉 하루전날)
      ,ADD_MONTHS(SYSDATE, 1) - ADD_MONTHS(SYSDATE, -1) as ex7
FROM dual;




--DECODE 표현식 특정 값일때 표현변경
SELECT *            --조회
FROM customers;

SELECT cust_id
      ,cust_name
      ,cust_gender
      ,DECODE(cust_gender, 'M', '남자', '여자') as gender  --cust_gender가 M이면 (true) 남자, 그 밖에는 여자
      ,DECODE(cust_gender, 'M', '남자', '여자','!!?') as gender  --'!!?'이건뭐지??
FROM customers;


----------------------------------------
SELECT *            --products조회
FROM products;

--DISTINCT (중복 제거)
--중복된 데이터를 제거하고 고유한 값을 반환
SELECT DISTINCT prod_category
FROM products;
--행 조합이 중복되지 않는 갑 반환
SELECT DISTINCT prod_category, prod_subcategory
FROM products
ORDER BY 1;                    //order by 뭔지 다시보기


--NVL(컬럼, 반환값) 컬럼 같이 null일 경우 반환값 리턴
SELECT emp_name
      ,salary
      ,commission_pct
      ,salary + salary * commission_pct         AS 상여금포함1  -- NULL 값 발생 가능 //salary *commission_pct무슨역할?
      ,salary + salary * NVL(commission_pct, 0) AS 상여금포함2  -- NULL 안전 처리
FROM employees;



/*  문제
    1.employess 직원중 근속년수가 30년 이상인 직원만 출력하시오 (근속년수 내림차순)
    2.customers 고객의 나이를 기준으로 30대, 40대, 50대를 구분하여 출력(나머지 연령대는 '기타')
     정렬(연령 오름차순), 검색조건(1.도시, 2.출생년도:1960~1990년 출생 3. 결혼상태:single 5.성별:남)
*/
--1번문제
SELECT *  --조회
FROM employees;

------답-----
SELECT emp_name, hire_date
        ,TO_CHAR(SYSDATE,   'YYYY')
        ,TO_CHAR(hire_date, 'YYYY')
        ,TO_CHAR(SYSDATE,   'YYYY') - ,TO_CHAR(hire_date, 'YYYY') as 근속년수
FROM employees
WHERE TO_CHAR(SYSDATE,   'YYYY') - ,TO_CHAR(hire_date, 'YYYY') >= 26;
ORDER BY 근속년수 DESC, hire_date ASC ;
------------
SELECT emp_name, 
       hire_date,
       TO_CHAR(SYSDATE, 'YYYY') AS 현재년도,
       TO_CHAR(hire_date, 'YYYY') AS 입사년도,
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM hire_date) AS 근속년수
FROM employees
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM hire_date) >= 26
ORDER BY 근속년수 DESC, hire_date ASC;




--------------내가한풀이-----------
SELECT emp_name
      ,hire_date
      ,ADD_MONTHS(hire_date ,360) as 근속년수
      ,TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(hire_date, 'YYYY') as 근속년수2
      ,SYSDATE
     --오류  ,ADD_MONTHS(hire_date ,360) as 근속년수 - TO_CHAR(hire_date, 'YYYY') as 근속
     --정렬
FROM employees;




--2번문제--
------답-----
SELECT cust_name,
       cust_year_of_birth,
       TO_CHAR(SYSDATE, 'YYYY') - cust_year_of_birth AS age,
       DECODE(TRUNC((TO_CHAR(SYSDATE, 'YYYY') - cust_year_of_birth) / 10), 
              3, '30대', 
              4, '40대', 
              5, '50대', 
              '기타') AS 연령,
       cust_gender,
       cust_marital_status,
       cust_city
FROM customers
WHERE cust_city = 'Aachen'
AND cust_gender = 'M'
AND cust_marital_status IS NOT NULL  -- NULL이 아닌 값만 포함
AND cust_year_of_birth BETWEEN 1960 AND 1990
ORDER BY cust_year_of_birth DESC;




------내 풀이-----------
SELECT cust_name
      ,cust_year_of_birth
     -- ,TO_CHAR(cust_year_of_birth, 'YYYY') as 출생년도
      --,TO_CHAR(SYSDATE, 'YYYY') as 현재년도
    -- ,TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(cust_year_of_birth, 'YYYY')  || as 나이
      
FROM customers
ORDER BY cust_year_of_birth


-------------------------------------
SELECT mem_name
     , mem_bir
     , TO_CHAR(mem_bir, 'YYYY') as 출생년도
     , TO_CHAR(SYSDATE, 'YYYY') as 현재년도
     , TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(mem_bir, 'YYYY') as 나이
FROM member
ORDER BY mem_bir DESC;

---------------


SELECT *            --조회
FROM customers;

