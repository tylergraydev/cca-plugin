---
name: cca-azure
description: CCA knowledge for Azure cloud services and Azure DevOps. Auto-loaded when azure-pipelines.yml, .azure/, or Azure-related configs exist.
---

# CCA: Azure Context

## Detection
This context applies when:
- `azure-pipelines.yml` exists
- `.azure/` directory exists
- `host.json` (Azure Functions) exists
- `*.bicep` or `azuredeploy.json` files exist

---

# Azure DevOps Pipelines

## Basic Pipeline
```yaml
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

stages:
  - stage: Build
    jobs:
      - job: BuildJob
        steps:
          - task: NodeTool@0
            inputs:
              versionSpec: '20.x'
          - script: npm ci
          - script: npm run build
          - script: npm test

  - stage: Deploy
    dependsOn: Build
    condition: succeeded()
    jobs:
      - deployment: DeployWeb
        environment: 'production'
        strategy:
          runOnce:
            deploy:
              steps:
                - script: echo "Deploying..."
```

## Common Tasks

### Node.js
```yaml
steps:
  - task: NodeTool@0
    inputs:
      versionSpec: '20.x'
  - task: Npm@1
    inputs:
      command: 'ci'
  - task: Npm@1
    inputs:
      command: 'custom'
      customCommand: 'run build'
```

### .NET
```yaml
steps:
  - task: UseDotNet@2
    inputs:
      version: '8.x'
  - task: DotNetCoreCLI@2
    inputs:
      command: 'restore'
  - task: DotNetCoreCLI@2
    inputs:
      command: 'build'
      arguments: '--configuration Release'
  - task: DotNetCoreCLI@2
    inputs:
      command: 'test'
```

### Docker
```yaml
steps:
  - task: Docker@2
    inputs:
      containerRegistry: 'myACR'
      repository: 'myapp'
      command: 'buildAndPush'
      Dockerfile: '**/Dockerfile'
      tags: |
        $(Build.BuildId)
        latest
```

### Azure Web App Deployment
```yaml
steps:
  - task: AzureWebApp@1
    inputs:
      azureSubscription: 'MyAzureSubscription'
      appType: 'webAppLinux'
      appName: 'my-web-app'
      package: '$(Pipeline.Workspace)/drop/**/*.zip'
```

## Variables & Secrets
```yaml
variables:
  - name: buildConfiguration
    value: 'Release'
  - group: 'my-variable-group'  # From Library
  - name: secretVar
    value: $(MY_SECRET)  # Pipeline secret

steps:
  - script: echo $(buildConfiguration)
    env:
      SECRET_VAR: $(secretVar)  # Map secret to env
```

## Templates
```yaml
# templates/build-steps.yml
parameters:
  - name: nodeVersion
    default: '20.x'

steps:
  - task: NodeTool@0
    inputs:
      versionSpec: ${{ parameters.nodeVersion }}
  - script: npm ci
  - script: npm run build
```

```yaml
# azure-pipelines.yml
stages:
  - stage: Build
    jobs:
      - job: BuildJob
        steps:
          - template: templates/build-steps.yml
            parameters:
              nodeVersion: '20.x'
```

## Multi-Stage with Environments
```yaml
stages:
  - stage: Build
    jobs:
      - job: Build
        steps:
          - script: npm run build

  - stage: DeployStaging
    dependsOn: Build
    jobs:
      - deployment: Deploy
        environment: 'staging'
        strategy:
          runOnce:
            deploy:
              steps:
                - script: ./deploy.sh staging

  - stage: DeployProduction
    dependsOn: DeployStaging
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - deployment: Deploy
        environment: 'production'
        strategy:
          runOnce:
            deploy:
              steps:
                - script: ./deploy.sh production
```

---

# Azure CLI

## Authentication
```bash
# Interactive login
az login

# Service principal login
az login --service-principal -u <app-id> -p <password> --tenant <tenant-id>

# Set subscription
az account set --subscription "My Subscription"

# List subscriptions
az account list --output table
```

## Resource Groups
```bash
# Create
az group create --name myResourceGroup --location eastus

# List
az group list --output table

# Delete
az group delete --name myResourceGroup --yes
```

## App Service
```bash
# Create web app
az webapp create \
  --resource-group myResourceGroup \
  --plan myAppServicePlan \
  --name myUniqueAppName \
  --runtime "NODE:20-lts"

# Deploy from zip
az webapp deployment source config-zip \
  --resource-group myResourceGroup \
  --name myUniqueAppName \
  --src app.zip

# Configure settings
az webapp config appsettings set \
  --resource-group myResourceGroup \
  --name myUniqueAppName \
  --settings KEY=value

# View logs
az webapp log tail \
  --resource-group myResourceGroup \
  --name myUniqueAppName
```

## Azure Functions
```bash
# Create function app
az functionapp create \
  --resource-group myResourceGroup \
  --consumption-plan-location eastus \
  --runtime node \
  --runtime-version 20 \
  --functions-version 4 \
  --name myFunctionApp \
  --storage-account mystorageaccount

# Deploy
func azure functionapp publish myFunctionApp

# Local development
func start
```

## Container Instances
```bash
# Create container
az container create \
  --resource-group myResourceGroup \
  --name mycontainer \
  --image myregistry.azurecr.io/myapp:latest \
  --cpu 1 \
  --memory 1.5 \
  --ports 80

# View logs
az container logs --resource-group myResourceGroup --name mycontainer
```

## Azure Kubernetes Service (AKS)
```bash
# Create cluster
az aks create \
  --resource-group myResourceGroup \
  --name myAKSCluster \
  --node-count 3 \
  --enable-addons monitoring \
  --generate-ssh-keys

# Get credentials
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster

# Scale
az aks scale --resource-group myResourceGroup --name myAKSCluster --node-count 5
```

---

# Azure Functions

## Local Development
```bash
# Install tools
npm install -g azure-functions-core-tools@4

# Create new project
func init MyFunctionApp --javascript

# Create function
func new --name HttpTrigger --template "HTTP trigger"

# Run locally
func start
```

## Function Example (Node.js)
```javascript
// src/functions/httpTrigger.js
const { app } = require('@azure/functions');

app.http('httpTrigger', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: async (request, context) => {
        context.log('HTTP trigger function processed a request.');
        
        const name = request.query.get('name') || await request.text() || 'World';
        
        return { body: `Hello, ${name}!` };
    }
});
```

## Function Example (C#)
```csharp
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;

public class HttpTrigger
{
    [Function("HttpTrigger")]
    public async Task<HttpResponseData> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post")] HttpRequestData req,
        FunctionContext context)
    {
        var response = req.CreateResponse(HttpStatusCode.OK);
        await response.WriteStringAsync("Hello, World!");
        return response;
    }
}
```

## host.json Configuration
```json
{
  "version": "2.0",
  "logging": {
    "applicationInsights": {
      "samplingSettings": {
        "isEnabled": true
      }
    }
  },
  "extensions": {
    "http": {
      "routePrefix": "api"
    }
  },
  "functionTimeout": "00:10:00"
}
```

---

# Bicep (Infrastructure as Code)

## Basic Template
```bicep
// main.bicep
param location string = resourceGroup().location
param appName string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${appName}-plan'
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'NODE|20-lts'
    }
  }
}

output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
```

## Deploy Bicep
```bash
# Deploy
az deployment group create \
  --resource-group myResourceGroup \
  --template-file main.bicep \
  --parameters appName=myapp

# What-if (preview changes)
az deployment group what-if \
  --resource-group myResourceGroup \
  --template-file main.bicep
```

---

## Common Gotchas
- Pipeline variables use `$(VAR)` syntax, not `${{ }}`
- Template parameters use `${{ parameters.name }}`
- Secrets are masked in logs automatically
- Use `dependsOn` for stage/job ordering
- Environments enable approval gates
- Azure CLI commands need `az login` first
- Function Apps v4 use new programming model
- Bicep is preferred over ARM JSON templates
- Use Key Vault for secrets in production
- App Service requires App Service Plan (or use consumption)
