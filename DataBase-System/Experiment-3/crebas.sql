/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2012                    */
/* Created on:     2019/4/7 14:35:06                            */
/*==============================================================*/


if exists (select 1
            from  sysobjects
           where  id = object_id('tbcell38400')
            and   type = 'V')
   drop view tbcell38400
go

if exists (select 1
            from  sysobjects
           where  id = object_id('OptCellInfo')
            and   type = 'V')
   drop view OptCellInfo
go

if exists (select 1
            from  sysobjects
           where  id = object_id('MROInfo')
            and   type = 'V')
   drop view MROInfo
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tbATUC2I')
            and   type = 'U')
   drop table tbATUC2I
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tbATUData')
            and   type = 'U')
   drop table tbATUData
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tbATUHandOver')
            and   type = 'U')
   drop table tbATUHandOver
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tbAdjCell')
            and   type = 'U')
   drop table tbAdjCell
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tbC2I')
            and   type = 'U')
   drop table tbC2I
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tbCell')
            and   type = 'U')
   drop table tbCell
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('tbHandOver')
            and   name  = 'N_CELL'
            and   indid > 0
            and   indid < 255)
   drop index tbHandOver.N_CELL
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tbHandOver')
            and   type = 'U')
   drop table tbHandOver
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tbMROData')
            and   type = 'U')
   drop table tbMROData
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tbOptCell')
            and   type = 'U')
   drop table tbOptCell
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tbPCIAssignment')
            and   type = 'U')
   drop table tbPCIAssignment
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tbSecAdjCell')
            and   type = 'U')
   drop table tbSecAdjCell
go

/*==============================================================*/
/* Table: tbATUC2I                                              */
/*==============================================================*/
create table tbATUC2I (
   SECTOR_ID            nvarchar(50)         not null,
   NCELL_ID             nvarchar(50)         not null,
   RATIO_ALL            int                  null,
   RANK                 int                  null,
   COSITE               smallint             null,
   constraint PK_TBATUC2I primary key nonclustered (SECTOR_ID, NCELL_ID)
)
go

/*==============================================================*/
/* Table: tbATUData                                             */
/*==============================================================*/
create table tbATUData (
   seq                  bigint               not null,
   FileName             nvarchar(255)        not null,
   Time                 varchar(100)         null,
   LONGITUDE            float                null,
   LATITUDE             float                null,
   CellID               nvarchar(50)         null,
   TAC                  int                  null,
   EARFCN               int                  null,
   PCI                  smallint             null
      constraint CKC_PCI_TBATUDAT check (PCI is null or (PCI between 0 and 503)),
   RSRP                 float                null,
   RS_SINR              float                null,
   NCell_ID_1           nvarchar(50)         null,
   NCell_EARFCN_1       int                  null,
   NCell_PCI_1          smallint             null,
   NCell_RSRP_1         float                null,
   Ncell_ID_2           nvarchar(50)         null,
   NCell_EARFC_2        int                  null,
   NCell_PCI_2          smallint             null,
   NCell_RSRP_2         float                null,
   NCell_ID_3           nvarchar(50)         null,
   NCell_EARFCN_3       int                  null,
   NCell_PCI_3          smallint             null,
   NCell_RSRP_3         float                null,
   NCell_ID_4           nvarchar(50)         null,
   NCell_EARFCN_4       int                  null,
   NCell_PCI_4          smallint             null,
   NCell_RSRP_4         float                null,
   NCell_ID_5           nvarchar(50)         null,
   NCell_EARFCN_5       int                  null,
   NCell_PCI_5          smallint             null,
   NCell_RSRP_5         float                null,
   NCell_ID_6           nvarchar(50)         null,
   NCell_EARFCN_6       int                  null,
   NCell_PCI_6          smallint             null,
   NCell_RSRP_6         float                null,
   constraint PK_TBATUDATA primary key nonclustered (seq, FileName)
)
go

/*==============================================================*/
/* Table: tbATUHandOver                                         */
/*==============================================================*/
create table tbATUHandOver (
   SSECTOR_ID           nvarchar(50)         null,
   NSECTOR_ID           varchar(50)          null,
   HOATT                int                  null
)
go

/*==============================================================*/
/* Table: tbAdjCell                                             */
/*==============================================================*/
create table tbAdjCell (
   S_SECTOR_ID          nvarchar(50)         not null,
   N_SECTOR_ID          nvarchar(50)         not null,
   S_EARFCN             int                  null,
   N_EARFCN             int                  null,
   constraint PK_TBADJCELL primary key nonclustered (S_SECTOR_ID, N_SECTOR_ID)
)
go

/*==============================================================*/
/* Table: tbC2I                                                 */
/*==============================================================*/
create table tbC2I (
   CITY                 nvarchar(255)        null,
   SCELL                nvarchar(255)        not null,
   NCELL                nvarchar(255)        not null,
   PrC2I9               float                null,
   C2I_Mean             float                null,
   Std                  float                null,
   SampleCount          float                null,
   WeightedC2I          float                null,
   constraint PK_TBC2I primary key nonclustered (SCELL, NCELL)
)
go

/*==============================================================*/
/* Table: tbCell                                                */
/*==============================================================*/
create table tbCell (
   CITY                 nvarchar(255)        null,
   SECTOR_ID            nvarchar(255)         not null,
   SECTOR_NAME          nvarchar(255)        not null,
   ENODEBID             int                  not null,
   ENODEB_NAME          nvarchar(255)        not null,
   EARFCN               int                  not null,
   PCI                  smallint                 null
      constraint CKC_PCI_TBCELL check (PCI is null or (PCI between 0 and 503)),
   PSS                  int                  null
      constraint CKC_PSS_TBCELL check (PSS is null or (PSS between 0 and 2)),
   SSS                  int                  null
      constraint CKC_SSS_TBCELL check (SSS is null or (SSS between 0 and 167)),
   TAC                  int                  null,
   VENDOR               nvarchar(255)        null,
   LONGITUDE            float                not null,
   LATITUDE             float                not null,
   STYLE                nvarchar(255)        null,
   AZIMUTH              float                not null,
   HEIGHT               float                null,
   ELECTTILT            float                null,
   MECHTILT             float                null,
   TOTLETILT            float                not null,
   
      
   constraint PK_TBCELL primary key nonclustered (SECTOR_ID)
)
go

/*==============================================================*/
/* Table: tbHandOver                                            */
/*==============================================================*/
create table tbHandOver (
   CITY                 nvarchar(255)        null,
   SCELL                varchar(50)          null,
   NCELL                varchar(50)          null,
   HOATT                int                  null,
   HOSUCC               int                  null,
   HOSUCCRATE           float                null
)
go

/*==============================================================*/
/* Index: N_CELL                                                */
/*==============================================================*/
create index N_CELL on tbHandOver (
SCELL ASC,
NCELL ASC
)
go

/*==============================================================*/
/* Table: tbMROData                                             */
/*==============================================================*/
create table tbMROData (
   TimeStamp            nvarchar(30)         not null,
   ServingSector        nvarchar(50)         not null,
   InterferingSector    nvarchar(50)         not null,
   LteScRSRP            float                null,
   LteNcRSRP            float                null,
   LteNcEarfcn          int                  null,
   LteNcPci             smallint             null,
   constraint PK_TBMRODATA primary key nonclustered (TimeStamp, ServingSector, InterferingSector)
)
go

/*==============================================================*/
/* Table: tbOptCell                                             */
/*==============================================================*/
create table tbOptCell (
   SECTOR_ID            nvarchar(50)         not null,
   EARFCN               int                  null,
   CELL_TYPE            nvarchar(50)         null,
   constraint PK_TBOPTCELL primary key nonclustered (SECTOR_ID)
)
go

/*==============================================================*/
/* Table: tbPCIAssignment                                       */
/*==============================================================*/
create table tbPCIAssignment (
   ASSIGN_ID            smallint             not null,
   EARFCN               int                  null,
   SECTOR_ID            nvarchar(50)         not null,
   SECTOR_NAME          nvarchar(200)        null,
   ENODEB_ID            int                  null,
   PCI                  smallint             null
      constraint CKC_PCI_TBPCIASS check (PCI is null or (PCI between 0 and 503)),
   PSS                  int                  null
      constraint CKC_PSS_TBPCIASS check (PSS is null or (PSS between 0 and 2)),
   SSS                  int                  null
      constraint CKC_SSS_TBPCIASS check (SSS is null or (SSS between 0 and 167)),
   LONGITUDE            float                null,
   LATITUDE             float                null,
   STYLE                varchar(50)          null,
   OPT_DATETIME         datetime             null,
   constraint PK_TBPCIASSIGNMENT primary key nonclustered (ASSIGN_ID, SECTOR_ID)
)
go

/*==============================================================*/
/* Table: tbSecAdjCell                                          */
/*==============================================================*/
create table tbSecAdjCell (
   S_SECTOR_ID          varchar(50)          not null,
   N_SECTOR_ID          varchar(50)          not null,
   constraint PK_TBSECADJCELL primary key nonclustered (S_SECTOR_ID, N_SECTOR_ID)
)
go

/*==============================================================*/
/* View: MROInfo                                                */
/*==============================================================*/
create view MROInfo as
    select ServingSector,InterferingSector,LteScRSRP 
        from tbMROData
            where LteScRSRP<40
go

/*==============================================================*/
/* View: OptCellInfo                                            */
/*==============================================================*/
create view OptCellInfo as
select SECTOR_ID,CELL_TYPE,C2I_Mean,tbC2I.NCELL as tbC2I_NCELL,tbHandOver.NCELL as tbHandOver_NCELL,HOSUCCRATE
from tbOptCell,tbC2I,tbHandOver
    where CELL_TYPE = 'ÓÅ»¯Çø'
go

/*==============================================================*/
/* View: tbcell38400                                            */
/*==============================================================*/
create view tbcell38400 as
select  SECTOR_ID,ENODEBID ,EARFCN,PCI,LONGITUDE,LATITUDE,STYLE
from tbCell
    where EARFCN =38400
go

