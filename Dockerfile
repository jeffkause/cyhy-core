FROM python:2
MAINTAINER Mark Feldhousen <mark.feldhousen@hq.dhs.gov>
ENV CYHY_HOME="/home/cyhy" \
    CYHY_ETC="/etc/cyhy" \
    CYHY_CORE_SRC="/usr/src/cyhy-core" \
    PYTHONIOENCODING="utf8"

RUN groupadd --system cyhy && useradd --system --gid cyhy cyhy

RUN mkdir ${CYHY_HOME}
RUN chown cyhy:cyhy ${CYHY_HOME}
VOLUME ${CYHY_ETC} ${CYHY_HOME}

# Install MongoDB shell 3.2 from official repository
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
RUN echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.2 main" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
RUN apt-get update
RUN apt-get install -y mongodb-org-shell

WORKDIR ${CYHY_CORE_SRC}

COPY . ${CYHY_CORE_SRC}
RUN pip install --no-cache-dir .[dev]
RUN var/geoipupdate.sh
RUN ln -snf ${CYHY_CORE_SRC}/var/getenv /usr/local/bin
RUN ln -snf ${CYHY_CORE_SRC}/var/getopsenv /usr/local/bin

USER cyhy
WORKDIR ${CYHY_HOME}
CMD ["getenv"]
