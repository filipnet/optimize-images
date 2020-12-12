#!/bin/bash
#
# Script Name   : optimize-images.sh
# Description   : Optimize and Compress JPEG or PNG Images in Linux command line
# Author        : https://github.com/filipnet/optimize-images
# License       : BSD 3-Clause "New" or "Revised" License
# ======================================================================================

renice -n 10 $$ > /dev/null
export LC_ALL=de_DE.utf8
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m' 
BOLD='\e[1m'
NORMAL='\e[0m'

# Check dependencies
command -v jpegoptim >/dev/null 2>&1 || { echo >&2 "Package jpegoptim is required but not installed. Aborting."; exit 1; }
command -v optipng >/dev/null 2>&1 || { echo >&2 "Package optipng is require but not installed. Aborting."; exit 1; }

# Set variables, you can customize them according to their preferences
JPEGOPTIM_ARGS="--strip-all --overwrite --threshold=2 --max=80 --totals --all-progressive"
OPTIPNG_ARGS="-o7 -f4 -strip all -clobber"

# Start optimization and compression
if [ -n "$1" ]; then
    IMAGEFOLDER=$1
    if [ "$2" == "-force" ]; then
        echo -e "${PURPLE}Force optimization and compression of all images${NC}"
	JPGFILES=`find $IMAGEFOLDER -type f -iname *.jp*g`
        PNGFILES=`find $IMAGEFOLDER -type f -iname *.png`
    else
	echo -e "${PURPLE}Optimization and compression of new images${NC}"
	JPGFILES=`find $IMAGEFOLDER -newermt "-24 hours" -type f -iname *.jp*g`
        PNGFILES=`find $IMAGEFOLDER -newermt "-24 hours" -type f -iname *.png`
    fi

    for i in $JPGFILES 
    do
        echo "Optimizing $i"
        jpegoptim $JPEGOPTIM_ARGS $i
    done
    for i in $PNGFILES 
    do
        echo "Optimizing $i"
        optipng $OPTIPNG_ARGS $i
    done
else
    echo -e "${RED}Path parameter was not defined${NC}"
    echo "        Usage: Optimization images newer 24 hours for cronjob batch processing"
    echo -e "                 ${BOLD}optimize-images.sh /path/to/image-directory/${NORMAL}"
    echo "               Force optimization for all images inside given folder"
    echo -e "                 ${BOLD}optimize-images.sh /path/to/image-directory/ -force${NORMAL}"
    echo "Documentation: https://github.com/filipnet/optimize-images/blob/main/README.md"
fi
