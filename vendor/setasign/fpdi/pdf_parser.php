<?php
/**
 * This file is part of FPDI
 *
 * @package   FPDI
 * @copyright Copyright (c) 2017 Setasign - Jan Slabon (https://www.setasign.com)
 * @license   http://opensource.org/licenses/mit-license The MIT License
 * @version   1.6.2
 */

/**
 * Class pdf_parser
 */
class pdf_parser
{
    /**
     * Type constant
     *
     * @var integer
     */
    const TYPE_NULL = 0;

    /**
     * Type constant
     *
     * @var integer
     */
    const TYPE_NUMERIC = 1;

    /**
     * Type constant
     *
     * @var integer
     */
    const TYPE_TOKEN = 2;

    /**
     * Type constant
     *
     * @var integer
     */
    const TYPE_HEX = 3;

    /**
     * Type constant
     *
     * @var integer
     */
    const TYPE_STRING = 4;

    /**
     * Type constant
     *
     * @var integer
     */
    const TYPE_DICTIONARY = 5;

    /**
     * Type constant
     *
     * @var integer
     */
    const TYPE_ARRAY = 6;

    /**
     * Type constant
     *
     * @var integer
     */
    const TYPE_OBJDEC = 7;

    /**
     * Type constant
     *
     * @var integer
     */
    const TYPE_OBJREF = 8;

    /**
     * Type constant
     *
     * @var integer
     */
    const TYPE_OBJECT = 9;

    /**
     * Type constant
     *
     * @var integer
     */
    const TYPE_STREAM = 10;

    /**
     * Type constant
     *
     * @var integer
     */
    const TYPE_BOOLEAN = 11;

    /**
     * Type constant
     *
     * @var integer
     */
    const TYPE_REAL = 12;

    /**
     * Define the amount of byte in which the initial keyword of a PDF document should be searched.
     *
     * @var int
     */
    static public $searchForStartxrefLength = 5500;

    /**
     * Filename
     *
     * @var string
     */
    public $filename;

    /**
     * File resource
     *
     * @var resource
     */
    protected $_f;

    /**
     * PDF Context
     *
     * @var pdf_context
     */
    protected $_c;

    /**
     * xref-Data
     *
     * @var array
     */
    protected $_xref;

    /**
     * Data of the Root object
     *
     * @var array
     */
    protected $_root;

    /**
     * PDF version of the loaded document
     *
     * @var string
     */
    protected $_pdfVersion;

    /**
     * For reading encrypted documents and xref/object streams are in use
     *
     * @var boolean
     */
    protected $_readPlain = true;

    /**
     * The current read object
     *
     * @var array
     */
    protected $_currentObj;

    /**
     * Constructor
     *
     * @param string $filename Source filename
     * @throws InvalidArgumentException
     */
    public function __construct($filename)
    {
        $this->filename = $filename;

        $this->_f = @fopen($this->filename, 'rb');

        if (!$this->_f) {
            throw new InvalidArgumentException(sprintf('Cannot open %s !', $filename));
        }

        $this->getPdfVersion();

        if (!class_exists('pdf_context')) {
            require_once('pdf_context.php');
        }
        $this->_c = new pdf_context($this->_f);

        // Read xref-Data
        $this->_xref = array();
        $this->_readXref($this->_xref, $this->_findXref());

        // Check for Encryption
        $this->getEncryption();

        // Read root
        $this->_readRoot();
    }

    /**
     * Destructor
     */
    public function __destruct()
    {
        $this->closeFile();
    }

    /**
     * Close the opened file
     */
    public function closeFile()
    {
        if (isset($this->_f) && is_resource($this->_f)) {
            fclose($this->_f);
            unset($this->_f);
        }
    }

    /**
     * Check Trailer for Encryption
     *
     * @throws Exception
     */
    public function getEncryption()
    {
        if (isset($this->_xref['trailer'][1]['/Encrypt'])) {
            throw new Exception('File is encrypted!');
        }
    }

    /**
     * Get PDF-Version
     *
     * @return string
     */
    public function getPdfVersion()
    {
        if ($this->_pdfVersion === null) {
            fseek($this->_f, 0);
            preg_match('/\d\.\d/', fread($this->_f, 16), $m);
            if (isset($m[0]))
                $this->_pdfVersion = $m[0];
        }

        return $this->_pdfVersion;
    }

    /**
     * Read the /Root dictionary
     */
    protected function _readRoot()
    {
        if ($this->_xref['trailer'][1]['/Root'][0] != self::TYPE_OBJREF) {
            throw new Exception('Wrong Type of Root-Element! Must be an indirect reference');
        }

        $this->_root = $this->resolveObject($this->_xref['trailer'][1]['/Root']);
    }

    /**
     * Find the xref table
     *
     * @return integer
     * @throws Exception
     */
    protected function _findXref()
    {
        $toRead = self::$searchForStartxrefLength;

        $stat = fseek($this->_f, -$toRead, SEEK_END);
        if ($stat === -1) {
            fseek($this->_f, 0);
        }

        $data = fread($this->_f, $toRead);

        $keywordPos = strpos(strrev($data), strrev('startxref'));
        if (false === $keywordPos) {
            $keywordPos = strpos(strrev($data), strrev('startref'));
        }

        if (false === $keywordPos) {
            throw new Exception('Unable to find "startxref" keyword.');
        }

        $pos = strlen($data) - $keywordPos;
        $data = substr($data, $pos);

        if (!preg_match('/\s*(\d+).*$/s', $data, $matches)) {
            throw new Exception('Unable to find pointer to xref table.');
        }

        return (int) $matches[1];
    }

    /**
     * Read the xref table
     *
     * @param array $result Array of xref table entries
     * @param integer $offset of xref table
     * @return boolean
     * @throws Exception
     */
    protected function _readXref(&$result, $offset)
    {
        $tempPos = $offset - min(20, $offset);
        fseek($this->_f, $tempPos); // set some bytes backwards to fetch corrupted docs

        $data = fread($this->_f, 100);

        $xrefPos = strrpos($data, 'xref');

        if ($xrefPos === false) {
            $this->_c->reset($offset);
            $xrefStreamObjDec = $this->_readValue($this->_c);

            if (is_array($xrefStreamObjDec) && isset($xrefStreamObjDec[0]) && $xrefStreamObjDec[0] == self::TYPE_OBJDEC) {
                throw new Exception(
                    sprintf(
                        'This document (%s) probably uses a compression technique which is not supported by the ' .
                        'free parser shipped with FPDI. (See https://www.setasign.com/fpdi-pdf-parser for more details)',
                        $this->filename
                    )
                );
            } else {
                throw new Exception('Unable to find xref table.');
            }
        }

        if (!isset($result['xrefLocation'])) {
            $result['xrefLocation'] = $tempPos + $xrefPos;
            $result['maxObject'] = 0;
        }

        $cycles = -1;
        $bytesPerCycle = 100;

        fseek($this->_f, $tempPos = $tempPos + $xrefPos + 4); // set the handle directly after the "xref"-keyword
        $data = fread($this->_f, $bytesPerCycle);

        while (($trailerPos = strpos($data, 'trailer', max($bytesPerCycle * $cycles++, 0))) === false && !feof($this->_f)) {
            $data .= fread($this->_f, $bytesPerCycle);
        }

        if ($trailerPos === false) {
            throw new Exception('Trailer keyword not found after xref table');
        }

        $data = ltrim(substr($data, 0, $trailerPos));

        // get Line-Ending
        $found = preg_match_all("/(\r\n|\n|\r)/", substr($data, 0, 100), $m); // check the first 100 bytes for line breaks
        if ($found === 0) {
            throw new Exception('Xref table seems to be corrupted.');
        }
        $differentLineEndings = count(array_unique($m[0]));
        if ($differentLineEndings > 1) {
            $lines = preg_split("/(\r\n|\n|\r)/", $data, -1, PREG_SPLIT_NO_EMPTY);
        } else {
            $lines = explode($m[0][0], $data);
        }

        $data = $differentLineEndings = $m = null;
        unset($data, $differentLineEndings, $m);

        $linesCount = count($lines);

        $start = 1;

        for ($i = 0; $i < $linesCount; $i++) {
            $line = trim($lines[$i]);
            if ($line) {
                $pieces = explode(' ', $line);
                $c = count($pieces);
                switch($c) {
                    case 2:
                        $start = (int)$pieces[0];
                        $end   = $start + (int)$pieces[1];
                        if ($end > $result['maxObject'])
                            $result['maxObject'] = $end;
                        break;
                    case 3:
                        if (!isset($result['xref'][$start]))
                            $result['xref'][$start] = array();

                        if (!array_key_exists($gen = (int) $pieces[1], $result['xref'][$start])) {
                            $result['xref'][$start][$gen] = $pieces[2] == 'n' ? (int) $pieces[0] : null;
                        }
                        $start++;
                        break;
                    default:
                        throw new Exception('Unexpected data in xref table');
                }
            }
        }

        $lines = $pieces = $line = $start = $end = $gen = null;
        unset($lines, $pieces, $line, $start, $end, $gen);

        $this->_c->reset($tempPos + $trailerPos + 7);
        $trailer = $this->_readValue($this->_c);

        if (!isset($result['trailer'])) {
            $result['trailer'] = $trailer;
        }

        if (isset($trailer[1]['/Prev'])) {
            $this->_readXref($result, $trailer[1]['/Prev'][1]);
        }

        $trailer = null;
        unset($trailer);

        return true;
    }

    /**
     * Reads a PDF value
     *
     * @param pdf_context $c
     * @param string $token A token
     * @return mixed
     * @throws Exception
     */
    protected function _readValue(&$c, $token = null)
    {
        if (is_null($token)) {
            $token = $this->_readToken($c);
        }

        if ($token === false) {
            return false;
        }

        switch ($token) {
            case '<':
                // This is a hex string.
                // Read the value, then the terminator

                $pos = $c->offset;

                while(1) {

                    $match = strpos($c->buffer, '>', $pos);

                    // If you can't find it, try
                    // reading more data from the stream

                    if ($match === false) {
                        if (!$c->increaseLength()) {
                            return false;
                        } else {
                            continue;
                        }
                    }

                    $result = substr($c->buffer, $c->offset, $match - $c->offset);
                    $c->offset = $match + 1;

                    return array (self::TYPE_HEX, $result);
                }
                break;

            case '<<':
                // This is a dictionary.

                $result = array();

                // Recurse into this function until we reach
                // the end of the dictionary.
                while (($key = $this->_readToken($c)) !== '>>') {
                    if ($key === false) {
                        return false;
                    }

                    if (($value =   $this->_readValue($c)) === false) {
                        return false;
                    }

                    // Catch missing value
                    if ($value[0] == self::TYPE_TOKEN && $value[1] == '>>') {
                        $result[$key] = array(self::TYPE_NULL);
                        break;
                    }

                    $result[$key] = $value;
                }

                return array (self::TYPE_DICTIONARY, $result);

            case '[':
                // This is an array.

                $result = array();

                // Recurse into this function until we reach
                // the end of the array.
                while (($token = $this->_readToken($c)) !== ']') {
                    if ($token === false) {
                        return false;
                    }

                    if (($value = $this->_readValue($c, $token)) === false) {
                        return false;
                    }

                    $result[] = $value;
                }

                return array (self::TYPE_ARRAY, $result);

            case '(':
                // This is a string
                $pos = $c->offset;

                $openBrackets = 1;
                do {
                    for (; $openBrackets != 0 && $pos < $c->length; $pos++) {
                        switch (ord($c->buffer[$pos])) {
                            case 0x28: // '('
                                $openBrackets++;
                                break;
                            case 0x29: // ')'
                                $openBrackets--;
                                break;
                            case 0x5C: // backslash
                                $pos++;
                        }
                    }
                } while($openBrackets != 0 && $c->increaseLength());

                $result = substr($c->buffer, $c->offset, $pos - $c->offset - 1);
                $c->offset = $pos;

                return array (self::TYPE_STRING, $result);

            case 'stream':
                $tempPos = $c->getPos() - strlen($c->buffer);
                $tempOffset = $c->offset;

                $c->reset($startPos = $tempPos + $tempOffset);

                // Find the first "newline"
                while ($c->buffer[0] !== chr(10) && $c->buffer[0] !== chr(13)) {
                    $c->reset(++$startPos);
                    if ($c->ensureContent() === false) {
                        throw new Exception(
                            'Unable to parse stream data. No newline followed the stream keyword.'
                        );
                    }
                }

                $e = 0; // ensure line breaks in front of the stream
                if ($c->buffer[0] == chr(10) || $c->buffer[0] == chr(13))
                    $e++;
                if ($c->buffer[1] == chr(10) && $c->buffer[0] != chr(10))
                    $e++;

                if ($this->_currentObj[1][1]['/Length'][0] == self::TYPE_OBJREF) {
                    $tmpLength = $this->resolveObject($this->_currentObj[1][1]['/Length']);
                    $length = $tmpLength[1][1];
                } else {
                    $length = $this->_currentObj[1][1]['/Length'][1];
                }

                if ($length > 0) {
                    $c->reset($startPos + $e, $length);
                    $v = $c->buffer;
                } else {
                    $v = '';
                }

                $c->reset($startPos + $e + $length);
                $endstream = $this->_readToken($c);

                if ($endstream != 'endstream') {
                    $c->reset($startPos + $e + $length + 9); // 9 = strlen("endstream")
                    // We don't throw an error here because the next
                    // round trip will start at a new offset
                }

                return array(self::TYPE_STREAM, $v);

            default:
                if (is_numeric($token)) {
                    // A numeric token. Make sure that
                    // it is not part of something else.
                    if (($tok2 = $this->_readToken($c)) !== false) {
                        if (is_numeric($tok2)) {

                            // Two numeric tokens in a row.
                            // In this case, we're probably in
                            // front of either an object referencl  l  0  m  m  ;ÿ  n  n  =ÿ  o  o  [ÿ  p  p  ]ÿ  q  q  0  r  r  	0  s  s  
0  t  t  0  u  u  0  v  v  0  w  w  0  x  x  0  y  y  0  z  z  0  {  {  ÿ  |  |  ÿ  }  }  ±   ~  ~  ×                   ÷       ÿ      `"      ÿ      ÿ      f"      g"      "      4"      B&      @&      °       2       3       !      åÿ      ÿ      àÿ      áÿ      ÿ      ÿ      ÿ      
ÿ       ÿ      §       &      &      Ë%      Ï%      Î%      Ç%      Æ%        ¡%  ¡  ¡   %  ¢  ¢  ³%  £  £  ²%  ¤  ¤  ½%  ¥  ¥  ¼%  ¦  ¦  ;   §  §  0  ¨  ¨  !  ©  ©  !  ª  ª  !  «  «  !  ¬  ¬  0  ­  ­  ?   ®  ®  ?   ¯  ¯  ?   °  °  ?   ±  ±  ?   ²  ²  ?   ³  ³  ?   ´  ´  ?   µ  µ  ?   ¶  ¶  ?   ·  ·  ?   ¸  ¸  "  ¹  ¹  "  º  º  "  »  »  "  ¼  ¼  "  ½  ½  "  ¾  ¾  *"  ¿  ¿  )"  À  À  ?   Á  Á  ?   Â  Â  ?   Ã  Ã  ?   Ä  Ä  ?   Å  Å  ?   Æ  Æ  ?   Ç  Ç  ?   È  È  '"  É  É  ("  Ê  Ê  âÿ  Ë  Ë  Ò!  Ì  Ì  Ô!  Í  Í   "  Î  Î  "  Ï  Ï  ?   Ð  Ð  ?   Ñ  Ñ  ?   Ò  Ò  ?   Ó  Ó  ?   Ô  Ô  ?   Õ  Õ  ?   Ö  Ö  ?   ×  ×  ?   Ø  Ø  ?   Ù  Ù  ?   Ú  Ú   "  Û  Û  ¥"  Ü  Ü  #  Ý  Ý  "  Þ  Þ  "  ß  ß  a"  à  à  R"  á  á  j"  â  â  k"  ã  ã  "  ä  ä  ="  å  å  "  æ  æ  5"  ç  ç  +"  è  è  ,"  é  é  ?   ê  ê  ?   ë  ë  ?   ì  ì  ?   í  í  ?   î  î  ?   ï  ï  ?   ð  ð  +!  ñ  ñ  0   ò  ò  o&  ó  ó  m&  ô  ô  j&  õ  õ      ö  ö  !   ÷  ÷  ¶   ø  ø  ?   ù  ù  ?   ú  ú  ?   û  û  ?   ü  ü  ï%                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      @  @  ?   A  A  ?   B  B  ?   C  C  ?   D  D  ?   E  E  ?   F  F  ?   G  G  ?   H  H  ?   I  I  ?   J  J  ?   K  K  ?   L  L  ?   M  M  ?   N  N  ?   O  O  ÿ  P  P  ÿ  Q  Q  ÿ  R  R  ÿ  S  S  ÿ  T  T  ÿ  U  U  ÿ  V  V  ÿ  W  W  ÿ  X  X  ÿ  Y  Y  ?   Z  Z  ?   [  [  ?   \  \  ?   ]  ]  ?   ^  ^  ?   _  _  ?   `    !ÿ  a    "ÿ  b    #ÿ  c    $ÿ  d    %ÿ  e    &ÿ  f    'ÿ  g    (ÿ  h    )ÿ  i    *ÿ  j    +ÿ  k    ,ÿ  l    -ÿ  m    .ÿ  n    /ÿ  o    0ÿ  p    1ÿ  q    2ÿ  r    3ÿ  s    4ÿ  t    5ÿ  u    6ÿ  v    7ÿ  w    8ÿ  x    9ÿ  y    :ÿ  z  z  ?   {  {  ?   |  |  ?   }  }  ?   ~  ~  ?                   ?   `    Aÿ  a    Bÿ  b    Cÿ  c    Dÿ  d    Eÿ  e    Fÿ  f    Gÿ  g    Hÿ  h    Iÿ  i    Jÿ  j    Kÿ  k    Lÿ  l    Mÿ  m    Nÿ  n    Oÿ  o    Pÿ  p    Qÿ  q    Rÿ  r    Sÿ  s    Tÿ  t    Uÿ  u    Vÿ  v    Wÿ  w    Xÿ  x    Yÿ  y    Zÿ      ?       ?       ?       ?       A0        B0  ¡  ¡  C0  ¢  ¢  D0  £  £  E0  ¤  ¤  F0  ¥  ¥  G0  ¦  ¦  H0  §  §  I0  ¨  ¨  J0  ©  ©  K0  ª  ª  L0  «  «  M0  ¬  ¬  N0  ­  ­  O0  ®  ®  P0  ¯  ¯  Q0  °  °  R0  ±  ±  S0  ²  ²  T0  ³  ³  U0  ´  ´  V0  µ  µ  W0  ¶  ¶  X0  ·  ·  Y0  ¸  ¸  Z0  ¹  ¹  [0  º  º  \0  »  »  ]0  ¼  ¼  ^0  ½  ½  _0  ¾  ¾  `0  ¿  ¿  a0  À  À  b0  Á  Á  c0  Â  Â  d0  Ã  Ã  e0  Ä  Ä  f0  Å  Å  g0  Æ  Æ  h0  Ç  Ç  i0  È  È  j0  É  É  k0  Ê  Ê  l0  Ë  Ë  m0  Ì  Ì  n0  Í  Í  o0  Î  Î  p0  Ï  Ï  q0  Ð  Ð  r0  Ñ  Ñ  s0  Ò  Ò  t0  Ó  Ó  u0  Ô  Ô  v0  Õ  Õ  w0  Ö  Ö  x0  ×  ×  y0  Ø  Ø  z0  Ù  Ù  {0  Ú  Ú  |0  Û  Û  }0  Ü  Ü  ~0  Ý  Ý  0  Þ  Þ  0  ß  ß  0  à  à  0  á  á  0  â  â  0  ã  ã  0  ä  ä  0  å  å  0  æ  æ  0  ç  ç  0  è  è  0  é  é  0  ê  ê  0  ë  ë  0  ì  ì  0  í  í  0  î  î  0  ï  ï  0  ð  ð  0  ñ  ñ  0  ò  ò  ?   ó  ó  ?   ô  ô  ?   õ  õ  ?   ö  ö  ?   ÷  ÷  ?   ø  ø  ?   ù  ù  ?   ú  ú  ?   û  û  ?   ü  ü  ?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       @  @  ¡0  A  A  ¢0  B  B  £0  C  C  ¤0  D  D  ¥0  E  E  ¦0  F  F  §0  G  G  ¨0  H  H  ©0  I  I  ª0  J  J  «0  K  K  ¬0  L  L  ­0  M  M  ®0  N  N  ¯0  O  O  °0  P  P  ±0  Q  Q  ²0  R  R  ³0  S  S  ´0  T  T  µ0  U  U  ¶0  V  V  ·0  W  W  ¸0  X  X  ¹0  Y  Y  º0  Z  Z  »0  [  [  ¼0  \  \  ½0  ]  ]  ¾0  ^  ^  ¿0  _  _  À0  `  `  Á0  a  a  Â0  b  b  Ã0  c  c  Ä0  d  d  Å0  e  e  Æ0  f  f  Ç0  g  g  È0  h  h  É0  i  i  Ê0  j  j  Ë0  k  k  Ì0  l  l  Í0  m  m  Î0  n  n  Ï0  o  o  Ð0  p  p  Ñ0  q  q  Ò0  r  r  Ó0  s  s  Ô0  t  t  Õ0  u  u  Ö0  v  v  ×0  w  w  Ø0  x  x  Ù0  y  y  Ú0  z  z  Û0  {  {  Ü0  |  |  Ý0  }  }  Þ0  ~  ~  ß0                  à0      á0      â0      ã0      ä0      å0      æ0      ç0      è0      é0      ê0      ë0      ì0      í0      î0      ï0      ð0      ñ0      ò0      ó0      ô0      õ0      ö0      ?       ?       ?       ?       ?       ?       ?       ?     ¿       À    ¡  Á    ¢  Â    £  Ã    ¤  Ä    ¥  Å    ¦  Æ    §  Ç    ¨  È    ©  É    ª  Ê    «  Ë    ¬  Ì    ­  Í    ®  Î     ¯  Ï  ¡  °  Ð  £  ±  Ñ  ¤  ²  Ò  ¥  ³  Ó  ¦  ´  Ô  §  µ  Õ  ¨  ¶  Ö  ©  ·  ·  ?   ¸  ¸  ?   ¹  ¹  ?   º  º  ?   »  »  ?   ¼  ¼  ?   ½  ½  ?   ¾  ¾  ?     ¿  ±     À  ²  ¡  Á  ³  ¢  Â  ´  £  Ã  µ  ¤  Ä  ¶  ¥  Å  ·  ¦  Æ  ¸  §  Ç  ¹  ¨  È  º  ©  É  »  ª  Ê  ¼  «  Ë  ½  ¬  Ì  ¾  ­  Í  ¿  ®  Î  À  ¯  Ï  Á  °  Ð  Ã  ±  Ñ  Ä  ²  Ò  Å  ³  Ó  Æ  ´  Ô  Ç  µ  Õ  È  ¶  Ö  É  ×  ×  ?   Ø  Ø  ?   Ù  Ù  ?   Ú  Ú  ?   Û  Û  ?   Ü  Ü  ?   Ý  Ý  ?   Þ  Þ  ?   ß  ß  ?   à  à  ?   á  á  ?   â  â  ?   ã  ã  ?   ä  ä  ?   å  å  ?   æ  æ  ?   ç  ç  ?   è  è  ?   é  é  ?   ê  ê  ?   ë  ë  ?   ì  ì  ?   í  í  ?   î  î  ?   ï  ï  ?   ð  ð  ?   ñ  ñ  ?   ò  ò  ?   ó  ó  ?   ô  ô  ?   õ  õ  ?   ö  ö  ?   ÷  ÷  ?   ø  ø  ?   ù  ù  ?   ú  ú  ?   û  û  ?   ü  ü  ?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       @  p    A  q    B  r    C  s    D  t    E  u    F  v    G  w    H  x    I  y    J  z    K  {    L  |    M  }    N  ~    O      P      Q       R    !  S    "  T    #  U    $  V    %  W    &  X    '  Y    (  Z    )  [    *  \    +  ]    ,  ^    -  _    .  `    /  a  a  ?   b  b  ?   c  c  ?   d  d  ?   e  e  ?   f  f  ?   g  g  ?   h  h  ?   i  i  ?   j  j  ?   k  k  ?   l  l  ?   m  m  ?   n  n  ?   o  o  ?   @  p  0  A  q  1  B  r  2  C  s  3  D  t  4  E  u  5  F  v  Q  G  w  6  H  x  7  I  y  8  J  z  9  K  {  :  L  |  ;  M  }  <  N  ~  =              O    >  P    ?  Q    @  R    A  S    B  T    C  U    D  V    E  W    F  X    G  Y    H  Z    I  [    J  \    K  ]    L  ^    M  _    N  `    O      ?       ?       ?       ?       ?       ?       ?       ?       ?       ?       ?       ?       ?        %        %  ¡  ¡  %  ¢  ¢  %  £  £  %  ¤  ¤  %  ¥  ¥  %  ¦  ¦  ,%  §  §  $%  ¨  ¨  4%  ©  ©  <%  ª  ª  %  «  «  %  ¬  ¬  %  ­  ­  %  ®  ®  %  ¯  ¯  %  °  °  #%  ±  ±  3%  ²  ²  +%  ³  ³  ;%  ´  ´  K%  µ  µ   %  ¶  ¶  /%  ·  ·  (%  ¸  ¸  7%  ¹  ¹  ?%  º  º  %  »  »  0%  ¼  ¼  %%  ½  ½  8%  ¾  ¾  B%  ¿  ¿  ?   À  À  ?   Á  Á  ?   Â  Â  ?   Ã  Ã  ?   Ä  Ä  ?   Å  Å  ?   Æ  Æ  ?   Ç  Ç  ?   È  È  ?   É  É  ?   Ê  Ê  ?   Ë  Ë  ?   Ì  Ì  ?   Í  Í  ?   Î  Î  ?   Ï  Ï  ?   Ð  Ð  ?   Ñ  Ñ  ?   Ò  Ò  ?   Ó  Ó  ?   Ô  Ô  ?   Õ  Õ  ?   Ö  Ö  ?   ×  ×  ?   Ø  Ø  ?   Ù  Ù  ?   Ú  Ú  ?   Û  Û  ?   Ü  Ü  ?   Ý  Ý  ?   Þ  Þ  ?   ß  ß  ?   à  à  ?   á  á  ?   â  â  ?   ã  ã  ?   ä  ä  ?   å  å  ?   æ  æ  ?   ç  ç  ?   è  è  ?   é  é  ?   ê  ê  ?   ë  ë  ?   ì  ì  ?   í  í  ?   î  î  ?   ï  ï  ?   ð  ð  ?   ñ  ñ  ?   ò  ò  ?   ó  ó  ?   ô  ô  ?   õ  õ  ?   ö  ö  ?   ÷  ÷  ?   ø  ø  ?   ù  ù  ?   ú  ú  ?   û  û  ?   ü  ü  ?                                                                                                                                                                                                                                                         