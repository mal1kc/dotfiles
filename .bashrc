#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
# catpuccin color theme
PS1='[\u@\h \W]\$ '
if [ "$TERM" = "linux" ]; then
	printf %b '\e]P01E1E2E' # set background color to "Base"
	printf %b '\e]P8585B70' # set bright black to "Surface2"

	printf %b '\e]P7BAC2DE' # set text color to "Text"
	printf %b '\e]PFA6ADC8' # set bright white to "Subtext0"

	printf %b '\e]P1F38BA8' # set red to "Red"
	printf %b '\e]P9F38BA8' # set bright red to "Red"

	printf %b '\e]P2A6E3A1' # set green to "Green"
	printf %b '\e]PAA6E3A1' # set bright green to "Green"

	printf %b '\e]P3F9E2AF' # set yellow to "Yellow"
	printf %b '\e]PBF9E2AF' # set bright yellow to "Yellow"

	printf %b '\e]P489B4FA' # set blue to "Blue"
	printf %b '\e]PC89B4FA' # set bright blue to "Blue"

	printf %b '\e]P5F5C2E7' # set magenta to "Pink"
	printf %b '\e]PDF5C2E7' # set bright magenta to "Pink"

	printf %b '\e]P694E2D5' # set cyan to "Teal"
	printf %b '\e]PE94E2D5' # set bright cyan to "Teal"
:'
	\e]P01E1E2E: #1E1E2E (Base)
    \e]P8585B70: #585B70 (Surface2)
    \e]P7BAC2DE: #BAC2DE (Text)
    \e]PFA6ADC8: #A6ADC8 (Subtext0)
    \e]P1F38BA8: #F38BA8 (Red)
    \e]P9F38BA8: #F38BA8 (Bright Red)
    \e]P2A6E3A1: #A6E3A1 (Green)
    \e]PAA6E3A1: #A6E3A1 (Bright Green)
    \e]P3F9E2AF: #F9E2AF (Yellow)
    \e]PBF9E2AF: #F9E2AF (Bright Yellow)
    \e]P489B4FA: #89B4FA (Blue)
    \e]PC89B4FA: #89B4FA (Bright Blue)
    \e]P5F5C2E7: #F5C2E7 (Pink)
    \e]PDF5C2E7: #F5C2E7 (Bright Pink)
    \e]P694E2D5: #94E2D5 (Teal)
    \e]PE94E2D5: #94E2D5 (Bright Teal)
'
	clear
fi


export PATH=$HOME/.local/bin:$PATH
