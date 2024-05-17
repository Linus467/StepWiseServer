#!/bin/bash

# Variables
REPO_URL="https://github.com/Linus467/StepWiseServer.git"  # HTTPS URL of your private repo
REPO_DIR="/home/ec2-user/stepWiseServer/stepWiseServer"
VENV_DIR="$REPO_DIR/venv"
GUNICORN_SERVICE="/etc/systemd/system/flaskapp.service"
NGINX_CONF="/etc/nginx/conf.d/flaskapp.conf"

# Fetch the latest code from the repository
if [ ! -d "$REPO_DIR" ]; then
  git clone $REPO_URL $REPO_DIR
else
  cd $REPO_DIR && git pull origin main
fi

# Set up or refresh the virtual environment
python3 -m venv $VENV_DIR
source $VENV_DIR/bin/activate

# Update and install Python dependencies
pip install --upgrade pip
pip install -r $REPO_DIR/requirements.txt

# Ensure Gunicorn is set up to start on reboot and start it
sudo systemctl enable flaskapp
sudo systemctl restart flaskapp

# Check if Nginx configuration exists, if not create it
if [ ! -f "$NGINX_CONF" ]; then
    sudo tee $NGINX_CONF > /dev/null <<EOL
server {
    listen 80;
    server_name your_domain_or_ip;  # Replace with your domain or IP

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    error_log /var/log/nginx/flaskapp_error.log;
    access_log /var/log/nginx/flaskapp_access.log;
}
EOL
fi

# Restart Nginx to apply any changes
sudo systemctl restart nginx
sudo systemctl enable nginx

# Print status of services to check everything is running smoothly
echo "Checking the status of Gunicorn and Nginx..."
sudo systemctl status flaskapp --no-pager
sudo systemctl status nginx --no-pager