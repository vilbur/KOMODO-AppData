#SingleInstance force

/**    CONVERT all *.komodotool files in directory and subdirs TO *.ktf files
  *
  *
  * ----------------------------------------------------------------
  *
  * IMPORTATNT: HOW TO SE LANGUAGE OF SNIPPET
  *
  * Language of snippet is get from this script filename suffix.
  * If suffix is missing then "General" language is used.
  *
  * E.G.:
  *		KomodotoolConvertor_Autohotkey.ahk	>>> "Autohotkey"
  *		KomodotoolConvertor-Maxscript.ahk	>>> "Maxscript"
  *		KomodotoolConvertor Javascript.ahk	>>> "Javascript"
  *		KomodotoolConvertor.ahk	>>> "General"
  *
  * ----------------------------------------------------------------
  */


/*


	THESE DATA ARE CONVERTED:
		name -> komodo tool
		indent_relative
		treat_as_ejs
		indent_relative
		set_selection
		auto_abbreviation
		type

		value	> written after header
*/


/*
   EXAMPLE OF SNIPPET HEADER:

		komodo tool: snipet_name
		================
		language:	Maxscript
		type:	snippet
		treat_as_ejs:	false
		auto_abbreviation:	false
		indent_relative:	true
		set_selection:	false
		is_clean:	true
		version:	1.1.5
		================
 */


/*
	GET SNIPPET LANGUAGE
*/
global $SNIPPET_LANGUAGE

SplitPath, A_LineFile,,,, $filename

StringSplit, $filename_split, $filename, "_- "

if ($filename_split2 == "")
	$SNIPPET_LANGUAGE := "General"
else
	$SNIPPET_LANGUAGE := $filename_split2

/*
	LOOP KOMODOTOOLS IN FOLDER
*/
Loop, Files, *.komodotool, R
{
	;MsgBox,262144,A_LoopFileLongPath, %A_LoopFileLongPath%,3

    $ktf_data := convertKomodotoolFile(A_LoopFileLongPath)
	;MsgBox,262144,ktf_data, %$ktf_data%,3

    SplitPath, A_LoopFileLongPath,,$directory,, $filename

	$ktf_file := $directory "\\" $filename ".ktf"

	FileDelete, % $ktf_file ;;; AVOID CREATE *.ktf FILE AGAIN

	FileDelete, % A_LoopFileLongPath ;;; DELETE old .komodotool FILE

	FileAppend, % $ktf_data, % $ktf_file
}



MsgBox,262144, SUCCESS, Conversion successed,3


/* convert komodotool file to kft

*/
convertKomodotoolFile($path)
{
	FileRead, $file, % $path

	$komodotool_data := Jxon_Load( "[" $file "]" )[1]

	If ($komodotool_data.treat_as_ejs == 1)
		$komodotool_data.treat_as_ejs := "true"
	else
		$komodotool_data.treat_as_ejs := "false"

	;$result .= "/*"
	$result .= "`nkomodo tool: " $komodotool_data.name
	$result .= "`n================"
	$result .= "`nlanguage:	       " $SNIPPET_LANGUAGE
	$result .= "`ntype:              " $komodotool_data.type
	$result .= "`ntreat_as_ejs:      " $komodotool_data.treat_as_ejs
	$result .= "`nauto_abbreviation: " $komodotool_data.auto_abbreviation
	$result .= "`nindent_relative:   " $komodotool_data.indent_relative
	$result .= "`nset_selection:     " $komodotool_data.set_selection
	$result .= "`nis_clean:          true"
	$result .= "`nversion:           1.1.5"

	;$result .= "`n================*/"
	$result .= "`n================"

	for each, $line in $komodotool_data.value
		$result .= "`n" $line

	return $result
}



; -------------------------------------------------------------------------------------------------------------------------
; Coco's Jxon_Load function: https://github.com/cocobelgica/AutoHotkey-JSON/blob/master/Jxon.ahk
Jxon_Load(ByRef src, args*)
{
	static q := Chr(34)

	key := "", is_key := false
	stack := [ tree := [] ]
	is_arr := { (tree): 1 }
	next := q . "{[01234567890-tfn"
	pos := 0
	while ( (ch := SubStr(src, ++pos, 1)) != "" )
	{
		if InStr(" `t`n`r", ch)
			continue
		if !InStr(next, ch, true)
		{
			ln := ObjLength(StrSplit(SubStr(src, 1, pos), "`n"))
			col := pos - InStr(src, "`n",, -(StrLen(src)-pos+1))

			msg := Format("{}: line {} col {} (char {})"
			,   (next == "")      ? ["Extra data", ch := SubStr(src, pos)][1]
			  : (next == "'")     ? "Unterminated string starting at"
			  : (next == "\")     ? "Invalid \escape"
			  : (next == ":")     ? "Expecting ':' delimiter"
			  : (next == q)       ? "Expecting object key enclosed in double quotes"
			  : (next == q . "}") ? "Expecting object key enclosed in double quotes or object closing '}'"
			  : (next == ",}")    ? "Expecting ',' delimiter or object closing '}'"
			  : (next == ",]")    ? "Expecting ',' delimiter or array closing ']'"
			  : [ "Expecting JSON value(string, number, [true, false, null], object or array)"
			    , ch := SubStr(src, pos, (SubStr(src, pos)~="[\]\},\s]|$")-1) ][1] 							;"
			, ln, col, pos)

			throw Exception(msg, -1, ch)
		}

		is_array := is_arr[obj := stack[1]]

		if i := InStr("{[", ch)
		{
			val := (proto := args[i]) ? new proto : {}
			is_array? ObjPush(obj, val) : obj[key] := val
			ObjInsertAt(stack, 1, val)

			is_arr[val] := !(is_key := ch == "{")
			next := q . (is_key ? "}" : "{[]0123456789-tfn")
		}

		else if InStr("}]", ch)
		{
			ObjRemoveAt(stack, 1)
			next := stack[1]==tree ? "" : is_arr[stack[1]] ? ",]" : ",}"
		}

		else if InStr(",:", ch)
		{
			is_key := (!is_array && ch == ",")
			next := is_key ? q : q . "{[0123456789-tfn"
		}

		else ; string | number | true | false | null
		{
			if (ch == q) ; string
			{
				i := pos
				while i := InStr(src, q,, i+1)
				{
					val := StrReplace(SubStr(src, pos+1, i-pos-1), "\\", "\u005C")
					static end := A_AhkVersion<"2" ? 0 : -1
					if (SubStr(val, end) != "\") ;;; "
						break
				}
				if !i ? (pos--, next := "'") : 0
					continue

				pos := i ; update pos

				  val := StrReplace(val,    "\/",  "/")
				, val := StrReplace(val, "\" . q,    q)
				, val := StrReplace(val,    "\b", "`b")
				, val := StrReplace(val,    "\f", "`f")
				, val := StrReplace(val,    "\n", "`n")
				, val := StrReplace(val,    "\r", "`r")
				, val := StrReplace(val,    "\t", "`t")

				i := 0
				while i := InStr(val, "\",, i+1)
				{
					if (SubStr(val, i+1, 1) != "u") ? (pos -= StrLen(SubStr(val, i)), next := "\") : 0
						continue 2

					; \uXXXX - JSON unicode escape sequence
					xxxx := Abs("0x" . SubStr(val, i+2, 4))
					if (A_IsUnicode || xxxx < 0x100)
						val := SubStr(val, 1, i-1) . Chr(xxxx) . SubStr(val, i+6)
				}

				if is_key
				{
					key := val, next := ":"
					continue
				}
			}

			else ; number | true | false | null
			{
				val := SubStr(src, pos, i := RegExMatch(src, "[\]\},\s]|$",, pos)-pos)

			; For numerical values, numerify integers and keep floats as is.
			; I'm not yet sure if I should numerify floats in v2.0-a ...
				static number := "number", integer := "integer"
				if val is %number%
				{
					if val is %integer%
						val += 0
				}
			; in v1.1, true,false,A_PtrSize,A_IsUnicode,A_Index,A_EventInfo,
			; SOMETIMES return strings due to certain optimizations. Since it
			; is just 'SOMETIMES', numerify to be consistent w/ v2.0-a
				else if (val == "true" || val == "false")
					val := %value% + 0
			; AHK_H has built-in null, can't do 'val := %value%' where value == "null"
			; as it would raise an exception in AHK_H(overriding built-in var)
				else if (val == "null")
					val := ""
			; any other values are invalid, continue to trigger error
				else if (pos--, next := "#")
					continue

				pos += i-1
			}

			is_array? ObjPush(obj, val) : obj[key] := val
			next := obj==tree ? "" : is_array ? ",]" : ",}"
		}
	}

	return tree[1]
}