#!/usr/bin/env bash
#
# PyQt5 Dash Docset generator
# 

# Install requirments
apt update && apt install -y mercurial python3 python3-pip python3-venv file
go get -u github.com/technosophos/dashing
go get -u github.com/aktau/github-release

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
cp $current_dir/icon.png $current_dir/dashing.json .
$GOPATH/bin/dashing build pyqt5
tar -cvzf pyqt5.tgz pyqt5.docset
mv pyqt5.tgz $current_dir
cd $current_dir

# Upload to GitHub
$GOPATH/bin/github-release upload -u yshalsager -r pyqt5-docset -t "V5.13" -n pyqt5-$(date +%d.%m.%Y-%R).tgz -f pyqt5.tgz
