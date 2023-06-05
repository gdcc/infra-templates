from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates
from azure import validators
from azure.cache import AzLivingCache

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
    validators.validate_vm_size(vm_size)
    validators.validate_security_policy(security_policy)
    if ssh_ip_whitelist:
        validators.validate_ip(ssh_ip_whitelist)
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
    validators.validate_location(location)
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

@app.get("/bash/placeholder")
def retrieve_bash_script(
        request: Request,
        args: str,
        script_name: str | None = 'placeholder.sh',
):
    return templates.TemplateResponse(
       f"bash/{script_name}",
        {
            "request": request,
            "args": args
        }
    )
