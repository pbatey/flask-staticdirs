venv:=source .venv/bin/activate &&

# Note: the default flask port, 5000, is now used by AirPlay
PORT=5001
BUMP=minor

version:=$(shell $(venv) python version.py)


.PHONY: default
default:
	@echo "Usage:"
	@echo "   make serve"
	@echo "   make PORT=$(PORT) serve"
	@echo "   make bump # bump minor version"
	@echo "   make BUMP=major bump"
	@echo "   make BUMP=patch bump"
	@echo "   make test"
	@echo "   make PORT=$(PORT) test"
	@echo "   make deploy"

.venv: .venv/pyvenv.cfg
.venv/pyvenv.cfg: requirements.txt
	python3 -m venv .venv
	$(venv) pip3 install -r requirements.txt | grep -f "already satisfied"

.PHONY: serve test bump
serve: .venv
	@if [ ! nc -z localhost $(PORT) &>/dev/null ]; then echo "port $(PORT) already in use"; exit 1; fi
	$(venv) FLASK_RUN_PORT=$(PORT) FLASK_APP=server.py flask run

test: .venv
	./test.sh $(PORT)

bump:
	bumpversion --allow-dirty \
	  --current-version $(version) \
	  $(BUMP) flask_staticdirs/__init__.py

.PHONY: package deploy
package:
	rm -rf build dist
	$(venv) python3 setup.py sdist bdist_wheel
	tar tzf dist/flask-staticdirs-$(version).tar.gz
	$(venv) twine check dist/*

deploy: test package
	@if git describe --always --dirty | grep "dirty"; then \
	  echo "Will not deploy with uncommitted changes. 🤬"; \
	  exit 1; \
	else \
	  echo twine upload dist/*; \
	  twine upload dist/*; \
	fi