use strict;
use argola;

my $hme;
my $apphm;

$hme = $ENV{"HOME"};
$apphm = $hme . "/.chobakwrap/promulga-shelnet-id";

system("mkdir","-p",$apphm);

sub opto__f_new {

  # The following (commented-out) line would have generated "something"
  # and "something.pub". Too bad that isn't clear enough from the
  # "ssh-keygen" man-page --- but at least I figured it out.
  #system("ssh-keygen","-t","rsa","-q","-f",$apphm . "/something");
  
  system("rm","-rf",$apphm . "/futurecode",$apphm . "/futurecode.pub");
  system("ssh-keygen","-t","rsa","-q","-f",$apphm . "/futurecode");
  
  system('echo','NEW KEY-PAIR GENERATED');
} &argola::setopt("-new",\&opto__f_new);

sub opto__f_upl {
  my $lc_rloc;
  my $lc_rcmd;
  my $lc_conta;
  my @lc_contb;
  my $lc_contc;
  my $lc_typ;
  my $lc_con;
  $lc_rloc = "~/.ssh/authorized_keys";
  #$lc_rcmd = "( ls && date && sleep 20 && date )";
  $lc_rcmd = "ls";
  
  $lc_conta = `cat ~/.chobakwrap/promulga-shelnet-id/upscr.txt`;
  @lc_contb = split(/\n/,$lc_conta);
  foreach $lc_contc (@lc_contb)
  {
    ($lc_typ,$lc_con) = split(/:/,$lc_contc,2);
    if ( $lc_typ eq "l" )
    {
      $lc_rloc = $lc_con;
    }
    if ( $lc_typ eq "c" )
    {
      $lc_rcmd = $lc_con;
    }
    if ( $lc_typ eq "to" )
    {
      open TAK, "| ( cd ~/.chobakwrap/promulga-shelnet-id && sftp $lc_con )";
      print TAK "put futurecode.pub " . $lc_rloc . "\n";
      close TAK;
      open TAK, "| ssh $lc_con";
      print TAK $lc_rcmd . "\n";
      close TAK;
    }
  }
  
  system('echo','SHELNET UPLOAD --- NOW WHAT?');
} &argola::setopt("-upl",\&opto__f_upl);

sub opto__f_activate {
  system("mkdir","-p",$hme . "/.ssh");
  system("rm","-rf",$hme . "/.ssh/id_rsa");
  system("cp",$apphm . "/futurecode",$hme . "/.ssh/id_rsa");
  system('echo','ACTIVATION COMPLETE');
} &argola::setopt("-activate",\&opto__f_activate);

&argola::runopts;



