use `回收` ;
select *
from `一般廢棄物清理情況資料8`;

##查看總垃圾量
select `"year"`, `"county"` ,(`一般廢棄物產生量` + `一般垃圾量` + `資源垃圾量` + `廚餘回收`) AS `all`
from `一般廢棄物清理情況資料8` order by `all` desc;

##單看 "一般廢棄物"
select `"county"`, `一般廢棄物產生量` 
from `一般廢棄物清理情況資料8`
where `"year"` = 111
order by `一般廢棄物產生量` desc;

##查看哪個縣市依般廢棄物回收率最高
select *
from `一般廢棄物回收率指標資料8` 
where `"year"` = 111
order by `一般廢棄物回收率` desc;

select *
from `全國一般廢棄物處理量8`
order by `總處理量` desc;
