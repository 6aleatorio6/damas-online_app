#!/bin/bash

# SCRIPT DE INSTAÇÂO DO EMULADOR PARA UBUNTU
# ANDROID SUICIDIO NÂO FUNCIONA BEM EM CONTAINER

# ENV 
API_LEVEL=33
DEVICE_ID=25 #Pixel 5
ANDROID_HOME="${HOME}/Android/Sdk"


if [ -f /etc/debian_version ]; then
    PACKAGE_MANAGER="apt-get"

    JAVA_PACKAGE="openjdk-17-jdk"
    JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
elif [ -f /etc/redhat-release ]; then
    PACKAGE_MANAGER="dnf"

    JAVA_PACKAGE="java-17-openjdk-devel"
    JAVA_HOME="/usr/lib/jvm/jre-17-openjdk"
else
    echo "Sistema não suportado!"
    exit 1
fi

sudo $PACKAGE_MANAGER update
sudo $PACKAGE_MANAGER install -y $JAVA_PACKAGE

check_and_set_variable(){
    local var_name=$1
    local var_value=$2
    
    # Lista de arquivos de shell para verificar
    local shellrc_files=("$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile")  # Adicione mais arquivos, se necessário

    # Itera sobre os arquivos de shell
    for shellrc_file in "${shellrc_files[@]}"; do
        # Verifica se o arquivo existe
        if [ -f "$shellrc_file" ]; then
            # Adiciona ou atualiza a variável de ambiente no arquivo de configuração do shell
            if ! grep -q "^export $var_name=" "$shellrc_file"; then
                echo "export $var_name=\"$var_value\"" >> "$shellrc_file"
            else
                sed -i "s|^export $var_name=.*|export $var_name=\"$var_value\"|" "$shellrc_file"
            fi
        fi
    done

    export "$var_name"="$var_value"

}


check_and_set_variable "ANDROID_HOME" $ANDROID_HOME
check_and_set_variable "JAVA_HOME" $JAVA_HOME
check_and_set_variable "PATH" "$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

# ANDROID SDK
PATH_CMDLINE="${ANDROID_HOME}/cmdline-tools" 
PATH_TOOLS_ZIP="${ANDROID_HOME}/tools.zip" 

mkdir -p $PATH_CMDLINE
wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip  -O $PATH_TOOLS_ZIP
unzip -q $PATH_TOOLS_ZIP -d $PATH_CMDLINE  
mv "${PATH_CMDLINE}/cmdline-tools" "${PATH_CMDLINE}/latest" 
rm $PATH_TOOLS_ZIP



# instalando o sdk
echo Y | sdkmanager --licenses  > /dev/null 
echo Y | sdkmanager --verbose --no_https "emulator" \
    "system-images;android-${API_LEVEL};google_apis;x86_64" "platforms;android-${API_LEVEL}" "platform-tools"


echo no | avdmanager create avd -n AndroidPaia -k "system-images;android-${API_LEVEL};google_apis;x86_64" -d $DEVICE_ID --force

# Configurando o teclado
CONFIG_FILE="$HOME/.android/avd/AndroidPaia.avd/config.ini"
if grep -q "hw.keyboard" "$CONFIG_FILE"; then
    sed -i 's/^hw.keyboard=.*/hw.keyboard=yes/' "$CONFIG_FILE"
else
    echo "hw.keyboard=yes" >> "$CONFIG_FILE"
fi

npm install

echo "AS VARIÁVEIS DE AMBIENTE FORAM CONFIGURADAS E O EMULADOR FOI INSTALADO! REINICIE O TERMINAL PARA APLICAR AS ALTERAÇÕES."