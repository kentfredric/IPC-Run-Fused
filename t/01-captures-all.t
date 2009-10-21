#
#===============================================================================
#
#         FILE:  01-captures-all.t
#
#  DESCRIPTION:
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Kent Fredric (theJackal), <kentfredric@gmail.com>
#      COMPANY:
#      VERSION:  1.0
#      CREATED:  21/10/09 13:03:21 NZDT
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Test::More tests => 4;
use FindBin;

# NOTE: This test is hard to guarantee, its possibly random.

my $output = "w0w1w2w3w4w5w6w7w8w9w10\n" x 6 .
  join '', map { "<<$_>>\np0p1p2p3p4p5p6p7p8p9p10\n" } 0 .. 5;

use IPC::Run::Fused qw( run_fused );

for ( 1 .. 4 ){
  my $str = '';

  run_fused my $fh, $^X, "$FindBin::Bin/tbin/01.pl" or die "$@";

  while( my $line = <$fh> ){
    $str .= $line;
  }

  is( $str, $output, 'Captures All');
}
