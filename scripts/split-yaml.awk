#!/usr/bin/awk -f

BEGIN { file=1; kind="unknown"; name="unknown" ; metadata=0 ; filename="" }
/---/ { file=file+1; metadata=0 ; kind="unknown"; name="unknown" ; filename="" }
/metadata:/ { metadata=1  }
metadata==0 && /kind:(.*)/ { kind=$2 }
metadata==1 && "unknown"==name && /name:(.*)/ { name=$2 ; metadata=0 }
name!="unknown" && kind!="unknown" && filename=="" { filename=name"-"kind".yaml" ; print "mv "file".yaml "filename }
