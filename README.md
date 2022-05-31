Deploying an Image with Packer
=

### Explanations
Once we confirm that our image has everything we need, we enter the command to actually create an image:
```
packer build demo.json
```
Then we can access (i.e. list or delete) this image using the CLI:

```
az image list
az image delete -g packer-rg -n myPackerImage
```



