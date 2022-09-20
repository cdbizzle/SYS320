# Need to import re
import csv
import re
# change typo in ur1HauseOpen to urlhausopen
def urlHausOpen(filename,searchTerm):
# Changed 'filename' to filename (the variable)
# Changed while to with
    with open(filename) as f:
        #changed csv.review to csv.reader
        contents = csv.reader(f)
        for _ in range(9):
            next(contents)
        #for keyword in searchTerms:
        for eachLine in contents:
            x = re.findall(r"" + searchTerm + "", eachLine[2])
            for _ in x:
            # Don't edit this line. It is here to show how it is possible
            # to remove the "tt" so programs don't convert the malicious
            # domains to links that an be accidentally clicked on.
                the_url = eachLine[2].replace("http","hxxp")
                the_src = eachLine[7]
                print("""
                URL: {}
                Info: {}
                {}""".format(the_url, the_src, "*" * 60))