# Stacks

Services that will run with various stacks using `docker-compose.yaml` and managed via [Portainer-CE](https://docs.portainer.io/start/install-ce).

## Instructions

1. On the host machine, start [Portainer](portainer/docker-compose.yaml),
2. Add a new source for GitOps in Portainer UI,
   1. Source name: kwame-mintah
   2. Repository URL: https://github.com/kwame-mintah/raspberry-pi-squiggles
   3. Authentication: False
3. Then '+ Add Stack' for each stack listed in the directory with polling set to `15m`.
   1. [monitoring](/montoring/docker-compose.yaml): stacks/monitoring/docker-compose.yaml
   2. [registry](/registry/docker-compose.yaml): stacks/registry/docker-compose.yaml
   3. [services](/services/docker-compose.yaml): stacks/services/docker-compose.yaml

## Note

Portainer agent was not installed on the host machine. Portainer stack management is limited via the Portainer UI.
