# acme.sh dnsapi extend
This is acme.sh dns certificate extended providers

## Webenlet API
```
export WEBENLET_USER=username
export WEBENLET_PASS=md5pass

acme.sh --issue --dns dns_webenlet -d example.com --keylength 2048

```

## acw API
```
export ACW_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

acme.sh --issue --dns dns_acw -d example.com --keylength 2048

```