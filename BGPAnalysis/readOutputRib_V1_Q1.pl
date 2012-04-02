#! /usr/bin/perl -w 
while(<>){
	#while(/(string(\d{1,3}))/g){
	#	print "$1\n" if $2 <= 100;
#	}
}

#FH1 = open "abc.txt";
#open(FH1,"outputRib.dat")|| die "can not open the file \n";
#open(FH1,"RibAsciiFileAS209_6.dat")|| die "can not open the file \n";
#@abcfile = <FH1>;
$wordPrefix ="PREFIX";
$wordAS_Path ="AS_PATH";
$count=0;
$subnetStr="";
$preSubnet="";
$nextSubnet="";
$distinctPrefixes=0;
%hashASTable ;

#start Time
$start = time();
#@FilesToRead = ("outputRib.dat");
@FilesToRead = ("ribfinal4920000I.dat","ribfinal4920000II.dat","ribfinal4920000III.dat","ribfinal4920000IV.dat","ribfinal4920000V.dat","ribfinal4920000VI.dat");

foreach my $p (@FilesToRead)
        {
open(FH1,$p)|| die "can not open the file \n";
@abcfile = <FH1>;

foreach $line(@abcfile){
	#print "Line : $line";
	$prefixIndex = index($line,$wordPrefix);
	if($prefixIndex>=0){
		print $line;
		#($name,$subnet) = split("\s",$line);
#		print "Name : $name\t"."Subnet : $subnet";
		my @values = split('\s',$line);
#		foreach my $val (@values){
#			print "$val\n";
#		}
		($first,$value) = split('\s',$line);
		if($count==0){
			$preSubnet=$value;
		}else{
			$nextSubnet=$value;
		}
		if($preSubnet ne $nextSubnet){
			#print "Pre subnet :$preSubnet \t"."next Subnet: $nextSubnet";
			$distinctPrefixes++;
			$subnetStr=$subnetStr."\n".$value;	
			if($count>0){
				$preSubnet=$nextSubnet;
			}
		}

		$count++;
	}

}
print "Closing file FH1";
close(FH1);
}

# end timer
$end = time();



print "\nDistinct Subnets: $subnetStr\n";
# report
print "\n\nTime taken was ", ($end - $start), " seconds";

print "\nNumber of Distinct prefixes :$distinctPrefixes";

