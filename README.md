# TL;DR;

This is for those that doesn`t have deployment resource only replicas set...
It will delete pod one by one until 20%(default of -p) of desired state and after it will wait desired state to be reached.
You just need to pass a keyword and it will find pods and replica with this name

## usage:
```
./delete_pods.sh <keyword>
./delete_pods.sh [ -n namespace ] <keyword>
./delete_pods.sh [ -c context ] [ -n namespace ] [ -p 0-100 ] <keyword>

    -p      percentage(rounds up) of desired state that must be keep running, check will run after delete
```
