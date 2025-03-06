CREATE TABLE ��ȭ (
    ��ȣ NUMBER PRIMARY KEY,
    �̸� VARCHAR2(100),
    �����⵵ NUMBER,
    ����� NUMBER,
    ������ NUMBER,
    ���� NUMBER
);

CREATE TABLE ��� (
    ��ȣ NUMBER PRIMARY KEY,
    �̸� VARCHAR2(100),
    ������� DATE,
    Ű NUMBER,
    ������ NUMBER,
    ����� VARCHAR2(255)
);

CREATE TABLE �⿬ (
    ��ȭ��ȣ NUMBER,
    ����ȣ NUMBER,
    ���� VARCHAR2(200),
    PRIMARY KEY (��ȭ��ȣ, ����ȣ, ����),
    FOREIGN KEY (��ȭ��ȣ) REFERENCES ��ȭ(��ȣ) ON DELETE CASCADE,
    FOREIGN KEY (����ȣ) REFERENCES ���(��ȣ) ON DELETE CASCADE
);

-- ������ ����
INSERT INTO ��ȭ VALUES (1, '�����', 2019, 10000, 10000, 8.6);
INSERT INTO ��ȭ VALUES (2, '���˵���', 2017, 5630000, 1714324, 8.5);

INSERT INTO ��� VALUES (101, '�۰�ȣ', TO_DATE('1967-01-17', 'YYYY-MM-DD'), 180, 75, NULL);
INSERT INTO ��� VALUES (102, '������', TO_DATE('1971-03-01', 'YYYY-MM-DD'), 175, 90, '����ȭ');

INSERT INTO �⿬ VALUES (1, 101, '�ֿ�(����)');       --�۰�ȣ
INSERT INTO �⿬ VALUES (2, 102, '�ֿ�(������)');      --������
INSERT INTO �⿬ VALUES (2, 102, '������');            --������ 

-- ������ ��ȸ
SELECT ���.�̸� as ����̸�, 
       �⿬.����,
       ���.�������,
       ��ȭ.*
FROM ���,�⿬,��ȭ
WHERE ���.��ȣ = �⿬.����ȣ(+)
AND �⿬.��ȭ��ȣ = ��ȭ.��ȣ(+)
AND ���.�̸� = '�۰�ȣ'
;
--�۰�ȣ	�ֿ�(����)	67/01/17	1	�����	2019	10000	10000	8.6





/*
    WINDOW ��
    rows: �ο� ������ window���� ����
    range: ������ ������ window���� ����
    
    unbounded preceding : ��Ƽ������ ���еǴ� ù ��° �ο찡 ��������
    unbounded following : ��Ƽ������ ���е� ������ �ο찡 �� ����
    current row : ���� ����
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

--���� ���� �����ݾ��� ����Ͻÿ�
--
select TO_CHAR(period, 'YYYY')--, region, loan_jan_amt

from kor_loan_status
WHERE region = '����'


select SUBstr(period,1,4) as YY,
       period,
       region 
      ,SUM(loan_jan_amt)OVER(PARTITION BY period ORDER BY region
                              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as ����
from kor_loan_status
WHERE region = '����'



select *    
from kor_loan_status;
















