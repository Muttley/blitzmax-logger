Type TCustomLogWriter Extends TLogWriter

	Const FADE_SPEED:Float = 0.0025

	Field font:TImageFont
	Field fontHeight:Int

	Field messages:TList = New TList

	Field severityR:Int[] = [255, 255, 255, 255, 255, 174,  89,   0]
	Field severityG:Int[] = [  0, 128, 166, 208, 255, 255, 255, 255]
	Field severityB:Int[] = [  0,   0,   0,   0,   0,   0,   0,   0]


	Method Close()
		' Nothing to do
	EndMethod



	Method New()
		font = LoadImageFont("data/VeraMoBd.ttf", 20)
		SetImageFont (font)
		fontHeight = TextHeight ("A")
	EndMethod



	Method Render()
		SetImageFont (font)
		Local yPos:Int = SCREEN_HEIGHT - (fontHeight * messages.Count())
		For Local message:TCustomMessage = EachIn messages
			SetAlpha (message.alpha)
			SetColor (severityR[message.severity], severityG[message.severity], severityB[message.severity])
			DrawText (message.message, message.xPos, yPos)
			yPos :+ fontHeight
		Next
	EndMethod



	Method Update()
		For Local message:TCustomMessage = EachIn messages
			message.alpha :- FADE_SPEED
			If message.alpha <= 0.0 Then messages.Remove (message)
		Next
	EndMethod



	Method Write (message:TLoggerMessage)
		Local newMessage:TCustomMessage = New TCustomMessage

		newMessage.message  = severityToString (message.severity) + ": " + message.message
		newMessage.severity = message.severity

		SetImageFont (font)

		newMessage.xPos = (SCREEN_WIDTH - TextWidth (newMessage.message)) / 2

		messages.AddLast (newMessage)
	EndMethod

EndType
