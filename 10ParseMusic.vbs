'---------------------------------------------------
'---------------------------------------------------
'--Tech Metadata XML Reformat for Music Files-------
'---------------------------------------------------
'--Dec 2009 Scott Renton----------------------------
'---------------------------------------------------
'---------------------------------------------------

Option Explicit
Dim objFSO, objFolder, objShell, objInFile, objLogFile, objOutFile, objTempFile
Dim strDirectory, strWrite, strONNull, strCollNull, strEnglishName, strLen, strLeft, strBodyExtra, strRoms,strFirst, strBodyAppend, strTag, strTD, strInFile, strOutFile, strMult, strLog, strText, strReadLine, strReadLineNext, a, i, strTempFile, strOutLine, strBody


strDirectory = "U:\ISG\EULMGShared\LIBSTAFF\dld\MIMS Project\Development\MIMSWorkflow"
strInFile = "\ucdcat.txt"
strOutFile = "\ParsedMusicNewSep15.xml"
strTempFile = "\TempMusic.xml"
strLog = "\LogMusic.txt"
i = 0
a = ""
strRoms ="(i)(ii(iv(v)(vi(ix(x)(xi(xv(xx(xl(il(ic(l)(lx(lv(li(c)(ci(cv(cx"



'Create the File System Object
Set objFSO = CreateObject("Scripting.FileSystemObject")

Set objLogFile = objFSO.CreateTextFile(strDirectory & strLog)
Set objOutFile = objFSO.CreateTextFile(strDirectory & strOutFile)
Set objTempFile = objFSO.CreateTextFile(strDirectory & strTempFile)

set objInFile = objFSO.OpenTextFile(strDirectory & strInFile)


objLogFile.writeLine("Opened Test Doc")


Do While Not objInFile.AtEndOfStream
	strReadLine = objInFile.ReadLine
	a=split (strReadLine, vbTab)
        
	For i = 0 to UBound(a)
	        if instr(strReadLine,"<B>Classification:") then
	        	objLogFile.writeLine("nup")
	        else	
   			objTempFile.writeLine(a(i))
		end if
	Next
Loop

Set objTempFile = objFSO.OpenTextFile(strDirectory & strTempFile)

strFirst = "Y"
objOutFile.writeLine("<xml>")
objOutFile.writeLine(" <ItemList>")
strReadLineNext = objTempFile.ReadLine


Do While Not strReadLineNext = "END"
     if (not instr(strReadLineNext, "001") >0) then
	if instr(strReadLineNext, "NPO:") or instr(strReadLineNext, "Serial number:") or instr(strReadLineNext, "Body width, maximum:") or instr(strReadLineNext, "KWD:") or instr(strReadLineNext, "Body width:") or instr(strReadLineNext, "Nominal pitch:") or instr(strReadLineNext, "Classification:") or instr(strReadLineNext, "Culture of origin:") or instr(strReadLineNext, "String length 1:") or instr(strReadLineNext, "String length 2:") or instr(strReadLineNext, "Shell diameter:") or instr(strReadLineNext, "Shell depth:") or instr(strReadLineNext, "Number of tension points:") or instr(strReadLineNext, "Number of frets:") or instr(strReadLineNext, "Sounding length:") or instr(strReadLineNext, "Bore:") or instr(strReadLineNext, "Depth of reed/mouthpiece receiver:") or instr(strReadLineNext, "Diameter of reed/mouthpiece receiver:") or instr(strReadLineNext, "L0:") or instr(strReadLineNext, "L1:") or instr(strReadLineNext, "L2:") or instr(strReadLineNext, "L3:") or instr(strReadLineNext, "L4:") or instr(strReadLineNext, "R0:") or instr(strReadLineNext, "R1:") or instr(strReadLineNext, "R2:") or instr(strReadLineNext, "R3:") or instr(strReadLineNext, "R4:") or instr(strReadLineNext, "Keyhead type:") or instr(strReadLineNext, "Keymount type:") or instr(strReadLineNext, "Valve type:") or instr(strReadLineNext, "AN:") or instr(strReadLineNext, "ON:") or instr(strReadLineNext, "ON:") or instr(strReadLineNext, "EN:") or instr(strReadLineNext, "NP:") or instr(strReadLineNext, "TS:") or instr(strReadLineNext, "Maker:") or instr(strReadLineNext, "PL:")  or instr(strReadLineNext, "CO:")  or instr(strReadLineNext, "DM:")  or instr(strReadLineNext, "SN:") or instr(strReadLineNext, "FM:")  or  instr(strReadLineNext, "Overall size:")  or instr(strReadLineNext, "Body length:") or instr(strReadLineNext, "Body width, upper bouts:")   or instr(strReadLineNext, "Body width, waist:") or instr(strReadLineNext, "Body width, lower bouts:")  or instr(strReadLineNext, "Body depth:")  or instr(strReadLineNext, "String length:")  or instr(strReadLineNext, "String length:")  or instr(strReadLineNext, "Technical description:") or instr(strReadLineNext, "IN:")  or instr(strReadLineNext, "Decorative features:") or instr(strReadLineNext, "Playing accessories:")  or instr(strReadLineNext, "CS:")  or instr(strReadLineNext, "FL:")  or instr(strReadLineNext, "RH:")  or instr(strReadLineNext, "General usage of type:")  or instr(strReadLineNext, "General literature references:")  or instr(strReadLineNext, "General literature reference:")  or instr(strReadLineNext, "Performance characteristics:") or instr(strReadLineNext, "Usable Pitch:") or instr(strReadLineNext, "Usable pitch:")   or instr(strReadLineNext, "AW:")  or instr(strReadLineNext, "Specific literature references:") or instr(strReadLineNext, "Illustration references:")  or instr(strReadLineNext, "Specific recording references:")  or instr(strReadLineNext, "Specific usage history:") or instr(strReadLineNext, "Previous ownership:")  or instr(strReadLineNext, "Current ownership:")  or instr(strReadLineNext, "CA:")  or instr(strReadLineNext, "IND:")  or instr(strReadLineNext, "SOR:") or instr(strReadLineNext, "PNN:") or instr(strReadLineNext, "LOC:") or instr(strReadLineNext, "AQD:") or instr(strReadLineNext, "RDE:") or instr(strReadLineNext, "AOE:") or instr(strReadLineNext, "CON:") or instr(strReadLineNext, "MON:")  or instr(strReadLineNext, "CCR:")  or instr(strReadLineNext, "VAL:") or instr(strReadLineNext, "MFE:")  or instr(strReadLineNext, "MFC:") or instr(strReadLineNext, "V:") or instr(strReadLineNext, "AccessionNo:") then
		strWrite = "Y"
		
		if strFirst = "N" then
			if len(strBody) > 0 then
				if instr (strBody, " =") then 
					strBody = replace(strBody, " =", " ")
				end if	
			        if instr(strBody, "&") then
			        	strBody = replace (strBody, "&", "&#38;")
			        end if
			        
				if instr(strBody," #") then
					strBody = replace (strBody, "#", "&#163;")
				end if
				
				if instr(strBody,"*sharp") then
					strBody = replace(strBody,"*sharp","&#9839;")
				end if
				
				if instr(strBody,"*natural") then
					strBody = replace (strBody, "*natural", "&#9838;")
				end if
					
				if instr(strBody,"*flat") then
					strBody = replace (strBody, "*flat", "&#9837;")
				end if
				
				if instr(strBody,"*quarter") then
					strBody = replace (strBody, "*quarter", "&#188;")
				end if
				
				if instr(strBody,"*half") then
					strBody = replace (strBody, "*half", "&#189;")
				end if
				
				if instr(strBody,"*threequarters") then
					strBody = replace (strBody, "*threequarters", "&#190;")
				end if
				
				if instr(strBody,"A*E") then
					strBody = replace (strBody, "A*E", "&#196;")
				end if
				
				if instr(strBody,"O*E") then
					strBody = replace (strBody, "O*E", "&#214;")
				end if
				
				if instr(strBody,"U*E") then
					strBody = replace (strBody, "U*E", "&#220;")
				end if
			
				if instr(strBody,"E*E") then
					strBody = replace (strBody, "E*E", "&#203;")
				end if
				
				if instr(strBody,"a*e") then
					strBody = replace (strBody, "a*e", "&#228;")
				end if
				
				if instr(strBody,"o*e") then
					strBody = replace (strBody, "o*e", "&#246;")
				end if
				
				if instr(strBody,"u*e") then
					strBody = replace (strBody, "u*e", "&#252;")
				end if
					
				if instr(strBody,"e*e") then
					strBody = replace (strBody, "e*e", "&#235;")
				end if
				
				if instr(strBody,"a*/") then
					strBody = replace (strBody, "a*/", "&#225;")
				end if
					
				if instr(strBody,"i*/") then
					strBody = replace (strBody, "i*/", "&#237;")
				end if
					
				if instr(strBody,"e*/") then
					strBody = replace (strBody, "e*/", "&#233;")
				end if
					
				if instr(strBody,"A*/") then
					strBody = replace (strBody, "A*/", "&#193;")
				end if
					
				if instr(strBody,"I*/") then
					strBody = replace (strBody, "I*/", "&#205;")
				end if
					
				if instr(strBody,"E*/") then
					strBody = replace (strBody, "E*/", "&#201;")
				end if
					
				if instr(strBody,"a*\") then
					strBody = replace (strBody, "a*\", "&#224;")
				end if
				
				if instr(strBody,"i*\") then
					strBody = replace (strBody, "i*\", "&#236;")
				end if
					
				if instr(strBody,"e*\") then
					strBody = replace (strBody, "e*\", "&#232;")
				end if
					
				if instr(strBody,"A*\") then
					strBody = replace (strBody, "A*\", "&#192;")
				end if
					
				if instr(strBody,"I*\") then
					strBody = replace (strBody, "I*\", "&#204;")
				end if
			
				if instr(strBody,"E*\") then
					strBody = replace (strBody, "E*\", "&#200;")
				end if
				
				if instr(strBody,"c*z") then
					strBody = replace (strBody, "c*z", "&#231;")
				end if
				
				if instr(strBody,"C*Z") then
					strBody = replace (strBody, "C*Z", "&#199;")
				end if
				
				if instr(strBody,"a*s") then
					strBody = replace (strBody, "a*s", "&#226;")
				end if
				
				if instr(strBody,"e*s") then
					strBody = replace (strBody, "e*s", "&#234;")
				end if
					
				if instr(strBody,"o*s") then
					strBody = replace (strBody, "o*s", "&#244;")
				end if
					
				if instr(strBody,"u*s") then
					strBody = replace (strBody, "u*s", "&#251;")
				end if
					
				if instr(strBody,"i*s") then
					strBody = replace (strBody, "i*s", "&#238;")
				end if
				
				if instr(strBody,"A*S") then
					strBody = replace (strBody, "A*S", "&#194;")
				end if
				
				if instr(strBody,"E*S") then
					strBody = replace (strBody, "E*S", "&#202;")
				end if
				
				if instr(strBody,"I*S") then
					strBody = replace (strBody, "I*S", "&#206;")
				end if
				
				if instr(strBody,"O*S") then
					strBody = replace (strBody, "O*S", "&#212;")
				end if
				
				if instr(strBody,"U*S") then
					strBody = replace (strBody, "U*S", "&#219;")
				end if
			
				if instr(strBody,"a*a") then
					strBody = replace (strBody, "a*a", "&#229;")
				end if
				
				if instr(strBody,"A*A") then
					strBody = replace (strBody, "A*A", "&#197;")
				end if
				
				if instr(strBody,"o*i") then
					strBody = replace (strBody, "o*i", "&#248;")
				end if
				
				if instr(strBody,"O*I") then
					strBody = replace (strBody, "O*I", "&#216;")
				end if
				
				if instr(strBody,"a*y") then
					strBody = replace (strBody, "a*y", "&#227;")
				end if
					
				if instr(strBody,"n*y") then
					strBody = replace (strBody, "n*y", "&#241;")
				end if
				
				if instr(strBody,"o*y") then
					strBody = replace (strBody, "o*y", "&#245;")
				end if
				
				if instr(strBody,"N*Y") then
					strBody = replace (strBody, "N*Y", "&#209;")
				end if
					
				if instr(strBody,"O*Y") then
					strBody = replace (strBody, "A*Y", "&#213;")
				end if
					
				if instr(strBody,"A*Y") then
					strBody = replace (strBody, "A*Y", "&#195;")
				end if
				
				if instr(strBody,"c*v") then
					strBody = replace (strBody, "c*v", "&#269;")
				end if
				
				if instr(strBody,"C*V") then
					strBody = replace (strBody, "C*V", "&#268;")
				end if
				
				if instr(strBody,"a*-") then
					strBody = replace (strBody, "a*-", "&#257;")
				end if
					
				if instr(strBody,"A*-") then
					strBody = replace (strBody, "A*-", "&#256;")
				end if
					
				if instr(strBody,"*1") then
					strBody = replace (strBody, "*1", "&#8321;")
				end if
					
				if instr(strBody,"*2") then
					strBody = replace (strBody, "*2", "&#8322;")
				end if
					
				if instr(strBody,"*3") then
					strBody = replace (strBody, "*3", "&#8323;")
				end if
					
				if instr(strBody,"*4") then
					strBody = replace (strBody, "*4", "&#8324;")
				end if
					
				if instr(strBody,"*5") then
					strBody = replace (strBody, "*5", "&#8325;")
				end if
					
				if instr(strBody,"*6") then
					strBody = replace (strBody, "*6", "&#8326;")
				end if
				
				if instr(strBody,"*7") then
					strBody = replace (strBody, "*7", "&#8327;")
				end if
					
				if instr(strBody,"*8") then
					strBody = replace (strBody, "*8", "&#8328;")
				end if
					
				if instr(strBody,"*9") then
					strBody = replace (strBody, "*9", "&#8329;")
				end if
					
				if instr(strBody,"*copyright") then
					strBody = replace (strBody, "*copyright", "&#169;")
				end if
				
				if instr(strBody,"*degrees") then
					strBody = replace (strBody, "*degrees", "&#176;")
				end if
				
				if instr(strBody,"*x*") then
					strBody = replace (strBody, "*x*", "&#215;")
				end if

				if instr(strBody,"*X*") then
					strBody = replace (strBody, "*x*", "&#215;")
				end if
			
				if instr(strBody,"&&#163;38;") then
					strBody = replace (strBody, "&&#163;38;", "&#38;")
				end if

				if instr (strBody, "D*.") then
					strBody = replace(strBody, "D*.", "&#7690;")
				end if

				if instr (strBody, "d*.") then
					strBody = replace(strBody, "d*.", "&#7691;")
				end if

				if instr (strBody, "U*-") then
					strBody = replace(strBody, "U*-", "&#362;")
				end if

				if instr (strBody, "u*-") then
					strBody = replace(strBody, "u*-", "&#363;")
				end if

				if instr (strBody, "I*-") then
					strBody = replace(strBody, "I*-", "&#298;")
				end if

				if instr (strBody, "i*-") then
					strBody = replace(strBody, "i*-", "&#299;")
				end if

				if instr (strBody, "U*\") then
					strBody = replace(strBody, "U*\", "&#217;")
				end if

				if instr (strBody, "u*\") then
					strBody = replace(strBody, "u*\", "&#249;")
				end if

				if instr (strBody, "S*/") then
					strBody = replace(strBody, "S*/", "&#346;")
				end if

				if instr (strBody, "s*/") then
					strBody = replace(strBody, "s*/", "&#347;")
				end if

				if instr (strBody, "O*\") then
					strBody = replace(strBody, "O*\", "&#210;")
				end if

				if instr (strBody, "o*\") then
					strBody = replace(strBody, "o*\", "&#242;")
				end if

				if instr (strBody, "&amp;") then
					strBody = replace(strBody, "&amp;", "&#38;")
				end If
				
				if instr (strBody, """") then
					strBody = replace(strBody, """", "&#34;")
				end If
				
				if instr (strBody, "'") then
					strBody = replace(strBody, """", "&#39;")
				end If
				
				if instr (strBody, "<I>") then
					strBody = replace(strBody, "<I>", "&#60;i&#62;")
				end If
				
				if instr (strBody, "<i>") then
					strBody = replace(strBody, "<i>", "&#60;i&#62;")
				end If
				
				if instr (strBody, "</i>") then
					strBody = replace(strBody, "</i>", "&#60;&#47;i&#62;")
				end If
				
				if instr (strBody, "</I>") then
					strBody = replace(strBody, "</I>", "&#60;&#47;i&#62;")
				end If
				
				if instr (strBody, "<B>") then
					strBody = replace(strBody, "<B>", "&#60;b&#62;")
				end If
				
				if instr (strBody, "<b>") then
					strBody = replace(strBody, "<b>", "&#60;b&#62;")
				end If
				
				if instr (strBody, "</b>") then
					strBody = replace(strBody, "</b>", "&#60;&#47;b&#62;")
				end If
				
				if instr (strBody, "</B>") then
					strBody = replace(strBody, "</B>", "&#60;&#47;b&#62;")
				end If
				
if instr (strBody,"€") then strBody = replace(strBody,"€","&#128;")  end if
if instr (strBody,"ƒ") then strBody = replace(strBody,"ƒ","&#131;")  end if
if instr (strBody,"…") then strBody = replace(strBody,"…","&#133;")  end if
if instr (strBody,"†") then strBody = replace(strBody,"†","&#134;")  end if
if instr (strBody,"‡") then strBody = replace(strBody,"‡","&#135;")  end if
if instr (strBody,"ˆ") then strBody = replace(strBody,"ˆ","&#136;")  end if
if instr (strBody,"‰") then strBody = replace(strBody,"‰","&#137;")  end if
if instr (strBody,"Š") then strBody = replace(strBody,"Š","&#138;")  end if
if instr (strBody,"Œ") then strBody = replace(strBody,"Œ","&#140;")  end if
if instr (strBody,"Ž") then strBody = replace(strBody,"Ž","&#142;")  end if
if instr (strBody,"™") then strBody = replace(strBody,"™","&#153;")  end if
if instr (strBody,"š") then strBody = replace(strBody,"š","&#154;")  end if
if instr (strBody,"œ") then strBody = replace(strBody,"œ","&#156;")  end if
if instr (strBody,"ž ") then strBody = replace(strBody,"ž ","&#158;")  end if
if instr (strBody,"Ÿ") then strBody = replace(strBody,"Ÿ","&#159;")  end if
if instr (strBody,"¡") then strBody = replace(strBody,"¡","&#161;")  end if
if instr (strBody,"¢") then strBody = replace(strBody,"¢","&#162;")  end if
if instr (strBody,"£") then strBody = replace(strBody,"£","&#163;")  end if
if instr (strBody,"¤") then strBody = replace(strBody,"¤","&#164;")  end if
if instr (strBody,"¥") then strBody = replace(strBody,"¥","&#165;")  end if
if instr (strBody,"¦") then strBody = replace(strBody,"¦","&#166;")  end if
if instr (strBody,"§") then strBody = replace(strBody,"§","&#167;")  end if
if instr (strBody,"¨") then strBody = replace(strBody,"¨","&#168;")  end if
if instr (strBody,"©") then strBody = replace(strBody,"©","&#169;")  end if
if instr (strBody,"ª") then strBody = replace(strBody,"ª","&#170;")  end if
if instr (strBody,"«") then strBody = replace(strBody,"«","&#171;")  end if
if instr (strBody,"¬") then strBody = replace(strBody,"¬","&#172;")  end if
if instr (strBody,"­") then strBody = replace(strBody,"­","&#173;")  end if
if instr (strBody,"®") then strBody = replace(strBody,"®","&#174;")  end if
if instr (strBody,"¯") then strBody = replace(strBody,"¯","&#175;")  end if
if instr (strBody,"°") then strBody = replace(strBody,"°","&#176;")  end if
if instr (strBody,"±") then strBody = replace(strBody,"±","&#177;")  end if
if instr (strBody,"²") then strBody = replace(strBody,"²","&#178;")  end if
if instr (strBody,"³") then strBody = replace(strBody,"³","&#179;")  end if
if instr (strBody,"´") then strBody = replace(strBody,"´","&#180;")  end if
if instr (strBody,"µ") then strBody = replace(strBody,"µ","&#181;")  end if
if instr (strBody,"¶") then strBody = replace(strBody,"¶","&#182;")  end if
if instr (strBody,"·") then strBody = replace(strBody,"·","&#183;")  end if
if instr (strBody,"¸") then strBody = replace(strBody,"¸","&#184;")  end if
if instr (strBody,"¹") then strBody = replace(strBody,"¹","&#185;")  end if
if instr (strBody,"º") then strBody = replace(strBody,"º","&#186;")  end if
if instr (strBody,"»") then strBody = replace(strBody,"»","&#187;")  end if
if instr (strBody,"¼") then strBody = replace(strBody,"¼","&#188;")  end if
if instr (strBody,"½") then strBody = replace(strBody,"½","&#189;")  end if
if instr (strBody,"¾") then strBody = replace(strBody,"¾","&#190;")  end if
if instr (strBody,"¿") then strBody = replace(strBody,"¿","&#191;")  end if
if instr (strBody,"À") then strBody = replace(strBody,"À","&#192;")  end if
if instr (strBody,"Á") then strBody = replace(strBody,"Á","&#193;")  end if
if instr (strBody,"Â") then strBody = replace(strBody,"Â","&#194;")  end if
if instr (strBody,"Ã") then strBody = replace(strBody,"Ã","&#195;")  end if
if instr (strBody,"Ä") then strBody = replace(strBody,"Ä","&#196;")  end if
if instr (strBody,"Å") then strBody = replace(strBody,"Å","&#197;")  end if
if instr (strBody,"Æ") then strBody = replace(strBody,"Æ","&#198;")  end if
if instr (strBody,"Ç") then strBody = replace(strBody,"Ç","&#199;")  end if
if instr (strBody,"È") then strBody = replace(strBody,"È","&#200;")  end if
if instr (strBody,"É") then strBody = replace(strBody,"É","&#201;")  end if
if instr (strBody,"Ë") then strBody = replace(strBody,"Ë","&#203;")  end if
if instr (strBody,"Ì") then strBody = replace(strBody,"Ì","&#204;")  end if
if instr (strBody,"Í") then strBody = replace(strBody,"Í","&#205;")  end if
if instr (strBody,"Î") then strBody = replace(strBody,"Î","&#206;")  end if
if instr (strBody,"Ï") then strBody = replace(strBody,"Ï","&#207;")  end if
if instr (strBody,"Ð") then strBody = replace(strBody,"Ð","&#208;")  end if
if instr (strBody,"Ñ") then strBody = replace(strBody,"Ñ","&#209;")  end if
if instr (strBody,"Ò") then strBody = replace(strBody,"Ò","&#210;")  end if
if instr (strBody,"Ó") then strBody = replace(strBody,"Ó","&#211;")  end if
if instr (strBody,"Ô") then strBody = replace(strBody,"Ô","&#212;")  end if
if instr (strBody,"Õ") then strBody = replace(strBody,"Õ","&#213;")  end if
if instr (strBody,"Ö") then strBody = replace(strBody,"Ö","&#214;")  end if
if instr (strBody,"×") then strBody = replace(strBody,"×","&#215;")  end if
if instr (strBody,"Ø") then strBody = replace(strBody,"Ø","&#216;")  end if
if instr (strBody,"Ù") then strBody = replace(strBody,"Ù","&#217;")  end if
if instr (strBody,"Ú") then strBody = replace(strBody,"Ú","&#218;")  end if
if instr (strBody,"Û") then strBody = replace(strBody,"Û","&#219;")  end if
if instr (strBody,"Ü") then strBody = replace(strBody,"Ü","&#220;")  end if
if instr (strBody,"Ý") then strBody = replace(strBody,"Ý","&#221;")  end if
if instr (strBody,"Þ") then strBody = replace(strBody,"Þ","&#222;")  end if
if instr (strBody,"ß") then strBody = replace(strBody,"ß","&#223;")  end if
if instr (strBody,"ß") then strBody = replace(strBody,"ß","&#223;")  end if
if instr (strBody,"à") then strBody = replace(strBody,"à","&#224;")  end if
if instr (strBody,"à") then strBody = replace(strBody,"à","&#224;")  end if
if instr (strBody,"á") then strBody = replace(strBody,"á","&#225;")  end if
if instr (strBody,"á") then strBody = replace(strBody,"á","&#225;")  end if
if instr (strBody,"â") then strBody = replace(strBody,"â","&#226;")  end if
if instr (strBody,"â") then strBody = replace(strBody,"â","&#226;")  end if
if instr (strBody,"ã") then strBody = replace(strBody,"ã","&#227;")  end if
if instr (strBody,"ã") then strBody = replace(strBody,"ã","&#227;")  end if
if instr (strBody,"ä") then strBody = replace(strBody,"ä","&#228;")  end if
if instr (strBody,"ä") then strBody = replace(strBody,"ä","&#228;")  end if
if instr (strBody,"å") then strBody = replace(strBody,"å","&#229;")  end if
if instr (strBody,"å") then strBody = replace(strBody,"å","&#229;")  end if
if instr (strBody,"æ") then strBody = replace(strBody,"æ","&#230;")  end if
if instr (strBody,"æ") then strBody = replace(strBody,"æ","&#230;")  end if
if instr (strBody,"ç") then strBody = replace(strBody,"ç","&#231;")  end if
if instr (strBody,"ç") then strBody = replace(strBody,"ç","&#231;")  end if
if instr (strBody,"è") then strBody = replace(strBody,"è","&#232;")  end if
if instr (strBody,"è") then strBody = replace(strBody,"è","&#232;")  end if
if instr (strBody,"é") then strBody = replace(strBody,"é","&#233;")  end if
if instr (strBody,"é") then strBody = replace(strBody,"é","&#233;")  end if
if instr (strBody,"ê") then strBody = replace(strBody,"ê","&#234;")  end if
if instr (strBody,"ê") then strBody = replace(strBody,"ê","&#234;")  end if
if instr (strBody,"ë") then strBody = replace(strBody,"ë","&#235;")  end if
if instr (strBody,"ë") then strBody = replace(strBody,"ë","&#235;")  end if
if instr (strBody,"ì") then strBody = replace(strBody,"ì","&#236;")  end if
if instr (strBody,"ì") then strBody = replace(strBody,"ì","&#236;")  end if
if instr (strBody,"í") then strBody = replace(strBody,"í","&#237;")  end if
if instr (strBody,"í") then strBody = replace(strBody,"í","&#237;")  end if
if instr (strBody,"î") then strBody = replace(strBody,"î","&#238;")  end if
if instr (strBody,"î") then strBody = replace(strBody,"î","&#238;")  end if
if instr (strBody,"ï") then strBody = replace(strBody,"ï","&#239;")  end if
if instr (strBody,"ï") then strBody = replace(strBody,"ï","&#239;")  end if
if instr (strBody,"ð") then strBody = replace(strBody,"ð","&#240;")  end if
if instr (strBody,"ð") then strBody = replace(strBody,"ð","&#240;")  end if
if instr (strBody,"ñ") then strBody = replace(strBody,"ñ","&#241;")  end if
if instr (strBody,"ñ") then strBody = replace(strBody,"ñ","&#241;")  end if
if instr (strBody,"ò") then strBody = replace(strBody,"ò","&#242;")  end if
if instr (strBody,"ò") then strBody = replace(strBody,"ò","&#242;")  end if
if instr (strBody,"ó") then strBody = replace(strBody,"ó","&#243;")  end if
if instr (strBody,"ó") then strBody = replace(strBody,"ó","&#243;")  end if
if instr (strBody,"ô") then strBody = replace(strBody,"ô","&#244;")  end if
if instr (strBody,"ô") then strBody = replace(strBody,"ô","&#244;")  end if
if instr (strBody,"õ") then strBody = replace(strBody,"õ","&#245;")  end if
if instr (strBody,"õ") then strBody = replace(strBody,"õ","&#245;")  end if
if instr (strBody,"ö") then strBody = replace(strBody,"ö","&#246;")  end if
if instr (strBody,"ö") then strBody = replace(strBody,"ö","&#246;")  end if
if instr (strBody,"÷") then strBody = replace(strBody,"÷","&#247;")  end if
if instr (strBody,"÷") then strBody = replace(strBody,"÷","&#247;")  end if
if instr (strBody,"ø") then strBody = replace(strBody,"ø","&#248;")  end if
if instr (strBody,"ø") then strBody = replace(strBody,"ø","&#248;")  end if
if instr (strBody,"ù") then strBody = replace(strBody,"ù","&#249;")  end if
if instr (strBody,"ù") then strBody = replace(strBody,"ù","&#249;")  end if
if instr (strBody,"ú") then strBody = replace(strBody,"ú","&#250;")  end if
if instr (strBody,"ú") then strBody = replace(strBody,"ú","&#250;")  end if
if instr (strBody,"û") then strBody = replace(strBody,"û","&#251;")  end if
if instr (strBody,"û") then strBody = replace(strBody,"û","&#251;")  end if
if instr (strBody,"ü") then strBody = replace(strBody,"ü","&#252;")  end if
if instr (strBody,"ü") then strBody = replace(strBody,"ü","&#252;")  end if
if instr (strBody,"ý") then strBody = replace(strBody,"ý","&#253;")  end if
if instr (strBody,"ý") then strBody = replace(strBody,"ý","&#253;")  end if
if instr (strBody,"þ") then strBody = replace(strBody,"þ","&#254;")  end if
if instr (strBody,"þ") then strBody = replace(strBody,"þ","&#254;")  end if
if instr (strBody,"ÿ") then strBody = replace(strBody,"ÿ","&#255;")  end if
if instr (strBody,"ÿ") then strBody = replace(strBody,"ÿ","&#255;")  end if


			
				objOutFile.writeLine ("		<" & strTag & ">" & strBody & "</" & strTag & ">")
			end if
		end if	
		
		'if instr(strReadLineNext, "CL:" ) then
		'	if strFirst = "N" then
		'		objOutFile.WriteLine("	</Item>")
		'	end if
		'	objOutFile.writeLine("	<Item>")
		'	strBody = ltrim(replace(strReadLineNext, "CL:",""))
		'	strTag = "Classification"
		'end if

		'if instr(strReadLineNext, "Classification:" ) then
		'	if strFirst = "N" then
		'		objOutFile.WriteLine("	</Item>")
		'	end if
		'	objOutFile.writeLine("	<Item>")
		'	strBody = ltrim(replace(strReadLineNext, "<B>Classification:",""))
		'	strBody = replace(strBody, "</b>" ,"")
		'	strTag = "Classification"
		'end if

		if instr(strReadLineNext, "AN:") then 
			'objLogFile.writeLine("at top " & strONNull)
			'if (strONNull = "null") then
			'	objOutFile.writeLine("		<OriginalName>" & strEnglishName & "</OriginalName>")
			'end if
			'strONNull = "null"
			if (strCollNull = "null") then
				objOutFile.writeLine("		<CollectionAssignation>EUCHMI Collection</CollectionAssignation>")
			end if	
			strCollNull = "null"
			if strFirst = "N" then
				objOutFile.WriteLine("	</Item>")
			end if
			objOutFile.writeLine("	<Item>")
			strBody = ltrim(replace(strReadLineNext, "AN:",""))
			strBody = replace(strBody, "(","")
			strBody = replace(strBody, ")","")
			strTag = "AcquisitionNumber"
		end if

		if instr(strReadLineNext, "ON:") then
			if (instr(strReadLineNext, "CON:") or instr(strReadLineNext,"MON:")) then
				objLogFile.writeLine ("not the right bit!")
			else
		 	'	objLogFile.writeLine ("upon entering ON process: " & strReadLineNext & strONNull)
				strBody = ltrim(replace(strReadLineNext, "ON:",""))
				strLen = len(strBody)	
				strTag = "OriginalName"
			'	if (strReadLineNext = "ON:") then
			'		strONNull = "null"
			'	else
			'		objLogFile.writeLine ("setting to not null")
			'		strONNull = "not"
			'	end if
			end if
		end if
		
		if (instr(strReadLineNext, "EN:")) then 
		        objLogFile.writeLine ("EnglishName?" & strReadLineNext)
			strBody = ltrim(replace(strReadLineNext, "EN:",""))
			strEnglishName = strBody
			strTag = "EnglishName"
			strLen = len(strBody)	
		end if
	
		if instr(strReadLineNext, "Nominal pitch:") then 
			objLogFile.writeLine ("Nominal pitch?" & strReadLineNext)
			'strBody = ltrim(replace(strReadLineNext, "Nominal pitch:",""))
			if strReadLineNext = "Nominal pitch:" then
				strBody = "Nominal pitch:"
			else	
				strBody = strReadLineNext
			end if
			strTag = "NominalPitch"
			strLen = len(strBody)	
		end if
		
		if instr(strReadLineNext, "NP:") then 
			'strBody = ltrim(replace(strReadLineNext, "NP:",""))
			if strReadLineNext = "NP:" then
				strBody = "Nominal pitch:"
			else	
				strBody = strReadLineNext
			end if
			strTag = "NominalPitch"
			strLen = len(strBody)
			
		end if		
	
		if instr(strReadLineNext, "TS:") then 
			strBody = ltrim(replace(strReadLineNext, "TS:",""))
			strTag = "TypeOrSystem"
			strLen = len(strBody)
			
		end If
		
		if instr(strReadLineNext, "V:") then 
			strBody = ltrim(replace(strReadLineNext, "V:",""))
			strTag = "Vernon"
			strLen = len(strBody)
			
		end If
		
		if instr(strReadLineNext, "AccessionNo:") then 
			strBody = ltrim(replace(strReadLineNext, "AccessionNo:",""))
			strTag = "Accession_No"
			strLen = len(strBody)
			
		end if
	
		if instr(strReadLineNext, "Maker:") then 
			strBody = ltrim(replace(strReadLineNext, "Maker:",""))
			strTag = "Maker"
			strLen = len(strBody)
			
		end if
	
		if instr(strReadLineNext, "PL:") then 
			strBody = ltrim(replace(strReadLineNext, "PL:",""))
			strTag = "PlaceOfOrigin"
			strLen = len(strBody)
			
		end if

		if instr(strReadLineNext, "CO:")  then 
			strBody = ltrim(replace(strReadLineNext, "CO:",""))
			strTag = "CultureOfOrigin"
			strLen = len(strBody)
			
		end if
		
		if instr(strReadLineNext, "Culture of origin:") then
			strBody = ltrim(replace(strReadLineNext, "Culture of origin:",""))
			strTag = "CultureOfOrigin"
			strLen = len(strBody)		
		end if		
	
		if instr(strReadLineNext, "DM:") then 
			strBody = ltrim(replace(strReadLineNext, "DM:",""))
			if Right(strBody,1) = "." then
				strBody = left(strBody,len(strBody) - 1)
			end if	
			strTag = "DateMade"
			strLen = len(strBody)
			
		end if
		
		if instr(strReadLineNext, "SN:") then 
			strBody = ltrim(replace(strReadLineNext, "SN:",""))
			strTag = "SerialNo"
			strLen = len(strBody)
			
		end if
		
		if instr(strReadLineNext, "Serial number:") then 
			strBody = ltrim(replace(strReadLineNext, "Serial number:",""))
			strTag = "SerialNo"
			strLen = len(strBody)
					
		end if
		
		if instr(strReadLineNext, "FM:") then 
			strBody = ltrim(replace(strReadLineNext, "FM:",""))
			strTag = "FurtherInfo"
		end if
	
		if instr(strReadLineNext, "Overall size:") then 
			strBody = ltrim(replace(strReadLineNext, "Overall size:",""))
			strTag = "OverallSize"
			strLen = len(strBody)
			
		end if
	
		if instr(strReadLineNext, "Body length:") then 
			strBody = ltrim(replace(strReadLineNext, "Body length:",""))
			strTag = "BodyLength"
			strLen = len(strBody)
			
		end if
	
		if instr(strReadLineNext, "Body width, upper bouts:") then 
			strBody = ltrim(replace(strReadLineNext, "Body width, upper bouts:",""))
			strTag = "BodyWidthUpperBouts"
			strLen = len(strBody)
			
		end if
	
		if instr(strReadLineNext, "Body width, waist:") then 
			strBody = ltrim(replace(strReadLineNext, "Body width, waist:",""))
			strTag = "BodyWidthWaist"	
			strLen = len(strBody)
			
		end if
	
		if instr(strReadLineNext, "Body width, lower bouts:") then 
			strBody = ltrim(replace(strReadLineNext, "Body width, lower bouts:",""))
			strTag = "BodyWidthLowerBouts"
			strLen = len(strBody)
			
		end if
		
		if instr(strReadLineNext, "Body width, maximum:") then 
			strBody = ltrim(replace(strReadLineNext, "Body width, maximum:",""))
			strTag = "BodyWidthMaximum"
			strLen = len(strBody)
			
		end if
	
		if instr(strReadLineNext, "Body depth:") then 
			strBody = ltrim(replace(strReadLineNext, "Body depth:",""))
			strTag = "BodyDepth"
			strLen = len(strBody)
			
		end if
		
		if instr(strReadLineNext, "Body width:") then 
			strBody = ltrim(replace(strReadLineNext, "Body width:",""))
			strTag = "BodyWidth"
			strLen = len(strBody)		
		end if
	
		if instr(strReadLineNext, "String length:") then 
			strBody = ltrim(replace(strReadLineNext, "String length:",""))
			strTag = "StringLength"	
			strLen = len(strBody)
		end if
	
		if instr(strReadLineNext, "String length 1:") then 
			strBody = ltrim(replace(strReadLineNext, "String length 1:",""))
			strTag = "StringLength1"	
			strLen = len(strBody)
		end if

		if instr(strReadLineNext, "String length 2:") then 
			strBody = ltrim(replace(strReadLineNext, "String length 2:",""))
			strTag = "StringLength2"	
			strLen = len(strBody)
		end if
		
		if instr(strReadLineNext, "Shell diameter:") then 
			strBody = ltrim(replace(strReadLineNext, "Shell diameter:",""))
			strTag = "ShellDiameter"
			strLen = len(strBody)
		end if

		if instr(strReadLineNext, "Shell depth:") then 
			strBody = ltrim(replace(strReadLineNext, "Shell depth:",""))
			strTag = "ShellDepth"
			strLen = len(strBody)
		end if

		if instr(strReadLineNext, "Number of tension points:") then 
			strBody = ltrim(replace(strReadLineNext, "Number of tension points:",""))
			strTag = "NumberOfTensionPoints"	
			strLen = len(strBody)
		end if

		if instr(strReadLineNext, "Number of frets:") then 
			strBody = ltrim(replace(strReadLineNext, "Number of frets:",""))
			strTag = "NumberOfFrets"	
			strLen = len(strBody)
		end if

		if instr(strReadLineNext, "Sounding length:") then 
			strBody = ltrim(replace(strReadLineNext, "Sounding length:",""))
			strTag = "SoundingLength"
			strLen = len(strBody)
		end if

		if instr(strReadLineNext, "Bore:") then 
			strBody = ltrim(replace(strReadLineNext, "Bore:",""))
			strTag = "Bore"	
			strLen = len(strBody)
		end if

		if instr(strReadLineNext, "Depth of reed/mouthpiece receiver:") then 
			strBody = ltrim(replace(strReadLineNext, "Depth of reed/mouthpiece receiver:",""))
			strTag = "DepthOfReedMouthpieceReceiver"	
			strLen = len(strBody)
		end if

		if instr(strReadLineNext, "Diameter of reed/mouthpiece receiver:") then 
			strBody = ltrim(replace(strReadLineNext, "Diameter of reed/mouthpiece receiver:",""))
			strTag = "DiameterOfReedMouthpieceReceiver"
			strLen = len(strBody)
		end if

		if instr(strReadLineNext, "Technical description:") then 
			'strBody = ltrim(replace(strReadLineNext, "Technical description:",""))
			if strReadLineNext = "Technical description:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if	
			strTag = "TechnicalDescription"
		end if

		if instr(strReadLineNext, "L0:") then 
			'strBody = ltrim(replace(strReadLineNext, "L0:",""))
			if strReadLineNext = "L0:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "L0"	
		end if

		if instr(strReadLineNext, "L1:") then 
			'strBody = ltrim(replace(strReadLineNext, "L1:",""))
			if strReadLineNext = "L1:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "L1"	
		end if

		if instr(strReadLineNext, "L2:") then 
			'strBody = ltrim(replace(strReadLineNext, "L2:",""))
			if strReadLineNext = "L2:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "L2"	
		end if

		if instr(strReadLineNext, "L3:") then 
			'strBody = ltrim(replace(strReadLineNext, "L3:",""))
			if strReadLineNext = "L3:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "L3"	
		end if

		if instr(strReadLineNext, "L4:") then 
			'strBody = ltrim(replace(strReadLineNext, "L4:",""))
			if strReadLineNext = "L4:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "L4"	
		end if

		if instr(strReadLineNext, "R0:") then 
			'strBody = ltrim(replace(strReadLineNext, "R0:",""))
			if strReadLineNext = "L5:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "R0"	
		end if

		if instr(strReadLineNext, "R1:") then 
			'strBody = ltrim(replace(strReadLineNext, "R1:",""))
			if strReadLineNext = "R1:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "R1"	
		end if

		if instr(strReadLineNext, "R2:") then 
			'strBody = ltrim(replace(strReadLineNext, "R2:",""))
			if strReadLineNext = "R2:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "R2"	
		end if

		if instr(strReadLineNext, "R3:") then 
			'strBody = ltrim(replace(strReadLineNext, "R3:",""))
			if strReadLineNext = "R3:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "R3"	
		end if

		if instr(strReadLineNext, "R4:") then 
			'strBody = ltrim(replace(strReadLineNext, "R4:",""))
			if strReadLineNext = "R4:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "R4"	
		end if

		if instr(strReadLineNext, "Keyhead type:") then 
			'strBody = ltrim(replace(strReadLineNext, "Keyhead type:",""))
			if strReadLineNext = "Keyhead type:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "KeyheadType"	
		end if

		if instr(strReadLineNext, "Keymount type:") then 
			'strBody = ltrim(replace(strReadLineNext, "Keymount type:",""))
			if strReadLineNext = "Keymount type:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "KeymountType"	
		end if

		if instr(strReadLineNext, "Valve type:") then 
			'strBody = ltrim(replace(strReadLineNext, "Valve type:",""))
			if strReadLineNext = "Valve type:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "ValveType"	
		end if

		if instr(strReadLineNext, "IN:") then 
			strBody = ltrim(replace(strReadLineNext, "IN:",""))
			strTag = "Inscriptions"	
		end if
	
		if instr(strReadLineNext, "Decorative features:") then 
			strBody = ltrim(replace(strReadLineNext, "Decorative features:",""))
			strTag = "DecorativeFeatures"	
		end if
	
		if instr(strReadLineNext, "Playing accessories:") then 
			objLogFile.writeLine ("Playingaccessories?" & strReadLineNext)
			strBody = ltrim(replace(strReadLineNext, "Playing accessories:",""))
			strTag = "PlayingAccessories"
		end if

		if instr(strReadLineNext, "CS:") then 
			strBody = ltrim(replace(strReadLineNext, "CS:",""))
			strTag = "Case"	
		end if

		if instr(strReadLineNext, "FL:") then 
			strBody = ltrim(replace(strReadLineNext, "FL:",""))
			strTag = "Faults"	
		end if
	
		if instr(strReadLineNext, "RH:") then 
			strBody = ltrim(replace(strReadLineNext, "RH:","Repair History:"))
			if strReadLineNext = "RH:" then
				strBody = ""
			end if	
			strTag = "RepairHistory"
		end if
	
		if instr(strReadLineNext, "General usage of type:") then 
			'strBody = ltrim(replace(strReadLineNext, "General usage of type:",""))
			if strReadLineNext = "General usage of type:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "GeneralUsageOfType"	
		end if
		
		if instr(strReadLineNext, "General literature references:") then 
			'strBody = ltrim(replace(strReadLineNext, "General literature references:",""))
			if strReadLineNext = "General literature references:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "GeneralLiteratureReferences"	
		end if
		
		if instr(strReadLineNext, "General literature reference:") then 
			if strReadLineNext = "General literature reference:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "GeneralLiteratureReferences"	
		end if		
	
		if instr(strReadLineNext, "Performance characteristics:") then 
			strBody = ltrim(replace(strReadLineNext, "Performance characteristics:",""))
			if strReadLineNext = "Performance characteristics:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "PerformanceCharacteristics"	
		end if
	
		if instr(strReadLineNext, "Usable pitch:") then 
			objLogFile.writeLine ("Usablepitch?" & strReadLineNext)
			'strBody = ltrim(replace(strReadLineNext, "Usable pitch:",""))
			if strReadLineNext = "Usable pitch:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "UsablePitch"	
		end if
		
		if instr(strReadLineNext, "AW:") then 
			strBody = ltrim(replace(strReadLineNext, "AW:",""))
			strTag = "AssociationWithOtherItems"	
		end if
	
		if instr(strReadLineNext, "Specific literature references:") then 
			'strBody = ltrim(replace(strReadLineNext, "Specific literature references:",""))
			if strReadLineNext = "Specific literature references:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "SpecificLiteratureReferences"	
		end if
	
		if instr(strReadLineNext, "Illustration references:") then 
			'strBody = ltrim(replace(strReadLineNext, "Illustration references:",""))
			if strReadLineNext = "Illustration references:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "IllustrationReferences"
			strLen = len(strBody)
		end if
	
		if instr(strReadLineNext, "Specific recording references:") then 
			'strBody = ltrim(replace(strReadLineNext, "Specific recording references:",""))
			if strReadLineNext = "Specific recording references:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "SpecificRecordingReferences"	
			strLen = len(strBody)
		end if
	
		if instr(strReadLineNext, "Specific usage history:") then 
			'strBody = ltrim(replace(strReadLineNext, "Specific usage history:",""))
			if strReadLineNext = "Specific usage history:" then
				strBody = ""
			else	
				strBody = strReadLineNext
			end if
			strTag = "SpecificUsageHistory"	
			strLen = len(strBody)
		end if
		
		if instr(strReadLineNext, "Previous ownership:") then 
			strBody = ltrim(replace(strReadLineNext, "Previous ownership:",""))
			strTag = "PreviousOwnership"
			strLen = len(strBody)
			
		end if
	
		if instr(strReadLineNext, "Current ownership:") then 
			strBody = ltrim(replace(strReadLineNext, "Current ownership:",""))
			strTag = "CurrentOwnership"	
			strLen = len(strBody)
			
		end if
	
		if instr(strReadLineNext, "CA:") then 
			strBody = ltrim(replace(strReadLineNext, "CA:",""))
			strTag = "CollectionAssignation"
			if strReadLineNext = "CA:" then
				strCollNull = "null"
			else
				strCollNull = "not"
			end if
			strLen = len(strBody)
			
		end if
		
		if instr(strReadLineNext, "NPO:") then 
			strBody = ltrim(replace(strReadLineNext, "NPO:",""))
			strTag = "NamePrivateOwner"
			strLen = len(strBody)
					
		end if
		
		if instr(strReadLineNext, "KWD:") then 
			strBody = ltrim(replace(strReadLineNext, "KWD:",""))
			strTag = "Keyword"
			strLen = len(strBody)
							
		end if
	
		if instr(strReadLineNext, "IND:") then 
			strBody = ltrim(replace(strReadLineNext, "IND:",""))
			strTag = "IndexReference"
			strLen = len(strBody)
			
		end if

		if instr(strReadLineNext, "SOR:") then 
			strBody = ltrim(replace(strReadLineNext, "SOR:",""))
			strTag = "SortingNumber"
			strLen = len(strBody)
			
		end if

		if instr(strReadLineNext, "PNN:") then 
			strBody = ltrim(replace(strReadLineNext, "PNN:",""))
			strTag = "PhotographicNegativeNumbers"
			strLen = len(strBody)
				
		end if
	
		if instr(strReadLineNext, "LOC:") then 
			strBody = ltrim(replace(strReadLineNext, "LOC:",""))
			strTag = "Location"
			strLen = len(strBody)
			
		end if
		
		if instr(strReadLineNext, "AQD:") then 
			strBody = ltrim(replace(strReadLineNext, "AQD:",""))
			if Right(strBody,1) = "." then
				strBody = left(strBody,len(strBody) - 1)
			end if	
			strTag = "AcquisitionDate"
			strLen = len(strBody)
			
		end if
		
		if instr(strReadLineNext, "RDE:") then 
			strBody = ltrim(replace(strReadLineNext, "RDE:",""))
			if Right(strBody,1) = "." then
				strBody = left(strBody,len(strBody) - 1)
			end if	
			strTag = "RevisionDatesOfEntry"	
			strLen = len(strBody)
			
		end if
		
		if instr(strReadLineNext, "AOE:") then 
			strBody = ltrim(replace(strReadLineNext, "AOE:",""))
			strTag = "AuthorshipOfEntry"
			strLen = len(strBody)
			
		end if
	
		if instr(strReadLineNext, "CON:") then 
			strBody = ltrim(replace(strReadLineNext, "CON:","Conservation Record:"))
			if strReadLineNext = "CON:" then
				strBody = ""
			end if	
			strTag = "ConservationRecord"
			strLen = len(strBody)
		end if

		if instr(strReadLineNext, "MON:") then 
			strBody = ltrim(replace(strReadLineNext, "MON:","Condition Monitoring:"))
			if strReadLineNext = "MON:" then
				strBody = ""
			end if	
			strTag = "ConditionMonitoring"	
			strLen = len(strBody)
			
		end if

		if instr(strReadLineNext, "CCR:") then 
			strBody = ltrim(replace(strReadLineNext, "CCR:",""))
			strTag = "CustodialCategory"
			strLen = len(strBody)
			
		end if

		if instr(strReadLineNext, "VAL:") then 
			strBody = ltrim(replace(strReadLineNext, "VAL:",""))
			strTag = "Valuation"	
			strLen = len(strBody)
			
		end if
	
		if instr(strReadLineNext, "MFE:") then 
			strBody = ltrim(replace(strReadLineNext, "MFE:",""))
			strTag = "MemorandaForEditor"
			strLen = len(strBody)
		end if
	
		if instr(strReadLineNext, "MFC:") then 
			strBody = ltrim(replace(strReadLineNext, "MFC:",""))
			strTag = "MemorandaForCurator"
			strLen = len(strBody)
		end if
		
		
		strWrite = "Y"
		
	else 
		strBodyAppend = strReadLineNext
		strBody = strBody & strBodyAppend
		strWrite = "N"	
	end if

    end if
    strFirst = "N"

    strReadLineNext=objTempFile.readLine
  
Loop

if len(strBody) > 0 and strWrite = "Y" then
	objOutFile.writeLine ("		<" & strTag & ">" & strBody & "</" & strTag & ">")
end if


objOutFile.writeLine("  </Item>")
objOutFile.writeLine(" </ItemList>")
objOutFile.writeLine("</xml>")

    
WScript.Quit