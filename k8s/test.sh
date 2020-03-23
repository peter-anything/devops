#!/bin/bash

ARGS=`getopt -o h --long initial-cluster:,peer-port:,client-port: \
    -n 'test.bash' -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

#set 会重新排列参数的顺序，也就是改变$1,$2...$n的值，这些值在getopt中重新排列过了
eval set -- "$ARGS"

#经过getopt的处理，下面处理具体选项。
hosts=""
peer_port=0
client_port=0

while true ; do
    case "$1" in
        --initial-cluster)
            hosts=$2
            shift 2
            ;;
        --peer-port)
            peer_port=$2; 
            shift 2
            ;;
        --client-port)
            client_port=$2;
            shift 2
            ;;
        --)
            shift;
            break
            ;;
        *)
            echo "Internal error!";
            exit 1
            ;;
    esac
done

echo $hosts
echo $peer_port
echo $client_port


