#!/bin/bash

kind delete cluster

set -e

NODE_MONITOR_PERIOD=3
NODE_MONITOR_GRACE_PERIOD=15
POD_EVICTION_TIMEOUT=10
NODE_STATUS_UPDATE_FREQUENCY=10
NODE_STATUS_REPORT_FREQUENCY=10
NODE_LEASE_DURATION=10

cat <<-EOF >kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: kind
nodes:
  - role: control-plane
    kubeadmConfigPatches:
      - |
        kind: ClusterConfiguration
        controllerManager:
          extraArgs:
            node-monitor-period: ${NODE_MONITOR_PERIOD}s
            node-monitor-grace-period: ${NODE_MONITOR_GRACE_PERIOD}s
            pod-eviction-timeout: ${POD_EVICTION_TIMEOUT}s
      - |
        kind: KubeletConfiguration
        nodeStatusUpdateFrequency: ${NODE_STATUS_UPDATE_FREQUENCY}s
        nodeStatusReportFrequency: ${NODE_STATUS_REPORT_FREQUENCY}s
        nodeLeaseDurationSeconds: ${NODE_LEASE_DURATION}
  - role: worker
    kubeadmConfigPatches:
      - |
        kind: KubeletConfiguration
        nodeStatusUpdateFrequency: ${NODE_STATUS_UPDATE_FREQUENCY}s
        nodeStatusReportFrequency: ${NODE_STATUS_REPORT_FREQUENCY}s
        nodeLeaseDurationSeconds: ${NODE_LEASE_DURATION}
  - role: worker
    kubeadmConfigPatches:
      - |
        kind: KubeletConfiguration
        nodeStatusUpdateFrequency: ${NODE_STATUS_UPDATE_FREQUENCY}s
        nodeStatusReportFrequency: ${NODE_STATUS_REPORT_FREQUENCY}s
        nodeLeaseDurationSeconds: ${NODE_LEASE_DURATION}
  - role: worker
    kubeadmConfigPatches:
      - |
        kind: KubeletConfiguration
        nodeStatusUpdateFrequency: ${NODE_STATUS_UPDATE_FREQUENCY}s
        nodeStatusReportFrequency: ${NODE_STATUS_REPORT_FREQUENCY}s
        nodeLeaseDurationSeconds: ${NODE_LEASE_DURATION}
  - role: worker
    kubeadmConfigPatches:
      - |
        kind: KubeletConfiguration
        nodeStatusUpdateFrequency: ${NODE_STATUS_UPDATE_FREQUENCY}s
        nodeStatusReportFrequency: ${NODE_STATUS_REPORT_FREQUENCY}s
        nodeLeaseDurationSeconds: ${NODE_LEASE_DURATION}
  - role: worker
    kubeadmConfigPatches:
      - |
        kind: KubeletConfiguration
        nodeStatusUpdateFrequency: ${NODE_STATUS_UPDATE_FREQUENCY}s
        nodeStatusReportFrequency: ${NODE_STATUS_REPORT_FREQUENCY}s
        nodeLeaseDurationSeconds: ${NODE_LEASE_DURATION}
EOF

cat kind-config.yaml

time kind create cluster --config=kind-config.yaml

kubectl get nodes
docker ps


echo "------- kill things -------"


time_kill() {
  docker pause $1
  time kubectl wait --for condition=ready=unknown node/$1 --timeout=10m &
  #TODO: wait for a pod to be removed
  wait
}

time_kill kind-worker
time_kill kind-worker2
time_kill kind-worker3
time_kill kind-worker4
time_kill kind-worker5