import json

class AzCache:

    def __init__(self) -> None:
        self.locations = []
        self.vm_sizes = []
        pass

    def filtered_vm_list(self):
        if not self.vm_sizes:
            with open("vm_list", 'r') as vm_file:
                valid_vm_list = json.loads(vm_file.read())
            self.vm_sizes = sorted([vm.get("name") for vm in valid_vm_list])
        return self.vm_sizes

    def valid_locations(self):
        if not self.locations:
            with open("locations", 'r') as vm_file:
                valid_vm_list = json.loads(vm_file.read())
            self.locations = sorted([vm.get("name") for vm in valid_vm_list])
        return self.locations

AzLivingCache = AzCache()
