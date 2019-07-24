#!/bin/bash
# Batch Script
# July 23, 2018
# Sweep through N values for various formin dimerization states
# Summer 2019
# team real formins: Joanna, Poorvi, Katie, Allard
# Set variables for each run
SWEEPNAME=testNSweepWednesday1

# Loop through single variable
for N in $(seq 1 1 10)
do
    date
    # Run executable
    ./metropolis.out parameters.txt $SWEEPNAME.txt 0 1 $N -1 baseSepDist Force dimerForce
done

