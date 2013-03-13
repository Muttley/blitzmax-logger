Rem
'
' An example of how to create a custom log writer.
' This one is for displaying messages on-screen while testing a game.
'
' Press the Escape key to exit.
'
EndRem

SuperStrict

Import muttley.logger

Include "Source/TCustomLogWriter.bmx"
Include "Source/TCustomMessage.bmx"

Const SCREEN_WIDTH:Int  = 800
Const SCREEN_HEIGHT:Int = 600

Graphics (SCREEN_WIDTH, SCREEN_HEIGHT)
SetBlend (ALPHABLEND)

Global statsFont:TImageFont = LoadImageFont("data/VeraMoBd.ttf", 14)

Local customWriter:TCustomLogWriter = New TCustomLogWriter
TLogger.GetInstance().AddWriter (customWriter)

Local nextMessage:Int = MilliSecs() + Rand (10, 1000)

While Not KeyHit(KEY_ESCAPE)
	Cls

	If MilliSecs() >= nextMessage
		nextMessage = MilliSecs() + Rand (10, 1000)
		SendMessage()
	EndIf

	customWriter.update()
	customWriter.render()

	DrawStatistics()

	Flip
WEnd



Function DrawStatistics()
	SetColor (255, 255, 255)
	SetAlpha (1.0)

	Local statistics:String
	For Local i:Int = 0 To 7
		statistics :+ TLogWriter.severityDescriptions[i] + ":" + TLogger.GetInstance().GetMessageCount (i)
		If i < 7
			statistics :+ "  "
		EndIf
	Next

	SetImageFont (statsFont)
	DrawText (statistics, (SCREEN_WIDTH - TextWidth(statistics)) / 2, 0)
EndFunction



Function SendMessage()
	Local severity:Int = Rand (0, 7)
	TLogger.GetInstance().LogMessage (severity, "This is a test message sent at severity level " + severity)
EndFunction
