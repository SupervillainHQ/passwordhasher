# passwordhasher

A simple utility that creates a unique password for every website, while only requiring you to remember a single master password.

The utility combines the website domain name together with your master password and creates a password scramble, that can be submitted as your new login password.

## How To Use

1. Select the domain in the address-bar and copy it (Ctrl-C, or similar short-cut specific to your OS)
2. Type the command below and press ENTER:

    $ passwordhasher

3. Focus the cursor in the passwordfield and paste the new password into it (Ctrl-V, or similar short-cut specific to your OS)

### How does it work (mundane explanation)

Passwordhasher combines the domain name and your master password into a single text. This text is then scrambled into some jumble, but with the specific feature that the scrambled result will always be exactly the same if the text is also the same.

This way the scrambled text will be reconstructable again and again - you only have to remember your master password. The scramble will be impossible to guess from the domain name alone, and the scramble will be different for every domain name used.

### How does it work (technical explanation)

Passwordhasher concatenates the domain name with your master password and creates a simple MD5 hash. Optional arguments can alter the hash in various ways, if the website has requirements that cannot be satisfied by the characters output in an MD5 hash.

- ucf Capitalizes the returned string (upper-cases the first alpha-character)
- spch Transforms the first numeric character into special characters
- [decimal] Truncates the returned string to length
