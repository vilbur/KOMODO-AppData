/**
  
  
  FIRED BY DisplayFusion TRIGERED when Maxscript EXCEPTION WINDOW is created
  
	
  # Get error file from 3Ds Max and open it in Komodo
  
  IMPORTANT:
	  All programs must be run as ADMIN
	  ( Komodo, 3Ds Max, Autohotkey, Displayfusion )
  
  1. Execute Open-Macroscript-Exception-In-Komodo.ahk
  
  2. Get filename, line and position
  
	   - A) From maxscript error message
	   - B) From maxscript listener
  
  3. Write data to "error-data.json"
  
  4. Execute "goToLineInKomodoIfException.komodotool"
  
	   -> Read "error-data.json"
  
		  * Open ms file with error
		  * Go to line of error

		!!!!!!!!!!  IMPORTANT NOTE !!!!!!!!!!

		Script 'goToLineInKomodoIfException.komodotool'
			MUST HAS SAME SHORTCUT which is send with callGoToLineInKomodoIfException()

 */

$CLOSE_EXCEPTION_TIMEOUT := 3000


$exception_error	:= WinExist( "MAXScript MacroScript Error Exception")
$exception_compile	:= WinExist( "MAXScript MacroScript Compile Exception")

$listener_window  := WinExist( "ahk_class #32770")

$komodo_window :=  WinExist( "ahk_exe komodo.exe" )

;SetTitleMatchMode, 2

/**
  
  
  
  UNABLE TO GE TEXT FROM WINDOW "MAXScript MacroScript Error Exception"
  
  
  
 */
getTextFromExceptionWindow($exception_window)
{
	;msgBox,,, %$exception_window%,1
	DetectHiddenText, On
	
	WinActivate, ahk_id %$exception_window%
	;WinWait, ahk_id %$exception_window%,, 3
	;if not ErrorLevel
	{
		
		;msgBox, %clipboard%,1
		;Sleep, 1000
		
		Send, ^c
		;Send, {Ctrl down}c{Ctrl up};, ahk_id %$exception_window%
		;ControlSend, {Ctrl down}c{Ctrl up}, ahk_id %$exception_window%
		
		
		;Sleep, 1000
		ClipWait
		;MsgBox,  %clipboard%
		
		
	}
	
	;WinGetText, window_text, ahk_id %$exception_window%
	
	$cliboard := RegExReplace( clipboard, "[^[:ascii:]]") ;;; CLIPBOARD TEXT CAN CONTAIN HIDDEN CHARACTERS BECASUSE OF ENCODING, This is cleanup of string
	
	RegExMatch( $cliboard, "i).*file name: ([^\n]+)", $filename )

	RegExMatch( $cliboard, "i).*line number: (\d+)", $line )
	
	$filename := $filename1

	$filename := % SubStr( $filename, 1, StrLen($filename) - 1 ) ;; remove trailing "\\n"

	$filename := RegExReplace( $filename, "\\", "\\" ) ; escape backslash in path
	
	return	{file: $filename, line:	$line1}
	;	,col:	$position1
	;	,offset:	$position1}
}

/**
 */
getTextFromListenerWindow($listener_window)
{
	;msgBox,,, %$listener_window%,1

	WinActivate, ahk_id %$listener_window%

	ControlGetText, $window_text , MXS_Scintilla1, ahk_id %$listener_window%

	;msgBox,,, %$window_text%,1

	
	RegExMatch( $window_text, "i).*filename: ([^;]+)", $filename )
	RegExMatch( $window_text, "i).*position: (\d+);", $position )
	RegExMatch( $window_text, "i).*line: (\d+)", $line )

	;msgBox,,, %$filename1%,10
	;msgBox,,, %$position1%,1
	;msgBox,,, %$line1%,1

	return	{file:	RegExReplace( $filename1, "\\", "\\" )
		,line:	$line1
		,col:	$position1
		,offset:	$position1}
}


/** join object
*/
_joinObject($object, $delimeter:="`n")
{
	For $key, $value in $object
		$string .= """" $key """: """ $value ""","

	$string := % SubStr( $string, 1, StrLen($string) - 1 )
	
	return "{" $string "}"
}

/**
 */
createFileInfoFile( $error_data )
{
	;$error_data	:= getErrorDataFromMaxscriptEditor()
	$error_data_file	= %A_LineFile%\..\error-data.json

	FileDelete, %$error_data_file%
	

	FileAppend, % _joinObject($error_data), %$error_data_file% 
}


/** Execute 'goToLineInKomodoIfException.komodotool'
 */
callGoToLineInKomodoIfException($komodo_window)
{
	;msgBox,,, callGoToLineInKomodoIfException,3
	;msgBox,,, %$komodo_window%,10

	;SetKeyDelay, 10, 10
	SetKeyDelay, 100, 100

	BlockInput, on

	;ControlSend,, {Ctrl down}{Alt down}{Shift down}{F8}{Ctrl up}{Alt up}{Shift up}, ahk_id %$komodo_window%
	ControlSend,, {Ctrl down}{Alt down}{Shift down}{F8}{Ctrl up}{Alt up}{Shift up}, ahk_exe komodo.exe

	BlockInput, off
}

/* Close current file in editor
*/
closeMaxscriptEditorFile()
{
	;$editor_window :=  WinExist( "ahk_class MXS_SciTEWindow" )
	;ControlSend,, {Ctrl down}W{Ctrl up}, ahk_id %$editor_window%

	$hwnd_active := WinActive( "A" )

	sleep 500
	;SetKeyDelay, 100, 100
	WinActivate, ahk_class MXS_SciTEWindow
	;ControlSend,, {Ctrl down}w{Ctrl up}, ahk_class MXS_SciTEWindow
	Send, ^w
	sleep 500

	WinActivate, ahk_id %$hwnd_active%

}

;$exception_window := WinExist( "MAXScript MacroScript Error Exception")


/**
  	GET EXCEPTION DATA
  */
if ( $exception_error )
	$error_data  := getTextFromExceptionWindow($exception_error)
	
else if ( $exception_compile )
	$error_data  := getTextFromExceptionWindow($exception_compile)
	

else if( $listener_window )
	$error_data  := getTextFromListenerWindow($listener_window)

	;msgBox,,, %$error_data%,10




createFileInfoFile( $error_data )


callGoToLineInKomodoIfException($komodo_window)


Sleep, %$CLOSE_EXCEPTION_TIMEOUT%


/**
	CLOSE WINDOWS
  
  */
if ( $exception_error )
	WinClose, ahk_id %$exception_error%
	
else if ( $exception_compile )
	WinClose, ahk_id %$exception_compile%
	
closeMaxscriptEditorFile()


WinActivate, ahk_id %$komodo_window%

