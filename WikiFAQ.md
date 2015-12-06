# Introduction #

FAQ's regarding the problem statement and solution to this problem


# Details #

Add your content here.  Format your content with:
> ## FAQ ##

**Q1. AS number with ‘.’( dot)?**
_Answer)_ AS number with 'dot' is also an AS number. The AS numbers in the form x.y is 32bit AS numbers where x and y are 16bit numbers. Numbers of the form 0.y are exactly the old 16-bit AS numbers, 1.y numbers and 65535.65535 are reserved.

**Q2. As number with ‘{ }’?**
_Answer)_ I speculate that {A,B} means either A or B. Thus, AS PATH 1 2 3 {4,5} 6 could mean ‘AS PATH 1 2 3 4 6’ or ‘AS PATH 1 2 3 5 6’.

**Q3.What is Single-homed?**
_Answer)_ If it is connected to the rest of the network via one provider, it is single-homed.

**Q4.What is Multi-homed?**
_Answer)_ If it is connected to the rest of the network via two different providers, it is multi-homed.

**Q5. Example for question6.**
_Answer)_ Pick a number for ‘A’, say 173. Then what are single-homed prefixes from AS 173. Those prefixed shouldn’t be multi homed to some other AS