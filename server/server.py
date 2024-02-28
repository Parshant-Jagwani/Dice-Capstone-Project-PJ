import uvicorn                  # pip install uvicorn
from fastapi import FastAPI     # pip install fastapi
import os
import hashlib
import random
import string

app = FastAPI()

@app.get("/")
def get_home():
    """
    Return the Response from Home Route
    """
    return "This Is Server Side."

@app.get("/file")
def get_file():
    """
    Return the file and its checksum
    """
    file_path = "/serverdata/file.bin"
    checksum_path = "/serverdata/checksum.txt"

    if not os.path.exists(file_path):
        with open(file_path, "wb") as f:
            data = ''.join(random.choices(string.ascii_letters + string.digits, k=1024))
            f.write(data.encode())

    with open(file_path, "rb") as f:
        file_data = f.read()

    checksum = hashlib.sha256(file_data).hexdigest()

    with open(checksum_path, "w") as f:
        f.write(checksum)

    return file_data, checksum

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=5000)