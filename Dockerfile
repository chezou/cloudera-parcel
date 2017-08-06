FROM continuumio/miniconda

RUN conda create -y -q --copy -n R_env r-essentials