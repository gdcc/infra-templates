import os

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.templating import Jinja2Templates
from fastapi.encoders import jsonable_encoder
from azure import validators as azure_validators
from bash import validators as bash_validators
from azure.cache import AzLivingCache
from jinja2.exceptions import TemplateNotFound

app = FastAPI()

templates = Jinja2Templates(directory="templates")

@app.get("/terraform/azure/main")
def return_main_tf(
        request: Request,
        name: str,
        vm_size: str,
        vm_name: str,
        security_policy: str | None = 'internal',
        ssh_ip_whitelist: str | None = None,
        cloudinit_file: str | None = None):
    azure_validators.validate_vm_size(vm_size)
    azure_validators.validate_security_policy(security_policy)
    if ssh_ip_whitelist:
        azure_validators.validate_ip(ssh_ip_whitelist)
    return templates.TemplateResponse(
        "azure/main.tf",
        {
            "request": request,
            "name": name,
            "vm_size": vm_size,
            "security_policy": security_policy.lower(),
            "vm_name": vm_name,
            "ssh_ip_whitelist": ssh_ip_whitelist,
            "cloudinit_file": cloudinit_file
        }
    )

@app.get("/terraform/azure/variables")
def return_variables_tf(
        request: Request,
        name: str,
        location: str):
    azure_validators.validate_location(location)
    return templates.TemplateResponse(
        "azure/variables.tf",
        {
            "request": request,
            "name": name,
            "location": location
        }
    )

@app.get("/terraform/azure/outputs")
def return_outputs_tf(
        request: Request,
        name: str):
    return templates.TemplateResponse(
        "azure/outputs.tf",
        {
            "request": request,
            "name": name
        }
    )

@app.get("/terraform/azure/providers")
def return_providers_tf(
        request: Request,
        cloudinit_file: str | None = None
):
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


@app.get("/cloudinit/docker")
def return_dataverse_docker_playbook(
        request: Request,
):
    return templates.TemplateResponse(
        "cloudinit/docker-dataverse.yml",
        {
            "request": request,
        }
    )

@app.get("/cloudinit/downloadfiles")
def download_files_to_home_dir(
        request: Request,
        file_urls=[]
):
    fixed_urls = str(file_urls).split(",")
    stripped_urls = [item.strip() for item in fixed_urls]
    return templates.TemplateResponse(
        "cloudinit/download-files.yml",
        {
            "request": request,
            "files": set(stripped_urls),
        }
    )

@app.get("/bash/scripts/{script_name}")
def retrieve_bash_script(
        request: Request,
        args: str,
        script_name: str | None = 'placeholder.sh',
):
    bash_validators.validate_bash_file_present(script_name)
    return templates.TemplateResponse(
        f"bash/{script_name}",
        {
            "request": request,
            "args": args
        }
    )

@app.get("/bash/scripts")
def retrieve_bash_script_list(
        request: Request,
):
    bash_files = os.listdir('/src/templates/bash')
    return JSONResponse(content=jsonable_encoder(bash_files))
