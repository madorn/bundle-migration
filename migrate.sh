#! /bin/bash

# The use of labels in the container images:

# This is used to control which index images should include this operator.
# LABEL com.redhat.openshift.versions="v4.5, v4.6"'

# until cloudbld-2121 is done, you muse also add 
# LABEL com.redhat.delivery.operator.bundle=true

# Optionally, enable backporting in the generated dockerfile.  
# You want to do this only for the last image that will be published 
# as part of the migration.  For operators with only one release, 
# enable it since that is the first and last image.
# LABEL com.redhat.delivery.backport=true

  set -e
  folder=$1
  last_image=0
  counter=1
  for dir in ${folder}/*/
    do
      last_image=$((last_image+1))
    done;
  for dir in ${folder}/*/
    do
      echo "migrating ${dir}"
      opm alpha bundle generate --directory ${dir} --output-dir ${dir}
      dir=${dir%*/}
      version=${dir##*/}
      echo "LABEL com.redhat.openshift.versions=\"v4.5, 4.6\"" >> bundle.Dockerfile
      # until cloudbld-2121 is done, you muse also add 
      echo "LABEL com.redhat.delivery.operator.bundle=true" >> bundle.Dockerfile
      if ((counter==last_image))
      then
        echo "LABEL com.redhat.delivery.backport=true" >> bundle.Dockerfile
      fi
      mv bundle.Dockerfile ${folder}/bundle-${version}.Dockerfile
      echo "migrated ${dir}"
      ((counter=counter+1))
    done