#!/usr/bin/perl

use strict;
use warnings;

use Data::Dump qw( dump );
use Test::More qw( no_plan );
require_ok('HTTP::BrowserDetect');

my @tests = (
  [
    "Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.5) Gecko/20031007 Firebird/0.7",
    "0.7",
    0,
    0.7,
    "Firefox",
    "WinXP",
    "1.5",
    ["windows", "win32", "winnt", "winxp", "firefox", "gecko"],
  ],
  [
    "Mozilla/1.1 (Windows 3.0; I)",
    "1.1",
    1,
    "0.1",
    "Netscape",
    "Win3x",
    undef,
    ["netscape", "windows", "win3x", "win16"],
  ],
  [
    "Mozilla/1.1 (Windows 3.1; I)",
    "1.1",
    1,
    "0.1",
    "Netscape",
    "Win3x",
    undef,
    ["netscape", "windows", "win31", "win3x", "win16"],
  ],
  [
    "Mozilla/2.0 (Win95; I)",
    "2.0",
    2,
    0,
    "Netscape",
    "Win95",
    undef,
    ["netscape", "nav2", "windows", "win32", "win95"],
  ],
  [
    "Mozilla/2.0 (compatible; MSIE 3.01; Windows 95)",
    "3.01",
    3,
    .01,
    "MSIE",
    "Win95",
    undef,
    ["ie", "ie3", "windows", "win32", "win95"],
  ],
  [
    "Mozilla/2.0 (compatible; MSIE 3.01; Windows NT)",
    "3.01",
    3,
    .01,
    "MSIE",
    "WinNT",
    undef,
    ["ie", "ie3", "windows", "win32", "winnt"],
  ],
  [
    "Mozilla/2.0 (compatible; MSIE 3.0; AOL 3.0; Windows 95)",
    "3",
    3,
    0,
    "AOL Browser",
    "Win95",
    undef,
    ["ie", "ie3", "windows", "win32", "win95", "aol", "aol3"],
  ],
  [
    "Mozilla/2.0 (compatible; MSIE 4.0; Windows 95)",
    "4",
    4,
    0,
    "MSIE",
    "Win95",
    undef,
    ["ie", "ie4", "ie4up", "windows", "win32", "win95"],
  ],
  [
    "Mozilla/3.0 (compatible; MSIE 4.0; Windows 95)",
    "4.0",
    4,
    0,
    "MSIE",
    "Win95",
    undef,
    ["ie", "ie4", "ie4up", "windows", "win32", "win95"],
  ],
  [
    "Mozilla/4.0 (compatible; MSIE 4.01; Windows 95)",
    "4.01",
    4,
    0.01,
    "MSIE",
    "Win95",
    undef,
    ["ie", "ie4", "ie4up", "windows", "win32", "win95"],
  ],
  [
    "Mozilla/4.0 (compatible; MSIE 5.0b2; Windows NT)",
    "5.0",
    5,
    0,
    "MSIE",
    "WinNT",
    undef,
    ["ie", "ie5", "ie5up", "ie4up", "windows", "win32", "winnt"],
  ],
  [
    "Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)",
    "5.5",
    5,
    0.5,
    "MSIE",
    "WinNT",
    undef,
    [
      "ie",
      "ie5",
      "ie5up",
      "ie55",
      "ie55up",
      "ie4up",
      "windows",
      "win32",
      "winnt",
    ],
  ],
  [
    "Mozilla/4.0 (compatible; MSIE 5.5; Windows NT 5.0) via proxy gateway Something/1.23",
    "5.5",
    5,
    0.5,
    "MSIE",
    "Win2k",
    undef,
    [
      "ie",
      "ie5",
      "ie5up",
      "ie55",
      "ie55up",
      "ie4up",
      "windows",
      "win32",
      "winnt",
      "win2k",
    ],
  ],
  [
    "Mozilla/3.0 (Macintosh; I; PPC)",
    "3.0",
    3,
    0,
    "Netscape",
    "Mac",
    undef,
    ["netscape", "nav3", "mac", "macppc"],
  ],
  [
    "Mozilla/4.0 (compatible; MSIE 5.0; Win32)",
    "5.0",
    5,
    0,
    "MSIE",
    undef,
    undef,
    ["ie", "ie4up", "ie5", "ie5up", "windows", "win32"],
  ],
  [
    "Mozilla/4.0 (compatible; Opera/3.0; Windows 4.10) 3.50",
    "3.0",
    3,
    0,
    "Opera",
    undef,
    undef,
    ["opera", "opera3", "windows"],
  ],
  [
    "Mozilla/4.0 (compatible; MSIE 5.0b1; Windows NT 5.0)",
    "5.0",
    5,
    0,
    "MSIE",
    "Win2k",
    undef,
    [
      "ie",
      "ie4up",
      "ie5",
      "ie5up",
      "windows",
      "win32",
      "winnt",
      "win2k",
    ],
  ],
  [
    "Mozilla/4.06 [en] (Win98; I ;Nav)",
    "4.06",
    4,
    0.06,
    "Netscape",
    "Win98",
    undef,
    ["netscape", "nav4", "nav4up", "windows", "win32", "win98"],
  ],
  [
    "Mozilla/4.5 [en] (X11; I; FreeBSD 2.2.7-RELEASE i386)",
    "4.5",
    4,
    0.5,
    "Netscape",
    "Unix",
    undef,
    [
      "netscape",
      "nav4",
      "nav4up",
      "nav45",
      "nav45up",
      "bsd",
      "freebsd",
      "unix",
      "x11",
    ],
  ],
  [
    "Mozilla/3.03Gold (Win95; I)",
    "3.03",
    3,
    0.03,
    "Netscape",
    "Win95",
    undef,
    ["netscape", "nav3", "navgold", "windows", "win32", "win95"],
  ],
  ["Wget/1.4.5", "1.4", 1, 0.4, undef, undef, undef, ["wget", "robot"]],
  [
    "libwww-perl/5.11",
    "5.11",
    5,
    0.11,
    undef,
    undef,
    undef,
    ["lwp", "robot"],
  ],
  [
    "GetRight/3.2.1",
    "3.2",
    3,
    0.2,
    undef,
    undef,
    undef,
    ["getright", "robot"],
  ],
  [
    "Mozilla/3.0 (compatible; StarOffice/5.1; Linux)",
    "5.1",
    5,
    0.1,
    undef,
    "Linux",
    undef,
    ["linux", "unix", "staroffice"],
  ],
  [
    "Mozilla/3.0 (compatible; StarOffice/5.1; Win32)",
    "5.1",
    5,
    0.1,
    undef,
    undef,
    undef,
    ["win32", "windows", "staroffice"],
  ],
  [
    "iCab/Pre2.0 (Macintosh; I; PPC)",
    "2.0",
    2,
    0,
    undef,
    "Mac",
    undef,
    ["mac", "macppc", "icab"],
  ],
  [
    "Konqueror/1.1.2",
    "1.1",
    1,
    0.1,
    undef,
    undef,
    undef,
    [
      "konqueror"
    ],
    [
      "robot", # RT #30705
    ],
  ],
  [
    "Lotus-Notes/4.5 ( OS/2 )",
    "4.5",
    4,
    0.5,
    undef,
    "OS2",
    undef,
    ["lotusnotes", "os2"],
  ],
  #["Java1.0.2", "0.0", 0, 0, undef, undef, undef, ["java"]],
  [
    "Googlebot/1.0 (googlebot\@googlebot.com http://googlebot.com/)",
    "1.0",
    1,
    0,
    undef,
    undef,
    undef,
    ["google", "robot"],
  ],
  ["Nokia-WAP-Toolkit/1.3beta", "1.3", 1, 0.3, undef, undef, undef, ["wap"]],
  ["Nokia7110/1.0 (30.05)", "1.0", 1, 0, undef, undef, undef, ["wap"]],
  ["UP.Browser/4.1.2a-XXXX", "4.1", 4, 0.1, undef, undef, undef, ["wap"]],
  ["Wapalizer/1.0", "1.0", 1, 0, undef, undef, undef, ["wap"]],
  ["YourWap/1.16", "1.16", 1, 0.16, undef, undef, undef, ["wap"]],
  [
    "AmigaVoyager/3.3.50 (AmigaOS/PPC)",
    "3.3",
    3,
    0.3,
    undef,
    undef,
    undef,
    ["amiga"],
  ],
  [
    "fetch/1.0 FreeBSD/4.0-CURRENT (i386)",
    "1.0",
    1,
    0,
    undef,
    "Unix",
    undef,
    ["bsd", "freebsd", "unix", "robot"],
  ],
  [
    "Emacs-W3/2.1.105 URL/1.267 ((Unix?) ; TTY ; sparc-sun-solaris2.3)",
    "2.1",
    2,
    0.1,
    undef,
    "Unix",
    undef,
    ["emacs", "sun", "unix"],
  ],
  [
    "Mozilla/5.001 (windows; U; NT4.0; en-us) Gecko/25250101",
    "5.001",
    5,
    0.001,
    "Netscape",
    "WinNT",
    undef,
    [
      "netscape",
      "nav4up",
      "nav45up",
      "windows",
      "winnt",
      "win32",
      "gecko",
      "nav6",
      "nav6up",
      "mozilla",
      "gecko",
    ],
  ],
  [
    "Mozilla/5.001 (Macintosh; N; PPC; ja) Gecko/25250101 MegaCorpBrowser/1.0 (MegaCorp, Inc.)",
    "5.001",
    5,
    0.001,
    "Netscape",
    "Mac",
    undef,
    [
      "netscape",
      "nav4up",
      "nav45up",
      "nav6",
      "nav6up",
      "mac",
      "macppc",
      "mozilla",
      "gecko",
    ],
  ],
  [
    "Mozilla/9.876 (X11; U; Linux 2.2.12-20 i686, en) Gecko/25250101 Netscape/5.432b1 (C-MindSpring)",
    "5.432",
    5,
    0.432,
    "Netscape",
    "Linux",
    undef,
    [
      "netscape",
      "nav4up",
      "nav45up",
      "nav6",
      "nav6up",
      "linux",
      "unix",
      "mozilla",
      "gecko",
      "x11",
    ],
  ],
  [
    "TinyBrowser/2.0 (TinyBrowser Comment) Gecko/20201231",
    "2.0",
    2,
    0,
    undef,
    undef,
    undef,
    ["gecko"],
  ],
  [
    "TinyBrowser/2.0 (TinyBrowser Comment) Gecko/20201231",
    "2.000",
    2,
    0,
    undef,
    undef,
    undef,
    ["gecko"],
  ],
  [
    "Mozilla/5.0 (X11; U; FreeBSD i386; en-US; rv:1.7) Gecko/20040619 Firefox/0.9",
    "0.9",
    0,
    0.9,
    "Firefox",
    "Unix",
    "1.7",
    ["unix", "freebsd", "bsd", "x11", "firefox", "gecko"],
  ],
  [
    "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7) Gecko/20040614 Firefox/0.9",
    "0.9",
    0,
    0.9,
    "Firefox",
    "WinXP",
    "1.7",
    ["windows", "win32", "winnt", "winxp", "firefox", "gecko"],
  ],
  [
    "Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8a) Gecko/20040416 Firefox/0.8.0+",
    "0.8",
    0,
    0.8,
    "Firefox",
    "Win2k",
    "1.8a",
    ["windows", "win32", "winnt", "win2k", "firefox", "gecko"],
  ],
  [
    "Mozilla/5.0 (X11; U; Linux i686; de-DE; rv:1.6) Gecko/20040207 Firefox/0.8",
    "0.8",
    0,
    0.8,
    "Firefox",
    "Linux",
    "1.6",
    ["unix", "linux", "x11", "firefox", "gecko"],
  ],
  [
    "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.5a) Gecko/20031002 Mozilla Firebird/0.6.1",
    "0.6",
    0,
    0.6,
    "Firefox",
    "Linux",
    "1.5a",
    ["unix", "linux", "x11", "firefox", "gecko"],
  ],
  [
    "Mozilla/5.0 (Windows; U; WinNT4.0; en-US; rv:1.3a) Gecko/20021207 Phoenix/0.5",
    "0.5",
    0,
    0.5,
    "Firefox",
    "WinNT",
    "1.3a",
    ["windows", "win32", "winnt", "firefox", "gecko"],
  ],
  [
    "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; .NET CLR 3.5.30729; OfficeLive",
    "7.0",
    7,
    0,
    "MSIE",
    "WinVista",
    undef,
    [
      "windows",
      "win32",
      "winnt",
      "winvista",
      "dotnet",
      "ie",
      "ie7",
      "ie4up",
      "ie5up",
      "ie55up",
    ],
  ],
  [
    "Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/530.5 (KHTML, like Gecko) Chrome/2.0.172.31 Safari/530.5",
    "2.0",
    2,
    0,
    "Chrome",
    "WinVista",
    undef,
    [
      "windows",
      "win32",
      "winnt",
      "winvista",
      "chrome",
    ],
    [
      "safari",
      "gecko",
    ],
  ],
  # RT #48727
  [
    "Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/530.19.2 (KHTML, like Gecko) Version/4.0.2 Safari/530.19.1",
    "4.0",
    4,
    0,
    "Safari",
    "WinVista",
    undef,
    [
      "windows",
      "win32",
      "winnt",
      "winvista",
      "safari",
    ],
    [
      "gecko",
    ],
  ],
  [
    "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/124 (KHTML, like Gecko) Safari/125.1",
    "1.25",
    1,
    0.25,
    "Safari",
    "Mac OS X",
    undef,
    [
      "mac",
      "macosx",
      "macppc",
      "safari",
    ],
    [
      "gecko",
    ],
  ],
  [
    "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/106.2 (KHTML, like Gecko) Safari/100.1",
    "1.0",
    1,
    0,
    "Safari",
    "Mac OS X",
    undef,
    [
      "mac",
      "macosx",
      "macppc",
      "safari",
    ],
    [
      "gecko",
    ],
  ],
  [
    "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/74 (KHTML, like Gecko) Safari/74",
    "0.74",
    0,
    0.74,
    "Safari",
    "Mac OS X",
    undef,
    [
      "mac",
      "macosx",
      "macppc",
      "safari",
    ],
    [
      "gecko",
    ],
  ],
  [
    "BlackBerry7730/3.7.1 UP.Link/5.1.2.5",
    "3.7",
    3,
    0.7,
    undef,
    undef,
    undef,
    ["blackberry"],
  ],
  [
    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.0.3705; .NET CLR 1.1.4322)",
    "6.0",
    6,
    0,
    "MSIE",
    "Win2k",
    undef,
    [
      "windows",
      "winnt",
      "win2k",
      "win32",
      "ie",
      "ie4up",
      "ie5up",
      "ie55up",
      "ie6",
      "dotnet",
    ],
  ],
  [
    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)",
    "6.0",
    6,
    0,
    "MSIE",
    "WinXP",
    undef,
    [
      "windows",
      "winnt",
      "winxp",
      "win32",
      "ie",
      "ie4up",
      "ie5up",
      "ie55up",
      "ie6",
    ],
  ],
  [
    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.1.4322)",
    "6.0",
    6,
    0,
    "MSIE",
    "WinXP",
    undef,
    [
      "windows",
      "winnt",
      "winxp",
      "win32",
      "ie",
      "ie4up",
      "ie5up",
      "ie55up",
      "ie6",
      "dotnet",
    ],
  ],
  [
    "Mozilla/4.0 (compatible; MSIE 5.22; Mac_PowerPC) ",
    "5.22",
    5,
    0.22,
    "MSIE",
    "Mac",
    undef,
    ["mac", "macppc", "ie", "ie4up", "ie5", "ie5up"],
  ],
  [
    "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-US; rv:1.0.2) Gecko/20030208 Netscape/7.02",
    "7.02",
    7,
    0.02,
    "Netscape",
    "Mac OS X",
    "1.0.2",
    [
      "mac",
      "macppc",
      "netscape",
      "nav4up",
      "nav45up",
      "nav6up",
      "gecko",
      "macosx",
      "mozilla",
    ],
  ],
  [
    "Mozilla/5.0 (X11; U; Linux 2.4.3-20mdk i586; en-US; rv:0.9.1) Gecko/20010611",
    "5",
    5,
    0,
    "Netscape",
    "Linux",
    "0.9.1",
    [
      "linux",
      "netscape",
      "nav4up",
      "nav45up",
      "nav6",
      "nav6up",
      "unix",
      "x11",
      "gecko",
      "mozilla",
    ],
  ],
  [
    "Mozilla/5.0 (SymbianOS/9.1; U; en-us) AppleWebKit/413 (KHTML, like Gecko) Safari/413 UP.Link/6.3.1.15.0",
    4.13,
    4,
    0.13,
    "Safari",
    undef,
    undef,
    [
      "safari",
    ],
    [
      "gecko",
    ],
  ],
  [
    "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9) Gecko/2008062901 IceWeasel/3.0",
    3.0,
    3,
    0,
    "Iceweasel",
    undef,
    undef,
    ["windows", "win32", "winnt", "winxp", "firefox", "gecko",],
  ],
  [
    "libcurl-agent/1.0",
    1,
    1,
    0,
    "curl",
    undef,
    undef,
    ["curl"],
  ],
  [
    "puf/0.93.2a (Linux 2.4.20-19.9; i686)",
    0.93,
    0,
    0.93,
    "puf",
    undef,
    undef,
    ["puf","robot",],
    ["mobile",],
  ],
  [
    "Mozilla/5.0 (iPhone; U; CPU iPhone OS 2_0_2 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version/3.1.1 Mobile/5C1 Safari/525.20",
    undef,
    undef,
    undef,
    "safari",
    undef,
    undef,
    ["safari", "mobile"],
  ],
  # test for uninitialized value warnings RT #8547
  [
    "Internetf Explorer 6 (MSIE 6; Windows XP)",
  ],
  # test for uninitialized value warnings RT #8547
  [
    "Links (2.1pre15; Linux 2.4.26-vc4 i586; x)",
  ],

  # These tests all have issues with returning undef rather than 0 for
  # version numbers.  Need to explore this to see what the correct behaviour
  # should be

  #[
  #  "AmigaVoyager (compatible; AmigaVoyager; AmigaOS)",
  #  "0.0",
  #  0,
  #  0,
  #  undef,
  #  undef,
  #  undef,
  #  ["amiga"],
  #],
  #[
  #  "AvantGo 3.2 (compatible; AvantGo 3.2)",
  #  "0.0",
  #  0,
  #  0,
  #  undef,
  #  undef,
  #  undef,
  #  ["palm", "avantgo"],
  #],
  #["Nothing", undef, undef, 0, undef, undef, undef, [""]], # does this make sense?
  #[undef, "0.0", 0, 0, undef, undef, undef, [""]],
);

foreach my $test ( @tests ) {
    my ( $ua, $version, $major, $minor, $browser, $os, $other, $match, $no_match ) = @{$test};
    my $detected = HTTP::BrowserDetect->new( $ua );
    diag( $detected->user_agent );

    cmp_ok( $detected->version, '==', $version, "version: $version") if $version;
    cmp_ok( $detected->major, 'eq', $major, "major version: $major") if $major;
    cmp_ok( $detected->minor, 'eq', $minor, "minor version: $minor") if $minor;
    $os =~ tr[A-Z][a-z] if $os;

    if ( $os ) {
        $os =~ s{\s}{}gxms;
        ok( $detected->$os, $os ) if $os;
    }

    foreach my $type ( @{ $match } ) {
        ok( $detected->$type, "$type should match" );
    }

    # Test that $ua doesn't match a specific method
    foreach my $type ( @{ $no_match } ) {
        ok( !$detected->$type, "$type shouldn't match (and doesn't)" );
    }

    #diag( dump $test );

}
