#!/bin/bash
#title           : dns_list_validation.sh
#description     : Takes a list of DNS entries and look of the DNS creation date (and ping the IP address).
#author		 : Gregory Cardiet
#date            : 2017/10/01
#version         : 1.0
#usage		 : bash dns_list_validator.sh or ./dns_list_validator.sh
#==============================================================================

# Validate that a file has been in order to validate the entries.
if [ "$#" -ne 1 ]; then
    echo "[ERROR] Illegal number of parameters."
    echo ""
    echo "The correct use of the tool should be $0 and a file with the list of entries. The file should contain only a succession of DNS entries, one per line. This would be an example."
    echo ""
    echo "ovzmelkxgtgf.com"
    echo "kpsdnlprwclz.com"
    echo "kfpwayrztgjj.com"
    echo "gzumjmvqjkki.com"
    echo ""
    exit
fi

# For each DNS entry (one per line), validate the DNS entry and if the server is up and running.
while IFS='' read -r line || [[ -n "$line" ]]; do

    #Linux: creation_date=`whois $line | grep -E 'Creation Date: [[:digit:]]{2}-[a-z]{3}' | rev | cut -d " " -f 1 | rev`
    creation_date=`whois $line | grep -m 1 -E "Creation Date" | rev | cut -d " " -f 1 | rev`

    if [[ $creation_date ]]; then
      if ! ping -c 1 "$line" &>/dev/null ; then
          status="Down"
      else
          status="Up"
      fi
      printf "$line ($status): DNS Creation Date $creation_date\n"
    else
      printf "$line (Down): No DNS Creation Date\n"
    fi

done < $1
