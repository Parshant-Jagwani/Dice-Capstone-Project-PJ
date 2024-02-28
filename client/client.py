import uvicorn                  # pip install uvicorn
from fastapi import FastAPI     # pip install fastapi
import requests
import hashlib

app = FastAPI()

@app.get("/")
def get_home():
    """
    Return the Response from Home Route
    """
    return "This Is client side"

@app.get("/file")
def get_file():
    """
    Connect to the server, receive the file, and verify its integrity
    """
    url = "http://localhost:5000/file"
    response = requests.get(url)

    file_data = response.content[:1024]
    checksum = response.content[1024:].decode()

    calculated_checksum = hashlib.sha256(file_data).hexdigest()

    if calculated_checksum == checksum:
        print("File integrity verified.")
    else:
        print("File integrity check failed.")

    return file_data

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)