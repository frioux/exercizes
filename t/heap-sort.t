#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Deep;

sub max_i {
   my $x;
   my $i = 0;
   my $max_i = 0;
   for (@_) {
      if (!defined $x || $_ > $x) {
         $x = $_;
         $max_i = $i;
      }
      $i++;
   }
   return ($max_i, $x);
}
sub heap_sort { _conquer(_heapify(@_)) }

sub _heapify {
   return () if @_ == 0;
   my ($i, $x) = max_i(@_);
   splice @_, $i, 1;
   my @l = splice @_, 0, int @_ / 2;
   my @r = @_;
   return [$x, _heapify(@l), _heapify(@r)]
}

sub _merge_heap {
   my ($l, $r) = @_;

   return () unless $l;
   return $l unless $r;

   if ($l->[0] > $r->[0]) {
      return [
         $l->[0], 
         _merge_heap($l->[1], $l->[2]),
         $r,
      ];
   } else {
      return [
         $r->[0], 
         _merge_heap($r->[1], $r->[2]),
         $l,
      ];
   }
}

sub _pop {
   my $heap = shift;
   my $ret = $heap->[0];
   return $ret if @$heap == 1;
   $heap = _merge_heap($heap->[1], $heap->[2]);
   return $ret, $heap;
}

sub _conquer {
   my $heap = shift;

   my $top;
   my @foo;
   while (($top, $heap) = _pop($heap)) {
      unshift @foo, $top;
      last unless $heap;
   }
   
   return @foo;
}

my @data = map int rand 100, 1..20;
cmp_deeply([heap_sort(@data)], [sort { $a <=> $b } @data], 'sort works!');

done_testing;
