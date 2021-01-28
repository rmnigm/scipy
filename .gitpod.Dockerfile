ARG BASE_CONTAINER=trallard/scipy:scipy-dev.3
FROM ${BASE_CONTAINER}

# -----------------------------------------------------------------------------
# ---- OS dependencies ----
# hadolint ignore=DL3008
RUN apt-get update && \ 
    apt-get install -yq --no-install-recommends \
    zip \
    unzip \
    bash-completion \
    build-essential \
    htop \
    jq \
    less \
    locales \
    man-db \
    sudo \
    time \
    multitail \
    lsof \
    ssl-cert \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

RUN add-apt-repository -y ppa:git-core/ppa \
    && apt-get install -yq git \
    && rm -rf /var/lib/apt/lists/* 

# -----------------------------------------------------------------------------
# ---- Gitpod user ----

ENV LANG=en_US.UTF-8 \
    HOME=/home/gitpod \
    GP_USER=gitpod \
    GP_GROUP=gitpod \
    CONDA_DIR=/opt/conda

# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 33333 -G sudo -md "${HOME}" -s /bin/bash -p ${GP_GROUP} ${GP_USER} && \
    # passwordless sudo for users in the 'sudo' group
    sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers && \
    # ensuring we can use conda develop
    chown ${GP_USER}:${GP_GROUP} ${CONDA_DIR} && \
    # vanity custom bash prompt
    echo "PS1='\[\e]0;\u \w\a\]\[\033[01;36m\]\u\[\033[m\] > \[\033[38;5;141m\]\w\[\033[m\] \\$ '"  >> ~/.bashrc

WORKDIR $HOME

USER gitpod
