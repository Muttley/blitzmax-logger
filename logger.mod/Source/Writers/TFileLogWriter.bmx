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
