FROM python:3.8

WORKDIR /app

COPY pipeline1.py pipeline1_c.py
COPY Cars.csv Cars.csv 

RUN pip install pandas
RUN python pipeline1_c.py Cars.csv Final.csv

ENTRYPOINT [ "bash" ]