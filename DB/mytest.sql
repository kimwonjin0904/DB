create_dt DATE DEFAULT SYSDATE  -- create문에 추가하면 실행돌린날짜가 뜸


--ex1_4전체 다 업데이트 됨
UPDATE ex1_4
SET age = 10   --set함수는 무언가 수정할때  
WHERE mem_id = 'a001';

--a001 age 수정(수정되었는지 확인)
SELECT *
FROM ex1_4
WHERE mem_id= 'a001';

--조회--
SELECT *
FROM employees;
------------------

DESC employees;
-----------------

SELECT emp_name
FROM employees;
----------------
--DISTINCT는 중복 제거
SELECT DISTINCT emp_name
FROM employees;

SELECT emp_name
FROM employees;


--ORDER BY(오름차순 밑으로 갈수록 커짐)--
SELECT manager_id
FROM employees
ORDER BY manager_id;




--DESC(내림차순 위로 갈수록 커짐)--
SELECT manager_id
FROM employees
ORDER BY manager_id DESC;




--ASC--
SELECT manager_id, employee_id
FROM employees
ORDER BY manager_id  ASC, employee_id DESC;     //manager_id(오름차순)   employee_id(내림차순)




--WHERE(원하는 부분만 검색)--
--manager_id가 124인것만 검색--
SELECT *
FROM employees
WHERE manager_id = 124;

--WHERE 샐러리 3000이상 구할때
SELECT *
FROM employees
WHERE salary >= 3000;


--AND 여러개 조건 사용--(왜 안나오지????????????????????????????????)
SELECT *
FROM employees
WHERE SALARY >2660 
AND SALARY < 4800;


--WHERE, AND(2000~3000사이 샐러리 출력)--
SELECT salary
FROM employees
WHERE salary > 2000
AND salary < 3000;
--BETWEEN A AND B 연산자(2000~3000사이 샐러리 출력)--
SELECT salary
FROM employees
WHERE salary BETWEEN 2000 AND 3000;





--OR---
SELECT   salary 
        ,manager_id
FROM employees
WHERE salary = 4800
OR manager_id = 124 ;

--OR연산자를 이용해서 여러개 조건 (돈 3명 뽑음)
SELECT *
FROM employees
WHERE salary = 2600
OR  salary = 10000
OR  salary = 6000;





----NOT IN 연산자----2600,600,10000을 제외한 나머지 출력
SELECT salary
FROM employees
WHERE salary NOT IN (2600, 6000, 10000);


--IN (2600,600,10000만 나오도록 출력)
SELECT salary
FROM employees
WHERE salary IN (2600, 6000, 10000);



--LIKE 연산자(D로시작하는 이름 검색하여 출력)--
--내용검색기능--
SELECT *
FROM employees
WHERE emp_name LIKE 'D%';
--두 번째 글자가 D인 사람찾기  '_D%'
SELECT *
FROM employees
WHERE emp_name LIKE '_D%';
--NOT LIKE를 통해 D인 사람 빼고 검색하여 출력
SELECT emp_name
FROM employees
WHERE emp_name NOT LIKE 'D%';



--UNION 연산자(중복제거함)--
//1.
SELECT goods
FROM exp_goods_asia
WHERE country ='한국'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country ='일본';
//2.
SELECT emp_name, email, salary, manager_id
FROM employees
WHERE manager_id = 101
UNION
SELECT emp_name, email, salary, manager_id
FROm employees
WHERE manager_id = 100
;
---OR(중복그대로출력)
SELECT emp_name, email, salary, manager_id
FROM employees
WHERE manager_id = 100
OR manager_id = 101
;


SELECT *
from employees;
--UNION을 이용하여 D와P의 이름이 있는 사람 찾기
SELECT emp_name, email, salary, manager_id
FROM employees
WHERE emp_name LIKE  'D%'
UNION
SELECT emp_name, email, salary, manager_id
FROM employees 
WHERE emp_name LIKE '%P'
;


--UNION ALL(출력결과가 같을때)
--중복  포함하여 출력
SELECT *
FROM employees
WHERE email Like '%D'
UNION ALL
SELECT *
FROM employees
WHERE email Like '%D'
;


--MINUS 은 2개 일때
--NOT IN은 1개 셀렉터일때 

//1.NOT IN(2600빼고 출력)
SELECT salary
FROM employees
WHERE salary NOT IN 2600;
//2.MINUS(2600빼고 출력)
SELECT salary
FROM employees
MINUS 
SELECT salary
FROM employees
WHERE salary = 2600
;



--INTERSECT 집합연산자(결과값이 같은데이터만 출력)
SELECT salary
FROM employees
INTERSECT
SELECT salary
FROM employees
WHERE salary = 2600
;



--UPPER, LOWER, INITCAP(문자열)
--대문자,소문자,첫글자는 대문자 나머지는 소문자로 변환함수
SELECT UPPER(emp_name), LOWER(emp_name),INITCAP(emp_name)
FROm employees;
-------donald oconnell검색 후 INITCAP을 이용하여 바꾸기 ----------
SELECT INITCAP(emp_name) 
FROM employees
WHERE INITCAP(emp_name) LIKE INITCAP('%donald oconnell%');






--문자열 길이 구하는 LENGTH 함수--
SELECT emp_name, LENGTH(emp_name)
FROM employees
WHERE LENGTH(emp_name)  = 12             --문자열 12 인 emp_name문자열 길이 찾기
OR    LENGTH(emp_name) = 11
ORDER BY LENGTH(emp_name) DESC            --내림차순 오름차순 ORDER BY DESC에 따라 달라짐
;


--SUBSTR(문자열 일부 추출)
SELECT SUBSTR(emp_name, 1,3)  -- emp_name이 세글자 출력 
FROM employees;
SELECT SUBSTR(emp_name, 3)  -- emp_name이 세번째 글자부터 나머지 출력
FROM employees;


--SUBSTR과 LENGTH 섞어서 사용하기 (아직 이해 안됨)
SELECT 
       SUBSTR(emp_name , LENGTH(emp_name),1)
      ,SUBSTR(emp_name,-LENGTH(emp_name),2)
      , SUBSTR(emp_name ,2, LENGTH(emp_name))
FROm employees;


--INSTR(특정 문자열 위치 찾기)--   
SELECT 
     INSTR('HELLO,oracle', 'L')   일 -- 'L'이 처음 등장하는 위치
    ,INSTR('HELLO,oracle', 'L', 5)  이-- 5번째 문자부터 검색
    ,INSTR('HELLO,oracle', 'L', 2, 2) 삼 -- 2번째 문자부터 2번째로 등장하는 'L' 찾기
FROM DUAL;                                --DUAL은  테이블이 존재하지않을때 사용



--INSTR로 D가 있는 행 구하기
SELECT emp_name
FROM employees
WHERE INSTR(emp_name, 'D') > 0
;
--LIKE를 이용하여 D가 들어간 사원 구하기
SELECT emp_name 
FROM employees
WHERE emp_name LIKE '%D%';

--REPLACE--p139
--REPLACE(문자열, 찾는거, 바꾸게 될 문자 )--
SELECT '010-6305-9403' AS 번호
    ,REPLACE('010-6305-9403', '-',' ') AS replace1          -- -를 없애고 공백을 넣음
    ,REPLACE('010-6305-9403', '-') AS replace2              -- -만 없앰 추가 x
FROM DUAL;

--RPAD 빈 공간을 특정문자로 채우기--p141
SELECT   
    RPAD('971225-' , 14 ,'*') AS 주민,  -- '971225-' 뒤에 '*'를 추가하여 총 14자리로 만듦 (결과: '971225-*******')
    RPAD('010-12334' , 13, '*') AS 폰   -- '010-12334' 뒤에 '*'를 추가하여 총 13자리로 만듦 (결과: '010-12334****')
FROM dual;


--CONCAT(142p)
--두열 사이에 콜론 넣고 연결하기--
SELECT CONCAT('김원진', '님') AS 단일_문자열,  
       CONCAT(CONCAT('kimwonjin', ':'),'김원진') AS 오류_방지 -- ? `CONCAT()`는 하나의 인자만 받을 수 없음 (오류 발생)
FROM dual;
-----CONCAT 응용---
SELECT   CONCAT(emp_name, email)               -- emp_name + email 붙임
        ,CONCAT(emp_name, CONCAT(':',email))   --emp_name : email (:붙임)
FROM employees
WHERE emp_name LIKE '%D%';

/* 
    TRIM(p142) 
    특정 문자 지우기
    다시 보기 ??????????????????
*/
SELECT '[' || TRIM('__Oracle__') || ']' AS TRIM                  --결과 : [__Oracle__]
      ,'[' || TRIM(LEADING FROM'__Oracle__') || ']' AS TRIM
FROM DUAL;


/*
    ROUND(146p)
    특정 위치에서 반올림 해주는 함수
*/
SELECT ROUND(1234.5678)      as ROUND       --1235
      ,ROUND(1234.5678, 1 )  as ROUND2      --1234.6
      ,ROUND(1234.5678, -1)  as round3      --1230
      FROM dual;
      
/*
    MOD
    나머지 값을 구하는 함수
    MOD(숫자1, 숫자2)
    숫자1	나눌 숫자 (salary)
    숫자2	나눌 값 (20)
    반환값	숫자1을 숫자2로 나눈 나머지
*/
SELECT  MOD(15,6)       --3
       ,MOD(10,2)       --0
       ,MOD(11,2)       --1
FROM dual;



/*
    SYSDATE(150p)
    날짜 출력하기
*/
SELECT  SYSDATE      지금
       ,SYSDATE -1   어제
       ,SYSDATE +2   내일
FROM dual;
      
      
/*
    ADD_MONTHS(151p)
    몇 개월 이후 날짜를 구하는 함수
 */ 
SELECT SYSDATE                AS 오늘날짜, 
       ADD_MONTHS(SYSDATE, 3) AS 세달후            --(SYSDATE, 3) 현재날짜,개월수
FROM dual;
--문제 1주년 되는사람 찾기--
SELECT hire_date, 
       SYSDATE AS 오늘날짜, 
       ADD_MONTHS(hire_date, 12) AS "1주년"    --한글사용시 ""필요함
FROM employees;
//Like 사용 (TO_CHAR, EXTRACT사용)     
SELECT hire_date, 
       SYSDATE AS "오늘날짜", 
       ADD_MONTHS(hire_date, 12) AS "1주년"
FROM employees
WHERE TO_CHAR(ADD_MONTHS(hire_date, 12), 'YYYY') LIKE TO_CHAR(EXTRACT(YEAR FROM SYSDATE) + 1);

/*
    MOTHS_BETWEEN(152p)
    두 날짜간의 개월 수 차이 구하는 함수
*/
SELECT  update_date, hire_date,
        MONTHS_BETWEEN(hire_date,update_date)
FROM employees;
--floor(148p),mod,MONTH_BEWTWEEN 사용--
SELECT update_date, hire_date,
       FLOOR(MONTHS_BETWEEN(update_date, hire_date) / 12)     || '년 ' ||
       MOD(FLOOR(MONTHS_BETWEEN(update_date, hire_date)), 12) || '개월' AS 근속기간
FROM employees;


/*
    숫자와 문자열 더하기(157p)
*/


/*
    TO_CHAR(158p)
    날짜 숫자 데이터를 문자 데이터로 변환
*/
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') as 현재날짜시간
FROM dual;
--
SELECT TO_CHAR(SYSDATE, 'YYYY') as 이번연도    --출력: 2025
FROM employees;
--
SELECT SYSDATE
    ,TO_CHAR(SYSDATE, 'MM')  as mm
FROM dual;




/*
    TO_DATE(164p)
    문자 데이터 -> 날짜 데이터로
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
              'MANAGER', '관리자', 
              'ENGINEER', '엔지니어', 
              'CLERK', '사무직', 
              '기타')                  AS 직급설명
FROM employees;


/*
    CASE문(172p)
    CASE	조건문 시작
    WHEN	조건 설정
    THEN	조건이 참이면 반환할 값
    ELSE	모든 조건이 거짓일 때 반환할 값
    END	CASE문 종료
    AS 별칭	결과 컬럼의 별칭(이름) 지정
*/
SELECT emp_name, salary, 
       CASE 
           WHEN salary >= 5000 THEN '고액 연봉'
           WHEN salary >= 3000 THEN '중간 연봉'
           ELSE '저연봉'
       END AS 급여등급
FROM employees;

/*
    SUM(177)
    distinct 중복제거
*/
select SUM(salary)  --salary에 있는 것들을 다 더한 것을 출력
from employees;

select   sum(distinct salary)         --salary값에서 distinct를 통해 중복된 값을 제거
        ,sum(all salary)
        ,sum(salary)
from employees;

/*
    COUNT(180)
    테이블 데이터 개수 세기
*/
select count(emp_name) --employees에 있는 세로줄에있는 숫자 출력
from employees;
//
select distinct count(salary)   --중복된거 제거 샐러리 개수 출력
,count(salary)                  -- 샐러리 개수 출력
from employees;

/*
    MIN,MAX(183)
*/
SELECT max(salary) AS 최댓값, 
       min(salary) AS 최솟값, 
       max(salary) - min(salary) AS 급여차이,
       avg((salary)) as 평균급여,  
       ROUND(avg(salary),2) as 평균급여2
FROM employees;
-----------
select max(hire_date)
from employees
where Max(salary);

-------------
SELECT hire_date, MAX(salary) AS highest_salary
FROM employees
WHERE hire_date = '05/09/30' -- 원하는 입사 날짜
GROUP BY hire_date;

--------GROUP BY----------------
SELECT max(salary), hire_date   --2005-09-30날짜에 입사한 사람중 제일 높은 돈을 받는 사람 출력
FROM employees
WHERE hire_date = '2005-09-30' 
GROUP BY hire_date;

---------HAVING COUNT(-같이 입사한 사람이 2명이상인 날짜 출력)-----------------------
SELECT hire_date           
FROM employees
GROUP BY hire_date
HAVING COUNT(hire_date) > 2; --출력:02/06/07

--02/06/07날짜 찾아보기 위해 검색--
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

