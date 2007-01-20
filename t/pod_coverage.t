# $Id: pod_coverage.t,v 1.1.1.1 2007/01/20 00:37:45 comdog Exp $
use Test::More;
eval "use Test::Pod::Coverage 1.00";
plan skip_all => "Test::Pod::Coverage 1.00 required for testing POD coverage" if $@;
all_pod_coverage_ok();
																						 