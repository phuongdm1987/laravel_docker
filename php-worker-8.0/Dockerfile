#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

FROM backend-php-fpm-8.0

# Change current user to www
USER root

RUN apt-get --allow-releaseinfo-change update \
 && apt-get install -y --no-install-recommends \
    supervisor
RUN mkdir /var/log/queue 2> /dev/null

COPY supervisord.conf /etc/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisord.conf"]

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

WORKDIR /etc/supervisor/conf.d/
