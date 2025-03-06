--1.member 계정을 만드세요
        --user id : member, password: member
        --권한도 부여해야 접속&테이블 생성 가능
ALTER SESSION SET "_ORACLE_SCRIPT" = true;        
CREATE USER member IDENTIFIED BY member;    
GRANT CONNECT, RESOURCE TO member;
GRANT UNLIMITED TABLESPACE TO member;
--2.해당 계정으로 접속(java에서)
        --java계정에서 (3)을 실행하지 마시오

--3.member_table(utf-8).sql 문을 실행하여 (테이블 생성 및 데이터 저장)
        --SELECT *
        --FROM member
        --WHERE mem_id= 'a001';


/*데이터 조작어 DMl
  Data Mainpulation Language
  테이블에 데이터 검색, 삽입 ,수정 ,삭제에 사용
  SELECT< INSERT, UPDATE, DELETE, MERGE(병합)
  */
--논리 연산자 >, < , >=, <=, <>. !=, ^= 
SELECT *FROM employees WHERE salary = 2600;      --같다
SELECT *FROM employees WHERE salary <> 2600;     --같지 않다
SELECT *FROM employees WHERE salary != 2600;     --같지 않다
SELECT *FROM employees WHERE salary ^= 2600;     --같지 않다
SELECT *FROM employees WHERE salary < 2600;      --미만
SELECT *FROM employees WHERE salary > 2600;      --초과
SELECT *FROM employees WHERE salary <= 2600;     --이하
SELECT *FROM employees WHERE salary >= 2600;     --이상

--논리 연산자를 이용하여 PRODUCTS 테이블에서(금액 오름차순)
--상품 최저금액(prod_min_price)이 30 '이상' 50 '미만'의 '상품명'을 조회하시오.
SELECT *
FROM products;

desc products;

    SELECT prod_name                   --상품명
        ,prod_min_price                --가격
FROM products
WHERE prod_min_price >=30              --30이상
AND prod_min_price   < 50              --50미만 조건 추가할때는 AND
ORDER BY prod_min_price, prod_name;

--하위 카테고리가 'CD-ROM'인 조건 추가(AND)
  SELECT prod_name                     --상품명
        ,prod_min_price                --가격
FROM products
WHERE prod_min_price >=30              --30이상
AND prod_min_price   < 50              --50미만 조건 추가할때는 AND
AND prod_subcategory = 'CD-ROM'        --하위 카테고리가 'cd-rom'인 조건 추가
ORDER BY prod_min_price, prod_name;


----직원중 10, 20번 부서인 직원만 조회하시오(이름, 부서번호, 봉급) AND 말고 OR 사용
SELECT emp_name
     , department_id
     , salary
FROM employees
WHERE department_id = 10
OR    department_id = 20;       or또는

--표현식 CASE문(END로 마무리해야함)
--table의 값을 특정 조건에 따라 다르게 표현하고 싶을때 사용
--salary가 5000이하 C등급, 5000초과 15000이하 B등급, 15000초과 A등급
SELECT emp_name
      ,salary
      ,CASE WHEN salary <= 5000 THEN 'C등급'    
            WHEN salary >  5000 AND salary <= 15000 THEN 'B등급'
        ELSE 'A등급'                           --그 밖에~
       END as salary_grade
FROM employees
ORDER BY salary DESC;                          --DESC가 뜻하는건???

--논리 조건식 AND OR NOT
SELECT emp_name
      ,salary
FROM employees
WHERE NOT (salary >= 2500);                     --NOT 반대되는 개념 2500이 아닐때

--IN 조건(OR 이 많을때)
SELECT emp_name, department_id
FROM employees
WHERE department_id IN(10, 20, 30, 40)         --또는 조건이 많을때 사용
WHERE department_id NOT IN(10, 20, 30, 40);     --해당 조건이 아닌 (NOT)



--BETWEEN a AND b 조건식 a~b까지
SELECT emp_name, salary
FROM employees
WHERE salary BETWEEN 2000 AND 2500;



--LIKE 조선식 % <-- 모든
SELECT emp_name
FROM employees
--WHERE emp_name LIKE 'A%';                       --A로 시작하는 모든 ~
--WHERE emp_name LIKE '%a';                      --%가 앞에 있으면 a로 끝나는 모든~
WHERE emp_name LIKE '%a%';                        --a가 있는 모든

CREATE TABLE ex2_1(                                     --ex_1테이블 만들기
    nm VARCHAR2(30)
);
INSERT INTO ex2_1 VALUES('김팽수');                        --행에 삽입
INSERT INTO ex2_1 VALUES('팽수');
INSERT INTO ex2_1 VALUES('팽수닷');
INSERT INTO ex2_1 VALUES('남궁팽수');

SELECT *
FROM ex2_1
WHERE nm Like '팽수_';                               --자리수 _


--member 테이블 회원 중 김씨 정보만(아이디, 이름, 마일리지, 생일) 조회하시오
SELECT mem_id
      ,mem_name
      ,mem_mileage
      ,mem_bir
FROM member
WHERE mem_name LIKE '김%';



--member회원의 정보를 조회하세요
--단 mem_mileage 6000이상 vip
--6000미만 3000이상 gold 
--그밖에 silver로 출력(grade)
--아이디,이름, 직업, 등급 ,주소 (add1 + add2)출력(addr)
SELECT mem_id
      ,mem_name
      ,mem_job
      ,mem_mileage
      ,CASE WHEN mem_mileage >= 6000 THEN   'VIP'
            WHEN mem_mileage <= 6000 AND mem_mileage >= 3000 THEN 'GOLD'
            ELSE'SILVER'
            END as grade
      ,mem_add1 || mem_add2 as addr                 --주소출력
FROM member
ORDER BY mem_mileage DESC;
--ORDER BY 4 DESC, 2 ASC; --숫자는 select 절에 오는 순서로 사용가능



--null 조회는 IS NULL or IS NOT NULL로 가능
SELECT prod_name
      ,pord_size
FROM prod
WHERE prod_size IS NULL;          --null인 데이터 검색    
--WHERE prod_size = null;         --x검색안됨
--WHERE prod_size IS NOT null;         --null이 아닌 데이터 검색

     
    
 --내가 했던 풀이    
-- CASE WHEN mileage >  6000 THEN 'VIP'
--     WHEN mileage <  6000
--   AND  mileage >= 3000 THEN 'gold'
-- ELSE 'sliver'
--END as mileage_grade
--FROM member
--ORDER BY mileage DESC;




--숫자 함수
SELECT ABS(10)
      ,ABS(-10)
FROM dual;              -- <--dual임시 테이블과 같은
                        --(sql 사용 문법이 from 뒤에는 table 존재해야해서 사용)

--CEIL 올림, FLOOR 버림, ROUND 반올림
SELECT CEIL(10.01)
        ,ROUND(10.01)
        ,FLOOR(10.01)
FROM dual;
--ROUND(n, i) 매개변수 n을 소수점 i+1 번째에서 반올림한 결과를 반한
--          i는 디폴트 0, i 가 음수면 소수점을 기준으로 왼쪽 i번째에서 반올림
SELECT ROUND(10.154, 1)         --10.2출력
      ,ROUND(10.154, 2)         --10.15출력
      ,ROUND(10.154, -1)        --10출력
FROM dual;



--mod(m,n) m을 n으로 나누었을때 나머지 반환      0출력됨
SELECT MOD(4,2)
      ,MOD(4,2)
FROM dual;


--SQRT n의 제곱근 반환
SELECT SQRT(4)
      ,SQRT(8)
      ,ROUND(SQRT(8), 2)                --2.83출력됨.
FROM dual;



--문자함수
SELECT LOWER('HI')              --소문자로 변경
      ,UPPER('hi')              --대문자로 변경
FROM dual;

--문자함수 예제1. (검색될때 대소문자 변경)
SELECT   emp_name
        ,LOWER(emp_name)
        ,UPPER(emp_name)
FROM employees;

--이름에 smith가 있는 직원 조회
--nm <--검색조건에 :변수명 (바인드 테스트가 가능함 여러 케이스로 테스트할때 사용)
SELECT emp_name             --이름조회
FROM employees                
--WHERE LOWER(emp_name) LIKE '%' || LOWER('%smIth%') || '%';
WHERE LOWER(emp_name) LIKE '%' || LOWER(:nm) || '%';            --:nm을 통해 사용자입력받음(변수이름은 자유)





SELECT SUBSTR('ABCDEFG', 1, 4)       --a부터 4자리 
      ,SUBSTR('ABCDEFG', -4, 3)
      ,SUBSTR('ABCDEFG', -4, 1)
      ,SUBSTR('ABCDEFG', 5)          --5번째이후 다 출력
FROM dual;
--substr(char, pos, len) char의 pos번째 문자부터 len 길이만큼 자른 뒤 반환
--len이 없으면 pos부터 끝까지 
--len이 음수면 뒤에서 부터 



--회원의 성별을 출력하시오
--이름, 성별 (주민번호 뒷자리 첫째 자리 홀수 (남자), 짝수 (여자))
SELECT mem_name
      ,mem_regno2
      ,SUBSTR(mem_regno2, 1,1)
      ,MOD(SUBSTR(mem_regno2, 1,1) ,2)
      ,CASE WHEN MOD(SUBSTR(mem_regno2, 1,1) ,2) = 0 THEN '여자'
      ELSE '남자'
      END as gender
FROM member;





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
       -- (2)'수강내역' 테이블의 PK 키를 '수강내역번호'로 잡아준다 
        ALTER TABLE 수강내역 ADD CONSTRAINT PK_학생_수강내역 PRIMARY KEY (수강내역);
       -- (3)'과목' 테이블의 PK 키를 '과목번호'로 잡아준다 
       ALTER TABLE 과목 ADD CONSTRAINT PK_학생_과목번호 PRIMARY KEY (과목번호);
        --(4)'교수' 테이블의 PK 키를 '교수번호'로 잡아준다
        ALTER TABLE 교수 ADD CONSTRAINT PK_학생_교수번호 PRIMARY KEY (교수번호);
        --(5)'강의내역'의 PK를 '강의내역번호'로 잡아준다. 
        ALTER TABLE 강의내역 ADD CONSTRAINT PK_학생_강의내역번호 PRIMARY KEY (강의내역번호);
        --(6)'학생' 테이블의 PK를 '수강내역' 테이블의 '학번' 컬럼이 참조한다 FK 키 설정
         ADD CONSTRAINT FK_학생_학번 FOREIGN KEY(학번)
        --(7)'과목' 테이블의 PK를 '수강내역' 테이블의 '과목번호' 컬럼이 참조한다 FK 키 설정 
        ADD CONSTRAINT FK_학생_과목 FOREIGN KEY(과목)
        --(8)'교수' 테이블의 PK를 '강의내역' 테이블의 '교수번호' 컬럼이 참조한다 FK 키 설정
        ADD CONSTRAINT FK_학생_교수 FOREIGN KEY(교수번호)
        --(9)'과목' 테이블의 PK를 '강의내역' 테이블의 '과목번호' 컬럼이 참조한다 FK 키 설정
        ADD CONSTRAINT FK_학생_과목 FOREIGN KEY(과목번호)
         --   각 테이블에 엑셀 데이터를 임포트 

   
       
        REFERENCES 학생(학번);



        







