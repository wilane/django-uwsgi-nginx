# Copyright 2013 Thatcher Peskens
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from debian:latest

MAINTAINER Ousmane Wilane <wilane@gmail.com>

run apt-get update
run apt-get install -y build-essential git
run apt-get install -y python python-dev python-setuptools
run apt-get install -y nginx supervisor
run apt-get install -y libfreetype6-dev libwebp-dev  zlib-bin zlib1g-dev libjpeg8-dev libffi-dev
run easy_install pip

# install uwsgi now because it takes a little while
run pip install uwsgi

# install nginx
run apt-get install -y python-software-properties
run apt-get update
run apt-get install -y sqlite3

# install our code
add . /home/docker/code/

# setup all the configfiles
run echo "daemon off;" >> /etc/nginx/nginx.conf
run rm /etc/nginx/sites-enabled/default
run ln -s /home/docker/code/nginx-app.conf /etc/nginx/sites-enabled/
run ln -s /home/docker/code/supervisor-app.conf /etc/supervisor/conf.d/

# install django, normally you would remove this step because your project would already
# be installed in the code/app/ directory
# run django-admin.py startproject website /home/docker/code/app/

# run pip install
run pip install -r /home/docker/code/app/requirements.txt

# Instead of the below let's grab a template. The comment above still hold
run django-admin.py startproject --template https://github.com/xenith/django-base-template/zipball/master --extension py,md,rst myproject /home/docker/code/app/src/

run cp /home/docker/code/app/src/myproject/settings/local-dist.py /home/docker/code/app/src/myproject/settings/local.py

# Without this uwsgi will throw a funny error unrelated SO:20963856
run echo "DEBUG_TOOLBAR_PATCH_SETTINGS = False" >> /home/docker/code/app/src/myproject/settings/local.py

expose 80
cmd ["supervisord", "-n"]