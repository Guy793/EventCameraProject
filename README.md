EventCameraProject

Installations:
https://www.python.org/downloads/release/python-389/ -> Windows installer (64-bit)

package required:
pytorch 1.8.0
slayercuda 0.0.0
cudatoolkit 10.2.0
visual studio community 2019

installation proccess:
conda create -y -n snn python=3.7
conda activate snn
conda install -y pytorch torchvision cudatoolkit -c pytorch
conda install -y strictyaml tqdm -c conda-forge
conda install -y h5py pyyaml -c anaconda

# Setup for SLAYER
cd slayerpytorch
python setup.py install
cd ..
