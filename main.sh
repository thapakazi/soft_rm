#!/bin/bash


EXPIRE_ON='20days'

#use this tag the trashed components
DATE_TODAY=$(date +%d_%m_%Y) # 30_3_2016

#mother of recyclebin
MOTHER_OF_RECYCLE_BIN=/mytemp/soft_rm

# MOTHER_OF_RECYCLE_BIN=/tmp/thrash/
export TMPDIR=$MOTHER_OF_RECYCLE_BIN/$DATE_TODAY
mkdir -p  $TMPDIR \
    || { echo; echo "mother of bin on $MOTHER_OF_RECYCLE_BIN, wtf;
             #dealwithit :p
             please mess up your permission if you want to use $MOTHER_OF_RECYCLE_BIN";
         echo "or set MOTHER_OF_RECYLE_BIN to somewhere you have access to."
         exit; }


#get some random dir
SAVEDIR=$(mktemp -td my_blob.XXXXXXXXXX)

#lets put some attr to the file/folder
setfattr -n user.expires_on \
         -v `date +%d_%m_%Y -d "+$EXPIRE_ON"` $SAVEDIR \
    || { echo; echo 'mount / -o remount,user_xattr
               if you see Operation not permitted error
               also donot use /tmp spits out crazy issue, trust me'; exit; }


# too lazy to do ls to see changes
print_thrash_home_contents () {
    #check the attr set
    getfattr -dR $TMPDIR
}
print_thrash_home_contents
