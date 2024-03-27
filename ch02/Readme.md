# 쿼리 결과 정렬

## 지정한 순서대로 쿼리 결과 반환

월급높은 순으로 정렬

```sql
    SELECT
        ename
    ,   job
    ,   sal
    FROM emp
ORDER BY sal DESC;

```

순서로 컬럼 지정도 가능하다
아래는 위의 쿼리야 같다

```sql
    SELECT
        ename
    ,   job
    ,   sal
    FROM emp
ORDER BY 3 DESC;

```

## 다중 필드로 정렬

deptno 기준으로 오름차, 급여 내림차순으로 정렬

```sql
SELECT
        empno
    ,   deptno
    ,   sal
    ,   ename
    ,   job
    FROM emp
ORDER BY deptno, sal DESC;
```

`deptno` 를 기준으로 하여 `sal` 을 오름차순으로 정렬한다

`deptno` 는 아무것도 지정안했으니 내림차순이다

다음의 내용이 `ORDER BY` 사용시 주의할 점이다

1. `ORDER BY` 의 우선순위는 왼쪽부터 오른쪽이다
2. 숫자 사용시 `SELECT` 항목보다 크면 안된다
3. `SELECT` 항목에 없는 열로 정렬 가능하지만, 열 이름을 명시적으로 지정해야 한다
4. `GROUP BY`, `DISTINCT` 를 사용할때 `SELECT` 목록에 없는 열 기준으로 정렬할수 없다

## 부분 문자열로 정렬

사원명과 직급을 반환하되, JOB 열의 마지막 두문자를 기준으로 정렬하라

```sql
SELECT
    SUBSTRING(job, length(job) - 1)
    FROM emp;
```

`SUBSTRING` 은 첫번째로 해당하는 `field` 이름을,
그다음 인자로, `field` 에서 자를 위치 시작점을,
세번째 인자로, 시작점을 기준으로 몇문자를 자를지를 지정한다

`SUBSTRING` 에서 시작점만 지정하면, 끝까지 자른다
책에서는 이부분을 이용하여 `ORDER BY` 절을 사용하여 정렬했다

```sql
SELECT
        ename
    ,   job
    FROM emp
ORDER BY SUBSTRING(job, length(job) - 1);
```

## 혼합 영숫자 데이터 정렬

숫자 또는 문자부분을 기준으로 정렬

```sql
CREATE view v
AS
    SELECT
            ename || ' ' || deptno AS data
        FROM emp;

SELECT * FROM v;
```

ename 으로 정렬

```sql
SELECT *
    FROM v
ORDER BY split_part(data, ' ', 1);
```

deptno 으로 정렬

```sql
SELECT *
    FROM v
ORDER BY split_part(data, ' ', 2);
```

책에서는 다른 해법을 제공한다

`replace` 와 `translate` 함수를 사용하여 처리한다

```sql
SELECT
        data
    ,   replace(data,
            replace(translate(
                data,
                '0123456789',
                '##########'
            ),
        '#', ''), '') AS NUM
    ,   replace(translate(
            data,
            '0123456789',
            '##########'
        ), '#', '') AS CHAR
    FROM v;
```

```sh
data     |num|char   |
---------+---+-------+
SMITH 20 |20 |SMITH  |
ALLEN 30 |30 |ALLEN  |
WARD 30  |30 |WARD   |
JONES 20 |20 |JONES  |
MARTIN 30|30 |MARTIN |
BLAKE 30 |30 |BLAKE  |
CLARK 10 |10 |CLARK  |
SCOTT 20 |20 |SCOTT  |
KING 10  |10 |KING   |
TURNER 30|30 |TURNER |
ADAMS 20 |20 |ADAMS  |
JAMES 30 |30 |JAMES  |
FORD 20  |20 |FORD   |
MILLER 10|10 |MILLER |
```

`translate` 함수는 지정한 문자를, 치환하고자 하는 문자로 변경하는 함수이다

이러한 `translate` 함수를 사용하면 원하는 값만 추출하여 사용가능하다

```sql
--  ename 으로 정렬

SELECT
    *
    FROM v
ORDER BY REPLACE(
    translate(data, '0123456789', '#########'),
    '#', ''
    );

```

```sql
--  deptno 으로 정렬

SELECT
    *
    FROM v
ORDER BY
    REPLACE(data,
        REPLACE(
            translate(data, '0123456789', '#########'),
            '#', ''
        )
    , '')
```

## 정렬할 때 null 처리

```sql
--  null 값 내림차순 (null 아래로)
SELECT
        ename
    ,   sal
    ,   comm
    FROM (
        SELECT
            ename
        ,   sal
        ,   comm
        ,   CASE
                WHEN comm IS NULL THEN 0
                ELSE 1
            END AS is_null
        FROM emp
    )
ORDER BY is_null DESC, comm DESC;
```

```sql
--  null 값 오름차순 (null 위로)
SELECT
        ename
    ,   sal
    ,   comm
    FROM (
        SELECT
            ename
        ,   sal
        ,   comm
        ,   CASE
                WHEN comm IS NULL THEN 0
                ELSE 1
            END AS is_null
        FROM emp
    )
ORDER BY is_null ASC, comm DESC;
```

`NULLS FIRST`, `NULLS LAST` 를 사용하여 처리도 가능하다

```sql
SELECT
        ename
    ,   sal
    ,   comm
    FROM emp
ORDER BY comm nulls first;
```

```sql
SELECT
        ename
    ,   sal
    ,   comm
    FROM emp
ORDER BY comm nulls last;
```

## 데이터 종속 키 기준으로 정렬

job 이 `SALESMAN` 이면 comm 을 기준으로, 아니면 sal 을 기준으로 정렬

```sql
SELECT
        ename
    ,   sal
    ,   job
    ,   comm
    FROM emp
ORDER BY
    CASE
        WHEN job = 'SALESMAN' THEN comm
        ELSE sal
    END;
```

다음 처럼도 가능하다

```sql
SELECT
        ename
    ,   sal
    ,   job
    ,   comm
    ,   CASE
            WHEN job = 'SALESMAN' THEN comm
            ELSE sal
        END
    FROM emp
ORDER BY 5;
```
