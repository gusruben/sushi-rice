
set block "█"
set c1  "\e[38;2;249;38;114m"
set c2 "\e[38;2;96;96;96m"
set c3 "\e[38;2;239;130;76m"

set cols (tput cols)
set size (math $cols / 3)

# constant small
set size_sm 3
set size_bg 3

set blocks_sm (string repeat $block -n $size_sm)
set blocks_bg (string repeat $block -n $size_bg)

echo -e "
$c1 $blocks_sm█$c2$blocks_bg█$c3$blocks_sm
$c1 $blocks_sm$c2█$blocks_bg$c3█$blocks_sm
"

