FROM python:3.10

# RUN apt update
# RUN apt install python3-pip -y

WORKDIR /app

COPY . .

RUN pip install --cache-dir=/home/cache -r requirements.txt

EXPOSE 5000

CMD ["python3 ./api.py"]

