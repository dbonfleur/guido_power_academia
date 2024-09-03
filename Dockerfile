FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    git \
    curl \
    xz-utils \
    libglu1-mesa \
    cmake \
    ninja-build \
    clang \
    build-essential \
    libgtk-3-dev \
    libblkid-dev \
    liblzma-dev \
    gdb \
    lcov \
    pkg-config \
    libssl-dev \
    && apt-get clean

RUN wget https://storage.googleapis.com/dart-archive/channels/stable/release/3.5.1/sdk/dartsdk-linux-x64-release.zip -O /tmp/dartsdk.zip \
    && unzip /tmp/dartsdk.zip -d /usr/lib \
    && rm /tmp/dartsdk.zip

ENV PATH="/usr/lib/dart-sdk/bin:$PATH"

RUN dart --version

RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /usr/local/flutter

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:$PATH"

WORKDIR /app

COPY . .

RUN flutter pub get

EXPOSE 8080

CMD ["flutter", "run"]
