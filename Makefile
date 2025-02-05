# Directory di installazione (puoi sovrascrivere PREFIX se vuoi)
PREFIX ?= $(HOME)/.local
BINDIR ?= $(PREFIX)/bin

# Trova tutti gli script che iniziano per xrand- nella cartella bin/
SCRIPTS := $(wildcard bin/xrandr-*)

# Lista degli script con percorso di destinazione
BIN_SCRIPTS := $(patsubst bin/%, $(BINDIR)/%, $(SCRIPTS))

# Target di installazione principale
install: $(BIN_SCRIPTS)
	@echo "Installazione completata in $(BINDIR)"

# Regola pattern: copia ogni script da bin/ a $(BINDIR) preservando il nome
$(BINDIR)/%: bin/%
	@echo "Installo $< in $@"
	@install -Dm755 $< $@

# Target per rimuovere gli script installati (opzionale)
uninstall:
	@for f in $(BIN_SCRIPTS); do \
	  if [ -f $$f ]; then \
	    echo "Rimuovo $$f"; \
	    rm $$f; \
	  fi; \
	done
	@echo "Disinstallazione completata."

# Aggiungi phony per i target non legati a file
.PHONY: install uninstall
