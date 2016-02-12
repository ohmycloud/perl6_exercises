#!/home/jon/.rakudobrew/bin/perl6

use Test;



sub some_complicated_test_conditions {
    True;
}
#sub some_complicated_test_conditions {
#    False;
#}


#if some_complicated_test_conditions() {
#    pass("This should pass.");
#}
#else {
#    flunk("This will fail.");
#}



done-testing;




if some_complicated_test_conditions() {
    pass("This should pass.");
}
else {
    flunk("This will fail.");
}



done-testing;


