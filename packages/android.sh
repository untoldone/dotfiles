#!/usr/bin/env bash

set -e

case $OS_TYPE in
  debian)
    if [[ -f /usr/lib/android-sdk/platform-tools/adb ]]; then
      echo "Android tools already installed"
      exit 0
    fi

    sudo apt-get install -y ant maven gradle android-sdk

    echo export ANDROID_HOME=/usr/lib/android-sdk >> ~/.zshrc

    ;;
  darwin)
    if [[ -f /usr/local/Caskroom/android-sdk/4333796/tools/android ]]; then
      echo "Android tools already installed"
      exit 0
    fi

    brew install ant maven gradle
    brew cask install android-sdk android-ndk

    echo export ANT_HOME=/usr/local/opt/ant >> ~/.zshrc
    echo export MAVEN_HOME=/usr/local/opt/maven >> ~/.zshrc
    echo export GRADLE_HOME=/usr/local/opt/gradle >> ~/.zshrc
    echo export ANDROID_HOME=/usr/local/opt/android-sdk >> ~/.zshrc
    echo export ANDROID_NDK_HOME=/usr/local/opt/android-ndk >> ~/.zshrc

    echo 'export PATH=$ANT_HOME/bin:$PATH' >> ~/.zshrc
    echo 'export PATH=$MAVEN_HOME/bin:$PATH' >> ~/.zshrc
    echo 'export PATH=$GRADLE_HOME/bin:$PATH' >> ~/.zshrc
    echo 'export PATH=$ANDROID_HOME/tools:$PATH' >> ~/.zshrc
    echo 'export PATH=$ANDROID_HOME/platform-tools:$PATH' >> ~/.zshrc
    #export PATH=$ANDROID_HOME/build-tools/19.1.0:$PATH

    ;;
  *)
    echo "Unsupported OS $UNAME"
    exit 1
esac

# android update sdk --no-ui