## What the command opm alpha bundle generate does:

Before:

```
total 168
-rw-r--r--  1 alex  staff    40K Aug 13 11:32 core_v1alpha1_storagecluster_crd.yaml
-rw-r--r--  1 alex  staff   1.9K Aug 13 11:32 core_v1alpha1_storagenodestatus_crd.yaml
-rw-r--r--  1 alex  staff    36K Aug 13 11:32 portworxoperator.v1.0.0.clusterserviceversion.yaml
```
And then we run:
opm alpha bundle generate --directory 1.0.0 --output-dir 1.0.0

We should see something like this:
```
INFO[0000] Bundle channels and package name information not provided, inferring from parent package directory
INFO[0000] Inferred channels: alpha,stable
INFO[0000] Inferred package name: portworx-certified
INFO[0000] Inferred default channel: stable
INFO[0000] Building annotations.yaml
INFO[0000] Generating output manifests directory
INFO[0000] Writing annotations.yaml in /Users/alex/projects/redhat/bundle-migration/manifests-851274669/portworx-certified/portworx-certified-5edb2jey/1.0.0/metadata
INFO[0000] Building Dockerfile
INFO[0000] Writing bundle.Dockerfile in /Users/alex/projects/redhat/bundle-migration/manifests-851274669/portworx-certified/portworx-certified-5edb2jey
```

It creates 2 directories: manifests and metadata. Both inside the specific version folder.

```
-rw-r--r--  1 alex  staff    40K Aug 13 11:32 core_v1alpha1_storagecluster_crd.yaml
-rw-r--r--  1 alex  staff   1.9K Aug 13 11:32 core_v1alpha1_storagenodestatus_crd.yaml
drwxr-xr-x  5 alex  staff   160B Aug 13 12:06 manifests
drwxr-xr-x  3 alex  staff    96B Aug 13 12:06 metadata
-rw-r--r--  1 alex  staff    36K Aug 13 11:32 portworxoperator.v1.0.0.clusterserviceversion.yaml
```

And creates a file called bundle.Dockerfile to produce the container image for the operator registry in the bundle folder:
```
$ cd ..
$ ll
total 16
drwxr-xr-x  7 alex  staff   224B Aug 13 12:06 1.0.0
drwxr-xr-x  5 alex  staff   160B Aug 13 11:32 1.0.3
drwxr-xr-x  5 alex  staff   160B Aug 13 11:32 1.0.4
drwxr-xr-x  5 alex  staff   160B Aug 13 11:32 1.0.5
drwxr-xr-x  5 alex  staff   160B Aug 13 11:32 1.0.6
drwxr-xr-x  5 alex  staff   160B Aug 13 11:32 1.1.0
drwxr-xr-x  5 alex  staff   160B Aug 13 11:32 1.1.1
drwxr-xr-x  5 alex  staff   160B Aug 13 11:32 1.2.0
drwxr-xr-x  5 alex  staff   160B Aug 13 11:32 1.3.0
drwxr-xr-x  5 alex  staff   160B Aug 13 11:32 1.3.2
drwxr-xr-x  5 alex  staff   160B Aug 13 11:32 1.3.3
-rw-r--r--  1 alex  staff   495B Aug 13 12:06 bundle.Dockerfile
-rw-r--r--  1 alex  staff   172B Aug 13 11:32 portworx.package.yaml
```