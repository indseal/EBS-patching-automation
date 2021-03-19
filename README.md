Description: 
This tool is used to stop/start EBS apps, enable/disable maintenance, download and apply patch on R12.1.3 and check if a patch is applied or not. This tool is built for Oracle EBusiness Suite R12.13 on Linux X86_64 platform. It is meant for single node application, however it will also work for multinode arhcitecture(one needs to stop/start the other node(s) separately)

Main Script: ebs_apps_patch.sh

Other tool used: getMOSPatch.jar (Please refer https://github.com/MarisElsins/getMOSPatch)

Location: /home/applmgr/scripts/auto_patch (this is also default patch location, which can be changed according to preference or environment)

Below is sequence of steps to download and apply EBS patch through this tool.

Step 1.	sh ebs_apps_patch.sh download_patch <PATCH_ID>

Step 2.	sh ebs_apps_patch.sh stop_ebs_apps

Step 3.	sh ebs_apps_patch.sh enable_maintenance

Step 4. sh ebs_apps_patch.sh apply_patch <PATCH_ID>

Step 5.	sh ebs_apps_patch.sh check_patch_applied <PATCH_ID>

Step 6.	sh ebs_apps_patch.sh disable_maintenance

Step 7.	sh ebs_apps_patch.sh start_ebs_apps

Some important considerations:

1. You have to create defaults file in advance to make this script work
adpatch defaultsfile=$APPL_TOP/admin/$TWO_TASK/adalldefaults.txt

2. You need to update the environment file, APPSLOGIN(apps/<password>), PATCH_TOP_DIR, MOSUser & MOSPass as per your environment

3. If you have a previous adpatch session, the tool will fail. So assuming we are going to drop previous AutoPatch session, I have used "abandon=yes", 

4. The tool will exit if the patch is already applied previously.

5. If the defaults file is incomplete or not correctly built, it will throw eror like " AutoPatch could not find a response to the above prompt or found an incorrect response in the defaults file"

6. Make sure you have unzipped the patch on the patch location, else you will end up getting the error "AutoPatch error: Unable to change to the patch directory"
