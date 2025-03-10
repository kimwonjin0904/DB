/*
    table 테이블
    1.테이블 명 컬러명의 최대크기는 300byte (영문자 1개 1byte)
    2.테이블 명 컬럼명으로 예약어는 사용할 수 없음(select, varchar2)
    3.테이블명 컬럼명으로 문자 숫자 _, #을 사용할 수 있지만
        첫 글자는 문자만 올 수 있음.
    4.한 테이블에 사용 가능한 컬럼은 최대 255개
    
    명령어는 대소문자를 구별하지 않음.(저장되는 테이블 정보가 대문자로 저장됨)
    데이터는 대소문자를 구별함
*/
CREATE TABLE ex1_1(
    col1 CHAR(10)
   ,col2 VARCHAR(10)   --컬럼은 ,로 구분되며 하나의 컬럼은 하나의 타입과사이즈를 가짐
);
--INSERT 데이터 삽임
INSERT INTO ex1_1(col1, col2)
VALUES ('oracle', 'oracle');
INSERT INTO ex1_1(col1, col2)
VALUES ('오라클', '오라클');
INSERT INTO ex1_1(col1, col2)
VALUES ('오라클db', '오라클db');

SELECT *        --* 전체(컬럼)를 의미함
FROM ex1_1;

SELECT col1     --조회하고 싶은 컬럼 작성.
FROM ex1_1;

--length() <- 함수 문자열 길이, lengthb() <--문자열의 크기(byte)
SELECT col1, col2
    ,length(col1), length(col2), lengthb(col1), lengthb(col2)
FROM ex1_1;


SELECT *        --* 전체(컬럼)를 의미함
FROM employees;     --from절은 조회하고자 하는 테이블작성.
DESC employees;     --테이블 정보 간단 조회 

SELECT emp_name as nm         --직원명,월급등만 조회   //As, as(alies 별칭)
    ,hire_date  hd             --콤마를 구분으로 컬럼명 띄어쓰기 이후 단어는 별칭으로 인식
    ,salary     sa_la                --별칭으로 띄어쓰기는 안됨.(언더바 사용)
    ,department_id "부서 아이디"     --한글 별칭은 안스지만 쓰려면 ""
FROM employees;

--검색조건 where(검색하려는 조건있을때 이름등등)
SELECT *
FROM employees
WHERE salary >= 20000;      --2만 이상

--검색조건이 여러개 (10000~ 11000이면서 부서아이디가 80인 직원조회)
SELECT *
FROM employees
WHERE salary >= 10000
AND   salary <  11000   --and 그리고 해당 조건은 둘다 true 일때 행만 조회
AND department_id = 80      --부서아이디가 80
;

--정렬조건 ASC:오름차순(디폴트), DESC 내림차순
SELECT *
FROM employees
WHERE salary >= 10000
AND   salary <  11000   
AND department_id = 80 
ORDER BY department_id DESC --ASC
;

----------------------------------------
SELECT emp_name
FROM employees
WHERE salary >= 10000
  AND salary < 11000  -- 급여가 10,000 이상 11,000 미만인 직원
  AND department_id = 80 -- 부서 ID가 80인 직원
ORDER BY emp_name DESC; -- 직원 이름을 내림차순으로 정렬 
--oreder by emp_name asc(생략가능);



--사칙연산 사용가능
--ROUND(반올림 함수)
SELECT emp_name            AS 직원
    ,salary                AS 월급
    ,salary - salary * 0.1 AS 실수령액
    ,salary *12            AS 연봉
    ,ROUND(salary/22.5,2)  AS 일당
FROM employees;

/*
숫자 데이터 타입 NUMBER
number(p,s) p는 소수점을 기준으로 모든 유효숫자 자릿수를 의미함.
            s는 소수점 자리수를 의미함(디폴트 0)
            s가 2면 소수점 2자리 까지 (나머지는 반올림됨.)
            s가 음수 이면 소수점 기준으로 왼쪽 자리만큼 반올림됨.
*/
--drop table ex1_2;
CREATE TABLE ex1_2(
    col1 NUMBER(3)              --정수만 3자리
   ,col2 NUMBER(3,  2)          --정수1, 소수점 2자리까지
   ,col3 NUMBER(5, -2)          --십의 자리까지 반올림 (총7자리)        -2소수점 기준으로 2번
   ,col4 NUMBER
);
INSERT INTO ex1_2 (col1) VALUES (0.789);
INSERT INTO ex1_2 (col1) VALUES (99.6);
INSERT INTO ex1_2 (col1) VALUES (1004);     --오류남

INSERT INTO ex1_2 (col2) VALUES (0.7898);
INSERT INTO ex1_2 (col2) VALUES (1.7898);
INSERT INTO ex1_2 (col2) VALUES (9.9998);       --오류
INSERT INTO ex1_2 (col2) VALUES (10);             --오류  

INSERT INTO ex1_2 (col3) VALUES (12345.2345);
INSERT INTO ex1_2 (col3) VALUES (1234569.2345);
INSERT INTO ex1_2 (col3) VALUES (12345699.2345);        --오류 7자리 넘음
SELECT * FROM ex1_2;


/* 날짜 데이터 타입(data 년월일시분초, timestamp 년월일시분초.밀리초)
    sysdate 현재시간, systimestamp 현재시간.밀리초
*/

CREATE TABLE ex1_3(
     date1 DATE
    ,date2 TIMESTAMP
);
INSERT INTO ex1_3 VALUES(SYSDATE, SYSTIMESTAMP);
SELECT * FROM ex1_3;
--COMMIT; --물리적으로 반영
--ROLLBACK; --되돌리기








