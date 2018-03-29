#!/bin/bash

perl Makefile.PL && \
make && \
make test && \
sudo make install && \
make clean && \
echo Restart mbot service
sudo systemctl stop mbot && \
sudo systemctl start mbot
systemctl is-active --quiet mbot.service && echo done
