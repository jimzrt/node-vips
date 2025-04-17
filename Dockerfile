# Dockerfile for node-sharp-base

FROM node:22-alpine

# Install required build tools and libraries
RUN apk add --no-cache \
    build-base \
    autoconf \
    automake \
    libtool \
    pkgconfig \
    git \
    wget \
    nasm \
    bash \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libimagequant-dev \
    tiff-dev \
    zlib-dev \
    cairo-dev \
    glib-dev \
    gobject-introspection-dev \
    libxml2-dev \
    libexif-dev \
    ffmpeg-dev \
    libheif-dev \
    libde265-dev \
    x265-dev \
    cmake \
    ninja \
    g++ \
    make \
    meson \
    # Additional format support
    fftw-dev \
    orc-dev \
    lcms2-dev \
    pango-dev \
    fontconfig-dev \
    openjpeg-dev \
    poppler-dev \
    librsvg-dev \
    openexr-dev \
    cfitsio-dev \
    giflib-dev \
    imagemagick-dev \
    libarchive-dev

# Build latest libvips from source with libheif support
ENV VIPS_VERSION=8.16.1

RUN wget https://github.com/libvips/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.xz && \
    tar xf vips-${VIPS_VERSION}.tar.xz && \
    cd vips-${VIPS_VERSION} && \
    meson setup build \
      --buildtype=release \
      -Dgtk_doc=false \
      -Dheif=enabled \
      -Dfftw=enabled \
      -Dorc=enabled \
      -Dlcms=enabled \
      -Dpango=enabled \
      -Dfontconfig=enabled \
      -Dopenjpeg=enabled \
      -Dpoppler=enabled \
      -Drsvg=enabled \
      -Dopenexr=enabled \
      -Dcfitsio=enabled \
      -Dgif=enabled \
      -Dmagick=enabled \
      -Dlibarchive=enabled \
      -Dexamples=false && \
    meson compile -C build && \
    meson install -C build && \
    cd .. && \
    rm -rf vips-${VIPS_VERSION}*

# Link libraries (Alpine uses /etc/ld-musl-*.path files instead of ld.so.conf)
RUN mkdir -p /etc/ld-musl-$(uname -m).path.d && \
    echo "/usr/lib" > /etc/ld-musl-$(uname -m).path.d/libvips.conf && \
    echo "/usr/local/lib" >> /etc/ld-musl-$(uname -m).path.d/libvips.conf

# Working directory
WORKDIR /app

CMD ["node"]
