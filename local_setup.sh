#！bin/bash

# clone necessary repos
git clone --branch cuda_ooba https://github.com/yhyu13/GPTQ-for-LLaMa.git ./repositories/
git clone https://github.com/wawawario2/long_term_memory.git ./extensions/

ln -s docker/{Dockerfile,docker-compose.yml,.dockerignore} .
cp docker/.env.example .env
