#!/bin/bash

set -e

VersionTable=metadata.versions
Server='-h 10.0.7.18'
Credentials='-u root '
MYSQL="mysql $Server $Credentials"

getVersion()
{
	version=$($MYSQL -BN -e "select version_number from $VersionTable order by id desc limit 1;")
	echo $version
}

# variables passed
# $1 up alter table statement
# $2 version number
up()
{
   alter="$1"
   newver=$2
   # before applying which version are we on
   currver=$(getVersion)

   let currver=currver+1
   if [ "$currver" -ne "$newver" ]; then
     let currver=currver-1
	   echo "Incorrect version in sequence, database is at version $currver, you are applying version $newver"
	   exit
   fi

   # doing the alter
   echo "$(date): Running the following DDL: $alter"
   $MYSQL -e "$alter" && $MYSQL -e "insert into $VersionTable (version_number, alterstatement) values ($newver,"'quote("'"$alter"'")'");" && echo "$(date): Up DDL applied successfully"

}

# variables passed
# $1 up alter table statement
# $2 version number
down()
{
   alter="$1"
   newver=$2
   # before applying which version are we on
   currver=$(getVersion)

   if [ "$currver" -ne "$newver" ]; then
	    echo "Incorrect version in sequence, database is at version $currver, you are reverting version $newver"
      exit
   fi

   # doing the alter
   echo "$(date): Running the following DDL: $alter"
   $MYSQL -e "$alter" && $MYSQL -e "insert into $VersionTable (version_number, alterstatement) values (${newver}-1,"'quote("'"$alter"'")'");" && echo "$(date): Down DDL applied successfully"

}

