FROM ubuntu

RUN mkdir -p /minigpt
WORKDIR /minigpt

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y python3-pip python3-dev git cmake wget libopencv-dev python3-opencv 

RUN wget -c -q  https://huggingface.co/datasets/maknee/minigpt4-13b-ggml/resolve/main/minigpt4-13B-f16.bin
RUN wget -c -q   https://huggingface.co/datasets/maknee/ggml-vicuna-v0-quantized/resolve/main/ggml-vicuna-13B-v0-q5_k.bin

RUN apt update
RUN apt install -y qt6-base-dev python3-vtk7 libhdf5-serial-dev libglew-dev libfmt-dev

RUN echo ver1
RUN git clone https://github.com/Joshua-Ashton/minigpt4.cpp
WORKDIR /minigpt/minigpt4.cpp

RUN cmake -DMINIGPT4_BUILD_WITH_OPENCV=ON .
RUN cmake --build . --config Release

WORKDIR /minigpt/minigpt4.cpp/minigpt4
RUN pip install -r requirements.txt
RUN pip install -U gradio==3.48.0

CMD ["python3", "webui.py", "/minigpt/minigpt4-13B-f16.bin", "/minigpt/ggml-vicuna-13B-v0-q5_k.bin"]
