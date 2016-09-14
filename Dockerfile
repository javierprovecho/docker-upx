FROM alpine

ENV LDFLAGS=-static
ENV UPX_LZMADIR /lzma920
ENV UPX_UCLDIR=/ucl-1.03

RUN apk --update --no-cache add build-base zlib-dev xz-dev curl perl \
    && curl -L http://www.oberhumer.com/opensource/ucl/download/ucl-1.03.tar.gz|tar -xzv \
    && cd ucl-1.03 \
    && ./configure \
    && make \
    && make install \
    && cd / \
    && curl -LO http://www.7-zip.org/a/lzma920.tar.bz2 \
    && bunzip2 lzma920.tar.bz2 \
    && mkdir /lzma920 \
    && tar -xvf lzma920.tar -C /lzma920 \
    && curl -LO https://github.com/upx/upx/releases/download/v3.91/upx-3.91-src.tar.bz2 \
    && bunzip2 upx-3.91-src.tar.bz2  \
    && tar -xvf upx-3.91-src.tar \
    && cd upx-3.91-src \
    && sed -i "/addLoad/ s/NULL/(char*)NULL/" src/packer.cpp \
    && make all \
    && /upx-3.91-src/src/upx.out --best --ultra-brute -o /bin/upx /upx-3.91-src/src/upx.out \
    && apk del build-base zlib-dev xz-dev curl perl \
    && cd / \
    && rm -rf *.tar ucl-1.03 lzma920 upx-3.91-src

ENTRYPOINT ["upx"]