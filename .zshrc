# shellcheck shell=sh

{
	SNAZZ_COLORSCHEME='snazzy.colorscheme'

	SNAZZY_COLORSCHEME_PATH="${HOME:?}/.local/share/konsole/${SNAZZ_COLORSCHEME:?}"

	# https://github.com/miedzinski/konsole-snazzy
	# Download if missing
	if
		test \
			! \
			-f \
			"${SNAZZY_COLORSCHEME_PATH:?}"
	then
		curl \
			--fail \
			--output \
			"${SNAZZY_COLORSCHEME_PATH:?}" \
			--proto \
			'=https' \
			--tlsv1.2 \
			"https://raw.githubusercontent.com/miedzinski/konsole-snazzy/master/${SNAZZ_COLORSCHEME:?}"
	fi

	unset \
		-v \
		SNAZZ_COLORSCHEME

	unset \
		-v \
		SNAZZY_COLORSCHEME_PATH
}

#region PATH modification
. \
	"${HOME:?}/.cargo/env"

# 1) uutils' coreutils symlinks 2) Custom 3) Go 4) Python 5) Installed with Deno
PATH="${HOME:?}/uutils-coreutils-symlinks:${HOME:?}/bin:${HOME:?}/go/bin:${HOME:?}/.local/bin:${HOME:?}/.deno/bin:${PATH:?}"

export \
	PATH
#endregion

# Execute after Cargo modifies the PATH
#region ls colors
{
	VIVID_GENERATE_SNAZZY="$(
		vivid \
			generate \
			snazzy
	)"

	LS_COLORS="${VIVID_GENERATE_SNAZZY:?}"

	export \
		LS_COLORS

	unset \
		-v \
		VIVID_GENERATE_SNAZZY
}
#endregion

#region Aliases
. \
	"${HOME:?}/flatpak-aliases.sh"

alias cat='bat --paging=never'

alias less='bat --paging=always'

alias ls='coreutils ls --color=auto'
# https://github.com/eza-community/eza/pull/1155
# alias lsal='eza --all --color auto --header --long'
# alias lsaltr='eza --all --color auto --header --long --sort=modified'

# TODO
alias grep='/usr/bin/grep'

alias vi='kak'
alias vim='kak'

EDITOR='kak'

export \
	EDITOR

VISUAL='kak'

export \
	VISUAL

alias cp='/usr/bin/cp --interactive --verbose'
alias cpv='/usr/bin/cp --verbose'

alias mkdir='mkdir --verbose'

alias mv='/usr/bin/mv --interactive --verbose'
alias mvv='/usr/bin/mv --verbose'

# Prevent force or recursive from being added
alias rm='/usr/bin/rm --interactive --verbose -- '
alias rmf='/usr/bin/rm --force --verbose'
alias rmv='/usr/bin/rm --verbose'

alias rmdir='rmdir --verbose'

alias ksh='/usr/bin/oksh'
alias sh='/usr/bin/oksh'

# These break Zsh
alias echo='coreutils echo'
alias printf='coreutils printf'

{
	TIME_PATH="${HOME:?}/.cargo/bin/time"

	alias time="${TIME_PATH:?}"

	unset \
		-v \
		TIME_PATH
}

# imv is buggy in Wayland
# alias imv='imv-x11'
# Switch to Oculante
alias imv='oculante'

alias code='ELECTRON_OZONE_PLATFORM_HINT=auto code'
#endregion

#region Pager
PAGER='ov'

export \
	PAGER
#endregion

___AMXLPCBW_LECFUNCTION_BOLD="$(
	tput \
		bold
)"

___AMXLPCBW_LECFUNCTION_CLEAR="$(
	tput \
		sgr0
)"

___AMXLPCBW_LECFUNCTION_GREEN="$(
	tput \
		setaf \
		2
)"

___AMXLPCBW_LECFUNCTION_RED="$(
	tput \
		setaf \
		1
)"

lec() {
	(
		LAST_EXIT_CODE="${?:?}"

		if
			coreutils test \
				"${LAST_EXIT_CODE:?}" \
				-eq \
				0
		then
			COLOR="${___AMXLPCBW_LECFUNCTION_GREEN:?}"
			EMOJI='✔️'
			STATUS='succeeded'
		else
			COLOR="${___AMXLPCBW_LECFUNCTION_RED:?}"
			EMOJI='🗙'
			STATUS='failed'
		fi

		EMOJI_GROUP="${COLOR:?}${EMOJI:?}${___AMXLPCBW_LECFUNCTION_CLEAR:?}"
		LAST_EXIT_CODE_GROUP="${___AMXLPCBW_LECFUNCTION_BOLD:?}${LAST_EXIT_CODE:?}${___AMXLPCBW_LECFUNCTION_CLEAR:?}"
		STATUS_GROUP="${___AMXLPCBW_LECFUNCTION_BOLD:?}${COLOR:?}${STATUS:?}${___AMXLPCBW_LECFUNCTION_CLEAR:?}"

		coreutils printf \
			'%s\n' \
			" ${EMOJI_GROUP:?} (exit code: ${LAST_EXIT_CODE_GROUP:?}) Last command ${STATUS_GROUP:?}"

		return \
			"${LAST_EXIT_CODE:?}"
	)
}

#region Key bindings
# "You are probably in vi-Mode, because you have set $EDITOR or $VISUAL to something starting with ‘vi’"
# https://zshwiki.org/home/keybindings/
bindkey \
	-e

# Control + e to search forward in history (e.g. if the desired history item is accidentally passed)
# bindkey \
# 	'^F' \
# 	history-incremental-search-forward

# Control + right arrow key to move to next word
bindkey \
	'^[[1;5C' \
	emacs-forward-word
# Control + left arrow key to move to previous word
bindkey \
	'^[[1;5D' \
	emacs-backward-word
# Delete key to delete a character
# https://superuser.com/questions/997593/why-does-zsh-insert-a-when-i-press-the-delete-key
bindkey \
	'^[[3~' \
	delete-char

# Delete last word with control + backspace
# https://unix.stackexchange.com/questions/94331/how-can-i-delete-a-word-backward-at-the-command-line-bash-and-zsh/94388#94388
bindkey \
	'^H' \
	backward-kill-word
# Delete next word with control + delete
bindkey \
	'^[[3;5~' \
	kill-word

# Shift + tab to go backwards in completion menu
bindkey \
	'^[[Z' \
	reverse-menu-complete

# For https://github.com/zsh-users/zsh-history-substring-search
bindkey \
	'^[[A' \
	history-substring-search-up
bindkey \
	'^[[B' \
	history-substring-search-down

# For https://github.com/zsh-users/zsh-autosuggestions
bindkey \
	'^@' \
	autosuggest-accept
#endregion

#region Options
# https://unix.stackexchange.com/questions/371145/how-can-i-set-zsh-to-use-physical-paths
# Follow symbolic links
setopt \
	CHASE_LINKS
# Save timestamp and duration to history file
setopt \
	EXTENDED_HISTORY
# https://unix.stackexchange.com/questions/669971/zsh-can-i-have-a-combined-history-for-all-of-my-shells
setopt \
	SHARE_HISTORY
# Same as "set -o noclobber"
unsetopt \
	CLOBBER
#endregion

# Fix spelling/typographical errors
zstyle \
	':completion:*' \
	completer \
	_complete \
	_correct \
	_approximate

# Case insensitive completion
zstyle \
	':completion:*' \
	matcher-list \
	'' \
	'm:{a-zA-Z}={A-Za-z}' \
	'r:|=*' \
	'l:|=* r:|=*'

# Highlight current selection in tab complete file/directory menu
zstyle \
	':completion:*' \
	menu \
	select

# Highlight matched characters in completion menu
# ":ma=4;35" part is for changing the style of the currently selected item
zstyle \
	-e \
	':completion:*:default' \
	list-colors \
	'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==35=0}:${(s.:.)LS_COLORS}:ma=4;35")'

#region Control + r with already entered text
# https://unix.stackexchange.com/questions/97843/how-can-i-search-history-with-text-already-entered-at-the-prompt-in-zsh/588742#588742
_custom-history-incremental-search-backward() {
	zle \
		.history-incremental-search-backward \
		${BUFFER}
}

zle \
	-N \
	history-incremental-search-backward \
	_custom-history-incremental-search-backward
#endregion

#region Save history
HISTFILE="${HOME:?}/.histfile"
HISTSIZE=1000000000000000000
SAVEHIST=1000000000000000000
#endregion

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

{
	STARSHIP_INIT_ZSH="$(
		starship \
			init \
			zsh
	)"

	. \
		/dev/stdin \
		0<<z3797a6f7a857ff35102de4a4c2cbd89b
${STARSHIP_INIT_ZSH:?}
z3797a6f7a857ff35102de4a4c2cbd89b

	unset \
		-v \
		STARSHIP_INIT_ZSH
}

# Not needed because of control + e keybinding
# https://stackoverflow.com/questions/12373586/how-to-reverse-i-search-back-and-forth
# "-ixon" is one setting, not four short flags combined
coreutils stty \
	-ixon

# Uninstalled Homebrew
#FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH:?}"

# Hack for https://github.com/dandavison/delta/issues/1022
FPATH="${HOME:?}/.zsh-completions:${FPATH:?}"

autoload \
	-U \
	-z \
	compinit

compinit

# https://superuser.com/questions/696921/how-to-delete-one-directory-level-in-a-command-argument-up-to-a-slash-on-zsh-c
autoload \
	-U \
	-z \
	select-word-style

select-word-style \
	bash

{
	XREMAP_COMPLETIONS_ZSH="$(
		xremap \
			--completions \
			zsh
	)"

	. \
		/dev/stdin \
		0<<z3c2b03088d89a251d1de8c4d15b18527
${XREMAP_COMPLETIONS_ZSH:?}
z3c2b03088d89a251d1de8c4d15b18527

	unset \
		-v \
		XREMAP_COMPLETIONS_ZSH
}

{
	SHELDON_COMPLETIONS_SHELL_ZSH="$(
		sheldon \
			completions \
			--shell \
			zsh
	)"

	. \
		/dev/stdin \
		0<<z3c2b03088d89a251d1de8c4d15b18527
${SHELDON_COMPLETIONS_SHELL_ZSH:?}
z3c2b03088d89a251d1de8c4d15b18527

	unset \
		-v \
		SHELDON_COMPLETIONS_SHELL_ZSH
}

{
	SHELDON_SOURCE="$(
		sheldon \
			source
	)"

	. \
		/dev/stdin \
		0<<z14c555387d2abb5fd4d7b89dd9b8f74d
${SHELDON_SOURCE:?}
z14c555387d2abb5fd4d7b89dd9b8f74d

	unset \
		-v \
		SHELDON_SOURCE
}

SDKMAN_DIR="${HOME:?}/.sdkman"

export \
	SDKMAN_DIR

. \
	"${HOME:?}/.sdkman/bin/sdkman-init.sh"
