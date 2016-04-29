/* ------------------------------------------------------------------------------------------------------
// Copyright(c) 2011, Medidata Solutions, Inc., All Rights Reserved.
//
// This is PROPRIETARY SOURCE CODE of Medidata Solutions Worldwide. The contents of 
// this file may not be disclosed to third parties, copied or duplicated in 
// any form, in whole or in part, without the prior written permission of
// Medidata Solutions Worldwide.
//
// Author: Altin Vardhami avardhami@mdsol.com 
// (patterned after spCodingElementSearchForUnload by Steve Myers smyers@mdsol.com)
// ------------------------------------------------------------------------------------------------------*/

--declare @cnt bigint
--exec spCodingElementSearchForUnloadToQueue 12, 487, '', 59, @cnt output

-- REMOVED BY CONNOR ON 2014/03/07


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spCodingElementSearchForUnloadToQueue')
	DROP PROCEDURE spCodingElementSearchForUnloadToQueue
GO