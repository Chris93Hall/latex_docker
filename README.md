# Latex Docker

A LaTeX toolchain (TeX Live) packaged in a Docker image.

TeX Live is installed with the official net installer, following
https://www.tug.org/texlive/acquire-netinstall.html

## Build

```sh
./docker_build.sh
```

The full TeX Live scheme is installed by default. For a much smaller image,
pass a different scheme:

```sh
./docker_build.sh --build-arg TEXLIVE_SCHEME=scheme-basic
```

## Run

```sh
./docker_run.sh                 # interactive shell
./docker_run.sh latexmk -pdf paper.tex   # run a command directly
```

`/home` is mounted into the container and commands run as the calling user, so
output files keep your ownership.

## Notes

The installer is downloaded fresh on every build and TeX Live is installed into
an unversioned path (`/opt/texlive`), so the image builds and runs correctly
regardless of the current year / TeX Live release.
