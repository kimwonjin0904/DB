CREATE TABLE 영화 (
    번호 NUMBER PRIMARY KEY,
    이름 VARCHAR2(100),
    개봉년도 NUMBER,
    매출액 NUMBER,
    관객수 NUMBER,
    평점 NUMBER
);

CREATE TABLE 배우 (
    번호 NUMBER PRIMARY KEY,
    이름 VARCHAR2(100),
    출생일자 DATE,
    키 NUMBER,
    몸무게 NUMBER,
    배우자 VARCHAR2(255)
);

CREATE TABLE 출연 (
    영화번호 NUMBER,
    배우번호 NUMBER,
    역할 VARCHAR2(200),
    PRIMARY KEY (영화번호, 배우번호, 역할),
    FOREIGN KEY (영화번호) REFERENCES 영화(번호) ON DELETE CASCADE,
    FOREIGN KEY (배우번호) REFERENCES 배우(번호) ON DELETE CASCADE
);

-- 데이터 삽입
INSERT INTO 영화 VALUES (1, '기생충', 2019, 10000, 10000, 8.6);
INSERT INTO 영화 VALUES (2, '범죄도시', 2017, 5630000, 1714324, 8.5);

INSERT INTO 배우 VALUES (101, '송강호', TO_DATE('1967-01-17', 'YYYY-MM-DD'), 180, 75, NULL);
INSERT INTO 배우 VALUES (102, '마동석', TO_DATE('1971-03-01', 'YYYY-MM-DD'), 175, 90, '예정화');

INSERT INTO 출연 VALUES (1, 101, '주연(기택)');       --송강호
INSERT INTO 출연 VALUES (2, 102, '주연(마석도)');      --마동석
INSERT INTO 출연 VALUES (2, 102, '제작자');            --마동석 

-- 데이터 조회
SELECT 배우.이름 as 배우이름, 
       출연.역할,
       배우.출생일자,
       영화.*
FROM 배우,출연,영화
WHERE 배우.번호 = 출연.배우번호(+)
AND 출연.영화번호 = 영화.번호(+)
AND 배우.이름 = '송강호'
;
--송강호	주연(기택)	67/01/17	1	기생충	2019	10000	10000	8.6





/*
    WINDOW 절
    rows: 로우 단위로 window절을 지정
    range: 논리적인 범위로 window절을 지정
    
    unbounded preceding : 파티션으로 구분되는 첫 번째 로우가 시작지점
    unbounded following : 파티션으로 구분되 마지막 로우가 끝 지점
    current row : 현재 지점
*/
SELECT department_id, emp_name, hire_date, salary
      ,SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as pre_cur
    ,SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                         ROWS BETWEEN CURRENT ROW AND UNBOUNDED following) as pre_fol
      ,SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                         ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)         as p1_cur 
            ,SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                         ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING)         as cur_fol2                   
FROM employees
WHERE department_id IN(30,90);

--대전 월별 누적금액을 출력하시오
--
select TO_CHAR(period, 'YYYY')--, region, loan_jan_amt

from kor_loan_status
WHERE region = '대전'


select SUBstr(period,1,4) as YY,
       period,
       region 
      ,SUM(loan_jan_amt)OVER(PARTITION BY period ORDER BY region
                              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as 누적
from kor_loan_status
WHERE region = '대전'



select *    
from kor_loan_status;
















