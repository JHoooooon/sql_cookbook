
SELECT *
    FROM information_schema.tables
WHERE table_schema = 'public';

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

SELECT
    --     a.tablename
    -- ,   a.indexname
    -- ,   b.column_name
    *
    FROM 
        pg_catalog.pg_indexes a,
        information_schema.columns b
WHERE
        a.schemaname = 'public'
    AND b.table_name = 'emp';

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

SELECT
    *
FROM
    information_schema.key_column_usage;

SELECT
    *
FROM
    information_schema.table_constraints;

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

SELECT
    'select count(*) from ' || 'table_name' || ';' cnts
    FROM information_schema.tables;