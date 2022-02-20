# syntax = docker/dockerfile:1

ARG MOHIST_VERSION=304
ARG DOWNLOADER_VERSION=0.0.5
ARG CLOSER_VERSION=1.1
ARG RCON_CLI_VERSION=0.10.1

FROM eclipse-temurin:8-jdk as mods-downloader

COPY mods.txt .

ARG DOWNLOADER_VERSION

RUN curl -L "https://github.com/anatawa12/mod-downloader/releases/download/v${DOWNLOADER_VERSION}/mod-downloader-${DOWNLOADER_VERSION}.jar" \
    > mod-downloader.jar \
  && java -jar mod-downloader.jar \
    --server \
    --config mods.txt \
    --dest /mods

FROM eclipse-temurin:8-jdk as library-downloader

WORKDIR /server

COPY --from=mods-downloader /mods /server/mods
COPY server.properties /server/server.properties

ARG MOHIST_VERSION
ARG CLOSER_VERSION

RUN curl -L "https://mohistmc.com/builds/1.12.2/mohist-1.12.2-$MOHIST_VERSION-server.jar" \
    > mohist.jar \
  && curl -L "https://github.com/anatawa12/minecraft-server-auto-closer/releases/download/$CLOSER_VERSION/minecraft-server-auto-closer-$CLOSER_VERSION.jar" \
    > mods/auto-closer.jar \
  && echo "eula=true" > eula.txt \
  && timeout 600s java -Xmx2G -jar mohist.jar \
  && rm libraries/net/minecraft/1.12.2/minecraft_server.1.12.2.jar \
  && rm libraries/net/minecraft/launchwrapper/1.12/launchwrapper-1.12.jar \
  && rm libraries/lzma/lzma/0.0.1/lzma-0.0.1.jar \
  && rm libraries/org/scala-lang/plugins/scala-continuations-plugin_2.11.1/1.0.2/scala-continuations-plugin_2.11.1-1.0.2.jar \
  && rm libraries/java3d/vecmath/1.5.2/vecmath-1.5.2.jar \
  && rm mods/auto-closer.jar
# remove libraries by mojang (disallowed by terms):
#   net/minecraft/1.12.2/minecraft_server.1.12.2.jar        minecraft server
#   net/minecraft/launchwrapper/1.12/launchwrapper-1.12.jar launchwrapper
# remove unknown libraries:
#   lzma/lzma/0.0.1/lzma-0.0.1.jar
#       this may be traditonal versions of LZMA SDK (https://sourceforge.net/projects/p7zip/files/java_lzma/0.90/)
#   org/scala-lang/plugins/scala-continuations-plugin_2.11.1/1.0.2/scala-continuations-plugin_2.11.1-1.0.2.jar
#       I can't get library with same hash
#   java3d/vecmath/1.5.2/vecmath-1.5.2.jar
#       java3d vecmath (I can't get original so I remove)

FROM alpine as bundler

WORKDIR /server

COPY --from=library-downloader /server/banned-ips.json     /server/banned-ips.json
COPY --from=library-downloader /server/banned-players.json /server/banned-players.json
#COPY --from=library-downloader /server/bukkit.yml          /server/bukkit.yml
#COPY --from=library-downloader /server/cache               /server/cache
#COPY --from=library-downloader /server/commands.yml        /server/commands.yml
COPY --from=library-downloader /server/config              /server/config
COPY --from=library-downloader /server/eula.txt            /server/eula.txt
#COPY --from=library-downloader /server/help.yml            /server/help.yml
COPY --from=library-downloader /server/libraries           /server/libraries
#COPY --from=library-downloader /server/logs                /server/logs
COPY --from=mods-downloader    /mods                       /server/mods
COPY --from=library-downloader /server/mohist-config       /server/mohist-config
COPY --from=library-downloader /server/mohist.jar          /server/mohist.jar
COPY --from=library-downloader /server/ops.json            /server/ops.json
#COPY --from=library-downloader /server/paper.yml           /server/paper.yml
#COPY --from=library-downloader /server/permissions.yml     /server/permissions.yml
COPY --from=library-downloader /server/plugins             /server/plugins
COPY --from=library-downloader /server/server.properties   /server/server.properties
COPY --from=library-downloader /server/snapshots-server    /server/snapshots-server
#COPY --from=library-downloader /server/spigot.yml          /server/spigot.yml
#COPY --from=library-downloader /server/usercache.json      /server/usercache.json
COPY --from=library-downloader /server/whitelist.json      /server/whitelist.json

FROM eclipse-temurin:8-jdk

WORKDIR /server

ARG RCON_CLI_VERSION

COPY --from=bundler /server /server

# server starter

COPY run.sh /server/run.sh
RUN mkdir /rcon-cli \
  && curl -L "https://github.com/gorcon/rcon-cli/releases/download/v${RCON_CLI_VERSION}/rcon-${RCON_CLI_VERSION}-amd64_linux.tar.gz" \
  | tar -zx -O "rcon-${RCON_CLI_VERSION}-amd64_linux/rcon" \
  > /rcon-cli/rcon-cli \
    && chmod +x /rcon-cli/rcon-cli

# create directory for save
RUN ln -s /save/world /server/world \
    && ln -s /save/logs /server/logs \
    && ln -s /save/crash-reports /server/crash-reports

CMD ["/server/run.sh"]
