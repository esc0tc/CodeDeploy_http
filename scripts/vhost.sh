#!/bin/bash
export DN=smbtest

if [ -d /etc/apache2/sites-available/$DN.conf ]
        then echo "Error: site already configure using the name $DN"; exit
fi

echo "Creating Apache Site Configuration File"
echo "<IfModule mod_ssl.c>
        <VirtualHost _default_:443>
                ServerName jnprbuild.com
                ServerAlias $DN.jnprbuild.com
                DocumentRoot /var/www/$DN
                LogLevel warn
                ErrorLog /var/log/apache2/$DN/error.log
                CustomLog /var/log/apache2/$DN/access.log combined
                SSLEngine on
                SSLCertificateFile /etc/letsencrypt/live/jnprbuild.com-0001/cert.pem
                SSLCertificateKeyFile /etc/letsencrypt/live/jnprbuild.com-0001/privkey.pem
                <Directory /var/www/$DN>
                        AllowOverride All
                </Directory>
        </VirtualHost>
</IfModule>" > /etc/apache2/sites-available/$DN.conf

echo "Creating Document Root"
mkdir /var/www/$DN

echo "Creating Log File Directory"
mkdir /var/log/apache2/$DN

echo "Enabling Site & Reloading Apache (edit /etc/apache2/sites-available/$DN for more options)"
a2ensite $DN.conf
service apache2 restart
