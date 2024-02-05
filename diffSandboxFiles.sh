#! /bin/bash

type="Apex"
class=""
directory=""
normalizedType="null"
debug=false
file=""

while getopts o:n:f:t:d flag
do
	case "${flag}" in
		o) originalOrg=${OPTARG};;
		n) newOrg=${OPTARG};;
		f) file=${OPTARG};;
		t) type=${OPTARG};;
		d) debug=true;;
	esac
done

## Lowercase comparison
normalizedType=`awk '{print tolower($0)}' <<< ${type}`

case ${normalizedType} in
   apex)
      class="ApexClass"	
      directory="classes"
      ;;

   lwc)
      class="LightningComponentBundle"
      directory="lwc/${file}"
      ;;

   *)
      echo "Invalid Type given"
      exit 0
      ;;
esac

if [ ${file} == "" ]; then
   echo "Class File (-f) not provided."
   exit 1;
fi

if $debug; then
      echo ""
      echo "----------"
      echo "DEBUG VARS"
      echo "----------"
      echo ""
      echo "type = ${type}"
      echo "normalizedType = ${normalizedType}"
      echo "class = ${class}"
      echo "file = ${file}"
      echo "directory = ${directory}"
      echo "originalOrg = ${originalOrg}"
      echo "newOrg = ${newOrg}"
      echo ""
fi

diffFiles () {

   if $debug; then
      echo "DEBUG: diffFiles received value ${1}"
   fi
   
   echo ""
   echo "========== DIFFING FILES =========="
   echo "Command: diff /tmp/sandbox/${originalOrg}/${1} /tmp/sandbox/${newOrg}/${1}"
   echo ""
   echo "========== STARTING DIFF =========="
   echo ""
   diff /tmp/sandbox/${originalOrg}/${1} /tmp/sandbox/${newOrg}/${1}
   echo ""
   echo "========== END OF DIFF =========="
   echo ""
}

echo "Comparing ${class} ${file} between $originalOrg and $newOrg"
sfdx project retrieve start --target-org ${originalOrg} --metadata ${class}:${file} -r /tmp/sandbox/${originalOrg}/
sfdx project retrieve start --target-org ${newOrg} --metadata ${class}:${file} -r /tmp/sandbox/${newOrg}/

if [ ${normalizedType} == "apex" ]; then
   compareFile="${directory}/${file}.cls"

   diffFiles ${compareFile}
   diffFiles ${compareFile}-meta.xml
fi

if [ ${normalizedType} == "lwc" ]; then
   compareFile="${directory}/${file}"

   diffFiles ${compareFile}.html
   diffFiles ${compareFile}.js
   diffFiles ${compareFile}.css
   diffFiles ${compareFile}.js-meta.xml
fi

