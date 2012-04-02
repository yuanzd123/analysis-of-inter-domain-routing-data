#! /usr/bin/perl -w 
while(<>){
	while(/(string(\d{1,3}))/g){
		print "$1\n" if $2 <= 100;
	}
}

#FH1 = open "abc.txt";
@FilesToRead = ("ribfinal4920000I.dat","ribfinal4920000II.dat","ribfinal4920000III.dat");
#open(FH1,"outputRib.dat")|| die "can not open the file \n";
#open(FH1,"RibAsciiFileAS209_6.dat")|| die "can not open the file \n";
#open(FH1,"RibAsciiFile100000lines.dat")|| die "can not open the file \n";
#open(FH1,"RibAsciiFile640000lines.dat")|| die "can not open the file \n";
#open(FH1,"RibAsciiFile1280000lines.dat")|| die "can not open the file \n";
#open(FH1,"RibAsciiFile2460000lines.dat")|| die "can not open the file \n";
#open(FH1,"RibAsciiFile4920000lines.dat")|| die "can not open the file \n";
#open(FH1,"RibAsciiFile9840000lines.dat")|| die "can not open the file \n";
#open(FH1,"RibAsciiFile19680000lines.dat")|| die "can not open the file \n";

$wordPrefix ="PREFIX";
$wordAS_Path ="AS_PATH";
$count=0;
$subnetStr="";
$preSubnet="";
$nextSubnet="";
$distinctPrefixes=0;
%hashASTable ;

$PrefixVal;
$prefixHome;
%hashPrefixHome ;
$pushAt2 = 0;
$start = time();
foreach my $p (@FilesToRead)
        {
open(FH1,$p)|| die "can not open the file \n";
@abcfile = <FH1>;

foreach $line(@abcfile){
	#print "Line : $line";
	$prefixIndex = index($line,$wordPrefix);
	$as_pathIndex = index($line,$wordAS_Path);
	if($pushAt2 ==2){
		$pushAt2 = 0;	
	}

	# add prefixes as keys with homes as last element of AS_PATH.
	if($prefixIndex>=0){
		#print $line;
		#($name,$subnet) = split("\s",$line);
		
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
		
		$pushAt2++;
		if($preSubnet ne $nextSubnet){
			#print "Pre subnet :$preSubnet \t"."next Subnet: $nextSubnet";
			$distinctPrefixes++;
			$subnetStr=$subnetStr."\n".$value;
			
			#add the Distinct Prefix into the Key into hash Table.
			$PrefixVal = $value;
				
			#print "\n PrefixVal : $PrefixVal At $pushAt2";
			if($count>0){
				$preSubnet=$nextSubnet;
			}
		}
		
		$count++;
	}

	if($as_pathIndex>=0){
		my @as_pathValues = split('\s',$line);
		my $as_pathlength = (scalar @as_pathValues);
		$as_pathlength--;
		$pushAt2++;
		$prefixHome = $as_pathValues[$as_pathlength];
		#print " prefixHome : $prefixHome At $pushAt2";
		
		
	}
	#print "pushAt2 : $pushAt2";
	if($pushAt2 == 2) {
		# perform push into hash with this.
		#print "\n\n PrefixVal : $PrefixVal At $pushAt2";
		#print "\n prefixHome : $prefixHome At $pushAt2";
		if( $prefixHome ~~ @{$hashPrefixHome{$PrefixVal}}) { }
		else{
			push @{$hashPrefixHome{$PrefixVal}},$prefixHome;
		}
	}
}

close(FH1);
}
#file processing closes here
$prefixesMultiHomed = 0;
%SingleHomedPrefixes;
%MultiHomedPrefixes;
print "\n Prefix : Homes ";

foreach $key ( keys %hashPrefixHome){
	print "\n $key : @{$hashPrefixHome{$key}} \n";
	$homesForPrefix = scalar @{$hashPrefixHome{$key}};
	if( $homesForPrefix > 1 ){
		$prefixesMultiHomed++;
		print "Prefix : $key is Multihomed by : @{$hashPrefixHome{$key}}";
		push @{$MultiHomedPrefixes{$key}},@{$hashPrefixHome{$key}};
	}else {
		print "Prefix : $key is SingleHomed by : @{$hashPrefixHome{$key}}";
		push @{$SingleHomedPrefixes{@{$hashPrefixHome{$key}}[0]}},$key;
	}
	
}

# end timer
$end = time();

# report
print "\n\nTime taken was ", ($end - $start), " seconds";

print "\n\nFor getting Single-Homed Prefixes from ISP >>> Enter the ISP {AS HOME} Number";
$AS_Numb = <>;
chomp $AS_Numb ;
print "\nPrefixes Singlehomed by $AS_Numb only are :  @{$SingleHomedPrefixes{$AS_Numb}}";
$numOfPrefixes = scalar @{$SingleHomedPrefixes{$AS_Numb}};
print "\nTotal Prefixes Singlehomed by $AS_Numb only are :  $numOfPrefixes ";
print "\n\nNumber of Prefixes Multi-Homed is $prefixesMultiHomed";
print "\nPrefixes Multihomed are as follows :";
print "\n Do you want to see the Multihomed Data ?(y/n)";
$choice = <>;
chomp $choice;
if("y" ~~ $choice){
	foreach $key ( keys %MultiHomedPrefixes){
		print "\n $key : @{$MultiHomedPrefixes{$key}} \n";
	}
}

