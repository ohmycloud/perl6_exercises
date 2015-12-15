#!/home/jon/.rakudobrew/bin/perl6

my @letters = <a b c d e f g h i>;
say @letters[1];
say join ',', @letters[0,2..4];
say join ',', @letters[0,1,3]:kv;

my $lref = item(@letters);
say $lref.[0];
say @($lref);

### Deref the whole thing
my @new_array_1 = @($lref);
my @new_array_2 = $lref.list;   # ".hash" for hashes
my @new_array_3 = $lref[];      # Docs call this the "Zen" slice.

say '';


my %names = (
    jon     => 'barton',
    john    => 'koch',
    kermit  => 'jackson';
);
say %names{'jon'};
say join ',', %names{'jon', 'kermit'};
say join ',', %names{'jon', 'kermit'}:kv;

my $href = item(%names);
say $href{'jon'};
say $href.{'jon'};



my $cref = { say "foo" };
$cref();
$cref.();
sub foobar { say "foobar"; }
my $cref_1 = &foobar;
$cref_1();
