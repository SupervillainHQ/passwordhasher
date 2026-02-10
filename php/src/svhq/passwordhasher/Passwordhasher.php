<?php
namespace svhq\passwordhasher{
    class Passwordhasher{
        private string $domain;
        private string $hash;

        public function getDomain(){
            return $this->domain;
        }
        
        public function getHash(){
            return $this->hash;
        }

        public function __construct(string $domain){
            $this->domain = $domain;
        }
        
        public function hashIt(string $salt) : Passwordhasher {
            $this->hash = md5("{$this->domain}{$salt}");
            return $this;
        }

        /**
         * Not just a lower-to-upper. The input is cycled so even numbers and non-letter
         * characters are valid input.
         */
        private static function changeUpper(string $lower){
            // $dec = [Convert]::ToString([uint32]"0x000000$string", 10);
            $dec = ord($lower);
            $modded = ($dec % 24) + 65;
            // $char = [char[]]$modded;
            return chr($modded);
        }
        public function changeToUpper(int $caps) : Passwordhasher {
            if(is_null($this->hash)){
                return $this;
            }
            $capped = "";
            for($i = 1; $i <= $caps; $i++){
                $sub = $i * 2;
                $capped = $capped . self::changeUpper(substr($this->hash, 32 - $sub, 2));
            }
            return $this;
        }

        private static function changeSpecial(string $string){
            $dec = [Convert]::ToString([uint32]"0x000000$string", 10);
            $modded = ($dec % 7) + 58;
            $char = [char[]]$modded;
            return $char;
        }
        public function changeToSpecial(int $caps) : Passwordhasher {
            if(is_null($this->hash)){
                return $this;
            }
            $special = "";
            for($i = 1; $i <= $caps; $i++){
                $sub = $i * 2;
                $special = $special . self::changeSpecial(substr($this->hash, ($i-1) * 2, 2));
            }

            return $this;
        }

        public function cut(int $len) : Passwordhasher {
            if(is_null($this->hash)){
                return $this;
            }
            return $this;
        }
    }
}