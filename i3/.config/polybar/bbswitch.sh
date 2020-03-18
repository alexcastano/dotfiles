#!/bin/sh

if grep -q ON /proc/acpi/bbswitch; then
  echo "%{F#bd2c40}󰈈%{F-}"
else
  echo "%{F#555}󰈈%{F-}"
fi
