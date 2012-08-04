#! c:/perl -w

use strict;
use CalculatePayouts;
use BuyInFrame;
use MoneyStats;

use Tk;
use Tk::Scrollbar;
use Tk::ListBox;
use Tk::LabEntry;
use Tk::LabFrame;
use Tk::BrowseEntry;
use Tk::NoteBook;
use Tk::JPEG;

sub CreateDir();
sub CreateFile();
sub FillInfo();
sub HandleEntry();
sub FillListBox();
sub SelectNewMonth();
sub getListMonths();
sub DeleteEntry();
sub createBGColors();
sub updateDisplay();

###Global Variables###
my $Data_Path = 'C:\\Felix\\Perl\\PerlTk\\Felix_Poker.git\\Logs';
my $Year;
my %Months = ('0'=>'January', 
              '1'=>'February', 
              '2'=>'March', 
              '3'=>'April', 
              '4'=>'May',
	           '5'=>'June', 
              '6'=>'July', 
              '7'=>'August', 
              '8'=>'September', 
              '9'=>'October',
	           '10'=>'November', 
              '11'=>'December');

my @Results = '';

#Calculates the month and year
my @timeData = localtime(time);
$Year = $timeData[5] + 1900;

#$CurrentYearMonth is the full path to the file
my $CurrentYearMonth = "$Data_Path\\$Year\_$Months{$timeData[4]}.txt";

#Checks if C:/Felix/Perl/PerlTk/Felix_Poker/Logs exists, if not make it
if (!(-d "$Data_Path")) {
	CreateDir();
}
if (!(-e "$CurrentYearMonth")) {
       CreateFile();
}     

# These are the Buy Ins from Poker Stars... He's only playing with 4 for now
my @BuyInChoices = (5,10,20,30);
my @TournamentFinishChoices = ('First', 'Second', 'Third', 'LOST');
my %PayOut = CalculatePayouts::calcPayouts(@BuyInChoices);

# Picking some annoying Colors for Bo 
my %BuyInChoicesBG = (5 => '#68c8d9', 10 => '#57fbca', 20 => '#dd9e59', 30 => '#378ffb');

###############################################################
my $mw = MainWindow->new;
$mw -> configure(-title=>"Bo Vu's Poker Log");
$mw -> geometry("800x450+200+200");

#Create The Title Frame for "Poker Log" and the Date Selection
my $HeaderFrame = $mw -> Frame(-borderwidth=>'6', -background=>'black');
#"Poker Log" Label to go in HeaderFrame
my $PokerLabel = $HeaderFrame -> Label (-text=>"Poker Log",
	 				-borderwidth=>5,
					-font=>'courier',
					-relief=>'groove');
#Browse Entry for the dates to go in HeaderFrame
my $SelectedMonth = $Months{$timeData[4]}."_".$Year."\.txt";
my @ListedMonths;
getListMonths();
my $DateBrowser = $HeaderFrame -> BrowseEntry (-variable=>\$SelectedMonth,
                                               -choices=>\@ListedMonths,
					                                -browsecmd=>\&SelectNewMonth,
				                                   -borderwidth=>2,
				                                   -state=>'readonly',
				                                   -relief=>'sunken');

my $ACES = $mw -> Photo(-file=>"pocket_aces.jpg");
my $ACESLabel = $HeaderFrame -> Label (-background=>'black',
	                               -image=>$ACES);

#Create the Main Window to hold the notebook
my $MainFrame = $mw -> Frame(-background=>'black');
my $NoteBook = $MainFrame -> NoteBook();

###Packing###
#Frames First#
$HeaderFrame -> form (-top=>'%0', -left=>'%0', -right=>'%100');
$MainFrame -> form (-top=>$HeaderFrame, -left=>'%0', -bottom=>'%100', -right=>'%100');

#Stuff in HeaderFrame
$PokerLabel -> form (-left=>'%0');
$DateBrowser -> form (-right=>'%100');
$ACESLabel -> form (-top=>'%0', -left=>$PokerLabel, -bottom=>'%100', -right=>$DateBrowser);

###################################################
###Creation of the Main Frame######################

#Stuff in the MainFrame
$NoteBook -> form (-top=>'%3', -left=>'%3', -bottom=>'%97', -right=>'%97');

#Adding two tabs to the NoteBook
my $NoteBookEntryTab = $NoteBook->add("EntryTab", -label=>"Entry");
my $NoteBookStatsTab = $NoteBook->add("StatsTab", -label=>"Stats");

###Stuff in Entry Tab###
my $LeftEntryTab = $NoteBookEntryTab ->LabFrame(-label=>'Entry', -background=>'#dadc9a');
my $RightEntryTab= $NoteBookEntryTab ->LabFrame(-label=>'Statistics', -background=>'#dadc9a');
my $RightEntryTabButtonFrame = $NoteBookEntryTab -> Frame (-background=>'#dadc9a');
my $DeleteButton = $RightEntryTabButtonFrame -> Button (-text=>'Delete Entry',
	                                                -command=>\&DeleteEntry);

#Left Side of the Entry Tab#
my $BuyInChoice = '<Select your Buy In>';
my $PlaceChoice = '<What did you place>';
my $BuyInBrowser = $LeftEntryTab ->BrowseEntry(-variable=>\$BuyInChoice,
                                               -choices=>\@BuyInChoices,
				                                   -borderwidth=>2,
				                                   -state=>'readonly',
				                                   -relief=>'sunken',
				       	                          -browsecmd=>\&FillInfo);
my $PlaceBrowser = $LeftEntryTab ->BrowseEntry(-variable=>\$PlaceChoice,
                                               -choices=>\@TournamentFinishChoices,
				                                   -borderwidth=>2,
				                                   -state=>'readonly',
				                                   -relief=>'sunken');
my $EnterButton  = $LeftEntryTab ->Button (-text=>'Enter', 
                                           -command=>\&HandleEntry);
my $InfoBG = '#dadc9a';
my $InfoFrame    = $LeftEntryTab ->LabFrame(-label=>"Info", -background=>$InfoBG);
my $Image = $mw -> Photo(-file=>"poker.jpg");
my $ImageLabel = $InfoFrame -> Label(-background=>'#dadc9a',-image=>$Image);

#Stuff in the Info Frame#
my $FirstLabel = $InfoFrame -> Label ( -text=>'1st = ', -background=>$InfoBG);
my $SecondLabel = $InfoFrame -> Label ( -text=>'2nd = ', -background=>$InfoBG);
my $ThirdLabel = $InfoFrame -> Label ( -text=>'3rd = ', -background=>$InfoBG);

my $FirstMoney = '...';
my $SecondMoney = '...';
my $ThirdMoney = '...';
my $FirstMoneyLabel = $InfoFrame -> Label (-text=>$FirstMoney, -background=>$InfoBG);
my $SecondMoneyLabel = $InfoFrame ->Label (-text=>$SecondMoney, -background=>$InfoBG);
my $ThirdMoneyLabel = $InfoFrame -> Label (-text=>$ThirdMoney, -background=>$InfoBG);


#Right side of Entry Tab#
my $EntryTabListBox = $RightEntryTab -> Scrolled('Listbox', -scrollbars=>'oe', -exportselection=>0);

#Packing the Entry Tab#
$LeftEntryTab -> form (-top=>'%0', -left=>'%0', -bottom=>'%100', -right=>'%50');
$RightEntryTabButtonFrame -> form (-left=>$LeftEntryTab, -right=>'%100', -bottom=>'%100');
$DeleteButton -> pack (-side=>'right');
$RightEntryTab-> form (-top=>'%0', -left=>$LeftEntryTab, -bottom=>$RightEntryTabButtonFrame, -right=>'%100');

$BuyInBrowser -> form(-top=>'%25', -left=>'%20', -right=>'%70');
$PlaceBrowser -> form(-top=>$BuyInBrowser, -left=>'%20', -right=>'%70');
$EnterButton -> form( -top=>$PlaceBrowser, -left=>'%50', -right=>'%70');
$InfoFrame -> form (-top=>'%50', -left=>'%0', -bottom=>'%100', -right=>'%100');
$ImageLabel -> form (-top=>'%0', -left=>'%20', -bottom=>'%100', -right=>'%100');

$FirstLabel -> form(-top=>'%20', -left=>'%0', -right=>'%10');
$SecondLabel -> form(-top=>$FirstLabel, -left=>'%0', -right=>'%10');
$ThirdLabel -> form(-top=>$SecondLabel, -left=>'%0', -right=>'%10');
$FirstMoneyLabel -> form(-top=>'%20', -left=>$FirstLabel, -right=>'%20');
$SecondMoneyLabel -> form(-top=>$FirstMoneyLabel, -left=>$SecondLabel, -right=>'%20');
$ThirdMoneyLabel -> form(-top=>$SecondMoneyLabel, -left=>$ThirdLabel, -right=>'%20');

$EntryTabListBox -> form (-top=>'%0', -left=>'%0', -bottom=>'%100', -right=>'%100');

###END Stuff in Entry Tab###


###################################
###Begin StatsTab##################
my $StatsTabLeftFrameBG = '#dadc9a';
my $StatsTabRightFrameBG = 'green';
my $StatsTabLeftFrame = $NoteBookStatsTab -> LabFrame (-label=>'Game Stats', -background=>$StatsTabLeftFrameBG);
my $StatsTabRightFrame = new MoneyStats($NoteBookStatsTab, $StatsTabRightFrameBG);
$StatsTabRightFrame->initMoneyStats(@BuyInChoices);

$StatsTabLeftFrame -> form(-top=>'%0', -left=>'%0', -bottom=>'%100', -right=>'%70');
$StatsTabRightFrame->getFrame()-> form(-top=>'%0', -left=>$StatsTabLeftFrame, -bottom=>'%100', -right=>'%100');

#Left Frame
my $TotalGamesPlayed = @Results/4;
my $TotalMessage = "Total Games Played = ";
my $StatsTabLeftFrameHeader = $StatsTabLeftFrame -> Label(-text=>$TotalMessage,
							  -font=>'courier',
							  -anchor=>'e',
						  	  -background=>'#dadc9a');
my $StatsTabLeftFrameHeader2 = $StatsTabLeftFrame -> Label(-textvariable=>\$TotalGamesPlayed,
							   -font=>'courier',
							   -anchor=>'w',
							   -background=>'#dadc9a');
my $StatsTabLeftFrameStatsFrame  = $StatsTabLeftFrame -> Frame(-borderwidth=>2,
	                                                  -relief=>'groove');

#################################################

$StatsTabLeftFrameHeader -> form (-top=>'%0', -left=>'%0', -right=>'%60');
$StatsTabLeftFrameHeader2 -> form (-top=>'%0', -left=>$StatsTabLeftFrameHeader, -right=>'%100');
$StatsTabLeftFrameStatsFrame  -> form (-top=>$StatsTabLeftFrameHeader, -left=>'%0', -bottom=>'%100', -right=>'%100');

# FELIX right now Bo is only playing in 4 buy-ins... eventually figure out how to make this more
# dynamic if he starts getting into more games...
my @BuyIns;
my $FiveBuyIn = new BuyInFrame($StatsTabLeftFrameStatsFrame, 5, $BuyInChoicesBG{5});
push (@BuyIns, $FiveBuyIn);

my $TenBuyIn = new BuyInFrame($StatsTabLeftFrameStatsFrame, 10, $BuyInChoicesBG{10});
push (@BuyIns, $TenBuyIn);

my $TwentyBuyIn = new BuyInFrame($StatsTabLeftFrameStatsFrame, 20, $BuyInChoicesBG{20});
push (@BuyIns, $TwentyBuyIn);

my $ThirtyBuyIn = new BuyInFrame($StatsTabLeftFrameStatsFrame, 30, $BuyInChoicesBG{30});
push (@BuyIns, $ThirtyBuyIn);

$FiveBuyIn->getFrame()->form (-top=>'%0', -left=>'%0', -bottom=>'%50', -right=>'%50');
$TenBuyIn->getFrame() -> form (-top=>'%0', -left=>$FiveBuyIn->getFrame(), -bottom=>'%50', -right=>'%100');
$TwentyBuyIn->getFrame() -> form (-top=>'%50', -left=>'%0', -bottom=>'%100', -right=>'%50');
$ThirtyBuyIn->getFrame() -> form (-top=>'%50', -left=>$TwentyBuyIn->getFrame(), -bottom=>'%100', -right=>'%100');

updateDisplay();
MainLoop;

###############################################################

sub CreateDir() {
	mkdir ($Data_Path);
}

sub CreateFile() {
	open (FILE,">$CurrentYearMonth");
	close (FILE);
}

# Reads in the record for the current month and populates
# the listbox on the right side of the display.
sub FillListBox() {
	open (FILE,"$CurrentYearMonth");
	(@Results) = <FILE>;
	chomp (@Results);
	close (FILE);

	my @temp;
	my $counter = 0;
	my $tempvar = '';
	my $WS = ' ';

   # There is a counter of 4 because the Period of a record is 4
	foreach(@Results) {
		my $length = length($_);
		my $adjust = 15 - $length;
		$tempvar .= ($_.$WS x $adjust);
		$counter++;
		if ($counter == 4 ) {
			push (@temp,$tempvar);
			$counter = 0;
			$tempvar = '';
		}
	}
	$EntryTabListBox -> delete(0,'end');
	$EntryTabListBox -> insert('end', @temp);

   $TotalGamesPlayed = @Results/4;
}

# Get in here when the user hits Enter after picking a buy in and place
sub HandleEntry() {
   my $selectBuyIn = '<Select your Buy In>';
   my $place = '<What did you place>';
	if ( ($BuyInChoice ne $selectBuyIn) && ($PlaceChoice ne $place)) {
		open (FILE, $CurrentYearMonth);
		my @temp = <FILE>;
		chomp (@temp);
		close (FILE);

		push (@temp, $Months{$timeData[4]}."_".$timeData[3]);
		push (@temp, $BuyInChoice);
		push (@temp, $PlaceChoice);
		push (@temp, $PayOut{$BuyInChoice}{$PlaceChoice});

		open (FILE, ">$CurrentYearMonth");
		foreach (@temp) {
			print FILE "$_\n";
		}
		close (FILE);
		
		$BuyInChoice = $selectBuyIn;
		$PlaceChoice = $place;

      updateDisplay();
	}
}

sub FillInfo() {
	$FirstMoneyLabel -> configure(-text=>$PayOut{$BuyInChoice}{'First'});
	$SecondMoneyLabel-> configure(-text=>$PayOut{$BuyInChoice}{'Second'});
	$ThirdMoneyLabel -> configure(-text=>$PayOut{$BuyInChoice}{'Third'});
}

sub getListMonths () {
	opendir (DIR,$Data_Path) || die "CANT OPEN $Data_Path\n";
    my @temp = readdir DIR;
    foreach (@temp) {
        unless($_ =~ /^(\.|\.\.)/) {
            push(@ListedMonths,$_);
        }
    }
	close (DIR);
}

sub SelectNewMonth () {
	$CurrentYearMonth = "$Data_Path\\$SelectedMonth";
   updateDisplay();
}

sub DeleteEntry() {
	my @DeleteSelection = $EntryTabListBox -> curselection();

	if (@DeleteSelection) {
		my @temp1;
		my @temp2;
		open (FILE,"$CurrentYearMonth");
		(@temp1) = <FILE>;
		chomp (@temp1);
		close (FILE);

		my $DeleteIndexStart = $DeleteSelection[0] * 4;
		my $size = @temp1;

		for (my $i = 0; $i < $size; $i++) {
			if ($i == $DeleteIndexStart) {
			}
			elsif ($i == $DeleteIndexStart+1) {
			}
			elsif ($i == $DeleteIndexStart+2) {
			}
			elsif ($i == $DeleteIndexStart+3) {
			}
			else {
				push (@temp2,$temp1[$i]);
			}
			
		}
		@Results = '';
		open (FILE,">$CurrentYearMonth");
		foreach (@temp2) {
			push (@Results,$_);
			print FILE "$_\n";
		}
		close (FILE);

      updateDisplay();
	}
}

sub updateDisplay()
{
   FillListBox();

   foreach my $buyIn (@BuyIns)
   {
      $buyIn->PopulateStatsTab(@Results);
   }

   for (my $i=0; $i < @BuyInChoices; $i++)
   {
      $StatsTabRightFrame->calcStats($BuyInChoices[$i], $BuyIns[$i]);
   }

   $StatsTabRightFrame->calcNet(@BuyIns);
}
