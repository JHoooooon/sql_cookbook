# 메타 데이터 쿼리

특정 스키마에대한 정보를 찾을수 있는 래시피를 제공한다
테이블을 생서했는지, 왜래 키가 인덱싱되지 않았는지를 알고자 할수 있다

> 이부분은 한번 훑고 추가적으로 `Postgresql` 에서 사용하는 `information_scheam`, `pg_catalog` 를 정리한후 다시 봐야할것 같다..

`RDBMS` 는 데이터를 얻기 위한 테이브로가 뷰를 제공한다

`RDBMS` 는 테이블 및 뷰에 대한 메타 데이터를 높은 수준에서 저장하는 전략이 일반적이지만, 궁극적으로 구현된 형태들이 이 책에서 따르는 대부분이 `SQL` 과 같은 수준으로 표준화되지는 않는다

## 스키마 테이블 목록

```sql
--  postgresql, mysql

SELECT *
    FROM information_schema.tables
WHERE table_schema = 'public';
```

## 테이블의 열 나열

```sql
SELECT
        --  열의 이름
        column_name
        --  데이터 유형
    ,   data_type
        --  데이터 유형의 위치값
    ,   ordinal_position
    FROM information_schema.columns
WHERE
    table_schema    = 'public'
    AND table_name  = 'emp';
```

```sh
column_name|data_type        |ordinal_position|
-----------+-----------------+----------------+
empno      |integer          |               1|
ename      |character varying|               2|
job        |character varying|               3|
mgr        |integer          |               4|
hiredate   |date             |               5|
sal        |integer          |               6|
comm       |integer          |               7|
deptno     |integer          |               8|
```

```sql
SELECT
        --  db 명
        table_catalog
        --  schema 명
    ,   table_schema
        --  table 명
    ,   table_name
        --  열의 이름
    ,   column_name
        --  데이터 유형의 위치값
    ,   ordinal_position
        --  field default 값
    ,   column_default
        --  null 허용하는지
    ,   is_nullable
        --  data 타입
    ,   data_type
        --  data_type 이 문자 또는 비트 문자열일때 최대길이
    ,   character_maximum_length
        --  data_type 이 문자 또는 비트 문자열일때 최대길이 (byte 단위)
    ,   character_octet_length
        --  숫자일때 경우 정밀도
    ,   numeric_precision
        --  정밀도 및 소수점 유효 자리수 표시
    ,   numeric_precision_radix
        --  소수점 유효 자리수 표시
    ,   numeric_scale
        --  datetime 정밀도
    ,   datetime_precision
        --  datetime 일때
    ,   datetime_precision
        --  datetime 일때 소수로 나타낸 시간(초)정밀도
    ,   datetime_precision
        --  등등 많다..
    FROM information_schema.columns
WHERE
    table_schema    = 'public'
    AND table_name  = 'emp';
```

```sh
table_catalog|table_schema|table_name|column_name|ordinal_position|column_default|is_nullable|data_type        |character_maximum_length|character_octet_length|numeric_precision|numeric_precision_radix|numeric_scale|datetime_precision|interval_type|interval_precision|character_set_catalog|character_set_schema|character_set_name|collation_catalog|collation_schema|collation_name|domain_catalog|domain_schema|domain_name|udt_catalog|udt_schema|udt_name|scope_catalog|scope_schema|scope_name|maximum_cardinality|dtd_identifier|is_self_referencing|is_identity|identity_generation|identity_start|identity_increment|identity_maximum|identity_minimum|identity_cycle|is_generated|generation_expression|is_updatable|
-------------+------------+----------+-----------+----------------+--------------+-----------+-----------------+------------------------+----------------------+-----------------+-----------------------+-------------+------------------+-------------+------------------+---------------------+--------------------+------------------+-----------------+----------------+--------------+--------------+-------------+-----------+-----------+----------+--------+-------------+------------+----------+-------------------+--------------+-------------------+-----------+-------------------+--------------+------------------+----------------+----------------+--------------+------------+---------------------+------------+
postgres     |public      |emp       |empno      |               1|              |NO         |integer          |                        |                      |               32|                      2|            0|                  |             |                  |                     |                    |                  |                 |                |              |              |             |           |postgres   |pg_catalog|int4    |             |            |          |                   |1             |NO                 |NO         |                   |              |                  |                |                |NO            |NEVER       |                     |YES         |
postgres     |public      |emp       |ename      |               2|              |YES        |character varying|                      10|                    40|                 |                       |             |                  |             |                  |                     |                    |                  |                 |                |              |              |             |           |postgres   |pg_catalog|varchar |             |            |          |                   |2             |NO                 |NO         |                   |              |                  |                |                |NO            |NEVER       |                     |YES         |
postgres     |public      |emp       |job        |               3|              |YES        |character varying|                       9|                    36|                 |                       |             |                  |             |                  |                     |                    |                  |                 |                |              |              |             |           |postgres   |pg_catalog|varchar |             |            |          |                   |3             |NO                 |NO         |                   |              |                  |                |                |NO            |NEVER       |                     |YES         |
postgres     |public      |emp       |mgr        |               4|              |YES        |integer          |                        |                      |               32|                      2|            0|                  |             |                  |                     |                    |                  |                 |                |              |              |             |           |postgres   |pg_catalog|int4    |             |            |          |                   |4             |NO                 |NO         |                   |              |                  |                |                |NO            |NEVER       |                     |YES         |
postgres     |public      |emp       |hiredate   |               5|              |YES        |date             |                        |                      |                 |                       |             |                 0|             |                  |                     |                    |                  |                 |                |              |              |             |           |postgres   |pg_catalog|date    |             |            |          |                   |5             |NO                 |NO         |                   |              |                  |                |                |NO            |NEVER       |                     |YES         |
postgres     |public      |emp       |sal        |               6|              |YES        |integer          |                        |                      |               32|                      2|            0|                  |             |                  |                     |                    |                  |                 |                |              |              |             |           |postgres   |pg_catalog|int4    |             |            |          |                   |6             |NO                 |NO         |                   |              |                  |                |                |NO            |NEVER       |                     |YES         |
postgres     |public      |emp       |comm       |               7|              |YES        |integer          |                        |                      |               32|                      2|            0|                  |             |                  |                     |                    |                  |                 |                |              |              |             |           |postgres   |pg_catalog|int4    |             |            |          |                   |7             |NO                 |NO         |                   |              |                  |                |                |NO            |NEVER       |                     |YES         |
postgres     |public      |emp       |deptno     |               8|              |YES        |integer          |                        |                      |               32|                      2|            0|                  |             |                  |                     |                    |                  |                 |                |              |              |             |           |postgres   |pg_catalog|int4    |             |            |          |                   |8             |NO                 |NO         |                   |              |                  |                |                |NO            |NEVER       |                     |YES         |
```

## 테이블의 인덱싱된 열 나열

```sql
SELECT
        a.tablename
    ,   a.indexname
    ,   b.column_name
    FROM
        pg_catalog.pg_indexes a,
        information_schema.columns b
WHERE
        a.schemaname = 'public'
    AND b.table_name = 'emp';
```

## 테이블의 제약조건 나열

```sql
SELECT
        a.table_name
    ,   a.constraint_name
    ,   b.column_name
    ,   a.constraint_type
    FROM
        information_schema.table_constraints a,
        information_schema.key_column_usage b
WHERE
        a.table_name        = 'EMP'
    AND a.table_schema      = 'public'
    AND a.table_name        = b.table_name
    AND a.table_schema      = b.table_schema
    AND a.constraint_name   = b.constraint_name;
```

## 관련 인덱스가 없는 외래 키 나열

인덱싱 되징 않은 외래키 열을 가진 테이블을 나열한다

```sql
SELECT
        fkey.table_name
    ,   fkeys.constraint_name
    ,   fkeys.column_name
    ,   ind_cols.indexname
    FROM (
        SELECT
                a.constraint_schema
            ,   a.table_name
            ,   a.constraint_name
            ,   a.column_name
            FROM   information_schema.key_column_usage a
                ,  information_schema.referential_constraints b
        WHERE
                a.constraint_name   = b.constraint_name
            AND a.constraint_schema = b.constraint_schema
            AND a.constraint_schema = 'public'
            AND a.table_name        = 'emp'
    ) fkeys
    LEFT JOIN
    (
        SELECT
                a.schemaname
            ,   a.tablename
            ,   b.column_name
            FROM    pg_catalog.pg_indexes a
                ,   information_schema.columns b
        WHERE
                a.tablename     = b.table_name
            AND a.schemaname    = b.table_schema
    ) ind_cols
    ON  (
        fkeys.constraint_schema = ind_cols.schemaname
        AND fkeys.table_name    = ind_cols.tablename
        AND fkeys.column_name   = ind_cols.column_name
    )
WHERE
    ind_cols.indexname IS NULL;
```

## SQL 로 SQL 생성

```sql
--  모든 테이블에서 모든 행의 수를 세는 SQL 생성
SELECT
    'select count(*) from ' || table_name || ';' cnts
    FROM information_schema.tables;
```

```sh
cnts                                                       |
-----------------------------------------------------------+
select count(*) from pg_statistic;                         |
select count(*) from pg_type;                              |
select count(*) from dept;                                 |
select count(*) from d;                                    |
select count(*) from dept_2;                               |
select count(*) from emp_commission;                       |
...
```

```sql
--  모든 테이블의 외래키 비활성
SELECT
    'alter table ' || table_name || 'disabl constraint' || constraint_name || ';' cons
    FROM information_schema.table_constraints
WHERE constraint_type = 'FOREIGN KEY';
```
