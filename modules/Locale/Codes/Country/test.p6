#!/usr/bin/env perl6

use Locale::Codes::Country;


### Some country code you already know
my $country_code = "USA";
#my $country_code = "UK";





### Get the official country string for the USA
my $country_name = codeToCountry("$country_code");
$country_name.say;                                              # AMERICA
''.say;


### OK, knowing the correct country string, we can get four different codes 
### associated with that country:
my $alpha_2 = countryToCode($country_name, 'alpha-2');
my $alpha_3 = countryToCode($country_name, 'alpha-3');
my $numeric = countryToCode($country_name, 'numeric');
my $domain  = countryToCode($country_name, 'dom');

$alpha_2.say;                                                   # US
$alpha_3.say;                                                   # USA
$numeric.say;                                                   # 840
$domain.say;                                                    # .us
''.say;


### Note that the "numeric" code is actually returned as a string.
### This will matter later on.
say "Our 'numeric' code is of type {$numeric.WHAT.perl}.";      # Str
''.say;


### The strings used as the second arg above are aliases to constants.  The 
### strings are easier to use and remember than the constants; this is just 
### for info.  These four lines produce the same output as the previous four:
say countryToCode("$country_name", LOCALE_CODE_ALPHA_2);
say countryToCode("$country_name", LOCALE_CODE_ALPHA_3);
say countryToCode("$country_name", LOCALE_CODE_NUMERIC);
say countryToCode("$country_name", LOCALE_CODE_DOM);
''.say;


### Back to codeToCountry again.
### We can use any of the four types of country codes to get the country name.  
### We do not have to tell the module which type of code we're using as they 
### all have features that make them easy to distinguish.
say codeToCountry( $alpha_2  );
say codeToCountry( $alpha_3  );
say codeToCountry( +$numeric  );            # Cast to Int
say codeToCountry( $domain  );
''.say;


### 
### When passing the numeric code, we have to ensure that it's an Int, not the 
### Str that countryToCode() returns.
###
### Presumably, codeToCountry is a multi method that has an (Int $arg) 
### signature on one of the multis.
###




