FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 as builder

ENV http_proxy http://127.0.0.1:8889
ENV https_proxy=http://127.0.0.1:8889

RUN apt-get update && \
    apt-get install --no-install-recommends -y git vim build-essential python3-dev python3-venv && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/oobabooga/GPTQ-for-LLaMa /build

WORKDIR /build

RUN python3 -m venv /build/venv

# yhyu13 : add mirror
RUN . /build/venv/bin/activate && \ 
    pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip3 config set global.extra-index-url https://download.pytorch.org/whl/cu118

RUN . /build/venv/bin/activate && \
    pip3 install --upgrade pip setuptools wheel && \
    pip3 install torch torchvision torchaudio && \
    pip3 install -r requirements.txt

# https://developer.nvidia.com/cuda-gpus
# for a rtx 2060: ARG TORCH_CUDA_ARCH_LIST="7.5"
ARG TORCH_CUDA_ARCH_LIST="8.6"
RUN . /build/venv/bin/activate && \
    pip3 install wheel && \
    python3 setup_cuda.py bdist_wheel -d .

FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04

ENV http_proxy http://127.0.0.1:8889
ENV https_proxy=http://127.0.0.1:8889

LABEL maintainer="Your Name <your.email@example.com>"
LABEL description="Docker image for GPTQ-for-LLaMa and Text Generation WebUI"

RUN apt-get update && \
    apt-get install --no-install-recommends -y libportaudio2 libasound-dev git python3 python3-pip make g++ && \
    rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/root/.cache/pip pip3 install virtualenv
RUN mkdir /app

WORKDIR /app

ARG WEBUI_VERSION
RUN test -n "${WEBUI_VERSION}" && git reset --hard ${WEBUI_VERSION} || echo "Using provided webui source"

RUN virtualenv /app/venv

# yhyu13 : add mirror
RUN . /app/venv/bin/activate && \ 
    pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip3 config set global.extra-index-url https://download.pytorch.org/whl/cu118

RUN . /app/venv/bin/activate && \
    pip3 install --upgrade pip setuptools wheel && \
    pip3 install torch torchvision torchaudio

COPY --from=builder /build /app/repositories/GPTQ-for-LLaMa
RUN . /app/venv/bin/activate && \
    pip3 install /app/repositories/GPTQ-for-LLaMa/*.whl

COPY extensions/api/requirements.txt /app/extensions/api/requirements.txt
COPY extensions/elevenlabs_tts/requirements.txt /app/extensions/elevenlabs_tts/requirements.txt
COPY extensions/google_translate/requirements.txt /app/extensions/google_translate/requirements.txt
COPY extensions/silero_tts/requirements.txt /app/extensions/silero_tts/requirements.txt
COPY extensions/whisper_stt/requirements.txt /app/extensions/whisper_stt/requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip . /app/venv/bin/activate && cd extensions/api && pip3 install -r requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip . /app/venv/bin/activate && cd extensions/elevenlabs_tts && pip3 install -r requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip . /app/venv/bin/activate && cd extensions/google_translate && pip3 install -r requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip . /app/venv/bin/activate && cd extensions/silero_tts && pip3 install -r requirements.txt
RUN --mount=type=cache,target=/root/.cache/pip . /app/venv/bin/activate && cd extensions/whisper_stt && pip3 install -r requirements.txt

COPY requirements.txt /app/requirements.txt
RUN . /app/venv/bin/activate && \
    pip3 install -r requirements.txt

RUN cp /app/venv/lib/python3.10/site-packages/bitsandbytes/libbitsandbytes_cuda118.so /app/venv/lib/python3.10/site-packages/bitsandbytes/libbitsandbytes_cpu.so

COPY . /app/
ENV CLI_ARGS=""
CMD . /app/venv/bin/activate && python3 server.py ${CLI_ARGS}