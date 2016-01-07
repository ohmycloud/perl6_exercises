#!/home/jon/.rakudobrew/bin/perl6

use NativeCall;
my class PwStruct is repr('CStruct') {
    has Str $.pw_name;
    has Str $.pw_passwd;
    has uint32 $.pw_uid;
    has uint32 $.pw_gid;
    has Str $.pw_gecos;
    has Str $.pw_dir;
    has Str $.pw_shell;
}
sub getuid()           returns uint32   is native(Str) {};
sub getpwuid(int $uid) returns PwStruct is native(Str) {};
say getpwuid(getuid()).pw_dir;


say $*HOME.Str;

