Rem
'
' muttley.logger - BlitzMax Logging Module
' Copyright (C) 2009-2013 Paul Maskelyne
'
' This software is licensed under the terms of the Artistic
' License version 2.0.
'
' For full license details, please read the file 'artistic-2_0.txt'
' included with this distribution, or see
' http://www.perlfoundation.org/legal/licenses/artistic-2_0.html
'
EndRem

Rem
	bbdoc: A log writer that outputs to the console
EndRem
Type TConsoleLogWriter Extends TLogWriter

	Field _displaySeverity:Int
	Field _displayTimestamp:Int


	Method Close()
		'Nothing to do here
	EndMethod



	Method New()
		_displayTimestamp = False
		_displaySeverity  = False
	EndMethod



	Rem
		bbdoc: Show the severity level of the message
	EndRem
	Method ShowSeverity (bool:Int)
		_displaySeverity = bool
	EndMethod



	Rem
		bbdoc: Show the timestamp of the message
	EndRem
	Method ShowTimestamp (bool:Int)
		_displayTimestamp = bool
	EndMethod



	Method Write (message:TLoggerMessage)
		If message.severity > _level Then Return

		Local line:String

		If _displayTimestamp
			line :+ message.timestamp + " "
		EndIf

		If _displaySeverity
			line :+ severityToString (message.severity) + ": "
		EndIf

		line :+ message.message

		Print line
	EndMethod

EndType
