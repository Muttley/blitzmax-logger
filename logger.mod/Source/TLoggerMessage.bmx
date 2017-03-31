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
	bbdoc: This class represents an actual log message that is sent to all log writers
End Rem
Type TLoggerMessage

	Rem
		bbdoc: The identifier of the host that created this message
	EndRem
	Field host:String

	Rem
		bbdoc: The message itself
	EndRem
	Field message:String

	Rem
		bbdoc: The severity of the message
	EndRem
	Field severity:Int

	Rem
		bbdoc: The timestamp of when the message was created
		about: The timestamp is in RFC 5424 compatible format, for example:
		<pre>
		2009-09-27T12:21:57+01:00
		2007-02-13T18:09:10-05:00
		</pre>
	EndRem
	Field timestamp:String

End Type
