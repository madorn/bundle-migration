#! /opt/anaconda3/bin/python

import yaml
import sys
import os


# get all CSVs under the bundle directory
def get_csv_paths(bundle_dir):
  bundle_subdirs = [subdir[0] for subdir in os.walk(bundle_dir)]
  csv_paths = []
  for subdir in bundle_subdirs:
    if subdir.endswith("/manifests"):
      for file in os.listdir(subdir):
        if file.endswith(".clusterserviceversion.yaml"):
          csv_paths.append(subdir + "/" + file)
  return csv_paths

# parse and check image fields on the csv file
def check_image_fields(csv_path_list):
  for csv_path in csv_path_list:
    with open(csv_path) as csv:
      parsed_csv = yaml.load(csv, Loader=yaml.FullLoader)
      
      # Check the registry address in the containerImage annotation field
      # should contain registry.connect.redhat.com if not append it to the beginning
      containerImage = parsed_csv["metadata"]["annotations"]["containerImage"]
      found = containerImage.find("registry.connect.redhat.com/")
      if found == -1:
        containerImage = "registry.connect.redhat.com/" + containerImage
        parsed_csv["metadata"]["annotations"]["containerImage"]  = containerImage 
      
      # Check the registry address in the image template container spec field
      # should contain registry.connect.redhat.com if not append it to the beginning
      image = parsed_csv["spec"]["install"]["spec"]["deployments"][0]["spec"]["template"]["spec"]["containers"][0]["image"]
      found = image.find("registry.connect.redhat.com/")
      if found == -1:
        image = "registry.connect.redhat.com/" + image
        parsed_csv["spec"]["install"]["spec"]["deployments"][0]["spec"]["template"]["spec"]["containers"][0]["image"] = image


    with open(csv_path, "w") as csv_file:
      csv = yaml.dump(parsed_csv, csv_file)
    
def main():
  check_image_fields(get_csv_paths(sys.argv[1]))

if __name__ == "__main__":
  main()
