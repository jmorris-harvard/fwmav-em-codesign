#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [ -d "venv" ]; then
  echo "virtual environment already exists"
else
  echo "creating virtual environment..."
  python3 -m venv venv
fi

source "venv/bin/activate"
python -m pip install --upgrade pip
if [ -f "requirements.txt" ]; then
  python -m pip install -r requirements.txt
else
  echo "no requirements.txt found"
fi

echo "Setup complete."

# build wing/actuator options
python3 "$SCRIPT_DIR/mechanical_options.py"

# correct thrust capabilities
python3 "$SCRIPT_DIR/passive.py" --file "$SCRIPT_DIR/mechanical-options.csv"

# add external components
python3 "$SCRIPT_DIR/external.py" --file "$SCRIPT_DIR/mechanical-options-pruned.csv" --additional "$SCRIPT_DIR/static/external-xt018.csv"

# add tapped boost power circuit
python3 "$SCRIPT_DIR/tapped_boost.py" --file "$SCRIPT_DIR/mechanical-options-pruned-external-xt018.csv" --split

# OR add charge pump power circuit
python3 "$SCRIPT_DIR/charge_pump.py" --file "$SCRIPT_DIR/mechanical-options-pruned-external-xt018.csv" --split --process "xt018"
