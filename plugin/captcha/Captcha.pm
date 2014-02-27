package plugin::captcha::Captcha;
# 

# $Id: Captcha.pm,v 1.1 2007/05/14 04:52:41 sakuma Exp $
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

	use GD::SecurityImage::AC;
	use File::Path;

	return bless $self, $class;

}


# /*
#  * create
#  * @author Hiro Sakuma <sakuma@zero52.com>
#  * @param $wiki
#  * @return $captcha
#  */

sub create {

	my $self = shift;
	my $wiki = shift;
	my $cgi = $wiki->get_CGI();
	my ($login, $config);

	$config = &Util::load_config_hash($wiki, "captcha.dat");

	$login = $wiki->get_login_info($cgi);

	if (!-d $wiki->config('captcha_tmp_dir') . "/data") {
		mkpath($wiki->config('captcha_tmp_dir') . "/data") or die $!;
	}

	if (!-d $wiki->config('captcha_tmp_dir') . "/output") {
		mkpath($wiki->config('captcha_tmp_dir') . "/output") or die $!;
	}

	$self->{captcha} = new GD::SecurityImage::AC();
	$self->{captcha}->gdsi(
		new => {
			width => $wiki->config('captcha_width'),
			height => $wiki->config('captcha_height'),
			font => $wiki->config('captcha_font'),
			ptsize => $wiki->config('captcha_ptsize'),
			scramble => 1,
			angle => 15,
			bgcolor => '#ffffff',
		},
		create => [
			ttf => 'ec',
			'#000000',
			'#003399',
		],
		particle => [
			2500,
			1,
		],
	);
	$self->{captcha}->data_folder($wiki->config('captcha_tmp_dir') . "/data");
	$self->{captcha}->output_folder($wiki->config('captcha_tmp_dir') . "/output");
	$self->{captcha}->expire($wiki->config('captcha_expire'));
	$self->{captcha}->keep_failures(1);


	return $self->{captcha};


}



sub check_code {

	my $self = shift;
	my $code = shift;
	my $md5 = shift;
	my ($check);

	$check = $self->{captcha}->check_code($code, $md5);

	return $check;

}



sub generate_code {

	my $self = shift;
	my $number_of_characters = shift;
	my ($md5);

	$md5 = $self->{captcha}->generate_code($number_of_characters);

	return $md5;

}


1;
