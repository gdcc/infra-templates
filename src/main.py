import os

from fastapi import FastAPI, HTTPException, Request, UploadFile
from fastapi.responses import JSONResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from fastapi.encoders import jsonable_encoder
from azure import validators as azure_validators
from bash import validators as bash_validators
from azure.cache import AzLivingCache
from jinja2.exceptions import TemplateNotFound
from models import TemplateCreateModel

from base import base_list_method, base_get_method, base_create_method, base_delete_method
from defaults.azure import (
    BASH_DEFAULTS,
    DOWNLOAD_FILE_DEFAULTS,
    MAIN_TF_DEFAULTS,
    OUTPUTS_TF_DEFAULTS,
    PROVIDERS_TF_DEFAULTS,
    VARIABLES_TF_DEFAULTS,
)

app = FastAPI()

templates = Jinja2Templates(directory="templates")

@app.get("/")
def redirect_to_docs():
    return RedirectResponse(url="https://infra-templates.gdcc.io/docs/")

@app.post("/terraform/azure/main")
def return_main_tf(
        request: Request,
        variables: dict | None = MAIN_TF_DEFAULTS,
    ):
    try:
        variables['name']
        variables['vm_name']
        variables['vm_size']
    except KeyError:
        raise HTTPException(
            status_code=400, detail="Missing variables."
        )
    azure_validators.validate_vm_size(variables.get('vm_size'))
    azure_validators.validate_security_policy(variables['security_policy'])
    if variables.get('ssh_ip_whitelist'):
        azure_validators.validate_ip(variables['ssh_ip_whitelist'])
    return base_get_method(
        request=request,
        variables=variables,
        filepath='/src/templates/azure/main.tf',
        optional_vars=['ssh_ip_whitelist', 'cloudinit_file']
    )

@app.post("/terraform/azure/variables")
def return_variables_tf(
        request: Request,
        variables: dict | None = VARIABLES_TF_DEFAULTS
):
    azure_validators.validate_location(variables.get('location'))
    return base_get_method(
        request=request,
        variables=variables,
        filepath='/src/templates/azure/variables.tf'
    )

@app.post("/terraform/azure/outputs")
def return_outputs_tf(
        request: Request,
        variables: dict | None = OUTPUTS_TF_DEFAULTS):
    return base_get_method(
        request=request,
        variables=variables,
        filepath='/src/templates/azure/outputs.tf'
    )

@app.post("/terraform/azure/providers")
def return_providers_tf(
        request: Request,
        variables: dict | None = PROVIDERS_TF_DEFAULTS
):
    return base_get_method(
        request=request,
        variables=variables,
        filepath='/src/templates/azure/providers.tf',
        optional_vars=['cloudinit_file']
    )
    return templates.TemplateResponse(
        "azure/providers.tf",
        {
            "request": request,
            "cloudinit_file": cloudinit_file
        }
    )

@app.get("/terraform/azure/locations")
def return_locations():
    return AzLivingCache.valid_locations()

@app.get("/terraform/azure/vm-sizes")
def return_vm_sizes():
    return AzLivingCache.filtered_vm_list()


@app.post("/cloudinit/docker")
def return_dataverse_docker_playbook(
        request: Request,
):
    return base_get_method(
        request=request,
        variables={},
        filepath='/src/templates/cloudinit/docker-dataverse.yml',
    )

@app.post("/cloudinit/downloadfiles")
def download_files_to_home_dir(
        request: Request,
        variables: dict | None = DOWNLOAD_FILE_DEFAULTS
):
    # This needs a generic URL validator
    return base_get_method(
        request=request,
        variables=variables,
        filepath='/src/templates/cloudinit/download-files.yml'
    )

@app.post("/bash/scripts/{script_name}")
def retrieve_bash_script(
        request: Request,
        variables: dict | None = BASH_DEFAULTS,
        script_name: str | None = 'placeholder.sh',
):
    return base_get_method(
        request=request,
        variables=variables,
        filepath=f'/src/templates/bash/{script_name}'
    )

@app.get("/bash/scripts")
def retrieve_bash_script_list():
    return base_list_method(path='bash')

@app.post("/bash/scripts")
def create_bash_script(
        filename: str,
        template: UploadFile
):
    full_path = os.path.join('/src/templates', f'bash/{filename}')
    return base_create_method(
        path=full_path,
        template=template
    )

@app.delete("/bash/scripts/{script_name}")
def delete_bash_script(
    script_name: str,
):
    full_path = os.path.join('/src/templates', f'bash/{script_name}')
    return base_delete_method(path=full_path)
