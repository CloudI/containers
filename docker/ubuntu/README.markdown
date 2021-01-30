# CloudI Ubuntu Docker Example 

This image includes all the integration tests and the programming language
integration enabled by default:

* C/C++
* Erlang/Elixir
* Java
* Javascript
* Perl
* PHP
* Python
* Ruby

The image is **1.71 GB** on `x86_64`.  If you need a smaller image, use the
[Alpine Linux](https://github.com/CloudI/containers/tree/master/docker/alpine#readme) default image.

## USAGE

To build and run the image, use:

    docker build -t cloudi_ubuntu .
    docker run -d -it -p 6464:6464 --name cloudi_ubuntu cloudi_ubuntu

The CloudI dashboard is then accessible at
[http://localhost:6464/cloudi/](http://localhost:6464/cloudi/).

If you need to use the Erlang shell while CloudI is running,
remember to detach with a CTRL+P,CRTL+Q key sequence:

    docker container attach cloudi_ubuntu

