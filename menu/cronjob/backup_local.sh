#!/bin/bash

######################################################################
#           Auto Install & Optimize LEMP Stack on CentOS 7, 8        #
#                                                                    #
#                Author: Sanvv - HOSTVN Technical                    #
#                  Website: https://hostvn.vn                        #
#                                                                    #
#              Please don't remove copyright. Thank!                 #
# Please don't copy copy under any circumstance for business reason! #
######################################################################

# shellcheck disable=SC2154
# shellcheck disable=SC1091
source /var/hostvn/hostvn.conf
# shellcheck disable=SC1091
source /var/hostvn/menu/helpers/variable_common

backup_num=$(grep "backup_num" "${FILE_INFO}" | cut -f2 -d'=')

for users in /home/*; do
	if [[ -d "${users}" ]]; then
		user=${users##*/}
		for domains in /home/"${user}"/*; do
			if [[ -d "${domains}" ]]; then
				domain=${domains##*/}
				for publics in /home/${user}/${domain}/public_html; do
					if [[ -d "${publics}" ]]; then
						public=${publics##*/}
						db_name=$(grep "db_name" "${USER_DIR}/.${domain}.conf" | cut -f2 -d'=')
						if [[ ! -d "/home/backup/${DATE}/${domain}" ]]; then
							mkdir -p /home/backup/"${DATE}"/"${domain}"
						fi
						rm -rf /home/backup/"${DATE}"/"${domain}"/*
						cd_dir /home/backup/"${DATE}"/"${domain}"
						mysqldump -uadmin -p"${mysql_pwd}" "${db_name}" > "${db_name}".sql

						cd_dir /home/"${user}"/"${domain}"
						tar -cpzvf /home/backup/"${DATE}"/"${domain}"/"${domain}".tar.gz "${public}"
					fi
				done
			fi
		done
	fi
done

old_backup=$(date -d "${backup_num} days ago" +%Y-%m-%d)

for D in /home/backup/*; do
	[[ -d "${D}" ]] || continue
	folder=${D##*/}
	if [[ ${folder} -ne ${old_backup} ]]; then
		rm -rf /home/backup/"${folder}"
	fi
done