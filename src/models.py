#!/usr/bin/env python3
import os

from typing import Dict, Optional, Self
from fastapi import Request, UploadFile
from pydantic import BaseModel, create_model
from fastapi.templating import Jinja2Templates
from jinja2 import Environment
from jinja2.exceptions import TemplateSyntaxError

class TemplateCreateModel(BaseModel):

    path: str
    filename: str
    template: UploadFile
