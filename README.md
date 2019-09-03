# DetNetSpawc
#This repositiry hold the files used in the paper "Deep MIMO Detection" presented in spawc2017
#Further information regarding the algorithm can be founf at
https://arxiv.org/abs/1706.01151

All files require the TensorFlow library in order to run.
All files were tested using Tensorflow version 1.0.1. Using different versions may require certain modifications.
Parameters are not the same used in the paper, so results might be slightly different.

#file list:
DetNet.py-The basic DetNet architecture. Training and testing over i.i.d gaussian channels
FullyConnected.py - The Fully connected architecture. Training and testing over a fixed channel
Top06_30_20.csv -  An example of a channel that can be used in the FullyConnected.py 
