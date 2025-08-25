# MarkdownLinker  * Search in file tree of current file, and write links to files matching criteria  * It allows mass creation of links in markdown file  ------------------------------------------------------------------------------------  ## USE TO IMPORT:  ### Names of Files & Folders  ### Links to Files & Folders  ### Folders  ### File content as code block  ### Images  ------------------------------------------------------------------------------------  ## EXAMPLES OF CONFIGURATION  
``` javascript
/** Loop all subdirs
 *  Find all files which name is same as folder name E.G.: "FooBar\FooBar.php"
 *  Links indented
 *  Links to directories
 *
 * Search extension is recognized from search_extensions variable
 */
function includeFileTreeLinks()
{
	new ko.extensions.vilbur.markdown.MarkdownLinker()
			//.matchDirName()
			//.linkToDir()			
			.searchExt('ms')
			.indentation(' ')
			.textBy('file')
			.heading()
			.update()
			.include();
}

includeFileTreeLinks();

/* ===================================================================================================== */ 


/** Search files with name matching '-source' with extension 'md' in main directory
 */
function searchByNameWithMaxLevelTest()
{
	new ko.extensions.vilbur.markdown.MarkdownLinker()
			.searchName('.*-source')
			.searchExt('md')
			.maxLevel(1)
			.heading('Readme Test')
			.include();
}

searchByNameWithMaxLevelTest();


/* ===================================================================================================== */ 

/** Search images named as folder with any suffix
 *  In 4 level of subfolders
 *  Link text by filename
*/
function searchImagesWithAnySuffix()
{
	new ko.extensions.vilbur.markdown.MarkdownLinker()
			.searchExt('jpg')
			.matchDirName('prefix')
			.textBy('file')
			.maxLevel(4)
			.unique() // include only if not in file allready
			.heading('Images Test')
			.include();
}

searchImagesWithAnySuffix();

/* ===================================================================================================== */ 

/*
 *
 */
function searchCodeFilesAndIncludeAsDocblockLinks()
{
	new ko.extensions.vilbur.markdown.MarkdownLinker()
			.searchExt('php|ahk')
			.codeBlock()										
			.matchDirName()
			.maxLevel(2)
			.heading('Codeblock Test')
			.include();
}

searchCodeFilesAndIncludeAsDocblockLinks();
```  ------------------------------------------------------------------------------------  
## RESULT RENDERED IN MARKDOWN  ## Include codeblock  
``` php
/** MainA */Class MainA{}
```  ## Links to files & folders  * [LibNested](Test/TestFolders/Lib/LibNested)    * [LibNestedDeep](Test/TestFolders/Lib/LibNested/Lib/LibNestedDeep)  * [MainA](Test/TestFolders/MainA)    * [SubA](Test/TestFolders/MainA/SubA)      * [SubSubA](Test/TestFolders/MainA/SubA/SubSubA)  ## Readme Test  [Test](Test/readme-source.md)  [TestFolders](Test/TestFolders/readme-source.md)  ## Links to images  ![MainA suffix](Test/TestFolders/MainA/MainA-suffix.jpg)  ![MainA](Test/TestFolders/MainA/MainA.jpg)  ![SubA](Test/TestFolders/MainA/SubA/SubA.jpg)  ------------------------------------------------------------------------------------  ## RESULT IN SOURCE MARKDOWN FILE  ``` markdown  ## Links to files & folders  * [LibNested](Test/TestFolders/Lib/LibNested)    * [LibNestedDeep](Test/TestFolders/Lib/LibNested/Lib/LibNestedDeep)  * [MainA](Test/TestFolders/MainA)    * [SubA](Test/TestFolders/MainA/SubA)      * [SubSubA](Test/TestFolders/MainA/SubA/SubSubA)  ## Readme Test  [Test](Test/readme-source.md)  [TestFolders](Test/TestFolders/readme-source.md)  ## Links to images  ![MainA suffix](Test/TestFolders/MainA/MainA-suffix.jpg)  ![MainA](Test/TestFolders/MainA/MainA.jpg)  ![SubA](Test/TestFolders/MainA/SubA/SubA.jpg)  ```    