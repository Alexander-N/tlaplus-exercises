FROM openjdk:17-alpine3.13

ARG NB_USER=leslie
ARG NB_UID=1000
ENV NB_USER ${NB_USER}
ENV NB_UID ${NB_UID}
RUN addgroup ${NB_USER} && adduser -D -G ${NB_USER} -u ${NB_UID} ${NB_USER}
COPY *.ipynb /home/${NB_USER}/
RUN chown -R ${NB_USER} /home/${NB_USER}

RUN apk --no-cache add --update \
    gcc \
    libc-dev \
    zeromq-dev \
    python3-dev \
    py3-pip \
    linux-headers \
    libffi-dev \
    libxslt-dev

RUN pip3 install --upgrade \
    pip \
    wheel \
    tlaplus_jupyter \
    jupyter_contrib_nbextensions
RUN python3 -m tlaplus_jupyter.install && \
    jupyter contrib nbextension install --system --symlink && \
    jupyter nbextension enable exercise2/main --system

USER ${NB_USER}
WORKDIR /home/${NB_USER}

CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
