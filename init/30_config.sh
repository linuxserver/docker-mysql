#!/bin/bash

# make folders if required
mkdir -p "$DATADIR" /var/run/mysqld /config/log/mysql

# configure my.cnf and mysqld_safe
sed -i 's/key_buffer\b/key_buffer_size/g' /etc/mysql/my.cnf
sed -ri 's/^(bind-address|skip-networking)/;\1/' /etc/mysql/my.cnf
sed -i s#/var/log/mysql#/config/log/mysql#g /etc/mysql/my.cnf
sed -i -e 's/\(user.*=\).*/\1 abc/g' /etc/mysql/my.cnf
sed -i -e "s#\\(datadir.*=\\).*#\\1 $DATADIR#g" /etc/mysql/my.cnf
sed -i "s/user='mysql'/user='abc'/g" /usr/bin/mysqld_safe

# setup custom cnf file
[[ ! -f /config/custom.cnf ]] && cp /defaults/my.cnf /config/custom.cnf
[[ ! -L /etc/mysql/conf.d/custom.cnf && -f /etc/mysql/conf.d/custom.cnf ]] && rm /etc/mysql/conf.d/custom.cnf
[[ ! -L /etc/mysql/conf.d/custom.cnf ]] && ln -s /config/custom.cnf /etc/mysql/conf.d/custom.cnf

# set permissions
chmod -R 777 /var/run/mysqld

