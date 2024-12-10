# docker-platys-mdp-init
A docker image which can be used to execute curl commands against REST API of supported service instances to initialize it upon startup. Currently the following services are supported:

  * Apache NiFI (`nifi-api.sh` and `nifi-toolkit.sh`)
  * Hashicorp Vault (`vault-api.sh`)
  * Airflow (`airflow-api.sh`)
  * LakeFS (`lakefs-api.sh`)

