#!/bin/sh

echo $1
echo $2
echo $3
echo $4
broke=0     

file_name=$1/load_runner_api.log
current_time=$(date "+%Y%m%d")
new_file_name=$file_name.$current_time
echo $new_file_name
echo "I am running a $1 load" > $new_file_name 
if [ -s $1/mapfile-master.txt ]
then
   if scl enable rh-python35 "python3 dspace_loader_api.py -c $1 -e live -f $3 -d $4"
   then
      if /u01/dspace/dspace/bin/dspace import -r -e scott.renton@ed.ac.uk -c $2 -s ~/dspace/upload/dspaceLoader/$1/dspaceExisting/ -m ~/dspace/upload/dspaceLoader/$1/mapfile.txt >> $new_file_name
      then 
	 if /u01/dspace/dspace/bin/dspace import -a -e scott.renton@ed.ac.uk -c $2 -s ~/dspace/upload/dspaceLoader/$1/dspaceNew/ -m ~/dspace/upload/dspaceLoader/$1/mapfile.txt --resume >> $new_file_name 
         then
            export JAVA_OPTS=-Xmx2048m
            if /u01/dspace/dspace/bin/dspace curate -t bitstreamtometadata -i $2
            then
               if scl enable rh-python35 "python3 dspace_loader_sync_map_file.py -c $1 -e live"
               then
                  if [ -s $1/mapfile.txt ]
                  then
                     if cat $1/mapfile.txt  | mail -s "$1 load: items loaded" lac-vernon-auto-output@mlist.is.ed.ac.uk
                     then
                        echo "mail sent!" >> $new_file_name
                     fi
                  else
                     echo "no mail to send" >> $new_file_name
                  fi
               else 
                  echo "sync map files fell over" >> $new_file_name
	       fi
            else
               echo "bitstream to metadata fell over" >> $new_file_name  
            fi
         else
            echo "load of new items fell over"   >> $new_file_name  
         fi
      else
         echo "load of existing items fell over" >> $new_file_name  
      fi
   else
      echo "archive format creator fell over- see its log for details" >> $new_file_name  
   fi
else
   echo "missing map file- do not run!" >> $new_file_name
fi

