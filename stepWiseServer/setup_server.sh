#!/bin/bash

# Variables
REPO_URL="https://github.com/Linus467/StepWiseServer.git"  # HTTPS URL of your private repo
REPO_DIR="/home/ec2-user/stepWiseServer/stepWiseServer"
VENV_DIR="$REPO_DIR/venv"
GUNICORN_SERVICE="/etc/systemd/system/flaskapp.service"
APACHE_CONF="/etc/httpd/conf/httpd.conf"

# Update and install necessary packages
sudo yum update -y
sudo yum install -y git python3 python3-pip httpd

# Clone the private repository using HTTPS
if [ ! -d "$REPO_DIR" ]; then
  git clone $REPO_URL $REPO_DIR
else
  cd $REPO_DIR && git pull origin main
fi

# Set up a virtual environment
python3 -m venv $VENV_DIR
source $VENV_DIR/bin/activate

# Install Python dependencies
pip install --upgrade pip
pip install -r $REPO_DIR/requirements.txt

# Create Gunicorn systemd service file
sudo tee $GUNICORN_SERVICE > /dev/null <<EOL
[Unit]
Description=Gunicorn instance to serve Flask application
After=network.target

[Service]
User=ec2-user
Group=nginx
WorkingDirectory=$REPO_DIR
Environment="PATH=$VENV_DIR/bin"
ExecStart=$VENV_DIR/bin/gunicorn --workers 3 --bind 127.0.0.1:8000 wsgi:app

[Install]
WantedBy=multi-user.target
EOL

# Enable and start Gunicorn service
sudo systemctl daemon-reload
sudo systemctl start flaskapp
sudo systemctl enable flaskapp

# Configure Apache
sudo tee $APACHE_CONF > /dev/null <<EOL
ServerRoot "/etc/httpd"
Listen 80

Include conf.modules.d/*.conf

User apache
Group apache

ServerAdmin root@localhost

<Directory />
    AllowOverride none
    Require all denied
</Directory>

DocumentRoot "/var/www/html"

<Directory "/var/www">
    AllowOverride None
    Require all granted
</Directory>

<Directory "/var/www/html">
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>

<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>

<Files ".ht*">
    Require all denied
</Files>

ErrorLog "logs/error_log"
LogLevel warn

<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b" common
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    CustomLog "logs/access_log" common
</IfModule>

<IfModule alias_module>
    ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"
</IfModule>

<Directory "/var/www/cgi-bin">
    AllowOverride None
    Options None
    Require all granted
</Directory>

<IfModule mime_module>
    TypesConfig /etc/mime.types
    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz
    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml
</IfModule>

AddDefaultCharset UTF-8

<IfModule mime_magic_module>
    MIMEMagicFile conf/magic
</IfModule>

EnableSendfile on

IncludeOptional conf.d/*.conf

<VirtualHost *:80>
    ServerName your_domain_or_ip

    WSGIDaemonProcess flaskapp python-home=/home/ec2-user/stepWiseServer/stepWiseServer/venv python-path=/home/ec2-user/stepWiseServer/stepWiseServer
    WSGIScriptAlias / /home/ec2-user/stepWiseServer/stepWiseServer/wsgi.py

    <Directory /home/ec2-user/stepWiseServer/stepWiseServer>
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL

# Restart Apache to apply changes
sudo systemctl restart httpd
sudo systemctl enable httpd

# Print status of services
sudo systemctl status flaskapp
sudo systemctl status httpd