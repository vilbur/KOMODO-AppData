# MarkdownLinker  
* Search in tree of current file, and write links to files matching criteria  


## Examples  
[include:\Test\MarkdownLinkerTest.komodotool]  


------------------------------------------------------------------------------------  
------------------------------------------------------------------------------------  

## RESULT IN SOURCE OF MARKDOWN FILE  

``` markdown  

## Structure Test  
* [LibNested](Test/TestFolders/Lib/LibNested)  
  * [LibNestedDeep](Test/TestFolders/Lib/LibNested/Lib/LibNestedDeep)  
* [MainA](Test/TestFolders/MainA)  
  * [SubA](Test/TestFolders/MainA/SubA)  
    * [SubSubA](Test/TestFolders/MainA/SubA/SubSubA)  

## Readme Test  
[Test](Test/readme-source.md)  
[TestFolders](Test/TestFolders/readme-source.md)  

## Images Test  
![MainA suffix](Test/TestFolders/MainA/MainA-suffix.jpg)  
![MainA](Test/TestFolders/MainA/MainA.jpg)  
![SubA](Test/TestFolders/MainA/SubA/SubA.jpg)  

## Codeblock Test  
[include :\Test\TestFolders\MainA\MainA.ahk]  

```  


------------------------------------------------------------------------------------  
------------------------------------------------------------------------------------  

## RESULT RENDERED  


## Structure Test  

* [LibNested](Test/TestFolders/Lib/LibNested)  
  * [LibNestedDeep](Test/TestFolders/Lib/LibNested/Lib/LibNestedDeep)  
* [MainA](Test/TestFolders/MainA)  
  * [SubA](Test/TestFolders/MainA/SubA)  
    * [SubSubA](Test/TestFolders/MainA/SubA/SubSubA)  

## Readme Test  
[Test](Test/readme-source.md)  
[TestFolders](Test/TestFolders/readme-source.md)  

## Images Test  
![MainA suffix](Test/TestFolders/MainA/MainA-suffix.jpg)  
![MainA](Test/TestFolders/MainA/MainA.jpg)  
![SubA](Test/TestFolders/MainA/SubA/SubA.jpg)  

## Codeblock Test  
[include:\Test\TestFolders\MainA\MainA.ahk]  
  