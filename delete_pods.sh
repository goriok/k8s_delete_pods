#echo !/bin/bash
NS=''
CONTEXT=''

usage() {
  echo "This is for those that doesn\`t have deployment resource only replicas set...  
It will delete pod one by one until 30% of desired state and after it will wait desired state to be reached.
You just need to pass a keyword and it will find pods and replica with this name 

$0 <keyword>
$0 [ -n namespace ] <keyword>
$0 [ -c context ] [ -n namespace ] <keyword>
                                                 ,-~-.
                                                < ^ ; ~,
                                                 (_  _, 
                                                  J~~> 
"
  exit
}

if [ $# -eq 0 ]; then
  usage
fi

while getopts ":n:c:h" options; do
  case "${options}" in 
    n)
      NS="-n ${OPTARG}"
      ;;
    c)
      CONTEXT="--context=${OPTARG}"
      ;;
    h)
      usage
      ;;
  esac
done

shift $(($#-1))
KEYWORD=$1

k="kubectl $NS $CONTEXT"
declare -a pods=($(kubectl $NS $CONTEXT get po | grep $KEYWORD | grep Running | awk '{ print $1 }' |  tr '\n' ' '))
replicaSet=$(kubectl $NS $CONTEXT  get rs | grep $KEYWORD |  awk '{ print $1 }')

if [[ ${#pods[@]} -eq 0 ]]; then
  echo "couldn\`t find any pods... (╯︵╰, )"
  exit
fi

echo replica set returned from keyword \"$KEYWORD\": 
echo
echo '  '$replicaSet
echo
echo pods returned from keyword \"$KEYWORD\":
echo
printf '  %s\n' "${pods[@]}"
echo
read -p "delete these pods? [Yy] ? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  for pod in ${pods[@]}; do
   kubectl $NS $CONTEXT  delete --grace-period=0 --force po $pod
   echo
   echo "(╯ °□°)╯︵ ┻━┻"
   echo waiting desired state...
   while : 
   do
    desired=$(kubectl $NS $CONTEXT  get rs | grep $KEYWORD |  awk '{print $2}') 
    current=$(kubectl $NS $CONTEXT  get rs | grep $KEYWORD |  awk '{print $4}') 
    echo state: $current/$desired
    if [ "$desired" -eq "$current" ] || [ $((($desired*80+99)/100)) -le $current ] ; then
      echo
      echo "(ヘ･_･)ヘ┳━┳"
      echo "pod $pod has been replaced"
      echo 
      break;
    fi
    sleep 1s
   done
  done
  echo
  echo all pods have been deleted =\)
  echo "\m/_(>_<)_\m/"
fi
