# !/usr/bin/bash

# f(x) = x*x
function f {
	echo `bc <<< "scale=10; ($1*$1)"`
}

function uniform {
	#echo `awk 'BEGIN { srand(); printf("%.8f\n", rand()) }'`
	awk -v "seed=$[(RANDOM & 32767) + 32768 * (RANDOM & 32767)]" \
       'BEGIN { srand(seed); printf("%.8f\n", rand()) }'
}

A=$1
B=$2
MIN=$3
MAX=$4
RUNS=$5

POS=0
NEG=0
DIFF_X=`bc <<< "scale=10; ($B - $A)"`
DIFF_Y=`bc <<< "scale=10; ($MAX - $MIN)"`

POS=0
NEG=0

for i in $(seq 1 $RUNS); do
	RAND_X=`uniform`
	RAND_X=`bc <<< "scale=10; ($RAND_X * $DIFF_X + $A)"`
	RAND_Y=`uniform`
	RAND_Y=`bc <<< "scale=10; ($RAND_Y * $DIFF_Y + $MIN)"`
	VAL_Y=`f $RAND_X`
	if [ `echo $VAL_Y'>'$RAND_Y | bc -l` == "1" ]
		then
			(( ++POS ))
		else
			(( ++NEG ))
	fi
done

#echo $POS
#echo $NEG

echo `bc <<< "scale=10; ($POS/$RUNS)"`