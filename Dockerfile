ARG PYTHON_VERSION

FROM python:${PYTHON_VERSION}-alpine

ARG JDK_VERSION
ARG HOME_DIR

#PREPARING OS
RUN apk add --no-cache bash
RUN apk update --no-cache
RUN apk upgrade --no-cache

#CHANGING DEFAULT SHELL
SHELL ["/bin/bash", "-c"]

#INSTALLING COMMONS
RUN apk add --no-cache --no-interactive zip
RUN apk add --no-cache --no-interactive unzip
RUN apk add --no-cache --no-interactive curl
RUN apk add --no-cache --no-interactive openjdk${JDK_VERSION}
RUN apk add --no-cache --no-interactive maven
RUN apk add --no-cache --no-interactive make
RUN apk add --no-cache --no-interactive ca-certificates
RUN apk add --no-cache --no-interactive git
RUN apk add --no-cache --no-interactive g++
RUN apk add --no-cache --no-interactive openssl
RUN apk add --no-cache --no-interactive libstdc++
RUN apk add --no-cache --no-interactive npm
RUN apk add --no-cache --no-interactive openssl
RUN apk add --no-cache --no-interactive gcompat
RUN apk add --no-cache --no-interactive neovim
RUN apk add --no-cache --no-interactive rust
RUN apk add --no-cache --no-interactive cargo
RUN cargo install ripgrep fd-find
RUN apk add --no-cache --no-interactive fontconfig

#INSTALLING LUNARVIM
RUN bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) -y
RUN echo "alias lvim=${HOME_DIR}/.local/bin/lvim" >> ${HOME_DIR}/.bashrc

#INSTALLING LUNARVIM JAVA IDE CONFIGS
RUN rm -r ${HOME_DIR}/.config/lvim
RUN git clone https://github.com/Israiloff/lvim-java-ide.git ${HOME_DIR}/.config/lvim

#INSTALLING JDTLS
RUN git clone https://github.com/eclipse-jdtls/eclipse.jdt.ls.git ${HOME_DIR}/projects/nvim/jdtls
RUN cd ${HOME_DIR}/projects/nvim/jdtls && ./mvnw clean verify -DskipTests=true

#INSTALLING MICROSOFT JAVA DEBUG FOR VS
RUN git clone https://github.com/microsoft/java-debug ${HOME_DIR}/projects/nvim/java-debug
RUN cd ${HOME_DIR}/projects/nvim/java-debug && ./mvnw clean install

#INSTALLING MICROSOFT JAVA TEST FOR VS
RUN git clone https://github.com/microsoft/vscode-java-test.git ${HOME_DIR}/projects/nvim/java-test
RUN cd ${HOME_DIR}/projects/nvim/java-test && npm install && npm run build-plugin

#DOWNLOADING LOMBOK ANNOTATION PROCESSOR
RUN curl https://projectlombok.org/downloads/lombok.jar -o /${HOME_DIR}/projects/nvim/lombok.jar

RUN curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/RobotoMono.zip
RUN mkdir /.fonts
RUN unzip RobotoMono.zip -d /.fonts
RUN fc-cache -fv
RUN rm RobotoMono.zip

ENTRYPOINT ["/bin/bash"]
