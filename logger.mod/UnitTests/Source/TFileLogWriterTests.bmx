'This BMX file was edited with BLIde ( http://www.blide.org )
Rem
	bbdoc:Undocumented type
End Rem
Type TFileLogWriterTests Extends TTest

	Field logger:TLoggerMock
	Field logWriter:TFileLogWriter

	Field logLevels:Int[]

	Method Setup() {before}
		logger = TLoggerMock.GetInstance()

		logWriter = New TFileLogWriter
		logger.AddWriter (logWriter)

		logLevels = New Int[8]
		logLevels[0] = LOGGER_EMERGENCY
		logLevels[1] = LOGGER_ALERT
		logLevels[2] = LOGGER_CRITICAL
		logLevels[3] = LOGGER_ERROR
		logLevels[4] = LOGGER_WARNING
		logLevels[5] = LOGGER_NOTICE
		logLevels[6] = LOGGER_INFO
		logLevels[7] = LOGGER_DEBUG
	EndMethod

	Method Breakdown() {after}
		logger.Close()
		logger = Null
	EndMethod

	' Test that the specified files are identical
	Method AreFilesIdentical:Int (file1:String, file2:String)
		Local testFile:TStream    = ReadFile (file1)
		Local compareFile:TStream = ReadFile (file2)

		' Unable to open one of the files
		If (Not testFile) Or (Not compareFile) Then Return False

		' Files are not the same size
		If compareFile.Size() <> testFile.Size() Then Return False

		While Not testFile.Eof()
			Local line1:String = testFile.ReadLine()

			' make sure the compare file still has data left as well
			If compareFile.Eof()
				Return False
			Else
				' make sure the lines are identical
				If line1 <> compareFile.ReadLine() Then Return False
			EndIf
		Wend

		' make sure the compare file doesn't have any data left
		If Not compareFile.Eof() Then Return False

		Return True
	EndMethod

	' Send test messages at all possible severity levels
	Method SendTestMessages()
		For Local logLevel:Int = EachIn logLevels
			For Local j:Int = 1 To 10
				logger.LogMessage (logLevel, "Severity " + logLevel + " level message " + j + "/10")
			Next
		Next
	EndMethod

	Method DifferentFilesAreNotIdentical() {test}
		assertFalse (AreFilesIdentical ("data/test-log0.log", "data/test-log1.log"))
	EndMethod

	Method SameFilesAreIdentical() {test}
		AssertTrue (AreFilesIdentical ("data/test-log7.log", "data/test-log7.log"))
	EndMethod

	Method LogFileContainsExpectedDataAtLogLevelEmergency() {test}
		Local filename:String = "data/test-log0-results.log"

		logWriter.SetFilename  (filename)
		logWriter.ShowSeverity (True)
		logWriter.SetOverwrite (True)
		logWriter.SetLevel (LOGGER_EMERGENCY)

		sendTestMessages()
		logger.Close()

		AssertTrue (AreFilesIdentical (filename, "data/test-log0.log"))
	EndMethod

	Method LogFileContainsExpectedDataAtLogLevelAlert() {test}
		Local filename:String = "data/test-log1-results.log"
		logWriter.SetFilename  (filename)
		logWriter.ShowSeverity (True)
		logWriter.SetOverwrite (True)
		logWriter.SetLevel (LOGGER_ALERT)

		sendTestMessages()
		logger.Close()

		AssertTrue (AreFilesIdentical (filename, "data/test-log1.log"))
	EndMethod

	Method LogFileContainsExpectedDataAtLogLevelCritical() {test}
		Local filename:String = "data/test-log2-results.log"
		logWriter.SetFilename  (filename)
		logWriter.ShowSeverity (True)
		logWriter.SetOverwrite (True)
		logWriter.SetLevel (LOGGER_CRITICAL)

		sendTestMessages()
		logger.Close()

		AssertTrue (AreFilesIdentical (filename, "data/test-log2.log"))
	EndMethod

	Method LogFileContainsExpectedDataAtLogLevelError() {test}
		Local filename:String = "data/test-log3-results.log"
		logWriter.SetFilename  (filename)
		logWriter.ShowSeverity (True)
		logWriter.SetOverwrite (True)
		logWriter.SetLevel (LOGGER_ERROR)

		sendTestMessages()
		logger.Close()

		AssertTrue (AreFilesIdentical (filename, "data/test-log3.log"))
	EndMethod

	Method LogFileContainsExpectedDataAtLogLevelWarning() {test}
		Local filename:String = "data/test-log4-results.log"
		logWriter.SetFilename  (filename)
		logWriter.ShowSeverity (True)
		logWriter.SetOverwrite (True)
		logWriter.SetLevel (LOGGER_WARNING)

		sendTestMessages()
		logger.Close()

		AssertTrue (AreFilesIdentical (filename, "data/test-log4.log"))
	EndMethod

	Method LogFileContainsExpectedDataAtLogLevelNotice() {test}
		Local filename:String = "data/test-log5-results.log"
		logWriter.SetFilename  (filename)
		logWriter.ShowSeverity (True)
		logWriter.SetOverwrite (True)
		logWriter.SetLevel (LOGGER_NOTICE)

		sendTestMessages()
		logger.Close()

		AssertTrue (AreFilesIdentical (filename, "data/test-log5.log"))
	EndMethod

	Method LogFileContainsExpectedDataAtLogLevelInfo() {test}
		Local filename:String = "data/test-log6-results.log"
		logWriter.SetFilename  (filename)
		logWriter.ShowSeverity (True)
		logWriter.SetOverwrite (True)
		logWriter.SetLevel (LOGGER_INFO)

		sendTestMessages()
		logger.Close()

		AssertTrue (AreFilesIdentical (filename, "data/test-log6.log"))
	EndMethod

	Method LogFileContainsExpectedDataAtLogLevelDebug() {test}
		Local filename:String = "data/test-log7-results.log"
		logWriter.SetFilename  (filename)
		logWriter.ShowSeverity (True)
		logWriter.SetOverwrite (True)
		logWriter.SetLevel (LOGGER_DEBUG)

		sendTestMessages()
		logger.Close()

		AssertTrue (AreFilesIdentical (filename, "data/test-log7.log"))
	EndMethod

EndType
