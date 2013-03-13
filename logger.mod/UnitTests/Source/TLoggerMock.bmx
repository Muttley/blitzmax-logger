Rem
	bbdoc: Mock version of the TLogger class used to ensure consistant
	timestamps and hostname whilst running tests.
End Rem
Type TLoggerMock Extends TLogger Final

	Global instance:TLoggerMock


	' Returns a fixed timestamp to ensure consistant test results
	Method CreateTimestamp:String()
		Return "1970-01-01T12:00:00+00:00"
	End Method


	' Returns a fixed hostname to ensure consistant test results
	Method GetHost:String()
		Return "unitTest"
	End Method


	' Returns an instance of the mocked logger
	Function GetInstance:TLoggerMock()
		If Not instance
			instance = New TLoggerMock
			Return instance
		Else
			Return instance
		EndIf
	EndFunction


	' Constructor
	Method New()
		If instance Throw "Cannot create multiple instances of Singleton Type"
	EndMethod

End Type
