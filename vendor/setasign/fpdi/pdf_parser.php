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
                            // front of either an object referenclЃ  lЃ  0  mЃ  mЃ  ;я  nЃ  nЃ  =я  oЃ  oЃ  [я  pЃ  pЃ  ]я  qЃ  qЃ  0  rЃ  rЃ  	0  sЃ  sЃ  
0  tЃ  tЃ  0  uЃ  uЃ  0  vЃ  vЃ  0  wЃ  wЃ  0  xЃ  xЃ  0  yЃ  yЃ  0  zЃ  zЃ  0  {Ѓ  {Ѓ  я  |Ѓ  |Ѓ  я  }Ѓ  }Ѓ  ±   ~Ѓ  ~Ѓ  Ч               ЂЃ  ЂЃ  ч   ЃЃ  ЃЃ  я  ‚Ѓ  ‚Ѓ  `"  ѓЃ  ѓЃ  я  „Ѓ  „Ѓ  я  …Ѓ  …Ѓ  f"  †Ѓ  †Ѓ  g"  ‡Ѓ  ‡Ѓ  "  €Ѓ  €Ѓ  4"  ‰Ѓ  ‰Ѓ  B&  ЉЃ  ЉЃ  @&  ‹Ѓ  ‹Ѓ  °   ЊЃ  ЊЃ  2   ЌЃ  ЌЃ  3   ЋЃ  ЋЃ  !  ЏЃ  ЏЃ  ея  ђЃ  ђЃ  я  ‘Ѓ  ‘Ѓ  ая  ’Ѓ  ’Ѓ  бя  “Ѓ  “Ѓ  я  ”Ѓ  ”Ѓ  я  •Ѓ  •Ѓ  я  –Ѓ  –Ѓ  
я  —Ѓ  —Ѓ   я  Ѓ  Ѓ  §   ™Ѓ  ™Ѓ  &  љЃ  љЃ  &  ›Ѓ  ›Ѓ  Л%  њЃ  њЃ  П%  ќЃ  ќЃ  О%  ћЃ  ћЃ  З%  џЃ  џЃ  Ж%   Ѓ   Ѓ  Ў%  ЎЃ  ЎЃ   %  ўЃ  ўЃ  і%  ЈЃ  ЈЃ  І%  ¤Ѓ  ¤Ѓ  Ѕ%  ҐЃ  ҐЃ  ј%  ¦Ѓ  ¦Ѓ  ;   §Ѓ  §Ѓ  0  ЁЃ  ЁЃ  ’!  ©Ѓ  ©Ѓ  ђ!  ЄЃ  ЄЃ  ‘!  «Ѓ  «Ѓ  “!  ¬Ѓ  ¬Ѓ  0  ­Ѓ  ­Ѓ  ?   ®Ѓ  ®Ѓ  ?   ЇЃ  ЇЃ  ?   °Ѓ  °Ѓ  ?   ±Ѓ  ±Ѓ  ?   ІЃ  ІЃ  ?   іЃ  іЃ  ?   ґЃ  ґЃ  ?   µЃ  µЃ  ?   ¶Ѓ  ¶Ѓ  ?   ·Ѓ  ·Ѓ  ?   ёЃ  ёЃ  "  №Ѓ  №Ѓ  "  єЃ  єЃ  †"  »Ѓ  »Ѓ  ‡"  јЃ  јЃ  ‚"  ЅЃ  ЅЃ  ѓ"  ѕЃ  ѕЃ  *"  їЃ  їЃ  )"  АЃ  АЃ  ?   БЃ  БЃ  ?   ВЃ  ВЃ  ?   ГЃ  ГЃ  ?   ДЃ  ДЃ  ?   ЕЃ  ЕЃ  ?   ЖЃ  ЖЃ  ?   ЗЃ  ЗЃ  ?   ИЃ  ИЃ  '"  ЙЃ  ЙЃ  ("  КЃ  КЃ  вя  ЛЃ  ЛЃ  Т!  МЃ  МЃ  Ф!  НЃ  НЃ   "  ОЃ  ОЃ  "  ПЃ  ПЃ  ?   РЃ  РЃ  ?   СЃ  СЃ  ?   ТЃ  ТЃ  ?   УЃ  УЃ  ?   ФЃ  ФЃ  ?   ХЃ  ХЃ  ?   ЦЃ  ЦЃ  ?   ЧЃ  ЧЃ  ?   ШЃ  ШЃ  ?   ЩЃ  ЩЃ  ?   ЪЃ  ЪЃ   "  ЫЃ  ЫЃ  Ґ"  ЬЃ  ЬЃ  #  ЭЃ  ЭЃ  "  ЮЃ  ЮЃ  "  ЯЃ  ЯЃ  a"  аЃ  аЃ  R"  бЃ  бЃ  j"  вЃ  вЃ  k"  гЃ  гЃ  "  дЃ  дЃ  ="  еЃ  еЃ  "  жЃ  жЃ  5"  зЃ  зЃ  +"  иЃ  иЃ  ,"  йЃ  йЃ  ?   кЃ  кЃ  ?   лЃ  лЃ  ?   мЃ  мЃ  ?   нЃ  нЃ  ?   оЃ  оЃ  ?   пЃ  пЃ  ?   рЃ  рЃ  +!  сЃ  сЃ  0   тЃ  тЃ  o&  уЃ  уЃ  m&  фЃ  фЃ  j&  хЃ  хЃ      цЃ  цЃ  !   чЃ  чЃ  ¶   шЃ  шЃ  ?   щЃ  щЃ  ?   ъЃ  ъЃ  ?   ыЃ  ыЃ  ?   ьЃ  ьЃ  п%                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      @‚  @‚  ?   A‚  A‚  ?   B‚  B‚  ?   C‚  C‚  ?   D‚  D‚  ?   E‚  E‚  ?   F‚  F‚  ?   G‚  G‚  ?   H‚  H‚  ?   I‚  I‚  ?   J‚  J‚  ?   K‚  K‚  ?   L‚  L‚  ?   M‚  M‚  ?   N‚  N‚  ?   O‚  O‚  я  P‚  P‚  я  Q‚  Q‚  я  R‚  R‚  я  S‚  S‚  я  T‚  T‚  я  U‚  U‚  я  V‚  V‚  я  W‚  W‚  я  X‚  X‚  я  Y‚  Y‚  ?   Z‚  Z‚  ?   [‚  [‚  ?   \‚  \‚  ?   ]‚  ]‚  ?   ^‚  ^‚  ?   _‚  _‚  ?   `‚  Ѓ‚  !я  a‚  ‚‚  "я  b‚  ѓ‚  #я  c‚  „‚  $я  d‚  …‚  %я  e‚  †‚  &я  f‚  ‡‚  'я  g‚  €‚  (я  h‚  ‰‚  )я  i‚  Љ‚  *я  j‚  ‹‚  +я  k‚  Њ‚  ,я  l‚  Ќ‚  -я  m‚  Ћ‚  .я  n‚  Џ‚  /я  o‚  ђ‚  0я  p‚  ‘‚  1я  q‚  ’‚  2я  r‚  “‚  3я  s‚  ”‚  4я  t‚  •‚  5я  u‚  –‚  6я  v‚  —‚  7я  w‚  ‚  8я  x‚  ™‚  9я  y‚  љ‚  :я  z‚  z‚  ?   {‚  {‚  ?   |‚  |‚  ?   }‚  }‚  ?   ~‚  ~‚  ?               Ђ‚  Ђ‚  ?   `‚  Ѓ‚  Aя  a‚  ‚‚  Bя  b‚  ѓ‚  Cя  c‚  „‚  Dя  d‚  …‚  Eя  e‚  †‚  Fя  f‚  ‡‚  Gя  g‚  €‚  Hя  h‚  ‰‚  Iя  i‚  Љ‚  Jя  j‚  ‹‚  Kя  k‚  Њ‚  Lя  l‚  Ќ‚  Mя  m‚  Ћ‚  Nя  n‚  Џ‚  Oя  o‚  ђ‚  Pя  p‚  ‘‚  Qя  q‚  ’‚  Rя  r‚  “‚  Sя  s‚  ”‚  Tя  t‚  •‚  Uя  u‚  –‚  Vя  v‚  —‚  Wя  w‚  ‚  Xя  x‚  ™‚  Yя  y‚  љ‚  Zя  ›‚  ›‚  ?   њ‚  њ‚  ?   ќ‚  ќ‚  ?   ћ‚  ћ‚  ?   џ‚  џ‚  A0   ‚   ‚  B0  Ў‚  Ў‚  C0  ў‚  ў‚  D0  Ј‚  Ј‚  E0  ¤‚  ¤‚  F0  Ґ‚  Ґ‚  G0  ¦‚  ¦‚  H0  §‚  §‚  I0  Ё‚  Ё‚  J0  ©‚  ©‚  K0  Є‚  Є‚  L0  «‚  «‚  M0  ¬‚  ¬‚  N0  ­‚  ­‚  O0  ®‚  ®‚  P0  Ї‚  Ї‚  Q0  °‚  °‚  R0  ±‚  ±‚  S0  І‚  І‚  T0  і‚  і‚  U0  ґ‚  ґ‚  V0  µ‚  µ‚  W0  ¶‚  ¶‚  X0  ·‚  ·‚  Y0  ё‚  ё‚  Z0  №‚  №‚  [0  є‚  є‚  \0  »‚  »‚  ]0  ј‚  ј‚  ^0  Ѕ‚  Ѕ‚  _0  ѕ‚  ѕ‚  `0  ї‚  ї‚  a0  А‚  А‚  b0  Б‚  Б‚  c0  В‚  В‚  d0  Г‚  Г‚  e0  Д‚  Д‚  f0  Е‚  Е‚  g0  Ж‚  Ж‚  h0  З‚  З‚  i0  И‚  И‚  j0  Й‚  Й‚  k0  К‚  К‚  l0  Л‚  Л‚  m0  М‚  М‚  n0  Н‚  Н‚  o0  О‚  О‚  p0  П‚  П‚  q0  Р‚  Р‚  r0  С‚  С‚  s0  Т‚  Т‚  t0  У‚  У‚  u0  Ф‚  Ф‚  v0  Х‚  Х‚  w0  Ц‚  Ц‚  x0  Ч‚  Ч‚  y0  Ш‚  Ш‚  z0  Щ‚  Щ‚  {0  Ъ‚  Ъ‚  |0  Ы‚  Ы‚  }0  Ь‚  Ь‚  ~0  Э‚  Э‚  0  Ю‚  Ю‚  Ђ0  Я‚  Я‚  Ѓ0  а‚  а‚  ‚0  б‚  б‚  ѓ0  в‚  в‚  „0  г‚  г‚  …0  д‚  д‚  †0  е‚  е‚  ‡0  ж‚  ж‚  €0  з‚  з‚  ‰0  и‚  и‚  Љ0  й‚  й‚  ‹0  к‚  к‚  Њ0  л‚  л‚  Ќ0  м‚  м‚  Ћ0  н‚  н‚  Џ0  о‚  о‚  ђ0  п‚  п‚  ‘0  р‚  р‚  ’0  с‚  с‚  “0  т‚  т‚  ?   у‚  у‚  ?   ф‚  ф‚  ?   х‚  х‚  ?   ц‚  ц‚  ?   ч‚  ч‚  ?   ш‚  ш‚  ?   щ‚  щ‚  ?   ъ‚  ъ‚  ?   ы‚  ы‚  ?   ь‚  ь‚  ?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       @ѓ  @ѓ  Ў0  Aѓ  Aѓ  ў0  Bѓ  Bѓ  Ј0  Cѓ  Cѓ  ¤0  Dѓ  Dѓ  Ґ0  Eѓ  Eѓ  ¦0  Fѓ  Fѓ  §0  Gѓ  Gѓ  Ё0  Hѓ  Hѓ  ©0  Iѓ  Iѓ  Є0  Jѓ  Jѓ  «0  Kѓ  Kѓ  ¬0  Lѓ  Lѓ  ­0  Mѓ  Mѓ  ®0  Nѓ  Nѓ  Ї0  Oѓ  Oѓ  °0  Pѓ  Pѓ  ±0  Qѓ  Qѓ  І0  Rѓ  Rѓ  і0  Sѓ  Sѓ  ґ0  Tѓ  Tѓ  µ0  Uѓ  Uѓ  ¶0  Vѓ  Vѓ  ·0  Wѓ  Wѓ  ё0  Xѓ  Xѓ  №0  Yѓ  Yѓ  є0  Zѓ  Zѓ  »0  [ѓ  [ѓ  ј0  \ѓ  \ѓ  Ѕ0  ]ѓ  ]ѓ  ѕ0  ^ѓ  ^ѓ  ї0  _ѓ  _ѓ  А0  `ѓ  `ѓ  Б0  aѓ  aѓ  В0  bѓ  bѓ  Г0  cѓ  cѓ  Д0  dѓ  dѓ  Е0  eѓ  eѓ  Ж0  fѓ  fѓ  З0  gѓ  gѓ  И0  hѓ  hѓ  Й0  iѓ  iѓ  К0  jѓ  jѓ  Л0  kѓ  kѓ  М0  lѓ  lѓ  Н0  mѓ  mѓ  О0  nѓ  nѓ  П0  oѓ  oѓ  Р0  pѓ  pѓ  С0  qѓ  qѓ  Т0  rѓ  rѓ  У0  sѓ  sѓ  Ф0  tѓ  tѓ  Х0  uѓ  uѓ  Ц0  vѓ  vѓ  Ч0  wѓ  wѓ  Ш0  xѓ  xѓ  Щ0  yѓ  yѓ  Ъ0  zѓ  zѓ  Ы0  {ѓ  {ѓ  Ь0  |ѓ  |ѓ  Э0  }ѓ  }ѓ  Ю0  ~ѓ  ~ѓ  Я0              Ђѓ  Ђѓ  а0  Ѓѓ  Ѓѓ  б0  ‚ѓ  ‚ѓ  в0  ѓѓ  ѓѓ  г0  „ѓ  „ѓ  д0  …ѓ  …ѓ  е0  †ѓ  †ѓ  ж0  ‡ѓ  ‡ѓ  з0  €ѓ  €ѓ  и0  ‰ѓ  ‰ѓ  й0  Љѓ  Љѓ  к0  ‹ѓ  ‹ѓ  л0  Њѓ  Њѓ  м0  Ќѓ  Ќѓ  н0  Ћѓ  Ћѓ  о0  Џѓ  Џѓ  п0  ђѓ  ђѓ  р0  ‘ѓ  ‘ѓ  с0  ’ѓ  ’ѓ  т0  “ѓ  “ѓ  у0  ”ѓ  ”ѓ  ф0  •ѓ  •ѓ  х0  –ѓ  –ѓ  ц0  —ѓ  —ѓ  ?   ѓ  ѓ  ?   ™ѓ  ™ѓ  ?   љѓ  љѓ  ?   ›ѓ  ›ѓ  ?   њѓ  њѓ  ?   ќѓ  ќѓ  ?   ћѓ  ћѓ  ?   џѓ  їѓ  ‘   ѓ  Аѓ  ’  Ўѓ  Бѓ  “  ўѓ  Вѓ  ”  Јѓ  Гѓ  •  ¤ѓ  Дѓ  –  Ґѓ  Еѓ  —  ¦ѓ  Жѓ    §ѓ  Зѓ  ™  Ёѓ  Иѓ  љ  ©ѓ  Йѓ  ›  Єѓ  Кѓ  њ  «ѓ  Лѓ  ќ  ¬ѓ  Мѓ  ћ  ­ѓ  Нѓ  џ  ®ѓ  Оѓ     Їѓ  Пѓ  Ў  °ѓ  Рѓ  Ј  ±ѓ  Сѓ  ¤  Іѓ  Тѓ  Ґ  іѓ  Уѓ  ¦  ґѓ  Фѓ  §  µѓ  Хѓ  Ё  ¶ѓ  Цѓ  ©  ·ѓ  ·ѓ  ?   ёѓ  ёѓ  ?   №ѓ  №ѓ  ?   єѓ  єѓ  ?   »ѓ  »ѓ  ?   јѓ  јѓ  ?   Ѕѓ  Ѕѓ  ?   ѕѓ  ѕѓ  ?   џѓ  їѓ  ±   ѓ  Аѓ  І  Ўѓ  Бѓ  і  ўѓ  Вѓ  ґ  Јѓ  Гѓ  µ  ¤ѓ  Дѓ  ¶  Ґѓ  Еѓ  ·  ¦ѓ  Жѓ  ё  §ѓ  Зѓ  №  Ёѓ  Иѓ  є  ©ѓ  Йѓ  »  Єѓ  Кѓ  ј  «ѓ  Лѓ  Ѕ  ¬ѓ  Мѓ  ѕ  ­ѓ  Нѓ  ї  ®ѓ  Оѓ  А  Їѓ  Пѓ  Б  °ѓ  Рѓ  Г  ±ѓ  Сѓ  Д  Іѓ  Тѓ  Е  іѓ  Уѓ  Ж  ґѓ  Фѓ  З  µѓ  Хѓ  И  ¶ѓ  Цѓ  Й  Чѓ  Чѓ  ?   Шѓ  Шѓ  ?   Щѓ  Щѓ  ?   Ъѓ  Ъѓ  ?   Ыѓ  Ыѓ  ?   Ьѓ  Ьѓ  ?   Эѓ  Эѓ  ?   Юѓ  Юѓ  ?   Яѓ  Яѓ  ?   аѓ  аѓ  ?   бѓ  бѓ  ?   вѓ  вѓ  ?   гѓ  гѓ  ?   дѓ  дѓ  ?   еѓ  еѓ  ?   жѓ  жѓ  ?   зѓ  зѓ  ?   иѓ  иѓ  ?   йѓ  йѓ  ?   кѓ  кѓ  ?   лѓ  лѓ  ?   мѓ  мѓ  ?   нѓ  нѓ  ?   оѓ  оѓ  ?   пѓ  пѓ  ?   рѓ  рѓ  ?   сѓ  сѓ  ?   тѓ  тѓ  ?   уѓ  уѓ  ?   фѓ  фѓ  ?   хѓ  хѓ  ?   цѓ  цѓ  ?   чѓ  чѓ  ?   шѓ  шѓ  ?   щѓ  щѓ  ?   ъѓ  ъѓ  ?   ыѓ  ыѓ  ?   ьѓ  ьѓ  ?                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       @„  p„    A„  q„    B„  r„    C„  s„    D„  t„    E„  u„    F„  v„    G„  w„    H„  x„    I„  y„    J„  z„    K„  {„    L„  |„    M„  }„    N„  ~„    O„  Ђ„    P„  Ѓ„    Q„  ‚„     R„  ѓ„  !  S„  „„  "  T„  …„  #  U„  †„  $  V„  ‡„  %  W„  €„  &  X„  ‰„  '  Y„  Љ„  (  Z„  ‹„  )  [„  Њ„  *  \„  Ќ„  +  ]„  Ћ„  ,  ^„  Џ„  -  _„  ђ„  .  `„  ‘„  /  a„  a„  ?   b„  b„  ?   c„  c„  ?   d„  d„  ?   e„  e„  ?   f„  f„  ?   g„  g„  ?   h„  h„  ?   i„  i„  ?   j„  j„  ?   k„  k„  ?   l„  l„  ?   m„  m„  ?   n„  n„  ?   o„  o„  ?   @„  p„  0  A„  q„  1  B„  r„  2  C„  s„  3  D„  t„  4  E„  u„  5  F„  v„  Q  G„  w„  6  H„  x„  7  I„  y„  8  J„  z„  9  K„  {„  :  L„  |„  ;  M„  }„  <  N„  ~„  =              O„  Ђ„  >  P„  Ѓ„  ?  Q„  ‚„  @  R„  ѓ„  A  S„  „„  B  T„  …„  C  U„  †„  D  V„  ‡„  E  W„  €„  F  X„  ‰„  G  Y„  Љ„  H  Z„  ‹„  I  [„  Њ„  J  \„  Ќ„  K  ]„  Ћ„  L  ^„  Џ„  M  _„  ђ„  N  `„  ‘„  O  ’„  ’„  ?   “„  “„  ?   ”„  ”„  ?   •„  •„  ?   –„  –„  ?   —„  —„  ?   „  „  ?   ™„  ™„  ?   љ„  љ„  ?   ›„  ›„  ?   њ„  њ„  ?   ќ„  ќ„  ?   ћ„  ћ„  ?   џ„  џ„   %   „   „  %  Ў„  Ў„  %  ў„  ў„  %  Ј„  Ј„  %  ¤„  ¤„  %  Ґ„  Ґ„  %  ¦„  ¦„  ,%  §„  §„  $%  Ё„  Ё„  4%  ©„  ©„  <%  Є„  Є„  %  «„  «„  %  ¬„  ¬„  %  ­„  ­„  %  ®„  ®„  %  Ї„  Ї„  %  °„  °„  #%  ±„  ±„  3%  І„  І„  +%  і„  і„  ;%  ґ„  ґ„  K%  µ„  µ„   %  ¶„  ¶„  /%  ·„  ·„  (%  ё„  ё„  7%  №„  №„  ?%  є„  є„  %  »„  »„  0%  ј„  ј„  %%  Ѕ„  Ѕ„  8%  ѕ„  ѕ„  B%  ї„  ї„  ?   А„  А„  ?   Б„  Б„  ?   В„  В„  ?   Г„  Г„  ?   Д„  Д„  ?   Е„  Е„  ?   Ж„  Ж„  ?   З„  З„  ?   И„  И„  ?   Й„  Й„  ?   К„  К„  ?   Л„  Л„  ?   М„  М„  ?   Н„  Н„  ?   О„  О„  ?   П„  П„  ?   Р„  Р„  ?   С„  С„  ?   Т„  Т„  ?   У„  У„  ?   Ф„  Ф„  ?   Х„  Х„  ?   Ц„  Ц„  ?   Ч„  Ч„  ?   Ш„  Ш„  ?   Щ„  Щ„  ?   Ъ„  Ъ„  ?   Ы„  Ы„  ?   Ь„  Ь„  ?   Э„  Э„  ?   Ю„  Ю„  ?   Я„  Я„  ?   а„  а„  ?   б„  б„  ?   в„  в„  ?   г„  г„  ?   д„  д„  ?   е„  е„  ?   ж„  ж„  ?   з„  з„  ?   и„  и„  ?   й„  й„  ?   к„  к„  ?   л„  л„  ?   м„  м„  ?   н„  н„  ?   о„  о„  ?   п„  п„  ?   р„  р„  ?   с„  с„  ?   т„  т„  ?   у„  у„  ?   ф„  ф„  ?   х„  х„  ?   ц„  ц„  ?   ч„  ч„  ?   ш„  ш„  ?   щ„  щ„  ?   ъ„  ъ„  ?   ы„  ы„  ?   ь„  ь„  ?                                                                                                                                                                                                                                                         