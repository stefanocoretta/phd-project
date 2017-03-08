#!/bin/bash

a=49
for i in *.wav; do
  new=$(printf "%03d.wav" "$a")
  mv -- "$i" "$new"
  let a=a+1
done
