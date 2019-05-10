"""
Imports QMU EPrint CSV file
"""
import sqlite3
import csv
import codecs
#import citation

#need to create a dc:identifier:citation field (author surname, (year), title, thesis / pub type, publisher / queen margaret university)
"""
AUTHOR field, separate with comma
creators_name.family:dc:creator:authorsurname: #concacentate as with editor name
creators_name.given:dc:creator:authorfirst:

CONTRIBUTOR field, separate with comma
contributors_name.family:dc:contributor:authorsurname: #concacentate as with editor name
contributors_name.given:dc:contributor:authorfirst:

EDITOR FIELD
editors_name.family:dc:contributor:editorsurname: #concatenate to dc:contributor:editor separate by comma
editors_name.given:dc:contributor:editorFirst:

CITATION field
place_of_pub:dc:description:noqual: #concacentate to dc:identifier:citation
volume:dc:description:volume: #concenate to citation
pages:dc:format:extent: #add to citation as well
pagerange:dc:format:extent: #add to citation as well

QMU citation style

WILLIAMS, R., 2003. Television: technology and cultural form. London: Routledge.


mapping.txt snippet:

citation:dc:identifier:citation
author:dc:contributor:author
editor:dc:contributor:editor
contributor:dc:contributor:contributor
"""

def rreplace(s, old, new, count):
    return (s[::-1].replace(old[::-1], new[::-1], count))[::-1]

def quote_identifier(s, errors="strict"):
    """Removes quotes"""
    encodable = s.encode("utf-8", errors).decode("utf-8")
    nul_index = encodable.find("\x00")
    if nul_index >= 0:
        error = UnicodeEncodeError("utf-8", encodable, nul_index, nul_index + 1, "NUL not allowed")
        error_handler = codecs.lookup_error(errors)
        replacement, _ = error_handler(error)
        encodable = encodable.replace("\x00", replacement)
    return "\"" + encodable.replace("\"", "\"\"") + "\""

def create_records(repo):
    error_log = []
    """Connect to SQLlite database & import data from CSV file"""
    conn = sqlite3.connect(repo+'.db')
    c = conn.cursor()
    query = '''pragma encoding=utf16;'''
    c.execute(query)
    results = []
    try:
        query = """DROP TABLE records;"""
        c.execute(query)
        conn.commit()
    except Exception as e:
        print (str(e))
    with open(repo+'.csv', 'rU', encoding='latin-1') as csvfile:#SR- had issues running the new CSV with replaces. I THINK this is ok, but not 100% sure.
        reader = csv.DictReader(csvfile)
        for row in reader:
            results.append(row)
    try:
        query = '''CREATE TABLE records('''
        for result in results[0].keys():
            query = query + "" + quote_identifier(result) + ","
        query = query.rstrip(',')
        query = query + ");"
        c.execute(query)
        conn.commit()
    except Exception as e:
        print (str(e))

    num_queries = 0
    for result in results:
        try:
            query = "INSERT INTO records VALUES ("
            for i in result.values():
                query = query + '"' + i.replace('"', '') + '",'
            query = query.rstrip(',')
            query = query + ");"
            c.execute(query)
            conn.commit()
            num_queries = num_queries + 1
            if num_queries%100 == 0:
                print('Successfully performed: '+str(num_queries)+'/'+str(len(results))+' intial inserts')
        except Exception as exception:
            error_log.append(exception)
            print(str(exception))

    #create concatenated fields
    query = "ALTER TABLE records ADD editor VARCHAR;"
    c.execute(query)
    conn.commit()
    query = "ALTER TABLE records ADD authors VARCHAR;"
    c.execute(query)
    conn.commit()
    query = "ALTER TABLE records ADD contributor VARCHAR;"
    c.execute(query)
    conn.commit()
    query = "ALTER TABLE records ADD citation VARCHAR;"
    c.execute(query)
    conn.commit()
    #SR- add an additional column for QMU authors
    query = "ALTER TABLE records ADD qmu_authors VARCHAR;"
    c.execute(query)
    conn.commit()

    #query SQL for full result set
    query = """SELECT DISTINCT eprintid FROM records;"""
    c1 = conn.cursor()
    counter = 0
    for result in c.execute(query):
        try:
            counter += 1
            print (counter)#this counts the number of queries
            authors = []
            editors = []
            contributors = []
            citation_authors = []#SR- adding a new field for surname, initial only (for citations)
            qmu_authors = []
            #authors = ''
            #editors = ''
            #contributors = ''
            #citation_authors = ''#SR- adding a new field for surname, initial only (for citations)
            #qmu_authors = ''
            citation = ''
            #create author
            query1 = """SELECT [creators_name.family], [creators_name.given] FROM records WHERE eprintid = """ +"""'"""+result[0]+"""' AND [creators_name.family] != '' AND [creators_name.given] != '' AND [creators_name.given] != '.'"""
            c1 = conn.cursor()
            for result1 in c1.execute(query1):
                print("bit" + result1[0] + "bit" + result1[1])
                authors.append(result1[0]+', '+result1[1]+'., ')#SR - changed to keep full name for authors, but keep the ., as it's good for delimiting downstream
                citation_authors.append(result1[0]+', '+result1[1][0]+'., ')#SR - added so we can keep this functionality for citation only
            #create editor
            query2 = """SELECT [editors_name.family], [editors_name.given] FROM records WHERE eprintid = """ +"""'"""+result[0]+"""' AND [editors_name.family] != '' AND [editors_name.given] != '' AND [editors_name.given] != '.'"""
            c2 = conn.cursor()
            for result2 in c2.execute(query2):
                print("bit" + result1[0] + "bit" + result1[1])
                editors.append(result2[0]+', '+result2[1][0]+'., ')
                print("EDITORS" + editors)
            #create contributor
            query3 = """SELECT [contributors_name.family], [contributors_name.given] FROM records WHERE eprintid = """ +"""'"""+result[0]+"""' AND [contributors_name.family] != '' AND [contributors_name.given] != '' AND [contributors_name.given] != '.'"""
            c3 = conn.cursor()
            for result3 in c3.execute(query3):
                contributors.append(result3[0]+', '+result3[1][0]+'., ')
            #get date, title, publisher, place of publication
            citation_info = {}
            query5 = """SELECT [date], [publisher], [type], [publication], [place_of_pub], [title], [volume], [pages], [pagerange] FROM records WHERE eprintid = '"""+result[0]+"""' AND type != ''"""

            c5 = conn.cursor()
            for result5 in c5.execute(query5):
                citation_info = {}
                citation_info['date'] = '2018'
                date = result5[0]
                if date.find('-') > -1:
                    date = date.split('-')[0]
                if date.find('/') > -1:
                    date = date.split('/')[2]
                    if int(date) < 50:
                        date = 2000 + int(date)
                        date = str(date)
                    else:
                        date = int(date)
                        date = str(date)
                citation_info['date'] = date
                citation_info['publisher'] = result5[1]
                citation_info['type'] = result5[2]
                citation_info['publication'] = result5[3]
                citation_info['place_of_pub'] = result5[4]
                citation_info['title'] = result5[5]
                #SR- added three fields to citation
                if result5[6] != '':
                    citation_info['volume'] = "vol. " + result5[6]
                else:
                    citation_info['volume'] = result5[6]
                if result5[7] != '':   
                    citation_info['number'] = "no. " + result5[7]
                else:
                    citation_info['number'] = result5[7]   
                if result5[8] != '':    
                    citation_info['pagerange'] = "pp. " + result5[8]
                else:
                    citation_info['pagerange'] = result5[8]
                #SR- was told to get number of volume, but not number of pages, so have done accordingly


            #SR- get qmu_authors- we have fields at the end of the csv which define these exclusively
            #query6 = """SELECT [creators_browse_name.family], [creators_browse_name.given] FROM records WHERE eprintid = """ +"""'"""+result[0]+"""' AND [creators_browse_name.family] != '' AND [creators_browse_name.given] != '' AND [creators_browse_name.given] != '.'"""
            #c6 = conn.cursor()
            #for result6 in c6.execute(query6):
            #    qmu_authors.append(result6[0]+', '+result6[1]+'., ')#SR - changed to keep full name for authors

            #create authors
            print("doing authors")
            authors_string = ''
            for a in authors:
                print(a)
                authors_string += a
                print("STRING" + authors_string)
            authors_string = authors_string.replace("'", "''")
            authors_string = rreplace(authors_string, '.,', '. ', 1)
            authors_string = rreplace(authors_string, '.,', '. & ', 1)
            print("AUTHORS STRING pre upload" + authors_string)
            #add authors to record
            query4 = """UPDATE records SET authors = '"""+authors_string+"""' WHERE eprintid = '"""+result[0]+"""';"""
            c1.execute(query4)
            conn.commit()

            #create authors
            editor_string = ''
            for a in editors:
                editor_string += a
            editor_string = editor_string.replace("'", "''")
            editor_string = rreplace(editor_string, '.,', '. ', 1)
            editor_string = rreplace(editor_string, '.,', '. & ', 1)
            #add editor to record
            query9 = """UPDATE records SET editor = '"""+editor_string+"""' WHERE eprintid = '"""+result[0]+"""';"""
            c1.execute(query9)
            conn.commit()

            #SR -need to generate citation authors separately
            citation_authors_string = ''
            for c_a in citation_authors:
                citation_authors_string += c_a
            citation_authors_string = citation_authors_string.replace("'", "''")
            citation_authors_string = rreplace(citation_authors_string, '.,', '. ', 1)
            citation_authors_string = rreplace(citation_authors_string, '.,', '. & ', 1)

            #SR- create QMU authors
            qmu_authors_string = ''
            for q_a in qmu_authors:
                qmu_authors_string += q_a
            qmu_authors_string = qmu_authors_string.replace("'", "''")
            qmu_authors_string = rreplace(qmu_authors_string, '.,', '. ', 1)
            qmu_authors_string = rreplace(qmu_authors_string, '.,', '. & ', 1)
            #add authors to record
            query7 = """UPDATE records SET qmu_authors = '"""+qmu_authors_string+"""' WHERE eprintid = '"""+result[0]+"""';"""
            c1.execute(query7)
            conn.commit()

            #create citation (place of publication is not stored in eprints records!!!)
            citation = ''
            #SR- shoehorning fields in
            #print(str(citation_authors_string))
            #print(str(citation_info))
            #citation = citation_authors_string.encode('utf-8') + ' ('+ str(citation_info['date'].encode('utf-8')) + ') ' + str(citation_info['title'].encode('utf-8')) +', '+ str(citation_info['publication'].encode('utf-8')) +', '+ str(citation_info['volume'].encode('utf-8')) +', '+ str(citation_info['pages'].encode('utf-8'))+', '+ str(citation_info['pagerange'].encode('utf-8'))+', '+ str(citation_info['place_of_pub'].encode('utf-8'))
            citation = citation_authors_string + ' ('+ str(citation_info['date']) + ') ' + str(citation_info['title']) +', '+ str(citation_info['publication']) +', '+ str(citation_info['volume']) +', '+ str(citation_info['number'])+', '+ str(citation_info['pagerange'])+', '+ str(citation_info['place_of_pub'])
            #print(str(citation))
            citation = citation.replace("'", "''")
            #query_citation = """UPDATE records SET citation = '"""+citation.decode('utf-8')+"""' WHERE eprintid = '"""+result[0]+"""';"""
            query_citation = """UPDATE records SET citation = '"""+citation+"""' WHERE eprintid = '"""+result[0]+"""';"""
            #print (query_citation)
            c1.execute(query_citation)
            conn.commit()
            #fix missing division names
            query8 = """UPDATE records SET divisions = 'NO DIVISION' WHERE eprintid IN (SELECT DISTINCT (eprintid) FROM records WHERE eprintid NOT IN (SELECT eprintid FROM records WHERE divisions != '' GROUP BY eprintid));"""
            c1.execute(query8)
            conn.commit()
        except Exception as e:
            print (str(e))
            print (result[0])
            error_log.append(e)
            error_log.append(result)
    print('Successfully performed: '+str(num_queries)+'/'+str(len(results))+' queries')
    for e in error_log:
        print (e)
        print ('\n')
def main():
    """ """
    #create_records('e-research')
    create_records('e-theses')
    print ('database import complete')
if __name__ == "__main__":
    main()
    