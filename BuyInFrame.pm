package BuyInFrame;

use strict;

use Tk;
use Tk::LabFrame;

# Each Buy In will have it's own frame. All its functions are encapsulated
# in this object.
sub new
{
   my $class = shift;
   my $self = {_parent => shift,
               _buyIn  => shift,
               _bg     => shift,
               _frame  => undef,
               _net    => undef,
               Label   => undef,
              };
   bless $self, $class;
   $self->initBuyInFrame();

   return $self;
}


# Sets all the labels and variables associated with this buy in frame
sub initBuyInFrame
{
   my ($self) = @_;

   my $frameLabelText = '$'.$self->{_buyIn}." Dollar Buy In";
   #Add relief and background
   $self->{_frame} = $self->{_parent}->LabFrame(-label=>$frameLabelText, -background=>$self->{_bg});
   $self->{_TotalPlayed} = 0;
   $self->{_No1Finish} = 0;
   $self->{_No2Finish} = 0;
   $self->{_No3Finish} = 0;
   $self->{_NoLOSTFinish} = 0;

   $self->{Label}{No1Finish} = $self->{_frame} -> Label (-text=>"1st Finishes = ",
                                             -anchor=>'w',
                                             -background=>$self->{_bg});
   $self->{Label}{No2Finish} = $self->{_frame} -> Label (-text=>"2nd Finishes = ",
                                             -anchor=>'w',
                                             -background=>$self->{_bg});
   $self->{Label}{No3Finish} = $self->{_frame} -> Label (-text=>"3rd Finishes = ",
                                             -anchor=>'w',
                                             -background=>$self->{_bg});
   $self->{Label}{NoLOSTFinish} = $self->{_frame} -> Label (-text=>"LOST Finishes = ",
                                             -anchor=>'w',
                                             -background=>$self->{_bg});

   $self->{Label}{No1Finish_2} = $self->{_frame} -> Label (-textvariable=>\$self->{_No1Finish}, -background=>$self->{_bg});
   $self->{Label}{No2Finish_2} = $self->{_frame} -> Label (-textvariable=>\$self->{_No2Finish}, -background=>$self->{_bg});
   $self->{Label}{No3Finish_2} = $self->{_frame} -> Label (-textvariable=>\$self->{_No3Finish}, -background=>$self->{_bg});
   $self->{Label}{NoLOSTFinish_2} = $self->{_frame} -> Label (-textvariable=>\$self->{_NoLOSTFinish}, -background=>$self->{_bg});

   $self->{Label}{No1Finish_3} = $self->{_frame} -> Label (-text=>' => % ', -background=>$self->{_bg});
   $self->{Label}{No2Finish_3} = $self->{_frame} -> Label (-text=>' => % ', -background=>$self->{_bg});
   $self->{Label}{No3Finish_3} = $self->{_frame} -> Label (-text=>' => % ', -background=>$self->{_bg});
   $self->{Label}{NoLOSTFinish_3} = $self->{_frame} -> Label (-text=>' => % ', -background=>$self->{_bg});

   $self->{No1Finish_Percent} = 0;
   $self->{No2Finish_Percent} = 0;
   $self->{No3Finish_Percent} = 0;
   $self->{NoLOSTFinish_Percent} = 0;

   $self->{Label}{No1Finish_4} = $self->{_frame} -> Label (-textvariable=>\$self->{No1Finish_Percent},
                                              -anchor=>'w', -background=>$self->{_bg});
   $self->{Label}{No2Finish_4} = $self->{_frame} -> Label (-textvariable=>\$self->{No2Finish_Percent},
                                              -anchor=>'w', -background=>$self->{_bg});
   $self->{Label}{No3Finish_4} = $self->{_frame} -> Label (-textvariable=>\$self->{No3Finish_Percent},
                                              -anchor=>'w', -background=>$self->{_bg});
   $self->{Label}{NoLOSTFinish_4} = $self->{_frame} -> Label (-textvariable=>\$self->{NoLOSTFinish_Percent},
                                              -anchor=>'w', -background=>$self->{_bg});

   my $totalGamesText = "Total ".$self->{_buyIn}." dollar games played = ";
   $self->{Label}{TotalPlayed} = $self->{_frame} -> Label (-text=>$totalGamesText,
	                                      -anchor=>'e', -background=>$self->{_bg});
   $self->{Label}{TotalPlayed_2} = $self->{_frame} -> Label (-textvariable=>\$self->{_TotalPlayed},
	                                      -anchor=>'w', -background=>$self->{_bg});

   $self->{Label}{No1Finish} -> form (-top=>'%0', -left=>'%0', -right=>'%35');
   $self->{Label}{No2Finish} -> form (-top=>$self->{Label}{No1Finish}, -left=>'%0', -right=>'%35');
   $self->{Label}{No3Finish} -> form (-top=>$self->{Label}{No2Finish}, -left=>'%0', -right=>'%35');
   $self->{Label}{NoLOSTFinish} -> form (-top=>$self->{Label}{No3Finish}, -left=>'%0', -right=>'%35');

   $self->{Label}{No1Finish_2} -> form (-top=>'%0', -left=>$self->{Label}{No1Finish}, -right=>'%50');
   $self->{Label}{No2Finish_2} -> form (-top=>$self->{Label}{No1Finish_2}, -left=>$self->{Label}{No2Finish}, -right=>'%50');
   $self->{Label}{No3Finish_2} -> form (-top=>$self->{Label}{No2Finish_2}, -left=>$self->{Label}{No3Finish}, -right=>'%50');
   $self->{Label}{NoLOSTFinish_2} -> form (-top=>$self->{Label}{No3Finish_2}, -left=>$self->{Label}{NoLOSTFinish}, -right=>'%50');

   $self->{Label}{No1Finish_3} -> form (-top=>'%0', -left=>$self->{Label}{No1Finish_2}, -right=>'%60');
   $self->{Label}{No2Finish_3} -> form (-top=>$self->{Label}{No1Finish_3}, -left=>$self->{Label}{No2Finish_2}, -right=>'%60');
   $self->{Label}{No3Finish_3} -> form (-top=>$self->{Label}{No2Finish_3}, -left=>$self->{Label}{No3Finish_2}, -right=>'%60');
   $self->{Label}{NoLOSTFinish_3} -> form (-top=>$self->{Label}{No3Finish_3}, -left=>$self->{Label}{NoLOSTFinish_2}, -right=>'%60');

   $self->{Label}{No1Finish_4} -> form (-top=>'%0',-left=>$self->{Label}{No1Finish_3},-right=>'%100');
   $self->{Label}{No2Finish_4}-> form (-top=>$self->{Label}{No1Finish_4},-left=>$self->{Label}{No2Finish_3},-right=>'%100');
   $self->{Label}{No3Finish_4} -> form (-top=>$self->{Label}{No2Finish_4},-left=>$self->{Label}{No3Finish_3},-right=>'%100');
   $self->{Label}{NoLOSTFinish_4} -> form (-top=>$self->{Label}{No3Finish_4},-left=>$self->{Label}{NoLOSTFinish_3},-right=>'%100');

   $self->{Label}{TotalPlayed} -> form (-left=>'%0', -bottom=>'%100', -right=>'%70');
   $self->{Label}{TotalPlayed_2} -> form (-left=>$self->{Label}{TotalPlayed}, -bottom=>'%100', -right=>'%100');

   return $self;
}

# Calculates the winning/losing percentages and keeps track of the total number
# of games played
sub PopulateStatsTab
{
   my ($self, @Results) = @_;

   $self->{_TotalPlayed} = 0;
   $self->{_No1Finish} = 0;
   $self->{_No2Finish} = 0;
   $self->{_No3Finish} = 0;
   $self->{_NoLOSTFinish} = 0;
   $self->{_net} = 0;

   
	my $size = (@Results);
	my ($tempDate,$tempBuyIn,$tempPlace,$tempMoney);
	$size = $size/4;
	for (my $i=0; $i<$size; $i++) 
   {
		$tempDate = shift(@Results);
		$tempBuyIn= shift(@Results);
		$tempPlace= shift(@Results);
		$tempMoney= shift(@Results);

      if ($tempBuyIn == $self->{_buyIn})
      {
         $self->{_TotalPlayed}++;
         $self->{_No1Finish}++ if ($tempPlace eq 'First');
         $self->{_No2Finish}++ if ($tempPlace eq 'Second');
         $self->{_No3Finish}++ if ($tempPlace eq 'Third');
         $self->{_NoLOSTFinish}++ if ($tempPlace eq 'LOST');
      }
   }

   $self->{No1Finish_Percent} = ($self->{_No1Finish}/$self->{_TotalPlayed}) * 100 if ($self->{_TotalPlayed} != 0);
   $self->{No2Finish_Percent} = ($self->{_No2Finish}/$self->{_TotalPlayed}) * 100 if ($self->{_TotalPlayed} != 0);
   $self->{No3Finish_Percent} = ($self->{_No3Finish}/$self->{_TotalPlayed}) * 100 if ($self->{_TotalPlayed} != 0);
   $self->{NoLOSTFinish_Percent} = ($self->{_NoLOSTFinish}/$self->{_TotalPlayed}) * 100 if ($self->{_TotalPlayed} != 0);

   if ($self->{_TotalPlayed} == 0)
   {
      $self->{No1Finish_Percent} = 0;
      $self->{No2Finish_Percent} = 0;
      $self->{No3Finish_Percent} = 0;
      $self->{NoLOSTFinish_Percent} = 0;
   }

   # Payouts for first/second/third are .5/.3/.2
   my $numPlayers = 9;
   my $buyIn = $self->{_buyIn};
   $self->{_net} = ($numPlayers * $buyIn * .50 * $self->{_No1Finish}) +
                   ($numPlayers * $buyIn * .30 * $self->{_No2Finish}) +
                   ($numPlayers * $buyIn * .20 * $self->{_No3Finish}) - 
                   ($buyIn * $self->{_TotalPlayed}) - 
                   ($buyIn * .1 * $self->{_TotalPlayed});
}

sub getFrame
{
   my ($self) = @_;
   return $self->{_frame};
}

sub getBuyIn
{
   my ($self) = @_;
   return $self->{_buyIn};
}

sub getNet
{
   my ($self) = @_;
   return $self->{_net};
}

1;
__END__
