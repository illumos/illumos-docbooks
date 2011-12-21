#!/bin/bash
#
# Attempt to build some set of the various docbooks that we have. Currently the
# only supported  output format is the old OpenSolaris HTML format. Options:
#
#	-o <dir>	Output docbooks in specified directory
#	-d <book>	Build the specified docbook
#	-a		Build every docbook
#

shopt -s xpg_echo

#
# Sometimes users get tricky with things like an aliased ls to ls -l or other
# similar tricky shell mappings. This next line will get rid of them for our
# script so we don't have to worry about them.
#
unalias -a

bld_arg0=$(basename $0)
bld_timestamp=$(date -u "+%Y%m%dT%H%M%SZ")
bld_root="$(dirname $0)/.."
bld_docpath="$bld_root/raw"
bld_defoutpath="$bld_root/output"
bld_jar="SolBookTrans.jar"
bld_jar_path="$bld_root/tools/SolBookTrans/dist/"
bld_sb_type="HTML_Project_Indiana_Style"
bld_cmd_base="java -jar $bld_jar -t $bld_sb_type"

bld_argo=
bld_arga=
bld_argd=
bld_booklist=


function fail
{
	local msg="$*"
	[[ -z "$msg" ]] && msg="failed"
	echo "$bld_arg0: $msg" >&2
	exit 1
}

function usage
{
	[[ $# -ne 0 ]] && echo "$bld_arg0: $@" >&2
	cat <<USAGE >&2
Usage: $bld_arg0 [-o output] [-a | -d book ...]

	-o specify output directory
	-a generate all docbooks
	-d generate specified docbook
	-h show this message
USAGE
	exit 2
}

function check_argd
{
	local arg=$1
	[[ -d $bld_docpath/$arg ]] || fail "can't find docbook $arg in " \
	    "$bld_docpath"
}

function check_req_progs
{
	[[ -f "$bld_jar_path/$bld_jar" ]] || fail \
	    "missing SolBookTrans.jar file"
	which java 2>&1 >/dev/null || fail "missing java executable, check path?"
}

#
# To build this, we need to actually go in and find the actually *.book file in
# the top level directory of the book dir. Once we have that, then we have to
# deal with the peculiarities of the jar file. It expects you to be in the
# directory with all of its resources. To handle that, we do an extra cd into
# that directory and leave it when done.
#
function build_book
{
	local bdir=$1 bfile= cdir=$PWD

	echo "Building book: $bdir"
	echo "Finding docbook file...      \c "
	for b in $bld_docpath/$bdir/*.book; do
		[[ -z $bfile ]] || fail "found multiple *.book defs in $bdir"
		bfile=$b
	done
	echo " $(basename $bfile)"
	echo "Generating HTML output...     \c "
	mkdir $bld_argo/$bdir || fail "failed to make book-specific output" \
	    "directory: $bld_argo/$bdir"
	cd $bld_jar_path
	$bld_cmd_base -s $cdir/$bfile -o $cdir/$bld_argo/$bdir > /dev/null
	[[ $? -eq 0 ]] || fail "failed to build $bdir"
	cd $cdir
	echo "done"
	echo ""
}

while getopts ":o:d:ah" c $@; do
	case "$c" in
	a)
		bld_arga=1
		;;
	d)
		if [[ -z "$bld_argd" ]]; then
			bld_argd=$OPTARG
		else
			bld_argd="$bld_argd $OPTARG"
		fi
		;;
	o)
		bld_argo=$OPTARG
		;;
	h)
		usage
		;;
	:)
		usage "option requires an argument: $OPTARG"
		;;
	*)
		usage "invalid option: $OPTARG"
		;;
	esac
done

[[ -z "$bld_arga" && -z "$bld_argd" ]] && fail \
    "one of -a and -d must be specified"

[[ ! -z "$bld_arga" && ! -z "$bld_argd" ]] && fail \
    "-a and -d are mutually exclusive options"

#
# Sanity check all the books exist and construct the list that we're going to
# actually build.
#
if [[ -z "$bld_arga" ]]; then
	for book in $bld_argd; do
		check_argd $book
	done
fi

#
# Don't actually start creating stuff until we know we're mostly certain we have
# everything we need to build...
#
check_req_progs

#
# Setup our output directory
#
if [[ -z $bld_argo ]]; then
	bld_argo="$bld_defoutpath/$bld_timestamp"
fi

mkdir -p $bld_argo || fail "couldn't make output directory"
echo "Outputting books to $bld_argo"

#
# Build all the books
#
if [[ -z "$bld_arga" ]]; then
	for book in $bld_argd; do
		build_book $book
	done
else
	for book in $bld_docpath/*; do
		build_book $(basename $book)
	done
fi

exit 0
