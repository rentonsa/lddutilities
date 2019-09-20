import os
import shutil
import json
import argparse
import logging
import time
import sys
import re
from speccoll_variables import ALL_VARS

ENVIRONMENT = ''

PARSER = argparse.ArgumentParser()
PARSER.add_argument('-e', '--environment', action="store", dest="environment", help="environment- test or live", default="live")
ARGS = PARSER.parse_args()
ENVIRONMENT = str(ARGS.environment)



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
    for d in dirs:
        shutil.rmtree(os.path.join(root, d))
        
TIME_STR= time.strftime("%Y%m%d")

def setup_custom_logger(name):
    formatter = logging.Formatter(fmt='%(asctime)s %(levelname)-8s %(message)s',
                                  datefmt='%Y-%m-%d %H:%M:%S')
    handler = logging.FileHandler(ENVIRONMENT + "spec_coll.log." + TIME_STR, mode='w')
    handler.setFormatter(formatter)
    screen_handler = logging.StreamHandler(stream=sys.stdout)
    screen_handler.setFormatter(formatter)
    logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG)
    logger.addHandler(handler)
    logger.addHandler(screen_handler)
    return logger

logger = setup_custom_logger('myapp')        

def create_dspace_record(manifest_array, out_file, et_out, outroot, manifest_id, manifest_shelf):
    image_count = 0
    from urllib.request import urlopen
    import json
    for manifest_ref in manifest_array:
        manifest = manifest_ref[0].replace('detail', 'iiif/m') + '/manifest'
        dealing_image = manifest_ref[0].replace('detail', 'iiif') + '/full/full/0/default.jpg'
        response = urlopen(manifest)
        try:
            resp_data = response.read().decode("utf-8")
            data = json.loads(resp_data)
        except ValueError:
            break
            bad_image_array.append(manifest)

        if image_count == 0:
            attribution = data["attribution"]
            type = []
            type_value = ''
            if ("-" in manifest_shelf):
                type = manifest_shelf.split("-")
                if type[0] == '':
                    type_value = str(type[1])
                else:
                    type_value = str(type[0])
            else:
                type_value = manifest_shelf

            dcvalue = et_out.SubElement(outroot, 'dcvalue')
            dcvalue.set('element', 'type')
            dcvalue.set('qualifier', '')
            dcvalue.text = type_value
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
                if item['label'] == "Shelfmark":
                    dcvalue = et_out.SubElement(outroot, 'dcvalue')
                    dcvalue.set('element', 'identifier')
                    dcvalue.set('qualifier', '')
                    if "ADO-" in manifest_shelf:
                        dcvalue.text = manifest_shelf
                    else:
                        dcvalue.text = str(value)
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
                    dcvalue.set('element', 'date')
                    dcvalue.set('qualifier', 'created')
                    dcvalue.text = str(value)
                if item["label"] == 'Catalogue Number':
                    if re.match('99*66', value) is not None:
                        alma_url = 'https://open-na.hosted.exlibrisgroup.com/alma/44UOE_INST/bibs/' + value
                        alma_data = get_data(alma_url)
                        logger.info(alma_data)
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

def get_images(connection, image_get_sql):
    manifest_array = []
    try:
        image_cursor = connection.cursor()
        image_cursor.execute(image_get_sql)
        while True:
            row = image_cursor.fetchone()
            if row == None:
                break
            manifest_array.append(row)
    except Exception:
        logger.error("could not connect to cursor")
    return manifest_array

def get_dummy_array():
    blank_file = {
        "@id": "https://librarylabs.ed.ac.uk/iiif/media/dummy/c1",
        "label": "Dummy Canvas",
        "height": 200,
        "width": 200,
        "description": "",
          "images": [
            {
              "motivation": "sc:painting",
              "on": "https://librarylabs.ed.ac.uk/iiif/media/dummy/c1",
              "resource": {
                "format": "image/jpeg",
                "service": {
                  "profile": "http://iiif.io/api/image/2/level2.json",
                  "@context": "http://iiif.io/api/image/2/context.json",
                  "@id": "https://librarylabs.ed.ac.uk/iiif/media/dummy"
                },
                "height": 200,
                "width": 200,
                "@id": "https://librarylabs.ed.ac.uk/iiif/media/dummy.png",
                "@type": "dctypes:Image"
              },
              "@type": "oa:Annotation"
            }
          ],
          "thumbnail": {
            "@id": "https://librarylabs.ed.ac.uk/iiif/media/dummy.png"
          },
          "@type": "sc:Canvas"
        }
    return blank_file

def create_manifests(manifest_array, manifest_id, env, paged, need_dummy):
    from urllib.request import urlopen
    bad_image_array = []
    image_count = 0
    viewing_hint = 'individuals'
    canvases_array = []
    sequences_array = []
    label = ''
    attribution = ''
    logo = ''
    type = ''
    context = ''
    man_id = ''
    related = ''
    if need_dummy:
        dummy_array = get_dummy_array()
        canvases_array.append(dummy_array)
    for manifest_ref in manifest_array:
        manifest = manifest_ref[0].replace('detail', 'iiif/m') + '/manifest'
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
            man_id = "http://" + env + "collectionsmedia.is.ed.ac.uk/iiif/" + str(manifest_id.strip()) + "/manifest"
            type = "sc:Manifest"
            context = data["@context"]
            related = data["@id"]
        canvas_array = data["sequences"][0]["canvases"][0]
        metadata = canvas_array["metadata"]

        canvases_array.append(canvas_array)
        for item in metadata:
            value = str(item['value']).replace("<span>", "")
            value = value.replace("</span>", "")
            value = value.replace("&", "&amp;")
            if paged == 'Y':
                if item['label'] == "Sequence":
                    try:
                        if int(value) > 0:
                            viewing_hint = 'paged'
                    except Exception:
                        viewing_hint = 'individuals'
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
    manifest_folder = "manifests/" + str(manifest_id.strip())
    os.makedirs(manifest_folder)
    os.chmod(manifest_folder, 0o777)

    manifest_loc = manifest_folder + '/manifest'
    with open(manifest_loc, 'w') as jsonfile:
        json.dump(outdata, jsonfile)

def get_subfolder(manifest_id):
    """
    Get subfolder for accession no, depending on whether exists or not
    :param item_acc_no:  accession no
    :return: subfolder will be path including existing or new
    """
    existing = False
    mapfile_name = ENVIRONMENT + "mapfile.txt"
    #logger.info(mapfile_name)
    file_master = open(mapfile_name)
    for line in file_master.readlines():
        manifest_id_len = len(manifest_id)
        #logger.info(manifest_id.strip() +str(line[:manifest_id_len]) )
        if manifest_id.strip() == line[:manifest_id_len]:
            #logger.info("matched")
            existing = True
    if existing:
        subfolder = EXISTING_FOLDER + manifest_id
    else:
        subfolder = NEW_FOLDER + manifest_id
    file_master.close()
    logger.info(subfolder)
    if os.path.exists(subfolder):
        logger.info("duplicate")
    else:
        logger.info(os.path.abspath(subfolder))
        os.makedirs(subfolder)
        os.chmod(subfolder, 0o777)
        out_file = subfolder + "/dublin_core.xml"
    return out_file

def manifest_check_insert(connection, manifest_shelf, collection):
    """
    Get Object info from API and return as json
    :param url: the API URL
    :return data: the returned json
    """
    import random, string
    manifest_id = ''
    try:
        manifest_shelf_cursor = connection.cursor()
        manifest_shelf_sql = "select manifest_id from MANIFEST_SHELFMARK where shelfmark = '" + str(manifest_shelf.strip()) + "' and collection ='" + str(collection.strip()) + "';"
        manifest_shelf_cursor.execute(manifest_shelf_sql)
        row = manifest_shelf_cursor.fetchone()
        if row:
            manifest_id = str(row[0])
            manifest_id = str(manifest_id.strip())
        else:
            inserted = False
            while inserted == False:
                stringLength = 8
                letters = string.ascii_lowercase + string.digits
                manifest_id = ''.join(random.choice(letters) for i in range(stringLength))
                manifest_id = str(manifest_id.strip())
                try:
                    insert_man_cursor = connection.cursor()
                    insert_man_sql = "insert into MANIFEST_SHELFMARK (manifest_id, shelfmark, collection) VALUES (%s,%s, %s);"
                    insert_man_values = (manifest_id, manifest_shelf.strip(), str(collection.strip()))
                    insert_man_cursor.execute(insert_man_sql, insert_man_values)
                    connection.commit()
                    inserted = True
                except Exception:
                    logger.info("trying again as I have hit a duplicate")
                    if connection:
                        logger.info("Failed to insert record into manifest_shelfmark table" + manifest_id)
    except Exception:
        logger.error("exception")

    logger.info("I am returning this manifest_id" + manifest_id)
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
        logger.info("IMAGE table truncated")
    except Exception:
        logger.info("Error while truncating IMAGE")

    try:
        truncate_image_dor_cursor = connection.cursor()
        truncate_image_dor_query = """ TRUNCATE TABLE IMAGE_DOR;"""
        truncate_image_dor_cursor.execute(truncate_image_dor_query)
        connection.commit()
        logger.info("IMAGE_DOR table truncated")
    except Exception:
        logger.error("Error while truncating IMAGE_DOR")

def main():

    """
    This is the main processing loop to traverse the API json returned
    """
    import psycopg2
    connection = psycopg2.connect(user="srenton1",
                                  password="",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="manifest_store")
    truncate_tables(connection)
    try:
        cursor = connection.cursor()
        # Print PostgreSQL Connection properties
        logger.info(connection.get_dsn_parameters(), "\n")
        # Print PostgreSQL version
        cursor.execute("SELECT id, dspace_record from COLLECTION order by id;")
        while True:
            row = cursor.fetchone()
            if row == None:
                break
            collection = row[0]
            dspace = str(row[1].strip())
            api_string = "https://images.is.ed.ac.uk/luna/servlet/as/fetchMediaSearch?fullData=true&bs=10000&lc="+collection
            logger.info(api_string)

            image_data = get_data(api_string)
            for record in image_data:
                shelfmark = 'N/A'
                sequence = 99999
                dor = ''
                size = record["urlSize1"]
                if record["mediaType"] == 'Book':
                    logger.info("This is a book- I do no more on it")
                else:
                    link_id = size.rsplit('/', 1)[-1]
                    image_id = link_id.split('.', 1)[0]
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
                                    logger.info("I got shelfmark" + shelfmark + " for image " + image_id)
                            if key == "work_id_number":
                                if dspace == 'N':
                                    shelfmark = value
                            #if key == "work_catalogue_number":
                                #logger.info("I got a WORK CATALOGUE NUMBER and it is " + value)
                            if key == "sequence":
                                logger.info(str(key) + str(value))
                                try:
                                    sequence = int(value)
                                    logger.info("I will be using " +  str(sequence))
                                except Exception:
                                    logger.info("I am excepting")
                                    sequence = 99999
                            if key == "digital_object_reference":
                                dor = value
                    try:
                        if dor != '':
                            shelfmark = 'Archive'
                        manifest_shelf = shelfmark.replace(" ", "-")
                        manifest_shelf = manifest_shelf.replace("*", "-")
                        manifest_shelf = manifest_shelf.replace("/", "-")
                        manifest_shelf = manifest_shelf.replace(".", "-")
                        manifest_shelf = manifest_shelf.replace(",", "-")
                        insert_cursor = connection.cursor()
                        postgres_insert_query = """ INSERT INTO IMAGE (image_id, collection, jpeg_path, shelfmark, sequence) VALUES (%s, %s, %s,%s, %s)"""
                        record_to_insert = (image_id, collection, identity, manifest_shelf, sequence)
                        insert_cursor.execute(postgres_insert_query, record_to_insert)
                        connection.commit()
                    except (Exception, psycopg2.Error) as error:
                        insert_cursor.close()
                        if connection:
                            logger.info(record_to_insert)
                            logger.info("Failed to insert record into IMAGE table with" + str(image_id) + str(identity), error)
                    if dor != '':
                        try:
                            insert_dor_cursor = connection.cursor()
                            postgres_insert_dor_query = """ INSERT INTO IMAGE_DOR (image_id, dor_id) VALUES (%s,%s)"""
                            record_to_insert_dor = (image_id, dor)
                            insert_dor_cursor.execute(postgres_insert_dor_query, record_to_insert_dor)
                            connection.commit()
                        except (Exception, psycopg2.Error) as error :
                            insert_dor_cursor.close()
                            logger.info("Error while connecting to PostgreSQL", error)

    finally:
        #closing database connection.
        if connection:
            cursor.close()
            logger.info("END OF LUNA LOADER cursor is closed")

    try:
        #loop round IMAGE table getting shelfmarks
        loop_shelf_cursor = connection.cursor()
        loop_shelf_sql = "select distinct(i.shelfmark), i.collection, c.dspace_record, c.paged from IMAGE i, COLLECTION c where i.collection = c.id group by i.shelfmark, i.collection, c.dspace_record, c.paged order by i.shelfmark, i.collection;;"
        loop_shelf_cursor.execute(loop_shelf_sql)
        while True:
            row = loop_shelf_cursor.fetchone()
            if row is None:  # better: if not row
                break
            manifest_shelf = str(row[0]).strip()
            collection = str(row[1]).strip()
            dspace = str(row[2]).strip()
            #paged = str(row[3]).strip()
            if manifest_shelf == 'N/A':
                break
            else:
                if manifest_shelf == 'Archive':
                    logger.info("working on an Archive")
                    try:
                        dor_cursor = connection.cursor()
                        dor_sql = "select distinct(dor_id) from IMAGE_DOR;"
                        dor_cursor.execute(dor_sql)
                        while True:
                            row = dor_cursor.fetchone()
                            if row is None:
                                break
                            else:
                                manifest_shelf = row[0]
                                manifest_id = manifest_check_insert(connection, manifest_shelf, collection)
                                image_get_sql = "select i.jpeg_path, i.sequence from IMAGE i, IMAGE_DOR id where id.dor_id ='" + manifest_shelf + "' and collection = '" + collection + "' and id.image_id = i.image_id order by i.sequence, i.jpeg_path;"
                                manifest_array = get_images(connection, image_get_sql)
                                if len(manifest_array) > 0:
                                    paged = False
                                    need_dummy = False
                                    if int(manifest_array[0][1]) == 0:
                                        paged = False
                                    else:
                                        paged = True
                                        if (int(manifest_array[0][1])%2) == 0:
                                            need_dummy = True
                                        else:
                                            need_dummy = False
                                    create_manifests(manifest_array, manifest_id, ENVIRONMENT, paged, need_dummy)
                                    if dspace == 'Y':
                                        logger.info('MAKING A DSPACE RECORD')
                                        out_file = get_subfolder(manifest_id)
                                        import xml.etree.cElementTree as et_out
                                        outroot = et_out.Element(ALL_VARS['DC_HEADER'])
                                        create_dspace_record(manifest_array, out_file, et_out, outroot, manifest_id, manifest_shelf)
                                else:
                                    logger.error("DEAD MANIFEST ID" + str(manifest_id))
                    except (Exception, psycopg2.Error) as error:
                        logger.info("Failed to get from IMAGE_DOR", error)
                else:
                    logger.info("Working on " + manifest_shelf)
                    manifest_id = manifest_check_insert(connection, manifest_shelf, collection)
                    image_get_sql = "select jpeg_path, sequence from IMAGE where shelfmark ='" + manifest_shelf +  "' and collection = '" + collection + "' order by sequence, jpeg_path;"
                    manifest_array = get_images(connection, image_get_sql)
                    if len(manifest_array) > 0:
                        paged = False
                        need_dummy = False
                        if int(manifest_array[0][1]) == 0:
                            paged = False
                        else:
                            paged = True
                            if (int(manifest_array[0][1])%2) == 0:
                                need_dummy = True
                            else:
                                need_dummy = False
                        create_manifests(manifest_array, manifest_id, ENVIRONMENT, paged, need_dummy)
                        if dspace == 'Y':
                            out_file = get_subfolder(manifest_id)
                            import xml.etree.cElementTree as et_out
                            outroot = et_out.Element(ALL_VARS['DC_HEADER'])
                            create_dspace_record(manifest_array, out_file, et_out, outroot, manifest_id, manifest_shelf)
                    else:
                        logger.error("DEAD MANIFEST ID" + str(manifest_id))
    except (Exception, psycopg2.Error) as error:
        logger.info("Failed along the way", error)

    finally:
        #closing database connection.
        if connection:
            loop_shelf_cursor.close()
            connection.close()
            logger.info("END OF PROG PostgreSQL connection is closed")

if __name__ == '__main__':
    main()
