import logCheck
import importlib
importlib.reload(logCheck)

# SSH authentication failures
def apache_events(filename, service, term):
    
    # Call syslogCheck and return the results
    is_found = logCheck._logs(filename, service, term)

    # Found list
    found = []

    # Loop through the results
    for eachFound in is_found:
        
        #print(eachFound)
        # Split the results
        sp_results = eachFound.split(" ")

        # Append the split value to the found list
        # "GET /server-info?mod_info.c HTTP/1.1" 404 435 "-" "-"
        found.append(sp_results[0] + " - " + sp_results[2] + " - " + sp_results[4] + " bytes sent, " + sp_results[7] + " bytes received.")

    # Remove duplicates by using set
    # and convert the list to a dictionary
    hosts = set(found)

    # Print results
    for eachHost in hosts:
        print(eachHost)