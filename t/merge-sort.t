#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Deep;

sub merge { _merge(_split(@_)) }

sub _split {
   my @l = splice @_, 0, int @_ / 2;
   my @r = @_;

   @l = _split(@l) unless @l == 1;
   @r = _split(@r) unless @r == 1;

   return \@l, \@r
}
sub _merge {
   my ($l, $r) = @_;

   my @a;

   my @l = @$l;
   my @r = @$r;
   while (@r || @l) {
  
      @r = _merge(@r) if ref $r[0];
      @l = _merge(@l) if ref $l[0];
      if (!@r) {
         push @a, @l;
         @l = ();
      }

      elsif (!@l) {
         push @a, @r;
         @r = ();
      }

      elsif ($l[0] <= $r[0]) {
         push @a, shift @l
      }

      else {
         push @a, shift @r
      }
   }

   return @a;
}

my @data = map int rand 100, 1..20;
cmp_deeply([merge(@data)], [sort { $a <=> $b } @data], 'sort works!');

done_testing;
