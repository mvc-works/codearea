
cd `dirname $0`

jade -wP *jade &
coffee -wbc *coffee &

read

pkill -f jade
pkill -f coffee