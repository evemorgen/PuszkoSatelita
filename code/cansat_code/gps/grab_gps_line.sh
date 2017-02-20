#!/bin/bash

cat /dev/ttyAMA0 | grep -m 1 "GPGGA"

