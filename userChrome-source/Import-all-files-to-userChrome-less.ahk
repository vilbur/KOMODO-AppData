/*
	import all less files in this directory to c:\GoogleDrive\Programs\code\Komodo\AppData\ActiveState\KomodoIDE\10.1\userChrome.less
*/
#SingleInstance force

$import_file_name = userChrome.less
$import_file      = %A_ScriptDir%\..\%$import_file_name%
FileDelete, %$import_file%

loop, %A_ScriptDir%\*.less, 0, 1
	GoSub, importFile	
return

/*
	importFile 
*/
importFile:
	SplitPath, A_LoopFileFullPath, $filename , , , $noext
	$content := "@import url(""resource://profile/userChrome/" $filename """);`n"
	FileAppend , %$content%, %$import_file%		
	
return