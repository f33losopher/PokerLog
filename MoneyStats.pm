package MoneyStats;

use strict;
use Tk;
use Tk::LabFrame;

# Keeps track of the grand total winnings/losses over all the 
# buy ins.
sub new
{
   my $class = shift;
   my $self = { _parent => shift,
                _bg     => shift,
                _buyIns => undef,
                _total  => 0,
                _frame  => undef,
                Label   => undef,
              };
   bless $self, $class;
   return $self;
}

sub initMoneyStats
{
   my ($self, @buyIns) = @_;
   
   $self->{_frame} = $self->{_parent}->LabFrame(-label=>'$$$ Money Stats $$$', -background=>$self->{_bg});

   $self->{_totalNet} = 0;

   $self->{Label}{StatsTabRightFrame_Header} = $self->{_frame} -> Label (-text=>"Your Net Gains/Losses",
	                        -borderwidth=>2,
							      -relief=>'raised',
							      -font=>'courier',
                           -background=>$self->{_bg});

   foreach my $buyIn (@buyIns)
   {
      $self->{buyInNetValue}{$buyIn} = 0;
      my $labelText = "\$".$buyIn." buy in = \$";
      $self->{Label}{buyIn}{$buyIn} = $self->{_frame}->Label(-text=>$labelText, -background=>$self->{_bg});
      $self->{Label}{buyInValue}{$buyIn} = $self->{_frame}->Label(-textvariable=>\$self->{buyInNetValue}{$buyIn}, -background=>$self->{_bg});
   }

   $self->{Label}{totalNet} = $self->{_frame}->Label(-text=>"Total Net = \$", -anchor=>'e', -background=>$self->{_bg});

   $self->{Label}{totalNetValue} = $self->{_frame} -> Label (-textvariable=>\$self->{_totalNet}, 
                                                              -anchor=>'w',
                                                              -background=>$self->{_bg}); 

   $self->{Label}{StatsTabRightFrame_Header} -> form(-top=>'%0', -left=>'%0', -right=>'%100');

   $self->{Label}{buyIn}{$buyIns[0]}->form(-top=>'%15', -left=>'%0', -right=>'%40');
   for (my $i = 1; $i < @buyIns; $i++)
   {
      $self->{Label}{buyIn}{$buyIns[$i]}->form(-top=>$self->{Label}{buyIn}{$buyIns[$i-1]}, -left=>'%0', -right=>'%40');
   }

   $self->{Label}{buyInValue}{$buyIns[0]}->form(-top=>'%15', -left=>$self->{Label}{buyIn}{$buyIns[0]}, -right=>'%100');
   for (my $i = 1; $i < @buyIns; $i++)
   {
      $self->{Label}{buyInValue}{$buyIns[$i]}->form(-top=>$self->{Label}{buyInValue}{$buyIns[$i-1]}, 
         -left=>$self->{Label}{buyIn}{$buyIns[$i]}, -right=>'%100');
   }

   $self->{Label}{totalNet} -> form (-top=>'%60',-left=>'%0', -right=>'%40');
   $self->{Label}{totalNetValue} -> form (-top=>'%60', -left=>$self->{Label}{totalNet}, -right=>'%100');

   return $self;
}

sub calcStats
{
   my ($self, $buyIn, $buyInFrame) = @_;

   $self->{buyInNetValue}{$buyIn} = $buyInFrame->getNet();
   return $self;
}

sub calcNet
{
   my ($self, @buyInFrames) = @_;

   my $total = 0;

   foreach my $buyInFrame (@buyInFrames)
   {
      $total += $buyInFrame->getNet(); 
   }

   $self->{_totalNet} = $total;
   return $self;
}

sub getFrame()
{
   my ($self) = @_;
   return $self->{_frame};
}

1;
__END__
