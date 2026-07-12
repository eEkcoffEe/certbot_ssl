#!/bin/bash

DOMAIN="sub-portal.duckdns.org"

apt update
apt install certbot -y

certbot certonly \
--standalone \
-d $DOMAIN

systemctl enable --now certbot.timer

certbot renew --dry-run
