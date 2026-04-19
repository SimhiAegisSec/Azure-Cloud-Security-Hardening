# Command to disable public access on the insecure storage account
az storage account update --name insecurestorage1 --resource-group RG-SC-Proj1 --allow-blob-public-access false



# 1. Disable Public Network Access
az storage account update --name insecurestorage1 --resource-group RG-SC-Proj1 --public-network-access Disabled

# 2. Disable Shared Key Access
az storage account update --name insecurestorage1 --resource-group RG-SC-Proj1 --allow-shared-key-access false

# 3. Require TLS 1.2
az storage account update --name insecurestorage1 --resource-group RG-SC-Proj1 --min-tls-version TLS1_2
