#!/bin/bash
host=$1
path=$2
site=$3

# add ssh-config for vagrant to ~/.ssh/config
sed "/^$/d;s/Host /$NL&/" ~/.ssh/config | sed "/^Host $host$/,/^$/d;"> config &&
cat config > ~/.ssh/config &&
rm config &&
vagrant ssh-config --host $host >> ~/.ssh/config

# add wp-cli.local.yml to project root if it doesn't exist with alias for @dev
cd $path/.. &&
if [ ! -f wp-cli.local.yml ]
then
  touch wp-cli.local.yml
fi

if ! grep -Fxq "@dev" wp-cli.local.yml
then

cat << EOF > wp-cli.local.yml
@dev:
  ssh: vagrant@$host/srv/www/$site/current
  path: web/wp
EOF

fi
