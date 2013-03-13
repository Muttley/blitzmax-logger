SuperStrict

Import muttley.logger
Import bah.maxunit

Include "Source\TFileLogWriterTests.bmx"
Include "Source\TLoggerMock.bmx"
Include "Source\TLoggerTests.bmx"
Include "Source\TLogWriterMock.bmx"
Include "Source\TLogWriterTests.bmx"

exit_ (New TTestSuite.run())
