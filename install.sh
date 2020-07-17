#!/bin/bash

#################################################
# Auto Install & Optimize LEMP Stack on CentOS 7#
# Version: 1.0                                  #
# Author: Sanvv - HOSTVN Technical              #
# Website: https://hostvn.net                   #
#                                               #
# Please don't remove copyright. Thank!         #
#################################################

# Set link
SCRIPT_LINK="https://scripts.sanvu88.net/lemp"

# VPS Info
OS_VER=$(rpm -E %centos)
OS_ARCH=$(uname -m)
RAM_TOTAL=$(awk '/MemTotal/ {print $2}' /proc/meminfo)

# Control Panel path
CPANEL="/usr/local/cpanel/cpanel"
DIRECTADMIN="/usr/local/directadmin/custombuild/build"
PLESK="/usr/local/psa/version"
WEBMIN="/etc/init.d/webmin"
SENTORA="/root/passwords.txt"
HOCVPS="/etc/hocvps/scripts.conf"
VPSSIM="/home/vpssim.conf"
EEV3="/usr/local/bin/ee"
WORDOPS="/usr/local/bin/wo"
KUSANAGI="/home/kusanagi"
CWP="/usr/local/cwpsrv"
VESTA="/usr/local/vesta/"
EEV4="/opt/easyengine"

# Set Lang
ROOT_ERR="Ban can chay script voi user root. Chay lenh \"sudo su\" de co quyen root!"
CANCEL_INSTALL="Huy cai dat..."
OS_WROG="Script chi hoat dong tren \"CentOS 7\"!"
RAM_NOT_ENOUGH="Canh bao: Dung luong RAM qua thap de cai Script. (it nhat 512MB)"
OTHER_CP_EXISTS="May chu cua ban da cai dat Control Panel khac. Vui long rebuild de cai dat Script."
HOSTVN_EXISTS="May chu cua ban da cai dat HOSTVN Script khac. Vui long rebuild neu muon cai dat lai."

# Set Color
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

welcome(){
    clear
    printf "=========================================================================\n"
    echo   "                            HOSTVN.NET Scripts                             "
    echo   "                 Auto Install & Optimize LEMP Stack on CentOS 7            "
    printf "          Neu can ho tro vui long lien he %s\n" "kythuat@hostvn.net"
    printf "=========================================================================\n"
    echo ""
    echo "Chuan bi cai dat..."
    sleep 3
}

###################
# Prepare Install #
###################

# Remove unnecessary services
remove_old_ervice(){
    yum -y remove mysql* php* httpd* sendmail* postfix* rsyslog* nginx*
    yum clean all
}

# Install requirement service
install_requirement(){
    yum -y install epel-release
    yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
    yum -y update
    yum -y install gawk bc wget tar gcc gcc-c++ flex bison make bind bind-libs bind-utils yum-utils shc dos2unix openssl openssl-devel perl quota libaio \
    libcom_err-devel libcurl-devel gd zlib-devel zip unzip libcap-devel cronie bzip2 cyrus-sasl-devel perl-ExtUtils-Embed ntpdate \
    autoconf automake libtool which patch mailx bzip2-devel lsof glibc-headers kernel-devel expat-devel nano htop git syslog-ng syslog-ng-libdbi \
    psmisc net-tools systemd-devel libdb-devel perl-DBI perl-Perl4-CoreLibs perl-libwww-perl xfsprogs rsyslog logrotate crontabs file kernel-headers
}


###################
#Check conditions #
###################

# Check if user not root
check_root(){
    if [[ "$(id -u)" != "0" ]]; then
        printf "${RED}%s${NC}\n" "${ROOT_ERR}"
        printf "${RED}%s${NC}\n" "${CANCEL_INSTALL}"
        exit
    fi
}

# Check OS
check_os(){
    if [[ "${OS_VER}" != "7" ]]; then
        printf "${RED}%s${NC}\n" "${OS_WROG}"
        printf "${RED}%s${NC}\n" "${CANCEL_INSTALL}"
        exit
    fi
}

# Check if not enough ram
check_low_ram(){
    if [[ "${RAM_TOTAL}" -lt "${LOW_RAM}" ]]; then
        printf "${RED}%s${NC}\n" "${RAM_NOT_ENOUGH}"
        printf "${RED}%s${NC}\n" "${CANCEL_INSTALL}"
        exit
    fi
}

# Check if other Control Panel has installed before
check_control_panel(){
    if [[ -f "${CPANEL}" || -f "${DIRECTADMIN}" || -f "${PLESK}" || -f "${WEBMIN}" || -f "${SENTORA}" || -f "${HOCVPS}" ]]; then
        printf "${RED}%s${NC}\n" "${OTHER_CP_EXISTS}"
        printf "${RED}%s${NC}\n" "${CANCEL_INSTALL}"
        exit
    fi

    if [[ -f "${VPSSIM}" || -f "${WORDOPS}" || -f "${EEV3}" || -d "${EEV4}" || -d "${VESTA}" || -d "${CWP}" || -d "${KUSANAGI}"  ]]; then
        printf "${RED}%s${NC}\n" "${OTHER_CP_EXISTS}"
        printf "${RED}%s${NC}\n" "${CANCEL_INSTALL}"
        exit
    fi

    if [[ -f "/etc/hostvn.lock" ]]; then
        printf "${RED}%s${NC}\n" "${HOSTVN_EXISTS}"
        printf "${RED}%s${NC}\n" "${CANCEL_INSTALL}"
        exit
    fi
}

check_before_install(){
    echo ""
    check_root
    check_os
    check_low_ram
    check_control_panel
}


#########################
#Dowload primary Script #
#########################
dowload_script(){
    curl -sO ${SCRIPT_LINK}/hostvn.sh && chmod +x hostvn.sh && sh hostvn.sh
}

_run(){
    welcome
    remove_old_ervice
    install_requirement
    check_before_install
    dowload_script
}

_run