import csv
import re
import json
AUDIT = open('value.txt', 'r')
AUDIT_LIST = csv.DictReader(AUDIT, delimiter='\t')
AUDIT_ARRAY = list(AUDIT_LIST)
AUDIT_LEN = len(AUDIT_ARRAY)


audit_row = 0

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

while audit_row < AUDIT_LEN:
    value = str(AUDIT_ARRAY[audit_row]['alma_id'])
    found = False
    print(value)
    out = re.match(r"^99", value)
    print(str(out))
    if out is not None:
        alma_url = 'https://open-na.hosted.exlibrisgroup.com/alma/44UOE_INST/bibs/' + value
        print(alma_url)
        alma_data = get_data(alma_url)

        if alma_data == '':
            print("dead_url " + alma_url)
        else:
            for key, value in alma_data.items():
                print(str(key) + str(value))
                twod = False
                if isinstance(value, list):
                    try:
                        for subkey, subvalue in value[0].items():
                            twod = True
                    except:
                        twod = False
                        for child in value:
                            if type(child) is not list:
                                print(str(key) + str(child))
                    if twod:
                        value_len = len(value)
                        count = 0
                        while count < value_len:
                            full_string = ''
                            for subkey, subvalue in value[count].items():
                                    full_string = full_string  + str(subvalue) + ' | '
                            print(str(key) + full_string)
                            count += 1
                else:
                    if isinstance(value, dict):
                        full_string = ''
                        for subkey, subvalue in value.items():
                            full_string = full_string + str(subvalue) + " | "
                        print(str(key) + full_string)
                    else:
                        print(str(key) + str(value))

    audit_row += 1