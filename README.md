# irssi-joinmsg

Add msgs to people that is offline/not in channel. 
Msgs will be displayed in when the user joins the channel again


## Requirements

irssi (duh)  

## Installation

1. Copy joinmsg.pl to ~/.irssi/scripts
2. Load script from irssi with '/load joinmsg.pl'


## Usage

### Add msg to user

!addmsg <nick> <msg>, e.g:
`!addmsg nettum check this awesome video out: http://www.youtube.com/watch?v=dQw4w9WgXcQ`

### Print msgs when user joins

The script will automatically print msgs stored for user when he joins the next time, e.g:
`<@rockdrvn> Messages for nettum:`
17:09 <@rockdrvn> "check this awesome video out: http://www.youtube.com/watch?v=dQw4w9WgXcQ", added by rick, Fri Aug 16 18:45:24 2013

