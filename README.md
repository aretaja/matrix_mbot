# matrix_mbot
Extensible matrix.org bot based on Net::Async::Matrix (Perl)

## Getting Started
Installation on Debian

### Prerequisites
* From CPAN
Net::Async::HTTP
IO::Async::SSL
String::Tagged
Test::Async::HTTP

* From debian repo
```
apt install libhttp-message-perl libio-async-perl libfuture-perl libstruct-dumb-perl liburi-perl libtest-identity-perl libhttp-cookies-perl libtest-refcount-perl libtry-tiny-perl libconfig-general-perl libdatetime-perl libmoose-perl libmodule-pluggable-perl libjson-perl libwww-perl
```

## Installing

### Add system user
```
sudo adduser --system --home /nonexistent --no-create-home --disabled-password --disabled-login mbot
```

### Make log directory
```
sudo mkdir /var/log/mbot
sudo chown mbot:adm /var/log/mbot
sudo chmod 2750 /var/log/mbot
```

### Setup config
```
sudo cp contrib/mbot.conf /usr/local/etc
sudo vim /usr/local/etc/mbot.conf # change for your needs
sudo chown mbot:root /usr/local/etc/mbot.conf
sudo chmod 0600 /usr/local/etc/mbot.conf
```

### Setup service
```
sudo cp contrib/mbot.service /etc/systemd/system
sudo vim /etc/systemd/system/mbot.service # change paths if needed
sudo systemctl enable mbot
```

### Install bot
```
git clone https://github.com/aretaja/matrix_mbot
cd matrix_mbot
```

### Install using script
```
./install.sh
```

### .. or do it step by step manually
```
perl Makefile.PL
make
make test
sudo make install
make clean
sudo systemctl restart mbot

```

## Usage
Ask help from bot
```
Mbot: help
```

## Extending
Plugins are realised using Module::Pluggable. You can extend bot functionality by writing new plugins and installing them into **matrix_mbot/lib/Mbot/Plugins** directory.

## Example chat
To interact with bot one must preffix message with **<bot_displayname>:**
```
(12:05:09) Me: Mbot: ping
(12:05:13) Mbot: P O N G
(14:33:26) Me: Mbot: decide one or two or three
(14:33:28) Mbot: one
```
