import os
import shutil
import json
import argparse
import logging
import time
import sys
import re
import csv
from speccoll_variables import ALL_VARS

ENVIRONMENT = ''

PARSER = argparse.ArgumentParser()
PARSER.add_argument('-e', '--environment', action="store", dest="environment", help="environment- test or live",
                    default="live")
ARGS = PARSER.parse_args()
ENVIRONMENT = str(ARGS.environment)

# Clear down dspace folders
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

# Map file maintained for dspace handles, to ensure we update or add depending on existence
CSV_FILE = open(ALL_VARS['MAP_FILE'], 'r')
MAPPING = csv.DictReader(CSV_FILE, delimiter=':')
MAP_ARRAY = list(MAPPING)
MAP_LEN = len(MAP_ARRAY)

FM = open(ENVIRONMENT + "mapfile.txt", "w")

TIME_STR = time.strftime("%Y%m%d")


def setup_custom_logger(name):
    """
    Better logging handled here
    :param name: name
    """
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


def map_md(key, value, et_out, outroot):
    """
    Map found field to its dublin core equivalent, and add to XML tree for the item
    :param key: fieldname
    :param value: field value
    :param et_out: XML Tree before
    :param outroot: dublin core header
    :return et_out: XML Tree with additional entry
    """
    map_row = 0
    while map_row < MAP_LEN:
        if MAP_ARRAY[map_row]['raw'] == key:
            if 'dc_prod_pri_date' in key:
                value = value[7:]
            mdschema = str(MAP_ARRAY[map_row]['dc'] + "value")
            mdelement = str(MAP_ARRAY[map_row]['element'])
            if MAP_ARRAY[map_row]['qualifier'] == 'noqual':
                mdqualifier = str('')
            else:
                mdqualifier = str(MAP_ARRAY[map_row]['qualifier'])
            if len(value) > 0:
                dcvalue = et_out.SubElement(outroot, mdschema)
                dcvalue.set('element', mdelement)
                dcvalue.set('qualifier', mdqualifier)
                dcvalue.text = value
        map_row = map_row + 1
    return et_out


def create_dspace_record(manifest_array, out_file, et_out, outroot, manifest_id, manifest_shelf):
    """
    Generate dublin core dspace data
    :param manifest_array: allows us to generate a thumbnail
    :param out_file: dspace dublin core file
    :param et_out: XML written
    :param outroot: XML to write to
    :param manifest_id: ID for manifest- name of folder
    :param manifest_shelf: shelfmark or DOR
    """
    image_count = 0
    from urllib.request import urlopen
    import json
    for manifest_ref in manifest_array:
        # Get first page image, used for thumbnail
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
            # Set DC fields needed for all- need a better way
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
                key = str(item['label'])
                value = str(item['value']).replace("<span>", "")
                value = value.replace("</span>", "")
                value = value.replace("&amp;", "and")
                if item["label"] == 'Catalogue Number':
                    # If we have an Alma ID, go off to Alma to get metadata (this makes it searchable)
                    out = re.match(r"^99", value)
                    logger.info(str(out))
                    if out is not None:
                        alma_url = 'https://open-na.hosted.exlibrisgroup.com/alma/44UOE_INST/bibs/' + value
                        alma_data = get_data(alma_url)
                        logger.info(alma_url)
                        if alma_data == '':
                            logger.info("dead_url " + alma_url)
                        else:
                            for alma_key, alma_value in alma_data.items():
                                logger.info(str(alma_key) + str(alma_value))
                                twod = False
                                if isinstance(alma_value, list):
                                    try:
                                        for subkey, subvalue in alma_value[0].items():
                                            twod = True
                                    except:
                                        twod = False
                                        for child in alma_value:
                                            if not (isinstance(child, list)):
                                                et_out = map_md(alma_key, child, et_out, outroot)
                                    if twod:
                                        value_len = len(alma_value)
                                        count = 0
                                        while count < value_len:
                                            full_string = ''
                                            for subkey, subvalue in alma_value[count].items():
                                                full_string = full_string + str(subvalue) + ' | '
                                            et_out = map_md(alma_key, full_string, et_out, outroot)
                                            count += 1
                                else:
                                    if isinstance(alma_value, dict):
                                        full_string = ''
                                        for subkey, subvalue in alma_value.items():
                                            full_string = full_string + str(subvalue) + " | "
                                        et_out = map_md(alma_key, full_string, et_out, outroot)
                                    else:
                                        et_out = map_md(alma_key, alma_value, et_out, outroot)
                else:
                    if item['label'] == "Shelfmark":
                        if "ADO-" in manifest_shelf:
                            value = manifest_shelf
                        else:
                            value = str(value)
                        # Write dublin core md
                        et_out = map_md(key, value, et_out, outroot)
                    else:
                        et_out = map_md(key, value, et_out, outroot)

        image_count += 1
    dcvalue = et_out.SubElement(outroot, 'dcvalue')
    dcvalue.set('element', 'format')
    dcvalue.set('qualifier', 'extent')
    dcvalue.text = str(image_count)

    # Write file
    from xml.dom import minidom
    rough_string = et_out.tostring(outroot, 'utf-8')
    reparsed = minidom.parseString(rough_string)
    pretty_string = reparsed.toprettyxml(indent="\t")
    import codecs
    with codecs.open(out_file, "w", encoding='utf-8') as file:
        file.write(pretty_string)
    file.close()


def get_images(connection, image_get_sql):
    """
    Get images for manifest
    :param connection: postgres connection
    :param image_get_sql: SQL to collect IMAGE table data
    """
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
    """
    Dummy array if needed
    """
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


def create_manifests(manifest_array, manifest_id, env, paged, need_dummy, manifest_shelf):
    """
    Create a manifest, using the canvas from the LUNA record
    :param manifest_array:  Canvases
    :param manifest_id: Name of the manifest
    :param env: test or live
    :param paged: if the paged value is to be attributed for display
    :need_dummy: if the sequence suggests we will get out of line trying to page, we can create a blank canvas
    :manifest_shelf: shelfmark/DOR
    """
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
        # Create dummy canvas if necessary
        dummy_array = get_dummy_array()
        canvases_array.append(dummy_array)

    for manifest_ref in manifest_array:
        # Process LUNA manifests
        manifest = manifest_ref[0].replace('detail', 'iiif/m') + '/manifest'
        response = urlopen(manifest)
        try:
            resp_data = response.read().decode("utf-8")
            data = json.loads(resp_data)
        except ValueError:
            break
            bad_image_array.append(manifest)
        if image_count == 0:
            label = 'IIIF manifest for ' + str(manifest_shelf)
            attribution = data["attribution"]
            logo = data["logo"]
            # Set location for manifest
            man_id = "http://" + env + "collectionsmedia.is.ed.ac.uk/iiif/" + str(manifest_id.strip()) + "/manifest"
            type = "sc:Manifest"
            context = data["@context"]
            related = data["@id"]
            if paged:
                viewing_hint = 'paged'
            else:
                viewing_hint = 'individuals'
        canvas_array = data["sequences"][0]["canvases"][0]
        metadata = canvas_array["metadata"]

        canvases_array.append(canvas_array)
        for item in metadata:
            value = str(item['value']).replace("<span>", "")
            value = value.replace("</span>", "")
            value = value.replace("&", "&amp;")
            # Possible fix? Value not used
            #item.text = value
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
    Create a subfolder for the new dspace record
    :param manifest_id:  Folder name will match the manifest id or name passed to it
    """
    existing = False
    mapfile_name = ENVIRONMENT + "mapfile-master.txt"
    file_master = open(mapfile_name)
    # Populate mapfile with mapping from manifest to dspace handle from master file (if exists)
    for line in file_master.readlines():
        manifest_id_len = len(manifest_id)
        if manifest_id.strip() == line[:manifest_id_len]:
            existing = True
            FM.write(line)
    # If it already exists, we run in with dspace import replace, otherwise add, so separate folders
    if existing:
        subfolder = EXISTING_FOLDER + manifest_id
    else:
        subfolder = NEW_FOLDER + manifest_id
    file_master.close()
    logger.info(subfolder)
    if os.path.exists(subfolder):
        logger.info("duplicate")
    else:
        # Creare subfolder if new
        logger.info(os.path.abspath(subfolder))
        os.makedirs(subfolder)
        os.chmod(subfolder, 0o777)
        out_file = subfolder + "/dublin_core.xml"
    return out_file


def manifest_check_insert(connection, manifest_shelf, collection, manifest_type):
    """
    Get Object info from API and return as json
    :param connection: the postgres connection
    :manifest_shelf: shelfmark or DOR
    :collection: LUNA collection
    :manifest_type: Archive or shelfmark
    :return man_name: the name of the manifest and dspace record
    """
    import random
    import string
    manifest_id = ''
    manifest_name = ''
    try:
        manifest_shelf_cursor = connection.cursor()
        # Check if the manifest exists
        manifest_shelf_sql = "select manifest_id, manifest_name from MANIFEST_SHELFMARK where upper(shelfmark) = upper('" + str(
            manifest_shelf.strip()) + "') and collection ='" + str(collection.strip()) + "';"
        manifest_shelf_cursor.execute(manifest_shelf_sql)
        row = manifest_shelf_cursor.fetchone()
        if row:
            manifest_id = str(row[0])
            manifest_id = str(manifest_id.strip())
            manifest_name = str(row[1])
        else:
            # If we do not find one (i.e. new volume)
            inserted = False
            while inserted == False:
                stringLength = 8
                # Generate a random identifier
                letters = string.ascii_lowercase + string.digits
                manifest_id = ''.join(random.choice(letters) for i in range(stringLength))
                manifest_id = str(manifest_id.strip())
                # The name of the manifest will be the DOR if an archive, the randomised id if not
                if manifest_type == 'ARCHIVE':
                    manifest_name = manifest_shelf
                else:
                    manifest_name = manifest_id
                try:
                    # Insert a new row
                    insert_man_cursor = connection.cursor()
                    insert_man_sql = "insert into MANIFEST_SHELFMARK (manifest_id, shelfmark, collection, manifest_name) VALUES (%s,%s, %s, %s);"
                    insert_man_values = (manifest_id, manifest_shelf.strip(), str(collection.strip()), manifest_name)
                    print(insert_man_values)
                    insert_man_cursor.execute(insert_man_sql, insert_man_values)
                    connection.commit()
                    inserted = True
                except Exception:
                    logger.info("trying again as I have hit a duplicate")
                    if connection:
                        logger.info("Failed to insert record into manifest_shelfmark table" + manifest_name)
    except Exception:
        logger.error("exception")

    logger.info("I am returning this manifest_id" + manifest_name)
    return str(manifest_name)


def get_data(url):
    """
    Get JSON data for URL
    :param url: LUNA API string for collection
    """
    from urllib.request import FancyURLopener
    class MyOpener(FancyURLopener):
        # Using FancyURLopener rather than straight request
        version = 'My new User-Agent'  # Set this to a string you want for your user agent

    myopener = MyOpener()
    response = myopener.open(url)
    try:
        data = response.read().decode("utf-8")
    except:
        image_data = ''
    try:
        image_data = json.loads(data)
    except:
        image_data = ''
    return image_data


def truncate_tables(connection):
    """
    Clear down IMAGE and IMAGE_DOR tables to ensure a fresh, up to date manifest
    :param connection: postgres connection
    """
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
    This is the main processing loop to traverse the API json returned.
    It uses the psycopg2 library which allows interaction between Python and postgres
    to take place.
    """
    import psycopg2
    # Set up postgres connection from variables
    connection = psycopg2.connect(user=ALL_VARS['DB_USER'],
                                  password=ALL_VARS['DB_PASSWORD'],
                                  host=ALL_VARS['DB_HOST'],
                                  port=ALL_VARS['DB_PORT'],
                                  database=ALL_VARS['DB_NAME'])
    truncate_tables(connection)
    try:
        cursor = connection.cursor()
        # Main loop: round each collection set up for harvesting
        cursor.execute("SELECT id, dspace_record from COLLECTION where run = 'Y' order by id;")
        while True:
            row = cursor.fetchone()
            if row == None:
                break
            collection = row[0]
            # DSpace determines whether we want to create a dspace record, or just a manifest
            dspace = str(row[1].strip())
            api_string = "https://images.is.ed.ac.uk/luna/servlet/as/fetchMediaSearch?fullData=true&bs=10000&lc=" + collection
            logger.info(api_string)
            # Get data from LUNA API for each record within the collection
            image_data = get_data(api_string)
            for record in image_data:
                shelfmark = 'N/A'
                sequence = 99999
                dor = ''
                size = record["urlSize1"]
                # Only interested in images, not Book Reader objects
                if record["mediaType"] == 'Book':
                    logger.info("This is a book- I do no more on it")
                else:
                    link_id = size.rsplit('/', 1)[-1]
                    image_id = link_id.split('.', 1)[0]
                    image_id = str(image_id).strip()
                    identity = "https://images.is.ed.ac.uk/luna/servlet/detail/" + record["identity"]
                    metadata = record["attributes"]
                    first_split = metadata.split('"],')
                    # Split out metadata items- identifying this is quite nasty. There should be a better way.
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
                            # Capture shelfmark and sequence for the image
                            if key == "work_shelfmark":
                                if dspace == 'Y':
                                    shelfmark = value
                            if key == "work_id_number":
                                if dspace == 'N':
                                    shelfmark = value
                            if key == "sequence":
                                try:
                                    sequence = int(value)
                                except Exception:
                                    # If unpaged, set all sequences to 99999 so we know not to page
                                    sequence = 99999
                            if key == "digital_object_reference":
                                dor = value
                    try:
                        if dor != '':
                            # If we are working with an Archive, DOR is king, so shelfmark can just be "Archive"
                            shelfmark = 'Archive'
                        # Simplification of shelfmark makes it easier to process
                        manifest_shelf = shelfmark.replace(" ", "-")
                        manifest_shelf = manifest_shelf.replace("*", "-")
                        manifest_shelf = manifest_shelf.replace("/", "-")
                        manifest_shelf = manifest_shelf.replace(".", "-")
                        manifest_shelf = manifest_shelf.replace(",", "-")
                        insert_cursor = connection.cursor()
                        # Create row in IMAGE table
                        postgres_insert_query = """ INSERT INTO IMAGE (image_id, collection, jpeg_path, shelfmark, sequence) VALUES (%s, %s, %s,%s, %s)"""
                        record_to_insert = (image_id, collection, identity, manifest_shelf, sequence)
                        insert_cursor.execute(postgres_insert_query, record_to_insert)
                        connection.commit()
                    except (Exception, psycopg2.Error) as error:
                        insert_cursor.close()
                        if connection:
                            logger.info(record_to_insert)
                            logger.info("Failed to insert record into IMAGE table with" + str(image_id) + str(identity),
                                        error)
                    if dor != '':
                        try:
                            # If Archive, also create row on IMAGE_DOR (idea is to allow multiple DORs for an image)
                            insert_dor_cursor = connection.cursor()
                            postgres_insert_dor_query = """ INSERT INTO IMAGE_DOR (image_id, dor_id) VALUES (%s,%s)"""
                            record_to_insert_dor = (image_id, dor)
                            insert_dor_cursor.execute(postgres_insert_dor_query, record_to_insert_dor)
                            connection.commit()
                        except (Exception, psycopg2.Error) as error:
                            insert_dor_cursor.close()
                            logger.info("Error while connecting to PostgreSQL", error)

    finally:
        # closing database connection.
        if connection:
            cursor.close()
            logger.info("END OF LUNA LOADER cursor is closed")

    try:
        # The LUNA API has done its work and the IMAGE table is populated. Now loop round IMAGE table getting shelfmarks
        loop_shelf_cursor = connection.cursor()
        loop_shelf_sql = "select distinct(upper(i.shelfmark)), i.collection, c.dspace_record, c.paged from IMAGE i, COLLECTION c where i.collection = c.id group by upper(i.shelfmark), i.collection, c.dspace_record, c.paged order by upper(i.shelfmark), i.collection;;"
        loop_shelf_cursor.execute(loop_shelf_sql)
        while True:
            row = loop_shelf_cursor.fetchone()
            if row is None:  # better: if not row
                break
            # Bring back info for IMAGE
            manifest_shelf = str(row[0]).strip()
            collection = str(row[1]).strip()
            dspace = str(row[2]).strip()
            if manifest_shelf == 'N/A':
                break
            else:
                # Big IF statement, processing differently for Archives/normal shelfmarks
                if manifest_shelf == 'ARCHIVE':
                    # To set appropriate manifest name, we need to know type
                    manifest_type = manifest_shelf
                    logger.info("working on an Archive")
                    try:
                        dor_cursor = connection.cursor()
                        dor_sql = "select distinct(dor_id) from IMAGE_DOR;"
                        dor_cursor.execute(dor_sql)
                        # This brings back the DOR ID as a volume level to work with
                        while True:
                            row = dor_cursor.fetchone()
                            if row is None:
                                break
                            else:
                                manifest_shelf = row[0]
                                # Check if this DOR already has a manifest, or if a new one needs to be created
                                manifest_name = manifest_check_insert(connection, manifest_shelf, collection, manifest_type)
                                # Get all images for DOR
                                image_get_sql = "select i.jpeg_path, i.sequence from IMAGE i, IMAGE_DOR id where id.dor_id ='" + manifest_shelf + "' and collection = '" + collection + "' and id.image_id = i.image_id order by i.sequence, i.jpeg_path;"
                                manifest_array = get_images(connection, image_get_sql)
                                logger.info(manifest_array)
                                if len(manifest_array) > 0:
                                    paged = False
                                    need_dummy = False
                                    # If unsequenced (99999), do not attempt to set page paramater
                                    if int(manifest_array[0][1]) == 99999:
                                        paged = False
                                    else:
                                        paged = True
                                        if (int(manifest_array[0][1]) % 2) == 0:
                                            #If we need to set a fake manifest at the top so paging works
                                            need_dummy = True
                                        else:
                                            need_dummy = False
                                    # Now create the manifest
                                    create_manifests(manifest_array, manifest_name, ENVIRONMENT, paged, need_dummy,
                                                     manifest_shelf)
                                    if dspace == 'Y':
                                        # Now create the dspace record in usual directory structure
                                        out_file = get_subfolder(manifest_name)
                                        import xml.etree.cElementTree as et_out
                                        outroot = et_out.Element(ALL_VARS['DC_HEADER'])
                                        create_dspace_record(manifest_array, out_file, et_out, outroot, manifest_name,
                                                             manifest_shelf)
                                else:
                                    logger.error("DEAD MANIFEST NAME" + str(manifest_name))
                    except (Exception, psycopg2.Error) as error:
                        logger.info("Failed to get from IMAGE_DOR", error)
                else:
                    # If we are not working on an Archive, we can use the image info we brought back in the first select
                    logger.info("Working on " + manifest_shelf)
                    # Check if this shelfmark already has a manifest, or if a new one needs to be created
                    # To set appropriate manifest name, we need to know type
                    manifest_type = manifest_shelf
                    manifest_name = manifest_check_insert(connection, manifest_shelf, collection, manifest_type)
                    # Get all images for shelfmark
                    image_get_sql = "select jpeg_path, sequence from IMAGE where upper(shelfmark) =upper('" + manifest_shelf + "') and collection = '" + collection + "' order by sequence, jpeg_path;"
                    manifest_array = get_images(connection, image_get_sql)
                    logger.info(manifest_array)
                    if len(manifest_array) > 0:
                        paged = False
                        need_dummy = False
                        if int(manifest_array[0][1]) == 99999:
                            paged = False
                        else:
                            paged = True
                            if (int(manifest_array[0][1]) % 2) == 0:
                                need_dummy = True
                            else:
                                need_dummy = False
                        # Now create the manifest
                        create_manifests(manifest_array, manifest_name, ENVIRONMENT, paged, need_dummy, manifest_shelf)
                        if dspace == 'Y':
                            # Now create the dspace record if necessary
                            out_file = get_subfolder(manifest_name)
                            import xml.etree.cElementTree as et_out
                            outroot = et_out.Element(ALL_VARS['DC_HEADER'])
                            create_dspace_record(manifest_array, out_file, et_out, outroot, manifest_name, manifest_shelf)
                    else:
                        logger.error("DEAD MANIFEST ID" + str(manifest_name))
    except (Exception, psycopg2.Error) as error:
        logger.info("Failed along the way", error)

    finally:
        # closing database connection.
        if connection:
            loop_shelf_cursor.close()
            connection.close()
            logger.info("END OF PROG PostgreSQL connection is closed")
    FM.close()


if __name__ == '__main__':
    main()
