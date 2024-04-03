# 문자열 작업

## 문자열 집어보기

문자열에서 각 문자를 행으로 반환하려고 하지만, SQL 에는 루프 작업이 없다

`emp` 테이블의 `ename` 인 `king` 을 `4` 개 행으로 표시하라

`sql` 에는 `for` 문이 존재하지 않는다.
하지만 이를 해결하기 위해 `데카르트곱` 을 사용한다

```sql
-- t10
SELECT * FROM t10;
```

```sh
id|
--+
 1|
 2|
 3|
 4|
 5|
 6|
 7|
 8|
 9|
10|
```

```sql
SELECT
    *
    FROM (
        SELECT
                ename
            FROM emp
        WHERE
            ename = 'KING'
    ) e,
    (
        SELECT
                id "pos"
            FROM t10
    ) iter
```

```sh
ename|pos|
-----+---+
KING |  1|
KING |  2|
KING |  3|
KING |  4|
KING |  5|
KING |  6|
KING |  7|
KING |  8|
KING |  9|
KING | 10|
```

각 `KING` 문자열과 `pos` 가 `데카르트곱` 에 의해 각 순서쌍을 형성하고 있다.

이렇게 만들어진 순서쌍을 이용하여, 각 문자열을 표현한다

이렇게 만들어진 순서쌍을 다음처럼도 표현한다

> `e` 의 `cardinality` 는 `1` 이고, `iter` 의 `cardinality` 는 `10` 이므로, `1 * 10` 으로 총 `10` 개의 `row` 가 생성된다
>
> `cardinality` 는 용어가 애매해서 그렇지, `table` 의 `tuple` 수 이다

```sql
SELECT
        substr(e.ename, iter.pos, 1) AS C
    FROM (
        SELECT
                ename
            FROM emp
        WHERE
            ename = 'KING'
    ) e,
    (
        SELECT
                id "pos"
            FROM t10
    ) iter
WHERE iter.pos <= length(e.ename);
```

```sh
c|
-+
K|
I|
N|
G|
```

## 문자열에 따옴표 포함

```sql
SELECT 'g''day mate' qmarks FROM t1 t;
SELECT 'breavers'' teeth' qmarks FROM t1 t;
SELECT '''' FROM t1 t;
```

```sh
qmarks    |
----------+
g'day mate|

qmarks         |
---------------+
breavers' teeth|

qmarks|
------+
'     |
```

따옴표를 포함하려면 **2개의 따옴표** 를 포함해야 한다

> 내 생각에는 `''` 에서 첫번째 `'` 가 두번째 `'` 을 이스케이프 처리해주는 것으로 생각이든다

문자열없이 두개의 따옴표만 있다면, `null` 이다

## 문자열에서 특정 문자의 발생 횟수 계산

```sh
10,,CLARK,,MANAGER
```

`,,` 가 몇개 있는지 찾아라

```sql
SELECT
        (
            length(str)
        -   length(REPLACE(str, ',,',''))
        ) / length(',,') "cnt"
    FROM
        (
            SELECT '10,,CLARK,,MANAGER' str
        )
```

```sql
cnt     |
--------+
       2|
```

## 문자열에서 원하지 않는 문자 제거

```sql
SELECT
        ename
    ,   translate(ename, 'AEIOU', '')
    ,   sal
    ,   replace(CAST(sal AS char(4)), '0', '')
    FROM emp;
```

```sh
ename |translate|sal |replace|
------+---------+----+-------+
SMITH |SMTH     | 800|8      |
ALLEN |LLN      |1600|16     |
WARD  |WRD      |1250|125    |
JONES |JNS      |2975|2975   |
MARTIN|MRTN     |1250|125    |
BLAKE |BLK      |2850|285    |
CLARK |CLRK     |2450|245    |
SCOTT |SCTT     |3000|3      |
KING  |KNG      |5000|5      |
TURNER|TRNR     |1500|15     |
ADAMS |DMS      |1100|11     |
JAMES |JMS      | 950|95     |
FORD  |FRD      |3000|3      |
MILLER|MLLR     |1300|13     |
```

책에서는 약간 쿼리가 이상하다

```sql
    --  이부분을
    ,   translate(ename, 'AEIOU', '')
    --  다음처럼 한다
    ,   replace(translate(ename, 'aaaaa', 'AEIOU'), 'a', '')
```

당연이 처리가 안된다.
책이 오타인듯하다 다음처럼 하기를 원하지 않았을까 싶다

```sql
 SELECT
        ename
    ,   REPLACE(translate(ename, 'AEIOU', 'aaaaaa'), 'a', '')
    ,   sal
    ,   replace(CAST(sal AS char(4)), '0', '')
    FROM emp;
```

## 숫자 및 문자 데이터 분리

다음과 같은 데이터가 있다

```sql
WITH d AS (
    SELECT ename || sal AS ename_sal
    FROM emp
)
SELECT * FROM d
```

```sh
ename_sal |
----------+
SMITH800  |
ALLEN1600 |
WARD1250  |
JONES2975 |
MARTIN1250|
BLAKE2850 |
CLARK2450 |
SCOTT3000 |
KING5000  |
TURNER1500|
ADAMS1100 |
JAMES950  |
FORD3000  |
MILLER1300|
```

여기서 문자와 숫자를 분리하여 처리하기를 원하다

```sql
--  내가 생각한 쿼리
WITH d AS (
    SELECT ename || sal AS ename_sal
    FROM emp
)
SELECT
    replace(TRANSLATE(ename_sal, '0123456789', 'a'), 'a', '') ename,
    replace(TRANSLATE(ename_sal, 'ABCDEFGHIJKLNMOPQRSTUVWXYZ', 'a'), 'a', '')::int sal
FROM d;

--  책에서 제공하는 쿼리
WITH d AS (
    SELECT ename || sal AS ename_sal
    FROM emp
)
SELECT
    replace(TRANSLATE(ename_sal, '0123456789', 'a'), 'a', '') ename,
    cast(
        replace(
            TRANSLATE(lower(ename_sal), 'abcdefghijklnmopqrstuvwxyz',
            rpad('z', 26, 'z')
        ), 'z', '')
        as integer
    ) sal
FROM d;
```

```sh
ename |sal |
------+----+
SMITH | 800|
ALLEN |1600|
WARD  |1250|
JONES |2975|
MARTIN|1250|
BLAKE |2850|
CLARK |2450|
SCOTT |3000|
KING  |5000|
TURNER|1500|
ADAMS |1100|
JAMES | 950|
FORD  |3000|
MILLER|1300|
```

책에서 제공하는 쿼리를 보면 항상, `translate` 에서 변환할 문자열을, 변환문자의 개수에 맞게 만들어서 `replace` 한다

> 왜 이렇게 하는건지는 아직을 잘 모르겠다
> 어치피 변환될 문자열이므로, 문자열 길이를 같게 유지할 필요가 있나?
>
> 왜 이렇게 처리하는지 알았다
>
> 기본적으로 `translate` 는 `from` 문자열을 `to` 문자열로 변경하는데, `1대1` 대응하여 변환한다
>
> 예를 들어서 `abc` 가 있고, `defgh` 가 있다고 가정하자
> `a` 는 `d` 로, `b` 는 `e` 로, `c` 는 `f` 로 변환된다.
> `fgh` 는 `1대1` 로 대응되는 값이 없으므로 무시된다
>
> 쿼리내용상 `'abcdefghijklnmopqrstuvwxyz'` 와 `1대1` 대응하려면, `z` 가 `26` 개 있어야, 해당 문자열에 대응하는 `z` 문자열을 생성할수 있다
>
> 사실 원래의 의문에 맞도록 문자열 길이를 같게 유지할 필요가 있을까 싶지만, 보기에는 유지하는게 좋아보기는한다
>
> 사실 `z` 하나로 변경하고 `replace` 해주어도 결과에는 차이가 없다

## 문자열의 영숫자 여부 확인

관심있는 열에 숫자와 문자 이외의 문자가 포함되지 않을때만 테이블에서 행을 반환하려 한다

```sql
WITH V AS (
    SELECT ename AS DATA
        FROM emp
    WHERE deptno = 10
    UNION ALL
    SELECT ename || ', $' || CAST(sal AS char(4)) || '.00' AS data
        FROM emp
    WHERE deptno = 20
    UNION ALL
    SELECT ename || CAST(deptno AS char(4)) AS DATA
        FROM emp
    WHERE deptno = 30
)
SELECT * FROM V;
```

```sh
data           |
---------------+
CLARK          |
KING           |
MILLER         |
SMITH, $800.00 |
JONES, $2975.00|
SCOTT, $3000.00|
ADAMS, $1100.00|
FORD, $3000.00 |
ALLEN30        |
WARD30         |
MARTIN30       |
BLAKE30        |
TURNER30       |
JAMES30        |
```

특수문자나 소수점없는 행을 반환해야 한다

```sql
WITH V AS (
    SELECT ename AS DATA
        FROM emp
    WHERE deptno = 10
    UNION ALL
    SELECT ename || ', $' || CAST(sal AS char(4)) || '.00' AS data
        FROM emp
    WHERE deptno = 20
    UNION ALL
    SELECT ename || CAST(deptno AS char(4)) AS DATA
        FROM emp
    WHERE deptno = 30
)
SELECT
    data
    FROM V
WHERE TRANSLATE(
            lower(data)
        ,   '0123456789abcdefghijklnmopqrstuvwxyz'
        ,   rpad('a', 36, 'a')
        ) = rpad('a', length(data), 'a');
```

책에서 나온 해법으로는 `translate` 를 사용하여, 문자열 및 숫자를 전부 `a` 로 변경한후, `data` 의 `length` 만큼 `a` 로 채운 문자열과 같은지 확인한다

```sql
WITH V AS (
    SELECT ename AS DATA
        FROM emp
    WHERE deptno = 10
    UNION ALL
    SELECT ename || ', $' || CAST(sal AS char(4)) || '.00' AS data
        FROM emp
    WHERE deptno = 20
    UNION ALL
    SELECT ename || CAST(deptno AS char(4)) AS DATA
        FROM emp
    WHERE deptno = 30
)
SELECT
    TRANSLATE(
            lower(data)
        ,   '0123456789abcdefghijklmnopqrstuvwxyz'
        ,   rpad('a', 36, 'a')
    )
    FROM V;
```

```sh
translate      |
---------------+
aaaaa          |
aaaa           |
aaaaaa         |
aaaaa, $aaa.aa |
aaaaa, $aaaa.aa|
aaaaa, $aaaa.aa|
aaaaa, $aaaa.aa|
aaaa, $aaaa.aa |
aaaaaaa        |
aaaaaa         |
aaaaaaaa       |
aaaaaaa        |
aaaaaaaa       |
aaaaaaa        |
```

여기서, `a` 문자열 이외의 문자가 있다면, 해당 열은 특수문자가 포함된것 이므로, 제외한 것이다

## 이름에서 이니셜 추출

전체 이름을 이니셜로 바꾸고 싶다

```sql
--  내가 생각한 해법
WITH T AS (
    SELECT 'Stewie Griffin' name
)
SELECT
    REPLACE(
            translate(name, 'abcdefghijklnmopqrstuvwxyz', '')
        ,   ' '
        ,   '.'
    ) || '.'
    FROM T;

-- 책에서 제공하는 해법

WITH T AS (
    SELECT 'Stewie Griffin Todde' name
)
SELECT
    CONCAT(
        REPLACE(
            REPLACE(
                TRANSLATE(
                    name,
                    'abcdefghijklnmopqrstuvwxyz',
                    rpad('#', 26, '#')
                ),
                '#',
                ''
            ),
            ' ',
            '.'
        ), '.'
    )
    FROM T
```

책에서는 항상 `rpad` 를 사용하여, 모든 문자열에 `1대1` 대응하도록 만들고 빈문자열로 `replace` 한다.

> 혹시 이렇게 하지 않으면 발생하는 예외적인 상황이 있을까 싶기도 하다...
>
> 내 생각으로는 개념상으로는 같은 로직이다

`mysql` 해법에서는 `substring_index` 와 `substring` 을 사용하여, 구분처리한다

```sql
--  postgresql 에서는 split_part 로 대신한다
WITH T AS (
    SELECT 'Stewie Griffin Todde' name
)
SELECT
    substring(split_part(name, ' ', 1), 1, 1) fist_name,
    substring(split_part(name, ' ', 1 + 1), 1, 1) middle_name,
    substring(split_part(name, ' ', -1), 1, 1) last_name
    FROM T
```

```sh
fist_name|middle_name|last_name|
---------+-----------+---------+
S        |G          |T        |
```

이를 처리하면 이니셜을 추출할수 있음을 알수 있다
그럼 이제, `middle_name` 이 있을때와 없을때를 구분하여
처리해주어야 한다

방법은 다음과 같다

```sql
WITH T AS (
    SELECT REPLACE('Stewie Griffin Todde', '.', '') name
)
SELECT
    CASE
        WHEN cnt > 2 THEN (
        concat(
            concat_ws(
                '.',
                substring(split_part(name, ' ', 1), 1, 1),
                substring(split_part(name, ' ', 1 + 1), 1, 1),
                substring(split_part(name, ' ', -1), 1, 1)
            ),
            '.'
        )
        )
        ELSE
        concat(
            concat_ws(
                '.',
                substring(split_part(name, ' ', 1), 1, 1),
                substring(split_part(name, ' ', -1), 1, 1)
            ),
            '.'
        )
    END Initials
    FROM (
        SELECT
                name
            --  공백이 몇개인지 계산한 값 + 1 을 하여 middle_name 이 있는지 확인
            ,   length(name) - length(replace(name, ' ', '')) + 1 AS cnt
            FROM T
    )
```

```sh
initials|
--------+
S.G.T.  |
```

## 문자열 일부를 정렬

부분 문자열을 기준으로 결과셋을 정렬하라

```sql
WITH T AS (
    SELECT ename FROM emp
)
SELECT * FROM T;
```

```sh
ename |
------+
SMITH |
ALLEN |
WARD  |
JONES |
MARTIN|
BLAKE |
CLARK |
SCOTT |
KING  |
TURNER|
ADAMS |
JAMES |
FORD  |
MILLER|
```

위의 쿼리를 마지막 두문자를 기준으로 정렬한다

```sql
--  내 풀이
WITH T AS (
    SELECT ename FROM emp
)
SELECT
    ename,
    substring(ename, length(ename) - 1, 2)
    FROM T
ORDER BY substring(ename, length(ename) - 1, 2);

--  책의 풀이
WITH T AS (
    SELECT ename FROM emp
)
SELECT
    ename,
    substring(ename, length(ename) - 1, 2)
    FROM T
ORDER BY substring(ename, length(ename) - 1);
```

```sh
ename |substring|
------+---------+
ALLEN |EN       |
MILLER|ER       |
TURNER|ER       |
JAMES |ES       |
JONES |ES       |
MARTIN|IN       |
BLAKE |KE       |
ADAMS |MS       |
KING  |NG       |
FORD  |RD       |
WARD  |RD       |
CLARK |RK       |
SMITH |TH       |
SCOTT |TT       |
```

## 문자열의 숫자로 정렬

문자열 내 숫자를 기준으로 결과셋을 정렬하라

```sql
WITH T AS (
    SELECT
            e.ename || ' ' || cast(e.empno AS char(4)) || ' ' || d.dname AS DATA
        FROM emp e, dept d
    WHERE
        e.deptno = d.deptno
)
SELECT * FROM T;
```

```sh
data                  |
----------------------+
MILLER 7934 ACCOUNTING|
KING 7839 ACCOUNTING  |
CLARK 7782 ACCOUNTING |
FORD 7902 RESEARCH    |
ADAMS 7876 RESEARCH   |
SCOTT 7788 RESEARCH   |
JONES 7566 RESEARCH   |
SMITH 7369 RESEARCH   |
JAMES 7900 SALES      |
TURNER 7844 SALES     |
BLAKE 7698 SALES      |
MARTIN 7654 SALES     |
WARD 7521 SALES       |
ALLEN 7499 SALES      |
```

```sql
--  내 풀이
WITH T AS (
    SELECT
            e.ename || ' ' || cast(e.empno AS char(4)) || ' ' || d.dname AS DATA
        FROM emp e, dept d
    WHERE
        e.deptno = d.deptno
), NO AS (
    SELECT
        data,
        replace(
            TRANSLATE(
                lower(DATA),
                'abcdefghijklmnopqrstuvwxyz',
                rpad('#', 26, '#')
            ),
            '#',
            ''
        )::integer empno
        FROM T
)
SELECT
    T.DATA
FROM T, NO
WHERE
    T.data = NO.data
ORDER BY NO.empno;

--  책의 풀이
WITH T AS (
    SELECT
            e.ename || ' ' || cast(e.empno AS char(4)) || ' ' || d.dname AS DATA
        FROM emp e, dept d
    WHERE
        e.deptno = d.deptno
)
SELECT
    DATA
    FROM T
ORDER BY
    cast(
        REPLACE(
            translate(
                lower(DATA),
                'abcdefghijklnmopqrstuvwxyz',
                rpad('#', 26, '#')
            ),
            '#',
            ''
        ) AS integer
    );
```

책의 풀이가 맞다..
굳이 `equal join` 할 필요없이, 순회되는 해당 `data` 값을 `replace` 로 처리하면 된다..

> 복잡하게 생각했다..

## 테이블 행으로 구분된 목록 만들기

세로 열로 구분하여 표시한 목록 값이다

```sql
WITH T AS (
    SELECT
        deptno,
        ename
    FROM emp
)
SELECT
        deptno
    ,   ename
    FROM T
ORDER BY deptno, ename;
```

```sh
deptno|ename |
------+------+
    10|CLARK |
    10|KING  |
    10|MILLER|
    20|ADAMS |
    20|FORD  |
    20|JONES |
    20|SCOTT |
    20|SMITH |
    30|ALLEN |
    30|BLAKE |
    30|JAMES |
    30|MARTIN|
    30|TURNER|
    30|WARD  |
```

이중, 동일한 `deptno` 을 가지는 직원들을 쉼표로 구분된 값으로 반환하여, 결과셋을 표시하라

```sql
--  나의 풀이
WITH T AS (
    SELECT
        deptno,
        ename
    FROM emp
)
SELECT
        deptno,
        array_to_string(array_agg(ename ORDER BY ename), ',') emps
    FROM T
GROUP BY deptno
ORDER BY deptno;

--  책의 풀이
WITH T AS (
    SELECT
        deptno,
        ename
    FROM emp
)
SELECT
        deptno,
        string_agg(ename, ',' ORDER BY ename)
    FROM T
GROUP BY deptno
ORDER BY deptno;
```

```sh
deptno|emps                                |
------+------------------------------------+
    10|CLARK,KING,MILLER                   |
    20|ADAMS,FORD,JONES,SCOTT,SMITH        |
    30|ALLEN,BLAKE,JAMES,MARTIN,TURNER,WARD|
```

> 👍 `string_agg` 가 있었다

여기서 의문인게 `string_agg(ename order by empno seperator, ',')` 형식으로 처리하는데, `syntax error` 가 발생했다...

문법을 찾아보았지만, 위처럼 하는것을 아직 찾아보지 못해ㄸ

일단은 넘어가도록 한다.

## 구분된 데이터를 다중값 IN 목록으로 변환

다음의 문자열이 있다

```sh
'7654, 7698, 7782, 7788'
```

이 문자열을 사용하여 `in` 연산자로 해당 `empno` 을 가진 사원을 쿼리해야 한다

```sql
--  나의 풀이
WITH T AS (
    SELECT '7654, 7698, 7782, 7788' emp_list
), iter AS (
    SELECT 1 id
    UNION ALL
    SELECT 2 id
    UNION ALL
    SELECT 3 id
    UNION ALL
    SELECT 4 id
    UNION ALL
    SELECT 5 id
    UNION ALL
    SELECT 6 id
),emps AS (
    SELECT
        split_part(t.emp_list, ', ', iter.id)::integer emp
    FROM T t, iter iter
    WHERE iter.id <= (length(t.emp_list) - length(TRANSLATE(t.emp_list, ', ', ''))) / length(', ') + 1
)
SELECT
    ename, sal, deptno
    FROM emp e
    WHERE e.empno IN (SELECT emp FROM emps);

--  책의 풀이
--  책의 풀이가 조금 애매한부분이 있어서,
--  조금 다르게 작성했다

SELECT ename, sal, deptno
    FROM emp e
WHERE e.empno IN (
    SELECT cast(empno AS integer)
        FROM (
            SELECT split_part(list.vals, ', ', iter.pos) empno
                FROM
                    ( SELECT id AS pos FROM t10 ) iter,
                    ( SELECT '7654, 7698, 7782, 7788' AS vals FROM t1) list
                WHERE
                    iter.pos <= (length(list.vals) - length(
                        replace(
                            list.vals,
                            ', ',
                            ''
                        )
                    )) / length(', ') + 1
        )
)
```

## 문자열을 알파벳 순서로 정렬

문자열의 개별문자를 알파벳순으로 재정렬한다

> 개별문자이다.

```sql
WITH T AS (
    SELECT ename FROM emp
)
SELECT *
    FROM T
ORDER BY T.ename;
```

```sh
ename |
------+
ADAMS |
ALLEN |
BLAKE |
CLARK |
FORD  |
JAMES |
JONES |
KING  |
MARTIN|
MILLER|
SCOTT |
SMITH |
TURNER|
WARD  |
```

문제를 풀지 못했다
책의 예시를 보면, `iter` 를 사용하여 `데카르트 곱` 으로 `equal` 조인 처리한후, `equal join` 된 문자열의 각 `pos` 의 문자 하나를 추출한다

```sql
select ename, string_agg(c , '' ORDER BY c)
from (
 select a.ename,
        substr(a.ename,iter.pos,1) as c
   from emp a,
        (select id as pos from t10) iter
  where iter.pos <= length(a.ename)
  order by 1,2
        ) x
        Group By c
```

```sh
ename |length|c|
------+------+-+
ADAMS |     5|A|
ADAMS |     5|A|
ADAMS |     5|M|
ADAMS |     5|D|
ADAMS |     5|S|
ALLEN |     5|E|
ALLEN |     5|A|
ALLEN |     5|N|
ALLEN |     5|L|
ALLEN |     5|L|
BLAKE |     5|B|
BLAKE |     5|K|
BLAKE |     5|E|
BLAKE |     5|L|
BLAKE |     5|A|
CLARK |     5|C|
CLARK |     5|R|
CLARK |     5|L|
CLARK |     5|K|
CLARK |     5|A|
FORD  |     4|D|
FORD  |     4|O|
FORD  |     4|R|
FORD  |     4|F|
JAMES |     5|S|
JAMES |     5|J|
JAMES |     5|A|
JAMES |     5|E|
JAMES |     5|M|
JONES |     5|J|
JONES |     5|E|
JONES |     5|N|
JONES |     5|S|
JONES |     5|O|
KING  |     4|K|
KING  |     4|I|
KING  |     4|N|
KING  |     4|G|
MARTIN|     6|T|
MARTIN|     6|R|
MARTIN|     6|M|
MARTIN|     6|I|
MARTIN|     6|A|
MARTIN|     6|N|
MILLER|     6|I|
MILLER|     6|M|
MILLER|     6|L|
MILLER|     6|L|
MILLER|     6|E|
MILLER|     6|R|
SCOTT |     5|S|
SCOTT |     5|T|
SCOTT |     5|T|
SCOTT |     5|O|
SCOTT |     5|C|
SMITH |     5|T|
SMITH |     5|M|
SMITH |     5|H|
SMITH |     5|S|
SMITH |     5|I|
TURNER|     6|R|
TURNER|     6|N|
TURNER|     6|U|
TURNER|     6|E|
TURNER|     6|T|
TURNER|     6|R|
WARD  |     4|R|
WARD  |     4|D|
WARD  |     4|W|
WARD  |     4|A|
```

이렇게 추출된 각 문자열을 `string_agg` 로 결합하되, `group by` 절을 통해 `ename` 을 기준으로 `group` 화 시켜준후, 합친다

`order by` 를 통해 `ename` 을 기준으로, `c` 가 정렬되었으므로, `c` 값을 `string_agg` 를 통해 합쳐주면, 각 문자열의 문자를 합쳐 결합할수 있다

```sql
SELECT string_agg(c, '' ORDER BY c)
    FROM (
        SELECT e.ename AS ename,
            substring(e.ename, iter.pos, 1) AS c
        FROM
            emp e,
            (SELECT id AS pos FROM t10) iter
        WHERE iter.pos <= length(e.ename)
        ORDER BY 1, 2
    )
GROUP BY ename;
```

```sh
string_agg|
----------+
AADMS     |
AELLN     |
ABEKL     |
ACKLR     |
DFOR      |
AEJMS     |
EJNOS     |
GIKN      |
AIMNRT    |
EILLMR    |
COSTT     |
HIMST     |
ENRRTU    |
ADRW      |
```

> 이거 생각못했다..
>
> 아무래도, `데카르트 곱` 을 이용한, 처리에 적응할 필요가 있겠다
