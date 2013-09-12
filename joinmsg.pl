use vars qw($VERSION %IRSSI);

use Irssi;

$VERSION = '1.0';
%IRSSI = (
    authors     => 'Marius Nettum',
    contact     => 'marius@intnernettum.no',
    name        => 'irssi-joinmsg',
    description => 'Add msgs to people that is not online. Msgs will be displayed when the user joins the channel',
    license     => 'GPL'
);

$path = '/path/to/store_msgs/'; #E.g. /home/marius/.irssi/joinmsg/. Remember trailing slash.
$msgfile = $path . 'irssi-joinmsg.txt';
$msgfile_tmp = $path . 'irssi-joinmsg.tmp';

sub handleinput {
    my ($server, $msg, $nick, $addr, $target) = @_;
    if ($msg =~ m/^!addmsg[ \t](.*?)[ \t](.*)/) {
    	if (open(my $writedata, '>>', $msgfile)) {
    		print $writedata $1 . ' F_SEP ' . $2 . ' F_SEP ' . localtime(time) . ' F_SEP ' . $nick . ' F_SEP ' . $target . "\n";
    		close($writedata);
    		$server->command('msg ' . $target .  ' Message added and will be printed next time ' . $1 . ' joins ' . $target);
    	}
    }
}

sub do_msg_on_join {
    my ($server, $target, $nick) = @_;
    my $channel = substr($target, 1);
    my @msgs = &get_msgs_for_nick($nick, $channel);
    if (@msgs) {
    	$server->command('msg ' . $channel .  ' Messages for ' . $nick . ':');
	    foreach $msg (@msgs) {
	    	$server->command('msg ' . $channel .  ' ' . $msg);
	    }
	}

}

sub get_msgs_for_nick {
	my $nick = quotemeta($_[0]);
	my $channel = $_[1];
	my $tmpfile_created = false;
	my @msgs = ();

	if (open(my $readdata, '<', $msgfile)) {
		open(my $writedata, '>', $msgfile_tmp);
		
        while (my $line = <$readdata>) {
			chomp $line;
			my @fields = split " F_SEP " , $line;
			
			if ($fields[0] =~ /$nick/i && $fields[4] =~ /$channel/i) {
				push(@msgs, '"' . $fields[1] . '" - added by ' . $fields[3] . ', ' . $fields[2])
			} else {
				$tmpfile_created = true;
				print $writedata $line . "\n";
			}
		}
		close($writedata);
		close($readdata);
		if ($tmpfile_created == true) {
			rename $msgfile_tmp, $msgfile;
		}
    }

    return @msgs;
}

Irssi::signal_add('message public', 'handleinput');
Irssi::signal_add('event join', 'do_msg_on_join');
Irssi::print("irssi-joinmsg v$VERSION loaded successfully");