import torch
import biotite.structure.io as bsio
from fastapi import FastAPI
from fastapi.responses import FileResponse
from pydantic import BaseModel
import os
import tempfile

app = FastAPI()

class SequenceInput(BaseModel):
    sequence: str

model = torch.hub.load("facebookresearch/esm:main", "esmfold_v1")
model = model.eval().cuda()
print("Model is ready for predictions")

@app.post("/predict")
async def predict(input: SequenceInput):
    sequence = input.sequence
    with torch.no_grad():
        output = model.infer_pdb(sequence)
    
    with tempfile.NamedTemporaryFile(delete=False, suffix=".pdb") as temp_file:
        temp_file.write(output.encode())
        temp_file_path = temp_file.name
    
    struct = bsio.load_structure(temp_file_path, extra_fields=["b_factor"])
    print(f"Mean pLDDT: {struct.b_factor.mean()}")
    
    return FileResponse(temp_file_path, media_type="chemical/x-pdb", filename="result.pdb")
