 for ((count=1;;count++))
 do
     ./buggy.sh &> out.log
     if [[ $? -ne 0 ]]; then
         cat out.log
         echo "failed after $count times"
         break

     echo "$count try"
     fi
 done


