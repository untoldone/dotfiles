#!/usr/bin/env bash

set -e

case $OS_TYPE in
  debian)
    if [[ -f /usr/lib/android-sdk/platform-tools/adb ]]; then
      echo "Android tools already installed"
      exit 0
    fi

    sudo apt-get install -y ant maven gradle android-sdk

    # Add Android environment variables to zshrc if not already present
    if ! grep -q "ANDROID_HOME" ~/.zshrc 2>/dev/null; then
      echo 'export ANDROID_HOME=/usr/lib/android-sdk' >> ~/.zshrc
    fi

    ;;
  darwin)
    if [[ -f /usr/local/Caskroom/android-sdk/4333796/tools/android ]]; then
      echo "Android tools already installed"
      exit 0
    fi

    brew install ant maven gradle
    brew install --cask android-sdk android-ndk

    # Add Android environment variables to zshrc if not already present
    if ! grep -q "ANDROID_HOME" ~/.zshrc 2>/dev/null; then
      cat >> ~/.zshrc << 'ANDROID_EOF'
export ANT_HOME=/usr/local/opt/ant
export MAVEN_HOME=/usr/local/opt/maven
export GRADLE_HOME=/usr/local/opt/gradle
export ANDROID_HOME=/usr/local/opt/android-sdk
export ANDROID_NDK_HOME=/usr/local/opt/android-ndk
export PATH=$ANT_HOME/bin:$PATH
export PATH=$MAVEN_HOME/bin:$PATH
export PATH=$GRADLE_HOME/bin:$PATH
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
ANDROID_EOF
    fi
    #export PATH=$ANDROID_HOME/build-tools/19.1.0:$PATH

    ;;
  *)
    echo "Unsupported OS $UNAME"
    exit 1
esac

# android update sdk --no-ui