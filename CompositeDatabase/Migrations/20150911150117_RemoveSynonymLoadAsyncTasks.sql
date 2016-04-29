DECLARE @synonymLongAsyncTaskType INT = 4

DELETE LATH
FROM LongAsyncTaskHistory LATH
	JOIN LongAsyncTasks LAT
		ON LATH.TaskId = LAT.TaskId
WHERE LAT.LongAsyncTaskType = @synonymLongAsyncTaskType

DELETE LongAsyncTasks
WHERE LongAsyncTaskType = @synonymLongAsyncTaskType
