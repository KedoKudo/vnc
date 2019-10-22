FROM kedokudo/caqtdm:latest

LABEL version="0.0.2" \
      maintainer="kedokudo <chenzhang8722@gmail.com>" \
      lastupdate="2019-10-22"
USER  root
EXPOSE 5901

RUN apt-get  update  -y   && \
    apt-get  upgrade -y   && \
    apt-get  install -y      \
        vnc4server \
        xfce4 xfce4-goodies  \
    && \
    rm -rf /var/lib/apt/lists/*

RUN wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.8.0.x86_64.tar.gz | tar xz --strip 1 -C /
RUN mkdir ~/.vnc
RUN echo "123456" | vncpasswd -f >> ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini
ENTRYPOINT ["/bin/tini", "--"]

CMD ["/usr/bin/vncserver","-geometry", "2880x1800", "-fg"]

# --- DEV ---
# docker build -t kedokudo/vnc:latest .
# docker run -dit --rm -p 5901:5901 kedokudo/vnc:latest
