# shell-download
 Automatic shell download script
 
 A simple script to download a bash shell script and optionally symlink to `$HOME"/.local/bin`

## Download

For main branch
```bash
mkdir $HOME/Downloads/scripts
```
```bash
cd $HOME/Downloads/scripts
```
```bash
wget https://github.com/tmiland/shell-download/raw/main/shell-download.sh
```

Set execute permission:
```bash
chmod +x shell-download.sh
```

Symlink
```bash
file=shell-download.sh
```
```bash
full_file_path=$(realpath ./"$file")
```
```bash
full_file_name=${file%.*}
```
```bash
sudo ln -s "$full_file_path" "$HOME"/.local/bin/"$full_file_name"
```

Now you can run `shell-download <URLtoShellScript>`

- This will make installing shell scripts a lot easier.
- You can download any other file and the script should detect if it's a shell script or not.
- It will only set execution permissions (`chmod +x`) on shell scripts.
  - You will be asked with [Y/N] wether or not you want to symlink the script.
    - If symlinked, name of the script will be used (without the `.sh` part).

## Dependencies

`wget`,`curl` or `fetch`
- will be installed if not found: `wget`

## Donations
<a href="https://www.buymeacoffee.com/tmiland" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
- [PayPal me](https://paypal.me/milanddata)
- [BTC] : 33mjmoPxqfXnWNsvy8gvMZrrcG3gEa3YDM

## Web Hosting

Sign up for web hosting using this link, and receive $100 in credit over 60 days.

[DigitalOcean](https://m.do.co/c/f1f2b475fca0)

#### Disclaimer 

*** ***Use at own risk*** ***

### License

[![MIT License Image](https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/MIT_logo.svg/220px-MIT_logo.svg.png)](https://github.com/tmiland/shell-download/blob/master/LICENSE)

[MIT License](https://github.com/tmiland/shell-download/blob/master/LICENSE)