FROM nvidia/cuda:10.0-cudnn7-devel

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    ghostscript \
    git \
    graphviz \
    poppler-utils \
    unzip \
    wget \
  && rm -rf /var/lib/apt/lists/*

# install conda
RUN curl -qsSLkO \
    https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-`uname -p`.sh \
  && bash Miniconda3-latest-Linux-`uname -p`.sh -b \
  && rm Miniconda3-latest-Linux-`uname -p`.sh
ENV PATH=/root/miniconda3/bin:$PATH

# install deep_doc_class
WORKDIR /tmp
RUN wget 'https://github.com/Odrec/deep_doc_class/archive/master.zip' && unzip master.zip

RUN mkdir -p /opt/deep_doc_class
WORKDIR /opt/deep_doc_class
RUN mv /tmp/deep_doc_class-master/* .

## remove problematic line; it's a Debian-specific thing
RUN sed -i '/pkg-resources==0.0.0/d' requirements.txt

RUN pip install -r requirements.txt
RUN python -c "import nltk; nltk.download('stopwords')"


VOLUME ["/files", "/results"]
RUN ln -s /files
RUN ln -s /results

WORKDIR /opt/deep_doc_class/src
CMD ["/bin/bash"]
