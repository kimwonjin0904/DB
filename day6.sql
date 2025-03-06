--17002 
--lsnrctl status 상태 확ㅇ니
--lsnrctl start 실행

/*
    집계함수와 그룹바이
    집계함수 대상 데이터에 대해 총합 , 평균, 최댓값, 최솟값 등을 구하는 함수 p 177
*/

SELECT COUNT(*)                         --null포함   *은 전체행의 개수
    ,COUNT(department_id)               --default all
    ,COUNT(ALL department_id)           --중복 o, nullx
    ,COUNT(DISTINCT department_id)      --중복 x, nullx
    ,COUNT(employee_id)
FROM employees;



SELECT   SUM(salary)            as 합계
        ,MAX(salary)            as 최대
        ,MIN(salary)            as 최소
        ,ROUND(AVG(salary),2)   as 평균                       --ROUND??
FROM employees;



--부서별 집계
SELECT  department_id
        ,SUM(salary)            as 합계
        ,MAX(salary)            as 최대
        ,MIN(salary)            as 최소
        ,ROUND(AVG(salary),2)   as 평균           
        ,COUNT(employee_id)     as  직원수
FROM employees
WHERE department_id IS NOT NULL
AND department_id IN (30, 60 ,90)
GROUP BY department_id
ORDER BY 1;


------------부서별, 직종 집계----
SELECT  department_id
        ,job_id
        ,SUM(salary)            as 합계
        ,MAX(salary)            as 최대
        ,MIN(salary)            as 최소
        ,ROUND(AVG(salary),2)   as 평균           
        ,COUNT(employee_id)     as  직원수
FROM employees
WHERE department_id IS NOT NULL                             --??
AND department_id IN (30, 60 ,90)
GROUP BY department_id, job_id
ORDER BY 1;
--select문 실행 순서
--FROM -> WEHRE -> GROUP -> HAVING -> SELECT -> ORDER BY



--member의 회원수와 마일리지의 합계,평균을 출력하시오
SELECT   COUNT(mem_id)                       as 회원수
        ,COUNT(*)                       as 회원수2
        ,SUM(mem_mileage)               as 마일리지 집계
        ,ROUND(AVG(mem_mileage,2)       as 평균
FROM member;    


----------
SELECT *
FROM member;

--직업별, 회원수, 마일리지 합꼐,평균(마일리지평균 내림차순)
SELECT mem_job, 
       COUNT(mem_id)              AS 회원수,
       SUM(mem_mileage)           AS 마일리지_합계,
       ROUND(AVG(mem_mileage), 2) AS 마일리지평균
FROM member
GROUP BY mem_job
ORDER BY 마일리지평균 DESC;


--직업별 마일리지 평균이 3000이상인 직업의 직업과 회원수를 출력
SELECT   mem_job, 
         COUNT(mem_id)               AS 회원수
         ,SUM(mem_mileage)            AS 마일리지_합계
        ,ROUND(AVG(mem_mileage), 2)  AS 마일리지평균
FROM member
GROUP BY mem_job
HAVING AVG(mem_mileage) >= 3000 --집계결과에 대해서 검색조건 추가할때 사용
ORDER BY 마일리지평균 DESC;


--kor_loan_status (java계정) 테이블의 
--2013년도 기간별 지역별 총 대출단액을 출력하시오
--1.집계 전 필요한 컬럼 만들기 
--2.검색 조건 추가
--3. 집계 후 결과 체크 (그룹바이절에는 셀렉트 절에 사용하는 표현 그대로 사용가능)

---정답----
desc kor_loan_status;
SELECT SUBSTR(period,1,4)            as 년도
        ,region                      as 지역
        ,SUM(loan_jan_amt)           as 대출합
FROM kor_loan_status
WHERE SUBSTR(period,1,4) = '2013'
GROUP BY  SUBSTR(period,1,4),region;



-----내 풀이----------

desc kor_loan_status;
SELECT SUBSTR(period,1,4),region, LOAN_JAN_AMT
FROM kor_loan_status
HAVING AVG()
ORDER BY


SELECT *
FROM kor_loan_status;





--지역별 대출잔액합께가 200000 이상인 지역을 출력하시오
--대출잔액 내림차순

--답---
SELECT region, SUM(loan_jan_amt)
FROM kor_loan_status
GROUP BY region
HAVING SUM(loan_jan_amt) >=30000
ORDER BY 2 DESC
;

---내 풀이-----
SELECT   region       as  지역
       -- ,loan_jan_amt as 대출합
        ,SUM(loan_jan_amt)  as 대출합
HAVING 
FROM kor_loan_status;


--대전, 서울, 부산의 년도별 대출 합계에서
--대출의 합이 60000이 넘는 결과를 출력하시오
--정렬:지역오름차순, 대출합 내림차순
--답--
SELECT SUBSTR(period, 1, 4)  AS 년도
       ,region                AS 지역
       ,SUM(loan_jan_amt)     AS 합계
FROM kor_loan_status
WHERE region IN ('대전', '서울', '부산')
GROUP BY SUBSTR(period, 1, 4), region
HAVING SUM(loan_jan_amt) >= 60000
ORDER BY 지역 ASC, 합계 DESC;


---GROUP BY ROLLUP---총게를 낼때 
SELECT region
        ,SUM(loan_jan_amt)
FROM kor_loan_status
GROUP BY ROLLUP(region);

-----NVL-----
SELECT NVL(region,'총계')
        ,SUM(loan_jan_amt)
FROM kor_loan_status
GROUP BY ROLLUP(region);


--년도별 대출의 합계와 총계
SELECT *
FROM kor_loan_status;

SELECT SUBSTR(period,1,4)  as 년도
      ,SUM(loan_jan_amt)   as 합계
FROM kor_loan_status
GROUP BY ROLLUP(SUBSTR(period,1,4));




--employees 직원들의 고용일자를(hire_date)를 활용하여 입사년도(TO_CHAR)별 직원수(COUNT)를 출력하시오
--(정렬 입사년도 오름차순)
SELECT *
FROM employees;

SELECT TO_CHAR(hire_date,'YYYY') as 년도
       ,COUNT(*) as 직원수 
FROM employees
GROUP BY TO_CHAR(hire_date,'YYYY')
ORDER BY 1 asc;

--employees 직원들의 고용일자를(hire_date)활용 입사한 날의 요일의 직원수를 출력
--(정렬은 일, 월 ~> 토)
SELECT  TO_CHAR(hire_date, 'DAY') as 요일
       ,COUNT(*) as 직원수   
FROM employees
GROUP BY TO_CHAR(hire_date, 'DAY'), TO_CHAR(hire_data,'d')
ORDER BY TO_CHAR(hire_data,'d') asc;



--customers 회원의 전체 회원수, 남자 회원수, 여자 회원수를 출력하시오
--남자, 여자라는 컬럼음 없음
--customers 테이블의 컬럼을 활용해서 만들어야함
SELECT COUNT(DECODE(cust_gender, 'F', '여자')) as 여자
,SUM(DECODE(cust_gender, 'F', 1,0)) as 여자
,COUNT(DECODE(cust_gender, 'M', '남자')) as 남자
,SUM(DECODE(cust_gender, 'M', 1,0)) as 남자
,COUNT(cust_gender) as 전체
FROM customers;



























