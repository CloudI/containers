# CloudI Alpine Docker Example

This image includes all the integration tests and all the programming language
integration enabled, but without additional programming languages installed
(other than C/C++ and Erlang).  To add programming languages use:

    docker exec -it cloudi_alpine /bin/sh
    apk add --no-cache go
    apk add --no-cache ghc
    apk add --no-cache openjdk11
    apk add --no-cache nodejs
    apk add --no-cache ocaml
    apk add --no-cache perl
    apk add --no-cache php
    apk add --no-cache python3
    apk add --no-cache ruby

The image is **379 MB** on `x86_64`.
If you install all the programming languages,
the container will become **1.97 GB (2.34 GB with image)** on `x86_64`.

## USAGE

To build and run the image, use:

    docker build -t cloudi_alpine .
    docker run -d -it -p 6464:6464 --name cloudi_alpine cloudi_alpine

The CloudI dashboard is then accessible at
[http://localhost:6464/cloudi/](http://localhost:6464/cloudi/).

If you need to use the Erlang shell while CloudI is running,
remember to detach with a CTRL+P,CRTL+Q key sequence:

    docker container attach cloudi_alpine

