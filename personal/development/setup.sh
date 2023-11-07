#!/bin/bash

ASDF_VERSION=''
BUN_VERSION=''
FLUTTER_VERSION=''
GOLANG_VERSION=''
JAVA_VERSION=''
KOTLIN_VERSION=''
NODEJS_VERSION=''
PYTHON_VERSION=''
RUST_VERSION=''

install_pkgs() {
    sudo apt-get install -y curl \
                            git \
                            clang \
                            cmake \
                            ninja-build \
                            libgtk-3-dev \
                            jq \
                            zip \
                            unzip \
                            pkg-config \
                            liblzma-dev
}

install_softwares() {
    sudo snap install dbeaver-ce \
                      postman \
                      figma-linux \
                      zoom-client\
                      remmina \
                      chromium \
                      thunderbird

    sudo snap install --classic code \
                                intellij-idea-community

    curl -o ~/Downloads/wps-office.deb https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/11708/wps-office_11.1.0.11708.XA_amd64.deb

    sudo apt-get install -y ~/Downloads/wps-office.deb
}

setup_asdf() {
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v$ASDF_VERSION
    echo -e "\n. \"\$HOME/.asdf/asdf.sh\"\n. \"\$HOME/.asdf/completions/asdf.bash\"" >> ~/.bashrc
}

install_bun() {
    asdf plugin bun https://github.com/cometkim/asdf-bun.git
    asdf install bun $BUN_VERSION
    asdf global bun $BUN_VERSION
}

install_flutter() {
    asdf plugin flutter https://github.com/oae/asdf-flutter.git
    asdf install flutter $FLUTTER_VERSION
    asdf global flutter $FLUTTER_VERSION

    flutter config --enable-web \
                   --enable-windows-desktop \
                   --enable-macos-desktop \
                   --enable-linux-desktop \
                   --enable-android \
                   --enable-ios

    echo -e "export CHROME_EXECUTABLE=/snap/bin/chromium\nexport ANDROID_HOME=\$HOME\nexport ANDROID_SDK_ROOT=\$HOME\nexport PATH=\$ANDROID_HOME/cmdline-tools:\$ANDROID_HOME/cmdline-tools/bin:\$ANDROID_HOME/platform-tools:\$ANDROID_HOME/platform-tools/bin:\$ANDROID_SDK_ROOT:\$PATH" >> ~/.bashrc

    curl -o ~/Downloads/commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip
    unzip ~/Downloads/commandlinetools.zip -d ~/

    $ANDROID_HOME/cmdline-tools/bin/sdkmanager --sdk_root=$HOME "platforms;android-30" \
                                                                "platform-tools" \
                                                                "build-tools;30.0.3" \
                                                                "emulator" \
                                                                "system-images;android-30;google_apis_playstore;x86_64"
    
    $ANDROID_HOME/cmdline-tools/bin/sdkmanager --licenses

    flutter config --android-sdk $HOME

    avdmanager create avd -n android-30 \
                          -k "system-images;android-30;google_apis_playstore;x86_64"
}

install_golang() {
    asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
    asdf install golang $GOLANG_VERSION
    asdf global golang $GOLANG_VERSION
}

install_java() {
    asdf plugin add java https://github.com/halcyon/asdf-java.git
    asdf install java $JAVA_VERSION
    asdf global java $JAVA_VERSION
}

install_kotlin() {
    asdf plugin add kotlin https://github.com/asdf-community/asdf-kotlin.git
    asdf install kotlin $KOTLIN_VERSION
    asdf global kotlin $KOTLIN_VERSION
}

install_nodejs() {
    asdf plugin nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf install nodejs $NODEJS_VERSION
    asdf global nodejs $NODEJS_VERSION
}

install_python() {
    asdf plugin python https://github.com/danhper/asdf-python.git
    asdf install python $PYTHON_VERSION
    asdf global python $PYTHON_VERSION
}

install_rust() {
    asdf plugin rust https://github.com/code-lever/asdf-rust.git
    asdf install rust $RUST_VERSION
    asdf global rust $RUST_VERSION
}

# Main script starts here
