mkdir -m 0700 ./secrets
printf "%s" "S3cr3t_Pg_Pass" > ./secrets/db_password
chmod 0400 ./secrets/db_password
