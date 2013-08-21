<!--
Author: Eric Carestia
ERC Softworks
-->


<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl fn xs plan-xsl plan" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"/>
               

  <!-- determines whether a date string is a valid date -->
  <xsl:function name="plan-xsl:is-valid-date">
    <xsl:param name="input" />
    <xsl:choose>
      <xsl:when test="string($input) castable as xs:date"><xsl:value-of select="fn:true()" /></xsl:when>
      <xsl:when test="plan-xsl:parse-date($input) castable as xs:date"><xsl:value-of select="fn:true()" /></xsl:when>
      <xsl:otherwise><xsl:value-of select="fn:false()" /></xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- converts a date string into a date -->
  <xsl:function name="plan-xsl:parse-date">
    <xsl:param name="input" />
    <!-- xslt doesn't have any built-in date parsing functions, so it only recognizes yyyy-MM-dd format -->
    <!-- define some other formats -->
    <xsl:variable name="yyyyMMdd">^(\d\d\d\d)(\d\d)(\d\d)$</xsl:variable>
    <xsl:variable name="yyyy_dot_MM_dot_dd">^(\d\d\d\d)\.(\d\d)\.(\d\d)$</xsl:variable>
    <xsl:variable name="yyyy_slash_MM_slash_dd">^(\d\d\d\d)/(\d\d)/(\d\d)$</xsl:variable>
    <xsl:variable name="M_dash_d_dash_yyyy">^(\d{1,2})-(\d{1,2})-(\d\d\d\d)$</xsl:variable>
    <xsl:variable name="M_dot_d_dot_yyyy">^(\d{1,2})\.(\d{1,2})\.(\d\d\d\d)$</xsl:variable>
    <xsl:variable name="M_slash_d_slash_yyyy">^(\d{1,2})/(\d{1,2})/(\d\d\d\d)$</xsl:variable>
    <xsl:choose>
      <!-- if any of these xsl:when cases are successful, it's a valid date -->
      <xsl:when test="string($input) castable as xs:date">
        <xsl:value-of select="string($input) cast as xs:date" />
      </xsl:when>
      <xsl:when test="plan-xsl:test-date($input, $yyyyMMdd, 1, 2, 3) castable as xs:date">
        <xsl:value-of select="plan-xsl:test-date($input, $yyyyMMdd, 1, 2, 3) cast as xs:date" />
      </xsl:when>
      <xsl:when test="plan-xsl:test-date($input, $yyyy_dot_MM_dot_dd, 1, 2, 3) castable as xs:date">
        <xsl:value-of select="plan-xsl:test-date($input, $yyyy_dot_MM_dot_dd, 1, 2, 3) cast as xs:date" />
      </xsl:when>
      <xsl:when test="plan-xsl:test-date($input, $yyyy_slash_MM_slash_dd, 1, 2, 3) castable as xs:date">
        <xsl:value-of select="plan-xsl:test-date($input, $yyyy_slash_MM_slash_dd, 1, 2, 3) cast as xs:date" />
      </xsl:when>
      <xsl:when test="plan-xsl:test-date($input, $M_dash_d_dash_yyyy, 3, 1, 2) castable as xs:date">
        <xsl:value-of select="plan-xsl:test-date($input, $M_dash_d_dash_yyyy, 3, 1, 2) cast as xs:date" />
      </xsl:when>
      <xsl:when test="plan-xsl:test-date($input, $M_dash_d_dash_yyyy, 3, 1, 2) castable as xs:date">
        <xsl:value-of select="plan-xsl:test-date($input, $M_dash_d_dash_yyyy, 3, 1, 2) cast as xs:date" />
      </xsl:when>
      <xsl:when test="plan-xsl:test-date($input, $M_dot_d_dot_yyyy, 3, 1, 2) castable as xs:date">
        <xsl:value-of select="plan-xsl:test-date($input, $M_dot_d_dot_yyyy, 3, 1, 2) cast as xs:date" />
      </xsl:when>
      <xsl:when test="plan-xsl:test-date($input, $M_slash_d_slash_yyyy, 3, 1, 2) castable as xs:date">
        <!--<xsl:message><xsl:value-of select="$input" /> valid according to <xsl:value-of select="$M_slash_d_slash_yyyy" /></xsl:message>-->
        <xsl:value-of select="plan-xsl:test-date($input, $M_slash_d_slash_yyyy, 3, 1, 2) cast as xs:date" />
      </xsl:when>
      <!-- if all xsl:when cases fail, it's not a valid date -->
      <xsl:otherwise>
        <!--<xsl:message><xsl:value-of select="$input" /> not a valid date</xsl:message>-->
        <xsl:value-of select="$input" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- attempts to convert a date string into a date suitable for use with xsl -->
  <xsl:function name="plan-xsl:test-date">
    <xsl:param name="input" />
    <xsl:param name="pattern" />
    <xsl:param name="year-group" />
    <xsl:param name="month-group" />
    <xsl:param name="day-group" />
    <xsl:choose>
      <xsl:when test="$input">
        <xsl:analyze-string select="$input" regex="{$pattern}">
          <xsl:matching-substring>
            <xsl:variable name="year" select="xs:integer(fn:regex-group($year-group))" />
            <xsl:variable name="month" select="xs:integer(fn:regex-group($month-group))" />
            <xsl:variable name="day" select="xs:integer(fn:regex-group($day-group))" />
            <xsl:variable name="date-iso" select="concat(fn:format-number($year, '0000'), '-', fn:format-number($month, '00'), '-', fn:format-number($day, '00'))" />
            <xsl:value-of select="$date-iso" />
          </xsl:matching-substring>
          <xsl:non-matching-substring>invalid date</xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:when>
      <xsl:otherwise>missing date</xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- determines whether a date string is a valid dateTime -->
  <xsl:function name="plan-xsl:is-valid-dateTime">
    <xsl:param name="input" />
    <xsl:choose>
      <xsl:when test="string($input) castable as xs:dateTime"><xsl:value-of select="fn:true()" /></xsl:when>
      <xsl:when test="plan-xsl:parse-dateTime($input) castable as xs:dateTime"><xsl:value-of select="fn:true()" /></xsl:when>
      <xsl:otherwise><xsl:value-of select="fn:false()" /></xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- converts a date string into a dateTime -->
  <xsl:function name="plan-xsl:parse-dateTime">
    <xsl:param name="input" />
    <!-- xslt doesn't have any built-in dateTime parsing functions, so it only recognizes yyyy-MM-ddThh:mm:ss.sss format -->
    <!-- define some other formats -->
    <xsl:variable name="yyyyMMddhhmmss">^(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)$</xsl:variable>
    <xsl:variable name="yyyy_dot_MM_dot_dd_space_hh_mm_ss">^(\d\d\d\d)\.(\d\d)\.(\d\d) (\d{1,2}):(\d\d)(:\d\d)?$</xsl:variable>
    <xsl:variable name="yyyy_slash_MM_slash_dd_space_hh_mm_ss">^(\d\d\d\d)/(\d\d)/(\d\d) (\d{1,2}):(\d\d)(:\d\d)?$</xsl:variable>
    <xsl:variable name="M_dash_d_dash_yyyy_space_hh_mm_ss">^(\d{1,2})-(\d{1,2})-(\d\d\d\d) (\d{1,2}):(\d\d)(:\d\d)?$</xsl:variable>
    <xsl:variable name="M_dot_d_dot_yyyy_space_hh_mm_ss">^(\d{1,2})\.(\d{1,2})\.(\d\d\d\d) (\d{1,2}):(\d\d)(:\d\d)?$</xsl:variable>
    <xsl:variable name="M_slash_d_slash_yyyy_space_hh_mm_ss">^(\d{1,2})/(\d{1,2})/(\d\d\d\d) (\d{1,2}):(\d\d)(:\d\d)?$</xsl:variable>
    <xsl:choose>
      <!-- if any of these xsl:when cases are successful, it's a valid dateTime -->
      <xsl:when test="string($input) castable as xs:dateTime">
        <xsl:value-of select="string($input) cast as xs:dateTime" />
      </xsl:when>
      <xsl:when test="plan-xsl:test-dateTime($input, $yyyyMMddhhmmss, 1, 2, 3, 4, 5, 6) castable as xs:dateTime">
        <xsl:value-of select="plan-xsl:test-dateTime($input, $yyyyMMddhhmmss, 1, 2, 3, 4, 5, 6) cast as xs:dateTime" />
      </xsl:when>
      <xsl:when test="plan-xsl:test-dateTime($input, $yyyy_dot_MM_dot_dd_space_hh_mm_ss, 1, 2, 3, 4, 5, 6) castable as xs:dateTime">
        <xsl:value-of select="plan-xsl:test-dateTime($input, $yyyy_dot_MM_dot_dd_space_hh_mm_ss, 1, 2, 3, 4, 5, 6) cast as xs:dateTime" />
      </xsl:when>
      <xsl:when test="plan-xsl:test-dateTime($input, $yyyy_slash_MM_slash_dd_space_hh_mm_ss, 1, 2, 3, 4, 5, 6) castable as xs:dateTime">
        <xsl:value-of select="plan-xsl:test-dateTime($input, $yyyy_slash_MM_slash_dd_space_hh_mm_ss, 1, 2, 3, 4, 5, 6) cast as xs:dateTime" />
      </xsl:when>
      <xsl:when test="plan-xsl:test-dateTime($input, $M_dash_d_dash_yyyy_space_hh_mm_ss, 3, 1, 2, 4, 5, 6) castable as xs:dateTime">
        <xsl:value-of select="plan-xsl:test-dateTime($input, $M_dash_d_dash_yyyy_space_hh_mm_ss, 3, 1, 2, 4, 5, 6) cast as xs:dateTime" />
      </xsl:when>
      <xsl:when test="plan-xsl:test-dateTime($input, $M_dash_d_dash_yyyy_space_hh_mm_ss, 3, 1, 2, 4, 5, 6) castable as xs:dateTime">
        <xsl:value-of select="plan-xsl:test-dateTime($input, $M_dash_d_dash_yyyy_space_hh_mm_ss, 3, 1, 2, 4, 5, 6) cast as xs:dateTime" />
      </xsl:when>
      <xsl:when test="plan-xsl:test-dateTime($input, $M_dot_d_dot_yyyy_space_hh_mm_ss, 3, 1, 2, 4, 5, 6) castable as xs:dateTime">
        <xsl:value-of select="plan-xsl:test-dateTime($input, $M_dot_d_dot_yyyy_space_hh_mm_ss, 3, 1, 2, 4, 5, 6) cast as xs:dateTime" />
      </xsl:when>
      <xsl:when test="plan-xsl:test-dateTime($input, $M_slash_d_slash_yyyy_space_hh_mm_ss, 3, 1, 2, 4, 5, 6) castable as xs:dateTime">
        <xsl:value-of select="plan-xsl:test-dateTime($input, $M_slash_d_slash_yyyy_space_hh_mm_ss, 3, 1, 2, 4, 5, 6) cast as xs:dateTime" />
      </xsl:when>
      <!-- if all xsl:when cases fail, it's not a valid date -->
      <xsl:otherwise>
        <!--<xsl:message><xsl:value-of select="$input" /> not a valid date</xsl:message>-->
        <xsl:value-of select="$input" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- attempts to convert a date-time string into a dateTime suitable for use with xsl -->
  <xsl:function name="plan-xsl:test-dateTime">
    <xsl:param name="input" />
    <xsl:param name="pattern" />
    <xsl:param name="year-group" />
    <xsl:param name="month-group" />
    <xsl:param name="day-group" />
    <xsl:param name="hour-group" />
    <xsl:param name="minute-group" />
    <xsl:param name="second-group" />
    <!--<xsl:message>testing <xsl:value-of select="$input" /> against <xsl:value-of select="$pattern" /></xsl:message>-->
    <xsl:analyze-string select="$input" regex="{$pattern}">
      <xsl:matching-substring>
        <xsl:variable name="year" select="xs:integer(fn:regex-group($year-group))" />
        <xsl:variable name="month" select="xs:integer(fn:regex-group($month-group))" />
        <xsl:variable name="day" select="xs:integer(fn:regex-group($day-group))" />
        <xsl:variable name="hour" select="xs:integer(fn:regex-group($hour-group))" />
        <xsl:variable name="minute" select="xs:integer(fn:regex-group($minute-group))" />
        <xsl:variable name="second">
          <xsl:choose>
            <xsl:when test="fn:string-length(fn:regex-group($second-group)) > 0">
              <xsl:choose>
                <xsl:when test="fn:starts-with(fn:regex-group($second-group), ':')">
                  <xsl:value-of select="xs:integer(fn:substring(fn:regex-group($second-group), 2))" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="xs:integer(fn:regex-group($second-group))" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="xs:integer(0)" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dateTime-iso" select="concat(fn:format-number($year, '0000'), '-', fn:format-number($month, '00'), '-', fn:format-number($day, '00'), 'T', fn:format-number($hour, '00'), ':', fn:format-number($minute, '00'), ':', fn:format-number($second, '00.000'))" />
        <xsl:value-of select="$dateTime-iso" />
      </xsl:matching-substring>
      <xsl:non-matching-substring>invalid dateTime</xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>
  
  <!-- adds to a date. unit can be 'years', 'months', 'days', 'hours', 'minutes', 'seconds' -->
  <xsl:function name="plan-xsl:add-to-date">
    <xsl:param name="date" />
    <xsl:param name="unit" />
    <xsl:param name="value" />
    <xsl:variable name="sign">
      <xsl:choose>
        <xsl:when test="number($value) &lt; 0">-</xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
		<!-- convert the date to XSLT yyyy-MM-dd format -->
		<xsl:variable name="xslt-date" select="xs:date(plan-xsl:parse-date($date))" as="xs:date" />
    <xsl:choose>
      <xsl:when test="$unit = 'years'">
        <!-- yearMonthDuration -->
        <xsl:variable name="durationString"><xsl:value-of select="$sign" />P<xsl:value-of select="fn:abs($value)" />Y</xsl:variable>
        <xsl:value-of select="$xslt-date + xs:yearMonthDuration($durationString)" />
      </xsl:when>
      <xsl:when test="$unit = 'months'">
        <!-- yearMonthDuration -->
        <xsl:variable name="durationString"><xsl:value-of select="$sign" />P<xsl:value-of select="fn:abs($value)" />M</xsl:variable>
        <xsl:value-of select="$xslt-date + xs:yearMonthDuration($durationString)" />
      </xsl:when>
      <xsl:when test="$unit = 'days'">
        <!-- dayTimeDuration -->
        <xsl:variable name="durationString"><xsl:value-of select="$sign" />P<xsl:value-of select="fn:abs($value)" />D</xsl:variable>
        <xsl:value-of select="$xslt-date + xs:dayTimeDuration($durationString)" />
      </xsl:when>
      <xsl:when test="$unit = 'hours'">
        <!-- dayTimeDuration -->
        <xsl:variable name="durationString"><xsl:value-of select="$sign" />PT<xsl:value-of select="fn:abs($value)" />H</xsl:variable>
        <xsl:value-of select="$xslt-date + xs:dayTimeDuration($durationString)" />
      </xsl:when>
      <xsl:when test="$unit = 'minutes'">
        <!-- dayTimeDuration -->
        <xsl:variable name="durationString"><xsl:value-of select="$sign" />PT<xsl:value-of select="fn:abs($value)" />M</xsl:variable>
        <xsl:value-of select="$xslt-date + xs:dayTimeDuration($durationString)" />
      </xsl:when>
      <xsl:when test="$unit = 'seconds'">
        <!-- dayTimeDuration -->
        <xsl:variable name="durationString"><xsl:value-of select="$sign" />PT<xsl:value-of select="fn:abs($value)" />S</xsl:variable>
        <xsl:value-of select="$xslt-date + xs:dayTimeDuration($durationString)" />
      </xsl:when>
    </xsl:choose>
  </xsl:function>
	
</xsl:stylesheet>