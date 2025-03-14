VENV_DIR := pi/venv
PYTHON := python3

.PHONY: create-migration
create-migration:
	goose -dir ./api/db/migrations create $(lastword $(MAKECMDGOALS)) sql
%:
	@:

dev-api:
	docker compose -f api/docker/docker-compose.yaml -p weather-station-api up -d 

rpi-image:
	sudo ./pi/scripts/create-image.sh

python-venv:
	@echo "Creating virtual environment..."
	$(PYTHON) -m venv $(VENV_DIR)
	@echo "Virtual environment created. Run 'source venv/bin/activate' to use it."

python-install: python-venv
	@echo "Installing dependencies..."
	$(VENV_DIR)/bin/pip install --upgrade pip
	$(VENV_DIR)/bin/pip install -r pi/scripts/requirements.txt
	@echo "Dependencies installed."

python-clean:
	@echo "Removing virtual environment..."
	rm -rf $(VENV_DIR)
	@echo "Virtual environment removed."