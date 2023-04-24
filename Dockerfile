FROM python:3.11-bullseye

WORKDIR src
COPY src/ .
COPY pyproject.toml ./stub.toml
COPY pyproject.toml .
COPY poetry.lock .

RUN pip install poetry
RUN POETRY_VIRTUALENVS_CREATE=false poetry install

EXPOSE 6067
RUN pip install uvicorn
