#!/bin/bash

sudo apt-get install tree

echo "" << ~/.bashrc
echo "# to create g function, stoivo git" << ~/.bashrc
echo "source `cat full_root_path_to_repo`generell.sh" << ~/.bashrc
echo "source `cat full_root_path_to_repo`dark_git_voodoo.sh" << ~/.bashrc
echo "" << ~/.bashrc

