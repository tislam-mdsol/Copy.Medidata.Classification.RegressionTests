if exists(select top(1)1 from sys.tables where name='_CodingOdmValues')
begin
    drop table _CodingOdmValues;
    print 'DROP TABLE [_CodingOdmValues]';
end
go


create table _CodingOdmValues
(
    k                       int identity,
    CodingRequestId         int not null,

    StudyOID                varchar(50) not null default(''),
    SubjectKey              varchar(50) not null default(''),
    SiteOID                 nvarchar(50) not null default(''),
    StudyEventOID           varchar(100) not null default(''),
    FolderNest              varchar(100) not null default(''),
    FormOID                 varchar(100) not null default(''),
    FormRepeatKey           varchar(100) not null default(''),
    ItemGroupOID            varchar(100) not null default(''),
    recordOrdinal           smallint not null default(0),
    ItemOID                 varchar(100) not null default(''),
    SourceIdentifier        varchar(50) not null,

    uuid                    varchar(40) not null default(''),

    primary key(
        k, CodingRequestId
    ),
    unique(CodingRequestId,
            StudyOID,SubjectKey,SiteOID,StudyEventOID,
            FolderNest,FormOID,FormRepeatKey,
            ItemGroupOID,recordOrdinal,ItemOID)with( ignore_dup_key=on )
);
go