Rem
'
' Copyright (c) 2009-2017 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
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
