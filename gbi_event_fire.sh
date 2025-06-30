#!/bin/bash
################################################################################
# gbi_event_fire.sh
#
# Description:
#   Script to fire GBI Events using EventAPI Perl script.
#
# Usage:
#   Update the variables in the "USER PARAMETERS" section below as needed,
#   then execute the script.
################################################################################

##########################
# USER PARAMETERS
##########################

EVENT_NAME="YOUR_EVENT_NAME"
PROCESS_NAME="YOUR_PROCESS_NAME"
BATCH_SK="111"
ENV_CD="YOUR_ENV_CODE"
GEO_CD="YOUR_GEO_CODE"
SNAP_ID="0000"
RPTG_DT="YYYY-MM-DD"
DATA_CATEGORY="YOUR_DATA_CATEGORY"
RPTG_TS="YYYY-MM-DD HH:MM:SS"
ESPRESSO_TICKET_ID="NULL"
EVENT_SPEC_ATTRIB="NULL"

##########################
# PERL SCRIPT PATH
##########################

PERL_SCRIPT="/path/to/GBI_Events_WS.pl"

##########################
# EXECUTION
##########################

echo "================================================================="
echo "Starting GBI Event Fire Script"
echo "================================================================="
echo "EVENT_NAME        : $EVENT_NAME"
echo "PROCESS_NAME      : $PROCESS_NAME"
echo "BATCH_SK          : $BATCH_SK"
echo "ENV_CD            : $ENV_CD"
echo "GEO_CD            : $GEO_CD"
echo "SNAP_ID           : $SNAP_ID"
echo "RPTG_DT           : $RPTG_DT"
echo "DATA_CATEGORY     : $DATA_CATEGORY"
echo "RPTG_TS           : $RPTG_TS"
echo "================================================================="
echo

read -p "Do you want to proceed? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
    echo "Execution cancelled by user."
    exit 1
fi

CMD="perl $PERL_SCRIPT \"EVENT_NAME=$EVENT_NAME;PROCESS_NAME=$PROCESS_NAME;BATCH_SK=$BATCH_SK;ENV_CD=$ENV_CD;EVENT_SPEC_ATTRIB=$EVENT_SPEC_ATTRIB;ESPRESSO_TICKET_ID=$ESPRESSO_TICKET_ID|CUSTOM_KEY=geo_cd;CUSTOM_VALUE=$GEO_CD;@ CUSTOM_KEY=snap_id;CUSTOM_VALUE=$SNAP_ID;@ CUSTOM_KEY=reporting_date;CUSTOM_VALUE=$RPTG_DT;@ CUSTOM_KEY=data_category;CUSTOM_VALUE=$DATA_CATEGORY;@ CUSTOM_KEY=signal_avail_ts;CUSTOM_VALUE=$RPTG_TS;\""

echo "Running Perl command..."
eval $CMD

echo
echo "GBI Event fired successfully!"
echo "================================================================="
