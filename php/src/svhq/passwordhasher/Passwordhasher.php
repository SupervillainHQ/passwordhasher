<?php
namespace svhq\passwordhasher{
    class Passwordhasher{
        private string $domain;
        private ?string $hash;
        private string $specials = '';
        private string $capped = '';
        private int $len = 32;

        public function getDomain() : string {
            return $this->domain;
        }
        
        public function getHash() : ?string {
            if(!isset($this->hash)){
                return null;
            }
            $s = strlen(trim($this->specials));
            $c = strlen(trim($this->capped));
            if($this->len < 32){
                $this->hash = substr($this->hash, 0, $this->len);
            }
            if($s > 0){
                $this->hash = substr_replace($this->hash, trim($this->specials), 0, $s);
            }
            if($c > 0){
                $this->hash = substr_replace($this->hash, $this->capped, $this->len - $c, $c);
            }
            return $this->hash;
        }

        public function __construct(string $domain = ''){
            $this->domain = $domain;
        }
        
        public function hashIt(string $salt = '') : Passwordhasher {
            $this->hash = md5("{$this->domain}{$salt}");
            return $this;
        }

        public function changeToUpper(int $caps) : Passwordhasher {
            if(is_null($this->hash)){
                return $this;
            }
            $this->capped = "";
            for($i = 1; $i <= $caps; $i++){
                $gap = $i * 2;
                $chunk = substr($this->hash, 32 - $gap, 2);
                $this->capped = $this->capped . Transform::changeUpper($chunk);
            }
            return $this;
        }

        public function changeToSpecial(int $caps) : Passwordhasher {
            if(is_null($this->hash)){
                return $this;
            }
            $this->specials = "";
            for($i = 1; $i <= $caps; $i++){
                $this->specials = $this->specials . Transform::changeSpecial(substr($this->hash, ($i-1) * 2, 2));
            }
            return $this;
        }

        public function changeLength(int $len) : Passwordhasher {
            // if(is_null($this->hash)){
            //     return $this;
            // }
            $this->len = $len;
            return $this;
        }
    }
}