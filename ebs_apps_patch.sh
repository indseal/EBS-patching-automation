#!/bin/bash
# +===========================================================================+
# | FILENAME
# |   ebs_apps_patch.sh
# |
# | DESCRIPTION
# |   This script is used to stop/start EBS apps, enable/disable maintenance, download and apply patch on R12.1.3 and check if a patch is applied or not
# |
# | USAGE
# |    sh ebs_apps_patch.sh download_patch <PATCH_ID>
# |    sh ebs_apps_patch.sh stop_ebs_apps
# |    sh ebs_apps_patch.sh enable_maintenance
# |    sh ebs_apps_patch.sh apply_patch <PATCH_ID>
# |    sh ebs_apps_patch.sh check_patch_applied <PATCH_ID>
# |    sh ebs_apps_patch.sh disable_maintenance
# |    sh ebs_apps_patch.sh start_ebs_apps
# |
# | PLATFORM
# |   Linux X86_64
# |
# | NOTES
# |
# | HISTORY
# | Indraneil Seal       03/17/2021      Created
# |
# |
# +===========================================================================+

# Check whether patch is applied
function check_patch_applied {
   sqlplus $APPSLOGIN << EOD
   select bug_number,creation_date,LANGUAGE from ad_bugs where bug_number='$PATCH_ID';
   select name from v\$database;
   exit
EOD
}

# Download patch on server
function download_patch {
    echo "Download patch on server ..."
    java -jar getMOSPatch.jar patch=$PATCH_ID platform=226P MOSUser=username@domain MOSPass=<MOS password>
}

# Apply patch on EBS apps
function apply_patch {
    echo "Apply EBS Apps patch ..."
    cd $ADMIN_SCRIPTS_HOME
    adpatch defaultsfile=${DEFAULTSFILE} logfile=u${PATCH_ID}_`date +\%d\%b\%y`.log patchtop=$PATCH_TOP_DIR/$PATCH_ID driver=u$PATCH_ID.drv interactive=no abandon=yes workers=12
}

# Stop application
function stop_ebs_apps {
    echo "Stop application"
    cd $ADMIN_SCRIPTS_HOME
    ./adstpall.sh $APPSLOGIN || { echo "Stop EBS Apps failed"; exit 1; }
}

# Start application
function start_ebs_apps {
    echo "Start application"
    cd $ADMIN_SCRIPTS_HOME
    ./adstrtal.sh $APPSLOGIN || { echo "Start EBS Apps failed"; exit 1; }
}

# Enable Maintenance Mode
function enable_maintenance {
   echo ###########################
   echo "Enable Maintenance Mode"
   echo ###########################
   sqlplus $APPSLOGIN << EOD
   @$AD_TOP/patch/115/sql/adsetmmd.sql ENABLE
EOD
   echo ###########################
   echo "Enable Maintenance Mode"
   echo ###########################
}

# Disable Maintenance Mode
function disable_maintenance {
   echo ###########################
   echo "Disable Maintenance Mode"
   echo ###########################
   sqlplus $APPSLOGIN << EOD
   @$AD_TOP/patch/115/sql/adsetmmd.sql DISABLE
EOD
   echo ###########################
   echo "Maintenance Mode disabled"
   echo ###########################
}

##########################
#      Main              #
##########################

. $APPL_TOP/APPS<SID>_<hostname>.env

PATCH_TOP_DIR=/home/applmgr/scripts/auto_patch
PATCH_ID=$2
APPSLOGIN=apps/<apps password>
DEFAULTSFILE=$APPL_TOP/admin/$TWO_TASK/adalldefaults.txt

case "$1" in
'enable_maintenance')
   enable_maintenance
;;
'disable_maintenance')
   disable_maintenance
;;
'stop_ebs_apps')
   stop_ebs_apps
;;
'start_ebs_apps')
   start_ebs_apps
;;
'apply_patch')
   apply_patch
;;
'download_patch')
   download_patch
;;
'check_patch_applied')
   check_patch_applied
;;
*)
   echo "Usage: sh ebs_apps_patch.sh [enable_maintenance|disable_maintenance|stop_ebs_apps|start_ebs_apps|apply_patch|download_patch|check_patch_applied] [patch number]"
esac
