Description: 
This tool is used to stop/start EBS apps, enable/disable maintenance, download and apply patch on R12.1.3 and check if a patch is applied or not. This tool is built for Oracle EBusiness Suite R12.13 on Linux X86_64 platform. It is meant for single node application, however it will also work for multinode arhcitecture(one needs to stop/start the other node(s) separately)

Main Script: ebs_apps_patch.sh

Other tool used: getMOSPatch.jar (Please refer https://github.com/MarisElsins/getMOSPatch)

Location: /home/applmgr/scripts/auto_patch (this is also default patch location, which can be changed according to preference or environment)

Below is sequence of steps to download and apply EBS patch through this tool.
•	sh ebs_apps_patch.sh download_patch <PATCH_ID>
•	sh ebs_apps_patch.sh stop_ebs_apps
•	sh ebs_apps_patch.sh enable_maintenance
•	sh ebs_apps_patch.sh apply_patch <PATCH_ID>
•	sh ebs_apps_patch.sh check_patch_applied <PATCH_ID>
•	sh ebs_apps_patch.sh disable_maintenance
•	sh ebs_apps_patch.sh start_ebs_apps

Some important considerations:

1. You have to create defaults file in advance to make this script work
adpatch defaultsfile=$APPL_TOP/admin/$TWO_TASK/adalldefaults.txt

2. You need to update the environment file, APPSLOGIN(apps/<apps password>), PATCH_TOP_DIR, MOSUser & MOSPass as per your environment

3. Assuming we are going to drop previous AutoPatch session, I have used "abandon=yes". Else it will fail with below error

--------------------------
Your previous AutoPatch session did not run to completion.

***
Do you wish to continue with your previous AutoPatch session ?
***

AutoPatch could not find a response to the above prompt
or found an incorrect response in the defaults file.

You must run AutoPatch in an interactive session
and provide a correct value.

------------------------------

4. If patch is already applied, it will fail with below error-

This Patch seems to have been applied already.
Would you like to continue anyway  [N] ? N *

You should check the file
$APPL_TOP/admin/<SID>/log/u<PATCH_ID>_<DATE>.log

for errors.

5. If the defaults file is incomplete or not correctly built, it will throw below eror:
 
The current location of ORACLE executables does not match the one
obtained from the defaults file.

***
Is this the correct database ?
***

AutoPatch could not find a response to the above prompt
or found an incorrect response in the defaults file.

You must run AutoPatch in an interactive session
and provide a correct value.


You should check the file
$APPL_TOP/admin/<SID>/log/u<PATCH_ID>_<DATE>.log

for errors.

6. Make sure you have unzipped the patch on the patch location, else you will end up getting below error -

You have specified /home/applmgr/scripts/auto_patch/<PATCH_ID> as the directory where your Oracle Applications patch has been unloaded.

AutoPatch error:
Unable to change to the patch directory.
