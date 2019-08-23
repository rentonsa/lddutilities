import csv
AUDIT = open('sessions_ez2.txt', 'r')
AUDIT_LIST = csv.DictReader(AUDIT, delimiter='\t')
AUDIT_ARRAY = list(AUDIT_LIST)
AUDIT_LEN = len(AUDIT_ARRAY)

sum_file = "summary_file_ezp_2.txt"
out_file = open(sum_file, "w")

audit_row = 0
while audit_row < AUDIT_LEN:
    session = str(AUDIT_ARRAY[audit_row]['SESSION'])
    status = str(AUDIT_ARRAY[audit_row]['STATUS'])

    if status == 'Logout':
        print('WORKING WITH ' + session)
        with open("ez2log.log") as fobj:
            for line in fobj:
                if session in line:
                    out_file.write(str(line))


    audit_row +=1