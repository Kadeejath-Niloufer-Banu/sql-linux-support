#!/bin/bash
##################################################################################
# Script: autosys_global_variables_and_events.sh
# Description: Example template for managing AutoSys global variables and events.
#              Includes commands for setting globals, checking status, and
#              machine online/offline control.
##################################################################################

##############################
# Example: Setting a global variable to DOWN
##############################
sendevent -usr <user> -pw <password> -E SET_GLOBAL -G GLOB.exampleExtraction=down

##############################
# Example: Check status of a global variable
##############################
autorep -G GLOB.exampleExtraction

##############################
# Example: Bringing a machine offline and online
##############################
sendevent -E MACH_OFFLINE -n GLOB.machine_name
sendevent -E MACH_ONLINE -n GLOB.machine_name

##############################
# Example: Variables for different environments
##############################
# Environment A
autorep -G GLOB.envAExtraction
autorep -G GLOB.envABODSextraction

# Environment B
sendevent -E SET_GLOBAL -G GLOB.envBExport=up
autorep -G GLOB.envBExport

# Environment C
sendevent -E SET_GLOBAL -G GLOB.envCBODSLoad=down
autorep -G GLOB.envCBODSLoad

##############################
# Example: PN Environments
##############################
# PN9
sendevent -E SET_GLOBAL -G GLOB.envPN9=up
autorep -G GLOB.envPN9

# PN6
sendevent -E SET_GLOBAL -G GLOB.envPN6=down
autorep -G GLOB.envPN6

##############################
# Example: Bringing multiple services up
##############################
sendevent -E SET_GLOBAL -G GLOB.service1=up
sendevent -E SET_GLOBAL -G GLOB.service2=up

autorep -G GLOB.service1
autorep -G GLOB.service2

##############################
# Example: EDM or BODS variables
##############################
sendevent -E SET_GLOBAL -G GLOB.bodsLoad=up
sendevent -E SET_GLOBAL -G GLOB.bodsLoad6=up
sendevent -E SET_GLOBAL -G GLOB.extraction=up

autorep -G GLOB.bodsLoad
autorep -G GLOB.bodsLoad6
autorep -G GLOB.extraction

##############################
# Example: Bringing global source down
##############################
sendevent -E SET_GLOBAL -G GLOB.source=down
autorep -G GLOB.source

##############################
# Example: Event API call (template)
##############################
# Replace <DATE> with appropriate date, e.g., 2024-01-01
perl /path/to/EventAPI/EventJMS/Events_WS.pl \
  "EVENT_NAME=CORE.ALLOCATIONS.BW;PROCESS_NAME=GLOBAL_ALLOCATION;BATCH_SK=111;ENV_CD=EXAMPLE_ENV;EVENT_SPEC_ATTRIB=NULL;ESPRESSO_TICKET_ID=NULL|CUSTOM_KEY=geo_cd;CUSTOM_VALUE=A;@CUSTOM_KEY=snap_id;CUSTOM_VALUE=0000;@CUSTOM_KEY=reporting_date;CUSTOM_VALUE=<DATE>;@CUSTOM_KEY=data_category;CUSTOM_VALUE=ALLOCATION;@CUSTOM_KEY=signal_avail_ts;CUSTOM_VALUE=<DATE> 23:19:52;"

##############################
# Example: EDMHANAOPS variables (as needed)
##############################
# Placeholder global variable examples
autorep -G GLOB.hanaOps
autorep -G GLOB.hanaCon

##################################################################################
# End of Script
##################################################################################
