#!/bin/bash
egrep '^<seg' | sed -e 's/<[^>]*>//g'
