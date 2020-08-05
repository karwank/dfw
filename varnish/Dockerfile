FROM varnish

COPY default.vcl /etc/varnish/

ENTRYPOINT []
CMD ["sh", "-c", "varnishd -f /etc/varnish/default.vcl -a http=:80,HTTP -a proxy=:8443,PROXY -s malloc,100M && /usr/bin/varnishncsa -a -w /var/log/varnish/varnishncsa.log"]
