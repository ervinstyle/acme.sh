#!/usr/bin/bash

#Author: ervinstyle

WEBENLET_URL=https://domreg.webenlet.hu/api.php
# WEBENLET_USER=your webenlet username
# WEBENLET_PASS=password md5 format

dns_webenlet_add() {
  fulldomain=$1
  txtvalue=$2
  ttl=86400

  WEBENLET_DOMAIN= _get_root_domain $fulldomain

  WEBENLET_USER="${WEBENLET_USER:-$(_readaccountconf_mutable WEBENLET_USER)}"
  WEBENLET_PASS="${WEBENLET_PASS:-$(_readaccountconf_mutable WEBENLET_PASS)}"

  if [ -z "$WEBENLET_USER" ] || [ -z "$WEBENLET_PASS" ]; then
    WEBENLET_USER=""
    WEBENLET_PASS=""
    _err "You have not yet entered webenlet api username, password and domain."
    _err "Please create your key and try again."
    return 1
  fi
  
  #save the credentials to the account conf file.
  _saveaccountconf_mutable WEBENLET_USER "$WEBENLET_USER"
  _saveaccountconf_mutable WEBENLET_PASS "$WEBENLET_PASS"

  _info "Adding TXT record to ${fulldomain}"

  data="user=${WEBENLET_USER}&password=${WEBENLET_PASS}&op=adddnsrecord&domain=${WEBENLET_DOMAIN}&host=${fulldomain}&record=${txtvalue}&prio=&type=TXT&ttl=${ttl}"

  response="$(_post "$data" "$WEBENLET_URL" "" POST)"

  if _contains "${response}" 'OK'; then
    return 0
  fi

  _err "Could not create resource record, check logs"
  _err "${response}"
  return 1

  _debug rootdomain "$WEBENLET_DOMAIN"
  _debug fulldomain "$fulldomain"
  _debug txtvalue "$txtvalue"
  _err "Not implemented!"
  return 1
}

#Usage: fulldomain txtvalue
#Remove the txt record after validation.
dns_webenlet_rm() {
  fulldomain=$1
  txtvalue=$2
  ttl=86400

  WEBENLET_USER="${WEBENLET_USER:-$(_readaccountconf_mutable WEBENLET_USER)}"
  WEBENLET_PASS="${WEBENLET_PASS:-$(_readaccountconf_mutable WEBENLET_PASS)}"

if [ -z "$WEBENLET_USER" ] || [ -z "$WEBENLET_PASS" ]; then
    WEBENLET_USER=""
    WEBENLET_PASS=""
    WEBENLET_DOMAIN= _get_root_domain $fulldomain
    _err "You have not yet entered webenlet api username, password and domain."
    _err "Please create your key and try again."
    return 1
  fi
  
  #save the credentials to the account conf file.
  _saveaccountconf_mutable WEBENLET_USER "$WEBENLET_USER"
  _saveaccountconf_mutable WEBENLET_PASS "$WEBENLET_PASS"

  data="user=${WEBENLET_USER}&password=${WEBENLET_PASS}&op=deldnsrecord&domain=${WEBENLET_DOMAIN}&host=${fulldomain}&record=${txtvalue}&prio=&type=TXT&ttl=${ttl}"

  response="$(_post "$data" "$WEBENLET_URL" "" POST)"

  if _contains "${response}" 'OK'; then
    return 0
  fi

  _err "Could not create resource record, check logs"
  _err "${response}"
  return 1

  _info "Remove TXT record to ${fulldomain}"
  _debug fulldomain "$fulldomain"
  _debug txtvalue "$txtvalue"
}

####################  Private functions below ##################################

_get_root_domain() {

  maindomain=$(echo "$1" | awk -F'.' '{print $(NF-1)"."$NF}')

  return $maindomain
}