<!--
Author: Eric Carestia
ERC Softworks
-->
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl app fn xs plan-xsl plan" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:include href="ERC.WebService.Generic.DateFunctions.xslt" />

  <!-- input: prioritize preprocessed value -->
  <xsl:function name="plan-xsl:get-input-value">
    <xsl:param name="field" />
    <xsl:variable name="key" select="$field/@ERC-name" />
    <xsl:choose>
      <xsl:when test="$field/ancestor::app:message/app:dataset[@id='webservice.preprocess']/parameters/item[@key = $key]">
        <xsl:value-of select="fn:normalize-space($field/ancestor::app:message/app:dataset[@id='webservice.preprocess']/parameters/item[@key = $key][1])" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="fn:normalize-space($field/ancestor::app:message/app:dataset[@id='webservice.incoming']/request/parameters/item[@key = $key][1])" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

	<xsl:function name="plan-xsl:parse-boolean">
		<xsl:param name="input" />
		<xsl:choose>
			<xsl:when test="$input = '1'">true</xsl:when>
			<xsl:when test="lower-case($input) = 'true'">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

  <xsl:function name="plan-xsl:format-field-for-partner">
    <!-- the field specification from the plan -->
    <xsl:param name="field" />
    <!-- the unformatted value -->
    <xsl:param name="rawValue" />
    <!-- format it -->
    <xsl:variable name="test">
      <xsl:choose>
        <xsl:when test="$field/plan:partner-format">
          <xsl:apply-templates select="$field/plan:partner-format">
            <xsl:with-param name="rawValue" select="$rawValue" />
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$rawValue" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!--<xsl:message>[format-field-for-partner returning <xsl:value-of select="$test" />]</xsl:message>-->
    <xsl:value-of select="$test" />
  </xsl:function>

  <xsl:function name="plan-xsl:minimal-phonenumber">
    <xsl:param name="input" />
    <xsl:value-of select="fn:replace($input, '\(|\)|\.|-|\s', '')" />
  </xsl:function>

  <xsl:function name="plan-xsl:calculate-months">
    <xsl:param name="years" />
    <xsl:param name="months" />
    <xsl:choose>
      <xsl:when test="($years castable as xs:integer) and ($months castable as xs:integer)">
        <xsl:value-of select="(xs:integer($years) * 12) + xs:integer($months)" />
      </xsl:when>
      <xsl:when test="$years castable as xs:integer">
        <xsl:value-of select="xs:integer($years) * 12" />
      </xsl:when>
      <xsl:when test="$months castable as xs:integer">
        <xsl:value-of select="xs:integer($months)" />
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xsl:template match="plan:partner-format">
    <xsl:param name="rawValue" />
    <xsl:variable name="test">
      <xsl:choose>
        <xsl:when test="*">
          <xsl:apply-templates select="*" mode="partner-format">
            <xsl:with-param name="rawValue" select="$rawValue" />
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$rawValue" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!--<xsl:message>[partner-format template returning <xsl:value-of select="$test" />]</xsl:message>-->
    <xsl:value-of select="$test" />
  </xsl:template>

  <xsl:template match="plan:uppercase" mode="partner-format">
    <xsl:param name="rawValue" />
    <xsl:value-of select="fn:upper-case($rawValue)" />
  </xsl:template>

  <xsl:template match="plan:lowercase" mode="partner-format">
    <xsl:param name="rawValue" />
    <xsl:value-of select="fn:lower-case($rawValue)" />
  </xsl:template>

  <xsl:template match="plan:date" mode="partner-format">
    <xsl:param name="rawValue" />
    <xsl:variable name="dateValue" select="plan-xsl:parse-date($rawValue)" />
    <!-- make sure the value is a date, just in case -->
    <!--<xsl:message>[dateValue = <xsl:value-of select="$dateValue" />]</xsl:message>-->
    <xsl:variable name="formattedValue">
      <xsl:choose>
        <xsl:when test="string($dateValue) castable as xs:date">
          <xsl:value-of select="fn:format-date($dateValue, .)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$rawValue" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!--<xsl:message>[formattedValue = <xsl:value-of select="$formattedValue" />]</xsl:message>-->
    <xsl:value-of select="$formattedValue" />
  </xsl:template>

  <xsl:template match="plan:datetime" mode="partner-format">
    <xsl:param name="rawValue" />
    <xsl:variable name="dateTimeValue" select="plan-xsl:parse-dateTime($rawValue)" />
    <!-- make sure the value is a date, just in case -->
    <xsl:choose>
      <xsl:when test="string($dateTimeValue) castable as xs:dateTime"><xsl:value-of select="fn:format-dateTime($dateTimeValue, .)" /></xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$rawValue" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="plan:boolean" mode="partner-format">
    <xsl:param name="rawValue" />
    <xsl:value-of select="plan-xsl:format-boolean($rawValue, @true-string, @false-string, $rawValue)" />
  </xsl:template>

  <xsl:function name="plan-xsl:format-boolean">
    <xsl:param name="input" />
    <xsl:param name="true-string" />
    <xsl:param name="false-string" />
    <xsl:param name="default" />
    <xsl:choose>
      <xsl:when test="$input castable as xs:boolean">
        <xsl:variable name="booleanValue" select="xs:boolean($input)" />
        <xsl:choose>
          <xsl:when test="$booleanValue = fn:true()">
            <xsl:value-of select="$true-string" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$false-string" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="fn:lower-case($input) = 'yes' or fn:lower-case($input) = 'y'">
        <xsl:value-of select="$true-string" />
      </xsl:when>
      <xsl:when test="fn:lower-case($input) = 'no' or fn:lower-case($input) = 'n'">
        <xsl:value-of select="$false-string" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$default" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="plan-xsl:calculate-date-ago">
    <xsl:param name="years" />
    <xsl:param name="months" />
    <xsl:variable name="current-date" select="fn:current-date()" />
    <xsl:choose>
      <xsl:when test="($years castable as xs:integer) and ($months castable as xs:integer)">
        <xsl:value-of select="plan-xsl:add-to-date(plan-xsl:add-to-date($current-date, 'years', 0 - xs:integer($years)), 'months', 0 - xs:integer($months))" />
      </xsl:when>
      <xsl:when test="$years castable as xs:integer">
        <xsl:value-of select="plan-xsl:add-to-date($current-date, 'years', 0 - xs:integer($years))" />
      </xsl:when>
      <xsl:when test="$months castable as xs:integer">
        <xsl:value-of select="plan-xsl:add-to-date($current-date, 'months', 0 - xs:integer($months))" />
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$current-date" /></xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- this template should catch any unexpected partner-formats -->
  <xsl:template match="*" mode="partner-format">
    <xsl:param name="rawValue" />
    <xsl:value-of select="$rawValue" />
  </xsl:template>
  
</xsl:stylesheet>