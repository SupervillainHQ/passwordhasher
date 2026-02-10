<?php
namespace tests\svhq\passwordhasher{

    use PHPUnit\Framework\TestCase;
    use svhq\passwordhasher\Transform;

    class TransformTest extends TestCase{
        function testStrToHex(){
            $this->expectException(\InvalidArgumentException::class);
            Transform::strToHex('g0');

            $this->expectException(\InvalidArgumentException::class);
            Transform::strToHex('a');

            $this->expectException(\InvalidArgumentException::class);
            Transform::strToHex('123');

            $transformed = Transform::strToHex('00');
            $this->assertEquals(0, $transformed);

            $transformed = Transform::strToHex('FF');
            $this->assertEquals(255, $transformed);

            $string = "9b";
            $transformed = Transform::strToHex($string);
            $this->assertEquals(155, $transformed);

            $string = "c4";
            $transformed = Transform::strToHex($string);
            $this->assertEquals(196, $transformed);
        }

        function testChangeUpper(){
            $string = "9b";
            $transformed = Transform::changeUpper($string);
            $this->assertEquals('L', $transformed);
        }

        function testChangeSpecial(){
            $string = "c4";
            $transformed = Transform::changeSpecial($string);
            $this->assertEquals(':', $transformed);
        }
    }
}