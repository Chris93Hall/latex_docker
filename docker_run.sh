#!/bin/bash

docker run --rm -it \
    --user=$(id -u) \
    --volume=/home:/home \
    latex:latest /bin/bash


