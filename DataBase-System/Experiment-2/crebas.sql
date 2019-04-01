/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2012                    */
/* Created on:     2019/4/1 10:43:22                            */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ATUC2I') and o.name = 'FK_ATUC2I_NCELL_ID_ATUDATA')
alter table ATUC2I
   drop constraint FK_ATUC2I_NCELL_ID_ATUDATA
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ATUC2I') and o.name = 'FK_ATUC2I_SECTOR_ID_CELL')
alter table ATUC2I
   drop constraint FK_ATUC2I_SECTOR_ID_CELL
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ATUHandOver') and o.name = 'FK_ATUHANDO_NESECTOR__ATUDATA')
alter table ATUHandOver
   drop constraint FK_ATUHANDO_NESECTOR__ATUDATA
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ATUHandOver') and o.name = 'FK_ATUHANDO_SSECTOR_I_CELL')
alter table ATUHandOver
   drop constraint FK_ATUHANDO_SSECTOR_I_CELL
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('AdjCell') and o.name = 'FK_ADJCELL_N_SECTOR_CELL')
alter table AdjCell
   drop constraint FK_ADJCELL_N_SECTOR_CELL
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('AdjCell') and o.name = 'FK_ADJCELL_S_SECTOR_CELL')
alter table AdjCell
   drop constraint FK_ADJCELL_S_SECTOR_CELL
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('C2I') and o.name = 'FK_C2I_NCELL_CELL')
alter table C2I
   drop constraint FK_C2I_NCELL_CELL
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('C2I') and o.name = 'FK_C2I_SCELL_MRODATA')
alter table C2I
   drop constraint FK_C2I_SCELL_MRODATA
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Cell') and o.name = 'FK_CELL_SECTOR-EN_ENODEB')
alter table Cell
   drop constraint "FK_CELL_SECTOR-EN_ENODEB"
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('HandOver') and o.name = 'FK_HANDOVER_NCELL2_CELL')
alter table HandOver
   drop constraint FK_HANDOVER_NCELL2_CELL
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('HandOver') and o.name = 'FK_HANDOVER_SCELL2_CELL')
alter table HandOver
   drop constraint FK_HANDOVER_SCELL2_CELL
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('SecAdjCell') and o.name = 'FK_SECADJCE_N-SECTOR_CELL')
alter table SecAdjCell
   drop constraint "FK_SECADJCE_N-SECTOR_CELL"
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('SecAdjCell') and o.name = 'FK_SECADJCE_S-SECTOR_CELL')
alter table SecAdjCell
   drop constraint "FK_SECADJCE_S-SECTOR_CELL"
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ATUC2I')
            and   name  = 'NCELL_ID_FK'
            and   indid > 0
            and   indid < 255)
   drop index ATUC2I.NCELL_ID_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ATUC2I')
            and   name  = 'SECTOR_ID_FK'
            and   indid > 0
            and   indid < 255)
   drop index ATUC2I.SECTOR_ID_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ATUC2I')
            and   type = 'U')
   drop table ATUC2I
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ATUData')
            and   type = 'U')
   drop table ATUData
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ATUHandOver')
            and   name  = 'SSECTOR_ID_FK'
            and   indid > 0
            and   indid < 255)
   drop index ATUHandOver.SSECTOR_ID_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ATUHandOver')
            and   name  = 'NESECTOR_ID_FK'
            and   indid > 0
            and   indid < 255)
   drop index ATUHandOver.NESECTOR_ID_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ATUHandOver')
            and   type = 'U')
   drop table ATUHandOver
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('AdjCell')
            and   name  = 'S_SECTOR_FK'
            and   indid > 0
            and   indid < 255)
   drop index AdjCell.S_SECTOR_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('AdjCell')
            and   name  = 'N_SECTOR_FK'
            and   indid > 0
            and   indid < 255)
   drop index AdjCell.N_SECTOR_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('AdjCell')
            and   type = 'U')
   drop table AdjCell
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('C2I')
            and   name  = 'NCELL_FK'
            and   indid > 0
            and   indid < 255)
   drop index C2I.NCELL_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('C2I')
            and   name  = 'SCELL_FK'
            and   indid > 0
            and   indid < 255)
   drop index C2I.SCELL_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('C2I')
            and   type = 'U')
   drop table C2I
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('Cell')
            and   name  = 'SECTOR-ENODEB_FK'
            and   indid > 0
            and   indid < 255)
   drop index Cell."SECTOR-ENODEB_FK"
go

if exists (select 1
            from  sysobjects
           where  id = object_id('Cell')
            and   type = 'U')
   drop table Cell
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ENODEB')
            and   type = 'U')
   drop table ENODEB
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('HandOver')
            and   name  = 'NCELL2_FK'
            and   indid > 0
            and   indid < 255)
   drop index HandOver.NCELL2_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('HandOver')
            and   name  = 'SCELL2_FK'
            and   indid > 0
            and   indid < 255)
   drop index HandOver.SCELL2_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('HandOver')
            and   type = 'U')
   drop table HandOver
go

if exists (select 1
            from  sysobjects
           where  id = object_id('MROData')
            and   type = 'U')
   drop table MROData
go

if exists (select 1
            from  sysobjects
           where  id = object_id('OptCell')
            and   type = 'U')
   drop table OptCell
go

if exists (select 1
            from  sysobjects
           where  id = object_id('PCIAssignment')
            and   type = 'U')
   drop table PCIAssignment
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('SecAdjCell')
            and   name  = 'S-SECTOR_FK'
            and   indid > 0
            and   indid < 255)
   drop index SecAdjCell."S-SECTOR_FK"
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('SecAdjCell')
            and   name  = 'N-SECTOR_FK'
            and   indid > 0
            and   indid < 255)
   drop index SecAdjCell."N-SECTOR_FK"
go

if exists (select 1
            from  sysobjects
           where  id = object_id('SecAdjCell')
            and   type = 'U')
   drop table SecAdjCell
go

/*==============================================================*/
/* Table: ATUC2I                                                */
/*==============================================================*/
create table ATUC2I (
   SECTOR_ID            nvarchar(50)         not null,
   FileName             varchar(255)         not null,
   seq                  bigint               not null,
   RATIO_ALL            float                null,
   RANK                 int                  null,
   COSITE               tinyint              null,
   constraint PK_ATUC2I primary key (SECTOR_ID, FileName, seq)
)
go

/*==============================================================*/
/* Index: SECTOR_ID_FK                                          */
/*==============================================================*/
create index SECTOR_ID_FK on ATUC2I (
SECTOR_ID ASC
)
go

/*==============================================================*/
/* Index: NCELL_ID_FK                                           */
/*==============================================================*/
create index NCELL_ID_FK on ATUC2I (
FileName ASC,
seq ASC
)
go

/*==============================================================*/
/* Table: ATUData                                               */
/*==============================================================*/
create table ATUData (
   seq                  bigint               not null,
   FileName             varchar(255)         not null,
   Time                 varchar(100)         null,
   Longitude            float                null,
   Latitude             float                null,
   CellID               varchar(50)          null,
   TAC                  int                  null,
   EARFCN               int                  null,
   PCI                  smallint             null,
   RSRP                 float                null,
   RS_SINR              float                null,
   NCell_ID_1           varchar(50)          null,
   NCell_EARFCN_1       int                  null,
   NCell_PCI_1          smallint             null,
   NCell_RSRP_1         float                null,
   NCell_ID_2           varchar(50)          null,
   NCell_EARFCN_2       int                  null,
   NCell_PCI_2          smallint             null,
   NCell_RSRP_2         float                null,
   NCell_ID_3           varchar(50)          null,
   NCell_EARFCN_3       int                  null,
   NCell_PCI_3          smallint             null,
   NCell_RSRP_3         float                null,
   NCell_ID_4           varchar(50)          null,
   NCell_EARFCN_4       int                  null,
   NCell_PCI_4          smallint             null,
   NCell_RSRP_4         float                null,
   NCell_ID_5           varchar(50)          null,
   NCell_EARFCN_5       int                  null,
   NCell_PCI_5          smallint             null,
   NCell_RSRP_5         float                null,
   NCell_ID_6           varchar(50)          null,
   NCell_EARFCN_6       int                  null,
   NCell_PCI_6          smallint             null,
   NCell_RSRP_6         float                null,
   constraint PK_ATUDATA primary key nonclustered (FileName, seq)
)
go

/*==============================================================*/
/* Table: ATUHandOver                                           */
/*==============================================================*/
create table ATUHandOver (
   FileName             varchar(255)         not null,
   seq                  bigint               not null,
   SECTOR_ID            nvarchar(50)         not null,
   HOATT                int                  null,
   constraint PK_ATUHANDOVER primary key (FileName, seq, SECTOR_ID)
)
go

/*==============================================================*/
/* Index: NESECTOR_ID_FK                                        */
/*==============================================================*/
create index NESECTOR_ID_FK on ATUHandOver (
FileName ASC,
seq ASC
)
go

/*==============================================================*/
/* Index: SSECTOR_ID_FK                                         */
/*==============================================================*/
create index SSECTOR_ID_FK on ATUHandOver (
SECTOR_ID ASC
)
go

/*==============================================================*/
/* Table: AdjCell                                               */
/*==============================================================*/
create table AdjCell (
   Cel_SECTOR_ID        nvarchar(50)         not null,
   SECTOR_ID            nvarchar(50)         not null,
   S_EARFEN             int                  null,
   N_EARFEN             int                  null,
   constraint PK_ADJCELL primary key (Cel_SECTOR_ID, SECTOR_ID)
)
go

/*==============================================================*/
/* Index: N_SECTOR_FK                                           */
/*==============================================================*/
create index N_SECTOR_FK on AdjCell (
Cel_SECTOR_ID ASC
)
go

/*==============================================================*/
/* Index: S_SECTOR_FK                                           */
/*==============================================================*/
create index S_SECTOR_FK on AdjCell (
SECTOR_ID ASC
)
go

/*==============================================================*/
/* Table: C2I                                                   */
/*==============================================================*/
create table C2I (
   TimeStamp            varchar(30)          not null,
   SercingSector        varchar(50)          not null,
   InterferingSector    varchar(50)          not null,
   SECTOR_ID            nvarchar(50)         not null,
   PrC2I9               float                null,
   C2I_Mean             float                null,
   Std                  float                null,
   SampleCount          float                null,
   WeightedC2I          float                null,
   constraint PK_C2I primary key (TimeStamp, SercingSector, InterferingSector, SECTOR_ID)
)
go

/*==============================================================*/
/* Index: SCELL_FK                                              */
/*==============================================================*/
create index SCELL_FK on C2I (
TimeStamp ASC,
SercingSector ASC,
InterferingSector ASC
)
go

/*==============================================================*/
/* Index: NCELL_FK                                              */
/*==============================================================*/
create index NCELL_FK on C2I (
SECTOR_ID ASC
)
go

/*==============================================================*/
/* Table: Cell                                                  */
/*==============================================================*/
create table Cell (
   CITY                 nvarchar(255)        null,
   SECTOR_ID            nvarchar(50)         not null,
   ENODEBID             int                  not null,
   SECTOR_NAME          varchar(255)         not null,
   EARFN                int                  not null
      constraint CKC_EARFN_CELL check (EARFN in (39148,38908,37900,38400,38950)),
   PCI                  int                  null
      constraint CKC_PCI_CELL check (PCI is null ),
   PSS                  int                  null
      constraint CKC_PSS_CELL check (PSS is null or (PSS in (0,1,2))),
   SSS                  int                  null
      constraint CKC_SSS_CELL check (SSS is null or (SSS between 0 and 167)),
   TAC                  int                  null,
   AZIMUTH              float                not null,
   HEIGHT               float                null,
   ELECTTILT            float                null,
   MECHTILT             float                null,
   TOTLETILT            float                not null,
   constraint PK_CELL primary key nonclustered (SECTOR_ID)
)
go

/*==============================================================*/
/* Index: "SECTOR-ENODEB_FK"                                    */
/*==============================================================*/
create index "SECTOR-ENODEB_FK" on Cell (
ENODEBID ASC
)
go

/*==============================================================*/
/* Table: ENODEB                                                */
/*==============================================================*/
create table ENODEB (
   CITY                 nvarchar(255)        null,
   ENODEBID             int                  not null,
   ENODEB_NAME          varchar(255)         not null,
   VENDOR               varchar(255)         null
      constraint CKC_VENDOR_ENODEB check (VENDOR is null or (VENDOR in ('华为','中兴','诺西','爱立信','贝尔','大唐'))),
   LONGITUDE            float                not null,
   LATITUDE             float                not null,
   STYLE                varchar(255)         null
      constraint CKC_STYLE_ENODEB check (STYLE is null or (STYLE in ('宏站','室内','室外'))),
   constraint PK_ENODEB primary key nonclustered (ENODEBID)
)
go

/*==============================================================*/
/* Table: HandOver                                              */
/*==============================================================*/
create table HandOver (
   Cel_SECTOR_ID        nvarchar(50)         not null,
   SECTOR_ID            nvarchar(50)         not null,
   HOATT                int                  null,
   HOSUCC               int                  null,
   HOSUCCRATE           float                null,
   constraint PK_HANDOVER primary key (Cel_SECTOR_ID, SECTOR_ID)
)
go

/*==============================================================*/
/* Index: SCELL2_FK                                             */
/*==============================================================*/
create index SCELL2_FK on HandOver (
Cel_SECTOR_ID ASC
)
go

/*==============================================================*/
/* Index: NCELL2_FK                                             */
/*==============================================================*/
create index NCELL2_FK on HandOver (
SECTOR_ID ASC
)
go

/*==============================================================*/
/* Table: MROData                                               */
/*==============================================================*/
create table MROData (
   TimeStamp            varchar(30)          not null,
   SercingSector        varchar(50)          not null,
   InterferingSector    varchar(50)          not null,
   LteScRSRP            float                null,
   LteNcRSRP            float                null,
   LteNcEarfcn          int                  null,
   LteNcPci             smallint             null,
   constraint PK_MRODATA primary key nonclustered (TimeStamp, SercingSector, InterferingSector)
)
go

/*==============================================================*/
/* Table: OptCell                                               */
/*==============================================================*/
create table OptCell (
   SECTOR_ID            varchar(50)          not null,
   EARFCN               int                  null
      constraint CKC_EARFCN_OPTCELL check (EARFCN is null or (EARFCN in (38400,39098,37400))),
   CALL_TYPE            varchar(50)          null
      constraint CKC_CALL_TYPE_OPTCELL check (CALL_TYPE is null or (CALL_TYPE in ('优化区','保护带'))),
   constraint PK_OPTCELL primary key nonclustered (SECTOR_ID)
)
go

/*==============================================================*/
/* Table: PCIAssignment                                         */
/*==============================================================*/
create table PCIAssignment (
   ASSIGN_ID            smallint             not null,
   EARFCN               int                  null
      constraint CKC_EARFCN_PCIASSIG check (EARFCN is null or (EARFCN in (37900,38908,38400))),
   SECTOR_ID            varchar(50)          not null,
   SECTOR_NAME          varchar(200)         null,
   ENODEB               int                  null,
   PCI                  int                  null,
   PSS                  int                  null,
   SSS                  int                  null,
   LONGITUDE            float                null,
   LATITUDE             float                null,
   STYLE                varchar(50)          null
      constraint CKC_STYLE_PCIASSIG check (STYLE is null or (STYLE in ('宏站','室内','室外'))),
   OPT_DATETIME         datetime             null,
   constraint PK_PCIASSIGNMENT primary key nonclustered (ASSIGN_ID, SECTOR_ID)
)
go

/*==============================================================*/
/* Table: SecAdjCell                                            */
/*==============================================================*/
create table SecAdjCell (
   SECTOR_ID            nvarchar(50)         not null,
   Cel_SECTOR_ID        nvarchar(50)         not null,
   constraint PK_SECADJCELL primary key (SECTOR_ID, Cel_SECTOR_ID)
)
go

/*==============================================================*/
/* Index: "N-SECTOR_FK"                                         */
/*==============================================================*/
create index "N-SECTOR_FK" on SecAdjCell (
SECTOR_ID ASC
)
go

/*==============================================================*/
/* Index: "S-SECTOR_FK"                                         */
/*==============================================================*/
create index "S-SECTOR_FK" on SecAdjCell (
Cel_SECTOR_ID ASC
)
go

alter table ATUC2I
   add constraint FK_ATUC2I_NCELL_ID_ATUDATA foreign key (FileName, seq)
      references ATUData (FileName, seq)
go

alter table ATUC2I
   add constraint FK_ATUC2I_SECTOR_ID_CELL foreign key (SECTOR_ID)
      references Cell (SECTOR_ID)
go

alter table ATUHandOver
   add constraint FK_ATUHANDO_NESECTOR__ATUDATA foreign key (FileName, seq)
      references ATUData (FileName, seq)
go

alter table ATUHandOver
   add constraint FK_ATUHANDO_SSECTOR_I_CELL foreign key (SECTOR_ID)
      references Cell (SECTOR_ID)
go

alter table AdjCell
   add constraint FK_ADJCELL_N_SECTOR_CELL foreign key (Cel_SECTOR_ID)
      references Cell (SECTOR_ID)
go

alter table AdjCell
   add constraint FK_ADJCELL_S_SECTOR_CELL foreign key (SECTOR_ID)
      references Cell (SECTOR_ID)
go

alter table C2I
   add constraint FK_C2I_NCELL_CELL foreign key (SECTOR_ID)
      references Cell (SECTOR_ID)
go

alter table C2I
   add constraint FK_C2I_SCELL_MRODATA foreign key (TimeStamp, SercingSector, InterferingSector)
      references MROData (TimeStamp, SercingSector, InterferingSector)
go

alter table Cell
   add constraint "FK_CELL_SECTOR-EN_ENODEB" foreign key (ENODEBID)
      references ENODEB (ENODEBID)
go

alter table HandOver
   add constraint FK_HANDOVER_NCELL2_CELL foreign key (SECTOR_ID)
      references Cell (SECTOR_ID)
go

alter table HandOver
   add constraint FK_HANDOVER_SCELL2_CELL foreign key (Cel_SECTOR_ID)
      references Cell (SECTOR_ID)
go

alter table SecAdjCell
   add constraint "FK_SECADJCE_N-SECTOR_CELL" foreign key (SECTOR_ID)
      references Cell (SECTOR_ID)
go

alter table SecAdjCell
   add constraint "FK_SECADJCE_S-SECTOR_CELL" foreign key (Cel_SECTOR_ID)
      references Cell (SECTOR_ID)
go

