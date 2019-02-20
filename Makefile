SCRIPT_DIR := ./scripts
INIT_SH    := $(SCRIPT_DIR)/init.sh
RM_SH      := $(SCRIPT_DIR)/rm.sh
DOC_SH     := $(SCRIPT_DIR)/doc.sh

usage:
	@echo "[usage] make init project=<new-project-name or /path/to/file.xlsm>"
	@echo "[usage] make rm project=<existing-project-name>"
	@echo "[usage] make doc project=<existing-project-name>"

init:
ifndef project
	@echo "Parameter \`project\` required"
	@echo "[usage] make init project=<new-project-name or /path/to/file.xlsm>"
else
	$(INIT_SH) $(project)
endif

rm:
ifndef project
	@echo "Parameter project required"
	@echo "[usage] make rm project=<existing-project-name>"
else
	$(RM_SH) $(project)
endif

doc:
ifndef project
	@echo "Parameter project required"
	@echo "[usage] make doc project=<existing-project-name>"
else
	@echo "[doc] project: "$(project)
endif

.PHONY: init rm doc
