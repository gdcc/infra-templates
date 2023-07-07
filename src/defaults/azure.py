BASH_DEFAULTS = {
    "args": "test"
}

MAIN_TF_DEFAULTS =  {
    'name': 'example_name',
    'vm_name': 'example_vm_name',
    'vm_size': 'Basic_A0',
    'security_policy': 'internal',
    'ssh_ip_whitelist': '1.1.1.1',
    'cloudinit_file': 'optional_filename'
}

VARIABLES_TF_DEFAULTS = {
    "name": "test",
    "location": "westeurope"
}

OUTPUTS_TF_DEFAULTS = {
    "name": "example_name"
}

PROVIDERS_TF_DEFAULTS = {
    'cloudinit_file': 'cloudinit_example_file'
}

DOWNLOAD_FILE_DEFAULTS = {
    'files': ['https://example.com/test.py', 'https://something.eu/example.rb']
}
