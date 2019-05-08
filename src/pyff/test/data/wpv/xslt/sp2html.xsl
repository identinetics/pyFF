<?xml version="1.0"?>
<!--
  Copyright (C) 2013 Peter Schober <peter@aco.net>

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU Affero General Public License as
  published by the Free Software Foundation, either version 3 of the
  License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Affero General Public License for more details.

  You should have received a copy of the GNU Affero General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:md="urn:oasis:names:tc:SAML:2.0:metadata"
                xmlns:mdui="urn:oasis:names:tc:SAML:metadata:ui"
                xmlns:mdrpi="urn:oasis:names:tc:SAML:metadata:rpi"
                xmlns:shibmd="urn:mace:shibboleth:metadata:1.0"
                xmlns:mdattr="urn:oasis:names:tc:SAML:metadata:attribute"
                xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion"
                xmlns:alg="urn:oasis:names:tc:SAML:metadata:algsupport"
                xmlns:init="urn:oasis:names:tc:SAML:profiles:SSO:request-init"
                exclude-result-prefixes="md mdui mdrpi shibmd mdattr saml alg init">
  <xsl:output method="html" omit-xml-declaration="yes" indent="yes" encoding="iso-8859-1"/>
  <xsl:template match="/md:EntitiesDescriptor">
    <html>
      <head>
        <title>SP</title>
        <script type="text/javascript" src="js/jquery-latest.js"></script>
        <script type="text/javascript" src="js/jquery.metadata.js"></script>
        <script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
        <script type="text/javascript" src="js/script.js"></script>
        <link rel="stylesheet" href="themes/blue/style.css" />
      </head>
      <body>
        <table id="datatable" border="1" cellpadding="5" cellspacing="0" class="tablesorter">
          <thead>
            <tr class="eduid_head">
              <th>Organisation</th>
              <th>Service</th>
              <th>Beschreibung</th>
              <th>Attribute</th>
              <th>SAML Entity</th>
            </tr>
          </thead>
          <tbody>
            <xsl:apply-templates select="md:EntityDescriptor[md:SPSSODescriptor]"/>
          </tbody>
          <tfoot>
            <tr class="eduid_head">
              <th>Organisation</th>
              <th>Service</th>
              <th>Beschreibung</th>
              <th>Attribute</th>
              <th>SAML Entity</th>
            </tr>
          </tfoot>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="md:EntityDescriptor">
    <!-- Try hard to find a Name -->
    <xsl:variable name="mduiName.de">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:DisplayName[@xml:lang='de'])"/>
    </xsl:variable>
    <xsl:variable name="mduiName.en">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:DisplayName[@xml:lang='en'])"/>
    </xsl:variable>
    <xsl:variable name="mduiName.any">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:DisplayName[@xml:lang and @xml:lang!='de' and @xml:lang!='en'][1])"/>
    </xsl:variable>
    <xsl:variable name="srvName.de">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:AttributeConsumingService/md:ServiceName[@xml:lang='de'])"/>
    </xsl:variable>
    <xsl:variable name="srvName.en">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:AttributeConsumingService/md:ServiceName[@xml:lang='en'])"/>
    </xsl:variable>
    <xsl:variable name="srvName.any">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:AttributeConsumingService/md:ServiceName[@xml:lang and @xml:lang!='de' and @xml:lang!='en'][1])"/>
    </xsl:variable>
    <xsl:variable name="Name">
      <xsl:choose>
        <xsl:when test="string-length($mduiName.de) &gt; 0">
          <xsl:value-of select="$mduiName.de"/>
        </xsl:when>
        <xsl:when test="string-length($mduiName.en) &gt; 0">
          <xsl:value-of select="$mduiName.en"/>
        </xsl:when>
        <xsl:when test="string-length($srvName.de) &gt; 0">
          <xsl:value-of select="$srvName.de"/>
        </xsl:when>
        <xsl:when test="string-length($srvName.en) &gt; 0">
          <xsl:value-of select="$srvName.en"/>
        </xsl:when>
        <xsl:when test="string-length($mduiName.any) &gt; 0">
          <xsl:value-of select="$mduiName.any"/>
        </xsl:when>
        <xsl:when test="string-length($srvName.any) &gt; 0">
          <xsl:value-of select="$srvName.any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Try hard to find a Description -->
    <xsl:variable name="mduiDesc.de">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:Description[@xml:lang='de'])"/>
    </xsl:variable>
    <xsl:variable name="mduiDesc.en">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:Description[@xml:lang='en'])"/>
    </xsl:variable>
    <xsl:variable name="mduiDesc.any">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:Description[@xml:lang and @xml:lang!='de' and @xml:lang!='en'][1])"/>
    </xsl:variable>
    <xsl:variable name="srvDesc.de">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:AttributeConsumingService/md:ServiceDescription[@xml:lang='de'])"/>
    </xsl:variable>
    <xsl:variable name="srvDesc.en">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:AttributeConsumingService/md:ServiceDescription[@xml:lang='en'])"/>
    </xsl:variable>
    <xsl:variable name="srvDesc.any">
      <xsl:value-of select="normalize-space(md:SPSSODescriptor/md:AttributeConsumingService/md:ServiceDescription[@xml:lang and @xml:lang!='de' and @xml:lang!='en'][1])"/>
    </xsl:variable>
    <xsl:variable name="Desc">
      <xsl:choose>
        <xsl:when test="string-length($mduiDesc.de) &gt; 0">
          <xsl:value-of select="$mduiDesc.de"/>
        </xsl:when>
        <xsl:when test="string-length($mduiDesc.en) &gt; 0">
          <xsl:value-of select="$mduiDesc.en"/>
        </xsl:when>
        <xsl:when test="string-length($srvDesc.de) &gt; 0">
          <xsl:value-of select="$srvDesc.de"/>
        </xsl:when>
        <xsl:when test="string-length($srvDesc.en) &gt; 0">
          <xsl:value-of select="$srvDesc.en"/>
        </xsl:when>
        <xsl:when test="string-length($mduiDesc.any) &gt; 0">
          <xsl:value-of select="$mduiDesc.any"/>
        </xsl:when>
        <xsl:when test="string-length($srvDesc.any) &gt; 0">
          <xsl:value-of select="$srvDesc.any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Try hard to find an Info URL -->
    <xsl:variable name="mduiURL.de">
      <xsl:value-of select="md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:InformationURL[@xml:lang='de']"/>
    </xsl:variable>
    <xsl:variable name="mduiURL.en">
      <xsl:value-of select="md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:InformationURL[@xml:lang='en']"/>
    </xsl:variable>
    <xsl:variable name="mduiURL.any">
      <xsl:value-of select="md:SPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:InformationURL[@xml:lang and @xml:lang!='de' and @xml:lang!='en'][1]"/>
    </xsl:variable>
    <xsl:variable name="mduiURL">
      <xsl:choose>
        <xsl:when test="string-length($mduiURL.de) &gt; 0">
          <xsl:value-of select="$mduiURL.de"/>
        </xsl:when>
        <xsl:when test="string-length($mduiURL.en) &gt; 0">
          <xsl:value-of select="$mduiURL.en"/>
        </xsl:when>
        <xsl:when test="string-length($mduiURL.any) &gt; 0">
          <xsl:value-of select="$mduiURL.any"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <!-- Try hard to find a Logo URL -->
    <xsl:variable name="mduiLogoURL.de">
      <xsl:value-of select="md:IDPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:Logo[@xml:lang='de']"/>
    </xsl:variable>
    <xsl:variable name="mduiLogoURL.en">
      <xsl:value-of select="md:IDPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:Logo[@xml:lang='en']"/>
    </xsl:variable>
    <xsl:variable name="mduiLogoURL.any">
      <xsl:value-of select="md:IDPSSODescriptor/md:Extensions/mdui:UIInfo/mdui:Logo[@xml:lang and @xml:lang!='de' and @xml:lang!='en'][1]"/>
    </xsl:variable>
    <xsl:variable name="mduiLogoURL">
      <xsl:choose>
        <xsl:when test="string-length($mduiURL.de) &gt; 0">
          <xsl:value-of select="$mduiURL.de"/>
        </xsl:when>
        <xsl:when test="string-length($mduiURL.en) &gt; 0">
          <xsl:value-of select="$mduiURL.en"/>
        </xsl:when>
        <xsl:when test="string-length($mduiURL.any) &gt; 0">
          <xsl:value-of select="$mduiURL.any"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <!-- Try hard to find an Org Name -->
    <xsl:variable name="orgName.de">
      <xsl:value-of select="normalize-space(md:Organization/md:OrganizationDisplayName[@xml:lang='de'])"/>
    </xsl:variable>
    <xsl:variable name="orgName.en">
      <xsl:value-of select="normalize-space(md:Organization/md:OrganizationDisplayName[@xml:lang='en'])"/>
    </xsl:variable>
    <xsl:variable name="orgName.any">
      <xsl:value-of select="normalize-space(md:Organization/md:OrganizationDisplayName[@xml:lang and @xml:lang!='de' and @xml:lang!='en'][1])"/>
    </xsl:variable>
    <xsl:variable name="orgName">
      <xsl:choose>
        <xsl:when test="string-length($orgName.de) &gt; 0">
          <xsl:value-of select="$orgName.de"/>
        </xsl:when>
        <xsl:when test="string-length($orgName.en) &gt; 0">
          <xsl:value-of select="$orgName.en"/>
        </xsl:when>
        <xsl:when test="string-length($orgName.any) &gt; 0">
          <xsl:value-of select="$orgName.any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Try hard to find an Org URL -->
    <xsl:variable name="orgURL.de">
      <xsl:value-of select="md:Organization/md:OrganizationURL[@xml:lang='de']"/>
    </xsl:variable>
    <xsl:variable name="orgURL.en">
      <xsl:value-of select="md:Organization/md:OrganizationURL[@xml:lang='en']"/>
    </xsl:variable>
    <xsl:variable name="orgURL.any">
      <xsl:value-of select="md:Organization/md:OrganizationURL[@xml:lang and @xml:lang!='de' and @xml:lang!='en'][1]"/>
    </xsl:variable>
    <xsl:variable name="orgURL">
      <xsl:choose>
        <xsl:when test="string-length($orgURL.de) &gt; 0">
          <xsl:value-of select="$orgURL.de"/>
        </xsl:when>
        <xsl:when test="string-length($orgURL.en) &gt; 0">
          <xsl:value-of select="$orgURL.en"/>
        </xsl:when>
        <xsl:when test="string-length($orgURL.any) &gt; 0">
          <xsl:value-of select="$orgURL.any"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="regAuth">
      <xsl:value-of select="md:Extensions/mdrpi:RegistrationInfo/@registrationAuthority"/>
    </xsl:variable>

    <tr>

      <!-- Organization + URL -->
      <td valign="top">
        <xsl:choose>
          <xsl:when test="$orgURL and contains($orgURL, '://')">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$orgURL"/>
              </xsl:attribute>
              <xsl:value-of select="$orgName"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$orgName"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>

      <!-- Service name + URL -->
      <td valign="top">
        <xsl:choose>
          <xsl:when test="$mduiURL and contains($mduiURL, '://')">
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="$mduiURL"/>
              </xsl:attribute>
              <xsl:value-of select="$Name"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$Name"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>

      <!-- Service description -->
      <td valign="top">
        <xsl:value-of select="$Desc"/>
      </td>

      <!-- Requested Attrs -->
      <td valign="top">
        <table>
          <xsl:if test="md:Extensions/mdattr:EntityAttributes/saml:Attribute[@Name='http://macedir.org/entity-category']">
            <tr>
              <td>EntityCat</td>
            </tr>
          </xsl:if>
          <xsl:if test="md:Extensions/alg:DigestMethod or md:Extensions/alg:SigningMethod">
            <tr>
              <td>Algorithms</td>
            </tr>
          </xsl:if>
          <xsl:if test="*/md:SingleLogoutService">
            <tr>
              <td>SLO</td>
            </tr>
          </xsl:if>
          <xsl:if test="md:SPSSODescriptor/md:Extensions/init:RequestInitiator">
            <tr>
              <td>RIP</td>
            </tr>
          </xsl:if>
        </table>
      </td>

      <!-- Entity
        The file name is the entityID as directory (double url-encoded) + 'ed.xml'
      -->
      <td valign="top">
        <xsl:variable name="encodedFilename">
          <xsl:call-template name="url-encode">
            <xsl:with-param name="str" select="@entityID"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="doubleEncodedFilename">
          <xsl:call-template name="url-encode">
            <xsl:with-param name="str" select="$encodedFilename"/>
          </xsl:call-template>
        </xsl:variable>
        <a href="entities/{$doubleEncodedFilename}/ed.xml">
          <xsl:value-of select="@entityID"/>
        </a>
      </td>


    </tr>
  </xsl:template>

  <xsl:template match="md:ContactPerson" name="ContactName">
    <xsl:apply-templates select="md:GivenName"/>
    <xsl:if test="md:GivenName">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="md:SurName"/>
  </xsl:template>

  <xsl:template match="md:EmailAddress">
    <xsl:choose>
      <xsl:when test="contains(text(),'mailto:')">
        <xsl:value-of select="normalize-space(substring-after(text(),'mailto:'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space(text())"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="md:GivenName">
    <xsl:value-of select="normalize-space(text())"/>
  </xsl:template>

  <xsl:template match="md:SurName">
    <xsl:value-of select="normalize-space(text())"/>
  </xsl:template>

  <xsl:template match="md:SPSSODescriptor/md:Extensions/shibmd:Scope">
    <xsl:value-of select="normalize-space(text())"/>
  </xsl:template>

  <xsl:template name="Scopes">
    <xsl:for-each select="md:SPSSODescriptor/md:Extensions/shibmd:Scope">
      <li>
        <xsl:value-of select="normalize-space(text())"/>
      </li>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="Contacts">
    <xsl:for-each select="md:ContactPerson[@contactType='technical']">
      <li>
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:text>mailto:</xsl:text>
            <xsl:apply-templates select="md:EmailAddress"/>
          </xsl:attribute>
          <xsl:call-template name="ContactName"/>
        </xsl:element>
      </li>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="md:RequestedAttribute">
    <tr>
      <xsl:choose>
        <xsl:when test="@isRequired = 'true'">
          <td align="right">
            <div>
              <span title="notwendig">
                <input type="checkbox" name="required" value="true" checked="checked" disabled="disabled"/>
              </span>
            </div>
          </td>
          <td class="notwendig">
            <xsl:choose>
              <xsl:when test="@FriendlyName">
                <xsl:element name="span">
                  <xsl:attribute name="title">
                    <xsl:value-of select="@Name"/>
                  </xsl:attribute>
                  <xsl:value-of select="@FriendlyName"/>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@Name"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </xsl:when>
        <xsl:otherwise>
          <td align="right">
            <div>
              <span title="optional">
                <input type="checkbox" name="required" value="false" disabled="disabled"/>
              </span>
            </div>
          </td>
          <td class="optional">
            <xsl:choose>
              <xsl:when test="@FriendlyName">
                <xsl:element name="span">
                  <xsl:attribute name="title">
                    <xsl:value-of select="@Name"/>
                  </xsl:attribute>
                  <xsl:value-of select="@FriendlyName"/>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@Name"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </xsl:otherwise>
      </xsl:choose>
    </tr>
  </xsl:template>


  <!-- ISO-8859-1 based URL-encoding demo
       Written by Mike J. Brown, mike@skew.org.
       Updated 2015-10-24 (to update the license).
       License: CC0 <https://creativecommons.org/publicdomain/zero/1.0/deed.en>
       Also see http://skew.org/xml/misc/URI-i18n/ for a discussion of
       non-ASCII characters in URIs.
  -->
  <!-- The string to URL-encode.
       Note: By "iso-string" we mean a Unicode string where all
       the characters happen to fall in the ASCII and ISO-8859-1
       ranges (32-126 and 160-255) -->
  <!-- Characters we'll support.        We could add control chars 0-31 and 127-159, but we won't. -->
  <xsl:variable name="ascii"> !"#$%&amp;'()*+,-./0123456789:;&lt;=&gt;?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~</xsl:variable>
  <xsl:variable name="latin1">&#160;&#161;&#162;&#163;&#164;&#165;&#166;&#167;&#168;&#169;&#170;&#171;&#172;&#173;&#174;&#175;&#176;&#177;&#178;&#179;&#180;&#181;&#182;&#183;&#184;&#185;&#186;&#187;&#188;&#189;&#190;&#191;&#192;&#193;&#194;&#195;&#196;&#197;&#198;&#199;&#200;&#201;&#202;&#203;&#204;&#205;&#206;&#207;&#208;&#209;&#210;&#211;&#212;&#213;&#214;&#215;&#216;&#217;&#218;&#219;&#220;&#221;&#222;&#223;&#224;&#225;&#226;&#227;&#228;&#229;&#230;&#231;&#232;&#233;&#234;&#235;&#236;&#237;&#238;&#239;&#240;&#241;&#242;&#243;&#244;&#245;&#246;&#247;&#248;&#249;&#250;&#251;&#252;&#253;&#254;&#255;</xsl:variable>
  <!-- Characters that usually don't need to be escaped -->
  <xsl:variable name="safe">!'()*-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~</xsl:variable>
  <xsl:variable name="hex" >0123456789ABCDEF</xsl:variable>


  <xsl:template name="url-encode">
    <xsl:param name="str"/>
    <xsl:if test="$str">
      <xsl:variable name="first-char" select="substring($str,1,1)"/>
      <xsl:choose>
        <xsl:when test="contains($safe,$first-char)">
          <xsl:value-of select="$first-char"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="codepoint">
            <xsl:choose>
              <xsl:when test="contains($ascii,$first-char)">
                <xsl:value-of select="string-length(substring-before($ascii,$first-char)) + 32"/>
              </xsl:when>
              <xsl:when test="contains($latin1,$first-char)">
                <xsl:value-of select="string-length(substring-before($latin1,$first-char)) + 160"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:message terminate="no">Warning: string contains a character that is out of range! Substituting "?".</xsl:message>
                <xsl:text>63</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
        <xsl:variable name="hex-digit1" select="substring($hex,floor($codepoint div 16) + 1,1)"/>
        <xsl:variable name="hex-digit2" select="substring($hex,$codepoint mod 16 + 1,1)"/>
        <xsl:value-of select="concat('%',$hex-digit1,$hex-digit2)"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="string-length($str) &gt; 1">
        <xsl:call-template name="url-encode">
          <xsl:with-param name="str" select="substring($str,2)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>