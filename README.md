# docker_ros2_gpu_test
ROS 2をGPUで動かす環境をdockerで構築

## 環境構築
1. `git clone https://github.com/YumaMatsumura/docker_ros2_gpu_test.git`
2. `cd docker_ros2_gpu_test`
3. `./build_docker.sh`

## 実行手順
1. `cd docker_ros2_gpu_test`
2. `./launch_docker.sh`
3. 別のターミナルで`nvidia-smi`で確認すると、GPUが動作していることがわかる。
   GPU環境がローカルに構築されている必要がある。  
