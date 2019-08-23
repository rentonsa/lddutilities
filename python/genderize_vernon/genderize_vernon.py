"""
Scott Renton, January 2019
Generate manifest for AV
"""
import csv
import json
import codecs
from xml.dom import minidom

import xml.etree.cElementTree as ETOut
art_outroot = ETOut.Element("vernon")
art_recordset = ETOut.SubElement(art_outroot, "recordset")

import xml.etree.cElementTree as ETOut_non
non_outroot = ETOut_non.Element("vernon")
non_recordset = ETOut_non.SubElement(non_outroot, "recordset")

#with open('annos-78.csv', 'r') as csvfile:
with open('allpersons.csv', 'r',encoding="utf-8-sig") as csvfile:
    all_reader = csv.DictReader(csvfile, delimiter=',', quotechar='"')
    all_array = list(all_reader)
with open('artpersons.csv', 'r',encoding="utf-8-sig") as art_csv:
    art_reader = csv.DictReader(art_csv, delimiter=',', quotechar='"')
    art_array = list(art_reader)
with open('nonartpersons.csv', 'r',encoding="utf-8-sig") as non_art_csv:
    non_art_reader = csv.DictReader(non_art_csv, delimiter=',', quotechar='"')
    non_art_array = list(non_art_reader)

all_len = len(all_array)

art_len = len(art_array)

non_art_len = len(non_art_array)
no_parse_file = open('unparse.txt', 'w')
art_for_load = open('art_for_load.txt','w')
non_art_for_load = open('non_art_for_load.txt', 'w')
in_no_collection = open('in_no_collection.txt', 'w')

def control():
    all_count = 0

    while all_count < all_len:
        first_string = all_array[all_count]["Firstnames"]
        first_bits =first_string.split(" ")
        firstname = first_bits[0]

        id = all_array[all_count]["System ID"]

        if firstname:
            from urllib.request import FancyURLopener

            class MyOpener(FancyURLopener):
                """
                MyOpener
                """
                version = 'My new User-Agent'   # Set this to a string you want for your user agent

            myopener = MyOpener()
            public_image_url = "https://api.genderize.io/?name=" + firstname + "&apikey=5ea74cbc57513eab823c2748a1c555b5"


            print(public_image_url)
            response_obtained = False
            data_read = False
            try:
                response = myopener.open(public_image_url)
                response_obtained = True
            except:
                print("error on genderize")
                no_parse_file.write(id+ "," + all_array[all_count]["Firstnames"]+ "," +  all_array[all_count]["Lastname"]+ "," +  "error calling genderize\n")
            if response_obtained:
                try:
                    data = response.read().decode("utf-8")
                    data_read = True
                except:
                    print("error on read")
                    no_parse_file.write(id+ "," + all_array[all_count]["Firstnames"]+ "," +  all_array[all_count]["Lastname"]+ "," +  "error reading post-calling genderize\n")
                if data_read:
                    gender_data = json.loads(data)
                    print(gender_data)
                    #except:
                    #    print("no response")
                    #    no_parse_file.write(id+ "," + all_array[all_count]["Firstnames"] + "," + all_array[all_count]["Lastname"]+ "," + "no response from genderize")
                    if gender_data["probability"] > 0.85:
                        print(str(gender_data["probability"]))
                        id = all_array[all_count]["System ID"]
                        art_count = 0
                        non_art_count = 0
                        art_found = False
                        non_art_found = False
                        while art_count < art_len:
                            if id == art_array[art_count]["System ID"]:
                                print("got an art")
                                record = ETOut.SubElement(art_recordset, "record")
                                #art_for_load.write("<record><id>" + id + "</id><gender>" + gender_data["gender"] + "</gender></record>")
                                art_idelement = ETOut.SubElement(record, "id")
                                art_idelement.text = id
                                art_firstelement = ETOut.SubElement(record, "firstname")
                                art_firstelement.text = all_array[all_count]["Firstnames"]
                                art_firstelement = ETOut.SubElement(record, "lastname")
                                art_firstelement.text = all_array[all_count]["Lastname"]
                                art_genderelement = ETOut.SubElement(record, "gender")
                                art_genderelement.text = gender_data["gender"]
                                art_genderelement = ETOut.SubElement(record, "certainty")
                                art_genderelement.text = str(gender_data["probability"])

                                art_found = True
                            art_count += 1

                        if art_found == False:
                            while non_art_count < non_art_len:
                                if id == non_art_array[non_art_count]["System ID"]:
                                    print("got a non-art")
                                    record = ETOut_non.SubElement(non_recordset, "record")
                                    non_idelement = ETOut_non.SubElement(record, "id")
                                    non_idelement.text = id
                                    non_firstelement = ETOut_non.SubElement(record, "firstname")
                                    non_firstelement.text = all_array[all_count]["Firstnames"]
                                    non_firstelement = ETOut.SubElement(record, "lastname")
                                    non_firstelement.text = all_array[all_count]["Lastname"]
                                    non_genderelement = ETOut.SubElement(record, "gender")
                                    non_genderelement.text = gender_data["gender"]
                                    non_genderelement = ETOut.SubElement(record, "certainty")
                                    non_genderelement.text = str(gender_data["probability"])
                                    non_art_found = True
                                non_art_count += 1
                            if non_art_found == False:
                                print("got a no-coll")
                                in_no_collection.write(id+ ",\"" +  all_array[all_count]["Firstnames"]+ "\",\"" +  all_array[all_count]["Lastname"]+ "\"," + "in no collection- ripe for deletion\n")
                    else:
                        in_no_collection.write(id+ ",\"" +  all_array[all_count]["Firstnames"]+ "\",\"" +  all_array[all_count]["Lastname"]+ "\"," + "not enough confidence to apply\n")
                else:
                    print("no first name")
                    in_no_collection.write(id+ ",,\"" +  all_array[all_count]["Lastname"]+ "\"," + "no first name!\n")
        all_count+=1

    art_rough_string = ETOut.tostring(art_outroot, 'utf-8')
    art_reparsed = minidom.parseString(art_rough_string)
    art_pretty_string = art_reparsed.toprettyxml(indent="\t")
    import codecs
    with codecs.open("art_for_load.txt", "w", encoding='utf-8') as art_file:
        art_file.write(art_pretty_string)

    non_rough_string = ETOut_non.tostring(non_outroot, 'utf-8')
    non_reparsed = minidom.parseString(non_rough_string)
    non_pretty_string = non_reparsed.toprettyxml(indent="\t")
    import codecs
    with codecs.open("non_for_load.txt", "w", encoding='utf-8') as non_file:
        non_file.write(non_pretty_string)
control()