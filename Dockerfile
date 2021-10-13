FROM fedora:34

# Install PHP dependencies
RUN yum install -y \
    php \
    php-cli \
    curl \
    php-mbstring \
    php-common \
    zip

# Include composer and install guzzle
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN mkdir /opt/vendor && \
    cd /opt && \
    composer require guzzlehttp/guzzle

# Makes sure environment variables, such as (LAMBDA_RUNTIME_DIR, LAMBDA_TASK_ROOT) can be accessed
RUN sed -i 's/variables_order = "GPCS"/variables_order = "EGPCS"/g' /etc/php.ini

# Prepare runtime files
COPY runtime/ /var/runtime
RUN chmod 0755 /var/runtime/bootstrap

# Add function
COPY src/ /var/task
WORKDIR /var/task

ENV LAMBDA_RUNTIME_DIR /var/runtime
ENV LAMBDA_TASK_ROOT /var/task

ENTRYPOINT [ '/var/runtime/bootstrap' ]
CMD [ 'handler.process' ]
