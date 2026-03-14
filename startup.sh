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

# for dolores (did this in new env with python v3.11 - wasnt working with 3.14)
#git clone https://github.com/a-ignatieva/dolores.git
#cd dolores/
#module load gcc/12.3
#module load gsl/2.7
#pip install -r requirements.txt
#had to remove brackets from stored_nbytes() in a tscompress file to run the example

