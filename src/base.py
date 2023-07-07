#!/usr/bin/env python3
import os
import pathlib

from fastapi import FastAPI, Request, UploadFile
from fastapi.responses import JSONResponse
from fastapi.templating import Jinja2Templates
from fastapi.encoders import jsonable_encoder
from azure import validators as azure_validators
from bash import validators as bash_validators
from azure.cache import AzLivingCache
from fastapi.exceptions import HTTPException
from jinja2.exceptions import TemplateNotFound, TemplateSyntaxError
from jinja2 import BaseLoader, Environment, FileSystemLoader, meta, Template
from functools import partialmethod, partial
from models import TemplateCreateModel
from fastapi.responses import JSONResponse

templates = Jinja2Templates(directory="templates")

def file_exists(path: str):
    return os.path.isfile(path)

def dir_exists(path: str):
    return os.path.isdir(f'/src/templates/{path}')

def is_valid_jinja_file(path: str):
    env = Environment()
    with open(path, 'r') as template:
        try:
            env.parse(template.read())
        except TemplateSyntaxError:
            return False
    return True

def is_valid_jinja(data: str):
    env = Environment()
    try:
        env.parse(data)
    except TemplateSyntaxError:
        return False
    return True

def _missing_variables(path: str, variables: dict, optional_vars=[]):
    env = Environment()
    with open(path, 'r') as template_file:
        data = template_file.read()
    ast = env.parse(data)
    template_variables = meta.find_undeclared_variables(ast)
    missing = []
    optional_vars += ['_body_stream', '__name__']
    for variable in template_variables:
        if variable not in variables:
            missing.append(variable)
    for var in optional_vars:
        if var in missing:
            missing.remove(var)
    if missing:
        return True, missing
    return False, set()

def _build_template(path: str, request: Request, variables: dict):
    variables['request'] = request
    template_path = pathlib.Path(path).parts
    return templates.TemplateResponse(
        f"{template_path[-2]}/{template_path[-1]}",
        variables
    )

def base_get_method(
        request: Request,
        variables: dict,
        filepath="",
        optional_vars=[]
):
    if file_exists(filepath):
        if is_valid_jinja_file(filepath):
            missing, vars = _missing_variables(filepath, variables, optional_vars)
            if missing:
                raise HTTPException(status_code=400, detail=f"Template variables missing: {vars}")
            return _build_template(
                path=filepath,
                request=request,
                variables=variables
            )
        raise HTTPException(status_code=400, detail="Template has invalid Jinja markup.")
    raise HTTPException(status_code=400, detail="Template not found at this location.")

def base_list_method(
    path=""
):
    if dir_exists(path):
        return os.listdir(f'/src/templates/{path}')
    raise HTTPException(status_code=400, detail='Directory not found.')

def base_create_method(
        path: str,
        template: UploadFile
):
    if not file_exists(path):
        file_data = template.file.read().decode('utf-8')
        if is_valid_jinja(file_data):
            base_path = '/src/templates/'
            relpath = os.path.join(base_path, path)
            with open(relpath, 'w') as new_file:
                new_file.write(file_data)
            return JSONResponse(content=file_data)
        raise HTTPException(status_code=400, detail='Template has invalid Jinja markup.')
    raise HTTPException(status_code=400, detail='File already exists in this location.')

def base_delete_method(
    path: str
):
    if file_exists(path):
        os.remove(path)
        return JSONResponse(status_code=204, content="")
    raise HTTPException(status_code=400, detail="File not found, nothing deleted.")
