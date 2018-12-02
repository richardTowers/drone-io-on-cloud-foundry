#!/bin/sh

set -e -u -o pipefail

parent_dir=$(cd "$(dirname "$0")/.." && pwd)

printf "Drone RPC server: "
read -r drone_rpc_server
printf "Drone RPC secret: "
read -r drone_rpc_secret

cloud_init_file=$parent_dir/tmp/drone-cloud-init.sh
cat <<EOF > "$cloud_init_file"
#!/bin/sh

docker run \\
  --volume=/var/run/docker.sock:/var/run/docker.sock \\
  --volume=/var/lib/drone:/data \\
  --env=DRONE_RPC_SERVER=$drone_rpc_server \\
  --env=DRONE_RPC_SECRET=$drone_rpc_secret \\
  --env=DRONE_RUNNER_CAPACITY=2 \\
  --env=DRONE_LOGS_DEBUG=true \\
  --restart=always \\
  --detach=true \\
  --name=drone \\
  drone/agent:1.0.0-rc.1
EOF

output=$(aws ec2 run-instances --image-id ami-0016c65679adc75f5 --count 1 --security-group-ids sg-0a1b0216ef7084cc0 --instance-type t2.small --key-name towers-drone-demo --user-data "file://$cloud_init_file")
instance_id=$(echo "$output" | jq -r '.Instances[0].InstanceId')

aws ec2 create-tags --resources "$instance_id" --tags "Key=Name,Value=towers-drone-demo"

