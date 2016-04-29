Declare @NewRegistrationMsgObjectTypeId INT = (SELECT ObjectTypeID FROM ObjectTypeR WHERE ObjectTypeName ='ProjectRegistrationMessage')
Declare @OldRegistrationMsgObjectTypeId INT = (SELECT ObjectTypeID FROM ObjectTypeR WHERE ObjectTypeName ='ProjectRegistrationTransmission')
Update TransmissionQueueItems
SET ObjectTypeID = @NewRegistrationMsgObjectTypeId
WHERE ObjectTypeID = @OldRegistrationMsgObjectTypeId 

Declare @NewCodingRejectionMsgObjectTypeId INT = (SELECT ObjectTypeID FROM ObjectTypeR WHERE ObjectTypeName ='CodingRejectionMessage')
Declare @OldCodingRejectionMsgObjectTypeId INT = (SELECT ObjectTypeID FROM ObjectTypeR WHERE ObjectTypeName ='CodingRejection')
Update TransmissionQueueItems
SET ObjectTypeID = @NewCodingRejectionMsgObjectTypeId
WHERE ObjectTypeID = @OldCodingRejectionMsgObjectTypeId 

Declare @NewCodingDecisionMsgObjectTypeId INT = (SELECT ObjectTypeID FROM ObjectTypeR WHERE ObjectTypeName ='FullCodingDecisionMessage')
Declare @OldCodingDecisionMsgObjectTypeId INT = (SELECT ObjectTypeID FROM ObjectTypeR WHERE ObjectTypeName ='CodingAssignment')
Update TransmissionQueueItems
SET ObjectTypeID = @NewCodingDecisionMsgObjectTypeId
WHERE ObjectTypeID = @OldCodingDecisionMsgObjectTypeId 