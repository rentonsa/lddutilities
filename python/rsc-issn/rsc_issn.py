import csv
AUDIT = open('journal_list', 'r')
AUDIT_LIST = csv.DictReader(AUDIT, delimiter='\t')
AUDIT_ARRAY = list(AUDIT_LIST)
AUDIT_LEN = len(AUDIT_ARRAY)

sum_file = "summary_file.txt"
out_file = open(sum_file, "w")

audit_row = 0
while audit_row < AUDIT_LEN:
    journal = str(AUDIT_ARRAY[audit_row]['dc.relation.ispartof[en]'])
    found = False
    with open("journal_issn.txt") as fobj:
        for line in fobj:
            journal_line = line.split(",")
            journal_authority = journal_line[0]
            issn = journal_line[1]
            if journal == journal_authority:
                print(str(journal) + "," + str(issn))
                out_file.write(str(journal) + "," + str(issn))
                found = True

        if found == False:
            out_file.write(str(journal)+"\n")

    audit_row +=1