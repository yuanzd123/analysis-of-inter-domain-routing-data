#! /usr/bin/perl -w 
while(<>){
	while(/(string(\d{1,3}))/g){
		print "$1\n" if $2 <= 100;
	}
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

#@FilesToRead = ("ribfinal4920000I.dat");
#ribfinal4920000I.dat");
#,"ribfinal4920000II.dat","ribfinal4920000III.dat","ribfinal4920000IV.dat",,"ribfinal4920000V.dat",,"ribfinal4920000VI.dat");
@FilesToRead = ("ribfinal4920000I.dat","ribfinal4920000II.dat","ribfinal4920000III.dat","ribfinal4920000IV.dat","ribfinal4920000V.dat","ribfinal4920000VI.dat");
foreach my $p (@FilesToRead)
        {
open(FH1,$p)|| die "can not open the file \n";
@abcfile = <FH1>;

foreach $line(@abcfile){
	#print "Line : $line";
	$prefixIndex = index($line,$wordPrefix);
	$as_pathIndex = index($line,$wordAS_Path);
	if($as_pathIndex>=0){
		my @as_pathValues = split('\s',$line);
		my $as_pathlength = (scalar @as_pathValues);
		for($i=0; $i<$as_pathlength; $i++){
			#print "\nAS Number : $as_pathValues[$i]\t";
			#check if the AS_Path is in line.

			if($wordAS_Path.":" ne $as_pathValues[$i]){
				
				if(exists($hashASTable{$as_pathValues[$i]})){
					#print "\nExisting AS Key : $as_pathValues[$i]\n";
					if($i>1){
						$j=$i-1;
						$preHashKeyVal = $as_pathValues[$j];
						#print "Precceedor AS".$preHashKeyVal;
						# add the value of current AS to the pervious AS Links
						$IsSameValue = 0;
						if($preHashKeyVal ~~$as_pathValues[$i]){
							#print "Prev value and as value are equal";
							$IsSameValue=1;
						}
						# add the value of current AS to the pervious AS Link
						if($IsSameValue == 0){
																
							#print "\n$preHashKeyVal has Links of  @{$hashASTable{$preHashKeyVal}}";
							# add previous AS in the current AS links
							$DontADD=0;
							foreach $raw_data(@{$hashASTable{$as_pathValues[$i]}})
        						{
                						if (index($raw_data,$as_pathValues[$i]) ge 0)
                						{
                       							# print "\nFound the AS in  @{$hashASTable{$preHashKeyVal}}\n";
									$DontADD=1;
        	        					}
        						}
							if($preHashKeyVal ~~ @{$hashASTable{$as_pathValues[$i]}})
							{
								$DontADD=1;
							}
							if($DontADD==0){
								#$hashASTable{$as_pathValues[$i]} = $preHashKeyVal ;
								push @{$hashASTable{$as_pathValues[$i]}},$preHashKeyVal;
								#print " ADD $preHashKeyVal to $as_pathValues[$i] ";
							}
						}
					}
				}else{
					if($i==1){
						#print("\nFirst hash table key AS: ",join (',',sort keys %hashASTable),"\n");
					}else{
						$j=$i-1;
						#print "j : $j and i : $i";
						$preHashKeyVal = $as_pathValues[$j];
						#print $preHashKeyVal," and ",$as_pathValues[$i];
						$IsSameValue = 0;
						if($preHashKeyVal~~$as_pathValues[$i]){
							#print "Prev value and as value are equal";
							$IsSameValue=1;
						}
						# add the value of current AS to the pervious AS Link
						if($IsSameValue == 0){
																				
							#print "\n$preHashKeyVal has Links of  @{$hashASTable{$preHashKeyVal}}";
					
							# add previous AS in the current AS links
							
								push @{$hashASTable{$as_pathValues[$i]}},$preHashKeyVal;
							
						}
					}				
				     	
				#	print "Added to the Hash table: $as_pathValues[$i]\n ";
				     }
			}
		}
	}


}
close(FH1);
}

# end timer
$end = time();

my @sortHashASTable = sort keys %hashASTable;
print "\nAS Connectivity for All AS\n";
print "AS <-> AS \n";

@keysHashASTable ;

for ($i=0; $i < scalar @sortHashASTable; $i++)
{	
	if ($sortHashASTable[$i] !~ /\{/)
	{
		push(@keysHashASTable, $sortHashASTable[$i]);
	}
}
foreach $key ( @keysHashASTable){

	$ASConnectivity = scalar( @{$hashASTable{$key}} );
	if($ASConnectivity > 0){
			foreach (@{$hashASTable{$key}}) {
 				print "\t $key <-> ".$_;
			}
			
	}
	
	$AverageASConnectivity = $AverageASConnectivity + $ASConnectivity;
	#print "\n AverageASConnectivity  : $AverageASConnectivity \n";
	
}


# report
print "\n\nTime taken was ", ($end - $start), " seconds";
print "\nDifferent AS-AS Connections   : $AverageASConnectivity \n";

