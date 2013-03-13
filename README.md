#About

The **muttley.logger** module allows you to log messages with varying levels of
severity to one or more log writers.

Log writers are included which write messages to the console, to files and via
UDP to Syslog servers. Logging severity levels are based on
[RFC 5424: The Syslog Protocol][7].

You can specify the level of logging you wish a log writer to receive and only
messages that fit within that level of logging will be written. This enables
you to have enhanced logging whilst in Debug mode, etc.

It is also easy to extend the logger module by creating your own custom log writers.

#Dependencies

The **muttley.logger** module relies on two additional modules in the form of
**bah.boost** and **bah.datetime**.

These modules are developed by Bruce Henderson and are available from his
**maxmods** [Google Code project page][1].

Also, the Unit Tests rely on Bruce's [bah.maxunit][6] module available from
the same location.

In order to successfully build the logger module and tests you will need to
install these modules as well.

#Installation

To install this module, copy the **logger.mod** directory into a folder
called **muttley.mod** in your **BlitzMax\mod** directory.

For example, on Windows:

	xcopy logger.mod C:\BlitzMax\mod\muttley.mod\. /E /I

On Linux:

	mkdir /opt/BlitzMax/mod/muttley.mod
	cp -r logger.mod /opt/BlitzMax/mod/muttley.mod/.

Then build the module as follows (assuming bmk is in your path):

	bmk makemods -a muttley.logger

#Unit Tests

Unit Tests for the module are included in the **logger.mod\UnitTests**
folder, and these can be run as follows:

	bmk makeapp -a -r -t console -x logger.mod\UnitTests\Main.bmx

#Examples

The **logger.mod\Examples** directory contains several applications which
show how the logger module can be used.

First there are simple examples which write log messages to the console
(**ConsoleLogWriter.bmx**), files (**FileLogWriter.bmx**) and Syslog
(**SyslogLogWriter.bmx**).

The Syslog example requires that a Syslog server be running on the localhost
to work.

There is also an graphical example of a custom log writer (**CustomLogWriter.bmx**)
which shows how you can create and use your own log writers to output log
messages in interesting ways.

#Sublime Project

For [Sublime Text 2][2] users there is a project file which can be used
if you wish modify this module in any way.  The project file includes
build systems for building the module, and building and running both
the Unit Tests and Example application.  These build systems rely on
the [Gradle][3] build automation system.

#Acknowledgements

Many thanks to Brucey for the use of his modules.

#License

Copyright (c) 2009-2013 Paul Maskelyne ([muttley@muttleyville.org][4]).

All rights reserved. Use of this code is allowed under the
Artistic License 2.0 terms, as specified in the LICENSE file
distributed with this code, or available from
[http://www.opensource.org/licenses/artistic-license-2.0.php][5]

[1]: https://code.google.com/p/maxmods/
[2]: http://www.sublimetext.com/
[3]: http://www.gradle.org/
[4]: mailto:muttley@muttleyville.org
[5]: http://www.opensource.org/licenses/artistic-license-2.0.php
[6]: https://code.google.com/p/maxmods/wiki/MaxUnitModule
[7]: http://tools.ietf.org/html/rfc5424
