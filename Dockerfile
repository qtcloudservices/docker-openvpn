# Original credit: https://github.com/jpetazzo/dockvpn &
# https://github.com/kylemanna/docker-openvpn

FROM ubuntu:trusty

MAINTAINER Jussi Nummelin <jussi.nummelin@digia.com>

RUN apt-get update && \
    apt-get install -y openvpn iptables git-core netmask && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Update checkout to use tags when v3.0 is finally released
RUN git clone --depth 1 --branch v3.0.0-rc2 https://github.com/OpenVPN/easy-rsa.git /usr/local/share/easy-rsa && \
    ln -s /usr/local/share/easy-rsa/easyrsa3/easyrsa /usr/local/bin

# Needed by scripts
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/local/share/easy-rsa/easyrsa3
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars

VOLUME ["/etc/openvpn"]

# Internally uses port 443, remap using docker
EXPOSE 443/tcp

WORKDIR /etc/openvpn

CMD ["start_vpn.sh"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*
