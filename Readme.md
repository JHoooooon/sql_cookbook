# SQL_COOKBOOK

> 책 `sql_cookbook` 을 정리한다

[x] [ch01 레코드 검색](./ch01)
[x] [ch02 쿼리 결과 정렬](./ch02)
[ ] ch03 다중 테이블 작업
[ ] ch04 삽입, 갱신, 삭제
[ ] ch05 메타 데이터 쿼리
[ ] ch06 문자열 작업
[ ] ch07 숫자 작업
[ ] ch08 날짜 산술
[ ] ch09 날짜 조작 기법
[ ] ch10 범위 관련 작업
[ ] ch11 고급 검색
[ ] ch12 보고서 작성과 재구성
[ ] ch13 계층적 쿼리
[ ] ch14 기타 다양한 기법
[ ] ch15 윈도우 함수 살펴보기
[ ] ch16 공통 테이블 식

## 실습을 위한 sql

```sql

CREATE TABLE EMP
       (EMPNO integer NOT NULL,
        ENAME VARCHAR(10),
        JOB VARCHAR(9),
        MGR integer,
        HIREDATE DATE,
        SAL integer,
        COMM integer,
        DEPTNO integer);

INSERT INTO EMP VALUES
        (7369, 'SMITH',  'CLERK',     7902,
        '1980-12-17',  800, NULL, 20);
INSERT INTO EMP VALUES
        (7499, 'ALLEN',  'SALESMAN',  7698,
        '1981-2-20', 1600,  300, 30);
INSERT INTO EMP VALUES
        (7521, 'WARD',   'SALESMAN',  7698,
        '1981-2-22', 1250,  500, 30);
INSERT INTO EMP VALUES
        (7566, 'JONES',  'MANAGER',   7839,
        '1981-4-2',  2975, NULL, 20);
INSERT INTO EMP VALUES
        (7654, 'MARTIN', 'SALESMAN',  7698,
        '1981-9-28', 1250, 1400, 30);
INSERT INTO EMP VALUES
        (7698, 'BLAKE',  'MANAGER',   7839,
        '1981-5-1',  2850, NULL, 30);
INSERT INTO EMP VALUES
        (7782, 'CLARK',  'MANAGER',   7839,
        '1981-6-9',  2450, NULL, 10);
INSERT INTO EMP VALUES
        (7788, 'SCOTT',  'ANALYST',   7566,
        '1982-12-9', 3000, NULL, 20);
INSERT INTO EMP VALUES
        (7839, 'KING',   'PRESIDENT', NULL,
        '1981-11-17', 5000, NULL, 10);
INSERT INTO EMP VALUES
        (7844, 'TURNER', 'SALESMAN',  7698,
        '1981-9-8',  1500,    0, 30);
INSERT INTO EMP VALUES
        (7876, 'ADAMS',  'CLERK',     7788,
        '1983-1-12', 1100, NULL, 20);
INSERT INTO EMP VALUES
        (7900, 'JAMES',  'CLERK',     7698,
        '1981-12-3',   950, NULL, 30);
INSERT INTO EMP VALUES
        (7902, 'FORD',   'ANALYST',   7566,
        '1981-12-3',  3000, NULL, 20);
INSERT INTO EMP VALUES
        (7934, 'MILLER', 'CLERK',     7782,
        '1982-1-23', 1300, NULL, 10);

CREATE TABLE DEPT
       (DEPTNO integer,
        DNAME VARCHAR(14),
        LOC VARCHAR(13) );

INSERT INTO DEPT VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO DEPT VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON');

DROP TABLE IF EXISTS emp_bonus;

CREATE TABLE emp_bonus (
  empno decimal(4,0) default NULL,
  received date default NULL,
  type decimal(1,0) default NULL
);

INSERT INTO emp_bonus VALUES ('7934','2005-03-17','1');
INSERT INTO emp_bonus VALUES ('7934','2005-02-15','2');
INSERT INTO emp_bonus VALUES ('7839','2005-02-15','3');
INSERT INTO emp_bonus VALUES ('7782','2005-02-15','1');

CREATE TABLE T1 (ID INTEGER);

INSERT INTO T1 VALUES (1);

CREATE TABLE T10 (ID INTEGER);

INSERT INTO T10 VALUES (1);
INSERT INTO T10 VALUES (2);
INSERT INTO T10 VALUES (3);
INSERT INTO T10 VALUES (4);
INSERT INTO T10 VALUES (5);
INSERT INTO T10 VALUES (6);
INSERT INTO T10 VALUES (7);
INSERT INTO T10 VALUES (8);
INSERT INTO T10 VALUES (9);
INSERT INTO T10 VALUES (10);


CREATE TABLE T100 (ID INTEGER);

INSERT INTO T100 VALUES (1);
INSERT INTO T100 VALUES (2);
INSERT INTO T100 VALUES (3);
INSERT INTO T100 VALUES (4);
INSERT INTO T100 VALUES (5);
INSERT INTO T100 VALUES (6);
INSERT INTO T100 VALUES (7);
INSERT INTO T100 VALUES (8);
INSERT INTO T100 VALUES (9);
INSERT INTO T100 VALUES (10);
INSERT INTO T100 VALUES (11);
INSERT INTO T100 VALUES (12);
INSERT INTO T100 VALUES (13);
INSERT INTO T100 VALUES (14);
INSERT INTO T100 VALUES (15);
INSERT INTO T100 VALUES (16);
INSERT INTO T100 VALUES (17);
INSERT INTO T100 VALUES (18);
INSERT INTO T100 VALUES (19);
INSERT INTO T100 VALUES (20);
INSERT INTO T100 VALUES (21);
INSERT INTO T100 VALUES (22);
INSERT INTO T100 VALUES (23);
INSERT INTO T100 VALUES (24);
INSERT INTO T100 VALUES (25);
INSERT INTO T100 VALUES (26);
INSERT INTO T100 VALUES (27);
INSERT INTO T100 VALUES (28);
INSERT INTO T100 VALUES (29);
INSERT INTO T100 VALUES (30);
INSERT INTO T100 VALUES (31);
INSERT INTO T100 VALUES (32);
INSERT INTO T100 VALUES (33);
INSERT INTO T100 VALUES (34);
INSERT INTO T100 VALUES (35);
INSERT INTO T100 VALUES (36);
INSERT INTO T100 VALUES (37);
INSERT INTO T100 VALUES (38);
INSERT INTO T100 VALUES (39);
INSERT INTO T100 VALUES (40);
INSERT INTO T100 VALUES (41);
INSERT INTO T100 VALUES (42);
INSERT INTO T100 VALUES (43);
INSERT INTO T100 VALUES (44);
INSERT INTO T100 VALUES (45);
INSERT INTO T100 VALUES (46);
INSERT INTO T100 VALUES (47);
INSERT INTO T100 VALUES (48);
INSERT INTO T100 VALUES (49);
INSERT INTO T100 VALUES (50);
INSERT INTO T100 VALUES (51);
INSERT INTO T100 VALUES (52);
INSERT INTO T100 VALUES (53);
INSERT INTO T100 VALUES (54);
INSERT INTO T100 VALUES (55);
INSERT INTO T100 VALUES (56);
INSERT INTO T100 VALUES (57);
INSERT INTO T100 VALUES (58);
INSERT INTO T100 VALUES (59);
INSERT INTO T100 VALUES (60);
INSERT INTO T100 VALUES (61);
INSERT INTO T100 VALUES (62);
INSERT INTO T100 VALUES (63);
INSERT INTO T100 VALUES (64);
INSERT INTO T100 VALUES (65);
INSERT INTO T100 VALUES (66);
INSERT INTO T100 VALUES (67);
INSERT INTO T100 VALUES (68);
INSERT INTO T100 VALUES (69);
INSERT INTO T100 VALUES (70);
INSERT INTO T100 VALUES (71);
INSERT INTO T100 VALUES (72);
INSERT INTO T100 VALUES (73);
INSERT INTO T100 VALUES (74);
INSERT INTO T100 VALUES (75);
INSERT INTO T100 VALUES (76);
INSERT INTO T100 VALUES (77);
INSERT INTO T100 VALUES (78);
INSERT INTO T100 VALUES (79);
INSERT INTO T100 VALUES (80);
INSERT INTO T100 VALUES (81);
INSERT INTO T100 VALUES (82);
INSERT INTO T100 VALUES (83);
INSERT INTO T100 VALUES (84);
INSERT INTO T100 VALUES (85);
INSERT INTO T100 VALUES (86);
INSERT INTO T100 VALUES (87);
INSERT INTO T100 VALUES (88);
INSERT INTO T100 VALUES (89);
INSERT INTO T100 VALUES (90);
INSERT INTO T100 VALUES (91);
INSERT INTO T100 VALUES (92);
INSERT INTO T100 VALUES (93);
INSERT INTO T100 VALUES (94);
INSERT INTO T100 VALUES (95);
INSERT INTO T100 VALUES (96);
INSERT INTO T100 VALUES (97);
INSERT INTO T100 VALUES (98);
INSERT INTO T100 VALUES (99);
INSERT INTO T100 VALUES (100);

```
