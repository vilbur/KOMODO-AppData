# MarkdownLinker  

* Search in file tree of current file, and write links to files matching criteria  

* It allows mass creation of links in markdown file  

------------------------------------------------------------------------------------  

## USE TO IMPORT:  

### Names of Files & Folders  
### Links to Files & Folders  
### Folders  
### File content as code block  
### Images  

------------------------------------------------------------------------------------  

## EXAMPLES OF CONFIGURATION  
[include:\Test\MarkdownLinkerTest.komodotool]  

------------------------------------------------------------------------------------  


## RESULT RENDERED IN MARKDOWN  

## Include codeblock  
[include:\Test\TestFolders\MainA\MainA.ahk]  


## Links to files & folders  

* [LibNested](Test/TestFolders/Lib/LibNested)  
  * [LibNestedDeep](Test/TestFolders/Lib/LibNested/Lib/LibNestedDeep)  
* [MainA](Test/TestFolders/MainA)  
  * [SubA](Test/TestFolders/MainA/SubA)  
    * [SubSubA](Test/TestFolders/MainA/SubA/SubSubA)  

## Readme Test  
[Test](Test/readme-source.md)  
[TestFolders](Test/TestFolders/readme-source.md)  


## Links to images  
![MainA suffix](Test/TestFolders/MainA/MainA-suffix.jpg)  
![MainA](Test/TestFolders/MainA/MainA.jpg)  
![SubA](Test/TestFolders/MainA/SubA/SubA.jpg)  

------------------------------------------------------------------------------------  


## RESULT IN SOURCE MARKDOWN FILE  

``` markdown  

## Links to files & folders  
* [LibNested](Test/TestFolders/Lib/LibNested)  
  * [LibNestedDeep](Test/TestFolders/Lib/LibNested/Lib/LibNestedDeep)  
* [MainA](Test/TestFolders/MainA)  
  * [SubA](Test/TestFolders/MainA/SubA)  
    * [SubSubA](Test/TestFolders/MainA/SubA/SubSubA)  

## Readme Test  
[Test](Test/readme-source.md)  
[TestFolders](Test/TestFolders/readme-source.md)  

## Links to images  
![MainA suffix](Test/TestFolders/MainA/MainA-suffix.jpg)  
![MainA](Test/TestFolders/MainA/MainA.jpg)  
![SubA](Test/TestFolders/MainA/SubA/SubA.jpg)  

```  
  