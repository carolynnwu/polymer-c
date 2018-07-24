# Batch Script
# July 23, 2018

# Set variables for each run
VERBOSE=0                   # Only print summary file for batch runs. If printing verbose, comment out concatenation step.

NFIL=1                      # Number of filaments simulated

BASESEPDISTANCE=0           # Separation distance of filament bases

FORCE=0                     # Force on ends of filaments in z-direction

DIMERFORCE=0                # Force pulling ends of multiple filaments together

# Loop through single variable
for ((FORCE=0;FORCE<=10;FORCE=($FORCE+1)))
do
    # Run executable
    ./metropolis.out parameters.txt SinglePolymerWithForce.$FORCE.txt $VERBOSE $NFIL $BASESEPDISTANCE $FORCE $DIMERFORCE &

done

# wait for all background processes to finish before concatenating files
wait

# print line when all processes have finished
echo "Done waiting for processes to finish."

# loop through all files, concatenate them into one file
for ((FORCE=0;FORCE<=10;FORCE=($FORCE+1)))
do

# concatenate inidividual run files into single file
cat SinglePolymerWithForce.$FORCE.txt >> SinglePolymerWithForce.txt

done
