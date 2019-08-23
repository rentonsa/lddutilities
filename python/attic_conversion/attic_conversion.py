"""
# Scott Renton, May 2019
# Attic parser
"""

#global variable definition, general setup
import os
import shutil
import json
import csv
import argparse
from datetime import timedelta, date



import xml.etree.ElementTree as ET

xmlin = 'Attic_XML.xml'

tree = ET.parse(xmlin)
root = tree.getroot()
from xml.dom import minidom

#fm = open(mapping.txt)

csvfileout = open('import.csv', 'w')
writer = csv.writer(csvfileout,delimiter=',',quotechar='"')

writer.writerow(['author','title','date','publisher', 'subject',  'type', 'qualname', 'quallevel', 'abstract', 'catalogued', 'file1', 'file2', 'file3', 'subject1', 'subject2', 'subject3', 'estc', 'description', 'language', 'identifier',])

atticfolder = '/Users/srenton1/Projects/theses'
def main():
    """
    This is the main processing loop to traverse the API json returned
    """
    child_no = 0
    nomatch = 0
    for child in root:
        child_no +=1
        intime = 1
        subject3 = ''
        a100 = ''
        c100 = ''
        q100 = ''
        d100 = ''
        a245 = ''
        b245 = ''
        c245 = ''
        a510 = ''
        c510 = ''
        a600 = ''
        q600 = ''
        c600 = ''
        d600 = ''
        t600 = ''
        a650 = ''
        x650 = ''
        z650 = ''
        matched_already = False
        filelist = []

        for item in child:
            if item.tag == 'controlfield':
                controltag = item.attrib['tag']
                if controltag=='001':
                    identifier = item.text
                    fm = open("match_list.txt", "r")
                    for line in fm.readlines():

                        if identifier.strip() == line.strip():
                            matched_already = True
                            print("We already have " + identifier)

            if item.tag == 'controlfield':
                controltag = item.attrib['tag']
                if controltag=='008':
                    date = item.text[7:11]
                    lang=item.text[35:38]
            if item.tag == 'datafield':
                tag = item.attrib['tag']
                if tag == '100':
                    for sub_field in item:
                        code = sub_field.attrib['code']
                        if code == 'a':
                            a100 = sub_field.text
                        if code == 'c':
                            c100 = sub_field.text
                        if code == 'q':
                            q100 = sub_field.text
                        if code == 'd':
                            d100 = sub_field.text

                if tag == '245':
                    for sub_field in item:
                        code = sub_field.attrib['code']
                        if code == 'a':
                            a245 = sub_field.text
                        if code == 'b':
                            b245 = sub_field.text
                        if code == 'c':
                            c245 = sub_field.text

                if tag == '502':
                    for sub_field in item:
                        code = sub_field.attrib['code']
                        if code == 'a':
                            description= sub_field.text

                if tag == '510':
                    for sub_field in item:
                        code = sub_field.attrib['code']
                        if code == 'a':
                            a510 = sub_field.text
                        if code == 'c':
                            c510 = sub_field.text


                if tag == '600':
                    print('SUBJECT1' + str(item.text))
                    for sub_field in item:
                        code = sub_field.attrib['code']
                        if code == 'a':
                            a600 = sub_field.text
                        if code == 'q':
                            q600 = sub_field.text
                        if code == 'c':
                            c600 = sub_field.text
                        if code == 'd':
                            d600 = sub_field.text
                        if code == 't':
                            t600 = sub_field.text

                if tag == '650':
                    for sub_field in item:
                        code = sub_field.attrib['code']
                        if code == 'a':
                            a650 = sub_field.text
                        if code == 'x':
                            if "Theses" in sub_field.text:
                                x650 = ''
                            else:
                                x650 = sub_field.text
                        if code == 'z':
                            if "Theses" in sub_field.text:
                                z650 = ''
                            else:
                                z650 = sub_field.text
                        subject2 = sub_field.text
                if tag == '651':
                    for sub_field in item:
                        code = sub_field.attrib['code']
                        if code == 'a':
                            subject3 = sub_field.text

                if tag == '852':
                    for sub_field in item:
                        code = sub_field.attrib['code']
                        if code == 'h':
                            if 'Att' in sub_field.text:
                                filelist.append (sub_field.text)
        creator = a100 + " " + c100 + " " + q100 + " " + d100
        title = a245 + " "  + b245 + " " + c245
        if a510 != '':
            estc = a510 + "_" + c510
        else:
            estc = ''
        if a600 != '':
            subject1 = a600 + " -- " + q600 + " -- " + c600 + " -- " + d600 + " -- " + t600
        else:
            subject1 = ''
        if z650 != '':
            subject2 = a650 + " -- " + x650 + " -- " + z650
        elif x650 != '':
            subject2 = a650 + " -- " + x650
        else:
            subject2 = a650

        publisher = 'The University of Edinburgh'
        subject0 = 'Annexe Thesis Digitisation Project 2019 Block 24'
        type = 'Thesis or Dissertation'
        qualname = 'MD Doctor of Medicine'
        quallevel = 'Doctoral'
        catalogued= ''
        abstract = ''
        filecounter=0
        file1 = ''
        file2 = ''
        file3 = ''
        id1 = ''
        id2 = ''
        id3 = ''
        filesmatched = []
        for filelistitem in filelist:
            filelistitem = filelistitem.replace('/','.')+ ".pdf"
            for file  in os.listdir(atticfolder):
                if file.endswith(".pdf"):
                    if file == filelistitem:
                        filesmatched.append(filelistitem)
                        if file1 == '':
                            file1 = file
                            id1 = filelistitem
                        elif file2 == '':
                            file2 = file
                            id2 =filelistitem
                        else:
                            file3 = file
                            id3 = filelistitem
            filecounter += 1

        if file1 == '' and file2 == '' and file3 == '':
            print(identifier + "NO MATCH")
            nomatch += 1

        if matched_already == False:
            rowforwrite = creator,title,date, publisher, subject0,  type, qualname, quallevel, abstract, catalogued, file1, file2, file3, subject1, subject2, subject3, estc, description, lang, identifier, id1,id2, id3
            writer.writerow(rowforwrite)

    print("TOTAL NO PDF" + str(nomatch))

if __name__ == '__main__':
    main()
