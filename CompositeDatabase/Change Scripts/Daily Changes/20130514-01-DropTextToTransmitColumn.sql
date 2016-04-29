IF EXISTS (SELECT NULL FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_NAME = 'TransmissionQueueItems'
   AND COLUMN_NAME = 'TextToTransmit')
BEGIN 
--Drop the TextToTransmit Column
ALTER TABLE TransmissionQueueItems
DROP COLUMN TextToTransmit

END