Rem
'
' Copyright (c) 2009-2013 Paul Maskelyne <muttley@muttleyville.org>.
'
' All rights reserved. Use of this code is allowed under the
' Artistic License 2.0 terms, as specified in the LICENSE file
' distributed with this code, or available from
' http://www.opensource.org/licenses/artistic-license-2.0.php
'
EndRem

SuperStrict

Rem
	bbdoc: muttley\logger
EndRem
Module muttley.logger

ModuleInfo "Version: 1.2.1"
ModuleInfo "License: Artistic License 2.0"
ModuleInfo "Author: Paul Maskelyne (Muttley)"
ModuleInfo "Copyright: (c) 2009-2013 Paul Maskelyne"
ModuleInfo "E-Mail: muttley@muttleyville.org"
ModuleInfo "Website: http://www.muttleyville.org"

ModuleInfo "History: 1.2.1"
ModuleInfo "History: Code tidy and migration to Bitbucket"
ModuleInfo "History: 1.2.0"
ModuleInfo "History: Changed the way timestamps are generated to work around a bug in BaH.DateTime"
ModuleInfo "History: Added missing test data for unit tests"
ModuleInfo "History: 1.1.0"
ModuleInfo "History: Updated Syslog support to RFC5424"
ModuleInfo "History: 1.0.1"
ModuleInfo "History: Minor documentation fixes"
ModuleInfo "History: 1.0.0"
ModuleInfo "History: Initial Release"

Import bah.boost
Import bah.datetime

Import brl.socket
Import brl.socketstream
Import brl.standardio
Import brl.linkedlist
Import brl.filesystem

Include "Source\TLogger.bmx"
Include "Source\TLoggerMessage.bmx"
Include "Source\Writers\TConsoleLogWriter.bmx"
Include "Source\Writers\TFileLogWriter.bmx"
Include "Source\Writers\TLogWriter.bmx"
Include "Source\Writers\TSyslogLogWriter.bmx"
