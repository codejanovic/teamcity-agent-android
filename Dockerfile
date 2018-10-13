FROM jetbrains/teamcity-minimal-agent:2018.1.1-linux

ENV DEBIAN_FRONTEND noninteractive
#26.1.1
ENV ANDROID_SDK_TOOLS_VERSION 4333796 
ENV ANDROID_SDK_TOOLS_URL="https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_VERSION}.zip"
ENV ANDROID_BUILD_TOOLS_VERSION 28.0.3
ENV ANDROID_SDK_PLATFORM_VERSION 28
ENV ANDROID_HOME="/usr/local/android-sdk"
ENV GRADLE_HOME=/usr/bin/gradle

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 4.10.2

ARG GRADLE_DOWNLOAD_SHA256=b49c6da1b2cb67a0caf6c7480630b51c70a11ca2016ff2f555eaeda863143a29

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
    && cd "$ANDROID_HOME" \
    && curl -o sdk.zip $ANDROID_SDK_TOOLS_URL \
    && unzip sdk.zip \
    && rm sdk.zip \
    && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses
# Install Android Build Tool and Libraries
RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_SDK_PLATFORM_VERSION}" \
    "platform-tools"
# Install Build Essentials
RUN  apt-get update && apt-get install build-essential file apt-utils git wget unzip -y 

# Install Gradle
RUN set -o errexit -o nounset \
	&& echo "Downloading Gradle" \
	&& wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
	\
	&& echo "Checking download hash" \
	&& echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum --check - \
	\
	&& echo "Installing Gradle" \
	&& unzip gradle.zip \
	&& rm gradle.zip \
	&& mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
	&& ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
	\
	&& echo "Adding gradle user and group" \
	&& mkdir -p /home/gradle/.gradle \
	\
	&& echo "Symlinking root Gradle cache to gradle Gradle cache" \
	&& ln -s /home/gradle/.gradle /root/.gradle
