import os
import shutil
import json
import csv
import argparse
from datetime import timedelta, date
from speccoll_variables import ALL_VARS
PARSER = argparse.ArgumentParser()

PARSER.add_argument('-e', '--environment', action="store", dest="environment", help="environment- test or live", default="live")

ENVIRONMENT = ''

EXISTING_FOLDER = ALL_VARS['EX_FOLD']
for root, dirs, files in os.walk(EXISTING_FOLDER):
    for f in files:
        os.unlink(os.path.join(root, f))
    for d in dirs:
        shutil.rmtree(os.path.join(root, d))
NEW_FOLDER = ALL_VARS['N_FOLD']
for root, dirs, files in os.walk(NEW_FOLDER):
    for f in files:
        os.unlink(os.path.join(root, f))
    for d in dirs:
        shutil.rmtree(os.path.join(root, d))
MAN_FOLDER = "manifests"
for root, dirs, files in os.walk(MAN_FOLDER):
    for f in files:
        os.unlink(os.path.join(root, f))

FM = open( ENVIRONMENT + "mapfile.txt", "w")

def create_dspace_record(manifest_array,out_file, et_out, outroot, manifest_id ):
    image_count = 0
    from urllib.request import urlopen
    import json
    for manifest_ref in manifest_array:
        manifest = manifest_ref.replace('detail', 'iiif/m') + '/manifest'
        dealing_image = manifest_ref.replace('detail', 'iiif') + '/full/full/0/default.jpg'
        response = urlopen(manifest)
        try:
            resp_data = response.read().decode("utf-8")
            data = json.loads(resp_data)
        except ValueError:
            break
            bad_image_array.append(manifest)

        if image_count == 0:
            attribution = data["attribution"]
            dcvalue = et_out.SubElement(outroot, 'dcvalue')
            dcvalue.set('element', 'identifier')
            dcvalue.set('qualifier', 'imageUri')
            dcvalue.text = str(dealing_image)
            dcvalue = et_out.SubElement(outroot, 'dcvalue')
            dcvalue.set('element', 'relation')
            dcvalue.set('qualifier', 'ispartof')
            dcvalue.text = str(attribution)
            dcvalue = et_out.SubElement(outroot, 'dcvalue')
            dcvalue.set('element', 'identifier')
            dcvalue.set('qualifier', 'manifest')
            dcvalue.text = str(manifest_id)

        canvas_array = data["sequences"][0]["canvases"][0]
        metadata = canvas_array["metadata"]
        for item in metadata:
            value = str(item['value']).replace("<span>", "")
            value = value.replace("</span>", "")
            value = value.replace("&amp;", "and")
            if item['label'] == "Title":
                dcvalue = et_out.SubElement(outroot, 'dcvalue')
                dcvalue.set('element', 'title')
                dcvalue.set('qualifier', '')
                dcvalue.text = str(value)
            if item['label'] == "Creator":
                dcvalue = et_out.SubElement(outroot, 'dcvalue')
                dcvalue.set('element', 'contributor')
                dcvalue.set('qualifier', 'author')
                dcvalue.text = str(value)
            if item['label'] == "Date":
                dcvalue = et_out.SubElement(outroot, 'dcvalue')
                dcvalue.set('element', 'contributor')
                dcvalue.set('qualifier', 'author')
                dcvalue.text = str(value)
        image_count += 1
    dcvalue = et_out.SubElement(outroot, 'dcvalue')
    dcvalue.set('element', 'format')
    dcvalue.set('qualifier', 'extent')
    dcvalue.text = str(image_count)

    from xml.dom import minidom
    rough_string = et_out.tostring(outroot, 'utf-8')
    reparsed = minidom.parseString(rough_string)
    pretty_string = reparsed.toprettyxml(indent="\t")
    import codecs
    with codecs.open(out_file, "w", encoding='utf-8') as file:
        file.write(pretty_string)
    file.close()

def get_images(connection, image_get_sql ):
    manifest_array = []
    try:
        image_cursor = connection.cursor()
        image_cursor.execute(image_get_sql)
        while True:
            row = image_cursor.fetchone()
            if row == None:
                break
            print(row[0])
            manifest_array.append(row[0])
    except Exception:
        print("could not connect to cursor")
    return manifest_array

def create_manifests(manifest_array, manifest_id, env):
    from urllib.request import urlopen
    import json
    bad_image_array = []
    image_count = 0
    viewing_hint = 'individuals'
    canvases_array = []
    sequences_array = []
    for manifest_ref in manifest_array:
        manifest = manifest_ref.replace('detail', 'iiif/m') + '/manifest'
        response = urlopen(manifest)
        try:
            resp_data = response.read().decode("utf-8")
            data = json.loads(resp_data)
        except ValueError:
            break
            bad_image_array.append(manifest)
        if image_count == 0:
            label = data["label"]
            attribution = data["attribution"]
            logo = data["logo"]
            man_id = "http://" + env + "manifest.collections.ed.ac.uk/" + str(manifest_id.strip()) + ".json"
            type = "sc:Manifest"
            context = data["@context"]
            related = data["@id"]
            print(related)
        canvas_array = data["sequences"][0]["canvases"][0]
        metadata = canvas_array["metadata"]
        canvases_array.append(canvas_array)
        for item in metadata:
            value = str(item['value']).replace("<span>", "")
            value = value.replace("</span>", "")
            value = value.replace("&", "&amp;")
            if item['label'] == "Sequence":
                if int(value) > 0:
                    viewing_hint = 'paged'
        image_count += 1

    sequences_array.append({"@type": "sc:Sequence",
                                "canvases": canvases_array})
    outdata = {
        "label": label,
        "attribution": attribution,
        "logo": logo,
        "@id": man_id,
        "related": related,
        "sequences": sequences_array,
        "@type": type,
        "viewingHint": viewing_hint,
        "@context": context
    }
    manifest_loc = "manifests/" + str(manifest_id.strip()) + '.json'
    with open(manifest_loc, 'w') as jsonfile:
        json.dump(outdata, jsonfile)

def get_subfolder(manifest_id):
    """
    Get subfolder for accession no, depending on whether exists or not
    :param item_acc_no:  accession no
    :return: subfolder will be path including existing or new
    """
    subfolder = ''
    existing = False
    file_master = open(ENVIRONMENT + "mapfile.txt")
    for line in file_master.readlines():
        print("got to here")
        manifest_id_len = len(manifest_id)
        if manifest_id == line[:manifest_id_len]:
            existing = True
    if existing:
        subfolder = EXISTING_FOLDER + manifest_id
    else:
        subfolder = NEW_FOLDER + manifest_id
    file_master.close()
    print(subfolder)
    if os.path.exists(subfolder):
         print("duplicate")
    else:
        print(os.path.abspath(subfolder))
        os.makedirs(subfolder)
        print("done it")
        os.chmod(subfolder, 0o777)
        out_file = subfolder + "/dublin_core.xml"
    return out_file

def manifest_check_insert(connection, manifest_shelf ,collection):
    """
    Get Object info from API and return as json
    :param url: the API URL
    :return data: the returned json
    """
    import random, string
    manifest_id = ''
    try:
        manifest_shelf_cursor = connection.cursor()
        manifest_shelf_sql = "select manifest_id from MANIFEST_SHELFMARK where shelfmark = '" + str(manifest_shelf.strip()) + "';"
        manifest_shelf_cursor.execute(manifest_shelf_sql)
        row = manifest_shelf_cursor.fetchone()
        if row:
            manifest_id = str(row[0])
            manifest_id = str(manifest_id.strip())
        else:
            try:
                i = 0
                stringLength = 8
                letters = string.ascii_lowercase + string.digits
                manifest_id = ''.join(random.choice(letters) for i in range(stringLength))
                manifest_id = str(manifest_id.strip())
                insert_man_cursor = connection.cursor()
                insert_man_sql = "insert into MANIFEST_SHELFMARK (manifest_id, shelfmark, collection) VALUES (%s,%s, %s);"
                insert_man_values = (manifest_id,manifest_shelf.strip(), str(collection.strip()) )
                insert_man_cursor.execute(insert_man_sql, insert_man_values)
                connection.commit()
            except Exception :
                insert_man_cursor.close()
                if(connection):
                    print("Failed to insert record into manifest_shelfmark table")
    except Exception:
        print("exception")

    print("I am returning this manifest_id" + manifest_id)
    return str(manifest_id)

def get_data(url):
    """
    """
    from urllib.request import FancyURLopener
    class MyOpener(FancyURLopener):
        """
        MyOpener
        """
        version = 'My new User-Agent'   # Set this to a string you want for your user agent

    myopener = MyOpener()
    response = myopener.open(url)
    data = response.read().decode("utf-8")
    image_data = json.loads(data)
    return image_data

def truncate_tables(connection):
    try:
        truncate_image_cursor = connection.cursor()
        truncate_image_query = """ TRUNCATE TABLE IMAGE;"""
        truncate_image_cursor.execute(truncate_image_query)
        connection.commit()
        print ("IMAGE table truncated")
    except Exception:
        print ("Error while truncating IMAGE")

    try:
        truncate_image_dor_cursor = connection.cursor()
        truncate_image_dor_query = """ TRUNCATE TABLE IMAGE_DOR;"""
        truncate_image_dor_cursor.execute(truncate_image_dor_query)
        connection.commit()
        print ("IMAGE_DOR table truncated")
    except Exception:
        print ("Error while truncating IMAGE_DOR")

def main():

    """
    This is the main processing loop to traverse the API json returned
    """
    import psycopg2
    connection = psycopg2.connect(user = "srenton1",
                                password = "",
                                host = "127.0.0.1",
                                port = "5432",
                                database = "manifest_store")
    truncate_tables(connection)
    try:
        cursor = connection.cursor()
        # Print PostgreSQL Connection properties
        print ( connection.get_dsn_parameters(),"\n")
        # Print PostgreSQL version
        cursor.execute("SELECT id, dspace_record from COLLECTION order by id;")
        while True:
            row = cursor.fetchone()
            if row == None:
                break
            collection = row[0]
            dspace = str(row[1].strip())
            api_string = "https://images.is.ed.ac.uk/luna/servlet/as/fetchMediaSearch?fullData=true&bs=10000&lc="+collection
            print(api_string)

            image_data = get_data(api_string)
            for record in image_data:
                shelfmark = 'N/A'
                sequence = 99999
                dor = ''
                size1 = record["urlSize1"]
                link_id = size1.rsplit('/', 1)[-1]
                image_id = link_id.split('.',1)[0]
                image_id = str(image_id).strip()
                identity = "https://images.is.ed.ac.uk/luna/servlet/detail/"+record["identity"]
                metadata = record["attributes"]
                first_split = metadata.split('"],')

                for bit in first_split:
                    data_items = bit.split('",')
                    for item in data_items:
                        if '["' in item:
                            item_pair = item.split(':["')
                        else:
                            item_pair = item.split(":")
                        try:
                            key = item_pair[0].replace('"', '')
                            value = item_pair[1].replace('"', '')
                        except Exception:
                            break
                        if key == "work_shelfmark":
                            if dspace == 'Y':
                                shelfmark = value
                        if key == "work_id_number":
                            if dspace == 'N':
                                shelfmark = value
                        if key == "sequence":
                            sequence = value
                        if key == "digital_object_reference":
                            dor = value
                try:
                    if dor != '':
                        shelfmark = 'Archive'

                    insert_cursor = connection.cursor()
                    postgres_insert_query = """ INSERT INTO IMAGE (image_id, collection, jpeg_path, shelfmark, sequence) VALUES (%s, %s, %s,%s, %s)"""
                    record_to_insert = (image_id, collection, identity,shelfmark, sequence)
                    insert_cursor.execute(postgres_insert_query, record_to_insert)
                    connection.commit()
                except (Exception, psycopg2.Error) as error :
                    insert_cursor.close()
                    if(connection):
                        print("Failed to insert record into IMAGE table with" + str(image_id) + str(identity), error)
                if dor != '':
                    try:
                        insert_dor_cursor = connection.cursor()
                        postgres_insert_dor_query = """ INSERT INTO IMAGE_DOR (image_id, dor_id) VALUES (%s,%s)"""
                        record_to_insert_dor = (image_id, dor)
                        insert_dor_cursor.execute(postgres_insert_dor_query, record_to_insert_dor)
                        connection.commit()
                    except (Exception, psycopg2.Error) as error :
                        insert_dor_cursor.close()
                        print ("Error while connecting to PostgreSQL", error)

    finally:
        #closing database connection.
            if(connection):
                cursor.close()
                print("END OF LUNA LOADER cursor is closed")

    try:
        #loop round IMAGE table getting shelfmarks
        loop_shelf_cursor = connection.cursor()
        loop_shelf_sql = "select distinct(i.shelfmark), i.collection, c.dspace_record from IMAGE i, COLLECTION c where i.collection = c.id order by i.shelfmark;"
        loop_shelf_cursor.execute(loop_shelf_sql)
        while True:
            row = loop_shelf_cursor.fetchone()
            if row is None:  # better: if not row
                break
            shelfmark = str(row[0]).strip()
            collection  = str(row[1]).strip()
            dspace = str(row[2]).strip()
            if shelfmark == 'N/A':
                break
            else:
                manifest_shelf = shelfmark.replace(" ", "-")
                manifest_shelf = manifest_shelf.replace("*", "-")
                manifest_shelf = manifest_shelf.replace("/", "-")
                manifest_shelf = manifest_shelf.replace(".", "-")
                manifest_shelf = manifest_shelf.replace(",", "-")
                if manifest_shelf == 'Archive':
                   print("working on an Archive")
                   try:
                        dor_cursor = connection.cursor()
                        dor_sql = "select distinct(dor_id) from orders.IMAGE_DOR;"
                        dor_cursor.execute(dor_sql)
                        while True:
                            row = dor_cursor.fetchone()
                            if row is None:
                                break
                            else:
                                manifest_shelf = row[0]
                                manifest_id = manifest_check_insert(connection, manifest_shelf, collection)
                                image_get_sql = "select i.jpeg_path, i.sequence from IMAGE i, IMAGE_DOR id where id.dor_id ='" + manifest_shelf + "' and id.image_id = i.image_id order by i.sequence, i.jpeg_path;"
                                manifest_array = get_images(connection, image_get_sql)
                                create_manifests(manifest_array, manifest_id, ENVIRONMENT)
                                if dspace =='Y':
                                    print('MAKING A DSPACE RECORD')
                                    out_file= get_subfolder(manifest_id)
                                    import xml.etree.cElementTree as et_out
                                    outroot = et_out.Element(ALL_VARS['DC_HEADER'])
                                    create_dspace_record(manifest_array,out_file, et_out, outroot, manifest_id)
                   except (Exception, psycopg2.Error) as error :
                        print("Failed to get from IMAGE_DOR", error)
                else:
                    manifest_id = manifest_check_insert(connection, manifest_shelf, collection)
                    image_get_sql = "select jpeg_path, sequence from IMAGE where shelfmark ='" + shelfmark +  "' order by sequence, jpeg_path;"
                    manifest_array = get_images(connection, image_get_sql)
                    create_manifests(manifest_array, manifest_id, ENVIRONMENT)
                    if dspace =='Y':
                        out_file= get_subfolder(manifest_id)
                        import xml.etree.cElementTree as et_out
                        outroot = et_out.Element(ALL_VARS['DC_HEADER'])
                        create_dspace_record(manifest_array,out_file, et_out, outroot, manifest_id)


    except (Exception, psycopg2.Error) as error :
        print("Failed along the way", error)

    finally:
        #closing database connection.
            if(connection):
                loop_shelf_cursor.close()
                connection.close()
                print("END OF PROG PostgreSQL connection is closed")

if __name__ == '__main__':

    main()