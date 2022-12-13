#SingleInstance Force
#InstallKeybdHook
;#NoTrayIcon


/** Get selected text
 */
getSelecetdText()
{
	$clip_bak := ClipboardAll  ; save clipboard contents
	Send, ^c
	ClipWait,1
	
	$sel_text := Clipboard 
	
	ClipBoard := $clip_bak         ; return original Clipboard contents
	
	return $sel_text
}

/** Save to temp *.ms file
 */
saveToFile( $script )
{
	$temp_file = %temp%\run-maxscript_temp-file.ms
	
	FileDelete, %$temp_file%
	
	FileAppend, %$script%, %$temp_file% 

	return $temp_file 
}

/**	Simulate drag & drop of files into window
 *	Works with 3Ds Max 2016 
 *
 *	 https://autohotkey.com/board/topic/109578-simulating-drag-and-drop-file-on-to-program/#post_id_651231
 *
 * @example DropFiles( "ahk_class Notepad", "C:\SomeName.txt" ) 
 *
 */
DropFiles(window, files*)
{
	for k,v in files
	  memRequired+=StrLen(v)+1
	hGlobal := DllCall("GlobalAlloc", "uint", 0x42, "ptr", memRequired+21)
	dropfiles := DllCall("GlobalLock", "ptr", hGlobal)
	NumPut(offset := 20, dropfiles+0, 0, "uint")
	for k,v in files
	  StrPut(v, dropfiles+offset, "utf-8"), offset+=StrLen(v)+1
	DllCall("GlobalUnlock", "ptr", hGlobal)
	PostMessage, 0x233, hGlobal, 0,, %window%
	
	if ErrorLevel
	  DllCall("GlobalFree", "ptr", hGlobal)
}

/** string $maxscript_file path to maxscript file
 *	
 */
$maxscript_file	= %1%



WinActivate, ahk_class 3DSMAX
DropFiles("ahk_class 3DSMAX", $maxscript_file )	; Max 2016