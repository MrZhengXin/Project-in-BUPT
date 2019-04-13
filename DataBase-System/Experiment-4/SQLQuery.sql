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
where   SECTOR_NAME like '%ÈýÃÅÏ¿%'; 
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
		

/*

*/	

/*

*/	

/*

*/	

