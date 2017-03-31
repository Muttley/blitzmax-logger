Rem
	bbdoc: Mock version of the TLogWriter class
End Rem
Type TLogWriterMock Extends TLogWriter

	Field nMessagesReceived:Int


	Method Close()
		'Nothing to do here
	End Method



	Method New()
		nMessagesReceived = 0
	End Method



	Method Write (message:TLoggerMessage)
		If message.severity > _level Then Return

		nMessagesReceived :+ 1
	End Method

End Type
