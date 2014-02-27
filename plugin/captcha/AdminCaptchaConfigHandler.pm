package plugin::captcha::AdminCaptchaConfigHandler;
# 

# $Id: AdminCaptchaConfigHandler.pm,v 1.2 2007/05/14 04:52:41 sakuma Exp $
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


# /**
#  * Constructor
#  * @author Hiro Sakuma <sakuma@zero52.com>
#  * @return $self
#  */

sub new {

	my $class = shift;
	my $self = {};

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
	my $cgi = $wiki->get_CGI;

	$wiki->set_title("CAPTCHAÀßÄê");

	if($cgi->param("SAVE") ne "") {
		return $self->save_config($wiki);
	} else {
		return $self->form($wiki);
	}

}


# /*
#  * save_config
#  * @author Hiro Sakuma <sakuma@zero52.com>
#  * @param $wiki
#  * @return $str
#  */

sub save_config {

	my $self = shift;
	my $wiki = shift;
	my $cgi  = $wiki->get_CGI;
	my $config;

	$config = &Util::load_config_hash($wiki, "captcha.dat");

	$config->{user_0} = $cgi->param("user_0") || "0";
	$config->{user_1} = $cgi->param("user_1") || "0";
	$config->{user_g} = $cgi->param("user_g") || "0";

	&Util::save_config_hash($wiki, "captcha.dat", $config);

	$wiki->redirectURL($wiki->config('script_name') . "?action=ADMINCAPTCHACONFIG");

}


# /*
#  * form
#  * @author Hiro Sakuma <sakuma@zero52.com>
#  * @param $wiki
#  * @return $str
#  */

sub form {

	my $self = shift;
	my $wiki = shift;
	my ($default, $config, $return);

	$default = {
		user_0 => "0",
		user_1 => "0",
		user_g => "1",
	};

	$config = &Util::load_config_hash($wiki, "captcha.dat");

	foreach (keys %$default) {
		if (!defined($config->{$_})) {
			$config->{$_} = $default->{$_};
		}
	}

	my $tmpl = HTML::Template->new(
		filename => $wiki->config('tmpl_dir') . "/admin_captcha_config.tmpl",
		die_on_bad_params => 0,
	);

	$tmpl->param(
		USER_0 => $config->{user_0},
		USER_1 => $config->{user_1},
		USER_G => $config->{user_g},
	);

	$return = "<form action=\"" . $wiki->config('script_name') . "\" method=\"post\">\n";
	$return .= $tmpl->output();
	$return .= "<input type=\"hidden\" name=\"action\" value=\"ADMINCAPTCHACONFIG\" />\n";
	$return .= "</form>\n";

	return $return;

}



1;
