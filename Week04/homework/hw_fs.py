# File to traverse the given directory and it's subdirectories and retrieve all the files
import os, argparse, re, sys, yaml

# Open the yaml file
try:
    with open('searchTerms.yaml', 'r') as yf:
        keywords = yaml.safe_load(yf)
except EnvironmentError as e:
    print(e.strerror)

# parser
parser = argparse.ArgumentParser(
    description="Traverses a directory and builds a forensic body file",
    epilog = "Developed by Cole Davis-Brand, September 2022"
)

# add arguement to pass to the fs.py program

parser.add_argument("-d", "--directory", required="True", help="Directory that you want to traverse")
parser.add_argument("-s", "--search", required="True", help="Search terms")

# Parse the arguments
args = parser.parse_args()
rootdir = args.directory
sTerms = keywords[args.search]


# Get information from the command line
#print(sys.argv)

# Directory to traverse
#rootdir = sys.argv[1]
#print(rootdir)

# Traverse a directory
# Check if argument is a directory

if not os.path.isdir(rootdir):
    print("Invalid directory -> {}".format(rootdir))
    exit()

# List to save files
fList = []
# Crawl through provided directory
for root, subfolders, filenames in os.walk(rootdir):
    for f in filenames:
        #print(root + "\\" + f)
        fileList = root + "\\" + f
        #print(fileList)
        fList.append(fileList)

#print(fList)

def _logs(filename, service):

    # Query the yaml file for the term or directive and retrieve the strings to search on
    terms = service
    listOfKeywords = terms.split(",")

    # Open a file
    with open(filename) as f:

        #read in the file and save it to a variable
        contents = f.readlines()

    # List to store the results
    results = []

    # Loop through the list returned. Each element is a lone from the smallSyslog file
    for line in contents:

        # Loops through keywords
        for eachKeyword in listOfKeywords:

            # If the 'line' contains the keyword then it will print
            # if eachKeyword in line
            # Searches and returns results using a regular expression search
            x = re.findall(r''+eachKeyword+'', line)

            for found in x:
                # Append the returned keywords to the results list
                results.append(found)


    # Sort the list
    results = sorted(results)
    endResults = []

    for line in results:
        print(line)

    return endResults

for f in fList:
    _logs(f,sTerms)