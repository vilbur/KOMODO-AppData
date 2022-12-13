#SingleInstance Force
;#InstallKeybdHook
;#NoTrayIcon
;#WinActivateForce

/**
 */
saveIni($current_path)
{
	;%A_LineFile%

	SplitPath, A_LineFile	,,$path_parent
	SplitPath, $current_path	,$filename

	$ini_path := $path_parent "\run-maxscript-via-notepad-komodo.ini"

	IniRead, $last_path, %$ini_path%, last_executed_maxscript, path

	if( $last_path == "ERROR" || $last_path != $current_path  )
		IniWrite, %$current_path%, %$ini_path%, last_executed_maxscript, path

	if( $last_path != $current_path )

		MsgBox,262144,New file, %$filename%, 1
		; MsgBox,262144,New file, %$filename%,2

}

/** Close '3Ds Max script exception window' 
 */
killMaxscriptExceptionWindow()
{

	SetTitleMatchMode, RegEx

	While WinExist( "MAXScript.*Exception") != "0x0"

	{
		$hwnd :=  WinExist( "MAXScript.*Exception")

		sleep 500

		ControlSend, , {NumpadEnter}, ahk_id %$hwnd%
	}
}
/**
 */
sendFilePathTomaxListener( $file_in_path )
{

	$file_in_command := "filein @""" $file_in_path """"

	saveIni($file_in_path)

	;WinActivate, ahk_class Qt5151QWindowIcon ;; MAX WINDOW -- THIS STOPS TO WORK
	WinActivate, ahk_class #32770 ;; LISTENER WINDOW

	
	;ControlSend, , {F11}, A -- open \ close listener window
	
	ControlFocus, MXS_Scintilla2, A ;;; clear old entry for sure
	
	sleep 300

	
	ControlSetText , MXS_Scintilla2, %$file_in_command% , A
	
	sleep 300
	
	
	ControlSend, MXS_Scintilla2, {NumpadEnter}, A
	

}

/**
 */
runMaxscript()
{
	;killMaxscriptExceptionWindow()

	WinGetTitle, $notepad_title,	ahk_exe notepad++.exe 
	WinGetTitle, $komodo_title,	ahk_exe komodo.exe

	/** NOTEPAD++
	  *	
	  */
	if( $notepad_title != "" )
	{
		RegExMatch( $notepad_title, "i)(.*\.(ms|mcr))", $file_in_path_title )

		RegExMatch( $komodo_title,  "\*", $file_is_not_saved )

		if( $file_is_not_saved == "" )
			$file_in_path_title := RegExReplace( $file_in_path_title, "\*", "" )

		;MsgBox,262144,runMaxscript, %$file_in_path_title% 
		if( $file_in_path_title == "" )
		{
			MsgBox,262144, Notepad error, % "In Notepad++ is some problem\n\nfile path:" $file_in_path_title 
			
			WinActivate, ahk_exe notepad++.exe 
		}

		else
			sendFilePathTomaxListener( $file_in_path_title )
	
	}
	/** KOMODO 
	  *	
	  */
	else if( $komodo_title != "" )
	{

		RegExMatch( $komodo_title,  "i)(.*\.ms)\**.*\((.*)\).*", $win_title_match ) ;; if match E.G.: "foo.ms" (X:\project\path)
		RegExMatch( $komodo_title,  "\*", $file_is_not_saved )
		
		if( $win_title_match != "" )
		{
			
			RegExMatch( $win_title_match2,  "i)(.*),(.*)", $project_open ) ;; if match E.G.: "foo.ms" (X:\project\path)


			if( $file_is_not_saved != "" )		
			{

				WinActivate, ahk_exe komodo.exe
	
				Send {Ctrl down}{s}{Ctrl up}
			}

			
			if( $project_open != "" )
				$file_path	:= $project_open1 "\\" $win_title_match1 ;; if project open 
			
			else
				$file_path	:= $win_title_match2 "\\" $win_title_match1 ;; if project is not open
			
			
			sendFilePathTomaxListener(  $file_path )
	
		}

	}
}

runMaxscript()

exit