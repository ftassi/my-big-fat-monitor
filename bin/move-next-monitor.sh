#!/bin/sh

# Ottieni il workspace attivo
CURRENT_WS=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused).name')

# Ottieni la lista degli output secondo i3
I3_OUTPUTS=$(i3-msg -t get_outputs | jq -r '.[] | select(.active) | .name')

# Trova il monitor attuale secondo i3
CURRENT_OUTPUT=$(i3-msg -t get_workspaces | jq -r ".[] | select(.focused).output")

# # Debugging: stampa informazioni
echo "Current workspace: $CURRENT_WS"
echo "Current output: $CURRENT_OUTPUT"
echo "Available i3 outputs: $I3_OUTPUTS"

# Se non ci sono output disponibili, esci con errore
if [ -z "$I3_OUTPUTS" ]; then
    echo "Errore: Nessun output disponibile."
    exit 1
fi

# Trova il prossimo monitor ciclico
NEXT_OUTPUT=""
FOUND=false
for OUTPUT in $I3_OUTPUTS; do
    if [ "$FOUND" = "true" ]; then
        NEXT_OUTPUT=$OUTPUT
        break
    fi
    if [ "$OUTPUT" = "$CURRENT_OUTPUT" ]; then
        FOUND=true
    fi
done

# Se non è stato trovato il prossimo output, prendi il primo (ciclo)
if [ -z "$NEXT_OUTPUT" ]; then
    NEXT_OUTPUT=$(echo "$I3_OUTPUTS" | head -n 1)
fi

# Se ancora non abbiamo un output valido, esci con errore
if [ -z "$NEXT_OUTPUT" ]; then
    echo "Errore: Nessun output disponibile per spostare il workspace."
    exit 1
fi

echo "Moving workspace to: $NEXT_OUTPUT"

# Sposta il workspace al prossimo monitor
i3-msg "move workspace to output $NEXT_OUTPUT"
