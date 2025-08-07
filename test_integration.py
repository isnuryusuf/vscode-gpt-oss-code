import requests
import time
import subprocess
import sys
import os

def test_backend_api():
    """Test the backend API endpoints"""
    base_url = "http://localhost:8000"
    
    print("Testing backend API...")
    
    # Test root endpoint
    try:
        response = requests.get(f"{base_url}/")
        assert response.status_code == 200
        print("✓ Root endpoint test passed")
    except Exception as e:
        print(f"✗ Root endpoint test failed: {e}")
        return False
    
    # Test creating an item
    try:
        item_data = {
            "name": "Test Item",
            "description": "This is a test item",
            "price": 9.99
        }
        response = requests.post(f"{base_url}/items/", json=item_data)
        assert response.status_code == 200
        created_item = response.json()
        print("✓ Item creation test passed")
    except Exception as e:
        print(f"✗ Item creation test failed: {e}")
        return False
    
    # Test getting items
    try:
        response = requests.get(f"{base_url}/items/")
        assert response.status_code == 200
        items = response.json()
        assert len(items) > 0
        print("✓ Get items test passed")
    except Exception as e:
        print(f"✗ Get items test failed: {e}")
        return False
    
    # Test getting specific item
    try:
        item_id = created_item["id"]
        response = requests.get(f"{base_url}/items/{item_id}")
        assert response.status_code == 200
        item = response.json()
        assert item["id"] == item_id
        print("✓ Get specific item test passed")
    except Exception as e:
        print(f"✗ Get specific item test failed: {e}")
        return False
    
    # Test updating item
    try:
        update_data = {
            "name": "Updated Test Item",
            "description": "This is an updated test item",
            "price": 19.99
        }
        response = requests.put(f"{base_url}/items/{item_id}", json=update_data)
        assert response.status_code == 200
        updated_item = response.json()
        assert updated_item["name"] == "Updated Test Item"
        print("✓ Item update test passed")
    except Exception as e:
        print(f"✗ Item update test failed: {e}")
        return False
    
    # Test deleting item
    try:
        response = requests.delete(f"{base_url}/items/{item_id}")
        assert response.status_code == 200
        print("✓ Item deletion test passed")
    except Exception as e:
        print(f"✗ Item deletion test failed: {e}")
        return False
    
    return True

def main():
    print("FastAPI + Vue + SQLite Boilerplate Integration Test")
    print("=" * 50)
    
    # Test backend API
    if test_backend_api():
        print("\n✓ All backend tests passed!")
        print("\nIntegration test completed successfully!")
        print("\nTo manually test the full application:")
        print("1. Start the backend: cd backend && python main.py")
        print("2. Start the frontend: cd frontend && npm run serve")
        print("3. Visit http://localhost:8080 in your browser")
    else:
        print("\n✗ Some tests failed!")
        sys.exit(1)

if __name__ == "__main__":
    main()