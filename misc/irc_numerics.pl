#!/usr/bin/perl -w

use warnings;
use strict;
use diagnostics;
use Carp;

my %names = (
	   # suck!  these aren't treated as strings --
	   # 001 ne 1 for the purpose of hash keying, apparently.
	   '001' => "welcome",
	   '002' => "yourhost",
	   '003' => "created",
	   '004' => "myinfo",
	   '005' => "map", 		# Undernet Extension, Kajetan@Hinner.com, 17/11/98
	   '006' => "mapmore", 		# Undernet Extension, Kajetan@Hinner.com, 17/11/98
	   '007' => "mapend", 		# Undernet Extension, Kajetan@Hinner.com, 17/11/98	   	   
	   '008' => "snomask", 		# Undernet Extension, Kajetan@Hinner.com, 17/11/98	   
	   '009' => "statmemtot", 	# Undernet Extension, Kajetan@Hinner.com, 17/11/98	   
	   '010' => "statmem", 		# Undernet Extension, Kajetan@Hinner.com, 17/11/98	   

	   200 => "tracelink",
	   201 => "traceconnecting",
	   202 => "tracehandshake",
	   203 => "traceunknown",
	   204 => "traceoperator",
	   205 => "traceuser",
	   206 => "traceserver",
	   208 => "tracenewtype",
	   209 => "traceclass",
	   211 => "statslinkinfo",
	   212 => "statscommands",
	   213 => "statscline",
	   214 => "statsnline",
	   215 => "statsiline",
	   216 => "statskline",
	   217 => "statsqline",
	   218 => "statsyline",
	   219 => "endofstats",
           220 => "statsbline",             # UnrealIrcd, Hendrik Frenzel
	   221 => "umodeis",
           222 => "sqline_nick",            # UnrealIrcd, Hendrik Frenzel
           223 => "statsgline",             # UnrealIrcd, Hendrik Frenzel
           224 => "statstline",             # UnrealIrcd, Hendrik Frenzel
           225 => "statseline",             # UnrealIrcd, Hendrik Frenzel
           226 => "statsnline",             # UnrealIrcd, Hendrik Frenzel
           227 => "statsvline",             # UnrealIrcd, Hendrik Frenzel
	   231 => "serviceinfo",
	   232 => "endofservices",
	   233 => "service",
	   234 => "servlist",
	   235 => "servlistend",
	   241 => "statslline",
	   242 => "statsuptime",
	   243 => "statsoline",
	   244 => "statshline",
	   245 => "statssline",		# Reserved, Kajetan@Hinner.com, 17/10/98
	   246 => "statstline",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
	   247 => "statsgline",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
### TODO: need numerics to be able to map to multiple strings
###           247 => "statsxline",             # UnrealIrcd, Hendrik Frenzel
	   248 => "statsuline",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
	   249 => "statsdebug",		# Unspecific Extension, Kajetan@Hinner.com, 17/10/98
	   250 => "luserconns",   # 1998-03-15 -- tkil
	   251 => "luserclient",
	   252 => "luserop",
	   253 => "luserunknown",
	   254 => "luserchannels",
	   255 => "luserme",
	   256 => "adminme",
	   257 => "adminloc1",
	   258 => "adminloc2",
	   259 => "adminemail",
	   261 => "tracelog",
	   262 => "endoftrace",  # 1997-11-24 -- archon
	   265 => "n_local",     # 1997-10-16 -- tkil
	   266 => "n_global",    # 1997-10-16 -- tkil
	   271 => "silelist",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
	   272 => "endofsilelist",	# Undernet Extension, Kajetan@Hinner.com, 17/10/98
	   275 => "statsdline",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
	   280 => "glist",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
	   281 => "endofglist",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
           290 => "helphdr",            # UnrealIrcd, Hendrik Frenzel
           291 => "helpop",             # UnrealIrcd, Hendrik Frenzel
           292 => "helptlr",            # UnrealIrcd, Hendrik Frenzel
           293 => "helphlp",            # UnrealIrcd, Hendrik Frenzel
           294 => "helpfwd",            # UnrealIrcd, Hendrik Frenzel
           295 => "helpign",            # UnrealIrcd, Hendrik Frenzel

	   300 => "none",
	   301 => "away",
	   302 => "userhost",
	   303 => "ison",
	   304 => "rpl_text",           # Bahamut IRCD
	   305 => "unaway",
	   306 => "nowaway",
	   307 => "userip",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
           308 => "rulesstart",         # UnrealIrcd, Hendrik Frenzel
           309 => "endofrules",         # UnrealIrcd, Hendrik Frenzel
	   310 => "whoishelp",          # (July01-01)Austnet Extension, found by Andypoo <andypoo@secret.com.au>
	   311 => "whoisuser",
	   312 => "whoisserver",
	   313 => "whoisoperator",
	   314 => "whowasuser",
	   315 => "endofwho",
	   316 => "whoischanop",
	   317 => "whoisidle",
	   318 => "endofwhois",
	   319 => "whoischannels",
	   320 => "whoisvworld",        # (July01-01)Austnet Extension, found by Andypoo <andypoo@secret.com.au>
	   321 => "liststart",
	   322 => "list",
	   323 => "listend",
	   324 => "channelmodeis",
	   329 => "channelcreate",  # 1997-11-24 -- archon
	   331 => "notopic",
	   332 => "topic",
	   333 => "topicinfo",      # 1997-11-24 -- archon
	   334 => "listusage",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
           335 => "whoisbot",           # UnrealIrcd, Hendrik Frenzel
	   341 => "inviting",
	   342 => "summoning",
           346 => "invitelist",         # UnrealIrcd, Hendrik Frenzel
           347 => "endofinvitelist",    # UnrealIrcd, Hendrik Frenzel
           348 => "exlist",             # UnrealIrcd, Hendrik Frenzel
           349 => "endofexlist",        # UnrealIrcd, Hendrik Frenzel
	   351 => "version",
	   352 => "whoreply",
	   353 => "namreply",
	   354 => "whospcrpl",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
	   361 => "killdone",
	   362 => "closing",
	   363 => "closeend",
	   364 => "links",
	   365 => "endoflinks",
	   366 => "endofnames",
	   367 => "banlist",
	   368 => "endofbanlist",
	   369 => "endofwhowas",
	   371 => "info",
	   372 => "motd",
	   373 => "infostart",
	   374 => "endofinfo",
	   375 => "motdstart",
	   376 => "endofmotd",
	   377 => "motd2",        # 1997-10-16 -- tkil
	   378 => "austmotd",		# (July01-01)Austnet Extension, found by Andypoo <andypoo@secret.com.au>
           379 => "whoismodes",         # UnrealIrcd, Hendrik Frenzel
	   381 => "youreoper",
	   382 => "rehashing",
           383 => "youreservice",       # UnrealIrcd, Hendrik Frenzel
	   384 => "myportis",
	   385 => "notoperanymore",	# Unspecific Extension, Kajetan@Hinner.com, 17/10/98
           386 => "qlist",              # UnrealIrcd, Hendrik Frenzel
           387 => "endofqlist",         # UnrealIrcd, Hendrik Frenzel
           388 => "alist",              # UnrealIrcd, Hendrik Frenzel
           389 => "endofalist",         # UnrealIrcd, Hendrik Frenzel
	   391 => "time",
	   392 => "usersstart",
	   393 => "users",
	   394 => "endofusers",
	   395 => "nousers",

	   401 => "nosuchnick",
	   402 => "nosuchserver",
	   403 => "nosuchchannel",
	   404 => "cannotsendtochan",
	   405 => "toomanychannels",
	   406 => "wasnosuchnick",
	   407 => "toomanytargets",
           408 => "nosuchservice",      # UnrealIrcd, Hendrik Frenzel
	   409 => "noorigin",
	   411 => "norecipient",
	   412 => "notexttosend",
	   413 => "notoplevel",
	   414 => "wildtoplevel",
	   416 => "querytoolong",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
	   421 => "unknowncommand",
	   422 => "nomotd",
	   423 => "noadmininfo",
	   424 => "fileerror",
           425 => "noopermotd",         # UnrealIrcd, Hendrik Frenzel
	   431 => "nonicknamegiven",
	   432 => "erroneusnickname",   # This iz how its speld in thee RFC.
	   433 => "nicknameinuse",
           434 => "norules",            # UnrealIrcd, Hendrik Frenzel
           435 => "serviceconfused",    # UnrealIrcd, Hendrik Frenzel
	   436 => "nickcollision",
	   437 => "bannickchange",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
	   438 => "nicktoofast",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
	   439 => "targettoofast",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
           440 => "servicesdown",           # Bahamut IRCD
	   441 => "usernotinchannel",
	   442 => "notonchannel",
	   443 => "useronchannel",
	   444 => "nologin",
	   445 => "summondisabled",
	   446 => "usersdisabled",
           447 => "nonickchange",       # UnrealIrcd, Hendrik Frenzel
	   451 => "notregistered",
           455 => "hostilename",        # UnrealIrcd, Hendrik Frenzel
           459 => "nohiding",           # UnrealIrcd, Hendrik Frenzel
           460 => "notforhalfops",      # UnrealIrcd, Hendrik Frenzel
	   461 => "needmoreparams",
	   462 => "alreadyregistered",
	   463 => "nopermforhost",
	   464 => "passwdmismatch",
	   465 => "yourebannedcreep", # I love this one...
	   466 => "youwillbebanned",
	   467 => "keyset",
	   468 => "invalidusername",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
           469 => "linkset",            # UnrealIrcd, Hendrik Frenzel
           470 => "linkchannel",        # UnrealIrcd, Hendrik Frenzel
	   471 => "channelisfull",
	   472 => "unknownmode",
	   473 => "inviteonlychan",
	   474 => "bannedfromchan",
	   475 => "badchannelkey",
	   476 => "badchanmask",
           477 => "needreggednick",           # Bahamut IRCD
	   478 => "banlistfull",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
           479 => "secureonlychannel",        # pircd
### TODO: see above todo
###           479 => "linkfail",               # UnrealIrcd, Hendrik Frenzel
           480 => "cannotknock",        # UnrealIrcd, Hendrik Frenzel
	   481 => "noprivileges",
	   482 => "chanoprivsneeded",
	   483 => "cantkillserver",
	   484 => "ischanservice",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
           485 => "killdeny",           # UnrealIrcd, Hendrik Frenzel
           486 => "htmdisabled",        # UnrealIrcd, Hendrik Frenzel
           489 => "secureonlychan",     # UnrealIrcd, Hendrik Frenzel
	   491 => "nooperhost",
	   492 => "noservicehost",

	   501 => "umodeunknownflag",
	   502 => "usersdontmatch",

	   511 => "silelistfull",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
	   513 => "nosuchgline",		# Undernet Extension, Kajetan@Hinner.com, 17/10/98
	   513 => "badping",			# Undernet Extension, Kajetan@Hinner.com, 17/10/98
           518 => "noinvite",           # UnrealIrcd, Hendrik Frenzel
           519 => "admonly",            # UnrealIrcd, Hendrik Frenzel
           520 => "operonly",           # UnrealIrcd, Hendrik Frenzel
           521 => "listsyntax",         # UnrealIrcd, Hendrik Frenzel
           524 => "operspverify",       # UnrealIrcd, Hendrik Frenzel

           600 => "rpl_logon",           # Bahamut IRCD
           601 => "rpl_logoff",           # Bahamut IRCD
           602 => "rpl_watchoff",       # UnrealIrcd, Hendrik Frenzel
           603 => "rpl_watchstat",      # UnrealIrcd, Hendrik Frenzel
           604 => "rpl_nowon",           # Bahamut IRCD
           605 => "rpl_nowoff",           # Bahamut IRCD
           606 => "rpl_watchlist",      # UnrealIrcd, Hendrik Frenzel
           607 => "rpl_endofwatchlist", # UnrealIrcd, Hendrik Frenzel
           610 => "mapmore",            # UnrealIrcd, Hendrik Frenzel
           640 => "rpl_dumping",        # UnrealIrcd, Hendrik Frenzel
           641 => "rpl_dumprpl",        # UnrealIrcd, Hendrik Frenzel
           642 => "rpl_eodump",         # UnrealIrcd, Hendrik Frenzel

           999 => "numericerror",           # Bahamut IRCD

	  );

print join(";\n", map {
  my $numeric = $_;
  my $len = length("$numeric");
  my $num = ((3 - $len) x "0") . $numeric;

  "numeric_to_atom(\"$num\") -> $names{$numeric}"
} sort keys %names), ".\n";

print "\n\n";

print join(";\n", map {
  my $numeric = $_;
  my $len = length("$numeric");
  my $num = ((3 - $len) x "0") . $numeric;

  "atom_to_numeric($names{$numeric}) -> \"$num\""
} sort keys %names), ".\n";
