#!/usr/bin/env bash
#
# A wrapper script aiming to make Git flow work even easier. 
#
# Assumed knowledges:
#   1) Git VCS  - https://git-scm.com/
#   2) Git flow - https://github.com/nvie/gitflow
#

usage() {
    echo "Usage: $(basename $0) [-h] -t <ticket> -g <gitflow_subcmd> -s|-f [-c <commit_comments>]"
    echo 
    echo "  -h, show command usage"
    echo "  -t, set the ticket (branch), e.g. 'PROJ-1234'"
    echo "  -g, set the gitflow subcommand type, i.e. 'feature' or 'hotfix'"
    echo "  -s, set gitflow subcommand to 'start' "
    echo "  -f, set gitflow subcommand to 'finish'"
    echo "  -c, set git commit comments, used with option '-f'"
    echo
    echo "Examples:"
    echo "  $(basename $0) -t PROJ-1234 -g feature -s"
    echo "  $(basename $0) -t PROJ-1234 -g feature -f -c 'commit comment'"
    echo
    exit 1
}

echo
while getopts ":ht:g:sfc:" opt; do 
    case $opt in
        h)
            usage
            ;;
        t)
            echo -e "[ticket (used as branch name)]:\n\t'$OPTARG'" >&2
            branch=$OPTARG
            ;;
        g)
            echo -e "[gitflow subcommand type]:\n\t'$OPTARG'" >&2
            subcmd_type=$OPTARG 
            ;;
        s)
            echo -e "[gitflow subcommand]:\n\t'start'" >&2
            subcmd='start'
            ;;
        f)
            echo -e "[gitflow subcommand]:\n\t'finish'" >&2
            subcmd='finish'
            ;;
        c)
            echo -e "[git commit comments]:\n\t'$OPTARG'" >&2
            comment=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument" >&2
            usage
            ;;
    esac
done

gitflow_cmd="git flow $subcmd_type $subcmd $branch"

echo -e "[Git flow command to be executed]:\n\t'$gitflow_cmd'"

# Prompt user of the "side-effect" (or benefit) of the -f (finish) option 
if [ $subcmd == 'finish' ]; then
    echo -e "\n===========\ngit status:\n==========="
    git status
    echo -e "\n============\nNOTE PLEASE:\n============"
    echo -e "All staged & unstaged changes will be committed automatically!!!"
    echo -e "Abort if you prefer to stage or commit your changes manually."
fi

echo
echo "Going to execute above command(s) ..."
echo "Hit 'Enter' to continue, or '^C' to abort"
read input

# Proceed to run the git flow command & preparation steps e.g. commit changes
case $subcmd in 
    start)
        eval $gitflow_cmd
        [[ $? -ne 0 ]] && exit $?

        # Prompt user to run equivalent 'finish' command once change is being done
        echo -e "or\n     $(basename $0) -t $branch -g $subcmd_type -f -c <commit_comments>\n"
        ;;

    finish)
        # Add tracking of newly added files
        [[ -n $(git status | grep "Untracked files:") ]] && git add . 

        # Commit changes (if not manually done yet) in preparation for the git flow command
        [[ -z $comment ]] && echo -e "Please provide commit comments using '-c' option\n" && exit 2
        git commit -a -m "$comment"

        # Run the git flow command
        eval $gitflow_cmd
        [[ $? -ne 0 ]] && exit $?
        ;;

    *)
        echo "Un-supported subcommand '$subcmd'!"
        ;;
esac

echo
