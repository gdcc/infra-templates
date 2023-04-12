from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates
# from src.validators import (
#     validate_ip,
#     validate_location,
#     validate_security_policy,
#     validate_vm_size
# )
import validators
from azcache import AzLivingCache

app = FastAPI()

templates = Jinja2Templates(directory="templates")

@app.get("/terraform/azure/main")
def return_main_tf(
        request: Request,
        name: str,
        vm_size: str,
        security_policy: str,
        ssh_ip_whitelist: str):
    validate_vm_size(vm_size)
    validate_security_policy(security_policy)
    validate_ip(ssh_ip_whitelist)
    return templates.TemplateResponse(
        "azure/main.tf",
        {
            "request": request,
            "name": name,
            "vm_size": vm_size,
            "security_policy": security_policy
        }
    )

@app.get("/terraform/azure/variables")
def return_variables_tf(
        request: Request,
        name: str,
        location: str):
    validate_location(location)
    return templates.TemplateResponse(
        "azure/variables.tf",
        {
            "request": request,
            "name": name,
            "location": location
        }
    )

@app.get("/terraform/azure/outputs")
def return_variables_tf(
        request: Request,
        name: str):
    return templates.TemplateResponse(
        "azure/outputs.tf",
        {
            "request": request,
            "name": name
        }
    )

@app.get("/terraform/locations")
def return_locations():
    return AzLivingCache.valid_locations()

@app.get("/terraform/vm-sizes")
def return_vm_sizes():
    return AzLivingCache.filtered_vm_list()

