import socket
from fastapi import HTTPException
from azcache import AzLivingCache

def validate_location(location):
    if location not in AzLivingCache.valid_locations():
        raise HTTPException(
            status_code=400,
            detail="Location incorrect"
        )

def validate_vm_size(vm_size):
    if vm_size not in AzLivingCache.filtered_vm_list():
        raise HTTPException(status_code=400, detail="VM size incorrect")

def validate_security_policy(security_policy):
    if security_policy != "internal" or "external":
        raise HTTPException(
            status_code=400,
            detail="Security policy incorrect; must be 'internal' or 'external'"
        )

def validate_ip(ssh_ip_whitelist):
    try:
        socket.inet_aton(ssh_ip_whitelist)
    except OSError:
        raise HTTPException(
            status_code=400,
            detail="Invalid IP address detected, check whitelist"
        )

