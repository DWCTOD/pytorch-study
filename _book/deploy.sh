#!/bin/sh

Usage(){
    echo "welcome use front-end release script
    -----------------------------------------
    use it require input your deploy target
           gook luck!
    author:
        wolf.deng@gmail.com
    -----------------------------------------
    Usage:

    # 发布github.io
    ./deploy.sh github.io
    "
}

die( ){
    echo
    echo "$*"
    Usage
    echo
    exit 1
}

git pull

# get real path
cd `echo ${0%/*}`
abspath=`pwd`

#清除之前生成的文件
rm -rf $abspath/build

TARGET=$1
PROJECT='pytorch-study'


sync( ){
    case $* in
        "github.io" )
            echo "sync $PROJECT gitbook website to $TARGET"
            GITHUB_PROJECT=""
				
            Sync="rsync -avu --delete --exclude '*.sh' --exclude '.git*' --exclude '.DS_Store' $abspath/_book/$PROJECT $GITHUB_PROJECT"
            echo $Sync
            eval $Sync

            cd $GITHUB_PROJECT
            rake generate
            rake deploy
        ;;

    esac
}

build(){
    echo "build $PROJECT document"

    OUTPUT="./build/$PROJECT"

    gitbook init

    rm  -rf $OUTPUT
    gitbook build . --output=$OUTPUT
}

blog(){
    echo "build & sync $PROJECT to github.io"
    build
    sync $TARGET
}

# 判断执行参数，调用指定方法
case $TARGET in
    github.io )
       blog
        ;;
    * )
        die "parameters is no reght!"
        ;;
esac
