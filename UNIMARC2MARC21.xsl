<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.loc.gov/MARC21/slim"
  xmlns:mx="info:lc/xmlns/marcxchange-v1"
  xmlns:map="http://example.org/map"
  exclude-result-prefixes="map mx">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <!--
    Transformation from UNIMARC XML representation (MarcXchange ISO 25577) to MARCXML.
    Based upon https://www.loc.gov/marc/unimarctomarc21.html
  -->
  <!--
    NOTE FOR LEGACY UNIMARC USERS:
    If your source XML incorrectly wraps UNIMARC tags in the Library of Congress MARC21 namespace
    (http://www.loc.gov/MARC21/slim) instead of valid ISO 25577 MarcXchange, change the 'xmlns:mx'
    declaration above to:
    xmlns:mx="http://www.loc.gov/MARC21/slim"
  -->

  <xsl:variable name="all-codes" select="'abcdefghijklmnopqrstuvwxyz123456789'"/>
  <xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

  <!-- UNIMARC / ISO 3166 -> MARC21 Country Codes (Table 1 : https://www.loc.gov/marc/unimarctomarc21_tables.pdf) -->
  <map:countries>
    <map:entry key="AD" val="an " desc="Andorra"/>
    <map:entry key="AE" val="ts " desc="United Arab Em."/>
    <map:entry key="AF" val="af " desc="Afghanistan"/>
    <map:entry key="AG" val="aq " desc="Antigua"/>
    <map:entry key="AL" val="aa " desc="Albania"/>
    <map:entry key="AN" val="na " desc="Netherlands Antilles"/>
    <map:entry key="AO" val="ao " desc="Angola"/>
    <map:entry key="AQ" val="ay " desc="Antarctica"/>
    <map:entry key="AR" val="ag " desc="Argentina"/>
    <map:entry key="AS" val="as " desc="American Samoa"/>
    <map:entry key="AT" val="au " desc="Austria"/>
    <map:entry key="AU" val="at " desc="Australia"/>
    <map:entry key="BB" val="bb " desc="Barbados"/>
    <map:entry key="BD" val="bg " desc="Bangladesh"/>
    <map:entry key="BE" val="be " desc="Belgium"/>
    <map:entry key="BG" val="bu " desc="Bulgaria"/>
    <map:entry key="BH" val="ba " desc="Bahrain"/>
    <map:entry key="BI" val="bd " desc="Burundi"/>
    <map:entry key="BJ" val="dm " desc="Benin (Dahomey)"/>
    <map:entry key="BM" val="bm " desc="Bermuda"/>
    <map:entry key="BN" val="cc " desc="China (PRC)"/>
    <map:entry key="BN" val="bx " desc="Brunei"/>
    <map:entry key="BO" val="bo " desc="Bolivia"/>
    <map:entry key="BR" val="bl " desc="Brazil"/>
    <map:entry key="BS" val="bf " desc="Bahamas"/>
    <map:entry key="BT" val="bt " desc="Bhutan"/>
    <map:entry key="BU" val="br " desc="Burma"/>
    <map:entry key="BV" val="bv " desc="Bouvet Island"/>
    <map:entry key="BW" val="bs " desc="Botswana"/>
    <map:entry key="BY" val="bw " desc="Belaru"/>
    <map:entry key="BZ" val="bh " desc="Belize"/>
    <map:entry key="CA" val="xxc" desc="Canada"/>
    <map:entry key="CC" val="xb " desc="Cocos Islands"/>
    <map:entry key="CF" val="cx " desc="Central African Rep."/>
    <map:entry key="CG" val="cf " desc="Congo (Brazzaville)"/>
    <map:entry key="CH" val="sz " desc="Switzerland"/>
    <map:entry key="CI" val="iv " desc="Ivory Coast"/>
    <map:entry key="CK" val="cw " desc="Cook Islands"/>
    <map:entry key="CL" val="cl " desc="Chile"/>
    <map:entry key="CM" val="cm " desc="Cameroon"/>
    <map:entry key="CO" val="ck " desc="Colombia"/>
    <map:entry key="CR" val="cr " desc="Costa Rica"/>
    <map:entry key="CT" val="cp " desc="Canton/Enderbury Is."/>
    <map:entry key="CU" val="cu " desc="Cuba"/>
    <map:entry key="CV" val="cv " desc="Cape Verde"/>
    <map:entry key="CX" val="xa " desc="Christmas Island"/>
    <map:entry key="CY" val="cy " desc="Cyprus"/>
    <map:entry key="CZ" val="xr " desc="Czech Republic"/>
    <map:entry key="DE" val="gw " desc="Germany"/>
    <map:entry key="DJ" val="ft " desc="Djibouti"/>
    <map:entry key="DK" val="dk " desc="Denmark"/>
    <map:entry key="DM" val="dq " desc="Dominica"/>
    <map:entry key="DO" val="dr " desc="Dominican Republic"/>
    <map:entry key="DZ" val="ae " desc="Algeria"/>
    <map:entry key="EC" val="ec " desc="Ecuador"/>
    <map:entry key="EG" val="ua " desc="Egypt (UAR)"/>
    <map:entry key="EH" val="ss " desc="Western Sahara"/>
    <map:entry key="ES" val="sp " desc="Spain"/>
    <map:entry key="ET" val="et " desc="Ethiopia"/>
    <map:entry key="FI" val="fi " desc="Finland"/>
    <map:entry key="FJ" val="fj " desc="Fiji"/>
    <map:entry key="FK" val="fk " desc="Falkland Islands"/>
    <map:entry key="FO" val="fa " desc="Faeroe Islands"/>
    <map:entry key="FQ" val="fs " desc="French So./Antarctic"/>
    <map:entry key="FR" val="fr " desc="France"/>
    <map:entry key="GA" val="go " desc="Gabon"/>
    <map:entry key="GB" val="xxk" desc="United Kingdom"/>
    <map:entry key="GD" val="gd " desc="Grenada"/>
    <map:entry key="GF" val="fg " desc="French Guiana"/>
    <map:entry key="GH" val="gh " desc="Ghana"/>
    <map:entry key="GI" val="gi " desc="Gibraltar"/>
    <map:entry key="GL" val="gl " desc="Greenland"/>
    <map:entry key="GM" val="gm " desc="Gambia"/>
    <map:entry key="GN" val="gv " desc="Guinea"/>
    <map:entry key="GP" val="gp " desc="Guadeloupe"/>
    <map:entry key="GQ" val="eg " desc="Equatorial Guinea"/>
    <map:entry key="GR" val="gr " desc="Greece"/>
    <map:entry key="GT" val="gt " desc="Guatemala"/>
    <map:entry key="GU" val="gu " desc="Guam"/>
    <map:entry key="GW" val="pg " desc="Guinea-Bissau"/>
    <map:entry key="GY" val="gy " desc="Guyana"/>
    <map:entry key="HK" val="hk " desc="Hong Kong"/>
    <map:entry key="HM" val="hm " desc="Heard &amp; McDonald Isl."/>
    <map:entry key="HN" val="ho " desc="Honduras"/>
    <map:entry key="HT" val="ht " desc="Haiti"/>
    <map:entry key="HU" val="hu " desc="Hungary"/>
    <map:entry key="HV" val="uv " desc="Burkina Faso"/>
    <map:entry key="ID" val="io " desc="Indonesia"/>
    <map:entry key="IE" val="ie " desc="Ireland"/>
    <map:entry key="IL" val="is " desc="Israel"/>
    <map:entry key="IN" val="ii " desc="India"/>
    <map:entry key="IO" val="bi " desc="British Indian Ocean Terr."/>
    <map:entry key="IQ" val="iq " desc="Iraq"/>
    <map:entry key="IR" val="ir " desc="Iran"/>
    <map:entry key="IS" val="ic " desc="Iceland"/>
    <map:entry key="IT" val="it " desc="Italy"/>
    <map:entry key="JM" val="jm " desc="Jamaica"/>
    <map:entry key="JO" val="jo " desc="Jordan"/>
    <map:entry key="JP" val="ja " desc="Japan"/>
    <map:entry key="JT" val="ji " desc="Johnston Atoll"/>
    <map:entry key="KE" val="ke " desc="Kenya"/>
    <map:entry key="KH" val="cb " desc="Cambodia (Kampuchea)"/>
    <map:entry key="KI" val="gb " desc="Kiribati"/>
    <map:entry key="KM" val="cq " desc="Comoros"/>
    <map:entry key="KN" val="xd " desc="St. Chris. &amp; Nevis Isl."/>
    <map:entry key="KP" val="kn " desc="Korea (North)"/>
    <map:entry key="KR" val="ko " desc="Korea (South)"/>
    <map:entry key="KW" val="ku " desc="Kuwait"/>
    <map:entry key="KY" val="cj " desc="Cayman Islands"/>
    <map:entry key="LA" val="ls " desc="Laos"/>
    <map:entry key="LB" val="le " desc="Lebanon"/>
    <map:entry key="LC" val="xk " desc="Saint Lucia"/>
    <map:entry key="LI" val="lh " desc="Liechtenstein"/>
    <map:entry key="LK" val="ce " desc="Sri Lanka (Ceylon)"/>
    <map:entry key="LR" val="lb " desc="Liberia"/>
    <map:entry key="LS" val="lo " desc="Lesotho"/>
    <map:entry key="LU" val="lu " desc="Luxembourg"/>
    <map:entry key="LY" val="ly " desc="Libya"/>
    <map:entry key="MA" val="mr " desc="Morocco"/>
    <map:entry key="MC" val="mc " desc="Monaco"/>
    <map:entry key="MG" val="mg " desc="Madagascar"/>
    <map:entry key="MI" val="xf " desc="Midway Islands"/>
    <map:entry key="ML" val="ml " desc="Mali"/>
    <map:entry key="MN" val="mp " desc="Mongolia"/>
    <map:entry key="MO" val="mh " desc="Macao"/>
    <map:entry key="MQ" val="mq " desc="Martinique"/>
    <map:entry key="MR" val="mu " desc="Mauritania"/>
    <map:entry key="MS" val="mj " desc="Montserrat"/>
    <map:entry key="MT" val="mm " desc="Malta"/>
    <map:entry key="MU" val="mf " desc="Mauritius"/>
    <map:entry key="MV" val="xc " desc="Maldive Islands"/>
    <map:entry key="MW" val="mw " desc="Malawi"/>
    <map:entry key="MX" val="mx " desc="Mexico"/>
    <map:entry key="MY" val="my " desc="Malaysia"/>
    <map:entry key="MZ" val="mz " desc="Mozambique"/>
    <map:entry key="NA" val="sx " desc="Namibia"/>
    <map:entry key="NC" val="nl " desc="New Caledonia"/>
    <map:entry key="NE" val="ng " desc="Niger"/>
    <map:entry key="NF" val="nx " desc="Norfolk Island"/>
    <map:entry key="NG" val="nr " desc="Nigeria"/>
    <map:entry key="NL" val="ne " desc="Netherlands"/>
    <map:entry key="NO" val="no " desc="Norway"/>
    <map:entry key="NP" val="np " desc="Nepal"/>
    <map:entry key="NQ" val="ay " desc="Dronning Maud Land"/>
    <map:entry key="NR" val="nu " desc="Nauru"/>
    <map:entry key="NT" val="iy " desc="Iraq-Saudi Neutral Zone"/>
    <map:entry key="NU" val="xh " desc="Niue"/>
    <map:entry key="NV" val="uc " desc="U.S. Misc. Carribbean Isl."/>
    <map:entry key="NZ" val="nz " desc="New Zealand"/>
    <map:entry key="OM" val="mk " desc="Oman"/>
    <map:entry key="PA" val="pn " desc="Panama"/>
    <map:entry key="PC" val="tt " desc="Trust Terr./Pac. Isl."/>
    <map:entry key="PE" val="pe " desc="Peru"/>
    <map:entry key="PF" val="fp " desc="French Polynesia"/>
    <map:entry key="PG" val="pp " desc="Papua New Guinea"/>
    <map:entry key="PH" val="ph " desc="Philippines"/>
    <map:entry key="PI" val="pf " desc="Paracel Islands"/>
    <map:entry key="PK" val="pk " desc="Pakistan"/>
    <map:entry key="PL" val="pl " desc="Poland"/>
    <map:entry key="PM" val="xl " desc="St Pierre Miquelon"/>
    <map:entry key="PN" val="pc " desc="Pitcairn Island"/>
    <map:entry key="PR" val="pr " desc="Puerto Rico"/>
    <map:entry key="PT" val="po " desc="Portugal"/>
    <map:entry key="PU" val="up " desc="U.S. Pacific Isl."/>
    <map:entry key="PY" val="py " desc="Paragua"/>
    <map:entry key="QA" val="qa " desc="Qatar"/>
    <map:entry key="RE" val="re " desc="Reunion"/>
    <map:entry key="RH" val="rh " desc="Rhodesia"/>
    <map:entry key="RO" val="rm " desc="Romania"/>
    <map:entry key="RW" val="rw " desc="Rwanda"/>
    <map:entry key="SA" val="su " desc="Saudi Arabia"/>
    <map:entry key="SB" val="bp " desc="Solomon Islands"/>
    <map:entry key="SC" val="se " desc="Seychelles"/>
    <map:entry key="SD" val="sj " desc="Sudan"/>
    <map:entry key="SE" val="sw " desc="Sweden"/>
    <map:entry key="SG" val="si " desc="Singapore"/>
    <map:entry key="SH" val="xj " desc="Saint Helena"/>
    <map:entry key="SI" val="xv " desc="Slovenia"/>
    <map:entry key="SI" val="xp " desc="Spratly Island"/>
    <map:entry key="SJ" val="sb " desc="Svalbard"/>
    <map:entry key="SK" val="xo " desc="Slovakia"/>
    <map:entry key="SL" val="sl " desc="Sierra Leone"/>
    <map:entry key="SM" val="sm " desc="San Marino"/>
    <map:entry key="SN" val="sg " desc="Senegal"/>
    <map:entry key="SO" val="so " desc="Somalia"/>
    <map:entry key="SR" val="sr " desc="Surinam"/>
    <map:entry key="ST" val="sf " desc="Sao Tome e Principe"/>
    <map:entry key="SU" val="xx " desc="USSR"/>
    <map:entry key="SV" val="es " desc="El Salvador"/>
    <map:entry key="SY" val="sy " desc="Syria"/>
    <map:entry key="SZ" val="sq " desc="Swaziland"/>
    <map:entry key="TC" val="tc " desc="Turks &amp; Caicos Isl."/>
    <map:entry key="TD" val="cd " desc="Chad"/>
    <map:entry key="TG" val="tg " desc="Togo"/>
    <map:entry key="TH" val="th " desc="Thailand"/>
    <map:entry key="TK" val="tl " desc="Tokelau Islands"/>
    <map:entry key="TN" val="ti " desc="Tunisia"/>
    <map:entry key="TO" val="to " desc="Tonga"/>
    <map:entry key="TP" val="io " desc="East Timor"/>
    <map:entry key="TR" val="tu " desc="Turkey"/>
    <map:entry key="TT" val="tr " desc="Trinidad and Tobago"/>
    <map:entry key="TV" val="tv " desc="Tuvalu"/>
    <map:entry key="TW" val="ch " desc="China (Taiwan)"/>
    <map:entry key="TZ" val="tz " desc="Tanzania"/>
    <map:entry key="UA" val="un " desc="Ukraine"/>
    <map:entry key="UG" val="ug " desc="Uganda"/>
    <map:entry key="US" val="xxu" desc="United States"/>
    <map:entry key="UY" val="uy " desc="Uruguay"/>
    <map:entry key="VA" val="vc " desc="Vatican City"/>
    <map:entry key="VC" val="xm " desc="Saint Vincent"/>
    <map:entry key="VE" val="ve " desc="Venezuela"/>
    <map:entry key="VG" val="vb " desc="Virgin Is. (British)"/>
    <map:entry key="VI" val="vi " desc="Virgin Is. (U.S.)"/>
    <map:entry key="VN" val="vm " desc="Vietnam"/>
    <map:entry key="VU" val="nn " desc="Vanuatu"/>
    <map:entry key="WF" val="wf " desc="Wallis and Futuna"/>
    <map:entry key="WK" val="wk " desc="Wake Island"/>
    <map:entry key="WS" val="ws " desc="Western Samoa"/>
    <map:entry key="XV" val="vp " desc="Various places"/>
    <map:entry key="YD" val="ys " desc="Yemen (Aden)"/>
    <map:entry key="YE" val="ye " desc="Yemen (Sana)"/>
    <map:entry key="YU" val="yu " desc="Yugoslavia"/>
    <map:entry key="ZA" val="sa " desc="South Africa"/>
    <map:entry key="ZM" val="za " desc="Zambia"/>
    <map:entry key="ZR" val="cg " desc="Zaire (Congo)"/>
    <map:entry key="ZW" val="rh " desc="Zimbabwe"/>
  </map:countries>

  <xsl:key name="country-map"
    match="map:countries/map:entry"
    use="@key"/>

  <!-- UNIMARC -> MARC21 Relator Codes (Table 2 : https://www.loc.gov/marc/unimarctomarc21_tables.pdf) -->
  <map:relators>
    <map:entry key="005" val="act" desc="actor"/>
    <map:entry key="010" val="adp" desc="adapter"/>
    <map:entry key="020" val="ann" desc="annotator"/>
    <map:entry key="030" val="arr" desc="arranger"/>
    <map:entry key="040" val="art" desc="artist"/>
    <map:entry key="050" val="asg" desc="assignee"/>
    <map:entry key="060" val="asn" desc="associated name"/>
    <map:entry key="065" val="auc" desc="auctioneer"/>
    <map:entry key="070" val="aut" desc="author"/>
    <map:entry key="072" val="aqt" desc="author in quotations or text abstract"/>
    <map:entry key="075" val="aft" desc="author of afterword, colophon, etc."/>
    <map:entry key="080" val="aui" desc="author of introd"/>
    <map:entry key="090" val="aus" desc="author of screenplay"/>
    <map:entry key="100" val="ant" desc="bibl. antecedent"/>
    <map:entry key="110" val="bnd" desc="binder"/>
    <map:entry key="120" val="bdd" desc="binding designer"/>
    <map:entry key="130" val="bkd" desc="book designer"/>
    <map:entry key="140" val="bjd" desc="bkjacket designer"/>
    <map:entry key="150" val="bpd" desc="bkplate designer"/>
    <map:entry key="160" val="bsl" desc="bookseller"/>
    <map:entry key="170" val="cll" desc="calligrapher"/>
    <map:entry key="180" val="ctg" desc="cartographer"/>
    <map:entry key="190" val="cns" desc="censor"/>
    <map:entry key="200" val="chr" desc="choreographer"/>
    <map:entry key="205" val="clb" desc="collaborator"/>
    <map:entry key="210" val="cmm" desc="commentator"/>
    <map:entry key="212" val="cwt" desc="commentator for written text"/>
    <map:entry key="220" val="com" desc="compiler"/>
    <map:entry key="230" val="cmp" desc="composer"/>
    <map:entry key="240" val="cmt" desc="compositor"/>
    <map:entry key="245" val="ccp" desc="conceptor"/>
    <map:entry key="250" val="cnd" desc="conductor"/>
    <map:entry key="255" val="csp" desc="consultant to a project"/>
    <map:entry key="260" val="cph" desc="copyright holder"/>
    <map:entry key="270" val="crr" desc="corrector"/>
    <map:entry key="273" val="cur" desc="curator"/>
    <map:entry key="275" val="dnc" desc="dancer"/>
    <map:entry key="280" val="dte" desc="dedicatee"/>
    <map:entry key="290" val="dto" desc="dedicator"/>
    <map:entry key="295" val="dgg" desc="degree grantor"/>
    <map:entry key="300" val="drt" desc="director"/>
    <map:entry key="305" val="dis" desc="dissertant"/>
    <map:entry key="310" val="dst" desc="distributor"/>
    <map:entry key="320" val="dnr" desc="donor"/>
    <map:entry key="330" val="dub" desc="dubious author"/>
    <map:entry key="340" val="edt" desc="editor"/>
    <map:entry key="350" val="egr" desc="engraver"/>
    <map:entry key="360" val="etr" desc="etcher"/>
    <map:entry key="365" val="exp" desc="expert"/>
    <map:entry key="370" val="flm" desc="film editor"/>
    <map:entry key="380" val="frg" desc="forger"/>
    <map:entry key="390" val="fmo" desc="former owner"/>
    <map:entry key="400" val="fnd" desc="funder"/>
    <map:entry key="410" val="grt" desc="graphic technician"/>
    <map:entry key="420" val="hnr" desc="honoree"/>
    <map:entry key="430" val="ilu" desc="illuminator"/>
    <map:entry key="440" val="ill" desc="illustrator"/>
    <map:entry key="450" val="ins" desc="inscriber"/>
    <map:entry key="460" val="ive" desc="interviewee"/>
    <map:entry key="470" val="ivr" desc="interviewer"/>
    <map:entry key="480" val="lbt" desc="librettist"/>
    <map:entry key="490" val="lse" desc="licensee"/>
    <map:entry key="500" val="lso" desc="licensor"/>
    <map:entry key="510" val="ltg" desc="lithographer"/>
    <map:entry key="520" val="lyr" desc="lyricist"/>
    <map:entry key="530" val="mte" desc="metal engraver"/>
    <map:entry key="540" val="mon" desc="monitor/contractor"/>
    <map:entry key="545" val="mus" desc="musician"/>
    <map:entry key="550" val="nrt" desc="narrator"/>
    <map:entry key="555" val="opn" desc="opponent"/>
    <map:entry key="557" val="orm" desc="organizer of meeting"/>
    <map:entry key="560" val="org" desc="originator"/>
    <map:entry key="570" val="oth" desc="other"/>
    <map:entry key="580" val="ppm" desc="papermaker"/>
    <map:entry key="582" val="pta" desc="patent applicant"/>
    <map:entry key="584" val="inv" desc="inventor"/>
    <map:entry key="587" val="pth" desc="patent holder"/>
    <map:entry key="590" val="prf" desc="performer"/>
    <map:entry key="595" val="res" desc="research"/>
    <map:entry key="600" val="pht" desc="photographer"/>
    <map:entry key="610" val="prt" desc="printer"/>
    <map:entry key="620" val="pop" desc="printer of plates"/>
    <map:entry key="630" val="pro" desc="producer"/>
    <map:entry key="635" val="prg" desc="programmer"/>
    <map:entry key="640" val="pfr" desc="proofreader"/>
    <map:entry key="650" val="pbl" desc="publisher"/>
    <map:entry key="651" val="pbd" desc="publishing director"/>
    <map:entry key="660" val="rcp" desc="recipient"/>
    <map:entry key="670" val="rce" desc="recording engineer"/>
    <map:entry key="673" val="rth" desc="research team head"/>
    <map:entry key="675" val="rev" desc="reviewer"/>
    <map:entry key="677" val="rtm" desc="research team member"/>
    <map:entry key="680" val="rbr" desc="rubricator"/>
    <map:entry key="690" val="sce" desc="scenarist"/>
    <map:entry key="695" val="sad" desc="scientific advisor"/>
    <map:entry key="700" val="scr" desc="scribe"/>
    <map:entry key="705" val="scl" desc="sulptor"/>
    <map:entry key="710" val="sec" desc="secretary"/>
    <map:entry key="720" val="sgn" desc="signer"/>
    <map:entry key="721" val="sng" desc="singer"/>
    <map:entry key="723" val="spn" desc="sponsor"/>
    <map:entry key="725" val="stn" desc="standards body"/>
    <map:entry key="727" val="ths" desc="thesis advisor"/>
    <map:entry key="730" val="trl" desc="translator"/>
    <map:entry key="740" val="tyd" desc="type designer"/>
    <map:entry key="750" val="tyg" desc="typographer"/>
    <map:entry key="755" val="voc" desc="vocalist"/>
    <map:entry key="760" val="wde" desc="wood engraver"/>
    <map:entry key="770" val="wam" desc="writer of accompanying material"/>
  </map:relators>

  <xsl:key name="relator-map"
    match="map:relators/map:entry"
    use="@key"/>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="mx:collection">
        <collection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
          <xsl:for-each select="mx:collection/mx:record">
            <record>
              <xsl:call-template name="record"/>
            </record>
          </xsl:for-each>
        </collection>
      </xsl:when>
      <xsl:otherwise>
        <record xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
          <xsl:for-each select="mx:record">
            <xsl:call-template name="record"/>
          </xsl:for-each>
        </record>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="record">
    <xsl:if test="@type">
      <xsl:attribute name="type">
        <xsl:variable name="val" select="normalize-space(@type)"/>
        <xsl:value-of select="concat(
          translate(substring($val, 1, 1), $lower, $upper),
          translate(substring($val, 2), $upper, $lower)
        )"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:call-template name="transform-leader"/>
    <xsl:call-template name="copy-control">
      <xsl:with-param name="tag">001</xsl:with-param>
    </xsl:call-template>

    <!-- 003 Control Number Identifier -->
    <xsl:variable name="unimarc003" select="string(mx:controlfield[@tag='003'])"/>
    <xsl:choose>
      <!-- BnF (France) -->
      <xsl:when test="contains($unimarc003, 'catalogue.bnf.fr')">
        <controlfield tag="003">FrPBN</controlfield>
      </xsl:when>
      <!-- BNP (Portugal) -->
      <xsl:when test="contains($unimarc003, 'id.bnportugal.gov.pt')">
        <controlfield tag="003">PoLiBN</controlfield>
      </xsl:when>
    </xsl:choose>

    <xsl:call-template name="copy-control">
      <xsl:with-param name="tag">005</xsl:with-param>
    </xsl:call-template>

    <!--008-->
    <xsl:call-template name="transform-100"/>

    <!--020->015-->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">020</xsl:with-param>
      <xsl:with-param name="dstTag">015</xsl:with-param>
      <xsl:with-param name="srcCodes">abz</xsl:with-param>
      <xsl:with-param name="dstCodes">2az</xsl:with-param>
    </xsl:call-template>

    <!--021->017 Copyright or Legal Deposit Number-->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">021</xsl:with-param>
      <xsl:with-param name="dstTag">017</xsl:with-param>
      <xsl:with-param name="srcCodes">ab</xsl:with-param>
      <xsl:with-param name="dstCodes">ba</xsl:with-param>
    </xsl:call-template>

    <!--010->020 ISBN-->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">010</xsl:with-param>
      <xsl:with-param name="dstTag">020</xsl:with-param>
      <xsl:with-param name="srcCodes">abdz</xsl:with-param>
      <xsl:with-param name="dstCodes">aqcz</xsl:with-param>
      <xsl:with-param name="stripChars">-</xsl:with-param>
    </xsl:call-template>

    <!--011->022 ISSN-->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">011</xsl:with-param>
      <xsl:with-param name="dstTag">022</xsl:with-param>
      <xsl:with-param name="srcCodes">ayz</xsl:with-param>
      <xsl:with-param name="dstCodes">azy</xsl:with-param>
    </xsl:call-template>

    <!-- 801->040 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">801</xsl:with-param>
      <xsl:with-param name="dstTag">040</xsl:with-param>
      <xsl:with-param name="srcCodes">abcg</xsl:with-param>
      <xsl:with-param name="dstCodes">acde</xsl:with-param>
    </xsl:call-template>

    <!-- 101->041 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">101</xsl:with-param>
      <xsl:with-param name="dstTag">041</xsl:with-param>
      <xsl:with-param name="srcCodes">abcde</xsl:with-param>
      <xsl:with-param name="dstCodes">akhbf</xsl:with-param>
    </xsl:call-template>

    <!-- 102->044 -->
    <xsl:if test="mx:datafield[@tag='102']">
      <datafield tag="044" ind1=" " ind2=" ">
        <xsl:for-each select="mx:datafield[@tag='102']/mx:subfield[@code='a']">
          <xsl:variable name="code" select="."/>
          <xsl:variable name="mapped">
            <xsl:for-each select="document('')">
              <xsl:value-of select="key('country-map', $code)/@val"/>
            </xsl:for-each>
          </xsl:variable>
          <!-- Get $b (subentity) immediately following $a -->
          <xsl:variable name="subentity" select="following-sibling::mx:subfield[1][@code='b']"/>

          <xsl:if test="string-length($mapped) &gt; 0">
            <subfield code="a">
              <xsl:value-of select="$mapped"/>
            </subfield>
          </xsl:if>
          <!-- Interleave $b between $a and $c, if it exists -->
          <xsl:if test="string-length($subentity) &gt; 0">
            <subfield code="b">
              <xsl:value-of select="$subentity"/>
            </subfield>
          </xsl:if>
          <!-- Output $c = case adjusted ISO -->
          <xsl:if test="string-length($code) &gt; 0">
            <subfield code="c">
              <xsl:value-of select="translate($code, $upper, $lower)"/>
            </subfield>
          </xsl:if>
        </xsl:for-each>
      </datafield>
    </xsl:if>

    <!-- 128->047 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">128</xsl:with-param>
      <xsl:with-param name="dstTag">047</xsl:with-param>
      <xsl:with-param name="srcCodes">a</xsl:with-param>
      <xsl:with-param name="dstCodes">a</xsl:with-param>
    </xsl:call-template>

    <!-- 615->072 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">615</xsl:with-param>
      <xsl:with-param name="dstTag">072</xsl:with-param>
      <xsl:with-param name="srcCodes">nm</xsl:with-param>
      <xsl:with-param name="dstCodes">ax</xsl:with-param>
    </xsl:call-template>

    <!-- 675->080 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">675</xsl:with-param>
      <xsl:with-param name="dstTag">080</xsl:with-param>
      <xsl:with-param name="srcCodes">a</xsl:with-param>
      <xsl:with-param name="dstCodes">a</xsl:with-param>
    </xsl:call-template>

    <!-- 676->082 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">676</xsl:with-param>
      <xsl:with-param name="dstTag">082</xsl:with-param>
      <xsl:with-param name="srcCodes">av</xsl:with-param>
      <xsl:with-param name="dstCodes">a2</xsl:with-param>
    </xsl:call-template>

    <!-- 700->100 -->
    <xsl:call-template name="transform-personal-name">
      <xsl:with-param name="srcTag">700</xsl:with-param>
      <xsl:with-param name="dstTag">100</xsl:with-param>
      <xsl:with-param name="combinecodes">ab</xsl:with-param>
      <xsl:with-param name="combinecodes_fin">aa</xsl:with-param>
      <xsl:with-param name="dstCodes1">cdfgp</xsl:with-param>
      <xsl:with-param name="dstCodes1_fin">cbdqu</xsl:with-param>
    </xsl:call-template>

    <!-- 500->240 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">500</xsl:with-param>
      <xsl:with-param name="dstTag">240</xsl:with-param>
      <xsl:with-param name="srcCodes">ahikm</xsl:with-param>
      <xsl:with-param name="dstCodes">anpfl</xsl:with-param>
    </xsl:call-template>

    <!-- 200->245 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">200</xsl:with-param>
      <xsl:with-param name="dstTag">245</xsl:with-param>
      <xsl:with-param name="srcCodes">aefb</xsl:with-param>
      <xsl:with-param name="dstCodes">abch</xsl:with-param>
    </xsl:call-template>

    <!-- 510, 512, 513, 514, 515, 516, 517->246-->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">510</xsl:with-param>
      <xsl:with-param name="dstTag">246</xsl:with-param>
      <xsl:with-param name="ind2">1</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">512</xsl:with-param>
      <xsl:with-param name="dstTag">246</xsl:with-param>
      <xsl:with-param name="ind2">4</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">513</xsl:with-param>
      <xsl:with-param name="dstTag">246</xsl:with-param>
      <xsl:with-param name="ind2">5</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">514</xsl:with-param>
      <xsl:with-param name="dstTag">246</xsl:with-param>
      <xsl:with-param name="ind2">6</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">515</xsl:with-param>
      <xsl:with-param name="dstTag">246</xsl:with-param>
      <xsl:with-param name="ind2">7</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">516</xsl:with-param>
      <xsl:with-param name="dstTag">246</xsl:with-param>
      <xsl:with-param name="ind2">8</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">517</xsl:with-param>
      <xsl:with-param name="dstTag">246</xsl:with-param>
      <xsl:with-param name="ind2">3</xsl:with-param>
    </xsl:call-template>

    <!-- 205->250 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">205</xsl:with-param>
      <xsl:with-param name="dstTag">250</xsl:with-param>
      <xsl:with-param name="srcCodes">ab</xsl:with-param>
      <xsl:with-param name="dstCodes">ab</xsl:with-param>
    </xsl:call-template>

    <!-- 210->260 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">210</xsl:with-param>
      <xsl:with-param name="dstTag">260</xsl:with-param>
      <xsl:with-param name="srcCodes">acd</xsl:with-param>
      <xsl:with-param name="dstCodes">abc</xsl:with-param>
      <xsl:with-param name="ind1">#</xsl:with-param>
      <xsl:with-param name="ind2">#</xsl:with-param>
    </xsl:call-template>

    <!-- 215->300 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">215</xsl:with-param>
      <xsl:with-param name="dstTag">300</xsl:with-param>
      <xsl:with-param name="srcCodes">acde</xsl:with-param>
      <xsl:with-param name="dstCodes">abce</xsl:with-param>
    </xsl:call-template>

    <!-- 225->490 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">255</xsl:with-param>
      <xsl:with-param name="dstTag">490</xsl:with-param>
      <xsl:with-param name="srcCodes">avx</xsl:with-param>
      <xsl:with-param name="dstCodes">avx</xsl:with-param>
    </xsl:call-template>

    <!-- 300-315 and 321 -> 500 General Note -->
    <xsl:for-each select="mx:datafield[((@tag &gt;= 300 and @tag &lt;= 315) or @tag = 321) and not(@tag = preceding-sibling::mx:datafield/@tag)]">
      <xsl:variable name="curTag" select="@tag"/>
      <xsl:for-each select="parent::mx:record">
        <xsl:call-template name="transform-datafield">
          <xsl:with-param name="srcTag" select="$curTag"/>
          <xsl:with-param name="dstTag">500</xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:for-each>

    <!-- 320->504 Bibliography Note -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">320</xsl:with-param>
      <xsl:with-param name="dstTag">504</xsl:with-param>
      <xsl:with-param name="srcCodes">a</xsl:with-param>
      <xsl:with-param name="dstCodes">a</xsl:with-param>
    </xsl:call-template>

    <!-- 600->600 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">600</xsl:with-param>
      <xsl:with-param name="dstTag">600</xsl:with-param>
      <xsl:with-param name="srcCodes">a</xsl:with-param>
      <xsl:with-param name="dstCodes">a</xsl:with-param>
    </xsl:call-template>

    <!-- 602->600 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">602</xsl:with-param>
      <xsl:with-param name="dstTag">600</xsl:with-param>
      <xsl:with-param name="srcCodes">cfxyz2</xsl:with-param>
      <xsl:with-param name="dstCodes">cdxzy2</xsl:with-param>
    </xsl:call-template>

    <!-- 610->653 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">610</xsl:with-param>
      <xsl:with-param name="dstTag">653</xsl:with-param>
    </xsl:call-template>

    <!-- 615->650 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">615</xsl:with-param>
      <xsl:with-param name="dstTag">650</xsl:with-param>
      <xsl:with-param name="srcCodes">ax</xsl:with-param>
    </xsl:call-template>

    <!-- 701->700 -->
    <xsl:call-template name="transform-personal-name">
      <xsl:with-param name="srcTag">701</xsl:with-param>
      <xsl:with-param name="dstTag">700</xsl:with-param>
      <xsl:with-param name="combinecodes">ab</xsl:with-param>
      <xsl:with-param name="combinecodes_fin">aa</xsl:with-param>
      <xsl:with-param name="dstCodes1">cdfgp</xsl:with-param>
      <xsl:with-param name="dstCodes1_fin">cbdqu</xsl:with-param>
    </xsl:call-template>

    <!-- 702->700 -->
    <xsl:call-template name="transform-personal-name">
      <xsl:with-param name="srcTag">702</xsl:with-param>
      <xsl:with-param name="dstTag">700</xsl:with-param>
      <xsl:with-param name="combinecodes">ab</xsl:with-param>
      <xsl:with-param name="combinecodes_fin">aa</xsl:with-param>
      <xsl:with-param name="dstCodes1">cdfgp</xsl:with-param>
      <xsl:with-param name="dstCodes1_fin">cbdqu</xsl:with-param>
    </xsl:call-template>

    <!-- 712->710 -->
    <xsl:call-template name="transform-name">
      <xsl:with-param name="srcTag">712</xsl:with-param>
      <xsl:with-param name="dstTag">710</xsl:with-param>
      <xsl:with-param name="combinecodes">ab</xsl:with-param>
      <xsl:with-param name="combinecodes_fin">aa</xsl:with-param>
      <xsl:with-param name="dstCodes1">defh</xsl:with-param>
      <xsl:with-param name="dstCodes1_fin">ncde</xsl:with-param>
    </xsl:call-template>

    <!-- 711->711 -->
    <xsl:call-template name="transform-name">
      <xsl:with-param name="srcTag">711</xsl:with-param>
      <xsl:with-param name="dstTag">711</xsl:with-param>
      <xsl:with-param name="combinecodes">ab</xsl:with-param>
      <xsl:with-param name="combinecodes_fin">aa</xsl:with-param>
      <xsl:with-param name="dstCodes1">defh</xsl:with-param>
      <xsl:with-param name="dstCodes1_fin">ncde</xsl:with-param>
    </xsl:call-template>

    <!-- 856->856 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">856</xsl:with-param>
      <xsl:with-param name="dstTag">856</xsl:with-param>
    </xsl:call-template>

    <!-- Capture local data 9xx -->
    <xsl:for-each select="mx:datafield[@tag &gt;= 900 and @tag &lt;= 999 and not(@tag = preceding-sibling::mx:datafield/@tag)]">
      <xsl:variable name="curTag" select="@tag"/>
      <xsl:for-each select="parent::mx:record">
        <xsl:call-template name="transform-datafield">
          <xsl:with-param name="srcTag" select="$curTag"/>
          <xsl:with-param name="dstTag" select="$curTag"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="transform-leader">
    <xsl:variable name="leader" select="mx:leader"/>
    <xsl:variable name="leader05" select="translate(substring($leader,06,1), 'o', 'c')"/>
    <xsl:variable name="leader06" select="translate(substring($leader,07,1), 'hmn', 'aor')"/>
    <xsl:variable name="leader07" select="substring($leader,08,1)"/>
    <xsl:variable name="leader08-16" select="' a2200000'"/>
    <xsl:variable name="leader17" select="translate(substring($leader,18,1), '23', '87')"/>
    <xsl:variable name="leader18" select="translate(substring($leader,19,1), ' n', 'c ')"/>
    <xsl:variable name="leader19-23" select="' 4500'"/>
    <leader>
      <xsl:value-of select="concat('00000', $leader05, $leader06, $leader07, $leader08-16, $leader17, $leader18, $leader19-23)"/>
    </leader>
  </xsl:template>
  <xsl:template name="copy-control">
    <xsl:param name="tag"/>
    <xsl:for-each select="mx:controlfield[@tag=$tag]">
      <controlfield tag="{$tag}">
        <xsl:value-of select="text()"/>
      </controlfield>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="transform-100">
    <xsl:variable name="source" select="mx:datafield[@tag='100']/mx:subfield[@code='a']"/>
    <xsl:variable name="f105" select="substring(concat(mx:datafield[@tag='105']/mx:subfield[@code='a'], '             '), 1, 13)"/>
    <xsl:variable name="illus-code" select="substring($f105, 1, 4)"/>
    <xsl:variable name="contents-form" select="substring($f105, 5, 4)"/>
    <xsl:variable name="repro-form" select="substring(concat(mx:datafield[@tag='106']/mx:subfield[@code='a'], ' '), 1, 1)"/>
    <xsl:variable name="dest00-05" select="substring($source,03,6)"/>
    <xsl:variable name="dest06" select="translate(substring($source,09,1), 'abcdefghij', 'cdusrqmtpe')"/>
    <xsl:variable name="dest07-14" select="substring($source,10,8)"/>
    <xsl:variable name="dest15-17">
      <xsl:variable name="code" select="normalize-space(mx:datafield[@tag='102']/mx:subfield[@code='a'][1])"/>
      <xsl:for-each select="document('')">
        <xsl:value-of select="substring(concat(key('country-map', $code)/@val, 'xx '), 1, 3)"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="dest18-21" select="translate($illus-code, 'ny', 'a ')"/>
    <xsl:variable name="dest22" select="translate(substring($source,18,1), 'bcadekmu', 'abjcdeg ')"/>
    <xsl:variable name="dest23-27" select="concat($repro-form, translate($contents-form, 'abcdefghijklmnopqrz', 'bciaderysp   l t n '))"/>
    <xsl:variable name="dest28" select="translate(substring($source,21,1), 'abcdefghy', 'fsllcizo ')"/>
    <xsl:variable name="dest29-32" select="concat(substring($f105, 9, 3), ' ')"/>
    <xsl:variable name="dest33" select="substring($source,35,1)"/>
    <xsl:variable name="dest34" select="translate(substring($f105, 13, 1), 'y', ' ')"/>
    <xsl:variable name="dest35-37" select="substring(concat(mx:datafield[@tag='101']/mx:subfield[@code='a'][1], '   '), 1, 3)"/>
    <xsl:variable name="dest38" select="translate(substring($source,22,1), '01', ' o')"/>
    <xsl:variable name="dest39" select="' '"/>
    <controlfield tag="008">
      <xsl:value-of select="concat($dest00-05, $dest06, $dest07-14, $dest15-17, $dest18-21, $dest22, $dest23-27, $dest28, $dest29-32, $dest33, $dest34, $dest35-37, $dest38, $dest39)"/>
    </controlfield>
  </xsl:template>

  <xsl:template name="transform-datafield">
    <xsl:param name="srcTag"/>
    <xsl:param name="dstTag" select="$srcTag"/>
    <xsl:param name="srcCodes" select="$all-codes"/>
    <xsl:param name="dstCodes" select="$srcCodes"/>
    <xsl:param name="stripChars" select="''"/>
    <xsl:param name="lowerCase" select="''"/>
    <xsl:param name="ind1" select="'x'"/>
    <xsl:param name="ind2" select="'x'"/>

    <xsl:if test="mx:datafield[@tag=$srcTag]/mx:subfield[contains($srcCodes, @code)]">
      <xsl:for-each select="mx:datafield[@tag=$srcTag]">
        <datafield tag="{$dstTag}">
          <xsl:call-template name="copy-indicators">
            <xsl:with-param name="ind1" select="$ind1"/>
            <xsl:with-param name="ind2" select="$ind2"/>
          </xsl:call-template>
          <xsl:call-template name="transform-subfields">
            <xsl:with-param name="srcCodes" select="$srcCodes"/>
            <xsl:with-param name="dstCodes" select="$dstCodes"/>
            <xsl:with-param name="stripChars" select="$stripChars"/>
            <xsl:with-param name="lowerCase" select="$lowerCase"/>
          </xsl:call-template>
        </datafield>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

<xsl:template name="transform-personal-name">
    <xsl:param name="srcTag"/>
    <xsl:param name="dstTag"/>
    <xsl:param name="combinecodes"/>
    <xsl:param name="combinecodes_fin"/>
    <xsl:param name="dstCodes1"/>
    <xsl:param name="dstCodes1_fin"/>

    <xsl:for-each select="mx:datafield[@tag=$srcTag]">
      <datafield tag="{$dstTag}" ind1="{translate(@ind2, '#|', '11')}" ind2=" ">

        <xsl:call-template name="transform-subfields-personal-combine">
          <xsl:with-param name="srcCodes" select="$combinecodes"/>
          <xsl:with-param name="dstCodes" select="$combinecodes_fin"/>
          <xsl:with-param name="stripChars">,</xsl:with-param>
        </xsl:call-template>

        <xsl:if test="$dstCodes1 != ''">
          <xsl:call-template name="transform-subfields">
            <xsl:with-param name="srcCodes" select="$dstCodes1"/>
            <xsl:with-param name="dstCodes" select="$dstCodes1_fin"/>
          </xsl:call-template>
        </xsl:if>

	<!-- Make the $4 relator substitution from UNIMARC numeric to MARC21 3-char codes -->
        <xsl:for-each select="mx:subfield[@code='4']">
          <xsl:variable name="rawCode" select="normalize-space(.)"/>
          <xsl:variable name="mappedCode">
            <xsl:for-each select="document('')">
              <xsl:value-of select="key('relator-map', $rawCode)/@val"/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:if test="string-length($mappedCode) &gt; 0">
            <subfield code="4">
              <xsl:value-of select="$mappedCode"/>
            </subfield>
          </xsl:if>
        </xsl:for-each>

      </datafield>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="transform-name">
    <xsl:param name="srcTag"/>
    <xsl:param name="dstTag"/>
    <xsl:param name="combinecodes"/>
    <xsl:param name="combinecodes_fin"/>
    <xsl:param name="dstCodes1"/>
    <xsl:param name="dstCodes1_fin"/>

    <xsl:for-each select="mx:datafield[@tag=$srcTag]">
      <datafield tag="{$dstTag}" ind1="{translate(@ind2, '#|', '11')}" ind2=" ">
        <xsl:call-template name="transform-subfields-combine">
          <xsl:with-param name="srcCodes" select="$combinecodes"/>
          <xsl:with-param name="dstCodes" select="$combinecodes_fin"/>
        </xsl:call-template>

        <xsl:if test="$dstCodes1 != ''">
          <xsl:call-template name="transform-subfields">
            <xsl:with-param name="srcCodes" select="$dstCodes1"/>
            <xsl:with-param name="dstCodes" select="$dstCodes1_fin"/>
          </xsl:call-template>
        </xsl:if>
      </datafield>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="copy-indicators">
    <xsl:param name="ind1"/>
    <xsl:param name="ind2"/>

    <xsl:attribute name="ind1">
      <xsl:value-of select="translate(substring(concat($ind1, @ind1), 1 + ($ind1 = 'x'), 1), '#|', '  ')"/>
    </xsl:attribute>
    <xsl:attribute name="ind2">
      <xsl:value-of select="translate(substring(concat($ind2, @ind2), 1 + ($ind2 = 'x'), 1), '#|', '  ')"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="transform-subfields-combine">
    <xsl:param name="data_code" select="'a'"/>
    <xsl:param name="srcCodes"/>
    <xsl:param name="dstCodes"/>
    <xsl:param name="stripChars" select="''"/>

    <subfield>
      <xsl:attribute name="code"><xsl:value-of select="$data_code"/></xsl:attribute>
      <xsl:for-each select="mx:subfield[contains($srcCodes, @code)]">
        <xsl:choose>
          <xsl:when test="$stripChars!=''">
            <xsl:value-of select="translate(text(), $stripChars, '')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="text()"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position()!=last()"> </xsl:if>
      </xsl:for-each>
    </subfield>
  </xsl:template>

  <xsl:template name="transform-subfields-personal-combine">
    <xsl:param name="data_code" select="'a'"/>
    <xsl:param name="srcCodes"/>
    <xsl:param name="dstCodes"/>
    <xsl:param name="stripChars" select="''"/>

    <subfield>
      <xsl:attribute name="code"><xsl:value-of select="$data_code"/></xsl:attribute>
      <xsl:for-each select="mx:subfield[contains($srcCodes, @code)]">
        <xsl:choose>
          <xsl:when test="$stripChars!=''">
            <xsl:value-of select="translate(text(), $stripChars, '')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="text()"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position()!=last()">, </xsl:if>
      </xsl:for-each>
    </subfield>
  </xsl:template>

  <xsl:template name="transform-subfields">
    <xsl:param name="srcCodes" select="$all-codes"/>
    <xsl:param name="dstCodes" select="$srcCodes"/>
    <xsl:param name="stripChars" select="''"/>
    <xsl:param name="lowerCase" select="''"/>

    <xsl:for-each select="mx:subfield[contains($srcCodes, @code)]">
      <subfield code="{translate(@code, $srcCodes, $dstCodes)}">
        <!-- Unconditionally strip characters -->
        <xsl:variable name="stripped" select="translate(text(), $stripChars, '')"/>
        <xsl:choose>
          <xsl:when test="$lowerCase != '' and contains($lowerCase, @code)">
            <xsl:value-of select="translate($stripped, $upper, $lower)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$stripped"/>
          </xsl:otherwise>
        </xsl:choose>
      </subfield>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
