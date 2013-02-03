
use strict;
use warnings;

use Test::More;

if ( $^O eq 'MSWin32' and not $ENV{IPC_RUN_FUSED_FORCE_TEST} ) {
  plan skip_all => 'Known to stall on Win32, set IPC_RUN_FUSED_FORCE_TEST to override';
}
else {
  plan tests => 100;
}

use FindBin;

# NOTE: This test is hard to guarantee, its possibly random.

my $output = "w0w1w2w3w4w5w6w7w8w9w10\n" x 6 . join '', map { "<<$_>>\np0p1p2p3p4p5p6p7p8p9p10\n" } 0 .. 5;

use IPC::Run::Fused qw( run_fused );

my $callback = sub {
  *STDOUT->autoflush(0);
  *STDERR->autoflush(0);
  for my $m ( 0 .. 5 ) {
    print "<<$m>>\n";
    for ( 0 .. 10 ) {
      print {*STDERR} "w$_";
    }
    print {*STDERR} "\n";
    for ( 0 .. 10 ) {
      print {*STDOUT} "p$_";
    }
    print {*STDOUT} "\n";
  }
};

# We do this lots to make sure theres no race conditions.
for ( 1 .. 100 ) {
  my $str = '';
  my $pid = run_fused( my $fh, $callback ) or die "$@";
  while ( my $line = <$fh> ) {
    $str .= $line;
  }
  is( $str, $output, 'Captures All' );
  waitpid( $pid, -1 );
}
