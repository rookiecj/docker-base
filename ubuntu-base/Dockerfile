FROM ubuntu:16.04
MAINTAINER Changju Lee <rookiecj@gmail.com>

# Configure Apt
ARG DEBIAN_FRONTEND=noninteractive
RUN sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu\//mirror:\/\/mirrors.ubuntu.com\/mirrors.txt/' /etc/apt/sources.list

# Build requirements
ENV BUILD_PACKAGES "software-properties-common"
RUN apt-get update \
 && apt-get install --yes ${BUILD_PACKAGES}


# Why should we need the init process?
# http://phusion.github.io/baseimage-docker/ 
# tini 0.14.0
ENV TINI_VERSION v0.14.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 \
 && gpg --verify /tini.asc
RUN chmod +x /tini
# Command line arguments to docker run <image> will be appended after all elements in an exec form ENTRYPOINT, 
# and will override all elements specified using CMD. This allows arguments to be passed to the entry point, i.e., docker run <image> -d will pass the -d argument to the entry point. 
# You can override the ENTRYPOINT instruction using the docker run --entrypoint flag.
# ENTRYPOINT ["executable", "param1", "param2"] (exec form, preferred)
ENTRYPOINT ["/tini", "--"]

# or use  docker run with --init
# --init    Run an init inside the container that forwards signals and reaps processes

RUN apt-get install --yes rsyslog kmod initramfs-tools sudo
RUN apt-get install --yes locales ntp whois vim 
RUN apt-get install --yes wget curl git

# clean up
RUN echo "${BUILD_PACKAGES}" | xargs apt-get purge --yes \
 && apt-get autoremove --purge --yes \
 && rm -rf /var/lib/apt/lists/*

# locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8   


# Set up the user
ARG UNAME=travis
ARG UID=1000
ARG GID=1000
ARG HOME=/home/${UNAME}
RUN mkdir -p ${HOME} && \
    echo "${UNAME}:x:${UID}:${GID}:${UNAME} User,,,:${HOME}:/bin/bash" >> /etc/passwd && \
    echo "${UNAME}:x:${UID}:" >> /etc/group && \
    mkdir -p /etc/sudoers.d && \
    echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME} && \
    chmod 0440 /etc/sudoers.d/${UNAME} && \
    chown ${UID}:${GID} -R ${HOME} && \
    gpasswd --add ${UNAME} audio && gpasswd --add ${UNAME} video
USER ${UNAME}
ENV HOME=${HOME}


VOLUME /docker
RUN ln -s /docker $HOME/docker
WORKDIR $HOME

#RUN cd ${HOME} && echo export QT_X11_NO_MITSHM=1>>.bashrc
COPY bashrc $HOME/.bashrc
COPY Xmodmap $HOME/.Xmodmap
COPY vimrc $HOME/.vimrc
RUN mkdir -p $HOME/.vim/bundle $HOME/.vim/backup
RUN git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
#RUN vim +PluginInstall +qall

# CMD ["param1","param2"] (as default parameters to ENTRYPOINT)
CMD ["/bin/bash"]

