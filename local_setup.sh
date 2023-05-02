#！bin/bash

# clone necessary repos
git clone https://github.com/oobabooga/GPTQ-for-LLaMa.git ./repositories/
git clone https://github.com/wawawario2/long_term_memory.git ./extensions/

git clone https://huggingface.co/wojtab/llava-13b-v0-4bit-128g.git ./models/
git clone https://huggingface.co/anon8231489123/gpt4-x-alpaca-13b-native-4bit-128g.git ./models/

ln -s docker/{Dockerfile,docker-compose.yml,.dockerignore} .
cp docker/.env.example .env
