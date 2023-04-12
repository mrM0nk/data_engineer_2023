#!/bin/bash


start=$(date +%s.%N)

counter=1
while [ $counter -le 5 ]
	do
	
		#####get_cars(python) part#####
		python ./main.py > null
		#################################

		#echo $counter
		((counter++))
	done


end=$(date +%s.%N)    
runtime=$(python -c "print((${end} - ${start})/5)")

echo "Runtime was $runtime"



