#! /usr/bin python
# need to change the above line to suit the path to python on your system

# N50 code originally from Cara Magnabosco was modified by Kate Wathen-Dunn
# https://caramagnabosco.wordpress.com/
# accessed 2nd July 2016, modified 5th July 2016

# Used to calculate the N50 of assembled contigs in a fasta file
# where N50 is the contig length, so that half the bases in the entire
# assembly are found in contigs of this length or below. (Cara M)

# Code also ouptputs the minimum, maximum, mean and median contig lengths
# as well as the total number of assembled bases and number of contigs
# in the assembly fasta file. (Kate WD)

# Execute by: python N50_Stats.py fastafile


from Bio import SeqIO
import sys
import numpy

input = open(sys.argv[1], 'rU')

seqlength = []

for record in SeqIO.parse(input, 'fasta'):
    bp = len(record.seq)
    seqlength.append(bp)

seqlength = sorted(seqlength)

num_contig = len(seqlength)

print ("the number of contigs is: %d" % num_contig)
print ("the min sequence length is: %d" % seqlength[0])
print ("the max sequence length is: %d" % seqlength[-1])

total_bp = sum(seqlength)
mean_contig_length = total_bp/len(seqlength)
median_contig_length = numpy.median(seqlength)

print ("the total assembled bases is: %d" % total_bp)
print ("the mean contig length is: %d" % mean_contig_length)
print ("the median contig length is: %d" % median_contig_length)

unique = []

for entry in seqlength:
    if not entry in unique:
        unique.append(entry)

n50 = []

for entry in unique:
    multiplier = seqlength.count(entry) * entry
    for i in range(multiplier):
        n50.append(entry)

index = len(n50)/2
avg = []

if index % 2 == 0:
    index_int = int(index)
    first = n50[index_int-1]
    second = n50[index_int]
    avg.append(first)
    avg.append(second)
    result = numpy.mean(avg)
    print ("the N50 is : %d" % result)
else:
    index_int = int(index)
    print("the N50 is: %d" % n50[index_int-1])

input.close()

