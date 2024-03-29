# 다중 테이블 작업

## 행 집합을 다른 행 위에 추가

두개 이상의 테이블에 저장된 데이터를 반환하고 한 결과셋을 다른 결과셋 위에 포개려고 한다

emp 테이블에 있는 부서 10 의 부서 번호와 함께, dept 테이블에 있는 각 부서명 및 부서번호를 표시하라

```sql
SELECT
    e.ename ename_and_dname,
    e.deptno
    FROM emp e
WHERE deptno = 10
UNION ALL
SELECT
    repeat('-', 10),
    null
UNION ALL
SELECT
    d.dname ename_and_dname,
    d.deptno
    FROM dept d
```

`UNION` 은 중복을 없앤다

```sql
SELECT
    deptno
    FROM emp
UNION
SELECT
    deptno
    FROM dept;
```

이는 `UNION ALL` 에 `DISTINCT` 를 사용한것과 같다

```sql
SELECT DISTINCT deptno
FROM (
    SELECT
        deptno
        FROM emp
    UNION ALL
    SELECT
        deptno
        FROM dept
);
```

```sh
deptno|
------+
    40|
    30|
    10|
    20|
```

## 연관된 여러 행 결합

부서 10의 모든 사원명과 각 사원의 부서 위치를 함께 표시하라

```sql
SELECT * from dept;
SELECT
        e.ename
    ,   d.dname
    ,   d.loc
    FROM emp e
    JOIN dept d
    ON e.deptno = d.deptno
WHERE e.deptno = 10;
```

책에서는 `Inner Join` 의 한 형태인 `Equal Join` 을 보여준다

```sql
SELECT
        e.ename
    ,   d.dname
    ,   d.loc
    FROM emp e, dept d
WHERE
    e.deptno = d.deptno
    AND e.deptno = 10;
```

이를 이해하기 위해서는 `Inner Join` 이 어떻게 이루어지는 보아야 한다

```sql
SELECT
        e.ename
    ,   d.dname
    ,   d.loc
    FROM emp e, dept d
```

이는 `Cross Join` 형태를 띄고 있다
이러한 형태를 `데카르트곱` 이라 한다

이렇게 생성된 `데카르트곱` 으로 생성된 테이블을 `WHERE` 절을 사용하여 걸러주는 역할을 한다

모든 순서쌍이 생성될것이니, 순서쌍중에서 `deptno` 이 같은 `field` 만을 선택하면 `deptno` 에 속한 사원을 출력한다

```sql
SELECT
        e.ename
    ,   d.dname
    ,   d.loc
    FROM emp e, dept d
WHERE e.deptno = d.deptno
```

이렇게 출력된 사원 테이블에서 다시 `deptno` 이 `10` 인 테이블을 선택하면 원하는 테이블을 선택할수 있다

```sql
SELECT
        e.ename
    ,   d.dname
    ,   d.loc
    FROM emp e, dept d
WHERE e.deptno = d.deptno
    AND e.deptno = 10;
```

## 두 테이블의 공통 행 찾기

```sql
DROP VIEW IF EXISTS v;

CREATE VIEW v
AS
SELECT ename, job, sal
    FROM emp
WHERE job = 'CLERK';

SELECT * FROM v;
```

`V` 행과 일치하는 `EMP` 테이블의 모든 사원의 `EMPNO`, `ENAME`, `JOB`, `SAL`, `DEPTNO` 을 반환하라

```sql
SELECT
        e.empno
    ,   e.ename
    ,   e.job
    ,   e.sal
    ,   e.deptno
    FROM emp e, v v
WHERE e.ename = v.ename
    AND e.job = v.job
    AND e.sal = v.sal;

SELECT
        e.empno
    ,   e.ename
    ,   e.job
    ,   e.sal
    ,   e.deptno
    FROM emp e
    JOIN v v
        ON e.ename = v.ename
            AND e.job = v.job
            AND e.sal = v.sal;

SELECT
        empno
    ,   ename
    ,   job
    ,   sal
    ,   deptno
    FROM emp
WHERE (ename, job, sal) IN (
    SELECT ename, job, sal FROM emp
    INTERSECT
    SELECT ename, job, sal FROM V
);
```

이전의 두 쿼리와는 다르게 맨 아래의 쿼리는 `INTERSECT` 를 사용하여 `IN` 연산자로 비교한다

`INTERSECT` 는 집합연산으로 두 테이블의 공통된 행을 반환한다

`교집합` 으로 생각하면 된다

## 한 테이블에서 다른 테이블에 존재하지 않는 값 검색

`EMP` 테이블에 없는 `DEPT` 테이블의 부서 정보를 찾으려 한다. `DEPT` 테이블의 `DEPTNO` 값이 `40` 인데 `EMP` 에는 없으니 `DEPNO` `40` 만 반환해야 한다

```sql
SELECT deptno FROM dept
EXCEPT
SELECT deptno FROM emp;

SELECT deptno
    FROM dept
WHERE deptno NOT IN (
    SELECT deptno
        FROM emp
);
```

`EXCEPT` 는 첫번째 결과 셋과 두번째 결과셋의 중복된 행을 모두 제거한다

그러므로, 첫번째 결과셋이 모든 값을 포함하고 있어야 정상적으로 `EXCEPT` 될수 있다

책에서 중요한 부분은, `NOT IN` 연산을 사용할때를 강조한다

`NOT IN` 은 본질적으로 `OR` 연산이며, `OR` 연산은 `FALSE OR NULL` 일때 `NULL` 평가하여 처리한다

```sql
SELECT FALSE OR NULL; -- NULL
```

`NOT IN` 연산자는 `FALSE` 일때, `FALSE` 인 값을 반환해야 하는데, `NULL` 값이 있으므로, `NULL` 을 반환한다

```sql
OR          AND         NOT

TT = T      TT = T      T = F
TF = T      TF = F      F = T
FT = T      FT = F      N = N
FF = F      FF = F
TN = T      TN = N
NT = T      NT = N
NF = N      NF = F
FN = N      FN = F
NN = N      NN = N
```

`NULL` 과 `OR` 연산자 비교시 `NULL` 이 나오는 이러한 부분을 개선하기 위해서는 `NOT EXISTS` 와 함께 서브쿼리를 사용하라고 한다

```sql
SELECT d.deptno
    FROM dept d
WHERE NOT EXISTS (
    SELECT 1
    FROM emp e
    WHERE d.deptno = e.deptno
);
```

`SUB QUERY` 가 결과를 반환하면, `EXISTS` 함수는 `TRUE` 로 평가되고, `NOT EXISTS` 는 `FALSE` 로 변환한다

즉, `SUB QUERY` 가 결과를 반환하지 않으면 `TRUE` 가 된다는것이다

`EXCEPT` 를 사용못하는 상황에서는 좋은 방법같다

## 다른 테이블 행과 일치하지 않는 행 검색

공통키가 잇는 두 테이블에서 다른 테이블과 일치하지 않는 한 테이블에 있는 행을 찾으려 한다

사원이 없는 부서를 찾고자 한다면 어떻게 해야 햘까?

```sql
SELECT
        d.deptno
    ,   d.dname
    ,   d.loc
    FROM dept d
    LEFT JOIN emp e
    ON e.deptno = d.deptno
WHERE e.empno is null;
```

## 다른 조인을 방해하지 않고 쿼리에 조인 추가

모든 사원명, 근무 부서의 위치 및 보너스를 받은 날짜를 반환하려고 한다

```sql
SELECT
        ename
    ,   d.dname
    ,   d.loc
    ,   eb.received
FROM
    emp e
    JOIN dept d
    ON e.deptno = d.deptno
    JOIn emp_bonus eb
    ON e.empno = eb.empno;
```

위처럼하면 원하는 결과셋이 아니다
모든 사원이 출력되어야 한다

```sql
SELECT
        ename
    ,   d.dname
    ,   d.loc
    ,   eb.received
FROM
    emp e
    JOIN dept d
    ON e.deptno = d.deptno
    LEFT JOIN emp_bonus eb
    ON e.empno = eb.empno;
ORDER BY 2

--  스칼라 서브쿼리

SELECT
        ename
    ,   (
            SELECT d.loc
                FROM dept d
            WHERE d.deptno = e.deptno
        )
    ,   (
            SELECT eb.received
                FROM emp_bonus eb
            WHERE eb.empno = e.empno
        )
    FROM emp e
    ORDER BY 2
```

스칼라 서브쿼리 같은경우 둘이상의 행을 반환하면 에러이다
그러므로 반드시 하나의 행을 반환하도록 해야 한다

## 두 테이블에 같은 데이터가 있는지 확인

테이블에 같은 데이터 값(`Cardinality`) 가 있는지 알고 싶을때 사용하는 패턴이다

```sql
CREATE view v
AS
SELECT * FROM emp
WHERE deptno != 10
UNION ALL
SELECT * FROM emp
WHERE ename = 'WARD';
```

```sql
--  상관쿼리(CORELATION QUERY)로 처리

SELECT
    *
FROM (
    SELECT
            e.empno
        ,   e.ename
        ,   e.job
        ,   e.mgr
        ,   e.hiredate
        ,   e.sal
        ,   e.comm
        ,   e.deptno
        ,   count(*) AS cnt
        FROM emp e
    GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
) e
WHERE NOT EXISTS (
    SELECT null
        FROM (
            SELECT
                    v.empno
                ,   v.ename
                ,   v.job
                ,   v.mgr
                ,   v.hiredate
                ,   v.sal
                ,   v.comm
                ,   v.deptno
                ,   count(*) AS cnt
                FROM v
            GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
        ) v
    WHERE   v.empno                 = e.empno
        AND v.ename                 = e.ename
        AND v.job                   = e.job
        AND coalesce(v.mgr, 0)      = coalesce(e.mgr, 0)
        AND v.hiredate              = e.hiredate
        AND v.sal                   = e.sal
        AND coalesce(v.comm, 0)      = coalesce(e.comm, 0)
        AND v.deptno                = e.deptno
        AND v.cnt                   = e.cnt
)
UNION ALL
SELECT
    *
FROM (
    SELECT
            v.empno
        ,   v.ename
        ,   v.job
        ,   v.mgr
        ,   v.hiredate
        ,   v.sal
        ,   v.comm
        ,   v.deptno
        ,   count(*) AS cnt
        FROM v v
    GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
) e
WHERE NOT EXISTS (
    SELECT null
        FROM (
            SELECT
                    e.empno
                ,   e.ename
                ,   e.job
                ,   e.mgr
                ,   e.hiredate
                ,   e.sal
                ,   e.comm
                ,   e.deptno
                ,   count(*) AS cnt
                FROM emp e
            GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
        ) v
    WHERE   v.empno                 = e.empno
        AND v.ename                 = e.ename
        AND v.job                   = e.job
        AND coalesce(v.mgr, 0)      = coalesce(e.mgr, 0)
        AND v.hiredate              = e.hiredate
        AND v.sal                   = e.sal
        AND coalesce(v.comm, 0)      = coalesce(e.comm, 0)
        AND v.deptno                = e.deptno
        AND v.cnt                   = e.cnt
)

--  EXCEPT 로 처리
(
    SELECT
            empno
        ,   ename
        ,   job
        ,   mgr
        ,   hiredate
        ,   sal
        ,   comm
        ,   deptno
        ,   count(*) AS cnt
        FROM V
    GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
    EXCEPT
    SELECT
            empno
        ,   ename
        ,   job
        ,   mgr
        ,   hiredate
        ,   sal
        ,   comm
        ,   deptno
        ,   count(*) AS cnt
        FROM emp
    GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
)
UNION ALL
(
    SELECT
            empno
        ,   ename
        ,   job
        ,   mgr
        ,   hiredate
        ,   sal
        ,   comm
        ,   deptno
        ,   count(*) AS cnt
        FROM emp
    GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
    EXCEPT
    SELECT
            empno
        ,   ename
        ,   job
        ,   mgr
        ,   hiredate
        ,   sal
        ,   comm
        ,   deptno
        ,   count(*) AS cnt
        FROM V
    GROUP BY empno, ename, job, mgr, hiredate, sal, comm, deptno
)
```

이부분은 쿼리 자체가 헷갈리수 있다

> 약간 헤멧는데 앞의 진리표에 의한 NULL 처리로 고생했다
> AND 연산이 이루어지므로, NULL 없이 처리해야 하는데, COALESCE 처리하지 않고 바로 대입하여, 뭐가 잘못되었는지 한참을 찾았다..
>
> 또 다른 중요한 부분중 하나는 `cnt` 역시 비교해야 한다
> `v` 의 `WARD` `cnt` 가 `2` 이며, `emp` `WARD` `cnt` 는 `1` 이므로 이 비교값으로 `WARD` 가 `NOT EXISTS` 한지 결정한다
>
> 이 책을 `SQL` 문법을 상황에 따라 바로 떠올릴때까지는 몇번씩 더읽어야 할것 같다
>
> 해결책이 쌈박하다

## 데카르트 곱 식별 및 방지하기

부서 위치와 함께 부서 10 의 각 사원명을 반환하려 한다

```sql
SELECT
        e.ename
    ,   d.loc
    FROM emp e, dept d
WHERE e.deptno = 10;
```

위의 로직은 데카르트곱에 의해 잘못된 결과를 내놓는다
이부분을 해결하기 위해서는 `WHERE` 절을 사용하여 걸르던가, `INNER JOIN` 을 사용해야 한다

```sql
--  Equal Join
SELECT
        e.ename
    ,   d.loc
    FROM emp e, dept d
WHERE
    e.deptno = d.deptno
    AND e.deptno = 10;


--  Inner Join
SELECT
        e.ename
    ,   d.loc
    FROM emp e
    JOIN dept d
    ON e.deptno = d.deptno
WHERE e.deptno = 10;
```

## 집계를 사용할 때 조인 수행

부서 10 에 해당하는 사원의 급여 합계와 보너스 합계를 찾는다. 일부 사원은 보너스를 두개 이상 받는데, `EMP` 테이블과 `EMP_BONUS` 테이블간의 조인 때문에 집계함수 `SUM` 이 잘못된 값을 반환한다

```sql
SELECT
        e.empno
    ,   e.ename
    ,   e.sal
    ,   e.deptno
    ,   e.sal * CASE
                    WHEN eb.type = 1 then .1
                    WHEN eb.type = 2 then .2
                    ELSE .3
                END bouns
    FROM emp e, emp_bonus eb
WHERE e.empno = eb.empno
    AND e.deptno = 10;
```

```sh
empno|ename |sal |deptno|bouns |
-----+------+----+------+------+
 7934|MILLER|1300|    10| 260.0|
 7839|KING  |5000|    10|1500.0|
 7782|CLARK |2450|    10| 245.0|
 7934|MILLER|1300|    10| 130.0|
```

```sql
SELECT
    sum(sal) as total_sal
    FROM emp e
WHERE e.deptno = 10;
```

```sh
total_sal|
---------+
     8750|
```

`total_sal` 값은 `8750` 이다

```sql
SELECT
        deptno
    ,   sum(sal) AS total_sal
    ,   sum(bonus) AS total_bonus
    FROM (
        SELECT
                e.empno
            ,   e.ename
            ,   e.sal
            ,   e.deptno
            ,   e.sal * CASE
                            WHEN eb.type = 1 then .1
                            WHEN eb.type = 2 then .2
                            ELSE .3
                        END AS "bonus"
            FROM emp e, emp_bonus eb
        WHERE e.empno = eb.empno
            AND e.deptno = 10
    )
GROUP BY deptno;
```

```sh
deptno|total_sal|total_bonus|
------+---------+-----------+
    10|    10050|     2135.0|
```

`total_sal` 값이 `10050` 이다
값이 다르며, 중복된 값에 의해 `1300` 더해진것을 볼 수 있다

```sql
--  DISTINCT 로 해결
--  SAL 부분만 두번 반복되지 않도록, DISTINCT 로
--  하나로 만든다

SELECT
        deptno
    ,   sum(distinct sal) AS total_sal
    ,   sum(bonus) AS total_bonus
    FROM (
        SELECT
                e.empno
            ,   e.ename
            ,   e.sal
            ,   e.deptno
            ,   e.sal * CASE
                            WHEN eb.type = 1 then .1
                            WHEN eb.type = 2 then .2
                            ELSE .3
                        END AS "bonus"
            FROM emp e, emp_bonus eb
        WHERE e.empno = eb.empno
            AND e.deptno = 10
    )
GROUP BY deptno;

--  SUM OVER 를 사용
--  POSTGRESQL 에서는 WINDOW 함수에서
--  DISTINCT 사용이 불가하다
--  참고용으로 살펴보자

SELECT
        e.empno
    ,   e.ename
    ,   sum(DISTINCT e.sal) OVER
        (
            PARTITION BY e.deptno
        ) AS total_sal
    ,   sum(e.sal *
            CASE
                WHEN eb.type = 1 THEN .1
                WHEN eb.type = 2 THEN .2
                ELSE .3
            END
        ) OVER
        (
            PARTITION BY e.deptno
        ) AS total_bonus
    FROM emp e, emp_bonus eb
WHERE e.empno = eb.empno
    AND e.deptno = 10;
```

## 집계시 외부 조인 수행

```sql
SELECT
    *
    FROM emp_bonus;
```

```sh
empno|received  |type|
-----+----------+----+
 7934|2005-02-15|   2|
 7934|2005-03-17|   1|
```

이상황에서 다음처럼 하면 서브쿼리상에 반환된 테이블만 처리한다

```sql
SELECT
        deptno
    ,   sum(sal) as total_sal
    ,   sum(bonus) as total_bonus
    FROM (
        SELECT
                e.empno
            ,   e.ename
            ,   e.sal
            ,   e.deptno
            ,   e.sal * CASE
                    WHEN eb.type = 1 THEN .1
                    WHEN eb.type = 2 THEN .2
                    ELSE .3
                END bonus
            FROM emp e, emp_bonus eb
            WHERE e.empno = eb.empno
                AND e.deptno = 10
    )
GROUP BY deptno;
```

```sql
deptno|total_sal|total_bonus|
------+---------+------------+
    10|     2600|       390.0|
```

이는 보너스를 받은 사원의 모든 합계만 처리된다
게다가 `total_bonus` 는 맞니만 `MILLER` 의 월급이 두번 합산된다
잘못되엇다

```sql
SELECT
        deptno
    ,   sum(DISTINCT sal) as total_sal
    ,   sum(bonus) as toatal_bonus
    FROM (
        SELECT
                e.empno
            ,   e.ename
            ,   e.sal
            ,   e.deptno
            ,   e.sal * CASE
                    WHEN eb.type = 1 THEN .1
                    WHEN eb.type = 2 THEN .2
                    ELSE .3
                END bonus
            FROM emp e left outer join emp_bonus eb
            ON e.empno = eb.empno
            WHERE e.deptno = 10
    )
GROUP BY deptno;
```

보너스를 받은 사원만 아니라, 다른 사원의 합계처리도 해야 하므로, `OUTER JOIN` 을 해주면 처리된다

## 여러 테이블에서 누락된 데이터 반환

```sql
--  YODA 사원 삽입
--  YODA 는 아직 부서 배정을 받지 못했다

INSERT INTO
emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) SELECT 111, 'YODA', 'JEDI', null, hiredate, sal, comm, null
FROM emp
where ename = 'KING';
```

```sql
SELECT d.deptno, d.dname, e.ename
    FROM dept d
    LEFT JOIN emp e
    ON d.deptno = e.deptno;
```

```sh
--  YODA 누락
deptno|dname     |ename |
------+----------+------+
    10|ACCOUNTING|MILLER|
    10|ACCOUNTING|KING  |
    10|ACCOUNTING|CLARK |
    20|RESEARCH  |FORD  |
    20|RESEARCH  |ADAMS |
    20|RESEARCH  |SCOTT |
    20|RESEARCH  |JONES |
    20|RESEARCH  |SMITH |
    30|SALES     |JAMES |
    30|SALES     |TURNER|
    30|SALES     |BLAKE |
    30|SALES     |MARTIN|
    30|SALES     |WARD  |
    30|SALES     |ALLEN |
    40|OPERATIONS|      |
```

```sql
SELECT d.deptno, d.dname, e.ename
    FROM dept d
    RIGHT JOIN emp e
    ON d.deptno = e.deptno;
```

```sh
--  OPERATIONS 누락
deptno|dname     |ename |
------+----------+------+
    10|ACCOUNTING|MILLER|
    10|ACCOUNTING|KING  |
    10|ACCOUNTING|CLARK |
    20|RESEARCH  |FORD  |
    20|RESEARCH  |ADAMS |
    20|RESEARCH  |SCOTT |
    20|RESEARCH  |JONES |
    20|RESEARCH  |SMITH |
    30|SALES     |JAMES |
    30|SALES     |TURNER|
    30|SALES     |BLAKE |
    30|SALES     |MARTIN|
    30|SALES     |WARD  |
    30|SALES     |ALLEN |
      |          |YODA  |
```

`RIGHT OUTER JOIN` 시 `OPERATIONS` 가 누락된다
누락된 모든 부분을 출력해야 한다

```sql
SELECT
        d.deptno
    ,   d.dname
    ,   e1.ename
    FROM dept d
    FULL OUTER JOIN emp e1
        ON e1.deptno = d.deptno;
```

`FULL OUTER JOIN` 을 사용하면 누란된 모든 부분역시 같이 출력된다

다음처럼 `FULL OUTER JOIN` 을 구현할수 있다

```sql
SELECT
        d.deptno
    ,   d.dname
    ,   e.ename
    FROM dept d
    LEFT JOIN emp e
    ON d.deptno = e.deptno
UNION
SELECT
        d.deptno
    ,   d.dname
    ,   e.ename
    FROM dept d
    RIGHT JOIN emp e
    ON d.deptno = e.deptno;
```

## 연산 및 비교에서 NULL 사용

`NULL` 사용시 연산을 하면 `NULL` 값이 나온다
그러므로 `NULL` 일때 숫자값으로 변경해주는것이 좋다

```sql
SELECT
        ename
    ,   comm
    ,   COALESCE(comm, 0)
FROM
    emp
WHERE coalesce(comm, 0) < (
    SELECT comm
        FROM emp
    WHERE ename = 'WARD'
);
```

`COALESCE` 는 이럴때 사용하기 좋은 함수이다
