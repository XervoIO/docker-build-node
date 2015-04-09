FROM onmodulus/image-build-base:0.0.1

ADD . /opt/modulus
RUN /opt/modulus/bootstrap.sh

# Set correct environment variables.
ENV PATH=/opt/modulus/bin:$PATH

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
