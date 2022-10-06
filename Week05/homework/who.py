# Imports needed 
import argparse, re, csv, os, yaml

# Open the YAML file
def _get(searchTerm):
    try:
        with open('searchTerms.yaml', 'r') as yf:
            keywords = yaml.safe_load(yf)
    except EnvironmentError as e:
        print(e.strerror)
    return keywords[searchTerm]

# Parser
def doParse():
    parser = argparse.ArgumentParser(
        description="Traverses a directory and pulls data using keywords in 'searchTerms'",
        epilog = "Developed by Cole Davis-Brand, October 2022"
        )
    # Creating arguements, in this case I added two
    parser.add_argument("-d", "--directory", required="True", help="Directory that you want to traverse")
    parser.add_argument("-s", "--searchTerm", required="True", help="Search terms from YAML file")

    # Parse the arugments
    args = parser.parse_args()
    return args

def doCSV(rootdir):
    if not os.path.isdir(rootdir):
        print("Invalid directory -> {}".format(rootdir))
        exit()

    fList = []

    # Crawl thorugh the provided directory
    for root, _, filenames in os.walk(rootdir):
        for f in filenames:
            fileList = root + "\\" + f
            fList.append(fileList)
    # Get the contents of the CSV file       
    csvList = []
    for file in fList:
        with open(file, 'r', encoding='utf-8') as csvFile:
            reader = csv.DictReader(csvFile)
            for row in reader:
                csvList.append(row)
    
    # Return the output
    return csvList

def complete():
    # Configure all moving parts to execute properly
    args = doParse()
    inside = doCSV(args.directory)
    searchTerm = _get(args.searchTerm)
    splitTerms = searchTerm.split(', ')

    # Using a loop, go through each line
    for line in inside:
        for term in splitTerms:
            if bool(re.findall(r'' + term + '', line.get("arguments"))):
                print("""
                Term: {}
                Line: {} | {} | {} | {} | {}
                """.format(term,
                line["arguments"], 
                line["hostname"], 
                line["name"],
                line["path"],
                line["pid"],
                line["username"]))

if __name__ == "__main__":
    complete()