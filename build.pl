#/usr/bin/env perl
# Note: before `cpanm Imager`, you need `brew install freetype` first
use strict;
use Imager;
use File::Slurp;
use File::Copy;


my $max = shift || 10;
my @colors  = qw/ blue brown darkgreen green orange paleblue pink purple red yellow /;
my @numbers = ( 0 .. $max );
my $html    = '';

for my $color (@colors) {
    $html .= sprintf q{<h5>%s</h5>}, $color;

    my $filename = sprintf '%s.png', $color;
    copy "src/$filename", "target/$filename";
    $html .= sprintf q{<img src="target/%s" />}, $filename;

    for my $number (@numbers) {
        my $img = Imager->new( file => sprintf 'src/%s.png', $color ) or die Imager->errstr();
        my $font = Imager::Font->new( file => "src/Arial Narrow Bold.ttf" ) or die Imager->errstr;
        $img->align_string(
            x      => 11,
            y      => 11,
            halign => 'center',
            valign => 'center',
            string => $number,
            font   => $font,
            size   => 13,
            aa     => 1,
            color  => 'black'
        );
        my $file = sprintf 'target/%s%d.png', $color, $number;
        $img->write( file => $file ) or die $img->errstr;
        $html .= sprintf q{<img src="%s" />}, $file;
    }
    $html .= q{<hr />};
}

write_file( 'preview.html', $html );
