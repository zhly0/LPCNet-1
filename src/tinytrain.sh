#!/bin/bash -x
# tinytrain.sh
#
# train using a tiny database, synthesise a few samples from within
# training database.  Used to perform quick sanity checks with a few hrs training

SRC=all_speech
DATE=190410

synth() {
  ./src/dump_data --test --c2pitch --mag --mask 111111111111000000 ~/Downloads/$1.sw $1.f32
  ./src/test_lpcnet --mag $1.f32 "$2".s16
}

train() {
  ./src/dump_data --train --c2pitch -z 0 --mag --mask 111111111111000000 -n 1E6 ~/Downloads/$SRC.sw $SRC.f32 $SRC.pcm
  ../src/train_lpcnet.py $SRC.f32 $SRC.pcm lpcnet_$DATE
  ../src/dump_lpcnet.py lpcnet_"$DATE"_10.h5
  cp nnet_data.c src
  make test_lpcnet
}

#train
synth c01_01  "$DATE"_f
synth mk61_01 "$DATE"_m