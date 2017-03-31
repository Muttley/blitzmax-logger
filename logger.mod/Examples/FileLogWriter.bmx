SuperStrict

Framework muttley.logger

Local fileWriter:TFileLogWriter = New TFileLogWriter

fileWriter.SetLevel    (LOGGER_DEBUG)
fileWriter.SetFilename ("data/FileLogWriter-results.log")

Local logger:TLogger = TLogger.GetInstance()
logger.AddWriter (fileWriter)

logger.LogInfo  ("[ConsoleLogWriter] An example Info log message")
logger.LogError ("[ConsoleLogWriter] An example Error log message")

logger.Close()
