FROM openjdk:17-slim-buster

ARG NB_USER=leslie
ARG NB_UID=1000
ENV NB_USER ${NB_USER}
ENV NB_UID ${NB_UID}
RUN adduser --uid ${NB_UID} ${NB_USER}

COPY *.ipynb /home/${NB_USER}/
RUN chown -R ${NB_USER} /home/${NB_USER}

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-setuptools
RUN pip3 install --upgrade \
    pip \
    setuptools \
    wheel
RUN pip3 install \
    tlaplus_jupyter \
    jupyter_contrib_nbextensions

RUN python3 -m tlaplus_jupyter.install && \
    jupyter contrib nbextension install --system --symlink && \
    jupyter nbextension enable exercise2/main --system

USER ${NB_USER}
WORKDIR /home/${NB_USER}

CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
