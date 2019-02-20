SCRIPT_DIR := ./scripts
INIT       := $(SCRIPT_DIR)/init.sh
rm         := $(SCRIPT_DIR)/rm.sh
doc        := $(SCRIPT_DIR)/doc.sh

usage:
	@echo "[usage] make init project=<new-project-name or /path/to/file.xlsm>"
	@echo "[usage] make rm project=<existing-project-name>"
	@echo "[usage] make doc project=<existing-project-name>"

init:
ifndef project
	@echo "Parameter \`project\` required"
	@echo "[usage] make init project=<new-project-name or /path/to/file.xlsm>"
else
	@echo "[init] project: "$(project)
endif

rm:
ifndef project
	@echo "Parameter project required"
	@echo "[usage] make rm project=<existing-project-name>"
else
	@echo "[rm] project: "$(project)
endif

doc:
ifndef project
	@echo "Parameter project required"
	@echo "[usage] make doc project=<existing-project-name>"
else
	@echo "[doc] project: "$(project)
endif

.PHONY: init rm doc
