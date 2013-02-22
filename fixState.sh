if [ $# -eq 1 ] 
then
./grabRatings.pl $1
./grabFeedback.pl $1
./parseDoctors.pl $1
./parseRatings.pl $1
./parseFeedback.pl $1
else 
echo "Usage: fixState.sh StateFolder"
fi
