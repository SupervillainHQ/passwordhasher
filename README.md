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


# Technical notes (Powershell version)

## Restrictions on character groups

Some websites require a password consist of a minimum of certain character groups. Since the MD5 hashing algorithm only include characters a-f and 0-9, additional functionality has been added to allow a password to include extra characters.

In order to maintain an idempotent result, the original hash is used as basis for new character generation. This is done by breaking the MD5 hash into pieces of 2 characters.

As an example, using the input string "123456" for the MD5 hasing function, the  resulting MD5 hash "e10adc3949ba59abbe56e057f20f883e" is chopped up into the following 16 segments:

e1, 0a, dc, 39, 49, ba, 59, ab, be, 56, e0, 57, f2, 0f, 88, 3e

Each of these chunks are treated as a Hexadecimal numbers, which can be used as input in a function that trim that input to fit a range of charecters from the Ascii table. This can be done by using a simple modulus calculation so the input fits the range of Ascii characters:

```Powershell
    char = (Hex % r) + offset
```

where r and offset refer to the indices in the standard and extended Ascii character table.


## Upper case restriction

Converting to upper case characters, we use the following range of characters:

| Ascii | Hex | Character |
| --- | --- | --- |
| 65 | 41 | Upper case A |
| 66 | 42 | Upper case B |
| 67 | 43 | Upper case C |
| 68 | 44 | Upper case D |
| 69 | 45 | Upper case E |
| 70 | 46 | Upper case F |
| 71 | 47 | Upper case G |
| 72 | 48 | Upper case H |
| 73 | 49 | Upper case I |
| 74 | 4A | Upper case J |
| 75 | 4B | Upper case K |
| 76 | 4C | Upper case L |
| 77 | 4D | Upper case M |
| 78 | 4E | Upper case N |
| 79 | 4F | Upper case O |
| 80 | 50 | Upper case P |
| 81 | 51 | Upper case Q |
| 82 | 52 | Upper case R |
| 83 | 53 | Upper case S |
| 84 | 54 | Upper case T |
| 85 | 55 | Upper case U |
| 86 | 56 | Upper case V |
| 87 | 57 | Upper case W |
| 88 | 58 | Upper case X |
| 89 | 59 | Upper case Y |
| 90 | 5A | Upper case Z |

Here the range is 24 and the offset is 65.

#### Example

```Powershell
    char = (Hex % 24) + 65
```

Treating the first chunk "E1" as a hexadecimal value that can be converted into a decimal value, and using it in the modulus calculation, the character conversion should look like this:

```Powershell
    char = (225 % 24) + 65
```

```Powershell
    char = 74
```

"E1" should therefore convert to "J".

## Special characters restriction

Here the range is 7 and the offset is 58. This should include the following characters:

| Ascii | Hex | Character |
| --- | --- | --- |
| 58 | 3A | : Colon |
| 59 | 3B | ; Semicolon |
| 60 | 3C | < Less than |
| 61 | 3D | = Equals sign |
| 62 | 3E | > Greater than |
| 63 | 3F | ? Question mark |
| 64 | 40 | @ At |


### Optional Special Characters Range

This subgroup of Ascii characters was also considered, but it was considered risky to include the ' (Apostrophe) character because of its significance in injection attacks (This character may be stripped or replaced when a webserver is sanitising input before saving as password, and we can't ensure any random website to do this properly and keep things the same on the login-screen and the change-password form).

| Ascii | Hex | Character |
| --- | --- | --- |
| 33 | 21 | ! Exclamation mark |
| 34 | 22 | " Quotation Mark |
| 35 | 23 | # Hash |
| 36 | 24 | $ Dollar |
| 37 | 25 | % Percent |
| 38 | 26 | & Ampersand |
| 39 | 27 | ' Apostrophe |
| 40 | 28 | [ Open bracket |
| 41 | 29 | ] Close bracket |
| 42 | 2A | * Asterisk |
| 43 | 2B | + Plus |
| 44 | 2C | , Comma |
| 45 | 2D | - Dash |


## Length restriction


