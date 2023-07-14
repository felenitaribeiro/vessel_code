#!/usr/bin/env bash
set -e

cp -r . /tmp/vessel_code

# test readme
echo "[DEBUG]: testing the clone command from the README:"
clone_command=`cat /tmp/vessel_code/README.md | grep https://github.com/KMarshallX/vessel_code.git`
echo $clone_command
$clone_command

echo "[DEBUG]: testing the miniconda installation from the README:"
get_command=`cat /tmp/vessel_code/README.md | grep miniconda-setup.sh`
echo $get_command
$get_command 

export PATH="/home/runner/miniconda3/bin:$PATH"
source ~/.bashrc

echo "[DEBUG]: testing the conda env build from the README:"
cd vessel_code
condaenv_command=`cat ./README.md | grep environment.yml`
echo $condaenv_command
$condaenv_command

# conda activate in a bash script
source /home/runner/miniconda3/bin/activate
conda init bash

echo "[DEBUG]: testing conda activate command from the README:"
condact_command=`cat ./README.md | grep activate`
echo $condact_command
$condact_command

# settings for data download
mkdir -p ./data/images/
mkdir -p ./data/predicted_labels/
mkdir ./pretrained_models/

pip install osfclient
osf -p nr6gc fetch /osfstorage/twoEchoTOF/raw/GRE_3D_400um_TR20_FA18_TE7p5_14_sli52_FCY_GMP_BW200_32_e2.nii.gz ./data/images/sub-001.nii.gz
#pretrained model download
osf -p abk4p fetch /osfstorage/pretrained_models/manual_ep5000_0621 ./pretrained_models/manual_ep5000_0621
osf -p abk4p fetch /osfstorage/pretrained_models/om1_ep5000_0711 ./pretrained_models/om1_ep5000_0711
osf -p abk4p fetch /osfstorage/pretrained_models/om2_ep5000_0711 ./pretrained_models/om2_ep5000_0711


path_to_images="./data/images/"
echo "Path to images: "$path_to_images""

path_to_output="./data/predicted_labels/"
echo "Path to output: "$path_to_output""

path_to_pretrained_model="./pretrained_models/manual_ep5000_0621"
echo "Path to pretrained model: "$path_to_pretrained_model""

echo "[DEBUG]: testing inference module without preprocessing:"
train_command1=`cat ./documentation/infer_readme.md | grep 'prep_mode 4'`
echo $train_command1
eval $train_command1

echo "[DEBUG]: testing inference module with preprocessing:"
train_command2=`cat ./documentation/infer_readme.md | grep 'prep_mode 1'`
echo $train_command2
eval $train_command2