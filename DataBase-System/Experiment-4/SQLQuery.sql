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
where   SECTOR_NAME like '%����Ͽ%'; 
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

-- ʹ��between����ѯ
--	����λ��111��112֮�䡢γ��λ��34.7��34.9֮���С��
--		��C2I���ŵľ�ֵ����
--			��С��ID
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

--ʹ��union����в�ѯ��������Ϊ������Ƶ��Ϊ38544��
-- ����������Ϊ����Ͽ��Ƶ��Ϊ38400��С��
select SECTOR_ID
 from   dbo.tbCell
 where  CITY = '����' 
 union  
select SECTOR_ID
 from   dbo.tbCell
 where  CITY = '����Ͽ' and EARFCN = 385400;						
/*

*/
/*

*/	

/*

*/	

/*

*/	

