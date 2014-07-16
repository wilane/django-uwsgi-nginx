# Django, uWSGI and Nginx in a container

This Dockerfile allows you to build a Docker container with a fairly standard
and speedy setup for Django with uWSGI and Nginx.

uWSGI from a number of benchmarks has shown to be the fastest server
for python applications and allows lots of flexibility.

Nginx has become the standard for serving up web applications and has the
additional benefit that it can talk to uWSGI using the uWSGI protocol, further
elinimating overhead.

Most of this setup comes from the excellent tutorial on
https://uwsgi.readthedocs.org/en/latest/tutorials/Django_and_nginx.html

Feel free to clone this and modify it to your liking. And feel free to
contribute patches.

### Build and run
* docker build -t webapp .
* docker run -d webapp

### How to insert your application

In /app/src currently a django project is created with startproject using the
template from https://github.com/xenith/django-base-template that features "set
of basic templates built from HTML5Boilerplate 4.1.0 and Twitter Bootstrap 3.0.2
(located in the base app, with css and javascript loaded from CloudFlare CDN by
default)." You will probably want to replace the content of /app/src with the
root of your django project if you already have one.

uWSGI chdirs to /app/src so in uwsgi.ini you will need to make sure the python
path to the wsgi.py file is relative to that.  Also note that the template
contains a conf directory with nginx, supervisor and uwsgi configs