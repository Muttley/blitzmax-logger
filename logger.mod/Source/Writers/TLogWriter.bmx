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
	bbdoc: The base class of all log writers
End Rem
Type TLogWriter

	Global severityDescriptions:String[] = [ ..
		"Emergency", "Alert",  "Critical", "Error", ..
		"Warning",   "Notice", "Info",     "Debug"  ..
	]

	Rem
		bbdoc: The current log _level
		about: Writers should only display/output messages that have a severity
		that is equal or lower than the level set for the writer
	EndRem
	Field _level:Int


	Rem
		bbdoc: Close the log writer
		about: This abstract Method needs to be implemented by all
		log writers and should be used for tidying up before shutdown,
		for example flushing and closing streams/files, etc.
	EndRem
	Method Close() Abstract



	Rem
		bbdoc: The current log level of this writer
	EndRem
	Method GetLevel:Int()
		return _level
	EndMethod



	Rem
		bbdoc: Set the log level of this writer
		about: Writers should only display/output messages that have a severity
		that is equal or lower than the level set for the writer
	EndRem
	Method SetLevel (level:Int)
		If (level >= 0) And (level <= 7)
			_level = level
		EndIf
	EndMethod



	Rem
		bbdoc: Returns a string representation of the specified severity level
	EndRem
	Method SeverityToString:String (severity:Int)
		If severity + 1 <= severityDescriptions.Length
			Return severityDescriptions[severity]
		Else
			Return Null
		End If
	EndMethod



	Rem
		bbdoc: Writer a message to the log writer's output
		about: This abstract Method needs to be implemented by all
		log writers and should handle the output of the specified
		message in a way appropriate for the type of output being
		written to
	EndRem
	Method Write (message:TLoggerMessage) Abstract

EndType
