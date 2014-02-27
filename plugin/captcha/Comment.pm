package plugin::captcha::Comment;
# 

# $Id: Comment.pm,v 1.1 2007/05/14 04:52:41 sakuma Exp $
#
# Copyright 2005-2009 BitCoffee, Inc. All rights reserved.
# Copyright (C) medicalsystems, Inc.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# * Neither the name of the nor the names of its contributors may be used to
#   endorse or promote products derived from this software without specific
#   prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

use strict;
use lib "./lib";

use plugin::comment::Comment;
@plugin::captcha::Comment::ISA = qw(plugin::comment::Comment);


# /**
#  * Constructor
#  * @author Hiro Sakuma <sakuma@zero52.com>
#  * @return $self
#  */

sub new {

	my $class = shift;
	my $self = new plugin::comment::Comment();

	use plugin::captcha::Captcha;

	return bless $self, $class;

}


# /*
#  * paragraph
#  * @author Hiro Sakuma <sakuma@zero52.com>
#  * @param $wiki
#  * @param $opt
#  * @return $str
#  */

sub paragraph {

	my $self = shift;
	my $wiki = shift;
	my $opt  = shift;
	my $cgi = $wiki->get_CGI();
	my ($config, $login, $captcha, $return, $insert, $md5);

	$config = &Util::load_config_hash($wiki, "captcha.dat");

	$login = $wiki->get_login_info($cgi);

	if ((!defined($login) && $config->{user_g}) || $config->{"user_" . $login->{type}}) {


		$captcha = new plugin::captcha::Captcha();
		$captcha->create($wiki);


		$md5 = $captcha->generate_code($wiki->config('captcha_number_of_characters'));


		$return = $self->SUPER::paragraph($wiki, $opt, @_);

		$insert = "<p>";
		$insert .= "<img src=\"" . $wiki->config('script_name') . "?action=CAPTCHA&amp;md5=$md5\" />";
		$insert .= "<br />";
		$insert .= "表示された文字列";
		$insert .= "<input type=\"text\" name=\"code\" value=\"\" />";
		$insert .= "<input type=\"hidden\" name=\"md5\" value=\"$md5\" />";
		$insert .= "</p>";

		$return =~ s/<input type="submit" /$insert<input type="submit" /;

	} else {

		$return = $self->SUPER::paragraph($wiki, $opt, @_);

	}

	return $return;

}



1;
