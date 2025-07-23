#!/bin/bash
#
# CAUTION: assumed to execute this script via `./_rename.sh`, otherwise failed
# 

before=${PWD##*/zmk-}       # get cwd-name
after=''

read -p 'New name:' after

echo -n \"${before}\" '-->' \"${after}\"
read -p ', sure? (y/N):' ans

[[ "${ans}" != 'y' ]] && echo 'quit' && exit -1

tree_before=$(\tree ${PWD})

# rename directories
cd .. && mv zmk-${before} zmk-${after} && cd zmk-${after}               # change cwd-name itself

[ -d ./boards/shields/${before} ] && mv ./boards/shields/${before} ./boards/shields/${after}

# rename files
files=$(find . -type f -name "${before}*")
for path in ${files[@]}; do
#    echo "${path}"
    mv "${path}" "${path/$before/$after}"
done

# replace names in files
grep_res=$(grep -l -r --exclude-dir=.git "${before}")
files1=${grep_res}
for path in ${files1[@]}; do
    echo "${path}"
    sed --in-place "s/${before}/${after}/" "${path}"
done

# replace names in files (capital letters)
grep_res=$(grep -l -r --exclude-dir=.git "${before^^}")
files2=${grep_res}
for path in ${files2[@]}; do
    echo "${path}"
    sed --in-place "s/${before^^}/${after^^}/" "${path}"
done


# print result
diff_exe='diff -u'
git_diff_opt=''
[ $(which difft) ] && diff_exe='difft --display side-by-side-show-both' && git_diff_opt='-c diff.external=difft'

tree_after=$(\tree ${PWD})
eval ${diff_exe} <(echo "${tree_before}") <(echo "${tree_after}")

#git --no-pager ${git_diff_opt} diff 

