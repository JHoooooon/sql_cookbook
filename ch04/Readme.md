# 삽입 갱신 삭제

## 새로운 레코드 삽입

```sql
INSERT INTO dept (deptno, dname, loc)
VALUES (50, 'PROGRAMMING', 'BALTIMORE');

SELECT * FROM dept
```

```sh
deptno|dname      |loc      |
------+-----------+---------+
    10|ACCOUNTING |NEW YORK |
    20|RESEARCH   |DALLAS   |
    30|SALES      |CHICAGO  |
    40|OPERATIONS |BOSTON   |
    50|PROGRAMMING|BALTIMORE|
```

```sql
-- 여러값 한번에 삽입

INSERT INTO dept (deptno, dname, loc)
VALUES
        (1, 'A', 'B')
    ,   (1, 'A', 'B')
    ,   (1, 'A', 'B');
```

## 기본값 삽입

```sql
CREATE TABLE D (
        id integer DEFAULT 0
);
```

이럴경우 `DEFAULT` 값을 명시적으로 삽입하는 방법에 대해서 알려준다

```sql
--  기본값을 명시적으로 지정
INSERT INTO D VALUES (default);

--  테이블이 모든 열에 기본값을 삽입하지 않을때
--  열 이름을 명시적으로 지정

INSERT INTO D(id) VALUES (default);

--  Postgresql 에서는 DEFAULT VALUES 절을 지원
--  모든 열이 기본값을 사용

INSERT INTO D DEFUALT VALUES;
```

모든 열이 기본값으로 정의도니 경우, `DEFAULT VALUES` 를 지정하여 모든 기본값으로 새행을 만든다

그렇지 않으면 각 열에 대해 `DEFAULT` 를 지정해야 한다

```sql
CREATE TABLE D (
        id integer DEFAULT 0
    ,   foo varchar(10)
)

INSERT INTO D (foo) VALUES ('Bar')
```

이 구문에서 `id` 는 `default` 가 지정되어 있으며, `foo` 는 아니므로, `foo` 만 지정해주면 알아서 `id` 는 `default` 값으로 지정된다

## null 로 기본값 오버라이딩

```sql
CREATE TABLE D (id integer DEFAULT 0, foo varchar(10));

--  테이블 내용을 살피기전에는,
--  id 값이 NULL 이라 착각할수 있음
-- INSERT INTO D (id, foo) VALUES
-- ('Brighten')

--  명시적으로 NULL 로 해주면,
--  default 값을 오버라이딩하여 반환
INSERT INTO D (id, foo) VALUES
(NULL, 'Brighten')

SELECT * FROM D;
```

```sh
id|foo     |
--+--------+
  |Brighten|
```

## 한 테이블에서 다른 테이블로 행 복사

```sql
INSERT INTO dept_east (deptno, dname, loc)
SELECT deptno, dname, loc
    FROM dept
WHERE loc IN ('NEW YORK', 'BOSTON');
```

이는 `dept_east` 테이블에 `dept` 테이블중 `loc` 이 `NEW YORK`, `BOSTON` 인 `ROW` 를 찾아서 삽입하는 로직이다

삽입시 주의할점은 값 순서에 맞게 삽입해야 하는 점이다

## 테이블 정의 복사

기존 테이블과 같은 열 집합을 가진 새 테이블을 만든다
`DEPT` 테이블과 동일한 구조의 `DEPT_2` 를 만드는 것이다

```sql
CREATE TABLE  dept_2
AS
SELECT *
    FROM dept
WHERE 1 = 0;
```

여기서 중요한점은 `WHERE` 절에 거짓 조건을 지정한것이다

거짓 조건이 없으면 새 테이블에 복사하는 테이블의 모든행이 삽입된다

```sql
CREATE TABLE dept_2
AS
SELECT *
FROM dept;

SELECT * FROM dept_2;
SELECT * FROM dept;
```

```sh
# dept_2
deptno|dname      |loc      |
------+-----------+---------+
    10|ACCOUNTING |NEW YORK |
    20|RESEARCH   |DALLAS   |
    30|SALES      |CHICAGO  |
    40|OPERATIONS |BOSTON   |
    50|PROGRAMMING|BALTIMORE|

# dept
deptno|dname      |loc      |
------+-----------+---------+
    10|ACCOUNTING |NEW YORK |
    20|RESEARCH   |DALLAS   |
    30|SALES      |CHICAGO  |
    40|OPERATIONS |BOSTON   |
    50|PROGRAMMING|BALTIMORE|
```

`WHERE` 절에 거짓조건을 넣으면 다음처럼 구조만 복사된다

```sql
DROP TABLE dept_2;

CREATE TABLE dept_2
AS
SELECT *
    FROM dept
WHERE 1 = 0;

SELECT * FROM dept_2;
SELECT * FROM dept;
```

```sh
# dept_2
deptno|dname|loc|
------+-----+---+

# dept
deptno|dname      |loc      |
------+-----------+---------+
    10|ACCOUNTING |NEW YORK |
    20|RESEARCH   |DALLAS   |
    30|SALES      |CHICAGO  |
    40|OPERATIONS |BOSTON   |
    50|PROGRAMMING|BALTIMORE|
```

## 특정 열에 대한 삽입 차단

특정 테이블 열에 값을 사입하는 것을 방지하려 한다
`EMP` 테이블에 값을 삽입하도록 허용하되, `EMPNO`, `ENAME`, `JOB` 열만 허용한다

```sql
--  view 를 만든다
CREATE VIEW new_emps
AS
SELECT empno, ename, job
    FROM emp e;

--  뷰에 삽입하면 데이터 베이스 서버는 삽입 내용을 기본 테이블로 변환한다
INSERT INTO new_emps
    (empno, ename, job)
VALUES (1, 'Jonathan', 'Editor')

-- --> 이는 다음의 쿼리로 변환되나
INSERT INTO emp
    (empno, ename, job)
VALUES (1, 'Jonathan', 'Editor')

--  실제로 이를 쿼리해보면 다음처럼 나온다
SELECT * FROM emp;
```

```sh
# `Jonahtan` 이 추가된것을 볼수 있다

empno|ename   |job      |mgr |hiredate  |sal |comm|deptno|
-----+--------+---------+----+----------+----+----+------+
 7369|SMITH   |CLERK    |7902|1980-12-17| 800|    |    20|
 7499|ALLEN   |SALESMAN |7698|1981-02-20|1600| 300|    30|
 7521|WARD    |SALESMAN |7698|1981-02-22|1250| 500|    30|
 7566|JONES   |MANAGER  |7839|1981-04-02|2975|    |    20|
 7654|MARTIN  |SALESMAN |7698|1981-09-28|1250|1400|    30|
 7698|BLAKE   |MANAGER  |7839|1981-05-01|2850|    |    30|
 7782|CLARK   |MANAGER  |7839|1981-06-09|2450|    |    10|
 7788|SCOTT   |ANALYST  |7566|1982-12-09|3000|    |    20|
 7839|KING    |PRESIDENT|    |1981-11-17|5000|    |    10|
 7844|TURNER  |SALESMAN |7698|1981-09-08|1500|   0|    30|
 7876|ADAMS   |CLERK    |7788|1983-01-12|1100|    |    20|
 7900|JAMES   |CLERK    |7698|1981-12-03| 950|    |    30|
 7902|FORD    |ANALYST  |7566|1981-12-03|3000|    |    20|
 7934|MILLER  |CLERK    |7782|1982-01-23|1300|    |    10|
  111|YODA    |JEDI     |    |1981-11-17|5000|    |      |
    1|Jonathan|Editor   |    |          |    |    |      |
```

위처럼 `view` 로 사용할 테이블을 제공하면 해당 `view` 상의 컬럼만 수정가능하기에 특정 열에 대한 삽입만 가능하도록 만들수 있다

> `Inline view` 를 통해 삽입도 가능하다고 하지만 **_Oracle_** 에서만 가능하다 한다

## 테이블에서 레코드 수정

`부서` `20` 에 속한 사원의 급여를 `10%` 인상한다

```sql
SELECT
        deptno
    ,   ename
    ,   sal
    ,   sal * .10
    ,   sal * 1.10
    FROM emp
WHERE deptno = 20
ORDER BY 1, 5;
```

```sh
deptno|ename|sal |amt_to_add|new_sal|
------+-----+----+----------+-------+
    20|SMITH| 800|     80.00| 880.00|
    20|ADAMS|1100|    110.00|1210.00|
    20|JONES|2975|    297.50|3272.50|
    20|SCOTT|3000|    300.00|3300.00|
    20|FORD |3000|    300.00|3300.00|
```

이처럼 인상되는 내용을 확인한후, `UPDATE` 한다

```sql
UPDATE emp
    SET sal = sal * 1.10
WHERE  deptno = 20;
```

`deptno` 이 `20` 인 사원은 전부 `10%` 월급이 인상된다

## 일치하는 행이 있을때 업데이트하기

한 테이블에 해당 행이 존재할때, 다른 테이블의 행을 업데이트한다

`emp_bonus` 테이블에 있는 사원은 `emp` 테이블에서 `sal` 을 `20%` 인상한다

```sql
-- in 사용시
UPDATE emp
    SET sal = sal * 1.20
WHERE empno IN (
    SELECT empno FROM emp_bonus
)

-- exists 사용시
UPDATE emp e
    SET sal = sal * 1.20
WHERE EXISTS (
    SELECT NULL
        FROM emp_bonus eb
    WHERE eb.empno = e.empno
)
```

`EXISTS` 는 상관쿼리를 사용해서 **해당 테이블을 조건식으로 필터링하고, 테이블 행이 존재하면 True, 아니면 False 를 반환한다**

반면 `IN` 연산자는 **해당 테이블을 처음 부터 끝까지 `OR` 연산자를 통해 비교한다**

**필터링된 테이블이 있는지 확인하는것**과, **처음부터 끝까지 연산자를 비교하는것**과의 차이는 테이블의 행이 많으면 많을수록 차이가 날것으로 예상된다

## 다른 테이블 값으로 업데이트

다른 값을 사용하여 테이블의 행을 업데이트하려 한다

특정 사원의 새로운 급여가 저장된 `NEW_SAL` 이라는 테이블이 있다

```sql
DROP TABLE IF EXISTS new_sal;

CREATE TABLE new_sal
(deptno integer primary key, sal integer);

INSERT INTO new_sal
VALUES (
    10, 4000
);

SELECT * FROM new_sal;
```

```sh
eptno|sal |
-----+----+
   10|4000|
```

`new_sal` 테이블을 사용하여 `emp` 테이블에서 특정 사원의 급여 및 커미션을 업데이트하려 한다.

`emp.sal` 을 `new_sal.sal` 로 업데이트한뒤, `emp.comm` 을 `new_sal.sal` 의 `50%` 로 업데이트하려 하라

```sql
--  내가 생각한 쿼리
UPDATE
    emp e
SET
    sal = (
        SELECT sal
            FROM new_sal ns
        WHERE e.deptno = ns.deptno
    ),
    comm = (
        SELECT sal * 0.5
            FROM new_sal ns
        WHERE e.deptno = ns.deptno
    )
WHERE EXISTS (
    SELECT null
        FROM new_sal ns
    WHERE e.deptno = ns.deptno
);

--  책에서 제시한 방법
--  이게 더 낫다
UPDATE
    emp e
SET
    (sal, comm) = (
        SELECT ns.sal, ns.sal / 2
            FROM new_sal ns
        WHERE e.deptno = ns.deptno
    ),
WHERE EXISTS (
    SELECT null
        FROM new_sal ns
    WHERE e.deptno = ns.deptno
);

--  postgresql 에서는 `UPDATE` 문에서 직접 조인 가능하다
UPDATE
    emp
SET
    sal = ns.sal
    comm = ns.sal / 2
    FROM new_sal ns
WHERE ns.deptno = emp.deptno;

--  MYSQL 에서는 WHERE 절 에서 EQUAL 조인한다
UPDATE
    emp e, new_sal ns
SET
    e.sal = ns.sal
    e.comm = ns.sal / 2
    FROM new_sal ns
WHERE ns.deptno = emp.deptno;
```

## 레코드 병합

레코드가 있으면 업데이트하고, 없으면 삽입하고, 특정 조건에 만족하지 못하면 삭제한다

- `emp_commission` 사원이 `emp` 테이블에 있을때, 해당 사원의 `comm` 을 `1000` 으로 업데이트

- `comm` 을 `1000` 으로 업데이트할 가능성이 있는 모든 사원에 대해, `SAL` 이 `2000` 미만이면, 해당 사원을 삭제(emp_commission 에서 삭제)

- 그렇지 않으면 `emp` 테이블의 `empno`, `ename`, `deptno` 값을 `emp_commission` 테이블에 삽입

```sql
--  책에서는 MYSQL 을 제외한 나머지 DB 는 작동된다고 하는데, `POSTGRESQL` 도 안된다

--  안됨!!
MERGE INTO emp_commission ec
USING (SELECT * FROM emp) e
    ON (ec.empno = e.empno)
WHEN MATCHED THEN
    UPDATE SET ec.comm = 1000
    DELETE WHERE (sal < 2000)
WHEN NOT MATCHED THEN
    INSERT (ec.empno, ec.ename, ec.deptno, ec.comm)
    VALUES (emp.empno, emp.ename, emp.deptno, emp.comm);
```

## 테이블에서 모든 레코드 삭제

```sql
DELETE FROM emp
```

## 특정 레코드 삭제

```sql
DELETE FROM emp WHERE deptno = 10
```

## 단일 레크도 삭제

```sql
DELETE FROM emp WHERE enpno = 7782
```

## 참조 무결성 위반 삭제

레코드가 다른 테이블에 존재하지 않는 레코드를 참조할때, 테이블에서 해당 레코드를 삭제하려고 한다

예를 들어 일부사원이 현재 존재하지 않는 부서에 할당되어 있을때, 해당 사원을 삭제하려고 한다

```sql
--  exists 사용시
DELETE FROM emp e
WHERE NOT EXISTS (
    SELECT NULL
        FROM deptno d
        WHERE e.deptno = d.deptno
);

--  in 사용시
DELETE FROM emp e
WHERE deptno NOT in (
    SELECT deptno
        FROM deptno d
);
```

## 중복 레코드 삭제

테이블에서 중복 레코드를 삭제하려 한다

```sql

CREATE TABLE dupes (id integer, name varchar(10));

INSERT INTO dupes VALUES (1, 'NAPOLEON');
INSERT INTO dupes VALUES (2, 'DYNAMITE');
INSERT INTO dupes VALUES (3, 'DYNAMITE');
INSERT INTO dupes VALUES (4, 'SHE SELLS');
INSERT INTO dupes VALUES (5, 'SHA SELLS');
INSERT INTO dupes VALUES (6, 'SHA SELLS');
INSERT INTO dupes VALUES (7, 'SHA SELLS');

SELECT * FROM dupes ORDER BY 1;
```

```sh
id|name     |
--+---------+
 1|NAPOLEON |
 2|DYNAMITE |
 3|DYNAMITE |
 4|SHE SELLS|
 5|SHA SELLS|
 6|SHA SELLS|
 7|SHA SELLS|
```

```sql
DELETE FROM dupes
WHERE id NOT IN (
    SELECT min(id)
        FROM dupes
    GROUP BY name
);

SELECT *
    FROM dupes
ORDER BY 1;
```

```sh
id|name     |
--+---------+
 1|NAPOLEON |
 2|DYNAMITE |
 4|SHE SELLS|
 5|SHA SELLS|
```

## 다른 테이블에서 참조된 레코드 삭제

```sql
CREATE TABLE dept_accidents
    (       deptno integer
        ,   accident_name varchar(20)
    );

INSERT INTO
    dept_accidents VALUES (10, 'BROKEN FOOT');
INSERT INTO
    dept_accidents VALUES (10, 'FLESH WOUND');
INSERT INTO
    dept_accidents VALUES (20, 'FIRE');
INSERT INTO
    dept_accidents VALUES (20, 'FIRE');
INSERT INTO
    dept_accidents VALUES (20, 'Flood');
INSERT INTO
    dept_accidents VALUES (30, 'BRUISED GLUTE');

SELECT * FROM dept_accidents;
```

```sh
deptno|accident_name|
------+-------------+
    10|BROKEN FOOT  |
    10|FLESH WOUND  |
    20|FIRE         |
    20|FIRE         |
    20|Flood        |
    30|BRUISED GLUTE|
```

사고가 세번이상 발생한 부서에서 근무하는 사원기록 을 `emp` 테이블에서 삭제한다

```sql
DELETE FROM emp e
    WHERE e.deptno IN (
        SELECT deptno
            FROM dept_accidents da
        GROUP BY deptno
        HAVING count(*) >= 3
    )
```
