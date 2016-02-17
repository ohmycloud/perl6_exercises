#!/home/jon/.rakudobrew/bin/perl6

use Template::Mojo;

my $t = Template::Mojo.from-file( 'Template.tmpl' );
say $t.render( {title => 'blarg'} );

