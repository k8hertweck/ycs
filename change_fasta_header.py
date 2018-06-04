# Code originally from http://crazyhottommy.blogspot.com.au/2014/07/use-python-to-change-header-of-fasta.html, accessed & modified 18Sept2017
# original author: Tommy Tang
# modified by: Kate Wathen-Dunn

#    The 'SRA-YCSL-trans-annotation-list-27Sep2017.txt' file is a single-column csv table containing the contig name (YCS-contig-#) and the matching 
#    blast description from  hits to the NCBI nr and nt database, as well as to Roseanne Casu's and Nam Hoang's sugarcane transcriptomes. 
#    Contig name and annotation were in the same cell, separated by a space, and with quotation marks removed.
#    The blast hits were filtered for e-value and useful descriptions.

with open ("/data/YCS_DeNovoMaster/DeNovo_Assemblies/final-master-YCS-leaf-transcriptome/sec-SRA-YCSL-trans-annotation-list-27Sep2017.txt", "r") as annotFile:
    annotation_dict = {}
    for line in annotFile:
        line = line.split()
        if line: #test whether it is an empty line
            annotation_dict[line[0]]=line[1:]
        else:
            continue


outfile = open ("/data/YCS_DeNovoMaster/DeNovo_Assemblies/final-master-YCS-leaf-transcriptome/final-SRA-YCSL-trans-annotated.fa", "w")

with open ("/data/YCS_DeNovoMaster/DeNovo_Assemblies/final-master-YCS-leaf-transcriptome/SRA-YCSL-trans.fa", "r") as myfasta:
    for line in myfasta:
        if line.startswith (">"):
            line = line[1:] # skip the ">" character
            line = line.split()
            if line[0] in annotation_dict:
                new_line = ">" + str(line[0]) + " " + " ".join(annotation_dict[line[0]])
                outfile.write ( new_line + "\n")
            else:
                outfile.write ( ">" + " ".join(line) + "  ---NA---" + "\n")
        else:
            outfile.write(line +"\n")


outfile.close() # always remember to close the file.


