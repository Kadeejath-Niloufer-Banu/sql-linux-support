# Source autosys bash profile (replace with your own path if different)
. /path/to/autosys.bash.profile

# Aliases for autosys commands (replace <user> and <password>)
alias jr='autorep -usr <user> -pw <password> -J'
alias jd='autorep -usr <user> -pw <password> -q -J'
alias se='sendevent -usr <user> -pw <password> -E'
alias fsj='sendevent -usr <user> -pw <password> -E FORCE_STARTJOB -J'
alias sj='sendevent -usr <user> -pw <password> -E STARTJOB -J'
alias mr='autorep -usr <user> -pw <password> -M'
alias css='sendevent -usr <user> -pw <password> -E CHANGE_STATUS -s SUCCESS -J'
alias kj='sendevent -usr <user> -pw <password> -E KILLJOB -J'
alias joh='sendevent -usr <user> -pw <password> -E JOB_ON_HOLD -J'
alias jof='sendevent -usr <user> -pw <password> -E JOB_OFF_HOLD -J'
alias joi='sendevent -usr <user> -pw <password> -E JOB_ON_ICE -J'
alias joffi='sendevent -usr <user> -pw <password> -E JOB_OFF_ICE -J'
alias ji='autorep -usr <user> -pw <password> -I'
alias jb='autorep -usr <user> -pw <password> -B'
alias jdp='job_depends -usr <user> -pw <password> -c -J'
alias jg='autorep -usr <user> -pw <password> -G'
alias jv='autorep -usr <user> -pw <password> -V'

# Function jrr: runs job report over a range of runs
jrr() {
    from=0
    no_run=10

    if [ $# -eq 2 ]; then
        no_run=$2
    fi

    if [ $# -eq 3 ]; then
        from=$2
        no_run=$3
    fi

    for arg in $(seq $from $no_run); do
        jr $1 -r -$arg | grep "$1"
    done
}

# Function cob: check various jobs (replace job names as needed)
cob() {
    echo "Extraction jobs:"
    jr job_extract_1 | grep job_extract_1
    jr job_extract_2 | grep job_extract_2
    jr job_extract_3 | grep job_extract_3
    echo "**************"
    echo "TRVAL jobs:"
    jr job_trval_1 | grep job_trval_1
    jr job_trval_2 | grep job_trval_2
    echo "**************"
    echo "F2C jobs:"
    jr job_f2c_1 | grep job_f2c_1
    jr job_f2c_2 | grep job_f2c_2
    echo "**************"
    echo "Semantic load triggers:"
    jr job_semantic_trigger_1 | grep job_semantic_trigger_1
    jr job_semantic_trigger_2 | grep job_semantic_trigger_2
    echo "**************"
    echo "Audit jobs:"
    jr job_audit_1 | grep job_audit_1
    jr job_audit_2 | grep job_audit_2
    echo "**************"
    echo "Publishing jobs:"
    jr job_publish_1 | grep job_publish_1
    jr job_publish_2 | grep job_publish_2
    echo "**************"
}

# Export your email id for notifications
export EMAIL_ID=<your_email>

# Source daemon support CLI env if present (replace with actual path if needed)
if [ -f /path/to/.daemon_support_cli_env ]; then
    . /path/to/.daemon_support_cli_env
fi
