# MarkdownLinker  * Search in tree of current file, and write links to files matching criteria  ## Examples  
``` javascript
/** Loop all subdirs
 *  Find all files which name is same as folder name E.G.: "FooBar\FooBar.php"
 *  Links indented
 *  Links to directories
 *
 * Search extension is recognized from search_extensions variable
 */
function includeFileStructureTest()
{
	new ko.extensions.vilbur.markdown.MarkdownLinker()
			.matchDirName()
			.linkToDir()			
			.indentation(' ')
			.heading('Structure Test')
			.update()
			.include();
}

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

/*---------------------------------------
	RUN TEST
-----------------------------------------
*/
includeFileStructureTest();
searchByNameWithMaxLevelTest();
searchImagesWithAnySuffix();
searchCodeFilesAndIncludeAsDocblockLinks();
```  ------------------------------------------------------------------------------------  ------------------------------------------------------------------------------------  ## RESULT IN SOURCE OF MARKDOWN FILE  ``` markdown  ## Structure Test  
* [LibNested](Test/TestFolders/Lib/LibNested)  
  * [LibNestedDeep](Test/TestFolders/Lib/LibNested/Lib/LibNestedDeep)  
* [MainA](Test/TestFolders/MainA)  
  * [SubA](Test/TestFolders/MainA/SubA)  
    * [SubSubA](Test/TestFolders/MainA/SubA/SubSubA)  ## Readme Test  
[Test](Test/readme-source.md)  
[TestFolders](Test/TestFolders/readme-source.md)  ## Images Test  
![MainA suffix](Test/TestFolders/MainA/MainA-suffix.jpg)  
![MainA](Test/TestFolders/MainA/MainA.jpg)  
![SubA](Test/TestFolders/MainA/SubA/SubA.jpg)  ## Codeblock Test  
[include :\Test\TestFolders\MainA\MainA.ahk]  ```  ------------------------------------------------------------------------------------  ------------------------------------------------------------------------------------  ## RESULT RENDERED  ## Structure Test  * [LibNested](Test/TestFolders/Lib/LibNested)    * [LibNestedDeep](Test/TestFolders/Lib/LibNested/Lib/LibNestedDeep)  * [MainA](Test/TestFolders/MainA)    * [SubA](Test/TestFolders/MainA/SubA)      * [SubSubA](Test/TestFolders/MainA/SubA/SubSubA)  ## Readme Test  [Test](Test/readme-source.md)  [TestFolders](Test/TestFolders/readme-source.md)  ## Images Test  ![MainA suffix](Test/TestFolders/MainA/MainA-suffix.jpg)  ![MainA](Test/TestFolders/MainA/MainA.jpg)  ![SubA](Test/TestFolders/MainA/SubA/SubA.jpg)  ## Codeblock Test  
``` php
/** MainA */Class MainA{}
```    