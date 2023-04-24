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


def test_main_tf():
    test_url = 'http://localhost:6067/terraform/azure/main?name=Monkey&vm_size=Standard_A0&security_policy=internal&ssh_ip_whitelist=192.168.0.1'
    response = client.get(test_url)
    assert response.status_code == 200
    from IPython import embed; embed()
    assert 'Monkey' in response.content.decode('utf-8')
    assert 'Standard_A0' in response.content.decode('utf-8')
    #assert "192.168.0.1" in response.content.decode('utf-8')
    assert 'Zebra' not in response.content.decode('utf-8')


