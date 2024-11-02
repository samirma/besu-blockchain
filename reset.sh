docker system prune -a

cd ~/besu-blockchain/Node-1/data

sudo rm -Rf DATABASE_METADATA.json  VERSION_METADATA.json  caches  database  uploads

cd ~/besu-blockchain/Node-2/data

sudo rm -Rf DATABASE_METADATA.json  VERSION_METADATA.json  caches  database  uploads

cd ~/besu-blockchain/Node-3/data

sudo rm -Rf DATABASE_METADATA.json  VERSION_METADATA.json  caches  database  uploads

sudo chown -R 1000:1000 Node-*

tree
