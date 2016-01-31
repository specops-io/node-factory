#!/bin/bash
SUDO="$(which sudo | grep -v 'not found')"
PIP2="${SUDO} $(which pip2)"

$PIP2 install ansible
