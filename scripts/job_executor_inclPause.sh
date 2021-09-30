#!/bin/bash

if [ -z "$STY" ]; then exec screen -dm -S jobExecutor /bin/bash "$0"; fi

folder="$(cd ../ && pwd)"
source $folder/config.ini

doit(){
echo "Starting job for all devices on instance: $MAD_instance"
echo ""

while read -r line ;do
origin=$(echo $line | awk '{print $1}')
deviceid=$(echo $line | awk '{print $2}')

echo "Pausing $origin and starting $job"
echo ""
curl -u $MADmin_user:$MADmin_pass "$MADmin_url/api/device/$deviceid" -H "Content-Type: application/json-rpc" --data-binary '{"call":"device_state","args":{"active":0}}'
curl -u $MADmin_user:$MADmin_pass "$MADmin_url/install_file?jobname=$job&origin=$origin&adb=False&type=JobType.CHAIN"

echo ""
echo "Sleeping $job_wait"
echo ""
sleep $job_wait

echo "Unpausing $origin"
echo ""
curl -u $MADmin_user:$MADmin_pass "$MADmin_url/api/device/$deviceid" -H "Content-Type: application/json-rpc" --data-binary '{"call":"device_state","args":{"active":1}}'
sleep 2s

done < <(mysql -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT $MAD_DB -NB -e "select a.name, a.device_id from settings_device a, madmin_instance b where a.instance_id = b.instance_id and b.name = '$MAD_instance';")
}


## run job for instance 1
if [ -z "$MAD_path_1" ]; then
  echo ""
  echo "No instance defined"
else
  MAD_instance=$MAD_instance_name_1
  MADmin_user=$MADmin_username_1
  MADmin_pass=$MADmin_password_1
  MADmin_url=$MAD_url_1
  doit
fi

## run job for instance 2
if [ -z "$MAD_path_2" ]; then
  echo ""
  echo "No 2nd instance defined"
else
  MAD_instance=$MAD_instance_name_2
  MADmin_user=$MADmin_username_2
  MADmin_pass=$MADmin_password_2
  MADmin_url=$MAD_url_2
  doit
fi

## run job for instance 3
if [ -z "$MAD_path_3" ]; then
  echo ""
  echo "No 3rd instance defined"
else
  MAD_instance=$MAD_instance_name_3
  MADmin_user=$MADmin_username_3
  MADmin_pass=$MADmin_password_3
  MADmin_url=$MAD_url_3
  doit
fi

## run job for instance 4
if [ -z "$MAD_path_4" ]; then
  echo ""
  echo "No 4th instance defined"
else
  MAD_instance=$MAD_instance_name_4
  MADmin_user=$MADmin_username_4
  MADmin_pass=$MADmin_password_4
  MADmin_url=$MAD_url_4
  doit
fi

## run job for instance 5
if [ -z "$MAD_path_5" ]; then
  echo ""
  echo "No 5th instance defined"
else
  MAD_instance=$MAD_instance_name_5
  MADmin_user=$MADmin_username_5
  MADmin_pass=$MADmin_password_5
  MADmin_url=$MAD_url_5
  doit
fi

echo ""
echo "All done !!"