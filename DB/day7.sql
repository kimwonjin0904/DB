-- 집합 연산자 UNION ------------------------------------------------------------------------

CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');

INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');


/*
    행단위 집합 UNION, UNION ALL, MINUS, INTERSECT
    컬럼의 수와 타입 일치해야함. 정렬은 마지막에만
*/

SELECT goods, seq
FROM exp_goods_asia
WHERE country ='한국';

SELECT goods, seq
FROM exp_goods_asia
WHERE country ='일본';

---------UNION 중복 제거 후 결합---------
SELECT goods
FROM exp_goods_asia
WHERE country ='한국'
UNION
SELECT goods
FROM exp_goods_asia
WHERE country ='일본';



----아래와 위의 셀레트값을 합친거 한국+일본(중복 상관없이)--------------
SELECT goods
FROM exp_goods_asia
WHERE country ='한국'
UNION ALL
SELECT goods
FROM exp_goods_asia
WHERE country ='일본'
ORDER BY 1;     --정렬조건은 마지막에만 사용가능


------MINUS(중복이 되지 않는 것 출력)-----------
SELECT goods
FROM exp_goods_asia
WHERE country ='한국'
MINUS
SELECT goods
FROM exp_goods_asia
WHERE country ='일본';


---------INTERSECT(두개의 행에 같은게 있는 것 출력)--------------------------
SELECT goods
FROM exp_goods_asia
WHERE country ='한국'
INTERSECT           --교집합
SELECT goods
FROM exp_goods_asia
WHERE country ='일본';



--------------------------
SELECT goods, seq
FROM exp_goods_asia
WHERE country ='한국'
UNION
SELECT goods, seq
FROM exp_goods_asia
WHERE country ='일본';
 

--------------
SELECT gubun
      ,SUM(loan_jan_amt)합
FROM kor_loan_status
GROUP BY ROLLUP(gubun);

--ROLLUP 쓰지 않고 결과내기--UNION쓰기
SELECT   gubun 
        ,SUM(loan_jan_amt)합
FROM kor_loan_status
GROUP BY gubun
UNION
SELECT '합계',SUM(loan_jan_amt)
FROM kor_loan_status




/*
    1.내부조인 INNER JOIN 동등 조인 EQUI-JOIN 이라함.
        WHERE 절에서 = 등호 연산 사용하여 조인함.
        A와 B테이블에 공통된 값을 가진 컬럼을 연결해 조인 조건이 True일
        경우 값이 같은 행을 추출
*/
SELECT *
FROM 학생,수강내역
WHERE 학생.학번 = 수강내역.학번
AND 학생.이름 = '최숙경';


----
*/
SELECT *
FROM 학생 a, 수강내역 b        --테이블 별칭
WHERE a.학번 = b.학번
AND a.이름 = '최숙경';
-----------------------------
SELECT  a.학번
       ,a.이름
       ,b.수강내역번호
       ,b.과목번호
       ,b.취득학점
FROM 학생 a, 수강내역 b        --테이블 별칭
WHERE a.학번 = b.학번
AND a.이름 = '최숙경';


--최숙경씨의 총 수강 내역 건수를 출력하시오--
SELECT   a.이름                               --이름 출력
        ,COUNT(b.수강내역번호)                --수강내역 건수이기때문에 COUNT
FROM 학생 a, 수강내역 b        
WHERE a.학번 = b.학번
AND a.이름 = '최숙경'
GROUP BY a.학번, a.이름;


---------내 풀이-------------------
SELECT a.이름       
       ,b.수강내역번호          
FROM 학생 a, 수강내역 b        
WHERE a.학번 = b.학번
AND a.이름 = '최숙경'
GROUP BY 수강내역번호;        --여기 틀림




-----------------------------------------------
SELECT   a.이름
        ,a.학번
        ,b.강의실
        ,c.과목이름
FROM 학생 a, 수강내역 b, 과목 c
WHERE a.학번 = b.학번
AND b.과목번호 = c.과목번호
AND a.이름 = '최숙경';


--최숙경씨의 총 수강학점을 출력하세요--
SELECT   a.이름
        ,a.학번
        ,COUNT(b.수강내역번호)   수강건수
        ,SUM(c.학점)                      총수강학점
FROM 학생 a, 수강내역 b, 과목 c
WHERE a.학번 = b.학번
AND b.과목번호 = c.과목번호
--AND a.이름 = '최숙경'
GROUP BY  a.이름 ,a.학번;


------교수들의 강의 이력건수를 출력하시오(강의건수 내림차순)-------------
SELECT 교수이름, 교수번호   
FROM 교수;

SELECT 강의내역번호, 교수번호
FROM 강의내역;



-- 교수별 강의 건수 조회
SELECT 
    강의내역.교수번호,
    COUNT(강의내역.강의내역번호) AS 강의건수
FROM 강의내역
GROUP BY 강의내역.교수번호;
-- 교수별 강의 내역 조회 및 정렬
SELECT 
    교수.교수이름,
    강의내역.강의내역번호
FROM 교수
JOIN 강의내역 ON 교수.교수번호 = 강의내역.교수번호
ORDER BY 강의내역.강의내역번호 DESC;




/*
    2.외부조인 OUTER JOIN
        null 값이 데이터도 포함해야 할때
        null 값이 포함될 테이블 조이문에 (+)기호 사용
        외부조인을 했다면 모든 테이블의 조건에 걸어줘야함.
*/
--조회
SELECT *
FROM 학생 a, 수강내역 b
WHERE a.학번 = b.학번;
---------------
SELECT a.이름
    ,a.학번
    ,COUNT(b.수강내역번호) 수강건수
FROM 학생 a, 수강내역 b
WHERE a.학번 = b.학번(+)
GROUP BY a.이름, a.학번;


-----------------과목정보
SELECT *
FROM 학생 a, 수강내역 b
WHERE a.학번 = b.학번;
---------------
SELECT a.이름
      ,a.학번
      ,b.수강내역번호  수강건수
      ,c.과목이름
FROM 학생 a, 수강내역 b, 과목 c
WHERE a.학번 = b.학번(+)
AND b.과목번호 = c.과목번호(+)


----모든 교수의 수강건수를 출력하시오 --
SELECT *
FROM 교수;

SELECT 
    교수.교수이름,
    COUNT(강의내역.강의내역번호) AS 강의건수
FROM 교수
LEFT JOIN 강의내역 ON 교수.교수번호 = 강의내역.교수번호
GROUP BY 교수.교수번호, 교수.교수이름
ORDER BY 강의건수 DESC;


------카트 이력---------------
SELECT *
FROM member;

SELECT *
FROM cart;

SELECT a.mem_id
        ,a.mem_name
        ,COUNT(b.cart_no) as 카트이력
FROM member a, cart b
WHERE a.mem_id = b.cart_member(+)
GROUP BY a.mem_id ,
         a.mem_name ;





--김은대씨의 상품 구매이력 출력--
SELECT   a.mem_id
        ,a.mem_name
        ,b.cart_no as 카트이력
        ,b.cart_prod
        ,b.cart_qty
     --   ,c.*  --해당 테이블 전체 컬럼
        ,c.prod_name
FROM member a, cart b, prod c
WHERE   a.mem_id = b.cart_member(+)
AND     b.cart_prod = c.prod_id(+)
AND     a.mem_name = '김은대';


/*
    모든 고객의 구매이력을 출력하시오
    고객의 구매이력을 출력하시오
    사용자아이디, 이름, 카트사용횟수, 상품품목, 전체상품구매수, 총구매금액
    member, cart, prod 테이블 사용(구매 금액은 prod_price)로 사용
    정렬(카트사용횟수)
*/
SELECT   
    a.mem_id,                    
    a.mem_name,                         
    COUNT(DISTINCT b.cart_no)                        AS 카트사용횟수,
    COUNT(DISTINCT b.cart_prod)                      AS 상품품목수,
    SUM(NVL(b.cart_qty, 0))                          AS 상품구매수, 
    SUM(NVL(b.cart_qty, 0) * NVL(c.prod_price, 0))   AS 총구매금액
FROM member a, cart b, prod c
WHERE a.mem_id = b.cart_member(+)
AND b.cart_prod = c.prod_id(+)
GROUP BY a.mem_id, a.mem_name
ORDER BY 카트사용횟수 DESC;




