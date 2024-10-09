FROM quay.io/fedora/fedora-bootc:40

COPY /etc/dnf /etc/dnf

RUN dnf install \
    cage \
    dosbox \
    xorg-x11-server-Xwayland \
    && dnf clean all \
    && rm -rf /var/cache/yum

COPY /etc/ /etc/
COPY /usr/ /usr/
COPY /var/ /var/

RUN ln -s /usr/lib/systemd/system/cage@.service /usr/lib/systemd/system/graphical.target.wants/cage@tty7.service
