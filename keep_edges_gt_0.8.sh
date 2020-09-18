#!/bin/bash
score=$1

awk '$3>=0.8' ${score} > ${score}".GT_0.8"
