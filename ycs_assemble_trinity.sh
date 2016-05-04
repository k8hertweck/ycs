# calls assemble_trinity from TACC to write optimized scripts for trinity assembly
# runs five dependent scripts in series, two largemem and three normal, listed in submission.list
# example output scripts in assembly_trinity/

assemble_trinity -l left.norm.fq -r right.norm.fq -o trinity_out_dir -a ycs -e k8hertweck@gmail.com --no-run

# inspect resulting scripts before running with `submit_launchers submission.list`
