
FROM hshar/webapp
ADD . /var/www/html
CMD ["apachectl", "-D", "FOREGROUND"]
