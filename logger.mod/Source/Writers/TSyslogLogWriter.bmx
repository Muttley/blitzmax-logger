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
	bbdoc: A log writer that outputs to a Syslog server via UDP
EndRem
Type TSyslogLogWriter Extends TLogWriter

	Const DEFAULT_FACILITY:Int = 16 ' Default facility will be set to local0

	Const DEFAULT_SERVER:String = "127.0.0.1"
	Const DEFAULT_UDP_PORT:Int  = 514

	Const SYSLOG_VERSION:Int = 1 ' defined in RFC5424

	Field _appName:String
	Field _facility:Int
	Field _server:String
	Field _stream:TSocketStream
	Field _udpPort:Int


	Method Close()
		If _stream
			_stream.Flush()
			_stream.Close()
		EndIf
	EndMethod



	Method FormatAppName()
		Local app:String = AppTitle

		' Replace non-ASCII characters in AppTitle with underscores
		For Local i:Int = 0 To app.Length - 1
			If (Asc (app[i..i + 1]) >= 33) And (Asc (app[i..i + 1]) <= 126)
				_appName :+ app[i..i + 1]
			Else
				_appName :+ "_"
			EndIf
		Next

		' Maximum length is 48 characters, so truncate if needed
		If _appName.Length > 48 Then _appName = _appName[..48]
	EndMethod



	Rem
		bbdoc: Default constructor
	EndRem
	Method New()
		_facility = DEFAULT_FACILITY
		_server   = DEFAULT_SERVER
		_udpPort  = DEFAULT_UDP_PORT
	EndMethod



	Method OpenSyslogStream()
		DebugLog ("Opening syslog stream")

		Local socket:TSocket = TSocket.CreateUDP()
		socket.Connect (HostIp (_server), _udpPort)

		_stream = TSocketStream.Create (socket)
	EndMethod



	Rem
		bbdoc: Set the _facility to use in the messages sent to the syslog server
		about: Facilities are based on those defined in RFC 5424 for the BSD Syslog protocol.
		Valid facility values are in the range 0 to 23 and are defined as being for the following message
		types. By default facility value 16 (local0) is used:
		<table>
			<tr> <th> Facility </th> <th> Description </th> </tr>
			<tr> <td> 0 </td> <td> kernel Messages </td> </tr>
			<tr> <td> 1 </td> <td> user-level messages </td> </tr>
			<tr> <td> 2 </td> <td> mail system </td> </tr>
			<tr> <td> 3 </td> <td> system daemons </td> </tr>
			<tr> <td> 4 </td> <td> security/authorization message </td> </tr>
			<tr> <td> 5 </td> <td> messages generated internally by syslog </td> </tr>
			<tr> <td> 6 </td> <td> line printer subsystem </td> </tr>
			<tr> <td> 7 </td> <td> network news subsystem </td> </tr>
			<tr> <td> 8 </td> <td> UUCP subsystem </td> </tr>
			<tr> <td> 9 </td> <td> clock daemon </td> </tr>
			<tr> <td> 10 </td> <td> security/authorization messages </td> </tr>
			<tr> <td> 11 </td> <td> FTP daemon </td> </tr>
			<tr> <td> 12 </td> <td> NTP subsystem </td> </tr>
			<tr> <td> 13 </td> <td> log audit </td> </tr>
			<tr> <td> 14 </td> <td> log alert </td> </tr>
			<tr> <td> 15 </td> <td> clock daemon </td> </tr>
			<tr> <td> 16 </td> <td> local use 0  (local0) </td> </tr>
			<tr> <td> 17 </td> <td> local use 1  (local1) </td> </tr>
			<tr> <td> 18 </td> <td> local use 2  (local2) </td> </tr>
			<tr> <td> 19 </td> <td> local use 3  (local3) </td> </tr>
			<tr> <td> 20 </td> <td> local use 4  (local4) </td> </tr>
			<tr> <td> 21 </td> <td> local use 5  (local5) </td> </tr>
			<tr> <td> 22 </td> <td> local use 6  (local6) </td> </tr>
			<tr> <td> 23 </td> <td> local use 7  (local7) </td> </tr>
		</table>
	EndRem
	Method SetFacility (facility:Int)
		If (facility >= 0) And (facility <= 23)
			_facility = facility
		EndIf
	EndMethod



	Rem
		bbdoc: Sets the hostname/IP address of the Syslog server to deliver the messages to
		about: Must be a valid/resolvable hostname/IP address
	EndRem
	Method SetServer (server:String)
		_server = server
	EndMethod



	Rem
		bbdoc: Set the UDP port to use to talk with the Syslog server
		about: The default is 514. You shouldn't need to change this
	EndRem
	Method SetUdpPort (port:Int)
		_udpPort = port
	EndMethod



	Method Write (message:TLoggerMessage)
		If message.severity > _level Then Return

		If Not _stream Then OpenSyslogStream()

		If Not _appName Then FormatAppName()

		Local priority:Int = (_facility * 8) + message.severity

		' Make sure we don't let any duff priority values through
		If priority < 0 Or priority > 191
			priority = 0
		EndIf

		Local line:String

		' Start header
		line :+ "<" + priority + ">"
		line :+ SYSLOG_VERSION
		line :+ " "
		line :+ message.timestamp
		line :+ " "
		line :+ message.host
		line :+ " "
		line :+ _appName
		line :+ " - -"	' contains empty PROCID and MSGID fields
		' End header

		line :+ " - " ' no structured data at this time

		line :+ message.message

		' Syslog messages have a maximum length of 1024 chars
		If line.length > 1024 Then line = line[..1024]

		_stream.WriteString (line)
		_stream.Flush()
	EndMethod

EndType
