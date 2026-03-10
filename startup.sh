# create virtual env
#module load python/3.14.2
#python -m venv crows

# load virtual env
source crows/bin/activate

# connect to jupyterhub
#pip install ipykernel
#python -m ipykernel install --user --name=crows
#venv2jup

# install packages
#pip install tskit
#pip install matplotlib
#module load proj/9.4.1
#module load geos/3.12.0
#pip install cartopy
#pip install snakemake

export XDG_CACHE_HOME=$SCRATCH #so snakemake writes temp files where it is allowed

