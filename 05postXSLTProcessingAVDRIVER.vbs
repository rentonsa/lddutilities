'------------------------------------------------------
'------------------------------------------------------
'--Post XSLT Processing
'------------------------------------------------------
'--Date: 		Sep 2011 
'--Author:      Scott Renton
'--Purpose:     Clean up of Insight-ready file, to ensure
'--				it can be processed by Import Media.
'--				1) Group Creators and Roles correctly
'--				2) Save Insight.xml as UTF-8
'--				3) Generate link file
'--Updates      Sep 2015- LUNA 7 Changes.
'--------------------------------------------------------
'--------------------------------------------------------

Option Explicit
Dim objFSO
Dim objInFile1
Dim objLogFile
Dim objOutFile
Dim objLinkFile

Dim strDirectory
Dim strInFile1
Dim strOutFile
Dim strLog
Dim strReadLineNext
Dim strFieldGroupSource
Dim strFieldGroupOtherID
Dim strFieldGroupDate
Dim strFieldGroupReference
Dim strFieldGroupAssociateCreator
Dim strWorkRecordId
Dim strReproRecordId
Dim strFieldGroupCreator
Dim strFieldGroupReproCreator
Dim strLinkFile
Dim strLine
Dim strXMLNamespace
Dim strFieldName
Dim strEditedField

Dim intGtPos
Dim intLtPos
Dim intStartPos
Dim intEndPos
Dim intLenLine
Dim intGroupNo
Dim intSlashPos

strFieldGroupCreator = "entity name=" & Chr(34) & "creator"
strFieldGroupReproCreator = "entity name=" & Chr(34) & "repro_creator"
strFieldGroupSource = "entity name=" & Chr(34) & "related_work"
strFieldGroupOtherID = "entity name=" & Chr(34) & "id_number"
strFieldGroupDate = "entity name=" & Chr(34) & "work_dates"
strFieldGroupReference = "entity name=" & Chr(34) & "references"
strFieldGroupAssociateCreator = "entity name=" & Chr(34) & "associate_creator"
strXMLNamespace = "xmlns=" & Chr(34) & Chr(34)

'Assign directories
strDirectory = "K:\dld\MIMS Project\Development\MIMSWorkflow\" 
strInFile1 = "Load.xml"
strLinkFile = "Link.txt"
strOutFile = "Insight.xml"
strLog = "\Log.xml"


' Create the File System Object
Set objFSO = CreateObject("Scripting.FileSystemObject")

Set objLogFile = objFSO.CreateTextFile(strDirectory & strLog)
Set objOutFile = objFSO.CreateTextFile(strDirectory & strOutFile)
set objInFile1 = objFSO.OpenTextFile(strDirectory & strInFile1)
Set objLinkFile = objFSO.CreateTextFile(strDirectory & strLinkFile)

objLogFile.writeLine("Opened XML FIle")



Do While Not objInFile1.AtEndOfStream
		'read each line
		strReadLineNext = objInFile1.ReadLine
		'ignore space
		if strReadLineNext = "" then
			objLogFile.writeLine("space")
		End If

		If InStr(strReadLineNext, "fieldGroup type") Then
			strReadLineNext = replace (strReadLineNext, "fieldGroup", "entity")
			strReadLineNext = replace (strReadLineNext, "entity type", "entity name")
			intGtPos = InStr(strReadLineNext,"""")
			intStartPos = intGtPos + 1
			intLtPos = InStrRev (strReadLineNext, """")	
			intEndPos = intLtPos -1
			strLine = Left(strReadLineNext, intEndPos)
			intLenLine = (Len(strLine) - intGtPos)
			strFieldName = mid(strLine, intStartPos, intLenLine)
			strEditedField = Replace(strFieldName, " ", "_")
			strEditedField = LCase(strEditedField)
			strReadLineNext = Replace(strReadLineNext, strFieldName, strEditedField)			
		End If
		
		If InStr(strReadLineNext, "xmlns="""" ")Then
			strReadLineNext = replace (strReadLineNext, "xmlns="""" ", "")	
		End If
		
		If InStr(strReadLineNext, "field type") Or InStr(strReadLineNext, "field   type") Then
			strReadLineNext = replace (strReadLineNext, "field type", "field name")	
			intGtPos = InStr(strReadLineNext,"""")
			intStartPos = intGtPos + 1
			intLtPos = InStrRev (strReadLineNext, """")	
			intEndPos = intLtPos -1
			strLine = Left(strReadLineNext, intEndPos)
			intLenLine = (Len(strLine) - intGtPos)
			strFieldName = mid(strLine, intStartPos, intLenLine)
			strEditedField = Replace(strFieldName, " ", "_")
			strEditedField = LCase(strEditedField)
			Select Case strEditedField
			Case "shelfmark","id_number", "alternate_title", "title", "subset", "subset_index","creator","creator_role", "creator_name", "creator_details", "display_date", "description", "location", "repository","subject_person", "subject_class", "source_notes", "source_page_no","source", "rights_statement"
				strEditedField = "work_" & strEditedField
			Case Else
				strEditedField = strEditedField
			End Select			
			strReadLineNext = Replace(strReadLineNext, strFieldName, strEditedField)	
		End If	
		
		If InStr(strReadLineNext, "repro_link_id") Then
			objLogFile.WriteLine(strReadLineNext)
			intGtPos = InStr(strReadLineNext,">")
			intStartPos = intGtPos + 1
			intLtPos = InStrRev (strReadLineNext, "</")	
			intEndPos = intLtPos -1
			strLine = Left(strReadLineNext, intEndPos)
			objLogFile.WriteLine(strLine)
			intLenLine = (Len(strLine) - intGtPos)
			strWorkRecordId = mid(strLine, intStartPos, intLenLine)
			strReproRecordId = strWorkRecordId & ".tif"
			objLinkFile.WriteLine(strReproRecordId & Chr(9) & strWorkRecordId)	
		End If
		
		If InStr(strReadLineNext, strFieldGroupCreator) Then
			intGtPos = InStr(strReadLineNext,"creator")
			intGroupNo = Mid(strReadLineNext,intGtPos + 7,1)
			strReadLineNext = Replace(strReadLineNext,intGroupNo, "")
		End If
		
		If InStr(strReadLineNext, strFieldGroupReproCreator) Then
			intGtPos = InStr(strReadLineNext,"creator")
			intGroupNo = Mid(strReadLineNext,intGtPos + 7,1)
			strReadLineNext = Replace(strReadLineNext,intGroupNo, "")
		End If
		
		If InStr(strReadLineNext, strFieldGroupOtherID) Then
			intGtPos = InStr(strReadLineNext,"number")
			intGroupNo = Mid(strReadLineNext,intGtPos + 6,1)
			strReadLineNext = Replace(strReadLineNext,intGroupNo, "")
		End If
		
		If InStr(strReadLineNext, strFieldGroupSource) Then
			intGtPos = InStr(strReadLineNext,"related_work")
			intGroupNo = Mid(strReadLineNext,intGtPos + 12,1)
			strReadLineNext = Replace(strReadLineNext,intGroupNo, "")
		End If
		
		If InStr(strReadLineNext, strFieldGroupReference) Then
			intGtPos = InStr(strReadLineNext,"references")
			intGroupNo = Mid(strReadLineNext,intGtPos + 10,1)
			strReadLineNext = Replace(strReadLineNext,intGroupNo, "")
		End If
		
		If InStr(strReadLineNext, strFieldGroupAssociateCreator) Then
			intGtPos = InStr(strReadLineNext,"associate_creator")
			intGroupNo = Mid(strReadLineNext,intGtPos + 17,1)
			strReadLineNext = Replace(strReadLineNext,intGroupNo, "")
		End If
		
		If InStr(strReadLineNext, "_(bytes)") Then
			strReadLineNext = Replace(strReadLineNext,"_(bytes)", "")
		End If

		If InStr(strReadLineNext, "_(pixels)") Then
			strReadLineNext = Replace(strReadLineNext,"_(pixels)", "")
		End If
		
'		If InStr(strReadLineNext, strFieldGroupDate) Then
'			objLogFile.WriteLine(strFieldGroupDate)
'			intGtPos = InStr(strReadLineNext,"Dates")
'			intGroupNo = Mid(strReadLineNext,intGtPos + 5,1)
'			strReadLineNext = Replace(strReadLineNext,intGroupNo, "")
'		End If
		
		If InStr(strReadLineNext,strXMLNamespace) then
			strReadLineNext = Replace(strReadLineNext, strXMLNamespace, "")
		End If
		
		'References Workaround....
		If InStr(strReadLineNext,",,") then
			strReadLineNext = Replace(strReadLineNext, ",,", ", ")
		End If
		
		If InStr(strReadLineNext,">, ") then
			strReadLineNext = Replace(strReadLineNext, ">, ", ">")
		End If
		
		If InStr(strReadLineNext,">,") then
			strReadLineNext = Replace(strReadLineNext, ">,", ">")
		End If
		
		'Subject Places Workaround
		If InStr(strReadLineNext, "Subject Place") Then
			intGtPos = InStr(strReadLineNext, ">")
			strReadLineNext = Mid(strReadLineNext, intGtPos + 1)

			intLtPos = InStrRev (strReadLineNext, "</")	
			intEndPos = intLtPos -1
			strReadLineNext = Left(strReadLineNext, intEndPos)

			intSlashPos = InStr(strReadLineNext, "/")
			If intSlashPos > 0 then
			 strReadLineNext = Mid(strReadLineNext,1, intSlashPos -1)
			End If
			 strReadLineNext = "<field type = " &chr(34) & "Subject Place" &  chr(34) & ">" & strReadLineNext & "</field>"
		End If
		objOutFile.writeLine(strReadLineNext)
		
			
Loop
		
WScript.Quit

