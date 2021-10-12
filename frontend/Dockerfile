FROM python:3.8-alpine

ENV BACKEND='backend'
ENV BACKEND_URI='/getData'

EXPOSE 8080

RUN apk add --update --no-cache gcc

# Install pipenv and compilation dependencies
RUN pip install pipenv

WORKDIR /app

COPY Pipfile .

COPY Pipfile.lock .

RUN PIPENV_VENV_IN_PROJECT=1 pipenv install --deploy

COPY . .

CMD [ "pipenv", "run", "python3", "app.py"]
