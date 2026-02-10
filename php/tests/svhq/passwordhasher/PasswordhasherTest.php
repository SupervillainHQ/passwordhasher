<?php
namespace tests\svhq\passwordhasher{

    use PHPUnit\Framework\TestCase;
    use svhq\passwordhasher\Passwordhasher;

    class PasswordhasherTest extends TestCase{
        public function testConstruct(){
            $hasher = new Passwordhasher('');
            $this->assertNotNull($hasher);
            $this->assertNull($hasher->getHash());
            $this->assertEquals('', $hasher->getDomain());
        }

        public function testHash(){
            $hasher = new Passwordhasher('a');
            $hasher->hashIt();
            $this->assertNotNull($hasher);
            $this->assertEquals('a', $hasher->getDomain());
            $this->assertEquals('0cc175b9c0f1b6a831c399e269772661', $hasher->getHash());

            $hasher = new Passwordhasher('1');
            $hasher->hashIt();
            $this->assertEquals('1', $hasher->getDomain());
            $this->assertEquals('c4ca4238a0b923820dcc509a6f75849b', $hasher->getHash());

            # fiddle with upper-case transformation
            $hasher = new Passwordhasher('1');
            $hasher->hashIt()->changeToUpper(1);
            $this->assertEquals('1', $hasher->getDomain());
            $this->assertEquals('c4ca4238a0b923820dcc509a6f75849L', $hasher->getHash());

            $hasher = new Passwordhasher('1');
            $hasher->hashIt()->changeToUpper(2);
            $this->assertEquals('1', $hasher->getDomain());
            $this->assertEquals('c4ca4238a0b923820dcc509a6f7584LM', $hasher->getHash());

            # fiddle with special-character transformation
            $hasher = new Passwordhasher('1');
            $hasher->hashIt()->changeToSpecial(1);
            $this->assertEquals('1', $hasher->getDomain());
            $this->assertEquals(':4ca4238a0b923820dcc509a6f75849b', $hasher->getHash());

            $hasher = new Passwordhasher('1');
            $hasher->hashIt()->changeToSpecial(2);
            $this->assertEquals('1', $hasher->getDomain());
            $this->assertEquals(':@ca4238a0b923820dcc509a6f75849b', $hasher->getHash());

            # fiddle with special-char & upper-case combo transformation
            $hasher = new Passwordhasher('1');
            $hasher->hashIt()->changeToUpper(1)->changeToSpecial(1);
            $this->assertEquals('1', $hasher->getDomain());
            $this->assertEquals(':4ca4238a0b923820dcc509a6f75849L', $hasher->getHash());

            # fiddle with length transformation
            $hasher = new Passwordhasher('1');
            $hasher->hashIt()->changeLength(20);
            $this->assertEquals('1', $hasher->getDomain());
            $this->assertEquals('c4ca4238a0b923820dcc', $hasher->getHash());

            $hasher = new Passwordhasher('1');
            $hasher->hashIt()->changeLength(12);
            $this->assertEquals('1', $hasher->getDomain());
            $this->assertEquals('c4ca4238a0b9', $hasher->getHash());

            # fiddle with transformations in any combination
            $hasher = new Passwordhasher('1');
            $hasher->hashIt()->changeLength(20)->changeToUpper(1);
            $this->assertEquals('1', $hasher->getDomain());
            $this->assertEquals('c4ca4238a0b923820dcL', $hasher->getHash());

            $hasher = new Passwordhasher('1');
            $hasher->hashIt()->changeLength(26)->changeToUpper(3)->changeToSpecial(2);
            $this->assertEquals('1', $hasher->getDomain());
            $this->assertEquals(':@ca4238a0b923820dcc509LMV', $hasher->getHash());
        }
    }
}