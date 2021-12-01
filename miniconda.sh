# Get conda in our $PATH
export PATH="$HOME/miniconda/bin:$PATH"
export MF="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"

if [ ! -f $HOME/miniconda/envs/prod/bin/python ]; then
    wget -q $MF -O miniconda.sh
    bash miniconda.sh -f -b -p $HOME/miniconda
    . $HOME/miniconda/etc/profile.d/conda.sh
    conda config --set quiet True --set always_yes yes --set changeps1 no
    echo Installing Python Version ${PYTHON_VERSION}
    conda create -n prod python=${PYTHON_VERSION} --file conda_requirements.txt
    conda activate prod
    conda clean -y --all -q
    python -m pip install --upgrade -r pip_requirements.txt
    rm -rf $HOME/miniconda/pkgs/cache/*
fi
. $HOME/miniconda/etc/profile.d/conda.sh
conda activate prod
# Debug printout
conda list
