FROM redhat/ubi8

RUN yum install -y wget perl

RUN wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar xvzf install-tl-unx.tar.gz
RUN perl install-tl-*/install-tl --no-interaction

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/texlive/2024/bin/x86_64-linux

ENTRYPOINT [""]
