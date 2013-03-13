'
' Unit tests for a generic log writer
'
Type TLogWriterTests Extends TTest

	Field logger:TLoggerMock
	Field logWriter:TLogWriterMock

	Field logLevels:Int[]


	Method Setup() {before}
		logger = TLoggerMock.GetInstance()

		logWriter = new TLogWriterMock
		logger.AddWriter (logWriter)

		logLevels = new Int[8]
		logLevels[0] = LOGGER_EMERGENCY
		logLevels[1] = LOGGER_ALERT
		logLevels[2] = LOGGER_CRITICAL
		logLevels[3] = LOGGER_ERROR
		logLevels[4] = LOGGER_WARNING
		logLevels[5] = LOGGER_NOTICE
		logLevels[6] = LOGGER_INFO
		logLevels[7] = LOGGER_DEBUG
	End Method



	Method Breakdown() {after}
		logger.Close()
		logger = Null
	End Method



	' Send test messages at all possible severity levels
	Method SendTestMessages()
		For Local logLevel:Int = EachIn logLevels
			For Local j:Int = 1 To 10
				logger.LogMessage (logLevel, "Severity " + logLevel + " level message " + j + "/10")
			Next
		Next
	End Method



	Method CanSetValidLogLevels() {test}
		for local i:Int = 0 to 7
			logWriter.setLevel (i)
			assertEqualsI (i, logWriter.getLevel())
		next
	End Method



	Method CannotSetInvalidLogLevels() {test}
		local currentLevel:Int = logWriter.getLevel()

		logWriter.setLevel (-1)
		assertEqualsI (currentLevel, logWriter.getLevel())

		logWriter.setLevel (8)
		assertEqualsI (currentLevel, logWriter.getLevel())
	End Method



	Method WriterReceivesCorrectNumberOfMessagesAtLevelEmergency() {test}
		logWriter.setLevel (LOGGER_EMERGENCY)
		sendTestMessages()
		assertEqualsI (10, logWriter.nMessagesReceived)
	End Method



	Method WriterReceivesCorrectNumberOfMessagesAtLevelAlert() {test}
		logWriter.setLevel (LOGGER_ALERT)
		sendTestMessages()
		assertEqualsI (20, logWriter.nMessagesReceived)
	End Method



	Method WriterReceivesCorrectNumberOfMessagesAtLevelCritical() {test}
		logWriter.setLevel (LOGGER_CRITICAL)
		sendTestMessages()
		assertEqualsI (30, logWriter.nMessagesReceived)
	End Method



	Method WriterReceivesCorrectNumberOfMessagesAtLevelError() {test}
		logWriter.setLevel (LOGGER_ERROR)
		sendTestMessages()
		assertEqualsI (40, logWriter.nMessagesReceived)
	End Method



	Method WriterReceivesCorrectNumberOfMessagesAtLevelWarning() {test}
		logWriter.setLevel (LOGGER_WARNING)
		sendTestMessages()
		assertEqualsI (50, logWriter.nMessagesReceived)
	End Method



	Method WriterReceivesCorrectNumberOfMessagesAtLevelNotice() {test}
		logWriter.setLevel (LOGGER_NOTICE)
		sendTestMessages()
		assertEqualsI (60, logWriter.nMessagesReceived)
	End Method



	Method WriterReceivesCorrectNumberOfMessagesAtLevelInfo() {test}
		logWriter.setLevel (LOGGER_INFO)
		sendTestMessages()
		assertEqualsI (70, logWriter.nMessagesReceived)
	End Method



	Method WriterReceivesCorrectNumberOfMessagesAtLevelDebug() {test}
		logWriter.setLevel (LOGGER_DEBUG)
		sendTestMessages()
		assertEqualsI (80, logWriter.nMessagesReceived)
	End Method

End Type
