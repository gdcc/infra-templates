#!/usr/bin/env python3

from fastapi import HTTPException
import os

def validate_bash_file_present(filename):
    file_list = os.listdir("/src/templates/bash")
    if filename not in file_list:
        raise HTTPException(
            status_code=400,
            detail="File does not exist"
        )
