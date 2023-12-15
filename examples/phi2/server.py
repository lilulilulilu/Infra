import torch
import uvicorn
from fastapi import FastAPI
from pydantic import BaseModel
from transformers import AutoTokenizer
from transformers import AutoModelForCausalLM

device = torch.device("cuda")
model = AutoModelForCausalLM.from_pretrained("microsoft/phi-2", torch_dtype="auto", device_map="auto", trust_remote_code=True)
tokenizer = AutoTokenizer.from_pretrained("microsoft/phi-2", trust_remote_code=True)

app = FastAPI()

class QueryBoby(BaseModel):
    query: str
    max_length: str = 512
    
class ResponseBoby(BaseModel):
    answer: str   

@app.post("/generate")
async def generate(body: QueryBoby):
    query = body.query
    max_length = int(body.max_length)
    print(f'max_length:{max_length}')
    input_ids = tokenizer(query, return_tensors="pt", return_attention_mask=False).input_ids.to(device)
    outputs = model.generate(input_ids, 
                            max_length=max_length,
                            top_p = 1, 
                            temperature = 1.0,
                            eos_token_id=50256,
                            bos_token_id=50256,
                            pad_token_id=50256)
    output = tokenizer.batch_decode(outputs)[0]
    answer = output
    return ResponseBoby(answer=answer)


if __name__ == "__main__":
   uvicorn.run(app, host="0.0.0.0", port=6001)
      
# CUDA_VISIBLE_DEVICES=7 nohup python inference.py > inference.log 2>&1 &
