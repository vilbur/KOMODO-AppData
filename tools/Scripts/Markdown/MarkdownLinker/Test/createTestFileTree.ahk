; Script to create directory hierarchy: grandparent -> parent -> child -> grandchild
; In each directory, create files with same name as directory + extensions: .ahk, .md, .js
; Each file will have short fake text content for mockup testing

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

/*
Function: createDirWithFiles
Creates directory if not exists and files with extensions ahk, md, js
Writes short fake text content inside each file.
*/
createDirWithFiles(path, name)
{
    if !FileExist(path)
        FileCreateDir, %path%
    
    fileList := [".ahk", ".md", ".js"]
    for i, ext in fileList
    {
        filePath := path "\" name ext
        if !FileExist(filePath)
        {
            if (ext = ".ahk")
                FileAppend, "; Mockup script for %name%`nMsgBox, This is %name%.ahk`n", %filePath%
            else if (ext = ".md")
                FileAppend, "# %name% Documentation`n`nSome fake text for %name%.md file.`n", %filePath%
            else if (ext = ".js")
                FileAppend, "// Mockup JavaScript for %name%`nconsole.log('This is %name%.js');`n", %filePath%
        }
    }
    ; return
}

; Base folder in script directory
baseDir := A_ScriptDir "\Test-Directory"
createDirWithFiles(baseDir, "Test-Directory")

; Parent
parentDir := baseDir "\Parent"
createDirWithFiles(parentDir, "Parent")

; Child
childDir := parentDir "\Child"
createDirWithFiles(childDir, "Child")

; Grandchild
grandchildDir := childDir "\GrandChild"
createDirWithFiles(grandchildDir, "GrandChild")

MsgBox, File hierarchy with mockup text created successfully!
