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

# FIXME: Build from django instead or one of the bases above: buildpack-deps/
# OR Use the official Django from this repo
# docker run -it --rm --user "$(id -u):$(id -g)" -v "$PWD":/usr/src/ \
#                              -w /usr/src/ \
#                              django-admin.py startproject --template https://github.com/xenith/django-base-template/zipball/master \
#                              --extension py,md,rst myproject /usr/src/app/src/

from django

MAINTAINER Ousmane Wilane <wilane@gmail.com>

# run apt-get update && apt-get install -y build-essential git  python python-dev \
#                        python-setuptools  nginx supervisor libfreetype6-dev \
#                        libwebp-dev   zlib1g-dev  libjpeg-dev libffi-dev \
#                        python-software-properties sqlite3 python-pip

run apt-get update && apt-get install -y nginx supervisor libfreetype6-dev git libwebp-dev zlib1g-dev  libjpeg-dev libffi-dev

# install our code
add . /usr/src/app

# setup all the configfiles
run pip install uwsgi

# Instead of the below let's grab a template. The comment above still hold
run pip install --no-cache-dir -r /usr/src/app/requirements.txt && pip install setuptools && \
    django-admin.py startproject --template https://github.com/xenith/django-base-template/zipball/master --extension py,md,rst myproject /usr/src/app/src/ \
    && cp /usr/src/app/src/myproject/settings/local-dist.py /usr/src/app/src/myproject/settings/local.py && \
    echo "DEBUG_TOOLBAR_PATCH_SETTINGS = False" >> /usr/src/app/src/myproject/settings/local.py

WORKDIR /usr/src/app/src
EXPOSE 8000
#CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
CMD ["uwsgi", "--ini",  "/usr/src/app/uwsgi.ini", "--chdir", "/usr/src/app/src"]