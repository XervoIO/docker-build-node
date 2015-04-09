FROM onmodulus/image-build-base:0.0.1

ADD . /opt/modulus
RUN /opt/modulus/bootstrap.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
