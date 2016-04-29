IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowTaskInsert')
	DROP PROCEDURE spWorkflowTaskInsert 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowTaskUpdate')
	DROP PROCEDURE spWorkflowTaskUpdate 
	
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowTaskLoadAll')
	DROP PROCEDURE spWorkflowTaskLoadAll 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowTaskLoadByWorkflowState')
	DROP PROCEDURE spWorkflowTaskLoadByWorkflowState 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowTaskLoadByWorkflow')
	DROP PROCEDURE spWorkflowTaskLoadByWorkflow 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementLoadByWorkflow')
	DROP PROCEDURE spCodingElementLoadByWorkflow 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementLoadByWorkflowState')
	DROP PROCEDURE spCodingElementLoadByWorkflowState 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementSearchByFilter')
	DROP PROCEDURE spCodingElementSearchByFilter 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingSourceTermInsert')
	DROP PROCEDURE spCodingSourceTermInsert 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingSourceTermInsertGroup')
	DROP PROCEDURE spCodingSourceTermInsertGroup 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowTasksInsert')
	DROP PROCEDURE spWorkflowTasksInsert 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spWorkflowTasksLoadPending')
	DROP PROCEDURE spWorkflowTasksLoadPending 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementLoadPendingAccessible')
	DROP PROCEDURE spCodingElementLoadPendingAccessible 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementSearchByFilterSecured')
	DROP PROCEDURE spCodingElementSearchByFilterSecured 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementSearchFailedTransmission')
	DROP PROCEDURE spCodingElementSearchFailedTransmission 
