
PROJECT_NAME = bmo

help:  ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

clean:  ## Clean python bytecodes, optimized files, cache, coverage...
	@find . -name "*.pyc" | xargs rm -rf
	@find . -name "*.pyo" | xargs rm -rf
	@find . -name "__pycache__" -type d | xargs rm -rf
	@find . -name ".cache" -type d | xargs rm -rf
	@find . -name ".coverage" -type f | xargs rm -rf
	@find . -name ".pytest_cache" -type d | xargs rm -rf
	@echo 'Temporary files deleted'

requirements-pip:  ## Install the app requirements
	@pip install --upgrade pip
	@pip install -r requirements/development.txt

test: clean ## Run the test suite
	export HOST='sqlite:///:memory:' && py.test  . -s -vvv

coverage: clean  ## Run the test coverage report
	export HOST='sqlite:///:memory:' && py.test --cov . --cov-report term-missing

lint: clean  ## Run pylint linter
	@printf '\n --- \n >>> Running linter...<<<\n'
	@pylint ./source/*
	@printf '\n FINISHED! \n --- \n'

style:  ## Run isort and black auto formatting code style in the project
	@isort -m 3 -tc -y
	@black -S -t py37 -l 79 . --exclude '/(\.git|\.venv|env|venv)/'

style-check:  ## Check isort and black code style
	@black -S -t py37 -l 79 --check . --exclude '/(\.git|\.venv|env|venv)/'

crawl: clean  ## Crawl save coins website and populate the database
	@scrapy runspider scrapy/savecoins_spider.py

up:
	docker-compose up -d
