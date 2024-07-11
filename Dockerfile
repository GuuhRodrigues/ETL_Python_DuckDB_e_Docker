FROM python:3.12.4
COPY requirements.txt /src/requirements.txt
RUN pip install -r requirements.txt
COPY . /src
WORKDIR /src
RUN poetry install
EXPOSE 8501
ENTRYPOINT ["poetry","run", "streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]