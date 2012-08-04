package CalculatePayouts;

use strict;

# Calculates the payouts based on the Buy In price
# 1 = %50
# 2 = %30
# 3 = %20
sub calcPayouts(@)
{
   my %payOuts;
   my $first = .5;
   my $second = .3;
   my $third = .2;
   my $numPlayers = 9;

   foreach my $buyIn (@_)
   {
      $payOuts{$buyIn}{'First'} = $buyIn * $numPlayers * $first;
      $payOuts{$buyIn}{'Second'} = $buyIn * $numPlayers * $second;
      $payOuts{$buyIn}{'Third'} = $buyIn * $numPlayers * $third;
      $payOuts{$buyIn}{'LOST'} = 0;
   }

   return %payOuts;
}
1;
__END__
