#! /usr/sepp/bin/perl -w

use strict;

# v0.5 - <muheim@ee.ethz.ch> - Wed Nov 25 10:16:13 CET 2015
#  - add new packages name and the according amount of data pads
#  - fix pin parsing
# v0.4 - <muheim@ee.ethz.ch> - Thu Dec 11 17:11:42 CET 2014
#  - expand %PACKAGES_PADAM, expand ERROR massage
#    make the read of the chip.io robust
#  - remove the WA for the ordinator libs, start ordinator without path 
# v0.3 - <muheim@ee.ethz.ch> - Fri Sep 26 15:43:35 CEST 2014
#  - changed the ordinator path to designkits 
# v0.2 - <muheim@ee.ethz.ch> - Thu Sep 18 10:38:57 CEST 2014
#  - fix a problem when the input output declaration was on more then one line
# v0.1 - <muheim@ee.ethz.ch> - Tue Sep  9 13:46:59 CEST 2014
#  - create
# 
# todo:
# reorder writing the verilog and calling ordinator so that it can be checked
# before the amount of pads and creating it by "prepare_chip.pl"

# info:
# The output name is generated from the top macro not from the input verilog name.

# ------------------------------------------------------------------------------
# variable definition
my $module     = "";
my $module_end = 0;
my $moduleTop  = "";
my $moduleChip = "";

my $moduledec     = "";
my $moduledec_end = 0;
my @pindec = ();
my $pindec = "";
my $pindec_end = 0;
my @pin = ();
my $pin = "";
my $padam = 0;
my @direction = ();
my @bushigh = ();
my @buslow  = ();

my $PAD_PREFIX = "pad_";
my $PAD_SUFFIX = "";
# packages name and the according amount of data pads
my %PACKAGES_PADAM = ('qfn40_umc65-ninth1', 36, 
                      'qfn40_umc65-ninth1-ep', 32,
                      'qfn56_umc65-ninth2', 48,
                      'qfn56_umc65-ninth2-ep', 44,
                      'qfn64_umc65-ninth4', 52,
                      'qfn64_umc65-mini2', 52,);


# ------------------------------------------------------------------------------
# read arguments and print a help
my ($me) = ($0 =~ m|([^/]*)$|);

if (scalar @ARGV != 1 or $ARGV[0] =~ /-h/){
   print <<MARK;

 Usage: $me top_netlist.v 

    This script can be used to create a chip level netlist from a top level netlist.
    that contains the pad declaration. The script will call the 'ordinator' tool to
    place the pads using a GUI. With the information from the 'ordinator' an io 
    file for encounter will be generated.

    Note: it is mandatory to be in a cockpit structure within ./encounter/src/
 
MARK
exit 1;
} 

my $top_verilog_name = $ARGV[0];



# ------------------------------------------------------------------------------
# open the files
open (VELOG_TOP,     "< ${top_verilog_name}") or die "can not find file: ${top_verilog_name}\n";

# ------------------------------------------------------------------------------
# read the verilog netlist
while (<VELOG_TOP>){

  ## find the module
  if (/^module ([A-Za-z0-9_]+)\s*\(/){
    $module = $1;
    $module_end = 1;
    $moduledec = $_;
    $moduledec_end = 1;

    @pindec = ();

    if (/\)/){
      $moduledec_end = 0;
    }

#print "module:         ".$module."\n";

  } elsif (/^endmodule/ && $module_end){
    $module_end = 0;

  } elsif (/\)/ && $moduledec_end){
    $moduledec = $moduledec.$_;
    $moduledec_end = 0;
  } elsif ($moduledec_end) {
    $moduledec = $moduledec.$_;
  }

  ## find the direction with pin
  if (/^\s*(input|output|inout)(\s|\[)/ && $module ){
    $pindec = $_;
    if (/;$/){
      push (@pindec, $pindec );
      $pindec_end = 0;
    } else {
      $pindec_end = 1;
    }
#print "pindec:         ".$pindec;
  } elsif ( $pindec_end ){
    $pindec = $pindec.$_;
    if (/;$/){
      push (@pindec, $pindec );
      $pindec_end = 0;
    } else {
      $pindec_end = 1;
    }
#print "pindec:         ".$_;
  }
}
close (VELOG_TOP);

# ------------------------------------------------------------------------------
# gife the name to the chip module
$moduleTop  = $module;
$moduleChip = $module;
if ( !( $moduleChip =~  s/top/chip/g ) ) {
  if ( !( $moduleChip =~  s/Top/Chip/g ) ) {
    $moduleChip = "${moduleTop}_chip";
    print "The chip level name will be : $moduleChip\n";
  }
}

# ------------------------------------------------------------------------------
my $filename_specpad=`ls ./specialpads*.v`;

# open the files
open (VELOG_SPECPAD, "< ${filename_specpad}") or die "can not find file: ${filename_specpad}\n".
                                                     "you have to be on encounter/src/.\n";
open (VELOG_CHIP,    "> ./${moduleChip}.v"           ) or die "failed to create file: $!\n";
open (PAD_CHIP,      "> ./${moduleChip}.padlist"     ) or die "failed to create file: $!\n";

# ------------------------------------------------------------------------------
# create a list of the pins
foreach $pindec (@pindec){
  my $pindec_line = $pindec;
  my $direction = "";
  if ($pindec_line =~ /(input|output|inout)/ ){
    $direction = $1;
  } # WA: it is only working in this way!!
  $pindec_line =~ s/(\s*)(input|output|inout)\s*//;
  my $bushigh = "";
  my $buslow  = "";
  if ($pindec_line =~ s/\[(\d+):(\d+)\]\s*//g ) {
    $bushigh = $1;
    $buslow  = $2;
  } else {
    $bushigh = 0;
    $buslow  = 0;
  }
  $pindec_line =~ s/(;|\n)//g; # remuve ";" and "new line" 
  push (@pin , split /,\s*/, $pindec_line);
  for (my $i = $#bushigh; $i <  $#pin; $i++){
    push (@direction , $direction);
    push (@bushigh , $bushigh);
    push (@buslow , $buslow);
  }

}


# ------------------------------------------------------------------------------
# write the verilog netlist
print VELOG_CHIP <<"BUGU";
// Created automatically by prepare_chip.pl
// 

BUGU

$moduledec =~  s/\Q$moduleTop/$moduleChip/g;

# write the module declaration
print VELOG_CHIP $moduledec."\n";

# write the pin declaration
foreach $pindec (@pindec){
  my $pindec_line = $pindec;
  $pindec_line =~ s/(input|output)/inout/g;
  print VELOG_CHIP $pindec_line;

}
# write the wire declaration
#print VELOG_CHIP "  wire   VDD, VDDIO, VSS, VSSIO;\n";
foreach $pindec (@pindec){
  my $wiredec_line = $pindec;
  $wiredec_line =~ s/(input|output|inout)/wire/g;
#  $wiredec_line =~ s/(I|O|IO)(,|\s|;|$)/$2/g;
  $wiredec_line =~ s/_(SB?|DB?|C|RB?|TB?|AB?)(I)(,|\s|;|$)/_$1$3/g;
  $wiredec_line =~ s/_(SB?|DB?|C|RB?|TB?|AB?)(O)(,|\s|;|$)/__$1$3/g;
  print VELOG_CHIP $wiredec_line;

}
print VELOG_CHIP "\n";


# write the pads instantiation
my $i = 0;
foreach my $p (@pin){
  my $w = $p;
#  $w =~ s/(I|O|IO)$//g;
  $w =~ s/_(SB?|DB?|C|RB?|TB?|AB?)(I)(,|\s|;|$)/_$1$3/g;
  $w =~ s/_(SB?|DB?|C|RB?|TB?|AB?)(O)(,|\s|;|$)/__$1$3/g;
  if ($direction[$i]  =~ /(input)/ ){
    if ( $bushigh[$i] ) {
      for (my $j = $bushigh[$i]; $j >= $buslow[$i]; $j--){
        print VELOG_CHIP  "  IUMB ${PAD_PREFIX}${p}${PAD_SUFFIX}_$j ( .DO(1'b0), .DI($w\[$j\]), .PAD($p\[$j\]),.OE(1'b0),\n";
        print VELOG_CHIP  "         .IDDQ(1'b0), .PIN2(1'b0), .PIN1(1'b0), .SMT(1'b0),\n";
        print VELOG_CHIP  "         .PD(1'b0), .PU(1'b0), .SR(1'b0) );\n";
        #print VELOG_CHIP  "         .VDD(VDD), .VDDIO(VDDIO), .VSS(VSS), .VSSIO(VSSIO) );\n";
      }
    
    } else {
      print VELOG_CHIP  "  IUMB ${PAD_PREFIX}${p}${PAD_SUFFIX} ( .DO(1'b0), .DI($w), .PAD($p),.OE(1'b0),\n";
      print VELOG_CHIP  "         .IDDQ(1'b0), .PIN2(1'b0), .PIN1(1'b0), .SMT(1'b0),\n";
      print VELOG_CHIP  "         .PD(1'b0), .PU(1'b0), .SR(1'b0) );\n";
      #print VELOG_CHIP  "         .VDD(VDD), .VDDIO(VDDIO), .VSS(VSS), .VSSIO(VSSIO) );\n";
    }
  } elsif ( $direction[$i]  =~ /(output)/ ) {
     if ( $bushigh[$i] ) {
      for (my $j = $bushigh[$i]; $j >= $buslow[$i]; $j--){
        print VELOG_CHIP  "  IUMB ${PAD_PREFIX}${p}${PAD_SUFFIX}_$j ( .DO($w\[$j\]), .DI(), .PAD($p\[$j\]),.OE(1'b1),\n";
        print VELOG_CHIP  "         .IDDQ(1'b0), .PIN2(1'b1), .PIN1(1'b0), .SMT(1'b0),\n";
        print VELOG_CHIP  "         .PD(1'b0), .PU(1'b0), .SR(1'b0) );\n";
        #print VELOG_CHIP  "         .VDD(VDD), .VDDIO(VDDIO), .VSS(VSS), .VSSIO(VSSIO) );\n";
      }
    
    } else {
      print VELOG_CHIP  "  IUMB ${PAD_PREFIX}${p}${PAD_SUFFIX} ( .DO($w), .DI(), .PAD($p),.OE(1'b1),\n";
      print VELOG_CHIP  "         .IDDQ(1'b0), .PIN2(1'b1), .PIN1(1'b0), .SMT(1'b0),\n";
      print VELOG_CHIP  "         .PD(1'b0), .PU(1'b0), .SR(1'b0) );\n";
      #print VELOG_CHIP  "         .VDD(VDD), .VDDIO(VDDIO), .VSS(VSS), .VSSIO(VSSIO) );\n";
    }
  } else {
    die "ERROR: on the top-level only input or output type of pins allowed";
  }
  $i++;
}


# write the top instantiation
print VELOG_CHIP "  ${moduleTop} i_${moduleTop} (";

# have to be chekt for 36
# write the pad instantiations
if ( $#pin ) {
  foreach my $p (@pin[0 .. $#pin]){
    my $w = $p;
#    $w =~ s/(I|O|IO)$//g;
    $w =~ s/_(SB?|DB?|C|RB?|TB?|AB?)(I)(,|\s|;|$)/_$1$3/g;
    $w =~ s/_(SB?|DB?|C|RB?|TB?|AB?)(O)(,|\s|;|$)/__$1$3/g;
    print VELOG_CHIP ".$p($w), ";
  }
  my $w = $pin[$#pin];
#  $w =~ s/(I|O|IO)$//g;
  $w =~ s/_(SB?|DB?|C|RB?|TB?|AB?)(I)(,|\s|;|$)/_$1$3/g;
  $w =~ s/_(SB?|DB?|C|RB?|TB?|AB?)(O)(,|\s|;|$)/__$1$3/g;
  print VELOG_CHIP ".$pin[$#pin]($w)";
}
print VELOG_CHIP ");\n";

# write the specialpads instantiation
# by reading the specialpads netlist file
while (<VELOG_SPECPAD>){
  print VELOG_CHIP;
}
close (VELOG_SPECPAD);


print VELOG_CHIP "\n";
print VELOG_CHIP "endmodule\n";

close (VELOG_CHIP);

# ------------------------------------------------------------------------------
# write the file with the padlist
$i = 0;
foreach my $p (@pin){
  if ( $bushigh[$i] ) {
    for (my $j = $bushigh[$i]; $j >= $buslow[$i]; $j--){
      print PAD_CHIP  "${p}_$j\n";
      $padam++;
    }
    
  } else {
    print PAD_CHIP  "${p}\n";
    $padam++;
  }
  $i++;
}

close (PAD_CHIP);

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ordinator
`ordinator ${moduleChip}.padlist`;

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
my %pad_num = ();
my $package_name = "";

# ------------------------------------------------------------------------------
# open the file 
open (ORDINATOR,       "< ./${moduleChip}_ord.txt"           ) or die "can not find file: ./${moduleChip}_ord.txt\n";
open (PAD_IO_TEMPLATE, "< ../src/sample/chip.io-template") or die "can not find file:./src/sample/chip.io-template\n";
open (PAD_IO,          "> ./${moduleChip}.io"                ) or die "failed to create file: ./${moduleChip}.io\n";


# ------------------------------------------------------------------------------
# read ordinator file

while (<ORDINATOR>){
  if (/^(\d+)\s([W|S|E|N]\d+)\s([A-Za-z0-9_]+)\s*$/) {
    $pad_num{$1} = ${PAD_PREFIX}.${3}.${PAD_SUFFIX};
  } else {
    foreach my $package (keys %PACKAGES_PADAM){
      if ( /\Q$package/ ){
        $package_name = $package;
      }
    }
  }
}

close (ORDINATOR);

# ------------------------------------------------------------------------------
# check if the input data are consistent



if ( $padam != $PACKAGES_PADAM{$package_name} ) {
  die "ERROR: there is a mismatch of the number of pins between the pads in your netlist\n".
      "       and the amount needed for the package you have chosen\n".
      "       you have to fill up all pads.\n\n".
      "package:                     ". $package_name."\n".
      "pad amount for this package: ". $PACKAGES_PADAM{$package_name}."\n".
      "pin amount in your netlist:  ". $padam."\n";
}
if ( keys( %pad_num ) != $PACKAGES_PADAM{$package_name} ) {
  die "ERROR: there is a mismatch on the number of pads on your ordinator run (placed pads)\n".
      "       and the amount available for your chosen package.\n\n".
      "package:                           ". $package_name."\n".
      "pad amount for this package:       ". $PACKAGES_PADAM{$package_name}."\n".
      "pad amount in your ordinator run:  ". keys( %pad_num )."\n";
}
# ------------------------------------------------------------------------------
# generate PAD IO file


# read the PAD IO file template
while (<PAD_IO_TEMPLATE>){
 if (/^(\s*\(\s*inst name=")(".*#\spin no:\s+(\d+).*)$/) {
   print PAD_IO "$1$pad_num{$3}$2\n";
 } else {
   print PAD_IO $_;
 }

}

close (PAD_IO_TEMPLATE);
close (PAD_IO);


# ------------------------------------------------------------------------------
# debug
#print "\n";
#print "package:         " . $package_name."\n";
#print "size of hash:    " . keys( %pad_num ) . "\n";
#print "pins package:    " . $PACKAGES_PADAM{$package_name}."\n";
#print "pins dec netlist:" . $#pin ."\n";
#print "pins netlist:    " . $padam ."\n";


#print "\n";
#print "moduleTopo:   ".$moduleTop."\n";
#print "moduleChip:   ".$moduleChip."\n";
#print "moduledec:    ".$moduledec."\n";

#foreach my $x (@pindec){
#  print $x;
#}

#print "\n";
#$i = 0;
#foreach my $p (@pin){
#  print "$i\t$direction[$i] [$bushigh[$i]:$buslow[$i]] $p\n";
#  $i++;
#}

