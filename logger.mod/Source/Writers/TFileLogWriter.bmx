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
	bbdoc: A log writer that outputs to a file
EndRem
Type TFileLogWriter Extends TLogWriter

	Const DEFAULT_FILENAME:String = "logfile.log"

?Debug
	Const DEFAULT_LEVEL:Int = LOGGER_INFO
?Not Debug
	Const DEFAULT_LEVEL:Int = LOGGER_ERROR
?

	Const DEFAULT_OVERWRITE:Int = True

	Field _displaySeverity:Int
	Field _filename:String
	Field _overwrite:Int
	Field _stream:TStream


	Method Close()
		If _stream
			_stream.Flush()
			_stream.Close()
		EndIf
	End Method



	Method New()
		_filename  = DEFAULT_FILENAME
		_level     = DEFAULT_LEVEL
		_overwrite = DEFAULT_OVERWRITE
		_displaySeverity = True
	End Method



	Method OpenLogFile()
		Assert _filename <> "", "No filename specified for log file."
		Assert FileType (_filename) <> 2, "Requested log file ~q" + _filename + "~q is a directory."

		If (FileSize (_filename) = -1) Or (_overwrite = True)
			' log file doesn't exist already are we want to overwrite it
			_stream = WriteStream (_filename)
			Assert _stream, "Unable to create new log file: " + _filename
		Else
			_stream = OpenStream (_filename)
			Assert _stream, "Unable to open existing log file: " + _filename
			SeekStream (_stream, _stream.Size())
		EndIf
	EndMethod



	Rem
	bbdoc: Sets the path/filename that will be written to
	EndRem
	Method SetFilename (filename:String)
		_filename = filename
	EndMethod



	Rem
		bbdoc: Sets whether to overwrite an existing file or not
	EndRem
	Method SetOverwrite (bool:Int)
		_overwrite = bool
	EndMethod



	Rem
		bbdoc: Specify whether to show the severity level in the log file or not
	EndRem
	Method ShowSeverity (bool:Int)
		_displaySeverity = bool
	EndMethod



	Method Write (message:TLoggerMessage)
		If message.severity > _level Then Return

		If Not _stream Then OpenLogFile()

		Local line:String = message.timestamp + " "
		line :+ message.host + " "

		If _displaySeverity
			line :+ severityToString (message.severity) + ": "
		EndIf

		line :+ message.message

		_stream.WriteLine (line)
		_stream.Flush()
	EndMethod

EndType
