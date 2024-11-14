/** Open maxscript in Komodo and go to line of MaxScript editor
 *
 *	1) Get current file and position in 3Ds Max script editor
 *	2) Save position
 *
 *	Executed by "go_to_line_if_exception_ahk"
 *
 */


;if( ! WinExist( "ahk_class MXS_SciTEWindow") )
;	return

/**
 */
createFileInfoFile(  )
{

	$error_data	:= getErrorDataFromMaxscriptEditor()
	$error_data.exception	:= getTextFromExceptionWindow()
	;Dump($error_data, "error_data", 1)
	if( iExcluded( $error_data.file ) )
		return

	$error_data_file	= %A_LineFile%\..\error-data.json

	msgBox %$error_data_file%
	FileDelete, %$error_data_file%
	FileAppend, % _joinObject($error_data), %$error_data_file%
}

/**
 */
getTextFromExceptionWindow()
{
	WinGetText, $exception,	MAXScript FileIn Exception



	$exception := % SubStr( $exception, 8, StrLen($exception) - 9 ) ; remove 'OK -- Type error:'

	$exception	:= RegExReplace( $exception, """", "'" ) ; "
	$exception	:= RegExReplace( $exception, "\t+", "" ) ; "
	$exception	:= RegExReplace( $exception, "\n", "" ) ; "

	return $exception
}

/**
 */
getErrorDataFromMaxscriptEditor()
{
	WinGetTitle, $win_title,	ahk_class MXS_SciTEWindow
	StatusBarGetText, $status_bar_text,,	ahk_class MXS_SciTEWindow

	$file_path	:= RegExReplace( $win_title, "\s-\sMAXScript", "" )

	RegExMatch( $status_bar_text, "i)li=(\d+)\sco=(\d+)\soffset=(\d+).*", $error_data )

	closeMaxscriptEditorFile()

	return	{file:	RegExReplace( $file_path, "\\", "\\" )
		,line:	$error_data1
		,col:	$error_data2
		,offset:	$error_data3}
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
iExcluded( $filepath )
{
	return RegExMatch( $filepath, "i)untitled" )
}


createFileInfoFile()
