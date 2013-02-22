if [ $# -eq 2 ]
then
mkdir $1
mkdir "$1/data"
mkdir "$1/ratings"
mkdir "$1/ratings/feedback"
./grabRatingsSearch.pl $2 $1
./grabRatings.pl $1
./grabFeedback.pl $1
./parseDoctors.pl $1
./parseRatings.pl $1
./parseFeedback.pl $1
else
echo "Usage: rate.sh StateInitials StateNumber\n"
fi