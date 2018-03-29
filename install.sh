#!/bin/bash

perl Makefile.PL && \
make && \
make test TEST_VERBOSE=1 && \
sudo make install && \
make clean && \
echo Restart mbot service
sudo systemctl stop mbot && \
sudo systemctl start mbot
systemctl is-active --quiet mbot.service && echo done
