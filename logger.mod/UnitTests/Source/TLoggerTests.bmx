Type TLoggerTests Extends TTest

	Field logger:TLogger


	Method Setup() {before}
		logger = TLogger.GetInstance()
	End Method



	Method Breakdown() {after}
		logger.Close()
		logger = Null
	End Method



	Method CanGetLoggerInstance() {test}
		assertNotNull (logger)
	End Method



	Method CanAddWriter() {test}
		Local nWriters:Int = logger.GetLogWriters().Count()
		assertEqualsI (0, nWriters)

		logger.AddWriter (New TLogWriterMock)
		assertEqualsI (1, logger.GetLogWriters().Count())
	End Method



	Method WritersRemovedOnClose() {test}
		logger.AddWriter (New TLogWriterMock)
		logger.AddWriter (New TLogWriterMock)
		logger.AddWriter (New TLogWriterMock)
		logger.AddWriter (New TLogWriterMock)

		Local nWriters:Int = logger.GetLogWriters().Count()
		assertEqualsI (4, logger.GetLogWriters().Count())

		logger.Close()
		assertEqualsI (0, logger.GetLogWriters().Count())
	End Method

End Type
