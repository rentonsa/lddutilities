#!/bin/sh
cd /u01/dspace/dspace/upload/dspaceLoader
if ./load_runner_api.sh art 10683/6 1 1
then
   echo "art successful" >> art/load_runner_wrapper.log
else
   echo "art failure" >> art/load_runner_wrapper.log
fi

if ./load_runner_api.sh mimed 10683/14558 0 1
then
   echo "mimed successful" >> mimed/load_runner_wrapper.log
else
   echo "mimed failure" >> mimed/load_runner_wrapper.log
fi

if ./load_runner_api.sh stcecilia 10683/95806 0 1
then
   echo "st cecilia successful" >> stcecilia/load_wrapper.log
else
   echo "st cecilia failure" >> stcecilia/load_wrapper.log
fi

if ./load_runner_api.sh publicart 10683/102633 0 1
then
    echo "public art successful" >> publicart/load_wrapper.log
else
    echo "public art failure" >> publicart/load_wrapper.log
fi

if ./load_runner_api.sh geology 10683/111462 0 1
then
    echo "public art successful" >> geology/load_wrapper.log
else
    echo "public art failure" >> geology/load_wrapper.log
fi

