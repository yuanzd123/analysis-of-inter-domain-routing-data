# Approach I followed for analysis of the BGP data #


## Details ##

Add your content here.  Format your content with:
**The problem statement has 6 questions, I solved them by using 6 rib files.**


**BGP Data files used are :**
1.	rib.20111001.0000.bz2 (Default) for primary purpose.
2.	rib.20110701.0000.bz2
3.	rib.20110801.0000.bz2
4.	rib.20110901.0000.bz2
5.	rib.20111101.0000.bz2
6.	rib.20111201.0000.bz2

---

_I followed a sequence of steps for obtaining Test files to work on._

**Steps to follow for obtaining test data for analysis of BGP data are as follows:**

1.	The First Step is to Download Data from routeview.org and convert it into ascii format.Download Files from Oregon’s website : [ftp://archive.routeviews.org/route-views.saopaulo/bgpdata/2011.10/RIBS/](ftp://archive.routeviews.org/route-views.saopaulo/bgpdata/2011.10/RIBS/)

2.	Convert the Ribs files downloaded into Ascii Format following the steps:

a.	Download zebra-dump-parser.tgz from http://www.linux.if/~md/software/zebra-dump-parser.tgz

b.	Un-compress Both the above files using following two commands

tar -xzvf zebra-dump-parser.tgz
bzip2 -d rib.20111001.0000.bz2

c.	Now in zebra-dump-parser.pl file change $format = 3 to $format = 1 to obtain the data in correct format.

d.	cat rib.20111001.0000 | time ./zebra-dump-parser.pl > ribascii

e.	Now ribascii is your ascii file on which you do data analysis.

3.	Chop the files into 4920000 lines by using ,$head option in Linux, for optimized performance of the scripts.

4.	Name each block as ("ribfinal4920000I.dat","ribfinal4920000II.dat","ribfinal4920000III.dat","ribfinal4920000IV.dat"<sub>"ribfinal4920000V.dat"</sub>"ribfinal4920000VI.dat") for input for all the scripts.

5.	Place all scripts in the same folder as the one containing the chopped files and run the simultaneous scripts.




