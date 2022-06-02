#!/usr/bin/env bash


## Author: Tommy Miland (@tmiland) - Copyright (c) 2022


######################################################################
####                     Shell Download.sh                        ####
####               Automatic shell download script                ####
####                   Maintained by @tmiland                     ####
######################################################################


# VERSION='1.0.0'

#------------------------------------------------------------------------------#
#
# MIT License
#
# Copyright (c) 2022 Tommy Miland
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#------------------------------------------------------------------------------#
# Check for wget or curl or fetch
printf "Checking for HTTP client .."
while true; do
  if [ -x "/usr/bin/wget" ]; then
    download="/usr/bin/wget -nv"
    break
  elif [ -x "/usr/bin/curl" ]; then
    download="/usr/bin/curl -f -s -L -O"
    break
  elif [ -x "/usr/bin/fetch" ]; then
    download="/usr/bin/fetch"
    break
  elif [ "$wget_attempted" = 1 ]; then
    printf ".. no HTTP client available. Could not install wget. Cannot continue.\\n"
    exit 1
  fi

  # Made it here without finding a downloader, so try to install one
  wget_attempted=1
  if [ -x /usr/bin/dnf ]; then
    dnf -y install wget
  elif [ -x /usr/bin/yum ]; then
    yum -y install wget
  elif [ -x /usr/bin/apt-get ]; then
    apt-get update >>/dev/null
    apt-get -y -q install wget
  fi
done
if [ -z "$download" ]; then
  echo "Tried to install downloader, but failed. Do you have working network and DNS?"
fi
printf " found %s\\n" "$download"

download() {
  export download_file
  download_file=$(echo "$1" | awk -F/ '{print $NF}')
  $download "$1"
  # shellcheck disable=SC2181
  if [ $? -ne 0 ]; then
    echo "Error: Failed to download $1. Cannot continue. Check your network connection and DNS settings."
    exit 1
  else
    return 0
  fi
}

download "$@" 1>/dev/null 2>&1

# Check if file is a shell script
check_file() {
  # shellcheck disable=SC2005,SC2046
  grep -qxF "$1" "$download_file"
}

if [ -f "$download_file" ]; then
  # Set execution permissions if file is a shell script
  echo "Checking if $download_file is a shell script"
  file_check=$(grep -c "/usr/bin/env bash\|/bin/bash\|/bin/sh" "$download_file")
  if [ "$file_check" -eq 1 ]; then
    echo "Trying to set execution permissions on $download_file"
    chmod +x "$download_file"
    echo "Success"
    echo "Now run you can run ./$download_file"
    echo -e "Do you want to symlink $download_file [Y/N?]"
    read -p "" -n 1 -r
    echo -e "\n"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      full_path_download_file=$(realpath ./"$download_file")
      full_name_download_file=${download_file%.*}
      sudo ln -s "$full_path_download_file" "$HOME"/.local/bin/"$full_name_download_file"
      echo "Now you can run $full_name_download_file"
      exit 1
    fi
    if [[ $REPLY =~ ^[Nn]$ ]]; then
      exit 1
    fi
  else
    echo "Not a shell script..."
    exit 1
  fi
else
  echo "something went wrong... $download_file doesn't exist"
fi

exit
