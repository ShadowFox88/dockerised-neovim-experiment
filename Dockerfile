FROM debian:bookworm-slim AS base
ENV DEBIAN_FRONTEND=noninteractive

RUN ["apt-get", "update"]
RUN ["apt-get", "dist-upgrade", "-y"]
RUN ["apt-get", "install", "-y", "gcc", "cmake", "ninja-build", "gettext", "unzip", "curl", "git"]

FROM base AS neovim
WORKDIR /tmp

RUN ["git", "clone", "--branch=stable", "--depth=1", "https://github.com/neovim/neovim"]

WORKDIR /tmp/neovim
ENV CMAKE_BUILD_TYPE=Release
ENV CCACHE_DISABLE=true

RUN ["make"]
RUN ["make", "install"]

FROM neovim AS final
WORKDIR /workspace

RUN ["apt-get", "clean"]
RUN ["apt-get", "autoremove", "-y"]

