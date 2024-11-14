

$listener_window := WinExist( "ahk_class #32770")

WinActive( "ahk_class #32770")


ControlGetText, $window_text , MXS_Scintilla1, ahk_class #32770
;msgBox %$window_text%


RegExMatch( $window_text, "i).*filename: ([^;]+)", filename )
RegExMatch( $window_text, "i).*position: (\d+);", position )
RegExMatch( $window_text, "i).*line: (\d+)", line )


msgBox %filename1%
msgBox %position1%
msgBox %line1%



;error_line_split := StrSplit( error_line, A_Space )

;msgBox %error_line_split1%
;
;;word_array := StrSplit(error_line, A_Space ) ; Omits periods.

;word_array := StrSplit(error_line, ";" )
;
;for index, item in word_array
;    MsgBox % item

/** 1) Close '3Ds Max script exception window' if exist
 *  2) Call 'goToLineInKomodoIfException.komodotool'
 *
 *
 * !!!!!!!!!!  IMPORTANT NOTE !!!!!!!!!!
 *
 *	 Script 'goToLineInKomodoIfException.komodotool'
 *	 	MUST HAS SAME SHORTCUT which is send with callGoToLineInKomodoIfException()
 *
 */

/** Call 'goToLineInKomodoIfException.komodotool'
 */
goToLineInKomodoIfException()
{

	;if( ! maxscriptExceptionWindowExists() )
		;return

	;if( isUnknownException() )
	;	return restartMax()
	;$exception = isUnknownException()
	;	MsgBox,262144,exception, %$exception%,3

	Run, %A_LineFile%\..\get-error-data-from-max.ahk

	sleep, 100

	closeExceptionWindow()

	$komodo_window :=  WinExist( "ahk_exe komodo.exe" )

	if( !$komodo_window )
		return

	callGoToLineInKomodoIfException($komodo_window)
}


/** Execute 'goToLineInKomodoIfException.komodotool'
 */
callGoToLineInKomodoIfException($komodo_window)
{

	SetKeyDelay, 10, 10
	BlockInput, on

	ControlSend,, {Ctrl down}{Alt down}{Shift down}{F8}{Ctrl up}{Alt up}{Shift up}, ahk_id %$komodo_window%


	BlockInput, off
}


/** Close '3Ds Max script exception window'
 */
maxscriptExceptionWindowExists()
{
	return % WinExist( "MAXScript FileIn Exception" )
}


/**
 */
isUnknownException()
{
	WinGetText, $exception,	MAXScript FileIn Exception

	return % RegExMatch( $exception, "i)Unknown system exception" )
}


/**
 */
restartMax()
{

	Process, Close, 3dsmax.exe

	Run, %ADSK_3DSMAX_x64_2016%\3dsmax.exe
}

/**
 */
closeExceptionWindow()
{
	;MsgBox,262144,, closeExceptionWindow,2
	GroupAdd, MaxExceptions, MAXScript FileIn Exception

	WinClose, ahk_group MaxExceptions

	return true
}

;goToLineInKomodoIfException()