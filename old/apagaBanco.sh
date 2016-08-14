

mysqladmin processlist -u root superCompras | \
awk '$2 ~ /^[0-9]/ {print "KILL "$2";"}' | \
mysql -u root 
mysqladmin -u root   drop superCompras -f
