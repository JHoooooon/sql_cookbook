SELECT
        ename
    ,   dname
FROM emp
INNER JOIN dept
ON dept.deptno = emp.deptno
WHERE emp.deptno = 10;

SELECT * from dept;
SELECT * from emp;


SELECT
    ename ename_and_dname,
    deptno
    FROM emp
WHERE deptno = 10
UNION ALL
SELECT
    repeat('-', 10),
    null
UNION ALL
SELECT
    d.dname ename_ename_and_dname,
    d.deptno
    FROM dept d;

SELECT
    deptno
    FROM emp
UNION
SELECT
    deptno
    FROM dept;

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

SELECT * from dept;
SELECT
        e.ename
    ,   d.dname
    ,   d.loc
    FROM emp e
JOIN dept d
ON e.deptno = d.deptno
WHERE e.deptno = 10;

SELECT
        e.ename
    ,   d.dname
    ,   d.loc
    FROM emp e, dept d
WHERE 
    e.deptno = d.deptno
    AND e.deptno = 10;


SELECT
        e.ename
    ,   d.dname
    ,   d.loc
    FROM emp e
    cross join dept d;

SELECT
        e.ename
    ,   d.dname
    ,   d.loc
    FROM emp e, dept d;

SELECT
        e.ename
    ,   d.dname
    ,   d.loc
    FROM emp e, dept d
    WHERE e.deptno = d.deptno;


SELECT
        e.ename
    ,   d.dname
    ,   d.loc
    FROM emp e, dept d
WHERE 
    e.deptno = d.deptno
    AND e.deptno = 10;

DROP VIEW IF EXISTS v;

CREATE VIEW v
AS
SELECT ename, job, sal
    FROM emp
WHERE job = 'CLERK';

SELECT * FROM v;

SELECT
        e.empno
    ,   e.ename
    ,   e.job
    ,   e.sal
    ,   e.deptno
    FROM emp e, v v
WHERE e.ename = v.ename

SELECT
        e.empno
    ,   e.ename
    ,   e.job
    ,   e.sal
    ,   e.deptno
    FROM emp e
    JOIN v v
        ON e.ename = v.ename