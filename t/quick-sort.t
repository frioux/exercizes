#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Deep;

sub quicksort {
   return @_ if @_ <= 1;

   my $pivot_i = int @_ / 2;
   my $pivot = $_[$pivot_i];

   my (@l, @r);

   my $i = 0;
   for (@_) {
      $i++, next if $i == $pivot_i;
      if ($_ <= $pivot) {
         push @l, $_;
      } else {
         push @r, $_;
      }
      $i++;
   }

   return (quicksort(@l), $pivot, quicksort(@r))
}

my @data = map int rand 100, 1..20;
cmp_deeply([quicksort(@data)], [sort { $a <=> $b } @data], 'sort works!');

done_testing;
