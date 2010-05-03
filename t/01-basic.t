#!perl -T

use warnings;
use strict;

use Test::More tests => 13;

use HTML::Examiner;
use Data::Dumper;

# 1
my $errors = {
   '0' => {
      'source' => 'tag(img) misses prop(alt) => error "image misses alt"',
   },
};
my $examiner = HTML::Examiner->new($errors);
my $report = $examiner->examine('<img />');
my $expected = ['image misses alt'];
is_deeply($report, $expected, 'tag misses prop');

# 2
$errors = {
   '0' => {
      'source' => 'tag(img) contains prop(style) => error "image contains style"',
   },
};
$examiner = HTML::Examiner->new($errors);
$report = $examiner->examine('<img style="color: red;"/>');
$expected = ['image contains style'];
is_deeply($report, $expected, 'tag contains prop');

# 3
$errors = {
   '0' => {
      'source' => 'tag(ANY) contains prop(style) => error "ANY contains style"',
   },
};
$examiner = HTML::Examiner->new($errors);
$report = $examiner->examine('<h2 style="color: red;">header</h2>');
$expected = ['ANY contains style'];
is_deeply($report, $expected, 'any contains prop');

# 4
$errors = {
   '0' => {
      'source' => 'tag(ANY) misses prop(style) => error "ANY misses style"',
   },
};
$examiner = HTML::Examiner->new($errors);
$report = $examiner->examine('<h2>header</h2>');
$expected = ['ANY misses style'];
is_deeply($report, $expected, 'any misses prop');

# 5
$errors = {
   '0' => {
      'source' => 'tag(table) => error "table found"',
   },
};
$examiner = HTML::Examiner->new($errors);
$report = $examiner->examine('<table><tr><td>c</td></tr></table>');
$expected = ['table found'];
is_deeply($report, $expected, 'tag exists');

# 6
$errors = {
   '0' => {
      'source' => 'tag(a).prop(target) matches /_blank/ => error "no new windows"',
   },
};
$examiner = HTML::Examiner->new($errors);
$report = $examiner->examine('<a href="link.html" target="_blank">link</a>');
$expected = ['no new windows'];
is_deeply($report, $expected, 'prop matches regexp');

# 7
$report = $examiner->examine('<a href="link.html" target="ANYTHINGELSE">link</a>');
$expected = [];
is_deeply($report, $expected, 'prop matches regexp 2');

# 8
$errors = {
   '0' => {
      'source' => 'tag(a).prop(href) mismatches /^http/ => error "href not http"',
   },
};
$examiner = HTML::Examiner->new($errors);
$report = $examiner->examine('<a href="link.html">link</a>');
$expected = ['href not http'];
is_deeply($report, $expected, 'prop mismatches regexp');

# 9
$report = $examiner->examine('<a href="http://foo.bar/link.html">link</a>');
$expected = [];
is_deeply($report, $expected, 'prop mismatches regexp 2');

# 10
$errors = {
   '0' => {
      'source' => 'tag(h1).content matches /title/ => error "word title inside header tag"',
   },
};
$examiner = HTML::Examiner->new($errors);
$report = $examiner->examine('<h1>i have a title word</h1>');
$expected = ['word title inside header tag'];
is_deeply($report, $expected, 'content matches regexp');

# 11
$report = $examiner->examine('<h1>i do not</h1>');
$expected = [];
is_deeply($report, $expected, 'content matches regexp 2');

# 12
$errors = {
   '0' => {
      'source' => 'tag(h1).content mismatches /title/ => error "word title not inside header tag"',
   },
};
$examiner = HTML::Examiner->new($errors);
$report = $examiner->examine('<h1>i do not</h1>');
$expected = ['word title not inside header tag'];
is_deeply($report, $expected, 'content mismatches regexp');

# 13
$report = $examiner->examine('<h1>i have a title word</h1>');
$expected = [];
is_deeply($report, $expected, 'content mismatches regexp 2');


