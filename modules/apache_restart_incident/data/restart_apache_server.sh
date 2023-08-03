bash

#!/bin/bash

# Restart Apache server

systemctl restart apache2

# Test the restart

curl -I ${APACHE_URL}

# Check the HTTP status code

if [ "$?" -ne 0 ]; then

  echo "Apache server is not running correctly."

else

  echo "Apache server is running correctly."

fi