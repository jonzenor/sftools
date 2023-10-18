#! /bin/bash

while getopts o:n:c: flag
do
	case "${flag}" in
		o) originalOrg=${OPTARG};;
		n) newOrg=${OPTARG};;
		c) apexClass=${OPTARG};;
	esac
done

echo "Comparing Apex Class ${apexClass} between $originalOrg and $newOrg.";
sfdx project retrieve start --target-org ${originalOrg} --metadata ApexClass:${apexClass} -r /tmp/sandbox/${originalOrg}/
sfdx project retrieve start --target-org ${newOrg} --metadata ApexClass:${apexClass} -r /tmp/sandbox/${newOrg}/

echo ""
echo "========== DIFFING FILES =========="
echo "Command: diff /tmp/sandbox/${originalOrg}/classes/${apexClass}.cls /tmp/sandbox/${newOrg}/classes/${apexClass}.cls"
echo ""
echo "========== STARTING DIFF =========="
echo ""
diff /tmp/sandbox/${originalOrg}/classes/${apexClass}.cls /tmp/sandbox/${newOrg}/classes/${apexClass}.cls
echo ""
echo "========== END OF DIFF =========="
echo ""

echo ""
echo "========== DIFFING META FILES =========="
echo "Command: diff /tmp/sandbox/${originalOrg}/classes/${apexClass}.cls-meta.xml /tmp/sandbox/${newOrg}/classes/${apexClass}.cls-meta.xml"
echo ""
echo "========== STARTING DIFF =========="
echo ""
diff /tmp/sandbox/${originalOrg}/classes/${apexClass}.cls-meta.xml /tmp/sandbox/${newOrg}/classes/${apexClass}.cls-meta.xml
echo ""
echo "========== END OF DIFF =========="
echo ""
