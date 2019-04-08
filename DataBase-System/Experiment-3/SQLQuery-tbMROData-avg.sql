/*insert into tbMROData
select TimeStamp, ServingSector, InterferingSector, avg(cast(LteScRSRP as float)) as LteScRSRP, avg(cast(LteNcRSRP as float)) as LteNcRSRP,avg(cast(LteNcEarfcn as int)) as LteNcEarfcn, avg(cast(LteNcPci as smallint)) as LteNcPci 
from _tbMROData
group by TimeStamp, ServingSector, InterferingSector*/
select * from tbMROData