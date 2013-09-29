#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Deep;

my $h = Hash->new;
$h->insert('foo', 'bar');
$h->insert('foo1', 'bar1');
$h->insert('foo2', 'bar2');
$h->insert('foo3', 'bar3');
is($h->access('foo'), 'bar', 'sorta works');
is($h->access('foo1'), 'bar1', 'sorta works');
is($h->access('foo2'), 'bar2', 'sorta works');
is($h->access('foo3'), 'bar3', 'sorta works');
warn $h->_collisions;
use Devel::Dwarn;
Dwarn $h;
done_testing;

BEGIN {

   package Hash;
   use Moo;

   has _collisions => (
      is => 'rw',
      default => 0,
   );

   sub _inc_collisions {
      $_[0]->_collisions($_[0]->_collisions + $_[1]) if $_[1];

      $_[1]
   }

   has _size => (
      is => 'ro',
      default => 1024,
   );

   has _container => (
      is => 'lazy',
      builder => sub {
         +[
            map [], 1..$_[0]->_size
         ]
      },
   );

   sub _hash {
      my ($self, $value) = @_;

      my $S = length $value;
      my $a = 256;

      my $ret = 0;
      my $i = 0;
      for (split qr//, $value) {
         $ret += $a**($S - ($i + 1)) * ord($_);
         $i++;
      }

      return $ret % $self->_size;
   }

   sub insert { 
      my $bucket = $_[0]->_container->[$_[0]->_hash($_[1])];
      $bucket->[
         $_[0]->_inc_collisions(scalar @$bucket)
      ] = [$_[1], $_[2]];
   }

   sub access { 
      my $bucket = $_[0]->_container->[$_[0]->_hash($_[1])];
      for (@$bucket) {
         return $_->[1] if $_->[0] eq $_[1]
      }
      return undef;
   }
}
