## Certified Operators Migration Step by Step

1) Clone the project and cd into it:
```
git clone git@github.com:acmenezes/bundle-migration.git
cd bundle-migration
```

2) Pull the certified operators manifests to your local machine:
```
make pull-cert-operators
```

3) Get the operator path and put into the BUNDLE_DIR variable:
Example:
```
BUNDLE_DIR=manifests-851274669/portworx-certified/portworx-certified-5edb2jey
```
4) If the operator has a flat directory create a new one and put it into the OUTPUT_DIR variable and run the nest command:

```
make nest
```
5) Run the migrate command that will generate the dockerfiles to build and push the images:
```
make bundle-migrate
```
This last one runs opm under the hood and [here](opm_alpha_generate.md) you can find what opm is doing.
