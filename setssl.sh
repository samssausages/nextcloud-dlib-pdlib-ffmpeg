# setssl.sh
# this file is to install your own ssl certificate and enable it in nextcloud.  Use in combination with my dockerfile.
# USAGE: setssl.sh <domain> <email>

echo 'SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
SSLProtocol All -SSLv2 -SSLv3
SSLHonorCipherOrder On
Header always set Strict-Transport-Security "max-age=63072000; includeSubdomains"
Header always set X-Frame-Options DENY
Header always set X-Content-Type-Options nosniff
SSLCompression off
SSLSessionTickets Off' > /etc/apache2/conf-available/ssl-params.conf
echo "<IfModule mod_ssl.c>
        <VirtualHost _default_:443>
                ServerAdmin $2
                ServerName $1
" > /etc/apache2/sites-available/default-ssl.conf
echo '
                DocumentRoot /var/www/html

                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined

                SSLEngine on

                SSLCertificateFile    /etc/ssl/nextcloud/cert.pem
                SSLCertificateKeyFile /etc/ssl/nextcloud/key.pem

                <FilesMatch "\.(cgi|shtml|phtml|php)$">
                                SSLOptions +StdEnvVars
                </FilesMatch>
                <Directory /usr/lib/cgi-bin>
                                SSLOptions +StdEnvVars
                </Directory>
        </VirtualHost>
</IfModule>' >> /etc/apache2/sites-available/default-ssl.conf
a2enmod ssl >/dev/null
a2ensite default-ssl >/dev/null
a2enconf ssl-params >/dev/null
