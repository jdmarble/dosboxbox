FROM quay.io/fedora/fedora-bootc:41

COPY /etc/dnf /etc/dnf

RUN dnf install \
     cage \
     xorg-x11-server-Xwayland \
     dnf5-plugins \
 && dnf copr enable rob72/86Box \
 && dnf install 86Box \
 && rm -rf /var/{cache,log} /var/lib/{dnf,rhsm}

RUN mkdir -p /usr/local/share/86Box/roms \
 && curl -L https://github.com/86Box/roms/archive/refs/tags/v4.2.1.tar.gz \
  | tar --extract --gunzip --strip-components=1 --directory=/usr/local/share/86Box/roms

COPY /etc/ /etc/
COPY /usr/ /usr/

RUN ln -s /usr/lib/systemd/system/cage@.service /usr/lib/systemd/system/graphical.target.wants/cage@tty1.service
