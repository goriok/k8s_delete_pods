#TL;DR;
This is for those that doesn`t have deployment resource only replicas set...
It will delete pod one by one until 30% of desired state and after it will wait desired state to be reached.
You just need to pass a keyword and it will find pods and replica with this name

./delete_pods.sh <keyword>
./delete_pods.sh [ -n namespace ] <keyword>
./delete_pods.sh [ -c context ] [ -n namespace ] <keyword>
                                                 ,-~-.
                                                < ^ ; ~,
                                                 (_  _,
                                                  J~~>

