# 테이블의 모든 행과 열 검색

## 테이블의 모든행 열 검색

```sql
select * from emp
```

```sh
empno|ename |job      |mgr |hiredate  |sal |comm|deptno|
-----+------+---------+----+----------+----+----+------+
 7369|SMITH |CLERK    |7902|1980-12-17| 800|    |    20|
 7499|ALLEN |SALESMAN |7698|1981-02-20|1600| 300|    30|
 7521|WARD  |SALESMAN |7698|1981-02-22|1250| 500|    30|
 7566|JONES |MANAGER  |7839|1981-04-02|2975|    |    20|
 7654|MARTIN|SALESMAN |7698|1981-09-28|1250|1400|    30|
 7698|BLAKE |MANAGER  |7839|1981-05-01|2850|    |    30|
 7782|CLARK |MANAGER  |7839|1981-06-09|2450|    |    10|
 7788|SCOTT |ANALYST  |7566|1982-12-09|3000|    |    20|
 7839|KING  |PRESIDENT|    |1981-11-17|5000|    |    10|
 7844|TURNER|SALESMAN |7698|1981-09-08|1500|   0|    30|
 7876|ADAMS |CLERK    |7788|1983-01-12|1100|    |    20|
 7900|JAMES |CLERK    |7698|1981-12-03| 950|    |    30|
 7902|FORD  |ANALYST  |7566|1981-12-03|3000|    |    20|
 7934|MILLER|CLERK    |7782|1982-01-23|1300|    |    10|
```

## 테이블에서 행의 하위 집합 검색

```sql
SELECT * FROM emp WHERE deptno = 20;
```

## 여러 조건을 충족하는 행

```sql
SELECT *
    FROM emp
WHERE
    deptno = 10
    OR comm IS NOT NULL
    OR sal <= 2000 AND deptno = 20;
```

`javascript` 의 `&&`, `||`, `!`, `===`, `<`, `>`, `>=`, `<=` 와 비슷하다

`or` 연산자는 전부다 `False` 이어야 출력되지 않는다.
`and` 연산자는 `where` 절의 조건중 하나라도 틀리면 출력되지 않는다

괄호로 그룹핑도 가능하다

## 테이블에서 열의 하위 집합 검색하기

```sql
SELECT ename, deptno, sal
    FROM emp;
```

## 열의 의미 있는 이름 지정

```sql
SELECT
    1 AS one;
```

## where 절에서 별칭이 지정된 열 참조

```sql
SELECT
        sal AS salary
    ,   comm as commission
    FROM emp
WHERE
    salary < 5000;
```

```sh
column "salary" does not exist
```

위의 에러를 보면 `salary` 는 존재하지 않는다고 한다
이는 `sql` 이 구문을 읽는 방식에 대한 방식에 의해 이러한 에러가 나온다

`sql` 은 다음의 순서로 파싱한다

1. FROM, JOIN
2. WHERE
3. GROUP BY
4. HAVING
5. SELECT
6. DISTINCT
7. ORDER BY
8. LIMIT / OFFSET

이 순서에 의해서 `WHERE` 절은 `SELECT` 절 이전에
실행되므로, `SELECT` 절에 지정한 별칭을 읽을수 없다

이를 해결하려면, `SUB QUERY` 를 사용하여 `INLINE VIEW` 로 `FROM` 절을 대신해야 한다

```sql
SELECT
    *
    FROM (
        SELECT
                sal AS salary
            ,   comm as commission
            FROM emp
    )
    WHERE
        salary < 5000;
```

```sql
salary|commission|
------+----------+
   800|          |
  1600|       300|
  1250|       500|
  2975|          |
  1250|      1400|
  2850|          |
  2450|          |
  3000|          |
  1500|         0|
  1100|          |
   950|          |
  3000|          |
  1300|          |
```

`5000` 보다 작은 `salary` 를 가진 사원을 출력한다

## 열 값 이어 붙이기

```sql
--  postgresql
SELECT
        ename || ' WORKS AS A ' || job
    FROM emp
WHERE deptno = 10;

--  mysql, postgresql
SELECT
        concat(ename, ' WORKS AS A ', job)
    FROM emp
WHERE deptno = 10;
```

## SELECT 문에서 조건식 사용

```sql
SELECT
        ename
    ,   sal
    ,   CASE
            WHEN sal <= 2000 THEN 'UNDERPAID'
            WHEN sal >= 4000 THEN 'OVERPAIND'
            ELSE 'OK'
        END AS STATUS
    FROM emp;
```

## 반환되는 행 수 제한

```sql
SELECT *
    FROM emp
LIMIT 5;
```

## 테이블에서 N 개의 무작위 레코드 반환

```sql
SELECT
        ename
    ,   sal
    FROM emp
ORDER BY RANDOM() limit 5;
```

> `ORDER BY` 에서 숫자 상수를 지정한다는 것은
> `SELECT` 목록의 순서 위치중 그 수에 해당하는 열에 따라 정렬하도록 요청한다는 의미입니다
>
> 반면, `ORDER BY` 절에 함수를 지정하면, 각 행에 대해 계산한 함수의 결과에 따라 정렬이 수행됩니다

`ORDER BY` 절에서 순서상수를 지정한다는 것은 각 컬럼에 접근할때, 컬럼 이름뿐 아니라 컬럼의 순서를 지정할도 있음을 말한다

각 행에 따라 `RAMDON` 함수의 결과가 정해지고, 정해진 값에 따라 정렬순서를 나타낸다고 하는것이다

즉, 컬럼의 순서를 직접 지정하는 방식이 아닌 각 행마다 계산된 값을 매핑하고, 순서를 지정하는 방식을 사용하므로, 혼돈하지 말라는 이야기인듯 하다.

## null 값 찾기

```sql
SELECT
    *
    FROM emp
WHERE comm IS NULl;
```

```sh
empno|ename |job      |mgr |hiredate  |sal |comm|deptno|
-----+------+---------+----+----------+----+----+------+
 7369|SMITH |CLERK    |7902|1980-12-17| 800|    |    20|
 7566|JONES |MANAGER  |7839|1981-04-02|2975|    |    20|
 7698|BLAKE |MANAGER  |7839|1981-05-01|2850|    |    30|
 7782|CLARK |MANAGER  |7839|1981-06-09|2450|    |    10|
 7788|SCOTT |ANALYST  |7566|1982-12-09|3000|    |    20|
 7839|KING  |PRESIDENT|    |1981-11-17|5000|    |    10|
 7876|ADAMS |CLERK    |7788|1983-01-12|1100|    |    20|
 7900|JAMES |CLERK    |7698|1981-12-03| 950|    |    30|
 7902|FORD  |ANALYST  |7566|1981-12-03|3000|    |    20|
 7934|MILLER|CLERK    |7782|1982-01-23|1300|    |    10|
```

## null 을 실제값으로 변환

```sql
SELECT
    coalesce(comm, 0)
    FROM emp
WHERE comm IS NULl;
```

```sh
coalesce|
--------+
       0|
       0|
       0|
       0|
       0|
       0|
       0|
       0|
       0|
       0|
```

## 패턴 검색

deptno 이 10 또는 20 인 사원 출력

```sql
SELECT
        ename
    ,   job
    FROM emp
    WHERE deptno in (10, 20);
```

deptno 이 10 또는 20 인 사원중 ename 이 "I" 가 있거나, "ER" 로 끝나는 사원을 반환

```sql
SELECT
        ename
    ,   job
    FROM emp
    WHERE
        deptno IN (10, 20)
        AND (ename LIKE '%I%' OR ename LIKE '%ER');
```

- `%`: 1개 이상의 모든 문자
- `_`: 1개 문자
