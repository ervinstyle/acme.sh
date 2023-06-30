#!/usr/bin/bash

#Author: ervinstyle

ACW_URL=https://vh-72145.serverxpro.com:8083/api/acme.php
# ACW_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

dns_acw_add() {
  fulldomain=$1
  txtvalue=$2

  ACW_KEY="${ACW_KEY:-$(_readaccountconf_mutable ACW_KEY)}"

  if [ -z "$ACW_KEY" ]; then
    ACW_KEY=""
    _err "You have not yet entered acw api key."
    _err "Please create your key and try again."
    return 1
  fi
  
  #save the credentials to the account conf file.
  _saveaccountconf_mutable ACW_KEY "$ACW_KEY"
  
  _info "Adding TXT record to ${fulldomain}"

  data="key=${ACW_KEY}&host=${fulldomain}&txt=${txtvalue}"

  response="$(_post "$data" "$ACW_URL" "" POST)"

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
dns_acw_rm() {
  fulldomain=$1
  txtvalue=$2
  ttl=86400

  ACW_KEY="${ACW_KEY:-$(_readaccountconf_mutable ACW_KEY)}"

  if [ -z "$ACW_KEY" ]; then
    ACW_KEY=""
    _err "You have not yet entered acw api key."
    _err "Please create your key and try again."
    return 1
  fi
  
  #save the credentials to the account conf file.
  _saveaccountconf_mutable ACW_KEY "$ACW_KEY"

  data="key=${ACW_KEY}&host=${fulldomain}&txt=${txtvalue}&delete=1"

  response="$(_post "$data" "$ACW_URL" "" POST)"

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
