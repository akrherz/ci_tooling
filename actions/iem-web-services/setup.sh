# Run iem-web-services on specified port (arg 1)
set -x
set -e

PORT=${1:-8080}
IEMWS="/opt/iem-web-services"

sudo mkdir -p "$IEMWS"
sudo git clone https://github.com/akrherz/iem-web-services.git "$IEMWS"

# Mamba install what this repo's environment.yml wants
mamba env update -y -n prod -f "$IEMWS/environment.yml"

# Run the iem-web-services
cd $IEMWS
PYTHONPATH=$PYTHONPATH:$(pwd)/src uvicorn \
    --host 0.0.0.0 \
    --port "$PORT" \
    iemws.main:app &
