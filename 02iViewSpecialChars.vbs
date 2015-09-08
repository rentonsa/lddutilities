'------------------------------------------------------
'------------------------------------------------------
'--Post-XSLT Special Character Removal
'------------------------------------------------------
'--Date: 		Jan 2011 
'--Author:      Scott Renton
'--Purpose:     iView XML is converted to a Vernon-loadable
'--				format in XSLT. Global replaces of special
'--    			characters need to be performed in a separate
'--				script, without which the Vernon XML import
'--				will certainly fall over.
'--				This script will inevitably grow as needed,
'--				although the lack of involved descriptive 
'--				metadata in iView.
'--------------------------------------------------------
'--------------------------------------------------------

Option Explicit
Dim objFSO
Dim objInFile
Dim objLogFile
Dim objOutFile
Dim objRefFile
Dim strDirectory
Dim strFileNo
Dim strFileNoAmended
Dim strInFile
Dim strOutFile
Dim strRefFile
Dim strLog
Dim strAmended
Dim strReadLineNext
Dim a
Dim i
Dim strFolder 
Dim strPreNumbers
Dim strLeftTag
Dim strRightTag
Dim strJpg
Dim strFullNo
Dim strTif
Dim writeBoolean
Dim strAccNo
Dim strReadLineRef
Dim strReadLineZero
Dim strRightTagPos
Dim strLeftTagPos
Dim strFullNoFirst
Dim strFormat
Dim strCreated
Dim strDay
Dim strMonth
Dim strYear
Dim intPeopleCount
Dim intKeywordCount
Dim fixtureBoolean
Dim gtPos

'Declare file directory
strDirectory 	= "K:\dld\MIMS Project\Development\MIMSWorkflow\"

'Assign files
strInFile 	= "iView.xml"
strOutFile 	= "vernonIn.xml"
strLog 		= "Log.txt"
strRefFile 	= "iViewWeedList.txt"
i 			= 0
a 			= ""

' Create the File System Object
Set objFSO 		= CreateObject("Scripting.FileSystemObject")
Set objLogFile 	= objFSO.CreateTextFile(strDirectory & strLog)
Set objOutFile 	= objFSO.CreateTextFile(strDirectory & strOutFile)
Set objInFile 	= objFSO.OpenTextFile(strDirectory & strInFile)

objLogFile.writeLine("Opened XML FIle")
intPeopleCount = 0
intKeywordCount = 0
writeBoolean = "Y"
'Loop through file
Do While Not objInFile.AtEndOfStream
	
	'Read each line
	strReadLineNext = objInFile.ReadLine
	'Check for string
	objLogFile.WriteLine(writeBoolean)
	If InStr(strReadLineNext, "/MediaItem>") Then 
		strReadLineNext = "</MediaItem>"
		intPeopleCount = 0
		intKeywordCount = 0
		fixtureBoolean = "N"
	End If 
	
	If InStr(strReadLineNext,"Tableau du Climat") Then
		MsgBox strReadLineNext
	End If
	strReadLineNext = Replace(strReadLineNext,"€","&#128;")
	strReadLineNext = Replace(strReadLineNext,"ƒ","&#131;") 
	strReadLineNext = 	Replace(strReadLineNext,"…","&#133;")
	strReadLineNext = 	Replace(strReadLineNext,"†","&#134;")
	strReadLineNext = 	Replace(strReadLineNext,"‡","&#135;") 
	strReadLineNext = 	Replace(strReadLineNext,"ˆ","&#136;")
	strReadLineNext = 	Replace(strReadLineNext,"‰","&#137;")
	strReadLineNext = 	Replace(strReadLineNext,"Š","&#138;")
	strReadLineNext = 	Replace(strReadLineNext,"Œ","&#140;")
	strReadLineNext = Replace(strReadLineNext,"Ž","&#142;")
	strReadLineNext = Replace(strReadLineNext,"™","&#153;")
	strReadLineNext = Replace(strReadLineNext,"š","&#154;")
	strReadLineNext = Replace(strReadLineNext,"œ","&#156;") 
	strReadLineNext = Replace(strReadLineNext,"ž ","&#158;") 
	strReadLineNext = Replace(strReadLineNext,"Ÿ","&#159;") 
	strReadLineNext = Replace(strReadLineNext,"¡","&#161;") 
	strReadLineNext = Replace(strReadLineNext,"¢","&#162;") 
	strReadLineNext = Replace(strReadLineNext,"£","&#163;")
	strReadLineNext = Replace(strReadLineNext,"¤","&#164;")
	strReadLineNext = Replace(strReadLineNext,"¥","&#165;")
	strReadLineNext = Replace(strReadLineNext,"¦","&#166;") 
	strReadLineNext = Replace(strReadLineNext,"§","&#167;") 
	strReadLineNext = Replace(strReadLineNext,"¨","&#168;") 
	strReadLineNext = Replace(strReadLineNext,"©","&#169;")  
	strReadLineNext = Replace(strReadLineNext,"ª","&#170;")  
	strReadLineNext = Replace(strReadLineNext,"«","&#171;") 
	strReadLineNext = Replace(strReadLineNext,"¬","&#172;")  
	strReadLineNext = Replace(strReadLineNext,"­","&#173;")  
	strReadLineNext = Replace(strReadLineNext,"®","&#174;")  
	strReadLineNext = Replace(strReadLineNext,"¯","&#175;")  
	strReadLineNext = Replace(strReadLineNext,"°","&#176;")  
	strReadLineNext = Replace(strReadLineNext,"±","&#177;")  
	strReadLineNext = Replace(strReadLineNext,"²","&#178;")  
	strReadLineNext = Replace(strReadLineNext,"³","&#179;")  
	strReadLineNext = Replace(strReadLineNext,"´","&#180;")  
	strReadLineNext = Replace(strReadLineNext,"µ","&#181;")  
	strReadLineNext = Replace(strReadLineNext,"¶","&#182;")  
	strReadLineNext = Replace(strReadLineNext,"·","&#183;") 
	strReadLineNext = Replace(strReadLineNext,"¸","&#184;")  
	strReadLineNext = Replace(strReadLineNext,"¹","&#185;")  
	strReadLineNext = Replace(strReadLineNext,"º","&#186;") 
	strReadLineNext = Replace(strReadLineNext,"»","&#187;") 
	strReadLineNext = Replace(strReadLineNext,"¼","&#188;")  
	strReadLineNext = Replace(strReadLineNext,"½","&#189;")  
	strReadLineNext = Replace(strReadLineNext,"¾","&#190;") 
	strReadLineNext = Replace(strReadLineNext,"¿","&#191;") 
	strReadLineNext = Replace(strReadLineNext,"À","&#192;") 
	strReadLineNext = Replace(strReadLineNext,"Á","&#193;")
	strReadLineNext = Replace(strReadLineNext,"Â","&#194;") 
	strReadLineNext = Replace(strReadLineNext,"Ã","&#195;") 
	strReadLineNext = Replace(strReadLineNext,"Ä","&#196;") 
	strReadLineNext = Replace(strReadLineNext,"Å","&#197;") 
	strReadLineNext = Replace(strReadLineNext,"Æ","&#198;") 
	strReadLineNext = Replace(strReadLineNext,"Ç","&#199;")
	strReadLineNext = Replace(strReadLineNext,"È","&#200;") 
	strReadLineNext = Replace(strReadLineNext,"É","&#201;") 
	strReadLineNext = Replace(strReadLineNext,"Ë","&#203;")
	strReadLineNext = Replace(strReadLineNext,"Ì","&#204;") 
	strReadLineNext = Replace(strReadLineNext,"Í","&#205;") 
	strReadLineNext = Replace(strReadLineNext,"Î","&#206;")  
	strReadLineNext = Replace(strReadLineNext,"Ï","&#207;")  
	strReadLineNext = Replace(strReadLineNext,"Ð","&#208;")  
	strReadLineNext = Replace(strReadLineNext,"Ñ","&#209;") 
	strReadLineNext = Replace(strReadLineNext,"Ò","&#210;") 
	strReadLineNext = Replace(strReadLineNext,"Ó","&#211;") 
	strReadLineNext = Replace(strReadLineNext,"Ô","&#212;") 
	strReadLineNext = Replace(strReadLineNext,"Õ","&#213;")  
	strReadLineNext = Replace(strReadLineNext,"Ö","&#214;") 
	strReadLineNext = Replace(strReadLineNext,"×","&#215;") 
	strReadLineNext = Replace(strReadLineNext,"Ø","&#216;") 
	strReadLineNext = Replace(strReadLineNext,"Ù","&#217;") 
	strReadLineNext = Replace(strReadLineNext,"Ú","&#218;")
	strReadLineNext = Replace(strReadLineNext,"Û","&#219;") 
	strReadLineNext = Replace(strReadLineNext,"Ü","&#220;") 
	strReadLineNext = Replace(strReadLineNext,"Ý","&#221;") 
	strReadLineNext = Replace(strReadLineNext,"Þ","&#222;")  
	strReadLineNext = Replace(strReadLineNext,"ß","&#223;") 
	strReadLineNext = Replace(strReadLineNext,"à","&#224;")  
	strReadLineNext = Replace(strReadLineNext,"á","&#225;")  
	strReadLineNext = Replace(strReadLineNext,"â","&#226;")  
	strReadLineNext = Replace(strReadLineNext,"ã","&#227;")  
	strReadLineNext = Replace(strReadLineNext,"ä","&#228;") 
	strReadLineNext = Replace(strReadLineNext,"å","&#229;")  
	strReadLineNext = Replace(strReadLineNext,"æ","&#230;")  
	strReadLineNext = Replace(strReadLineNext,"ç","&#231;")  
	strReadLineNext = Replace(strReadLineNext,"è","&#232;")  
	strReadLineNext = Replace(strReadLineNext,"é","&#233;") 
	strReadLineNext = Replace(strReadLineNext,"ê","&#234;")  
	strReadLineNext = Replace(strReadLineNext,"ë","&#235;")  
	strReadLineNext = Replace(strReadLineNext,"ì","&#236;") 
	strReadLineNext = Replace(strReadLineNext,"í","&#237;") 
	strReadLineNext = Replace(strReadLineNext,"î","&#238;")  
	strReadLineNext = Replace(strReadLineNext,"ï","&#239;")  
	strReadLineNext = Replace(strReadLineNext,"ð","&#240;")  
	strReadLineNext = Replace(strReadLineNext,"ñ","&#241;")  
	strReadLineNext = Replace(strReadLineNext,"ò","&#242;")
	strReadLineNext = Replace(strReadLineNext,"ó","&#243;")
	strReadLineNext = Replace(strReadLineNext,"ô","&#244;")
	strReadLineNext = Replace(strReadLineNext,"õ","&#245;")
	strReadLineNext = Replace(strReadLineNext,"ö","&#246;")
	strReadLineNext = Replace(strReadLineNext,"÷","&#247;")
	strReadLineNext = Replace(strReadLineNext,"ø","&#248;")
	strReadLineNext = Replace(strReadLineNext,"ù","&#249;")
	strReadLineNext = Replace(strReadLineNext,"ú","&#250;")
	strReadLineNext = Replace(strReadLineNext,"û","&#251;") 
	strReadLineNext = Replace(strReadLineNext,"ü","&#252;") 
	strReadLineNext = Replace(strReadLineNext,"ý","&#253;") 
	strReadLineNext = Replace(strReadLineNext,"þ","&#254;") 
	strReadLineNext = Replace(strReadLineNext,"ÿ","&#255;")
	strReadLineNext = Replace(strReadLineNext,"c&#184;","&#231;")
	strReadLineNext = Replace(strReadLineNext,"e&#204;","&#233;")
	strReadLineNext = Replace(strReadLineNext,"e&#204;","&#233;")
	If InStr(strReadLineNext, "Copyright") Then
		'Identify replacement string and run replacement
		strAmended= ReplaceTest("Copyright ", "&#169; ", strReadLineNext)
		strReadLineNext = strAmended
		If InStr(strReadLineNext, "<Copyright/>")  Then
			strReadLineNext = "<Copyright>&#169; The University of Edinburgh</Copyright>"
		End If
	End If
	
	If InStr(strReadLineNext, "<Filename>") Then 
		objLogFile.WriteLine(strReadLineNext)
		strRightTagPos = InStr(strReadLineNext,">")
		strFullNo = Mid(strReadLineNext, strRightTagPos + 1, 13)
		strLeftTagPos = InStr(strFullNo,"<")
		strFullNo = Mid (strFullNo, 1, strLeftTagPos -1)
		strPreNumbers = Mid (strFullNo, 1,4)
		strFormat = Mid (strFullNo, 10,3)
		If strFormat = "tif" Then
			strFormat = "tiff"
		End If
		strFullNo =Mid(strFullNo, 1,8)
		strJpg = ".jpg"
		strFolder = strpreNumbers & "000-" & strpreNumbers & "999\"
		strAccNo = Mid(strFullNo,1,7)
		objLogFile.WriteLine(strAccNo)
		Set objRefFile 	= objFSO.OpenTextFile(strDirectory & strRefFile)
		Do While Not objRefFile.AtEndOfStream
			strReadLineRef = objRefFile.ReadLine
			If strReadLineRef = strAccNo Then
				objLogFile.WriteLine("found a match" & strReadLineRef)
				writeBoolean = "N"
			End If
		Loop
		
		strReadLineNext = "<MediaItem>" & Chr(10) & "<Filename>" & strFolder & strFullNo & strJpg & "</Filename>" & Chr(10) & "<Format>" & UCase(strFormat) & "</Format>"	 
		'strReadLineNext = Replace(strReadLineNext,strTif, strJpg)
	End If
	
	If InStr(strReadLineNext, "UserField_1>") Then
		'A special case- strip down the value to 7 characters
		strRightTagPos = InStr(strReadLineNext,">")
		strRightTag = Mid(strReadLineNext, strRightTagPos + 1, 13)
		objLogFile.WriteLine("Right Tag " & strRightTag)
		strLeftTagPos = InStr(strRightTag,"<")
		objLogFile.WriteLine ("Left Tag Pos " & strLeftTagPos)
		strFileNo = Mid (strReadLineNext, strRightTagPos + 1, strLeftTagPos -1)
		objLogFile.WriteLine("FileNo" & strFileNo)
		strFileNoAmended = Mid(strFileNo, 1,7)
		objLogFile.WriteLine("File No Amended" & strFileNoAmended)
		strReadLineNext = Replace(strReadLineNext, strFileNo, strFileNoAmended)
		objLogFile.WriteLine("StrReadLineNext" & strReadLineNext)
	End If
	
	If InStr(strReadLineNext, " = ") Then
		strReadLineNext = Replace(strReadLineNext, " = ", "=")
	End If
	
	If InStr(strReadLineNext, " =") Then
		strReadLineNext = Replace(strReadLineNext, " =", "=")
	End If
	
	If InStr(strReadLineNext, "= ") Then
		strReadLineNext = Replace(strReadLineNext, "= ", "=")
	End If
	
	If InStr(strReadLineNext, "&apos;") Then
		strReadLineNext = Replace(strReadLineNext, "&apos;", "'")
	End If
	
	If InStr(strReadLineNext, "&amp;") Then
		strReadLineNext = Replace(strReadLineNext, "&amp;", "&#38;")
	End If
	
	If InStr(strReadLineNext, Chr(34)) And InStr(strReadLineNext, "<?xml") = 0 Then
		strReadLineNext = Replace(strReadLineNext, Chr(34), "&#34;")
	End If
	
	If InStr(strReadLineNext, "<People>") Then
		objLogFile.writeLine(" A People Line: " & strReadLineNext)
		intPeopleCount = intPeopleCount + 1
		objLogFile.writeLine(" Count: " & intPeopleCount)
		strReadLineNext =Replace(strReadLineNext,">", intpeopleCount & ">")
		objLogFile.writeLine(" It Is Now: " & strReadLineNext)
	End If
	
	If InStr(strReadLineNext, "<Keyword>") Then
		intKeywordCount = intKeywordCount + 1
		strReadLineNext =Replace(strReadLineNext,">", intKeywordCount & ">")
	End If
	
	If InStr(strReadLineNext, "<Fixture>") Then
		objLogFile.WriteLine("A Fixture!" & strReadLineNext)
		fixtureBoolean = "Y"
	End If
	
	'			if instr(strReadLineNext, "<Created>") Then
	'				strLeftTag = "<Created>"
	'				strRightTag = "</Created>"
	'				strLeftTagPos = instr(strReadLineNext,">")
	'				strCreated = Mid(strReadLineNext,strLeftTagPos + 1, 10)
	'				strDay = Mid(strCreated,9,2)
	'				strMonth = Mid(strCreated,6,2)
	'				strYear = Mid(strCreated,1,4)
	'				strReadLineNext = strLeftTag & strDay & "/" & strMonth & "/" & strYear & strRightTag
	'			end if
	
	'		    If InStr(strReadLineNext, "<?xml") Then
	
	'				If instr(strReadLineNext, chr(34)) Then
	
	'					strReadLineNext = replace(strReadLineNext, chr(34), "&#34;")
	'				end If
	'			End If
	If InStr(strReadLineNext, "UserField_15") Then
		If InStr(strReadLineNext, "N") Then
			strReadLineNext = strReadLineNext & Chr(10) & "<General_Flag>Private- Do Not Harvest</General_Flag>"
		End If
	End If			
	If writeBoolean = "Y" Then	
		If InStr(strReadLineNext,"<!") = 0 And InStr(strReadLineNext,"#REQUIRED >") = 0 And InStr (strReadLineNext,"]>") = 0  Then
			If InStr(strReadLineNext, "EventDate>") Then
				If fixtureBoolean = "Y" Then
					gtPos = InStr(strReadLineNext,">")
					objLogFile.WriteLine("Event Date" & strReadLineNext)
					strYear = Mid(strReadLineNext,gtPos + 1,4)
					objLogFile.WriteLine(strYear)
					strMonth = Mid(strReadLineNext,gtPos + 6,2)
					objLogFile.WriteLine(strMonth)
					strDay = Mid(strReadLineNext, gtPos + 9,2)
					objLogFile.WriteLine(strDay)
					strReadLineNext = "<EventDate>" & strDay & "/" & strMonth & "/" & strYear & "</EventDate>"
					objOutFile.WriteLine(strReadLineNext)
					objLogFile.writeLine("wrote the line: " & strReadLineNext)	
				End If
			Else
				If InStr(strReadLineNext, "<MediaItem>") Then
					If InStr(strReadLineNext, "<Filename>") Then
						objOutFile.writeLine(strReadLineNext)
						objLogFile.writeLine("wrote the line: " & strReadLineNext)
					End If
				Else	
					objOutFile.writeLine(strReadLineNext)
					objLogFile.writeLine("wrote the line: " & strReadLineNext)	
				End If
			End If
		End If
	Else
		If InStr(strReadLineNext, "/MediaItem>") Then 
			'objOutFile.writeLine(strReadLineNext)
			writeBoolean = "Y"
		End If 
	End If
	
Loop

'Final line of the xml
'objOutFile.writeLine("</MediaItemList>")
MsgBox "Finished"

WScript.Quit

'Function to perform replacements- takes three arguments
'patrn (full string)
'replStr (string to replace)
'str1 (replacement)
Function ReplaceTest(patrn, replStr, str1)
	Dim regEx
	
	' Create regular expression
	Set regEx = New RegExp
	regEx.Pattern = patrn
	regEx.IgnoreCase = True
	
	' Make replacement
	ReplaceTest = regEx.Replace(str1, replStr)
End Function

