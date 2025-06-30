#!/bin/bash
################################################################################
# gbi_connection_and_event_publish.sh
#
# Description:
#   This script provides example SQL queries and curl commands
#   to help retrieve connection information and publish UDM events
#   via REST API.
#
# Usage:
#   Replace the placeholders in the SQL queries or curl payload as needed.

################################################################################

##########################
# CONNECTION QUERIES
##########################

echo "Sample SQL queries for connection string checks:"

cat << 'EOF'
-- Check number of processes using a specific source DB server
SELECT COUNT(DISTINCT process_sk)
FROM gbi_metadata_owner.GBI_ENTITY_ATTRIBUTE_USER_VW
WHERE UPPER(SOURCE_DB_SERVER) = UPPER('<SOURCE_DB_SERVER>');

-- Check process environment datastore
SELECT * 
FROM gbi_process_env_datastore
WHERE process_sk = <PROCESS_SK>;

-- Get source and target details
SELECT SOURCE_DB_SERVER, SOURCE_DB_PORT, SOURCE_DB,
       SOURCE_ENTITY, TARGET_DB, TARGET_ENTITY
FROM gbi_metadata_owner.GBI_ENTITY_ATTRIBUTE_USER_VW
WHERE process_sk = <PROCESS_SK>
AND ROWNUM = 1;

-- Check datastore by host
SELECT DATASTORE_SK, DATASTORE_NAME, CONNECTION_STRING, PORT
FROM gbi_datastore
WHERE UPPER(HOST_NAME) = UPPER('<HOST_NAME>');

-- Check credentials
SELECT * 
FROM gbi_metadata_owner.gbi_env_datastore_cred
WHERE DATASTORE_SK = <DATASTORE_SK>;

-- Get decrypted password example
SELECT gbi_metadata_owner.gbi_etl_api.decrypt_pwd('<ENCRYPTED_PWD>', '<KEY>')
FROM dual;
EOF

echo
echo "----------------------------------------------------------------------"
echo "Sample queries section printed. Customize placeholders as needed."
echo "----------------------------------------------------------------------"
echo

##########################
# EVENT PAYLOAD TEMPLATE
##########################

echo "Sample UDM event JSON payload (replace placeholders):"

cat << 'EOF'
{
  "databaseID": null,
  "eventType": <EVENT_TYPE>,
  "eventTypeName": "<EVENT_TYPE_NAME>",
  "processID": <PROCESS_ID>,
  "environmentID": "<ENV_ID>",
  "applicationID": 0,
  "batchID": "<BATCH_ID>",
  "eventSpecAttrib": "NULL",
  "espressoTicketID": "0",
  "priority": 2,
  "status": "PENDING",
  "createTime": <CREATION_TS>,
  "updateTime": <UPDATE_TS>,
  "triggerTime": <TRIGGER_TS>,
  "errorMessage": null,
  "payloadList": [
    {
      "payloadItems": [
        {"key": "FILE_OVERWRITE_IND", "value": "N", "type": null, "format": null},
        {"key": "REQUEST_ID", "value": "<REQUEST_ID>", "type": null, "format": null},
        {"key": "FILE_NAME", "value": "<FILE_NAME>", "type": null, "format": null},
        {"key": "TABLE_NAME", "value": "<TABLE_
