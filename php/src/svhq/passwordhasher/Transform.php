<?php
namespace svhq\passwordhasher{

    use InvalidArgumentException;

    class Transform{

        public static function strToHex(string $string) : int {
            if(strlen($string) != 2){
                throw new InvalidArgumentException("invalid string length");
            }
            if(!preg_match('([a-f0-9]{2})', $string)){
                throw new InvalidArgumentException("invalid string format");
            }
            return hexdec($string);
        }
        /**
         * Not just a lower-to-upper. The input is cycled so even numbers and non-letter
         * characters are valid input.
         */
        public static function changeUpper(string $lower){
            $dec = hexdec($lower);
            $modded = ($dec % 24) + 65;
            // $char = [char[]]$modded;
            return chr($modded);
        }

        public static function changeSpecial(string $string){
            $dec = hexdec($string);
            $modded = ($dec % 7) + 58;
            return chr($modded);
        }
    }
}