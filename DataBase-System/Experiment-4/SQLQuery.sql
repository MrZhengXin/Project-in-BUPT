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
select SECTOR_ID
 from   dbo.tbCell
 where  CITY = '宜阳' 
 union  
select SECTOR_ID
 from   dbo.tbCell
 where  CITY = '三门峡' and EARFCN = 385400;						
/*

*/
/*

*/	

/*

*/	

/*

*/	

