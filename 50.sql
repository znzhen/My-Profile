use `new_school`;

-- 建立資料表
-- 學生
create table student(
 sno varchar(10) primary key,
 sname varchar(20),
 sage int(2), 
 ssex varchar(5)
);
-- 教師表
create table teacher(
 tno varchar(10) primary key, 
 tname varchar(20)
);
-- 課程表
create table course(
 cno varchar(10),
 cname varchar(20), 
 tno varchar(20), 
 constraint pk_course primary key (cno,tno)
);
-- 成績表
create table sc(
 sno varchar(10),
 cno varchar(10), 
 score float(4,2),
 constraint pk_sc primary key (sno,cno)
);
-- 插入數據
-- 學生
insert into student values ('s001','張三',23,'男');
insert into student values ('s002','李四',23,'男');
insert into student values ('s003','吳鵬',25,'男');
insert into student values ('s004','琴沁',20,'女');
insert into student values ('s005','王麗',20,'女');
insert into student values ('s006','李波',21,'男');
insert into student values ('s007','劉玉',21,'男');
insert into student values ('s008','蕭蓉',21,'女');
insert into student values ('s009','陳蕭曉',23,'女');
insert into student values ('s010','陳美',22,'女');
insert into student values ('s011','王麗',24,'女');
insert into student values ('s012','蕭蓉',20,'女');
-- 教師表
insert into teacher values ('t001', '劉陽');
insert into teacher values ('t002', '諶燕');
insert into teacher values ('t003', '胡明星');
-- 課程表
insert into course values ('c001','J2SE','t002');
insert into course values ('c002','Java Web','t002');
insert into course values ('c003','SSH','t001');
insert into course values ('c004','Oracle','t001');
insert into course values ('c005','SQL SERVER 2005','t003');
insert into course values ('c006','C#','t003');
insert into course values ('c007','JavaScript','t002');
insert into course values ('c008','DIV+CSS','t001');
insert into course values ('c009','PHP','t003');
insert into course values ('c010','EJB3.0','t002');
-- 成績表
insert into sc values ('s001','c001',78.9);
insert into sc values ('s002','c001',80.9);
insert into sc values ('s003','c001',81.9);
insert into sc values ('s004','c001',50.9);
insert into sc values ('s005','c001',59.9);
insert into sc values ('s001','c002',82.9);
insert into sc values ('s002','c002',72.9);
insert into sc values ('s003','c002',82.9);
insert into sc values ('s001','c003',59);
insert into sc values ('s006','c003',99.8);
insert into sc values ('s002','c004',52.9);
insert into sc values ('s003','c004',20.9);
insert into sc values ('s004','c004',59.8);
insert into sc values ('s005','c004',50.8);
insert into sc values ('s002','c005',92.9);
insert into sc values ('s001','c007',78.9);
insert into sc values ('s001','c010',78.9);
-- 練習開始
/* 1. 查詢學生表的 前10條資料 */
SELECT *
FROM student s
LIMIT 0,10;
/* 2.查詢成績表所有成績的最低分,平均分,總分 */
select MIN(score), avg(score), sum(score)
from sc;
/* 3.查詢老師 “諶燕” 所帶的課程設數量 */
select count(cno) from course
where tno='t002';
/* 查詢所有老師所帶 的課程 數量 */
select tno, count(*) from course
group by tno;
/* 查詢姓”張”的學生名單 */
select * from student
where sname LIKE '張%';
/* 查詢課程名稱為’Oracle’且分數低於60的學號和分數 */
select score, sno 
from sc left join course using(cno)
where cname ='Oracle' and score <60;
/* 查詢所有學生的選課 課程名稱 */
SELECT s2.sname AS '學生名稱', c.cname AS '課程名稱'
FROM sc s LEFT JOIN course c ON s.cno = c.cno 
LEFT JOIN student s2 ON s.sno = s2.sno
ORDER BY s.sno;
/* 查詢任何一門課程成績在70 分以上的學生姓名.課程名稱和分數 */
select s.sname,c.cname,s2.score from student s
left join sc s2 on s.sno=s2.sno
left join course c on c.cno=s2.cno
where score>=70 
order by score;
/* 查詢不及格的課程,並按課程號從大到小排列 學號,課程號,課程名,分數 */
select s.sno as '學號', c.cno AS '課程號', c.cname AS '課程名',s2.score AS '分數'
from student s left join sc s2 on s.sno=s2.sno
left join course c on c.cno=s2.cno
where score<60
order by c.cno;
/* 10.查詢沒學過”諶燕”老師講授的任一門課程  的學號,學生姓名 */ -- NOT IN
SELECT s.sno AS '學號', s.sname AS '學生姓名' FROM student s  
WHERE s.sno NOT IN 
(SELECT DISTINCT s2.sno FROM sc s2 
LEFT JOIN course c ON s2.cno = c.cno 
LEFT JOIN student s ON s2.sno = s.sno 
LEFT JOIN teacher t ON c.tno = t.tno 
WHERE t.tname = '諶燕');
/* 11.查詢兩門以上不及格課程的同學 的學號及其平均成績 */
SELECT s.sno AS '學號', AVG(s.score) AS '平均成績' FROM sc s 
WHERE s.score < 60
GROUP BY s.sno
HAVING COUNT(score) >= 2;
/* 檢索’c004’課程分數小於60,按分數降序排列的同學學號 */
select sno from sc
where cno='c004' and score<60
order by score ;
/* 刪除"s002"同學的"c001"課程的成績 */
delete from sc where sno='s002' and cno='c001';
/* 14.查詢’c001’課程比’c002’課程成績高的所有學生的學號 */ -- 同個表格重複用
SELECT a.sno AS '學生學號' FROM sc a
LEFT JOIN sc b ON a.sno = b.sno
WHERE a.cno = 'c001' AND b.cno = 'c002' AND a.score > b.score;
/* 15.查詢平均成績大於60 分的同學的學號和平均成績 */
select sno, avg(score)
from sc group by sno
having avg(score) >60;
/* 查詢所有同學的學號.姓名.選課數.總成績 */
select s.sno as '學號', s.sname as '姓名', count(s2.cno) as '選課數', sum(s2.score) as '總成績'
from student s left join sc s2 on s.sno=s2.sno
group by s.sno;
/* 17.查詢姓”劉”的老師的個數 */
select count(tname) from teacher
where tname like '劉%';
/* 查詢只學”諶燕”老師所教的課的同學的學號:姓名 */
SELECT s.sno AS '學號',
s2.sname AS '姓名'
FROM sc s 
LEFT JOIN student s2 ON s.sno = s2.sno
WHERE s.sno NOT IN 
(SELECT sno FROM sc s3
WHERE s3.cno NOT IN 
(SELECT DISTINCT c.cno 
FROM course c
LEFT JOIN teacher t ON c.tno = t.tno
 WHERE t.tname ='諶燕'));
/*19. 查詢學過”c001″並且也學過編號”c002″課程的同學的學號.姓名*/
 select st.* from sc a  -- 指返回student表格裡面的內容
 join sc b on a.sno=b.sno
 join student st on st.sno=a.sno
 where a.cno='c001' and b.cno='c002' and st.sno=a.sno;
 /*20. 查詢學過"諶燕"老師所教的所有課的同學的學號:姓名*/
 select distinct s.* from student s
 join sc s2 on s2.sno=s.sno
 join course c on c.cno=s2.cno
 join teacher t on t.tno=c.tno
 where t.tname='諶燕' ;
 /* 查詢課程編號"c002"的成績 比 課程編號"c001"課程 低 的所有同學的學號.姓名; */
select s.sno, s.sname from student s
left join sc s2 on s.sno = s2.sno
left join sc s3 on s.sno = s3.sno
where s2.cno='c002' and s3.cno='c001' and s2.score < s3.score;
/* 22.查詢所有課程成績 小於60分 的同學的學號.姓名; */
select s.sno, s.sname ,s2.score from student s
left join sc s2 on s.sno=s2.sno
where s2.score <60;
/* .查詢 沒有學全所有課 的同學的學號.姓名; */
select s.sno, s.sname from student s -- 學號 姓名
left join sc s2 on s2.sno=s.sno
group by s.sno, s.sname 
having count(s2.cno)< (select count(cno) from course); -- 學生的課程 < 全部的課程
/* 24.查詢至少有一門課 與學號爲"s001"的同學 所學相同 的同學的學號和姓名 */
 select st.* from student st,
 (select distinct a.sno from
 (select * from sc) a,
 (select * from sc where sc.sno='s001') b
 where a.cno=b.cno) h
 where st.sno=h.sno and st.sno<>'s001';
/* 25.查詢至少學過 學號爲"s001"同學 所有一門課的 其他同學學號和姓名; */
 select * from sc
 left join student st on st.sno=sc.sno
 where sc.sno <>'s001' -- 在學生裡，學號不等於001的
 and sc.cno in (select cno from sc where sno='s001'); -- 他們的課程號碼在 (課表裡是學號為001)
 /*  查詢各科成績最高和最低的分: 以如下形式顯示:課程ID,最高分 */
select c.cno as '課程ID', max(c.score) as '最高分', min(c.score) as '最低分' from sc c
group by c.cno;
/* 32.查詢不同老師 所教不同課程 平均分從高到低顯示 */
select max(t.tno), max(t.tname) ,max(c.cno), max(c.cname), c.cno, avg(score) 
-- 使用MAX()函數來取得每個分組內最大的教師編號和教師姓名，
-- 這樣可以確保結果中每一門課程都對應到正確的教師信息。
from sc , course c, teacher t
where sc.cno=c.cno and c.tno=t.tno 
group by c.cno
order by avg(score) desc;
/* 33.統計列印 各科成績的課程ID,課程名稱, 各分數段人數[100-85],[85-70],[70-60],[ <60] */
select sc.cno,c.cname,
 sum(case  when score between 85 and 100 then 1 else 0 end) AS "[100-85]",
 sum(case  when score between 70 and 85 then 1 else 0 end) AS "[85-70]",
 sum(case  when score between 60 and 70 then 1 else 0 end) AS "[70-60]",
 sum(case  when score <60 then 1 else 0 end) AS "[<60]"
 from sc, course c
 where  sc.cno=c.cno
 group by sc.cno ,c.cname;
/* 查詢出只選修了一門課程的 全部學生的學號和姓名 */
SELECT s.sno, s.sname from student s
left join sc s2 on s2.sno=s.sno
group by s.sno
having count(s2.cno)=1;
/* 37.查詢男生.女生人數 */
select ssex,count(*) from student 
group by ssex;
/* 39.1981 年出生的學生名單 (注:Student 表中Sage 列的類型是number) */
SELECT *
FROM Student
WHERE YEAR(CURDATE()) - Sage = 1981;
/* 40.查詢每門課程的平均成績,結果按平均成績升序排列,平均成績相同時,按課程號降序排列 */
select cno,avg(score) from sc 
group by cno 
order by avg(score)asc, cno desc; -- 先根據___， 再根據___
/* 41.查詢平均成績大於85 的所有學生的學號.姓名和平均成績 */
select s.sname,s.sno,avg(s2.score) from student s
left join sc s2 on s2.sno=s.sno
group by s.sname, s.sno
having avg(s2.score)>85 ;
/* 42.查詢課程編號爲c001 且課程成績在80 分以上的學生的學號和姓名; */
select s.sno,s.sname from student s
join sc s2 on s2.sno=s.sno
where s2.cno='c001' and s2.score >80;
/* 43.求選了課程的學生人數*/
 select count(distinct sno) from sc;
/*44.查詢選修"諶燕"老師所授課程的學生中,成績最高的學生姓名及其成績*/
 select st.sname,score from student st, sc, course c, teacher t
 where st.sno=sc.sno and sc.cno=c.cno and c.tno=t.tno
 and t.tname='諶燕' and sc.score=
 (select max(score)from sc where sc.cno=c.cno);
 /* 45.查詢各個課程及相應的選修人數 */
 select cno, count(sno) from sc
 group by cno;
 /* 46.查詢不同課程成績相同的學生的學號.課程號.學生成績 */
  select a.* from sc a ,sc b 
  where a.score=b.score and a.cno<>b.cno;
/* 49.檢索至少選修兩門課程的學生學號 */
select sno from sc
group by sno
having count(cno)>1;
/* 50.查詢全部學生都選修的課程的課程號和課程名 */
 select distinct(c.cno),c.cname from course c ,sc
 where sc.cno=c.cno;
 where sc.cno=c.cno;