#SingleInstance Force
;#InstallKeybdHook
;#NoTrayIcon
;#WinActivateForce

/**
 */
saveIni($current_path, $source_program)
{
	SplitPath, $current_path	,$filename

	$ini_path := A_Temp "\run-maxscript-via-notepad-komodo.ini"

	IniRead, $last_path, %$ini_path%, last_executed_maxscript, path

	if( $last_path == "ERROR" || $last_path != $current_path  )
		IniWrite, %$current_path%, %$ini_path%, last_executed_maxscript, path

	if( $last_path != $current_path )
		MsgBox,262144,New file, % "Run:  " $filename "`n`nFrom: " $source_program, 2

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
sendFilePathTomaxListener( $file_in_path, $source_program )
{

	$file_in_command := "filein @""" $file_in_path """"

	saveIni($file_in_path, $source_program)

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

	RegExMatch( $notepad_title, "i)(.*\.(ms|mcr))", $path_in_notepad_title )



	/** NOTEPAD++
	  *
	  */
	if( $path_in_notepad_title != "" )
	{
		RegExMatch( $notepad_title, "i)(.*\.(ms|mcr))", $path_in_title )

		$path_in_title := RegExReplace( $path_in_notepad_title, "\*", "" )

		sendFilePathTomaxListener( $path_in_title, "Notepad++" )

	}
	/** KOMODO
	  ;*
	  */
	else if( $komodo_title != "" )
	{

		RegExMatch( $komodo_title,  "i)(.*\.(ms|mcr))\**.*\((.*)\).*", $win_title_match ) ;; if match E.G.: "foo.ms" (X:\project\path)
		RegExMatch( $komodo_title,  "\*", $file_is_not_saved )

		;msgBox,,, %$win_title_match1%
		;msgBox,,, %$win_title_match2%
		;msgBox,,, %$win_title_match3%
		
		if( $win_title_match != "" )
		{

			RegExMatch( $win_title_match3,  "i)(.*),(.*)", $project_path_split ) ;; if match E.G.: "foo.ms" (X:\project\path)

			$filename := $win_title_match1

			if( $file_is_not_saved != "" )
			{

				WinActivate, ahk_exe komodo.exe

				Send {Ctrl down}{s}{Ctrl up}
			}


			if( $project_path_split != "" )
				$file_path	:= $project_path_split1 "\\" $filename ;; if project open

			else
				$file_path	:= $win_title_match3 "\\" $filename ;; if project is not open


			sendFilePathTomaxListener( $file_path, "Komodo" )

		}

	}
}

runMaxscript()

exit