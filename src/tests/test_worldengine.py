import pytest
from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app=app)

def test_locations():
    response = client.get("/terraform/azure/locations")
    assert response.status_code == 200
