#! /bin/bash
  set -e
  folder=$1
  for dir in ${folder}/*/
    do
      echo "migrating ${dir}"
      opm alpha bundle generate --directory ${dir} --output-dir ${dir}
      dir=${dir%*/}
      version=${dir##*/}
      mv bundle.Dockerfile ${folder}/bundle-${version}.Dockerfile
      echo "migrated ${dir}"
    done
