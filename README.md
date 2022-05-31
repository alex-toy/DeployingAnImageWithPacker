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

### Trouble shooting

You may very well receive a **InvalidTemplateDeployment** error when the resource SKU you've selected (such as VM size) isn't available for the location you've selected. An SKU(Stock Keeping Unit) is Microsoft's reference for their products and each SKU provides a specific amount of vm units. A VM unit is the amount of capacity needed to run one basic virtual machine for one day.

So the solution to your problem could be determining which regions/zones in which you have available SKUs for the size of VM you need and use that region/zone instead.

You can do that with the AzureCli by running the command:
```
az vm list-skus --location westus2 --size Standard_F --output table
```
You can use the the --location parameter to filter output to location you are using. Use the --size parameter to search by a partial size name you defined in your terraform script.


### Useful links : 

- [Azure locations](https://azuretracks.com/2021/04/current-azure-region-names-reference/)