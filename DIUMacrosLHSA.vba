Function specialChars(ByVal textValue As String) As String
    specialChars = Replace(textValue, "&", "&amp;")
    specialChars = Replace(specialChars, "<", "&lt;")
    specialChars = Replace(specialChars, ">", "&gt;")
End Function

Sub CreateXML()
    MsgBox "Howdy LHSA! Nice to see ya!"

    'Set worksheet- there is only one.
    Set oWorksheet = ThisWorkbook.Worksheets(1)
    sName = oWorksheet.Name

    'Set no columns and rows for counts
    lCols = oWorksheet.Columns.Count
    lRows = oWorksheet.Rows.Count

    'Header is so long it runs onto many lines- initialise here
    Dim firstheader
    Dim secondheader
    Dim thirdheader
    Dim fourthheader
    Dim Header

    'Initialise data arrays
    Dim lhsarray(1000) As String

    'Initialise file objects
    Dim flhs As Object
    Set flhs = CreateObject("ADODB.Stream")

    'Need a second object so we can get rid of the BOM character
    Dim flhsb As Object
    Set flhsb = CreateObject("ADODB.Stream")

    'Set file object properties
    flhs.Type = 2
    flhs.Charset = "utf-8"
    flhs.Open

    'Set binary file object properties and open
    flhsb.Type = 1
    flhsb.Mode = 3
    flhsb.Open

    'Declare final file names
    lhsxml = "T:\lhsa-images\Worksheets\xml\LHS.xml"

    summfile = "T:\lhsa-images\Worksheets\xml\summary.txt"

  'initialise counts
    i = 5

    lhscount = 0

     Close #99
    Open summfile For Output Lock Write As #99

    'Process all rows
    For i = 4 To lRows


        processed = Cells(i, 40)
        Dim personArray() As String
        Dim categoryArray() As String
        Dim creatorArray() As String
        Dim placeArray() As String
        Dim prodPlaceArray() As String
        Dim creatorNameArray() As String
        Dim creatorNameBits() As String
        shortcoll = ""
        coll = ""
        subjectCatString = ""
        subjectPersonString = ""
        summaryCreator = ""
        subjectPlaceString = ""
        prodPlaceString = ""
        summaryCreatorString = ""
        creatorNameString = ""
        goodrecord = "Y"
        titleString = ""
        badcoll = "N"
        workString = ""
        pageString = ""
        allSubjectCats = ""
        allSubjectPersons = ""
        rightsStatement = ""
        reproRightsStatement = ""
        licenceString = ""
        subsetIndex = ""
        relatedWorkVolPageNo = ""
        reproTitle = ""
        reproRecordId = ""
        reproLinkId = ""
        workRecordId = ""
        reproIdNumber = ""
        Title = ""
        Subset = ""
        relatedWorkTitle = ""
        shelfmark = ""
        sequence = ""
        catalogueNumber = ""
        repository = ""
        reproRepository = ""
        catalogueEntry = ""
        catString = ""
        reproPublicationStatus = ""
        subjectEvent = ""
        reproNotes = ""
        Description = ""
        dateString = ""
        Category = ""
        person = ""
        place = ""
        allSubjectPlaces = ""
        prodPlace = ""
        allProdPlaces = ""
        creatorName = ""
        allCreators = ""
        creatorString = ""

        'If ready to process act, otherwise bypass
        If processed = "X" Then
            coll = Cells(i, 22)
            If coll <> "" Then
                badcoll = "N"
                'Get collection tla
                Select Case coll
                    Case "LHSA PUBLIC"
                        lhscoll = coll
                        shortcoll = "lhs"
                   Case Else
                        badcoll = "Y"
                  End Select

                'Constants
                entitys = "<entity name = " & Chr(34)
                entitycfieldst = Chr(34) & ">" & Chr(10) & "<field name=" & Chr(34)
                fieldcvalues = Chr(34) & ">" & Chr(10) & "<value>"
                valueefielde = "</value>" & Chr(10) & "</field>" & Chr(10)
                fields = "<field name=" & Chr(34)
                entitye = "</entity>" & Chr(10)
                valueefieldeentitye = "</value>" & Chr(10) & "</field>" & Chr(10) & "</entity>" & Chr(10)
                ccby = "<![CDATA[<a href = " & Chr(34) & "https://creativecommons.org/licenses/by/3.0/" & Chr(34) & " target=" & Chr(34) & "_blank" & Chr(34) & "><img src = " & Chr(34) & "http://lac-luna-live4.is.ed.ac.uk:8181/graphics/by.jpg" & Chr(34) & "/></a>]]>"
                ccbyncnd = "<![CDATA[<a href = " & Chr(34) & "https://creativecommons.org/licenses/by-nc-nd/3.0/" & Chr(34) & " target=" & Chr(34) & "_blank" & Chr(34) & "><img src = " & Chr(34) & "http://lac-luna-live4.is.ed.ac.uk:8181/graphics/byncnd.jpg" & Chr(34) & "/></a>]]>"
                reproFileType = fields & "repro_file_type" & fieldcvalues & "Cropped TIFF" & valueefielde
                holdingInstitution = fields & "holding_institution" & fieldcvalues & "University of Edinburgh" & valueefielde
                reproCreatorName = entitys & "repro_creator" & entitycfieldst & "repro_creator_name" & fieldcvalues & "Digital Imaging Unit" & valueefielde
                reproCreatorRoleDescription = fields & "repro_creator_role_description" & fieldcvalues & "Creator" & valueefieldeentitye

                'Don't process if no collection
                If badcoll = "Y" Then
                   goodrecord = "N"
                   MsgBox "major problem- mis-spelt or ineligible Collection!" & " " & coll & " " & Cells(i, 8) & Cells(i, 9)
                End If

                'Don't process if no title
                If Cells(i, 13) = "" Then
                   goodrecord = "N"
                   MsgBox "major problem- no Title!" & " " & coll & " " & Cells(i, 8) & Cells(i, 9)
                Else
                   titleString = specialChars(Cells(i, 13))
                End If

                'If no work record ID (in column 8 OR 9, don't process)
                If Cells(i, 8) = "" Then
                    workString = Left(Cells(i, 9), 7)
                Else
                    workString = Left(Cells(i, 8), 7)
                End If

                If workString = "" Then
                   goodrecord = "N"
                   MsgBox "major problem- no image Id!" & " " & coll & " " & " " & Cells(i, 13) & " " & Cells(i, 17)
                End If

                If goodrecord = "Y" Then
                    'Get copyright & licence text
                    Select Case Cells(i, 10)
                         Case "LHSA-Y"
                            rightsStatement = entitys & "rights" & entitycfieldst & "work_rights_statement" & fieldcvalues & "Copyright Lothian Health Services Archive. Please contact for permissions and further information." & valueefieldeentitye
                            reproRightsStatement = entitys & "repro_rights" & entitycfieldst & "repro_rights_statement" & fieldcvalues & "Copyright Lothian Health Services Archive. Please contact for permissions and further information." & valueefieldeentitye
                            licenceString = ""
                        Case Else
                            rightsStatement = entitys & "rights" & entitycfieldst & "work_rights_statement" & fieldcvalues & "No copyright information available." & valueefieldeentitye
                            reproRightsStatement = entitys & "repro_rights" & entitycfieldst & "repro_rights_statement" & fieldcvalues & "No copyright information available." & valueefieldeentitye
                            licenceString = ""
                    End Select

                    'Process fields by column
                    If Cells(i, 17) = "" Then
                        subsetIndex = ""
                        relatedWorkVolPageNo = entitye
                        reproTitle = entitys & "repro_title" & entitycfieldst & "repro_title" & fieldcvalues & titleString & valueefieldeentitye
                    Else
                        pageString = specialChars(Cells(i, 17))
                        seqString = specialChars(Cells(i, 18))
                        subsetIndex = fields & "work_subset_index" & fieldcvalues & pageString & valueefielde
                        If shortcoll = "ssp" Then
                            relatedWorkVolPageNo = entitye
                            reproTitle = entitys & "repro_title" & entitycfieldst & "repro_title" & fieldcvalues & "Case " & pageString & ", " & "Page " & seqString & valueefieldeentitye
                        Else
                            relatedWorkVolPageNo = fields & "work_source_page_no" & fieldcvalues & pageString & valueefieldeentitye
                            reproTitle = entitys & "repro_title" & entitycfieldst & "repro_title" & fieldcvalues & titleString & ", " & pageString & valueefieldeentitye
                        End If
                    End If

                    reproRecordId = entitys & "repro_record" & entitycfieldst & "repro_record_id" & fieldcvalues & workString & "c.tif" & valueefielde
                    reproLinkId = fields & "repro_link_id" & fieldcvalues & workString & "c" & valueefielde
                    workRecordId = fields & "work_record_id" & fieldcvalues & workString & valueefielde
                    reproIdNumber = entitys & "repro_id_number" & entitycfieldst & "repro_id_number" & fieldcvalues & workString & "c" & valueefieldeentitye

                    Title = entitys & "title" & entitycfieldst & "work_title" & fieldcvalues & titleString & valueefieldeentitye
                    Subset = entitys & "subset" & entitycfieldst & "work_subset" & fieldcvalues & titleString & valueefielde
                    relatedWorkTitle = entitys & "related_work" & entitycfieldst & "work_source" & fieldcvalues & titleString & valueefielde

                    If Cells(i, 12) = "" Then
                        MsgBox "major problem- no Shelfmark!" & coll & " " & Cells(i, 8) & Cells(i, 9)
                        shelfmark = ""
                    Else
                        shelfmark = entitys & "id_number" & entitycfieldst & "work_shelfmark" & fieldcvalues & specialChars(Cells(i, 12)) & valueefielde
                    End If

                    If Cells(i, 18) = "" Then
                        sequence = entitye
                    Else
                        sequence = fields & "sequence" & fieldcvalues & Cells(i, 18) & valueefieldeentitye
                    End If

                    If Cells(i, 26) = "" Then
                        catalogueNumber = entitye
                    Else
                        catalogueNumber = fields & "work_catalogue_number" & fieldcvalues & specialChars(Cells(i, 26)) & valueefieldeentitye
                    End If

                    repository = entitys & "repository" & entitycfieldst & "work_repository" & fieldcvalues & Cells(i, 22) & valueefieldeentitye
                    reproRepository = entitys & "repro_repository" & entitycfieldst & "repro_repository" & fieldcvalues & Cells(i, 22) & valueefieldeentitye

                    If Cells(i, 24) = "" Then
                        catalogueEntry = ""
                    Else
                        catString = Replace(Cells(i, 24), "&", "%26")
                        catalogueEntry = entitys & "navigation" & entitycfieldst & "catalogue_entry" & fieldcvalues & catString & valueefieldeentitye
                    End If

                    If Cells(i, 11) = "Y" Then
                        reproPublicationStatus = entitys & "repro_publication_status" & entitycfieldst & "repro_publication_status" & fieldcvalues & "Full Public Access" & valueefieldeentitye
                    Else
                        reproPublicationStatus = entitys & "repro_publication_status" & entitycfieldst & "repro_publication_status" & fieldcvalues & "No Access" & valueefieldeentitye
                    End If

                    If Cells(i, 25) = "N/A" Or Cells(i, 25) = "Unknown" Or Cells(i, 25) = "-" Or Cells(i, 25) = "" Then
                        subjectEvent = ""
                    Else
                        subjectEvent = entitys & "subject" & entitycfieldst & "work_subject_event" & fieldcvalues & specialChars(Cells(i, 25)) & valueefieldeentitye
                    End If

                    If Cells(i, 27) = "N/A" Or Cells(i, 27) = "Unknown" Or Cells(i, 27) = "-" Or Cells(i, 27) = "" Then
                        reproNotes = entitye
                    Else
                        reproNotes = fields & "repro_notes" & fieldcvalues & specialChars(Cells(i, 27)) & valueefieldeentitye
                    End If

                    If Cells(i, 21) = "N/A" Or Cells(i, 21) = "Unknown" Or Cells(i, 21) = "-" Or Cells(i, 21) = "" Then
                        Description = ""
                    Else
                        Description = entitys & "description" & entitycfieldst & "work_description" & fieldcvalues & specialChars(Cells(i, 21)) & valueefieldeentitye
                    End If

                    If Cells(i, 14) = "N/A" Or Cells(i, 14) = "Unknown" Or Cells(i, 14) = "-" Or Cells(i, 14) = "" Then
                        dateString = ""
                    Else
                        dateString = entitys & "dates" & entitycfieldst & "work_display_date" & fieldcvalues & specialChars(Cells(i, 14)) & valueefieldeentitye
                    End If

                    j = 0
                    'Process repeating category
                    Category = Cells(i, 19)
                    If Category = "" Then
                        allSubjectCats = ""
                    Else
                        If InStr(Category, ";") = 0 Then
                            If Category = "N/A" Or Category = "Unknown" Or Category = "-" Then
                                Category = ""
                                allSubjectCats = ""
                            Else
                                allSubjectCats = entitys & "subject" & entitycfieldst & "work_subject_class" & fieldcvalues & specialChars(Category) & valueefieldeentitye
                            End If
                        Else
                            categoryArray() = Split(Category, ";")
                            For j = LBound(categoryArray()) To UBound(categoryArray())
                                If categoryArray(j) = "" Then
                                    allSubjectCats = ""
                                Else
                                    subjectCatString = entitys & "subject" & entitycfieldst & "work_subject_class" & fieldcvalues & Trim(specialChars(categoryArray(j))) & valueefieldeentitye
                                    allSubjectCats = allSubjectCats & subjectCatString
                                End If
                            Next j
                        End If
                    End If

                    'Process repeating subject persons
                    k = 0
                    person = Cells(i, 23)
                    If person = "" Then
                        allSubjectPersons = ""
                    Else
                        If InStr(person, ";") = 0 Then
                            If person = "N/A" Or person = "Unknown" Or person = "-" Then
                                person = ""
                                allSubjectPersons = ""
                            Else
                                allSubjectPersons = entitys & "subject" & entitycfieldst & "work_subject_person" & fieldcvalues & specialChars(person) & valueefieldeentitye
                            End If
                        Else
                            personArray() = Split(person, ";")

                            For k = LBound(personArray()) To UBound(personArray())
                                If personArray(k) = "" Then
                                    allSubjectPersons = ""
                                Else
                                    subjectPersonString = entitys & "subject" & entitycfieldst & "work_subject_person" & fieldcvalues & Trim(specialChars(personArray(k))) & valueefieldeentitye
                                    allSubjectPersons = allSubjectPersons & subjectPersonString
                                End If
                            Next k
                        End If
                    End If

                    'Process repeating subject places

                    r = 0
                    place = Cells(i, 20)
                    If place = "" Then
                        allSubjectPlaces = ""
                    Else
                        If InStr(place, ";") = 0 Then
                            If place = "N/A" Or place = "Unknown" Or place = "-" Then
                                place = ""
                                allSubjectPlaces = ""
                            Else
                                allSubjectPlaces = entitys & "subject" & entitycfieldst & "work_subject_place" & fieldcvalues & specialChars(place) & valueefieldeentitye
                            End If
                        Else
                            placeArray() = Split(place, ";")
                            For r = LBound(placeArray()) To UBound(placeArray())
                                If placeArray(r) = "" Then
                                    allSubjectPlaces = ""
                                Else
                                    subjectPlaceString = entitys & "subject" & entitycfieldst & "work_subject_place" & fieldcvalues & Trim(specialChars(placeArray(r))) & valueefieldeentitye
                                    allSubjectPlaces = allSubjectPlaces & subjectPlaceString
                                End If
                            Next r
                        End If
                    End If

                    v = 0
                    'Process repeating prod places
                    prodPlace = Cells(i, 15)
                    If prodPlace = "" Then
                        allProdPlaces = ""
                    Else
                        If InStr(prodPlace, ";") = 0 Then
                           If prodPlace = "N/A" Or prodPlace = "Unknown" Or prodPlace = "-" Then
                               prodPlace = ""
                               allProdPlaces = ""
                           Else
                               allProdPlaces = entitys & "production_place" & entitycfieldst & "production_place" & fieldcvalues & specialChars(prodPlace) & valueefieldeentitye
                           End If
                        Else
                            prodPlaceArray() = Split(prodPlace, ";")
                            For v = LBound(prodPlaceArray()) To UBound(prodPlaceArray())
                                If prodPlaceArray(v) = "" Then
                                    allProdPlaces = ""
                                Else
                                    prodPlaceString = entitys & "production_place" & entitycfieldst & "production_place" & fieldcvalues & Trim(specialChars(prodPlaceArray(v))) & valueefieldeentitye
                                    allProdPlaces = allProdPlaces & prodPlaceString
                                End If
                            Next v
                        End If
                    End If

                    'Generate summary creator in correct format
                    y = 0
                    creatorName = Cells(i, 16)
                    If creatorName = "" Then
                        allCreators = ""
                    Else
                        If InStr(creatorName, ";") = 0 Then
                            If InStr(creatorName, ",") = 0 Then
                                summaryCreator = creatorName
                            Else
                                creatorNameBits() = Split(creatorName, ",")
                                summaryCreator = Trim(Trim(creatorNameBits(1)) & " " & Trim(creatorNameBits(0)))
                            End If
                            creatorString = entitys & "creator" & entitycfieldst & "work_creator_details" & fieldcvalues & specialChars(creatorName) & valueefielde
                            creatorNameString = fields & "work_creator_name" & fieldcvalues & specialChars(creatorName) & valueefielde
                            summaryCreatorString = fields & "summary_creator" & fieldcvalues & specialChars(summaryCreator) & valueefieldeentitye
                            allCreators = creatorString & creatorNameString & summaryCreatorString
                        Else
                            creatorNameArray() = Split(creatorName, ";")

                            For y = LBound(creatorNameArray()) To UBound(creatorNameArray())
                                If creatorNameArray(y) = "" Then
                                    allCreators = ""
                                Else
                                    creatorString = entitys & "creator" & entitycfieldst & "work_creator_details" & fieldcvalues & Trim(specialChars(creatorNameArray(y))) & valueefielde
                                    creatorNameString = fields & "work_creator_name" & fieldcvalues & Trim(specialChars(creatorNameArray(y))) & valueefielde
                                End If

                                If InStr(creatorNameArray(y), ",") = 0 Then
                                    summaryCreatorString = fields & "summary_creator" & fieldcvalues & Trim(specialChars(creatorNameArray(y))) & valueefieldeentitye
                                Else

                                    creatorNameBits() = Split(creatorNameArray(y), ",")
                                    summaryCreator = Trim(Trim(creatorNameBits(1)) & " " & Trim(creatorNameBits(0)))
                                    summaryCreatorString = fields & "summary_creator" & fieldcvalues & specialChars(summaryCreator) & valueefieldeentitye
                                End If
                                creatorBlock = creatorString & creatorNameString & summaryCreatorString
                                allCreators = allCreators & creatorBlock
                            Next y
                        End If
                    End If

                    'Build XML file
                    dataLine1 = workRecordId & licenceString & shelfmark & holdingInstitution & catalogueNumber & Title & Subset & subsetIndex & sequence & allCreators & dateString & Description & allProdPlaces & repository & allSubjectPersons & allSubjectPlaces & subjectEvent & allSubjectCats & relatedWorkTitle & relatedWorkVolPageNo & rightsStatement & catalogueEntry
                    dataLine2 = reproRecordId & reproLinkId & reproFileType & reproNotes & reproTitle & reproCreatorName & reproCreatorRoleDescription & reproRepository & reproIdNumber & reproRightsStatement & reproPublicationStatus
                    dataLine = dataLine1 & dataLine2

                    Header = "<?xml version=" & Chr(34) & "1.0" & Chr(34) & " encoding=" & Chr(34) & "UTF-8" & Chr(34) & "?>" & Chr(10) & "<recordList>" & Chr(10)
                    recordLine = "<record>" & Chr(10)
                    recordCloser = "</record>" & Chr(10)

                    'Write to file objects

                    If shortcoll = "lhs" Then
                        If lhscount = 0 Then
                            flhs.WriteText Header & Chr(10)
                        End If
                        flhs.WriteText recordLine
                        flhs.WriteText dataLine & Chr(10)
                        flhs.WriteText recordCloser
                        lhsarray(lhscount) = Cells(i, 8) & " ; " & Cells(i, 11)
                        lhscount = walcount + 1
                    End If

                    Cells(i, 40) = "V"

                End If
            Else
                MsgBox "major problem- no Collection!" & " " & coll & " " & Cells(i, 8) & Cells(i, 9)
            End If
         End If


         Next
         'Start after the BOM chars, copy to bin and then copy to xml

         If lhscount > 0 Then
            flhs.WriteText "</recordList>"
            flhs.Position = 3
            flhs.CopyTo flhsb
            flhs.Flush
            flhs.Close
            flhsb.SaveToFile lhsxml, 2
         Else
            flhs.Close
            flhsb.Close
         End If

         i = 0

        If lhscount > 0 Then
            Print #99, lhscoll
            Print #99, "===================="
            For i = 0 To lhscount
                Print #99, lhsarray(i)
            Next
        End If

        Close #99

        MsgBox "Ended!"

End Sub


Sub Embed()
MsgBox "Hello LHSA!"

    Set oWorksheet = ThisWorkbook.Worksheets(1)
    sName = oWorksheet.Name
    MsgBox oWorksheet.Name

    lCols = oWorksheet.Columns.Count

    lRows = oWorksheet.Rows.Count

    execdir = "T:\lhsa-images\Worksheets\"
    MsgBox execdir
    For i = 4 To lRows
        If Cells(i, 32) = "R" Then
            folder = Left(Cells(i, 8), 4) & "000-" & Left(Cells(i, 8), 4) & "999\"
            imageNo = Left(Cells(i, 8), 7)
            embedcmd = "T:\lhsa-images\Worksheets\embed\" & imageNo & ".bat"
            Open embedcmd For Output Lock Write As #1
            Select Case Cells(i, 10)
                Case "LHSA-Y"
                    copyrightstring = "Copyright Lothian Health Services Archive. Please contact for permissions and further information."
                Case Else
                    copyrightstring = "No copyright information available."
            End Select

            titleString = "Title: " & Cells(i, 13) & "; Author: " & Cells(i, 16) & "; Page No: " & Cells(i, 17) & "; Shelfmark: " & Cells(i, 12) & "; Date: " & Cells(i, 14)
            descString = "Collection: " & Cells(i, 22) & "; Persons: " & Cells(i, 23) & "; Event: " & Cells(i, 25) & "; Place: " & Cells(i, 20) & "; Category: " & Cells(i, 19) & "; Description: " & Cells(i, 21)
            city = "Edinburgh"
            postcode = "EH8 9LJ"
            extrAdr = "Lothian Health Services Archive, Centre for Research Collections, Edinburgh University Library, George Square"
            country = "UK"
            tel = "0131 6511 720"
            Email = "is-crc@ed.ac.uk"
            diu = "Digital Imaging Unit"
            URL = "www.lhsa.lib.ed.ac.uk"

            Print #1, "cd /D T: > " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & ".txt" & Chr(34) & " 2>&1"
            Print #1, "cd " & Chr(34) & "T:\lhsa-images\Worksheets\exiv2" & Chr(34) & " >> " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & ".txt" & Chr(34) & " 2>>&1"
            Print #1, "echo " & Chr(34) & "directory is: " & Chr(34) & "%cd% >> " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & ".txt" & Chr(34) & " 2>>&1"
            Print #1, "exiv2 -M " & Chr(34) & "set  Iptc.Application2.Headline String " & imageNo & Chr(34) & " " & Chr(34) & "T:\lhsa-images\Crops\" & folder & "Process\" & imageNo & "c.tif" & Chr(34) & " >> " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & ".txt" & Chr(34) & " 2>>&1"
            Print #1, "exiv2 -M " & Chr(34) & "set  Iptc.Application2.Copyright String " & copyrightstring & Chr(34) & " " & Chr(34) & "T:\lhsa-images\Crops\" & folder & "Process\" & imageNo & "c.tif" & Chr(34) & " >> " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & ".txt" & Chr(34) & " 2>>&1"
            Print #1, "exiv2 -M " & Chr(34) & "set  Xmp.dc.creator XmpSeq " & diu & Chr(34) & " " & Chr(34) & "T:\lhsa-images\Crops\" & folder & "Process\" & imageNo & "c.tif" & Chr(34) & " >> " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & ".txt" & Chr(34) & " 2>>&1"
            Print #1, "exiv2 -M " & Chr(34) & "set  Iptc.Application2.Caption String " & descString & Chr(34) & " " & Chr(34) & "T:\lhsa-images\Crops\" & folder & "Process\" & imageNo & "c.tif" & Chr(34) & " >> " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & ".txt" & Chr(34) & " 2>>&1"
            Print #1, "exiv2 -M " & Chr(34) & "set  Iptc.Application2.ObjectName String " & titleString & Chr(34) & " " & Chr(34) & "T:\lhsa-images\Crops\" & folder & "Process\" & imageNo & "c.tif" & Chr(34) & " >> " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & ".txt" & Chr(34) & " 2>>&1"
            Print #1, "exiv2 -M " & Chr(34) & "set  Xmp.iptc.CreatorContactInfo/Iptc4xmpCore:CiAdrCity XmpText " & city & Chr(34) & " " & Chr(34) & "T:\lhsa-images\Crops\" & folder & "Process\" & imageNo & "c.tif" & Chr(34) & " >> " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & ".txt" & Chr(34) & " 2>>&1"
            Print #1, "exiv2 -M " & Chr(34) & "set  Xmp.iptc.CreatorContactInfo/Iptc4xmpCore:CiAdrPcode XmpText " & postcode & Chr(34) & " " & Chr(34) & "T:\lhsa-images\Crops\" & folder & "Process\" & imageNo & "c.tif" & Chr(34) & " >> " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & ".txt" & Chr(34) & " 2>>&1"
            Print #1, "exiv2 -M " & Chr(34) & "set  Xmp.iptc.CreatorContactInfo/Iptc4xmpCore:CiAdrExtadr XmpText  " & extrAdr & Chr(34) & " " & Chr(34) & "T:\lhsa-images\Crops\" & folder & "Process\" & imageNo & "c.tif" & Chr(34) & " >> " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & ".txt" & Chr(34) & " 2>>&1"
            Print #1, "exiv2 -M " & Chr(34) & "set  Xmp.iptc.CreatorContactInfo/Iptc4xmpCore:CiAdrCtry XmpText " & country & Chr(34) & " " & Chr(34) & "T:\lhsa-images\Crops\" & folder & "Process\" & imageNo & "c.tif" & Chr(34) & " >> " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & ".txt" & Chr(34) & " 2>>&1"
            Print #1, "exiv2 -M " & Chr(34) & "set  Xmp.iptc.CreatorContactInfo/Iptc4xmpCore:CiTelWork XmpText " & tel & Chr(34) & " " & Chr(34) & "T:\lhsa-images\Crops\" & folder & "Process\" & imageNo & "c.tif" & Chr(34) & " >> " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & ".txt" & Chr(34) & " 2>>&1"
            Print #1, "exiv2 -M " & Chr(34) & "set  Xmp.iptc.CreatorContactInfo/Iptc4xmpCore:CiEmailWork XmpText " & Email & Chr(34) & " " & Chr(34) & "T:\lhsa-images\Crops\" & folder & "Process\" & imageNo & "c.tif" & Chr(34) & " >> " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & ".txt" & Chr(34) & " 2>>&1"
            Print #1, "exiv2 -M " & Chr(34) & "set  Xmp.iptc.CreatorContactInfo/Iptc4xmpCore:CiUrlWork XmpText " & URL & Chr(34) & " " & Chr(34) & "T:\lhsa-images\Crops\" & folder & "Process\" & imageNo & "c.tif" & Chr(34) & " >> " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & ".txt" & Chr(34) & " 2>>&1"

            Close #1

            retval1 = Shell(Chr(34) & embedcmd & Chr(34), vbNormalFocus)

            Cells(i, 32) = "E"

        End If
    Next


End Sub


Sub Embed()
MsgBox "Hello!"

    Set oWorksheet = ThisWorkbook.Worksheets(1)
    sName = oWorksheet.Name
    MsgBox oWorksheet.Name

    lCols = oWorksheet.Columns.Count

    lRows = oWorksheet.Rows.Count

    execdir = "T:\lhsa-images\Worksheets\"
    MsgBox execdir

    dt = Format(CStr(Now), "yy_mm_dd_hh_mm")
    embedcmd = "T:\lhsa-images\Worksheets\embed\" & dt & ".bat"

    Open embedcmd For Output Lock Write As #1
    Print #1, "cd /D T: > " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & "connection.txt" & Chr(34) & " 2>&1"
    Print #1, "cd " & Chr(34) & "T:\lhsa-images\Worksheets\exiv2" & Chr(34) & " >> " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & "connection.txt" & Chr(34) & " 2>>&1"
    Print #1, "echo " & Chr(34) & "directory is: " & Chr(34) & "%cd% >> " & Chr(34) & "T:\lhsa-images\Worksheets\error\" & imageNo & "connection.txt" & Chr(34) & " 2>>&1"

    For i = 5 To lRows
        If Cells(i, 32) = "R" Then
            folder = Left(Cells(i, 8), 4) & "000-" & Left(Cells(i, 8), 4) & "999\"
            imageNo = Left(Cells(i, 8), 7)

            Select Case Cells(i, 10)
                Case "LHSA-Y"
                    copyrightstring = "Copyright Lothian Health Services Archive. Please contact for permissions and further information."
                Case Else
                    copyrightstring = "No copyright information available."
            End Select

            titl = "Title: " & Cells(i, 13) & "; Author: " & Cells(i, 16) & "; Page No: " & Cells(i, 17) & "; Shelfmark: " & Cells(i, 12) & "; Date: " & Cells(i, 14)
            desc = "Collection: " & Cells(i, 22) & "; Persons: " & Cells(i, 23) & "; Event: " & Cells(i, 25) & "; Place: " & Cells(i, 20) & "; Category: " & Cells(i, 19) & "; Description: " & Cells(i, 21)
            exAd = "Lothian Health Services Archive, Centre for Research Collections, Edinburgh University Library, George Square"
            city = "Edinburgh"
            pcde = "EH8 9LJ"
            ctr = "UK"
            tel = "0131 650 8379"
            URL = "www.lhsa.lib.ed.ac.uk"
            eml = "is-crc@ed.ac.uk"
            diu = "Digital Imaging Unit"

            commands = "T:\lhsa-images\Worksheets\commands\" & imageno & ".txt"

            Open commands For Output Lock Write As #2

            Print #2, "set Iptc.Application2.Headline String " & Chr(34) & imageno & Chr(34)
            Print #2, "set Iptc.Application2.Copyright String " & Chr(34) & copyrightstring & Chr(34)
            Print #2, "set Xmp.dc.creator XmpSeq " & Chr(34) & diu & Chr(34)
            Print #2, "set Iptc.Application2.Caption String " & Chr(34) & desc & Chr(34)
            Print #2, "set Iptc.Application2.ObjectName String " & Chr(34) & titl & Chr(34)
            Print #2, "set Xmp.iptc.CreatorContactInfo/Iptc4xmpCore:CiAdrCity XmpText " & Chr(34) & city & Chr(34)
            Print #2, "set Xmp.iptc.CreatorContactInfo/Iptc4xmpCore:CiAdrPcode XmpText " & Chr(34) & pcde & Chr(34)
            Print #2, "set Xmp.iptc.CreatorContactInfo/Iptc4xmpCore:CiAdrExtadr XmpText " & Chr(34) & exAd & Chr(34)
            Print #2, "set Xmp.iptc.CreatorContactInfo/Iptc4xmpCore:CiAdrCtry XmpText " & Chr(34) & ctr & Chr(34)
            Print #2, "set Xmp.iptc.CreatorContactInfo/Iptc4xmpCore:CiTelWork XmpText " & Chr(34) & tel & Chr(34)
            Print #2, "set Xmp.iptc.CreatorContactInfo/Iptc4xmpCore:CiEmailWork XmpText " & Chr(34) & eml & Chr(34)
            Print #2, "set Iptc.Application2.Headline String " & Chr(34) & imageno & Chr(34)
            Print #2, "set Xmp.iptc.CreatorContactInfo/Iptc4xmpCore:CiUrlWork XmpText " & Chr(34) & URL & Chr(34)

            Close #2
            Print #1, "exiv2 -m" & commands & " " & Chr(34) & "T:\diu\Crops\" & folder & "Process\" & imageno & "m.tif" & Chr(34) & " >> " & Chr(34) & "T:\diu\Worksheets\error\" & imageno & ".txt" & Chr(34) & " 2>>&1"

            Cells(i, 32) = "E"

        End If

    Next
    Close #1
    shellstring = Chr(34) & embedcmd & Chr(34)
    Call Shell("cmd.exe /S /C " & shellstring, vbNormalFocus)
    'retval1 = Shell(Chr(34) & embedcmd & Chr(34), vbNormalFocus)

End Sub

Sub Rename()
MsgBox "Hello LHSA!"

    Set oWorksheet = ThisWorkbook.Worksheets(1)
    sName = oWorksheet.Name
    MsgBox oWorksheet.Name

    lCols = oWorksheet.Columns.Count

    lRows = oWorksheet.Rows.Count

    execdir = "T:\lhsa-images\Worksheets\"
    dt = Format(CStr(Now), "yyy_mm_dd_hh_mm")
    copybackcmd = "T:\lhsa-images\Worksheets\copyback\" & dt & ".bat"
    Open copybackcmd For Output Lock Write As #1
    For i = 5 To lRows
        If Cells(i, 32) = "E" Then
            folder = Left(Cells(i, 8), 4) & "000-" & Left(Cells(i, 8), 4) & "999\"
            imageNo = Left(Cells(i, 8), 7)
            Print #1, "move T:\lhsa-images\Crops\" & folder & "Process\" & imageNo & "m.tif*  T:\lhsa-images\Crops\" & folder & "Process\" & imageNo & "c.tif"
            Cells(i, 32) = "X"

        End If
    Next

    Close #1

    shellstring = Chr(34) & copybackcmd & Chr(34)
    Call Shell("cmd.exe /S /C " & shellstring, vbNormalFocus)
    'retval1 = Shell(Chr(34) & copybackcmd & Chr(34), vbNormalFocus)

End Sub
