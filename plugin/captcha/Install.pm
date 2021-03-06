package plugin::captcha::Install;
# CAPTCHAを使ったスパム対策。

# $Id: Install.pm,v 1.2 2007/05/14 04:52:41 sakuma Exp $
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


# /*
#  * install
#  * @author Hiro Sakuma <sakuma@zero52.com>
#  * @param $wiki
#  * @param $cgi
#  * @return $str
#  */

sub install {

	my $wiki = shift;

	$wiki->add_hook("initialize", "plugin::captcha::Initialize");

	$wiki->add_handler("CAPTCHA", "plugin::captcha::CaptchaHandler");

	$wiki->add_admin_handler("ADMINCAPTCHACONFIG", "plugin::captcha::AdminCaptchaConfigHandler");

	$wiki->add_admin_menu("CAPTCHA設定", $wiki->config('script_name')."?action=ADMINCAPTCHACONFIG", 989, "CAPTCHAの設定を行います。");

}


1;
