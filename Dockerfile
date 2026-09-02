# syntax=docker/dockerfile:1
FROM redhat/ubi8

# scheme-full matches the previous behaviour; override at build time for a
# smaller image, e.g. --build-arg TEXLIVE_SCHEME=scheme-basic
ARG TEXLIVE_SCHEME=scheme-full

RUN yum install -y wget perl tar gzip \
    && yum clean all \
    && rm -rf /var/cache/yum

# Install TeX Live from the current net installer.
#
# Two things keep this working in any year:
#   * The installer is always downloaded fresh, so it matches the live tlnet
#     repository (a stale installer fails against a newer repo).
#   * TEXDIR is pinned to an unversioned path. Left to its default the
#     installer would use /usr/local/texlive/<year>, which is what made the
#     hard-coded PATH below break when the year rolled over.
RUN set -eux; \
    mkdir -p /tmp/install-tl; \
    wget -qO- https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
        | tar xz -C /tmp/install-tl --strip-components=1; \
    printf '%s\n' \
        "selected_scheme ${TEXLIVE_SCHEME}" \
        "TEXDIR /opt/texlive" \
        "TEXMFLOCAL /opt/texlive/texmf-local" \
        "TEXMFSYSCONFIG /opt/texlive/texmf-config" \
        "TEXMFSYSVAR /opt/texlive/texmf-var" \
        "instopt_adjustpath 0" \
        "tlpdbopt_install_docfiles 0" \
        "tlpdbopt_install_srcfiles 0" \
        > /tmp/texlive.profile; \
    perl /tmp/install-tl/install-tl --no-interaction --profile=/tmp/texlive.profile; \
    rm -rf /tmp/install-tl /tmp/texlive.profile; \
    # The binaries still live in an architecture subdirectory; expose it under
    # a stable name so PATH does not depend on the arch string either.
    ln -s /opt/texlive/bin/* /opt/texlive/bin/current

ENV PATH=/opt/texlive/bin/current:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN tex --version

CMD ["bash"]
