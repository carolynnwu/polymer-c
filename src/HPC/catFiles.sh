##############################################
# Concatenate log, output files
# Tar individual files
# 08 02 2019

##############################################
# Set up variables
ITERMIN=-1
ITERMAX=103

I2MAX=64

FOLDERNAME="StiffenRange"
FILENAME="CD3ZetaMembrane0"
LOGFILENAME="o*"

##############################################
##############################################
##############################################
# Make cat folders

# start in code part of folder
if [ ! -d "CatFiles"];
then
    mkdir CatFiles

    cd CatFiles

    mkdir CatLogs

    mkdir MissingFiles

    cd ..
fi

echo "We are here: $PWD"

# end in code part of folder

##############################################
##############################################

# Concatenate log files
for ((ITER=$ITERMIN;ITER<=$ITERMAX;ITER++))
do
    cd $FOLDERNAME.$ITER/logs


    if [ ! -e $FILENAME.$ITER.log];
    then
        for ((I2=1;I2<=$I2MAX;I2++))
        do
                if [ -e $FILENAME.$LOGFILENAME.$I2 ];
                    then
                        echo "/************************/\n\n" >> $FILENAME.$ITER.log
                        echo "$FILENAME.$LOGFILENAME.$I2\n" >> $FILENAME.$ITER.log
                        cat $FILENAME.$LOGFILENAME.$I2 >> $FILENAME.$ITER.log
                else
                        echo "Log file $FILENAME.$LOGFILENAME.$I2 does not exist."
                fi

        done

        cp $FILENAME.$ITER.log ../../CatFiles/CatLogs/

        echo "Finished concatenating log file $ITER."
    fi

    cd ../..
done

# wait for all background processes to finish before concatenating files
wait

echo "Done concatenating log files."

echo "We are here: $PWD"

##############################################
##############################################

# Concatenate output files
for ((ITER=$ITERMIN;ITER<=$ITERMAX;ITER++))
do
    cd $FOLDERNAME.$ITER

    if [ ! -e $FILENAME.$ITER.cat];
    then

        for ((I2=1;I2<=$I2MAX;I2++))
        do
            if [ -e $FILENAME.$ITER.$I2 ];
                then
                    cat $FILENAME$FOLDERNAME.$ITER.$I2 >> $FILENAME.$ITER.cat
            else
                    echo "$FILENAME$FOLDERNAME.$ITER.$I2\n" >> MissingFiles.$ITER
            fi

        done

        if [ $((wc -l $FILENAME.$ITER.cat)) > $I2MAX];
            then
                echo "Too many lines in cat file $FILENAME.$ITER.cat.\n" >> ../CatFiles/CatFiles.err
        fi

        cp $FILENAME.$ITER.cat ../CatFiles/

        cp MissingFiles.$ITER ../CatFiles/MissingFiles/

        echo "Finished concatenating output files $ITER."
    fi

    cd ../

done

echo "Done concatenating output files."

echo "We are here: $PWD"

##############################################
##############################################

# Tar individual output files into single folder

for ((ITER=$ITERMIN;ITER<=$ITERMAX;ITER++))
do

    tar -czvf $FOLDERNAME.$ITER.tar.gz $FOLDERNAME.$ITER/

done

tar -czvf Data_IndividualFiles.tar.gz $FOLDERNAME.*.tar.gz

echo "Finished archiving files."

