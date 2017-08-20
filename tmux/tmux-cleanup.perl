use strict;
use warnings;

sub on_wm_delete_window
{
    my $session = `tmux display-message -p '#S'`;
    if ($session ne 'eloquenza@pcquenza') {
        my $output = `tmux kill-session -t $session`;
    }
}
