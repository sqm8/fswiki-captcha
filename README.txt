!!!CAPTCHAプラグイン

README

 Hiro Sakuma <sakuma@zero52.com>
 Copyright 2005-2009 BitCoffee, Inc. All Rights Reserved.
 Copyright (C) medicalsystems, Inc.



!!CAPTCHAプラグインとは

CAPTCHA (Completely Automated Public Turning test to tell Computers and Humans Apart) という画像に表示される文字列をユーザに入力してもらうことで，スパム対策を行います．



!!使い方

インストールするだけです．



!!必要なソフトウェア

CAPTCHAプラグインでは，外部ライブラリとして，Perlモジュールの GD::SecurityImage::AC を必要とします．

Perl module の，GD::SecurityImage::AC が必要ですので，インストールしてください．

""# cpan install GD::SecurityImage::AC




!!同梱ファイル

画像の生成に TrueType Font を必要とします．

Free UCS Outline Fonts の FreeSansBold.ttf を同梱しています．
http://savannah.nongnu.org/projects/freefont/

このファイルのライセンスは GPL Version 2 です．ライセンスの詳細は同梱の gpl.txt を参照してください．



