/*
select distinct CellID from dbo.tbATUData
	where EARFCN = 38400
*/
/*
select NCELL_ID from dbo.tbATUC2I where 
	SECTOR_ID = '238397-1' and COSITE = 1
select NSECTOR_ID from dbo.tbATUHandOver where SSECTOR_ID = '238397-1'
*/
/*
select tbATUC2I.NCELL_ID,tbATUHandOver.NSECTOR_ID 
	from tbATUC2I  INNER join tbATUHandOver 
	 on  SSECTOR_ID = '238397-1' and SECTOR_ID = SSECTOR_ID and COSITE =1
*/



/*select T.SCELL,T.NCELL
from tbC2I as T,tbC2I as S
where T.C2I_Mean > S.C2I_Mean 
	and S.SCELL ='124673-0' and S.NCELL='259772-0'
*/
/*
select 	SECTOR_NAME 
from    tbPCIAssignment
where   SECTOR_NAME like '%三门峡%'; 
*/

/*
with max_hoatt as
	(select max(HOATT) AS MAX_HOATT
	 from   tbATUHandOver
	 group  by SSECTOR_ID)
	 */

/*
select SSECTOR_ID,NSECTOR_ID ,HOATT
from   tbATUHandOver
where  HOATT IN (select max(HOATT) AS MAX_HOATT
				 from   tbATUHandOver
				 group  by SSECTOR_ID )
order by HOATT desc
*/

-- 使用between语句查询
--	经度位于111到112之间、纬度位于34.7到34.9之间的小区
--		的C2I干扰的均值最大的
--			邻小区ID
/*	
with sector_id as (
					select SECTOR_ID
					from   tbCell
					where  (LONGITUDE between 111 and 112)
					and	   (LATITUDE  between 34.7 and 34.9)),
	 max_c2i  as (
					select max(C2I_Mean) as max_c2i_mean
					from   tbC2I
					where  SCELL IN (
							select SECTOR_ID
							from   tbCell
							where  (LONGITUDE between 111 and 112)
							and	   (LATITUDE  between 34.7 and 34.9) ) )

select NCELL
from   tbC2I
where  C2I_Mean in (
					select max(C2I_Mean) as max_c2i_mean
					from   tbC2I
					where  SCELL IN (
							select SECTOR_ID
							from   tbCell
							where  (LONGITUDE between 111 and 112)
							and	   (LATITUDE  between 34.7 and 34.9) ) )

*/					

--使用union语句中查询所属城市为宜阳、频点为38544，
-- 或所属城市为三门峡、频点为38400的小区
/*
select SECTOR_ID from  dbo.tbCell where  CITY = '宜阳' and EARFCN =38544
union  
select SECTOR_ID from  dbo.tbCell where  CITY ='三门峡' and EARFCN = 385400;		
*/

--根据小区一阶邻区关系表和二阶（同频）邻区关系表，使用interset语句查询一阶邻区和二阶邻区相同的小区。
/*

select tbAdjCell.S_SECTOR_ID
from   tbAdjCell
where  N_SECTOR_ID in(select N_SECTOR_ID from tbAdjCell intersect select N_SECTOR_ID from tbSecAdjCell)
*/

--根据一阶邻区关系表和二阶（同频）邻区关系表，使用except语句查询二阶邻区不是一阶邻区的小区
--NOTES:EXCEPT 仅返回那些不存在于第二个 SELECT 语句结果的记录（差集）
/*
select tbAdjCell.S_SECTOR_ID
from   tbAdjCell
where  N_SECTOR_ID in (select N_SECTOR_ID from tbAdjCell except select N_SECTOR_ID from tbSecAdjCell)
*/

--根据路测ATU C2I干扰矩阵表，使用except语句查询主小区和邻小区间干扰强度最大的小区

/*
select NCELL_ID
from   tbATUC2I
where  RANK IN (select RANK from tbATUC2I except select RANK from tbATUC2I where RANK >1)
*/

--根据路测ATU数据表，查询第1邻小区/干扰小区物理小区标识不为空的服务小区ID、服务小区PCI
/*
select NCell_ID_1,CellID,PCI
from   tbATUData
where  NCell_ID_1 is not null
*/

--根据优化小区/保护带小区表和小区一阶邻区关系表，查询一阶邻区数大于10的优化小区，并将查询结果降序排列。

/*

select SECTOR_ID
from   tbOptCell
where  CELL_TYPE='优化区' 
   and SECTOR_ID IN (select SECTOR_ID
					 from   tbOptCell
					 where  EXISTS  (select   S_SECTOR_ID, count( N_SECTOR_ID) as num
									 from     tbAdjCell			
									 group by S_SECTOR_ID
									 having   count( N_SECTOR_ID)>10) )
order by SECTOR_ID desc

*/

--根据小区/基站工参表和路测ATU数据表，查询所属基站为“253903”的小区的最大信噪比SINR，最小信噪比SINR，平均信噪比SINR
/*
select max(RS_SINR) as max_sinr,
	   min(RS_SINR) as min_sinr,
	   avg(RS_SINR) as avg_sinr
from   tbATUData
where  CellID in (
			select SECTOR_ID
			from   tbCell
			where  ENODEBID = 253903 )
*/

--根据优化小区/保护带小区表和小区PCI优化调整结果表，查询小区类型为“优化区”的小区经调整后的PCI
/*
select SECTOR_ID,PCI
from   tbPCIAssignment
where  SECTOR_ID IN(
					select SECTOR_ID 
					from   tbOptCell
					where  CELL_TYPE = '优化区' )
*/

--根据路测ATU数据表和小区/基站工参表，
--使用some语句查询 “服务小区参考信号接收功率RSRP”大于
-- 部分（至少一个）所属基站ID为5660的小区的“服务小区参考信号接收功率RSRP”的
--													服务小区
/*
select CellID
from   tbATUData
where  RSRP > some( select RSRP
					 from   tbATUData
					 where  CellID IN (select SECTOR_ID	
									   from   tbCell
									   where  ENODEBID = 5660)
					 )
*/

--根据路测ATU切换统计矩阵表和MRO测量报告数据表，使用all语句查询切换次数最多 的小区的干扰小区ID，干扰小区PCI
/*


select InterferingSector,LteNcPci
from   tbMROData
where  ServingSector in ( select SSECTOR_ID
						  from   tbATUHandOver
						  where  HOATT>=all (select HOATT
											from   tbATUHandOver)
						)


select SSECTOR_ID,HOATT
						  from   tbATUHandOver
						  where  HOATT>=all (select HOATT
											from   tbATUHandOver )


select HOATT
											from   tbATUHandOver


*/

--根据路测ATU数据表和优化小区表，使用not exists语句查询
--小区类型 不为保护带小区的
--		第1邻小区/干扰小区的标识、第1邻小区/干扰小区频点、第1邻小区/干扰小区物理小区标识、第1邻小区/干扰小区参考信号接收强度。

/*
select NCell_ID_1,NCell_EARFCN_1,NCell_PCI_1,NCell_RSRP_1
from   tbATUData
where  CellID in (
					select SECTOR_ID
					from   tbOptCell
					where  CELL_TYPE in (
											select CELL_TYPE
											from   tbOptCell as T
											where  NOT EXISTS 
															 (select *
															  from   tbOptCell
															  where   T.CELL_TYPE='保护带')
										)
					)


select
*/

--根据基于MR测量报告的干扰分析表和路测ATU切换统计矩阵表
--查询主小区ID在路测ATU切换统计矩阵表中只出现过一次的加权C2I干扰

/* 用Unique失败
SELECT WeightedC2I
from   tbC2I
where  SCELL in ( select T.SSECTOR_ID
				  from   tbATUHandOver as T
				  where unique(select count(S.SSECTOR_ID)
								 from   tbATUHandOver as S
								 where  T.SSECTOR_ID =S.SSECTOR_ID	)
								 )
*/
/* 换一种方法
SELECT WeightedC2I
from   tbC2I
where  SCELL in ( select T.SSECTOR_ID
				  from   tbATUHandOver as T
				  where 1>=(select count(S.SSECTOR_ID)
								 from   tbATUHandOver as S
								 where  T.SSECTOR_ID =S.SSECTOR_ID	)
								 )
    成功
*/

--根据路测ATU数据表，查询服务小区参考信号接收功率RSRP的均值大于-70的小区
/*
select CellID,avg_rsrp
from   ( select CellID, avg(RSRP) 
		 from   tbATUData
		 group by CellID)
		 as look_up(cellid,avg_rsrp)
where   avg_rsrp> -70;
 */

--根据路测ATU切换统计矩阵表和MRO测量报告数据表，使用with语句找出所有具有最低切换次数的小区的MRO测量信息
/*
with min_hoatt(hoatt) as 
	 ( select min(HOATT)
	   from   tbATUHandOver)
select ServingSector
from   tbMROData 
where  ServingSector in(select SSECTOR_ID
						from   tbATUHandOver
						where  HOATT = hoatt);
*/


--根据小区/基站工参表和一阶邻区关系表，列出频点为38400的所有小区的一阶邻区数目
/*
--采用标量子查询
select( select count(N_SECTOR_ID) 
		from   tbAdjCell
		where  S_SECTOR_ID in
				( select SECTOR_ID 
				  from   tbCell
				  where  EARFCN =38400)
		) as num1
--普通直接查询
select count(N_SECTOR_ID) as num2
	   from   tbAdjCell
		where S_EARFCN = 38400

*/


--根据小区/基站工参表和小区切换统计性能表，
--查询具有  最多二阶邻区数的小区的
--  最大切换成功次数、相应的切换目标小区ID、尝试切换次数

/*
select HOSUCC,SCELL, HOATT
from   tbHandOver
where  HOSUCC IN( select max(HOSUCC)
				  from   tbHandOver
				  where	 SCELL in ( select S_SECTOR_ID 
									from   tbSecAdjCell
									group  by S_SECTOR_ID
									HAVING COUNT(N_SECTOR_ID) >=all( select count(N_SECTOR_ID)
																     from   tbSecAdjCell
																     group by S_SECTOR_ID 
																    )
									)
				)
*/

--根据路测ATU切换统计矩阵表和小区切换统计性能表，删除
--切换次数 均值小于3的小区切换性能统计数据
--删除前记得测试
/*
delete from  tbHandOver
where  SCELL IN (
					select SSECTOR_ID
					from   tbATUHandOver
					group by SSECTOR_ID
					having avg(HOATT) < 3
				)	
*/

--向小区/基站工参表中插入一条新信息
/*
insert into tbCell
values (
		'北京',	50000-0,	'北京-HLHF-1',	124672,	'北京-HLHF',	
		38400,	40,	2	,5,1200,	'华为',	100.0000,	30.0000,	
		'宏站',	30,	20,	5,	3,	8)

select *from tbCell
where  CITY = '北京'
*/

--将优化小区/保护带小区表中，小区ID为“246506-3”的小区的小区类型改为“优化区”

/*
update tbOptCell
set    CELL_TYPE = '优化区'
where  SECTOR_ID='246506-3'

select SECTOR_ID,CELL_TYPE
from   tbOptCell
where  SECTOR_ID='246506-3'
*/

--用小区PCI优化调整结果表中“优化调整后的本小区PCI值”，
--替换小区/基站工参表中小区的“物理小区标识”
/*
update tbCell 
set   PCI = case
			when tbCELL.SECTOR_ID IN (select SECTOR_ID
									  from   tbPCIAssignment)
			then ( select PCI
				   from   tbPCIAssignment
				   where  tbCell.SECTOR_ID = tbPCIAssignment.SECTOR_ID)
			else  tbCell.PCI
			end
--用来验证结果
SELECT TOP 10 SECTOR_ID as Assign_id ,PCI
FROM   tbPCIAssignment
ORDER BY SECTOR_ID


SELECT TOP 150 SECTOR_ID as Cell_id ,PCI
FROM   tbCell
ORDER BY SECTOR_ID 
*/

--针对路测ATU C2I干扰矩阵表表，使用case语句作出如下修改：
--如果主小区与干扰小区为同站小区且干扰强度排序不小于1，则干扰强度排序减1；
--如果主小区与干扰小区不为同站，干扰强度排序加1
/*
update tbATUC2I
set RANK = case
		   when COSITE = 1 and RANK>1 then RANK -1
		   when COSITE = 0            then RANK +1
		   
		   end
*/