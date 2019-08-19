#!/usr/bin/env bash
#
# PyQt5 Dash Docset generator
# 

# Install requirments
apt update && apt install -y mercurial python3 python3-pip python3-venv file 2> /dev/null
go get -u github.com/technosophos/dashing

# Create Python venv
python3 -m venv env
source env/bin/activate
pip3 install Sphinx

# Clone docs
hg clone https://www.riverbankcomputing.com/hg/PyQt5Docs --branch=default

# Start
current_dir=`echo $(pwd)`
cd $current_dir/PyQt5Docs/docs/
sphinx-build -b html . out
cd out/
$GOPATH/bin/dashing create
cp $current_dir/icon.png $current_dir/dashing.json $current_dir/PyQt5Docs/docs/out
$GOPATH/bin/dashing build pyqt5 2> /dev/null
tar -cvzf pyqt5.tgz pyqt5.docset
mv pyqt5.tgz $current_dir
FILE=$current_dir/pyqt5.tgz

# Upload
curl -H "Authorization: token $GITHUB_TOKEN" -H "Content-Type: $(file -b --mime-type $FILE)" --data-binary @$FILE "https://uploads.github.com/repos/yshalsager/pyqt5-docset/releases/V5.13/assets?name=$(basename $FILE)"
