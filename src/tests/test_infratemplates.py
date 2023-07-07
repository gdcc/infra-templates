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
    test_url = 'http://localhost:6067/terraform/azure/variables'
    response = client.post(test_url)
    assert response.status_code == 200
    assert 'test' in response.content.decode('utf-8')
    assert "westeurope" in response.content.decode('utf-8')
    assert 'zebra' not in response.content.decode('utf-8')

def test_outputs_tf():
    test_url = 'http://localhost:6067/terraform/azure/outputs'
    response = client.post(test_url)
    assert response.status_code == 200
    assert 'example_name' in response.content.decode('utf-8')
    assert 'zebra' not in response.content.decode('utf-8')

def test_main_tf():
    test_url = 'http://localhost:6067/terraform/azure/main'
    response = client.post(test_url)
    assert response.status_code == 200
    assert 'example_name' in response.content.decode('utf-8')
    assert 'Basic_A0' in response.content.decode('utf-8')
    assert "1.1.1.1" in response.content.decode('utf-8')
    assert 'Zebra' not in response.content.decode('utf-8')

def test_providers_tf():
    test_url = 'http://localhost:6067/terraform/azure/providers'
    response = client.post(test_url)
    assert response.status_code == 200
    assert 'azurerm' in response.content.decode('utf8')
    assert 'cloudnope' not in response.content.decode('utf-8')

def test_cloudinit_dockerverse():
    test_url = 'http://localhost:6067/cloudinit/docker'
    response = client.post(test_url)
    assert response.status_code == 200
    assert 'runcmd' in response.content.decode('utf-8')

def test_download_files():
    test_url = 'http://localhost:6067/cloudinit/downloadfiles'
    response = client.post(test_url)
    assert response.status_code == 200
    assert "https://example.com/test.py" in response.content.decode('utf-8')
    assert "https://something.eu/example.rb" in response.content.decode('utf-8')
    assert "http://zebra.faketset/nothing" not in response.content.decode('utf-8')

def test_bash_placeholder():
    test_url = 'http://localhost:6067/bash/scripts/placeholder.sh'
    response = client.post(test_url)
    assert response.status_code == 200
    assert "test" in response.content.decode('utf-8')
    assert "#!/usr/bin/env sh" in response.content.decode('utf-8')
    assert "zebra" not in response.content.decode('utf-8')

def test_bash_list():
    test_url = 'http://localhost:6067/bash/scripts'
    response = client.get(test_url)
    assert response.status_code == 200
    assert response.content.decode('utf-8') is not None
    assert 'placeholder.sh' in response.content.decode('utf-8')
    assert 'monkey.sh' not in response.content.decode('utf-8')
