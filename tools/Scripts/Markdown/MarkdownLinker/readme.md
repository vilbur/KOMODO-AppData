# MarkdownLinker  * Search in file tree of current file, and write links to files matching criteria  * It allows mass creation of links in markdown file  ------------------------------------------------------------------------------------  ## USE TO IMPORT:  ### Names of Files & Folders  ### Links to Files & Folders  ### Folders  ### File content as code block  ### Images  ------------------------------------------------------------------------------------  # EXAMPLES OF CONFIGURATION  ------------------------------------------------------------------------------------  # CODE BLOCK  ## SETUP  
``` javascript
/* Search for 'php|ahk' files and include files contents * */(function searchCodeFilesAndIncludeAsDocblockLinks(){	new ko.extensions.vilbur.markdown.MarkdownLinker()			.searchExt('php|ahk')			.codeBlock()	// IMPORT CONTENT AS CODEBLOCK												.matchDirName()			.heading('Codeblock Test')			.include();})();
```  
## MARKDOWN COMPILED  ``` markdown  ;[include:\Test\includeFileContentToCodeBlock.ktf]  
```  
## RESULT  ## Codeblock Test  
``` php
/** LibNestedFolder * */Class LibNestedFolder{}
```  ------------------------------------------------------------------------------------  ## SETUP  
``` javascript
/* Clear Console */document.getElementById('console-widget').contentWindow.document.getElementById('output').innerHTML = '';/** Inclue links to files and folders in hierarchy * * Search extension is recognized from search_extensions variable */(function includeFileTreeLinks(){	new ko.extensions.vilbur.markdown.MarkdownLinker()			//.matchDirName() // include only files which pranet folder is same as filename E.G.: '\Foo\foo.ms'			//.linkToDir()						//.searchExt('md')			.searchExt('.*')			.indentation(' ')			//.maxLevel( 0 )			//.maxLevel( 2 )			.textBy('file') // display text by "file|dir"			.heading()			.update()			.include();})();  
```  
* [Readme source](Test/readme-source.md)  
* [Readme](Test/readme.md)  
  * [Include test](Test/TestFolders/include_test.md)  
    * [Include test](Test/TestFolders/Lib/include_test.md)  
## MARKDOWN COMPILED  ``` markdown  
```  ## RESULT  ## Codeblock Test  
``` php
/** LibNestedFolder * */Class LibNestedFolder{}
```  ------------------------------------------------------------------------------------  # IMAGES  ## SETUP  
``` javascript
/** Search images named as folder with any suffix *  In 4 level of subfolders *  Link text by filename*/(function linkImagesTest(){	new ko.extensions.vilbur.markdown.MarkdownLinker()			.searchExt('jpg')			.matchDirName('prefix')			.textBy('file')			.maxLevel(4)			.unique() // include only if not in file allready			.include();})();
```  ## MARKDOWN COMPILED  ``` markdown  ;![MainA suffix](Test/TestFolders/MainA/MainA-suffix.jpg)  ;![MainA](Test/TestFolders/MainA/MainA.jpg)  ;![SubA](Test/TestFolders/MainA/SubA/SubA.jpg)  ```  ## RESULT  ![MainA suffix](Test/TestFolders/MainA/MainA-suffix.jpg)  ![MainA](Test/TestFolders/MainA/MainA.jpg)  ![SubA](Test/TestFolders/MainA/SubA/SubA.jpg)  
* [](.folderdata)  
* [MarkdownLinker](MarkdownLinker.komodotool)  
* [MarkdownLinkerTest](MarkdownLinkerTest.komodotool)  
* [New AutoHotkey Script](New AutoHotkey Script.ahk)  
* [Readme](readme.md)  
* [Test](Test)  
## RESULT IN SOURCE MARKDOWN FILE  ``` markdown  ## Links to files & folders  * [LibNested](Test/TestFolders/Lib/LibNested)    * [LibNestedDeep](Test/TestFolders/Lib/LibNested/Lib/LibNestedDeep)  * [MainA](Test/TestFolders/MainA)    * [SubA](Test/TestFolders/MainA/SubA)      * [SubSubA](Test/TestFolders/MainA/SubA/SubSubA)  ## Readme Test  [Test](Test/readme-source.md)  [TestFolders](Test/TestFolders/readme-source.md)  ## Links to images  ![MainA suffix](Test/TestFolders/MainA/MainA-suffix.jpg)  ![MainA](Test/TestFolders/MainA/MainA.jpg)  ![SubA](Test/TestFolders/MainA/SubA/SubA.jpg)  ## TEST OF EXCLUDED LINK  ;[include:\Test\MarkdownLinkerTest.komodotool]  ```    