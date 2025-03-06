SELECT department_id
        ,LPAD('  ', 3*(LEVEL-1))  || department_name as 부서명
        --가상 -열로서 트리 내에서 어떤 단계에 있는지 나타내는 정수값
        ,parent_id                         
        ,LEVEL 
FROM departments
START WITH parent_id IS NULL                        --해당 조건 로우부터 시작
CONNECT BY PRIOR department_id = parent_id;         --계층 구조가 어떤 식으로 연결되는지
--      이전 부서들의 parent_id를 찾도록

--관리자와 직원
SELECT a.employee_id
      ,LPAD('  ', 3*(LEVEL-1))  || a.emp_name
      ,LEVEL
      ,b.department_name
FROM employees   a
    ,departments b
WHERE a.department_id = b.department_id
--AND a.department_id = 30
START WITH a.manager_id IS NULL                     --최상위 관리자(CEO)부터 시작
CONNECT BY PRIOR a.employee_id = a.manager_id;      --PRIOR a.employee_id(관리자)
--AND a.department_id = 30
/*
    1.조인이  있으면 조인 먼저 처리
    2.START WITH 절을 참조해 최상위 계층 로우를 선택
    3.CONNECT BY 절에 명시된 구문에 따라 계층형 관계 LEVEL 생성
    4.자식 로우 찾기가 끝나면 조인 조건을 제외한 검색 조건에 대한하는 로우를 걸러냄.
*/

--계층형 쿼리는 정렬조건을 넣으면 계층형 트리가 깨짐
--SIBLINGS를 넣어줘야함.
SELECT department_id
        ,LPAD('  ', 3*(LEVEL-1))  || department_name as 부서명
        ,parent_id                         
        ,LEVEL 
FROM departments
START WITH parent_id IS NULL                        --해당 조건 로우부터 시작
CONNECT BY PRIOR department_id = parent_id
ORDER SIBLINGS BY department_name;  

--계층형 쿼리에서 사용할 수 있는 함수
SELECT   department_id
        ,parent_id
        ,LPAD('  ', 3*(LEVEL-1))  || department_name as 부서명
        ,SYS_CONNECT_BY_PATH(department_name, '|')   as 부서들 --루트 노드에서 시작해 currnet row가지 정보 반환
        ,CONNECT_BY_ISLEAF                                     --마지막 노드1, 자식이 있으면 0
        ,CONNECT_BY_ROOT department_name as root_nm            --최상위
FROM departments
START WITH parent_id IS NULL                                   --해당 조건 로우부터 시작
CONNECT BY PRIOR department_id = parent_id; 

--신규 부서가 생겼습니다.
--IT 밑에 'SNS팀'
--IT 헬프 데스트 부서 밑에 '댓글부대'
--알맞게 데이터를 삽입해주세요
INSERT INTO departments (department_id, department_name, parent_id)
VALUES(280, 'SNS팀',60);
INSERT INTO departments (department_id, department_name, parent_id)
VALUES(290, '댓글부대',230);

SELECT * 
FROM departments;

CREATE TABLE 팀 (
    아이디 NUMBER, 
    이름 VARCHAR2(100 CHAR), 
    직책 VARCHAR2(100 CHAR),
    상위_아이디 NUMBER  
);
--다음과 같이 출력되도록 데이터를 삽임 후 계층형 쿼리를 작성하시오
INSERT INTO 팀(아이디, 이름, 직책)
VALUES(1, '이사장', '사장' );
INSERT INTO 팀(아이디, 이름, 직책)
VALUES(2, '김부장', '부장' );
INSERT INTO 팀(아이디, 이름, 직책)
VALUES(3, '서차장', '차장' );
INSERT INTO 팀(아이디, 이름, 직책)
VALUES(4, '장과장', '과장' );
INSERT INTO 팀(아이디, 이름, 직책)
VALUES(5, '이대리', '대리' );
INSERT INTO 팀(아이디, 이름, 직책)
VALUES(6, '최사원', '사원' );
INSERT INTO 팀(아이디, 이름, 직책)
VALUES(7, '강사원', '사원' );
INSERT INTO 팀(아이디, 이름, 직책)
VALUES(8, '박과장', '과장' );
INSERT INTO 팀(아이디, 이름, 직책)
VALUES(9, '김대리', '대리' );
INSERT INTO 팀(아이디, 이름, 직책)
VALUES(10, '주사원', '사원' );

--모름






--(bottom-up) 거꾸로 자식에서 부모로 아래에서 위로
SELECT department_id ,parent_id
      ,LPAD(' ', 3*(LEVEL-1)) || department_name as 부서명
      ,LEVEL
FROM departments
START WITH department_id = 280
CONNECT BY PRIOR parent_id = department_id;

--계층형쿼리 응용 CONNECT BY절과 LEVEL 사용(샘플 데이터가 필요할때)
SELECT LEVEL
FROM dual
CONNECT BY LEVEL <= 12; --레벨 12까지 출력

-- 1~12월 출력
SELECT TO_CHAR(SYSDATE, 'YYYY') || LPAD(LEVEL, 2,'0') as yy
FROM dual
CONNECT BY LEVEL<= 12;

SELECT period as yy
      ,sum(loan_jan_amt) 합계
fROM kor_loan_status
WHERE period Like '2013%'   
GROUP BY period
ORDER BY 1;
--
SELECT a.yy,
       NVL(b.합계, 0) AS 합계
FROM (SELECT '2013' || LPAD(LEVEL, 2, '0') AS yy
      FROM dual
      CONNECT BY LEVEL <= 12) a -- 201301 ~ 201312 생성
LEFT JOIN (SELECT period AS yy,
                  SUM(loan_jan_amt) AS 합계
           FROM kor_loan_status
           WHERE period LIKE '2013%'
           GROUP BY period) b
ON a.yy = b.yy
ORDER BY 1;


/*
    select a.yy
          ,b.합계
    from () a
        ,() b
    where a.yy = b.yy(+)
*/


--마지막날 일자를 구하여 해당 행 만큼 생성
SELECT TO_CHAR(SYSDATE)  as DATES
      ,LAST_DAY(SYSDATE) as DATES2
FROM dual
;
--------------------------
SELECT TO_CHAR(LAST_DAY(SYSDATE),'dd')      --dd를 통해서 날짜  출력결과: 31
    ,  TO_CHAR(LAST_DAY(SYSDATE))            --25/03/31
FROM dual
;
-------------
SELECT TO_DATE(TO_CHAR(SYSDATE,'YYYYMM') || LPAD(LEVEL, 2, '0')) as yyyymmdd
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE),'dd')
;


/*
    study계정
    reservation 테이블의 reserv_date, cancel 컬럼을 활용하여
    금천 '점'의 모든 요일별 예약건수를 출력하시오 (취소건 제외)
*/














