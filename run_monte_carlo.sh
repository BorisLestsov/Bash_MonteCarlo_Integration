# !/usr/bin/sh

A=0
B=1
MAX=0
MIN=1
RUNS=1000
TRUE_RES=0.33333

N_WORKERS=1

#(wget -O - pi.dk/3 || curl pi.dk/3/ || fetch -o - http://pi.dk/3) | bash
#sudo cp bin/* /usr/bin

function lead_zero {
	echo $1 | sed -e 's/^\./0./' -e 's/^-\./-0./'
}

DIFF=`bc <<< "scale=10; ($B - $A)/$N_WORKERS"`

touch .tmp
truncate -s 0 .tmp

for i in `seq $N_WORKERS`; do
	L=`bc <<< "$A + ($i-1) * $DIFF"`
	U=`bc <<< "$A + $i * $DIFF"`
	echo -e "$L $U $MAX $MIN $RUNS" >> .tmp
done

if [ -z "$1" ] 
	then
		RES=`parallel --no-notice -a .tmp --colsep ' ' ./main {}`
	else
		scp main ubuntu@ec2-34-207-99-68.compute-1.amazonaws.com:~/
		RES=`parallel --no-notice -S $1 -a .tmp --colsep ' ' ./main {}`
fi

RES=`echo $RES | tr ' ' '\n' | awk '{s+=$1} END {print s}'`
RES=`bc <<< "scale=10; $RES/$N_WORKERS"`
RES=`lead_zero $RES`
echo "Result      :" $RES 
echo "True result :" $TRUE_RES 
ERR=$(lead_zero `bc <<< "$RES-$TRUE_RES" | sed "s/^-//"`)
echo "Error       :" $ERR

rm .tmp
