package plugin::captcha::BBS2Handler;
# 

# $Id: BBS2Handler.pm,v 1.2 2007/05/19 03:30:04 sakuma Exp $
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

use plugin::bbs::BBS2Handler;
@plugin::captcha::BBS2Handler::ISA = qw(plugin::bbs::BBS2Handler);


# /**
#  * Constructor
#  * @author Hiro Sakuma <sakuma@zero52.com>
#  * @return $self
#  */

sub new {

	my $class = shift;
	my $self = new plugin::bbs::BBS2Handler();

	use plugin::captcha::Captcha;

	return bless $self, $class;

}


# /*
#  * do_action
#  * @author Hiro Sakuma <sakuma@zero52.com>
#  * @param $wiki
#  * @return $str
#  */

sub do_action {

	my $self = shift;
	my $wiki = shift;
	my $cgi = $wiki->get_CGI();
	my ($config, $login, $captcha, $check, $return);

	$config = &Util::load_config_hash($wiki, "captcha.dat");

	$login = $wiki->get_login_info($cgi);

	if ((!defined($login) && $config->{user_g}) || $config->{"user_" . $login->{type}}) {


		$captcha = new plugin::captcha::Captcha();
		$captcha->create($wiki);


		# 保存処理
		$check = $captcha->check_code($cgi->param('code'), $cgi->param('md5'));
		###warn($check);
		if ($check != 1) {
			return $wiki->error("入力された文字列が違います");
		}

	}

	$return = $self->SUPER::do_action($wiki, @_);

	return $return;

}



1;
