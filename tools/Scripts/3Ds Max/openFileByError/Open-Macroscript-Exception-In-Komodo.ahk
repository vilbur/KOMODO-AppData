/**
  
  
  FIRED BY DisplayFusion TRIGERED when Maxscript EXCEPTION WINDOW is created
  
  
  DisplayFusion MUST BE EXECUTED AS ADMINISTRATOR ( also 3Ds Max and Komodo )
  
  
  

  # Get error file from 3Ds Max and open it in Komodo

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

/**
  
  UNABLE TO GE TEXT FROM WINDOW "MAXScript MacroScript Error Exception"
  
  
  
 */
getTextFromExceptionWindow($exception_window)
{
	;msgBox,,, %$listener_window%,1
DetectHiddenText, On

	WinActivate, ahk_id %$exception_window%

	WinGetText, window_text, ahk_id %$exception_window%

	msgBox,,, %window_text%,1

	
	RegExMatch( $window_text, "i).*file name: ([^;]+)", $filename )
	;RegExMatch( $window_text, "i).*position: (\d+);", $position )
	RegExMatch( $window_text, "i).*line number: (\d+)", $line )

	;msgBox,,, %$filename1%,10
	;msgBox,,, %$position1%,1
	;msgBox,,, %$line1%,1

	;return	{file:	RegExReplace( $filename1, "\\", "\\" )
	;	,line:	$line1
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
		$string .= """" $key """:	""" $value ""","

	$string := % SubStr( $string, 1, StrLen($string) - 1 )
	;Dump($string, "string", 1)
	return "{" $string "}"
}

/**
 */
createFileInfoFile( $error_data )
{
	;$error_data	:= getErrorDataFromMaxscriptEditor()
	;$error_data.exception	:= getTextFromExceptionWindow()
	;;Dump($error_data, "error_data", 1)
	;if( iExcluded( $error_data.file ) )
	;	return
	;
	$error_data_file	= %A_LineFile%\..\error-data.json
	;
	;msgBox %$error_data_file%
	FileDelete, %$error_data_file%
	FileAppend, % _joinObject($error_data), %$error_data_file%
}


/** Execute 'goToLineInKomodoIfException.komodotool'
 */
callGoToLineInKomodoIfException($komodo_window)
{
	;msgBox,,, %$komodo_window%,10

	;SetKeyDelay, 10, 10
	SetKeyDelay, 100, 100

	BlockInput, on

	;ControlSend,, {Ctrl down}{Alt down}{Shift down}{F8}{Ctrl up}{Alt up}{Shift up}, ahk_id %$komodo_window%
	ControlSend,, {Ctrl down}{Alt down}{Shift down}{F8}{Ctrl up}{Alt up}{Shift up}, ahk_exe komodo.exe

	BlockInput, off
}



;$exception_window := WinExist( "MAXScript MacroScript Error Exception")

;SetTitleMatchMode, 2
;
;$exception_window := WinExist( "MAXScript MacroScript Error Exception")
$exception_window := WinExist( "MAXScript MacroScript Compile Exception")

$listener_window  := WinExist( "ahk_class #32770")
$komodo_window :=  WinExist( "ahk_exe komodo.exe" )

	;msgBox,,, %$exception_window%,10

;if( $exception_window )
;	$error_data  := getTextFromExceptionWindow($exception_window)
;else

if( $listener_window )
	$error_data  := getTextFromListenerWindow($listener_window)



createFileInfoFile( $error_data )


callGoToLineInKomodoIfException($komodo_window)

;sleep 10000

;if( $exception_window )
	;WinClose, ahk_id %$exception_window%

