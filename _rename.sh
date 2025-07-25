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
\cd .. && mv zmk-${before} zmk-${after} && \cd zmk-${after}               # change cwd-name itself

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
    # echo "${path}"
    sed --in-place "s/${before}/${after}/" "${path}"
done

# replace names in files (capital letters)
after_cap=${after^^}                # "foo-bar-baz" --> "FOO-BAR-BAZ"
after_cap=${after_cap//-/_}         #               --> "FOO_BAR_BAZ"
after_cap_name=${after_cap:0:15}    #               --> "FOO_B"
grep_res=$(grep -l -r --exclude-dir=.git "${before^^}")
files2=${grep_res}
for path in ${files2[@]}; do
    # echo "${path}"
    sed --in-place "s/\([^\"]\)${before^^}/\1${after_cap}/" "${path}"
    sed --in-place "s/\([\"]\)${before^^}/\1${after_cap_name}/" "${path}"   # for ZMK_KEYBOARD_NAME
done


# print result
diff_exe='diff -u'
git_diff_opt=''
[ $(which difft) ] && diff_exe='difft --display side-by-side-show-both' && git_diff_opt='-c diff.external=difft'

tree_after=$(\tree ${PWD})
eval ${diff_exe} <(echo "${tree_before}") <(echo "${tree_after}")

#git --no-pager ${git_diff_opt} diff
