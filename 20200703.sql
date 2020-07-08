
p.220 실습 join1
erd 다이어그램을 참고하여 prod 테이블과 lprod테이블을 조인하여
다음과 같은 결과가 나오는 쿼리를 작성
SELECT *
FROM prod;

SELECT *
FROM lprod;

ANSI-SQL 두 테이블의 연결 컬럼명이 다르기 때문에
NATURAL JOIN, JOIN with USING은 사용이 불가

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod JOIN lprod ON (prod.prod_lgu = lprod.lprod_gu);

ORACLE SQL
SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod, lprod
WHERE prod.prod_lgu = lprod.lprod_gu;


p221 실습 join2
erd 다이어그램을 참고하여 buyer,prod테이블을 조인하여
buyer별 담당하는 제품 정보를 다음과 같이 작성
ANSI-SQL
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod JOIN buyer ON(prod.prod_buyer = buyer.buyer_id);

ORACLE SQL
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod, buyer     --기술하는 순서 중요하지 않음(결과에 영향 없음)
WHERE prod.prod_buyer = buyer.buyer_id;


p222 실습 join3
erd다이어그램을 참고하여 member,cart,prod 테이블을 조인하여 
회원별 장바구니에 담은 제품 정보를 
ANSI-SQL
FROM 테이블명1 JOIN 테이블2

ANSI-SQL
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON(member.mem_id = cart.cart_member) 
            JOIN prod ON(cart.cart_prod = prod.prod_id);
            
CONCAT('Hello', CONCAT(',','World')) 형식과 비슷

ORACLE-SQL     
--좋은예
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member
  AND cart.cart_prod = prod.prod_id;


p223 실습 join 4~7
--새로운... 실습폴더의 batch.sql 내용 복사해서 실행시키고 -> commit;
CUSTOMER : 고객
PRODUCT : 제품
CYCLE(주기) : 고객 제품 애음 주기

SELECT *
FROM customer;

SELECT *
FROM cycle;

p223 실습 join4
erd 다이어그램을 참고하여 customer,cycle테이블을 조인하여
고객별 애음 제품,애음요일,개수를 다음과 같은 결과가 나오도록 쿼리를 작성
(고객명이 brown, sally인 고객만 조회) (정렬과 관계없이 값이 맞으면 정답)

SELECT customer.*, pid, day, cnt    --customer에서는 전제 다 가져오고

SELECT customer.cid, cnm, pid, day, cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
  AND cnm IN('brown', 'sally');
-->customer.*, = customer.cid,customer.cnm,pid,day,cnt
-->AND customer.cnm IN ('brown', 'sally');
 
p.225 실습 join5
customer, cycle, product 테이블을 조인하여
고객별 애음제품(pid), 애음요일(day), 개수(cnt), 제품명(pnm)을 쿼리작성
(고객명이 brown, sally인 고객만 조회) (정렬과 관계없이 값이 맞으면 정답)

SELECT customer.*, cycle.pid, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
  AND cycle.pid = product.pid
  AND customer.cnm IN('brown', 'sally');


p.226 실습 join6
customer, cycle, product 테이블을 조인하여
애음요일(day)과 관계없이 고객별 애음 제품별(pid), 개수(cnt)의 합(***)과, 제품명(pnm)을 쿼리 작성
(정렬과 관계없이 값이 맞으면 정답)

SELECT customer.*, cycle.pid, pnm, SUM(cnt)
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
  AND cycle.pid = product.pid
GROUP BY customer.cid, customer.cnm, cycle.pid, pnm;

인라인뷰로?
15 => 6 group ==> join

(SELECT cid, pid, SUM(cnt)
FROM cycle
GROUP BY cid, pid ) cycle, customer, product;
 

p.227 실습 join7
cycle, product 테이블을 이용하여
제품별, 개수의 합과, 제품명을 쿼리 작성
(정렬과 관계없이 값이 맞으면 정답)

SELECT cycle.pid, pnm, SUM(cnt)
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, pnm;



조인 성공 여부로 데이터 조회를 결정하는 구분방법
INNER JOIN : 조인에 성공하는 데이터만 조회하는 조인 방법 (빈도높음)
OUTTER JOIN : 조인에 실패 하더라도, 개발자가 지정한 기준이 되는 테이블의
              데이터는 나오도록 하는 조인
OUTER <==> INNER JOIN

복습 - 사원의 관리자 이름을 알고 싶은 상황
    조회 컬럼 : 사원의 사번, 사원의 이름, 사원의 관리자의 사번, 사원의 관리자의 이름
    
동일한 테이블끼리 조인 되었기 때문에 : SELF-JOIN
조인 조건을 만족한 데이터만 조회 되었기 때문에 : INNER-JOIN
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

KING의 경우 PRESIDENT이기 때문에 mgr 컬럼 값이 NULL ==> 조인에 실패
==> KING의 데이터는 조회되지 않음 (총 14건 데이터중 13건의 데이터만 조인 성공)

OUTER 조인을 이용하여 조인 테이블중 기준이 되는 테이블을 선택하면
조인에 실패하더라도 기준 테이블의 데이터는 조회 되도록 할 수 있다
LEFT / RIGHT OUTER

ANSI-SQL
테이블1 JOIN 테이블2 ON (.....)
테이블1 LEFT OUTER JOIN 테이블2 ON (.....)
위 쿼리는 아래와 동일
테이블2 RIGHT OUTER JOIN 테이블1 ON (.....)

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno);



