
class Door {
    subset DoorState of Str where * eqv 'closed' or * eqv 'open';

    has Int $.number;
    has $.state = 'open'|'closed';

    method open     { $!state = 'open' }
    method close    { $!state = 'closed' }
    method toggle   { $.state eqv 'closed' ?? $.open !! $.close }
}

