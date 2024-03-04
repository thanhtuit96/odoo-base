FROM  python:3.10.7-slim-bullseye

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]
ENV LANG C.UTF-8
ENV ODOO_VERSION 16.0
ENV ODOO_RC /odoo/odoo.conf
ARG ODOO_RELEASE=20221222

COPY ./docker/odoo/install_packages.sh ./tmp
RUN bash /tmp/install_packages.sh

#venv 
RUN python -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install setuptools wheel 
ENV PATH="/opt/venv/bin:$PATH"

# install odoo
COPY ./docker/odoo/odoo_${ODOO_VERSION}.${ODOO_RELEASE}.zip ./tmp/
RUN pip install /tmp/odoo_${ODOO_VERSION}.${ODOO_RELEASE}.zip

COPY ./docker/odoo/requirements.txt ./tmp
RUN pip install -r /tmp/requirements.txt 

COPY ./docker/odoo/addons.zip ./tmp/odoo/addons.zip
COPY ./docker/odoo /tmp/odoo
#odoo & 3rd party addons
RUN mkdir -p /odoo/data \
    && unzip /tmp/odoo/addons.zip -d /odoo/ \
    && mv /tmp/odoo/scripts/* /odoo/ 

VOLUME ["/odoo/data"]

#custom addons
RUN mkdir -p /odoo/local-src
COPY ./src/ /odoo/local-src
COPY ./migration /odoo/migration
# RUN pip install -r /odoo/techcoop/requirements.txt
VOLUME ["/odoo/local-src"]

#clean up
RUN apt-get clean \
    && pip cache purge \
    && rm -r /tmp/*

#run
EXPOSE 8069 8071 8072
ENTRYPOINT ["/odoo/entrypoint.py"]
CMD ["odoo"]

