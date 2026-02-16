# inspiration: https://github.com/alexwlchan/tex-dockerfile

FROM ubuntu:22.04

COPY texlive.profile /texlive.profile
COPY fonts /usr/local/share/fonts/my_fonts

RUN \
  apt-get update && \
  apt-get install -y \
    curl \
    perl-modules \
    libfontconfig1 \
    fontconfig && \
  curl -LO "https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz" && \
  tar -xzf install-tl-unx.tar.gz && \
  export TEXLIVE_INSTALLER=$(find . -maxdepth 1 -regex ".*install-tl-[0-9]+" -type d) && \
  export YEAR=$(echo $TEXLIVE_INSTALLER | awk '{ print substr($0, 14, 4) }') && \
  mv "${TEXLIVE_INSTALLER}" /install-tl && \
  sed -i "s/{{YEAR}}/${YEAR}/" /texlive.profile && \
  mkdir -p /usr/local/texlive/${YEAR} && \
  ln -s /usr/local/texlive/${YEAR} /usr/local/texlive/latest && \
  fc-cache

WORKDIR /install-tl
RUN ./install-tl --profile=/texlive.profile

ENV PATH=/usr/local/texlive/latest/bin/x86_64-linux:$PATH

VOLUME ["/data"]
WORKDIR /data