# $Id: prereq.t,v 1.1.1.1 2007/01/20 00:37:45 comdog Exp $
use Test::More;
eval "use Test::Prereq";
plan skip_all => "Test::Prereq required to test dependencies" if $@;
prereq_ok();
