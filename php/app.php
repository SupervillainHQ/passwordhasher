<?php

use svhq\passwordhasher\Passwordhasher;

require_once __DIR__ . '/vendor/autoload.php';

$hasher = new Passwordhasher('1');
$hasher->hashIt()->changeLength(26)->changeToUpper(3)->changeToSpecial(2);
$hash = $hasher->getHash();
var_dump($hash);