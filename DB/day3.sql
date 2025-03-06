CREATE TABLE TB_INFO(
        INFO_NO NUMBER(2) PRIMARY KEY     
       ,PC_NO VARCHAR2(10)  UNIQUE     NOT NULL
       ,NM  VARCHAR2(50)         NOT NULL
       ,EN_NM VARCHAR2(50)       NOT NULL 
       ,EMAIL VARCHAR2(50)       NOT NULL
       ,HOBBY VARCHAR2(500)
       ,CREATE_DT   DATE DEFAULT SYSDATE
       ,UPDATE_DT   DATE DEFAULT SYSDATE
);    

SELECT *
FROM ex1_4;
--ex1_4��ü �� ������Ʈ ��
UPDATE ex1_4;
SET age = 11;
--a001 age ����
SELECT *
FROM ex1_4
WHERE mem_id= 'a001';
--������ üũ �� �����ϴ� ����(update)
UPDATE ex1_4
SET age = 11
WHERE mem_id = 'a001';
COMMIT;
//192.168.0.12
//���� �� ���� ��̸� ������Ʈ commit���� �ؾ� �ݿ���

SELECT *
FROM TB_INFO
WHERE INFO_NO = '6';

UPDATE TB_INFO
SET hobby = '�뷡���'
WHERE INFO_NO = '6';
COMMIT;


--delete ������ ���� (where �ʼ�)
DELETE ex1_4;   --��ü ����

DELETE ex1_4
WHERE mem_id = 'a001';                       --�ش� ������ true�� ���� ����  ������ �������̸� and�־ �� �� ����

SELECT *
FROM ex1_4;     --ex1_4;��ȸ


--���̺� ���� ALTER (update�� ���̺� �����͸� ����)
--�÷��̸�����
ALTER TABLE ex1_4 RENAME COLUMN TO mem nick;
--���̺� �̸� ����
ALTER TABLE ex1_4 RENAME TO mem;
--�÷� ������ Ÿ�� ����(����� �������� ����)
ALTER TABLE mem MODIFY (mem_nick VARCHAR2(500));
--�������� ����
SELECT *
FROM user_constraints
WHERE table_name = 'MEM';                   --�ش� ���̺� �������� �̸� �˻�
ALTER TABLE mem CONSTRAINGTCH_EX_AGE;       --�ش� �������� ����
--�������� �߰�
ALTER TABLE mem ADD CONSTRAINT ck_ex_new_age CHECK(age BETWEEN 1 AND 150);
--�÷��߰�
ALTER TABLE mem ADD (new_en_nm VARCHAR2(100));
--�÷�����
ALTER TABLE mem DROP COLUNM new_en_nm;

DESC mem;

--TB_INFO�� MBTI �÷� �߰� ()
ALTER TABLE tb_info ADD (mbti VARCHAR2(4));

desc tb_info;

--FK �ܷ�Ű----------------------------------------------����ȵ�.
CREATE TABLE dep (                           -- �μ� ���̺�
    deptno     NUMBER(3) PRIMARY KEY,        -- �μ� ��ȣ (�⺻ Ű)
    dept_nm    VARCHAR2(20),                 -- �μ� �̸�
    dep_floor  NUMBER(4)                     -- �μ� �� 
);

CREATE TABLE emp(                            --�������̺�
     empno NUMBER(5) PRIMARY KEY
    ,emp_nm VARCHAR2(20)
    ,title VARCHAR2(20)
     --���� �ϰ����ϴ� �÷��� Ÿ�� ��ġ�ؾ���(���� �޶󵵵�)
     --references ������ ���̺�(�÷���)
     --���� ���̺�,�÷��� �����ؾ���(PK�̸鼭)
    ,dno    NUMBER(3) CONSTRAINT emp_fk REFERENCES dep(deptno)         
);

INSERT INTO dep VALUES(1, '����', 8);
INSERT INTO dep VALUES(2, '��ȹ', 9);
INSERT INTO dep VALUES(3, '����', 10);
INSERT INTO emp VALUES(100, '�ؼ�', '�븮', 2);
INSERT INTO emp VALUES(200, '����', '����', 3);
INSERT INTO emp VALUES(300, '�浿', '����', 4);   --������ (�������� ���Ἲ ����)

SELECT *
FROM dep;

SELECT emp.empno
    ,emp.emp_nm
    ,emp.title
    ,dep.dept_nm || '�μ�(' ||dep.dep_floor || '��)' as �μ�
FROM emp,dep
WHERE emp.dno = dep.deptno
AND emp.emp_nm ='����';


--�����ϰ� �ִ� ���̺��� ������� �����ʹ� ���� �ȵ�
DELETE dep
WHERE deptno = 3;
--���1: �������� ������ ���� �� ����
DELETE emp
WHERE empno = 200;
--���2: �������� �����ϰ� ����
DELETE emp;
DROP TABLE emp CASCADE CONSTRAINT; --emp����  �������� �����ϰ� ���̺� ����



SELECT employee_id
        ,emp_name
        ,job_id
        ,manager_id
        ,department_id
FROM employees;

--���̺� �ڸ�Ʈ
COMMENT ON TABLE tb_info IS 'tech9';
--�÷� �ڸ�Ʈ
COMMENT ON COLUMN tb_info.info_no IS '�⼮��ȣ';
COMMENT ON COLUMN tb_info.pc_no IS '�¼���ȣ';
COMMENT ON COLUMN tb_info.nm IS '�̸�';
COMMENT ON COLUMN tb_info.en_nm IS '������';
COMMENT ON COLUMN tb_info.email IS '�̸���';
COMMENT ON COLUMN tb_info.hobby IS '���';
COMMENT ON COLUMN tb_info.create_dt IS '������';
COMMENT ON COLUMN tb_info.update_dt IS '������';
COMMENT ON COLUMN tb_info.mbti IS '���������˻�';

--���̺� ������ȸ     
SELECT *
FROM all_tab_comments
WHERE comments  = 'tech9';  

--�÷� ������ȸ
SELECT *
FROM user_col_comments
WHERE comments = '���������˻�';




--1.member ������ ���弼��
        --user id : member, password: member
        --���ѵ� �ο��ؾ� ����&���̺� ���� ����
ALTER SESSION SET "_ORACLE_SCRIPT" = true;        
CREATE USER member IDENTIFIED BY member;    
GRANT CONNECT, RESOURCE TO member;
GRANT UNLIMITED TABLESPACE TO member;
--2.�ش� �������� ����(java����)
        --java�������� (3)�� �������� ���ÿ�
        
        
        
        

--3.member_table(utf-8).sql ���� �����Ͽ� (���̺� ���� �� ������ ����)
        --SELECT *
        --FROM member
        --WHERE mem_id= 'a001';
SELECT *
FROM member
WHERE mem_id = 'a001'







