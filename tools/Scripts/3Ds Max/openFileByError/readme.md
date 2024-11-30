# Get error file from 3Ds Max and open it in Komodo


1. Execute Open-Macroscript-Exception-In-Komodo.ahk

2. Get filename, line and position

     - A) From maxscript error message
     - B) From maxscript listener

3. Write data to "error-data.json"

4. Execute "goToLineInKomodoIfException.komodotool"

     -> Read "error-data.json"

		* Open ms file with error
		* Go to line of error