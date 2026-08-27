# syntax=docker/dockerfile:1

# -----------------------------
# Source build (clone + compile)
# -----------------------------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS source-build

ARG OPENSIM_GIT_URL=git://opensimulator.org/git/opensim
ARG OPENSIM_GIT_REF=master

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        libgdiplus \
        libc6-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN git clone --depth 1 --branch "${OPENSIM_GIT_REF}" "${OPENSIM_GIT_URL}" opensim

WORKDIR /src/opensim

RUN ./runprebuild.sh && \
    dotnet build --configuration Release OpenSim.sln


# -----------------------------
# Common runtime base
# -----------------------------
FROM mcr.microsoft.com/dotnet/runtime:8.0 AS runtime-base

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        unzip \
        tar \
        gettext-base \
        mariadb-client \
        libgdiplus \
        libc6-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/opensim

COPY docker/ ./docker/
RUN chmod +x ./docker/*.sh


# -----------------------------
# Runtime from source build
# -----------------------------
FROM runtime-base AS source-runtime

COPY --from=source-build /src/opensim/bin ./bin

RUN mkdir -p \
    /opt/opensim/bin/Regions \
    /opt/opensim/bin/config-include \
    /opt/opensim/bin/assetcache \
    /opt/opensim/bin/maptiles \
    /opt/opensim/bin/crashes \
    /config \
    /logs 

EXPOSE 9000/tcp 9000/udp
ENTRYPOINT ["/opt/opensim/docker/entrypoint.sh"]


# -----------------------------
# Runtime from official binary release
# -----------------------------
FROM runtime-base AS release-runtime

ARG OPENSIM_RELEASE_REF=r58b7b39
ARG OPENSIM_RELEASE_URL=https://github.com/opensim/opensim/releases/download/${OPENSIM_RELEASE_REF}/LastDotNetBuild.zip

RUN set -eux; \
    mkdir -p /tmp/pkg /tmp/extract /opt/opensim/bin; \
    curl -fsSL "${OPENSIM_RELEASE_URL}" -o /tmp/pkg/opensim.pkg; \
    case "${OPENSIM_RELEASE_URL}" in \
        *.zip) unzip -q /tmp/pkg/opensim.pkg -d /tmp/extract ;; \
        *.tar.gz|*.tgz) tar -xzf /tmp/pkg/opensim.pkg -C /tmp/extract ;; \
        *) echo "Unsupported OPENSIM_RELEASE_URL archive type" >&2; exit 1 ;; \
    esac; \
    dll_path="$(find /tmp/extract -type f -name OpenSim.dll | head -n 1)"; \
    if [ -z "${dll_path}" ]; then echo "OpenSim.dll not found in archive" >&2; exit 1; fi; \
    bin_dir="$(dirname "${dll_path}")"; \
    cp -a "${bin_dir}/." /opt/opensim/bin/; \
    rm -rf /tmp/pkg /tmp/extract

RUN mkdir -p \
    /opt/opensim/bin/Regions \
    /opt/opensim/bin/config-include \
    /opt/opensim/bin/assetcache \
    /opt/opensim/bin/maptiles \
    /opt/opensim/bin/crashes \
    /config \
    /logs 

EXPOSE 9000/tcp 9000/udp
ENTRYPOINT ["/opt/opensim/docker/entrypoint.sh"]