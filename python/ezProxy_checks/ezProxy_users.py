import csv
AUDIT = open('sessions.txt', 'r')
AUDIT_LIST = csv.DictReader(AUDIT, delimiter=',')
AUDIT_ARRAY = list(AUDIT_LIST)
AUDIT_LEN = len(AUDIT_ARRAY)

sum_file = "userlist3.txt"
out_file = open(sum_file, "w")

audit_row = 0
while audit_row < AUDIT_LEN:
    print(AUDIT_ARRAY[audit_row])
    session = str(AUDIT_ARRAY[audit_row]['USER'])
    print('WORKING WITH ' + session)
    with open("20191116.txt") as fobj:
        for line in fobj:
            if "Logout" in line:
                if session in line:
                    out_file.write(str(line))


    audit_row +=1