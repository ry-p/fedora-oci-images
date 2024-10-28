ARG FEDORA_ATOMIC_SPIN=sway-atomic
ARG BASE_IMAGE=quay.io/fedora-ostree-desktops/${FEDORA_ATOMIC_SPIN}
ARG FEDORA_MAJOR_VERSION=39

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION}

ARG FEDORA_ATOMIC_SPIN

COPY files/system/etc /etc
COPY files/system/usr /usr

COPY files/signing/policy.json /usr/etc/containers/policy.json
COPY files/signing/registry-config.yaml /etc/containers/registries.d/ryanpz.yaml
COPY cosign.pub /etc/pki/containers/ryanpz.pub

COPY build.sh packages.json /tmp/ryanpz/

RUN /tmp/ryanpz/build.sh /tmp/ryanpz/packages.json && \
    rpm-ostree cleanup -m && \
    ostree container commit
