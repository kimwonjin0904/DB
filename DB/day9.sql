/*
    ANSI(American NAtional Standards Institute)
    ANSI 표준은 데이터베이스 관리시스템에서 사용하는 SQL 표준
    INNER JOIN, LEFT OUTER JOIN, RIGHT JOIN, OUTER JOIN
*/

--일반 inner join
SELECT a.employee_id
        ,a.emp_name
        ,a.job_id
        ,b.department_name
FROM employees a    
    ,departments b
WHERE a.department_id = b.department_id;
--INNER
SELECT   a.employee_id
        ,a.emp_name
        ,a.job_id        
        ,b.department_name
FROM employees a 
INNER JOIN departments b
ON a.department_id = b.department_id 
WHERE a.department_id =30;      --검색조건이 있다면 조인구문 아래
--USING 조인 컬럼명이 같을때 사용
SELECT   a.employee_id
        ,a.emp_name
        ,a.job_id       
        ,b.department_name
FROM employees a 
INNER JOIN departments b
USING (department_id) 
WHERE department_id =30;            --USING 절에 사용한 컬럼은 테이블명 들어가면 안됨

--일반 outer join 
SELECT   a.employee_id
        ,a.emp_name         --한족 테이블만 있는 컬럼(a. 안 붙여두 됨)
        ,b.job_id
FROM employees a
        ,job_history b
WHERE a.job_id = b.job_id(+)
AND a.department_id = b.department_id(+);
--LEFT
SELECT   a.employee_id
        ,a.emp_name         --한족 테이블만 있는 컬럼(a. 안 붙여두 됨)
        ,b.job_id
FROM employees a
LEFT OUTER JOIN job_history b               --OUTER 꼭 안 써두 됨
ON (a.job_id = b.job_id
    AND a.department_id = b.department_id);
--LIGHT JOIN
SELECT   a.employee_id
        ,a.emp_name        
        ,b.job_id
FROM job_history b
RIGHT JOIN employees a            
ON (a.job_id = b.job_id
    AND a.department_id = b.department_id);

--테이블
CREATE TABLE tb_a (emp_id NUMBER);
CREATE TABLE tb_b (emp_id NUMBER);
INSERT INTO tb_a VALUES(10);
INSERT INTO tb_a VALUES(20);
INSERT INTO tb_a VALUES(40);


INSERT INTO tb_b VALUES(10);
INSERT INTO tb_b VALUES(20);
INSERT INTO tb_b VALUES(30);
COMMIT;
--FULL OUTER(일반 조인은 없음 양쪽(+) 안됨)
SELECT a.emp_id, b.emp_id
FROM tb_a a
FULL OUTER JOIN tb_b b
ON(a.emp_id = b.emp_id);
--CORSS JOIN
SELECT *
FROM tb_a, tb_b;  --3*3행 출력됨
--ANSI
SELECT *
FROM tb_a
CROSS JOIN tb_b;



--학생의 수장 내역을 출력하시오 LEFT OUTER JOIN 사용
SELECT *
FROM 학생;

SELECT a.이름 ,b.강의실, b.과목번호, c.과목이름
FROM 학생 a
LEFT OUTER JOIN 수강내역 b
ON a.학번 = b.학번
LEFT OUTER JOIN 과목 C
ON b.과목번호 = c.과목번호;


--뷰(VIEW) 실제 데이터는 뷰를 구성하는 테이블에 담겨 있음
--사용목적 : 데이터 보안 측면, 복잡하고 자주사용하는 쿼리를 간단하게 
--뷰 생성 권한이 없다면
--DBA권한이 있는 system 계정에서 GRANT CREATE VIEW TO 컨트롤 엔터하여 권한 부여
--GRANT CREATE VIEW TO 계정;
GRANT CREATE VIEW TO java;
CREATE OR REPLACE VIEW emp_dept AS
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
FROM employees a
    ,departments b
WHERE a.department_id = b.department_id;


--java계정에서 member 계정에게 뷰 조회 권한 부여
GRANT SELECT ON emp_dept TO member;
--member에서 아래 실행
SELECT *
FROM java.emp_dept;         --스키마. 뷰명, 
/*
    스키마 
    데이터베이스 구조와 제약 조건에 관한 전반적인 명세를 기술한 메타데이터 집합
    데이터베이스 모델링 관점에 따라 외부, 개념, 내부 스키마로 나눠짐
    임의의 사용자가 생성한 모든 데이터베이스 객체들을 말하며
    사용자 계정과 같다. java 계정이자 java스키마 
*/

--VIEW는 단순뷰(하나의 테이블로 생성)
         -- INSERT/UPDATE/DELETE 가능
--       복합뷰(여러개 테이블로 생성)
         -- INSERT/UPDATE/DELETE 가능
         
/*  시노님 Synonym 동의어, 객체 각자의 고유한 이름에 동의어를 만드는것
    PUBLIC 모든 사용자 접근가능, PRIVATE 특정사용자만
    시노님 생성시 default private이며
    public은 DBA권한이 있는 사용자만 생성 및 삭제 가능
*/
--권한을 부여하기 위해서
GRANT CREATE SYNONYM To java;       --시스템게정에서 실행
CREATE OR REPLACE SYNONYM emp1      --java계정에서 실행
FOR employees;                      --private 시노님

SELECT *
FROM emp1;

GRANT SELECT ON emp1 TO member;     --java에서 실행
--member에서 실행
SELECT *
FROM java.emp1;

CREATE OR REPLACE PUBLIC SYNONYM emp2 --시스템계정에서 실행
FOR java.employees;

SELECT *
FROM emp2;

/*
    시퀀스 SEQUUENCE 자동 순번을 반환하는 데이터베이스 객체
    정의한 규칙에 따라 순번을 생성
*/
CREATE SEQUENCE my_seq1
INCREMENT BY 1  -- 1씩 증가
START WITH   1    -- 1부터 시작
MINVALUE     1      -- 최소값 1
MAXVALUE    10     -- 최대값 10
NOCYCLE         -- 최대값(10)에 도달하면 멈춤 (반복되지 않음)
NOCACHE;        -- 캐싱 없음 (메모리에 미리 할당하지 않음)

--증가
SELECT my_seq1.NEXTVAL
FROM dual;
--현재
SELECT my_seq1.CURRVAL
FROM dual;



CREATE SEQUENCE my_seq2
INCREMENT BY 100        -- 100씩 증가
START WITH   1          -- 1부터 시작
MINVALUE     1          -- 최소값 1
MAXVALUE    1000000     -- 최대값 10
NOCYCLE                 -- 최대값(10)에 도달하면 멈춤 (반복되지 않음)
NOCACHE;                -- 캐싱 없음 (메모리에 미리 할당하지 않음)

SELECT my_seq2.NEXTVAL  --실행시 100씩증가 이해안됨???????????????????????
FROM dual;
INSERT INTO tb_a VALUES(my_seq2.NEXTVAL);
SELECT *
FROM tb_a;

--IDENTITY oracle 12버전이상에서 지원됨
CREATE TABLE my_tb(
    my_id NUMBER GENERATED ALWAYS AS IDENTITY
    ,my_nm VARCHAR2(100)
    ,CONSTRAINT my_pk PRIMARY KEY(my_id)
);
INSERT INTO my_tb(my_nm) VALUES('팽수');
INSERT INTO my_tb(my_nm) VALUES('동수');
INSERT INTO my_tb(my_nm) VALUES('수수');
SELECT * 
FROM my_tb;

-----------------------
CREATE TABLE my_tb2(
    my_id NUMBER GENERATED ALWAYS AS IDENTITY
    (START WITH 1 INCREMENT BY 2 NOCACHE)
    ,my_nm VARCHAR2(100)
    ,CONSTRAINT my_pk2 PRIMARY KEY(my_id)
);
INSERT INTO my_tb2(my_nm) VALUES('팽수');
INSERT INTO my_tb2(my_nm) VALUES('동수');
INSERT INTO my_tb2(my_nm) VALUES('수수');

SELECT * 
FROM my_tb2;


/*  MERGE 특징 조건에 따라 다른 쿼리를 수행할 때 사용가능
*/
--'과목' 테이블에 머신러닝 과목이 없으면 학점을 2로 생성
--있다면 학점을 3으로 업데이트 
MERGE INTO 과목 s
USING DUAL                         --비교 테이블 dual은 동일 테이블일때
ON(s.과목이름 = '머신러닝')         --mathch조건(머신러닝 과목이 있는지)
WHEN MATCHED THEN
        UPDATE SET s.학점 = 3
WHEN NOT MATCHED THEN
    INSERT (s.과목번호, s.과목이름, s.학점)
    VALUES ((SELECT NVL(MAX(과목번호), 0) +1
    FROM 과목), '머신러닝', 2);
---------------2--------------
MERGE INTO 과목 s
USING (SELECT '머신러닝' AS 과목이름 FROM DUAL) d  -- `머신러닝`을 비교 대상 테이블로 설정
ON (s.과목이름 = d.과목이름)  -- `머신러닝`이 과목 테이블에 존재하는지 확인
WHEN MATCHED THEN
    UPDATE SET s.학점 = 3  -- 과목이 존재하면 학점을 3으로 업데이트
WHEN NOT MATCHED THEN
    INSERT (s.과목번호, s.과목이름, s.학점)
    VALUES ((SELECT NVL(MAX(과목번호), 0) + 1 FROM 과목), '머신러닝', 2);  -- 과목이 없으면 추가



SELECT *
FROM 과목;



/*  2000년도 판매(금액)왕의 정보를 출력하시오 (sales, employees)    
    판매관련 컬럼(amount_sold, quantity_sold, slaes_date)
    (스칼라 서브쿼리와, 인라인 뷰를 사용해보세요)
*/
SELECT    a.employee_id
        ,(SELECT emp_name FROM employees
          WHERE employee_id = a.employee_id) as 직원이름
        ,TO_CHAR(판매금액, '999,999,999,99')    판매금액
        ,판매수량
FROM (SELECT employee_id, SUM(amount_sold)  as 판매금액
            ,SUM(quantity_sold)             as 판매수량
      FROM sales
      WHERE TO_CHAR(sales_date, 'YYYY') = '2000'
      GROUP BY employee_id
      ORDER BY 2 DESC) a
WHERE ROWNUM <= 1;


select count(*)
from sales;

