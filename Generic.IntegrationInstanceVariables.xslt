<!--
Author: Eric Carestia
ERC Softworks
-->
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl app plan"/>

	<!-- variables used in header, url, body and response transformations -->

	<!-- old versions -->
	<!--<xsl:variable name="current-integration-instance-id" select="/app:message/app:dataset[@id='webservice.post.current.id'][last()]/data" />
	<xsl:variable name="current-partner" select="/app:message/app:dataset[@id='webservice.postplan'][last()]/plan:*/plan:partner[plan:partner-integration-instance-id = $current-integration-instance-id]" />-->

	<!-- transaction values -->
	<xsl:variable name="ERC-transaction-id" select="/app:message/app:dataset[@id='webservice.transaction-id']/transaction-id" />
	<xsl:variable name="ERC-transaction-date-utc" select="/app:message/app:dataset[@id='webservice.timestamp']/webservice-timestamp-utc" />

	<!-- post values -->
	<xsl:variable name="input-parameters" select="/app:message/app:dataset[@id='webservice.input']/parameters" />
	<xsl:variable name="lookup-parameters" select="/app:message/app:dataset[@id='webservice.lookup-validation']/lookup-validation-output" />
	<xsl:variable name="ERC-application-url">
		<xsl:variable name="scheme">
			<xsl:choose>
				<xsl:when test="$input-parameters/item[@key='HTTPS'] = 'on'">https://</xsl:when>
				<xsl:otherwise>http://</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="host" select="$input-parameters/item[@key='HTTP_HOST']" />
		<xsl:variable name="url" select="$input-parameters/item[@key='URL']" />
		<xsl:variable name="query-string">
			<xsl:if test="$input-parameters[@key='QUERY_STRING']">?<xsl:value-of select="$input-parameters[@key='QUERY_STRING']" /></xsl:if>
		</xsl:variable>
		<!-- build the url -->
		<xsl:value-of select="$scheme"/><xsl:value-of select="$host" /><xsl:value-of select="$url" /><xsl:value-of select="$query-string" />
	</xsl:variable>
	<xsl:variable name="ERC-service-id" select="$input-parameters/item[@key='service-id']" />

	<!-- service plan -->
	<xsl:variable name="service-plan-owner-id" select="/app:message/app:dataset[@id = 'webservice.plan']/plan:plan/plan:owner-id" />
	<xsl:variable name="service-plan-owner-name" select="/app:message/app:dataset[@id = 'webservice.plan']/plan:plan/plan:metadata/plan:owner-name" />
	
	<!-- current partner info -->
	<xsl:variable name="current-post-plan-id" select="/app:message/app:dataset[@id='webservice.postplan.metadata'][last()]/plan:metadata/plan:postplan-id" />
	<xsl:variable name="current-post-plan-name" select="/app:message/app:dataset[@id='webservice.postplan.metadata'][last()]/plan:metadata/plan:name" />
	<xsl:variable name="current-partner" select="/app:message/app:dataset[@id='webservice.post.partner.current'][last()]/plan:partner" />
	<xsl:variable name="current-partner-id" select="$current-partner/plan:partner-id" />
	<xsl:variable name="current-partner-name" select="$current-partner/plan:metadata/plan:partner-description" />
	<xsl:variable name="current-partner-integration-id" select="$current-partner/plan:partner-integration-id" />
	<xsl:variable name="current-partner-integration-name" select="$current-partner/plan:metadata/plan:partner-integration-description" />
	<xsl:variable name="current-integration-instance-id" select="$current-partner/plan:partner-integration-instance-id" />
	<xsl:variable name="current-integration-instance-name" select="$current-partner/plan:metadata/plan:partner-integration-instance-description" />
	<xsl:variable name="current-instance-parameters" select="$current-partner/plan:post-info/plan:parameters" />
	<xsl:variable name="current-partner-price" select="$current-partner/plan:metadata/plan:price" />
	<xsl:variable name="current-partner-post-info" select="$current-partner/plan:post-info" />
	<xsl:variable name="previous-transaction-post-response" select="$current-partner/plan:previous-transaction/pr:post-response" />

	<!-- most recent post results -->
	<xsl:variable name="most-recent-post" select="/app:message/app:dataset[@id='webservice.post'][last()]/postresult" />
	<xsl:variable name="most-recent-post-duration">
		<xsl:choose>
			<xsl:when test="$most-recent-post/duration">
				<xsl:value-of select="$most-recent-post/duration" />
			</xsl:when>
			<xsl:otherwise>00:00:00.000</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="most-recent-http-code" select="$most-recent-post/response/status/number" />
	<xsl:variable name="most-recent-post-response-headers" select="$most-recent-post/response/headers" />
	<xsl:variable name="most-recent-post-body" select="/app:message/app:dataset[@id='webservice.post.response-body'][last()]" />
	
	<!-- most recent normalized results -->
	<xsl:variable name="most-recent-normalized-result" select="/app:message/app:dataset[@id='webservice.post.result'][last()]/pr:post-response" />

</xsl:stylesheet>
