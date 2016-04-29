 /* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2012, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Sneha Saikumar ssaikumar@mdsol.com
// ------------------------------------------------------------------------------------------------------*/

IF  EXISTS (SELECT null FROM sys.objects WHERE TYPE= 'P' and NAME = 'spPSProjectRegistrations')
DROP PROCEDURE dbo.spPSProjectRegistrations
GO
  
CREATE PROCEDURE [dbo].[spPSProjectRegistrations]  
  
@ProjectName NVARCHAR(440),  
@SegmentName NVARCHAR(255)  
  
AS  
BEGIN  
  
 Select   
 SG.SegmentName,  
 SP.ProjectName,  
 STUDY.ExternalObjectName AS 'StudyName',  
 STUDY.ExternalObjectId,  
 D.OID AS 'MedicalDictionary',
 D.MedicalDictionaryType,  
 DV_Curr.OID AS 'Version',  
 DV_Curr.Ordinal,  
 DV_Init.OID AS 'InitialVersion',
 DV_Init.Ordinal AS 'InitialOrdinal',
 SDV.NumberOfMigrations,  
 SDV.Created,
 SDV.Updated  
 from StudyProjects SP  
	 inner join Segments SG on SG.SegmentId = SP.SegmentID   
	 inner join TrackableObjects STUDY on STUDY.StudyProjectId = SP.StudyProjectId  
	 inner join StudyDictionaryVersion SDV on SDV.StudyID = STUDY.TrackableObjectID   
	 inner join DictionaryRef D on D.DictionaryRefID = SDV.MedicalDictionaryID  
	 inner join DictionaryVersionRef DV_Curr on DV_Curr.DictionaryVersionRefID = SDV.DictionaryVersionId
	 inner join DictionaryVersionRef DV_Init on DV_Init.DictionaryVersionRefID = SDV.InitialDictionaryVersionId
 where SP.ProjectName = @ProjectName and SG.SegmentName = @SegmentName   
   
END  

