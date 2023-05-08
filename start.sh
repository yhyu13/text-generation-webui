#！bin/bash

export PRE_CLI_ARGS="/usr/bin/env"
export CLI_ARGS="--model gpt4-x-vicuna-13B-GPTQ --model_type llama --wbits 4 --groupsize 128 --chat --xformers --sdp-attention"
#export CLI_ARGS="--model stable-vicuna-13B-GPTQ --model_type llama --wbits 4 --groupsize 128 --chat --xformers --sdp-attention"
#export CLI_ARGS="--model llama-30b-supercot-4bit-128g-cuda --model_type llama --wbits 4 --groupsize 128 --chat --xformers --sdp-attention"
#export CLI_ARGS="--model OpenAssistant-SFT-7-Llama-30B-GPTQ --model_type llama --wbits 4 --groupsize 128 --chat --xformers --sdp-attention"
#export CLI_ARGS="--model wizard-vicuna-13B-GPTQ --model_type llama --wbits 4 --groupsize 128 --chat --xformers --sdp-attention"
#export CLI_ARGS="--model chimera-7b-4bit-128g --model_type llama --wbits 4 --groupsize 128 --chat --xformers --sdp-attention"
#export CLI_ARGS="--model llava-13b-v0-4bit-128g --model_type llama --wbits 4 --groupsize 128 --chat --xformers --sdp-attention --extensions llava"

$PRE_CLI_ARGS && python3 server.py ${CLI_ARGS}