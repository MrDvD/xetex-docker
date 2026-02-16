# =============================================================================
# Custom XeLaTeX Environment
# Base: Ubuntu 22.04 | TeX Live: Latest (Dynamic)
# Inspiration: https://github.com/alexwlchan/tex-dockerfile
# =============================================================================

FROM ubuntu:22.04

COPY texlive.profile /texlive.profile

RUN \
  apt-get update && \
  apt-get install -y \
    curl \
    perl-modules \
    libfontconfig1 && \
  curl -LO "https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz" && \
  tar -xzf install-tl-unx.tar.gz && \
  export TEXLIVE_INSTALLER=$(find . -maxdepth 1 -regex ".*install-tl-[0-9]+" -type d) && \
  export YEAR=$(echo $TEXLIVE_INSTALLER | awk '{ print substr($0, 14, 4) }') && \
  sed -i "s/{{YEAR}}/${YEAR}/" /texlive.profile && \
  mkdir -p /usr/local/texlive/${YEAR} && \
  ln -s /usr/local/texlive/${YEAR} /usr/local/texlive/latest && \
  "${TEXLIVE_INSTALLER}/install-tl" --profile=/texlive.profile && \
  rm -rf \
    /install-tl-unx.tar.gz \
    "${TEXLIVE_INSTALLER}" \
    /texlive.profile \
    /var/lib/apt/lists/* && \
  apt-get purge -y --auto-remove curl && \
  apt-get autoremove -y && \
  apt-get clean

ENV PATH=/usr/local/texlive/latest/bin/x86_64-linux:$PATH

RUN \
  tlmgr init-usertree && \
  tlmgr install xetex fontspec geometry

VOLUME ["/data"]
WORKDIR /data