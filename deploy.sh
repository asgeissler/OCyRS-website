#!/bin/bash


rm -rf _site

quarto render

cp -r data _site/

# somewhat hacky way of making 'fna.motif' disappear in the file names
for i in _site/data/*/*fna.motif* ; do
  j=$(echo $i | sed 's,fna\.motif\.,,g')
  mv $i $j
done


# Ensure that localhost links are correct
# Copy to destination on server
scp -P 8080 -r _site adrian@localhost:/home/projects/rth/co2capture/sandbox/adrian/tmp/
echo "Please manualy copy to dna02 (something about the firewall prevents a direct ssh tunnel)"

# On dna02 the privileges might need adjustment, eg
#chmod -R a+rx .