#!/bin/bash 

EXPIRE_ON='20days' #days to keep the removed ones
DATE_TODAY=$(date +%d_%m_%Y) # 30_3_2016 to manage by date struct
MOTHER_OF_RECYCLE_BIN=/mytemp/soft_rm #mother of recyclebin

export TMPDIR=$MOTHER_OF_RECYCLE_BIN/$DATE_TODAY # MOTHER_OF_RECYCLE_BIN=/tmp/thrash/
mkdir -p  $TMPDIR \
    || { echo; echo "mother of bin on $MOTHER_OF_RECYCLE_BIN directly on / wtf;
             #dealwithit :p, cuz I have broken permissions..";
         echo "make sure you can run: 
                  mkdir -p MOTHER_OF_RECYLE_BIN";
         exit; }

#moving files and faking removal
move_and_fake_rm-rf(){
    stuff_to_move_from="$1"
    echo "moving everythings inside $stuff_to_move_from will be delete in $EXPIRE_ON"
    mv $stuff_to_move_from/* $SAVEDIR || mv $stuff_to_move_from $SAVEDIR

 }

# too lazy to do ls to see changes
print_thrash_home_contents () {
    #check the attr set
    getfattr -dR $1
}

# setting necessary tag attributes
set_attribs(){
    expires_on=$(date +%d_%m_%Y -d "+$EXPIRE_ON")
    deleted_from="$(echo $1|awk -F/ 'BEGIN{OFS="/"}{$NF="";print$0}')"

    export SAVEDIR=$TMPDIR/"$(echo $1|awk -F/ '{print$NF}')" #(mktemp -td my_blob.XXXXXXXXXX) #lets have some randomness
    mkdir -p $SAVEDIR
    #lets put some attr to the file/folder
    setfattr -n user.expires_on \
             -v $expires_on $SAVEDIR \
        || { echo; echo 'mount / -o remount,user_xattr
                  if you see Operation not permitted error
                  also donot use /tmp spits out crazy issue, trust me'; exit; }
    setfattr -n user.deleted_from \
             -v $deleted_from $SAVEDIR \
        || { echo; echo 'bailing out setting attrs about deleted_path
                         flie/folder being removed seems fishy'; exit; }

    move_and_fake_rm-rf "$1"
    print_thrash_home_contents "$SAVEDIR"
}

#giant loop
for i in $@
do
    set_attribs "$i"
done


