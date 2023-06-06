from fastapi.testclient import TestClient
from .. import main

client = TestClient(app=main.app)

def test_locations():
    response = client.get("/terraform/azure/locations")
    assert response.status_code == 200
    assert isinstance(response.json(), list)
    assert 'westeurope' in response.json()
    assert 'Random' not in response.json()

def test_vm_sizes():
    response = client.get("/terraform/azure/vm-sizes")
    assert response.status_code == 200
    assert isinstance(response.json(), list)
    assert 'Standard_A0' in response.json()
    assert 'Sanity' not in response.json()

def test_variables_tf():
    test_url = 'http://localhost:6067/terraform/azure/variables?name=monkey&location=westeurope'
    response = client.get(test_url)
    assert response.status_code == 200
    assert 'monkey' in response.content.decode('utf-8')
    assert "westeurope" in response.content.decode('utf-8')
    assert 'zebra' not in response.content.decode('utf-8')

def test_outputs_tf():
    test_url = 'http://localhost:6067/terraform/azure/outputs?name=monkey'
    response = client.get(test_url)
    assert response.status_code == 200
    assert 'monkey' in response.content.decode('utf-8')
    assert 'zebra' not in response.content.decode('utf-8')

def test_main_tf():
    test_url = 'http://localhost:6067/terraform/azure/main?name=monkey&vm_size=Standard_A0&vm_name=monkeytest&security_policy=internal&ssh_ip_whitelist=1.1.1.1'
    response = client.get(test_url)
    assert response.status_code == 200
    assert 'monkey' in response.content.decode('utf-8')
    assert 'Standard_A0' in response.content.decode('utf-8')
    assert "1.1.1.1" in response.content.decode('utf-8')
    assert 'Zebra' not in response.content.decode('utf-8')

def test_providers_tf():
    test_url = 'http://localhost:6067/terraform/azure/providers'
    response = client.get(test_url)
    assert response.status_code == 200
    assert 'azurerm' in response.content.decode('utf8')
    assert 'cloudinit' not in response.content.decode('utf-8')

def test_cloudinit_dockerverse():
    test_url = 'http://localhost:6067/cloudinit/docker'
    response = client.get(test_url)
    assert response.status_code == 200
    assert 'runcmd' in response.content.decode('utf-8')

def test_download_files():
    test_url = 'http://localhost:6067/cloudinit/downloadfiles?file_urls=http%3A%2F%2Ftest.com%2Ffile%2Chttp%3A%2F%2Fmonkey.test%2Fsomething'
    response = client.get(test_url)
    assert response.status_code == 200
    assert "http://test.com/file" in response.content.decode('utf-8')
    assert "http://monkey.test/something" in response.content.decode('utf-8')
    assert "http://zebra.faketset/nothing" not in response.content.decode('utf-8')

def test_bash_placeholder():
    test_url = 'http://localhost:6067/bash/scripts/placeholder.sh?args=monkey'
    response = client.get(test_url)
    assert response.status_code == 200
    assert "monkey" in response.content.decode('utf-8')
    assert "#!/usr/bin/env sh" in response.content.decode('utf-8')
    assert "zebra" not in response.content.decode('utf-8')

def test_bash_list():
    test_url = 'http://localhost:6067/bash/scripts'
    response = client.get(test_url)
    assert response.status_code == 200
    assert response.content.decode('utf-8') is not None
    assert 'placeholder.sh' in response.content.decode('utf-8')
    assert 'monkey.sh' not in response.content.decode('utf-8')
