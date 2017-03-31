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
	bbdoc: Severity level 0: Emergency
EndRem
Const LOGGER_EMERGENCY:Int = 0

Rem
	bbdoc: Severity level 1: Alert
EndRem
Const LOGGER_ALERT:Int = 1

Rem
	bbdoc: Severity level 2: Critical
EndRem
Const LOGGER_CRITICAL:Int = 2

Rem
	bbdoc: Severity level 3: Error
EndRem
Const LOGGER_ERROR:Int = 3

Rem
	bbdoc: Severity level 4: Warning
EndRem
Const LOGGER_WARNING:Int = 4

Rem
	bbdoc: Severity level 5: Notice
EndRem
Const LOGGER_NOTICE:Int = 5

Rem
	bbdoc: Severity level 6: Info
EndRem
Const LOGGER_INFO:Int = 6

Rem
	bbdoc: Severity level 7: Debug
EndRem
Const LOGGER_DEBUG:Int = 7


Rem
	bbdoc: The primary interface for logging messages
	about: All logging is handled by sending messages to this class. It then
	creates a new log message and passes it to any log writers that are
	registered.
End Rem
Type TLogger

	Global _instance:TLogger

	Field _host:String
	Field _logWriters:TList
	Field _messageCounts:Int[] = [0, 0, 0, 0, 0, 0, 0, 0]


	Rem
		bbdoc: Registers a new log writer so it can receive log messages
	EndRem
	Method AddWriter (writer:TLogWriter)
		_logWriters.AddLast (writer)
	EndMethod



	Rem
		bbdoc: Closes And de-registers all currently registered Log writers
		about: This Method should be called right at the end of your program
	EndRem
	Method Close()
		Local statistics:String

		For Local i:Int = 0 To 7
			statistics :+ TLogWriter.severityDescriptions[i] + ":" + _messageCounts[i]
			If i < 7
				statistics :+ "  "
			EndIf
		Next

		LogInfo ("[Logger] Statistics:  " + statistics)

		For Local writer:TLogWriter = EachIn _logWriters
			writer.Close()
			_logWriters.Remove (writer)
		Next

		ResetStatistics()
	EndMethod



	Rem
	'
	' Creates a timestamp in a format suitable For Syslog as defined in
	' RFC 5424
	'
	EndRem
	Method CreateTimestamp:String()
		Local uTime:TTime = TTime.CreateUniversal()
		Local lTime:TTime = TTime.CreateLocal()

		Local diff:TTimeDuration = lTime.subtract (uTime)

		Local diffHours:Int = diff.hours()
		Local diffMins:Int  = diff.minutes()

		Local tzAdjust:String

		If diffHours < 0
			tzAdjust = "-"
		Else
			tzAdjust = "+"
		EndIf

		diffHours = Abs (diffHours)

		If diffHours < 10
			tzAdjust :+ "0" + diffHours
		Else
			tzAdjust :+ diffHours
		EndIf

		tzAdjust :+ ":"

		If diffMins < 10
			tzAdjust :+ "0" + diffMins
		Else
			tzAdjust :+ diffMins
		EndIf

		Return lTime.toISOExtendedString() + tzAdjust
	EndMethod



	Rem
		bbdoc: return the current host identifier used in log messages
	EndRem
	Method GetHost:String()
		Return _host
	EndMethod



	Rem
		bbdoc: Returns an instance of the logger
		about: The logger class is singleton type
	EndRem
	Function GetInstance:TLogger()
		If Not _instance
			_instance = New TLogger
			Return _instance
		Else
			Return _instance
		EndIf
	EndFunction



	Rem
		bbdoc: Returns the list of log writers registered with the logger
	EndRem
	Method GetLogWriters:TList()
		return _logWriters
	EndMethod



	Rem
		bbdoc: Returns the number of messages received for the specified log level
	EndRem
	Method GetMessageCount:Int (level:Int)
		If level >= 0 And level < _messageCounts.Length
			Return _messageCounts[level]
		Else
			Return 0
		EndIf
	EndMethod



	Rem
		bbdoc: Logs an Alert level message
	EndRem
	Method LogAlert (message:String)
		LogMessage (LOGGER_ALERT, message)
	EndMethod



	Rem
		bbdoc: Logs a Critical level message
	EndRem
	Method LogCritical (message:String)
		LogMessage (LOGGER_CRITICAL, message)
	EndMethod



	Rem
		bbdoc: Logs a Debug level message
	EndRem
	Method LogDebug (message:String)
		LogMessage (LOGGER_DEBUG, message)
	EndMethod



	Rem
		bbdoc: Logs an Emergency level message
	EndRem
	Method LogEmergency (message:String)
		LogMessage (LOGGER_EMERGENCY, message)
	EndMethod



	Rem
		bbdoc: Logs an Error level message
	EndRem
	Method LogError (message:String)
		LogMessage (LOGGER_ERROR, message)
	EndMethod



	Rem
		bbdoc: Logs an Info level message
	EndRem
	Method LogInfo (message:String)
		LogMessage (LOGGER_INFO, message)
	EndMethod



	Rem
		bbdoc: Log a message at the specified severity level
		about: Severity levels are based on those defined in RFC 5424 for the BSD Syslog protocol.
		Valid severity levels are in the range 0 to 7 and are defined as being for the following message
		types:
		<table>
		<tr> <th> Severity </th> <th> Description </th> </tr>
		<tr> <td> 0 </td> <td> Emergency: system is unusable </td> </tr>
		<tr> <td> 1 </td> <td> Alert: action must be taken immediately </td> </tr>
		<tr> <td> 2 </td> <td> Critical: critical conditions </td> </tr>
		<tr> <td> 3 </td> <td> Error: error conditions </td> </tr>
		<tr> <td> 4 </td> <td> Warning: warning conditions </td> </tr>
		<tr> <td> 5 </td> <td> Notice: normal but significant condition </td> </tr>
		<tr> <td> 6 </td> <td> Info: informational messages </td> </tr>
		<tr> <td> 7 </td> <td> Debug: debug-level messages </td> </tr>
		</table>
	EndRem
	Method LogMessage (severity:Int, message:String)
		If (severity >= 0) And (severity <= 7)
			Local newMessage:TLoggerMessage = New TLoggerMessage

			newMessage.timestamp = createTimestamp()
			newMessage.severity  = severity
			newMessage.message   = message
			newMessage.host      = getHost()

			For Local writer:TLogWriter = EachIn _logWriters
				writer.Write (newMessage)
			Next

			_messageCounts[severity] :+ 1
		EndIf
	EndMethod



	Rem
		bbdoc: Logs a Notice level message
	EndRem
	Method LogNotice (message:String)
		LogMessage (LOGGER_NOTICE, message)
	EndMethod



	Rem
		bbdoc: Logs a Warning level message
	EndRem
	Method LogWarning (message:String)
		LogMessage (LOGGER_WARNING, message)
	EndMethod



	Rem
		bbdoc: Default constructor
	EndRem
	Method New()
		If _instance Throw "Cannot create multiple instances of Singleton Type"
		_logWriters = New TList
		_host = HostName (0)
	EndMethod



	Rem
		bbdoc: Reset the statistics count
		about: The logger keeps a count of how many of each severity of message
		it has handled, you can use this Method To reset that cound To zero
	EndRem
	Method ResetStatistics()
		_messageCounts = [0, 0, 0, 0, 0, 0, 0, 0]
	EndMethod



	Rem
		bbdoc: Set the host identifier used in Log messages
		about: When the logger is instantiated it attempts To get the HostName
		of the Local machine, however you can override the identifier it uses
		by setting it manually
	End Rem
	Method SetHost (host:String)
		_host = host
	EndMethod

EndType


Rem
	bbdoc: Logs an Alert level message
EndRem
Function LogAlert (message:String)
	TLogger.GetInstance().LogAlert (message)
EndFunction



Rem
	bbdoc: Logs a Critical level message
EndRem
Function LogCritical (message:String)
	TLogger.GetInstance().LogCritical (message)
EndFunction



Rem
	bbdoc: Logs a Debug level message
EndRem
Function LogDebug (message:String)
	TLogger.GetInstance().LogDebug (message)
EndFunction



Rem
	bbdoc: Logs an Emergency level message
EndRem
Function LogEmergency (message:String)
	TLogger.GetInstance().LogEmergency (message)
EndFunction



Rem
	bbdoc: Logs an Error level message
EndRem
Function LogError (message:String)
	TLogger.GetInstance().LogError (message)
EndFunction



Rem
	bbdoc: Logs an Info level message
EndRem
Function LogInfo (message:String)
	TLogger.GetInstance().LogInfo (message)
EndFunction



Rem
	bbdoc: Logs a Notice level message
EndRem
Function LogNotice (message:String)
	TLogger.GetInstance().LogNotice (message)
EndFunction



Rem
	bbdoc: Logs a Warning level message
EndRem
Function LogWarning (message:String)
	TLogger.GetInstance().LogWarning (message)
EndFunction
