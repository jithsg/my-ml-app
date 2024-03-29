install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

test:
	python -m pytest -vv --cov=cli --cov=mlib --cov=utilscli --cov=app test_mlib.py

format:
	black *.py

lint:
	pylint --disable=R,C,W1203,E1101 mlib cli utilscli
	
	#docker run --rm -i hadolint/hadolint < Dockerfile

build:
	docker build -t mlops .

run:
	#run docker image
	docker run -p 127.0.0.1:8080:8080 mlops

deploy:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 185183796631.dkr.ecr.us-east-1.amazonaws.com
	docker build -t my-mlopss-app .
	docker tag my-mlopss-app:latest 185183796631.dkr.ecr.us-east-1.amazonaws.com/my-mlopss-app:latest
	docker push 185183796631.dkr.ecr.us-east-1.amazonaws.com/my-mlopss-app:latest

all: install lint test format build deploy