export MASTER_PORT=$((12000 + $RANDOM % 20000))
export OMP_NUM_THREADS=1
echo "PYTHONPATH: ${PYTHONPATH}"
export CUDA_VISIBLE_DEVICES=0,1,2,3
which_python=$(which python)
echo "which python: ${which_python}"
export PYTHONPATH=${PYTHONPATH}:${which_python}
export PYTHONPATH=${PYTHONPATH}:.
echo "PYTHONPATH: ${PYTHONPATH}"

JOB_NAME='l16_25m'
OUTPUT_DIR="$(dirname $0)/$JOB_NAME"
LOG_DIR="$(dirname $0)/logs/${JOB_NAME}"
PARTITION='video'
NNODE=1
NUM_GPUS=4
NUM_CPU=112

# srun -p ${PARTITION} \
#     --job-name=${JOB_NAME} \
#     -n${NNODE} \
#     --gres=gpu:${NUM_GPUS} \
#     --ntasks-per-node=1 \
#     --cpus-per-task=${NUM_CPU} \
    torchrun \
    --nnodes=${NNODE} \
    --nproc_per_node=${NUM_GPUS} \
    --rdzv_backend=c10d \
    tasks/retrieval.py \
    $(dirname $0)/l16.py \
    pretrained_path /datassd2/pretrained_models/Unmasked_Teacher/multimodality/l16_25m.pth \
    output_dir ${OUTPUT_DIR}
