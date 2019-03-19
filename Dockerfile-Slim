FROM alpine:3.7
#Old Image without Go language Do not use!#
ENV PYTHONBUFFERED 1
ENV PYTHONFAULTHANDLER 1
ENV ANSIBLE_VERSION=2.6.4
ENV TERRAFORM_VERSION=0.11.10

RUN apk add --no-cache --virtual .build-deps \
        gcc \
        libc-dev \
        linux-headers \
        build-base \
        libffi-dev && \
    apk add --no-cache \
        bash \
        openssh \
        wget \
        curl \
        unzip \
        openssl openssl-dev \
        libxml2 libxml2-dev libxslt-dev \
        python python-dev py-pip && \
    pip install --upgrade \
        pip \
        cffi \
        setuptools \
        ansible==${ANSIBLE_VERSION} \
        pandevice \
        xmltodict \
        pan-python \
        paramiko \
        ipaddress \
        azure-cli \
        awscli \
        requests-toolbelt \
        requests \
        jsonschema && \
        ansible-galaxy install PaloAltoNetworks.paloaltonetworks && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform.zip && \
    unzip terraform.zip -d /bin && \
    rm -rf terraform.zip && \
    mkdir /usr/local/fca && \
    apk del .build-deps

ENTRYPOINT ["/bin/bash"]
