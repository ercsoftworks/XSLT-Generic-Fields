<?xml version="1.0" encoding="utf-8"?>

<!DOCTYPE stylesheet [
<!--<!ENTITY price  "/app:message/app:dataset[@id='webservice.postplan'][last()]/plan:sequence/plan:partner[plan:partner-integration-instance-id = $partner-instance-id]/plan:metadata/plan:price" >-->
]>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl app fn xs plan plan-xsl saxon pr rpt agg-xslt pl ns1 xsi SOAP-ENC SOAP-ENV" xmlns:app="http://www.appliedcognetics.com/Aggregator/2.0/Message"
                xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                                xmlns:saxon="http://saxon.sf.net/"
			    xmlns:pl="http://www.clickofficial.com/schema-namespace/"
				xmlns:ns1="urn:tss" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
				xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
				xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
>

<!--
 
PayDayPays

  <item key="publisher-id">asdfkh8923qhskdjfha0</item>
  <item key="api-token">55405</item>
  

-->
<!---->
  <xsl:output method="xml" indent="no" omit-xml-declaration="yes" />

  <xsl:include href="ERC.WebService.Generic.FieldFunctions.xslt" />
	<xsl:include href="ERC.WebService.Generic.IntegrationInstanceVariables.xslt" />

<xsl:template match="/" mode="plan:body">
	<xsl:variable name="post">
					publisherID=<xsl:value-of select="fn:encode-for-uri($current-instance-parameters/plan:item[@key='publisher-id'])" />&amp;
					apiToken=<xsl:value-of select="fn:encode-for-uri($current-instance-parameters/plan:item[@key='api-token'])" />&amp;
					tierID=<xsl:value-of select="fn:encode-for-uri($current-instance-parameters/plan:item[@key='tier-id'])" />&amp;
					referenceID=<xsl:value-of select="fn:encode-for-uri($ERC-transaction-id)" />&amp;
					clientIP=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='ip'])" />&amp;
					clientURL=http://<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='source-url'])" />&amp;
					amountRequested=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='requested-amount'])" />&amp;
					firstName=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='first-name'])" />&amp;
					lastName=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='last-name'])" />&amp;
					gender=<xsl:choose>
						<xsl:when test="$input-parameters/item[@key='gender'] = 'male'">Male</xsl:when>
						<xsl:when test="$input-parameters/item[@key='gender'] = 'female'">Female</xsl:when>
						<xsl:otherwise>Female</xsl:otherwise>
					</xsl:choose>&amp;
					emailAddress=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='email'])" />&amp;
					homePhone=<xsl:value-of select="fn:encode-for-uri(plan-xsl:minimal-phonenumber($input-parameters/item[@key='home-phone']))" />&amp;	
					cellPhone=<xsl:value-of select="fn:encode-for-uri(plan-xsl:minimal-phonenumber($input-parameters/item[@key='mobile-phone']))" />&amp;	
					homeAddress=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='address'])" />&amp;
					homeCity=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='city'])" />&amp;
					homeState=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='state'])" />&amp;
					homeZip=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='postalcode'])" />&amp;
					homeType=<xsl:choose><xsl:when test="$input-parameters/item[@key='housing-status'] = 'rent'">Rent</xsl:when><xsl:otherwise>Own</xsl:otherwise></xsl:choose>&amp;			
					homeLength=<xsl:value-of select="fn:encode-for-uri(fn:format-date(plan-xsl:calculate-date-ago(0, $input-parameters/item[@key='address-months']), '[Y0001]-[M01]-[D01]'))" />&amp;
					birthDate=<xsl:value-of select="fn:encode-for-uri(fn:format-date(plan-xsl:parse-date($input-parameters/item[@key='date-of-birth']), '[Y0001]-[M01]-[D01]'))" />&amp;
					citizen=T&amp;
					military=<xsl:choose>
						<xsl:when test="fn:lower-case($input-parameters/item[@key='active-military']) = 'true'">T</xsl:when>
						<xsl:when test="fn:lower-case($input-parameters/item[@key='active-military']) = 'false'">F</xsl:when>
						<xsl:otherwise>F</xsl:otherwise>
					</xsl:choose>&amp;
					socialSecurity=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='ssn'])" />&amp;
					stateID=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='driverslicense-number'])" />&amp;		
					bestCallTime=<xsl:choose>
						<xsl:when test="$input-parameters/item[@key='best-contact-time'] = 'morning'">Morning+at+Home</xsl:when>
						<xsl:when test="$input-parameters/item[@key='best-contact-time'] = 'afernoon'">Afternoon+at+Home</xsl:when>
						<xsl:when test="$input-parameters/item[@key='best-contact-time'] = 'evening'">Evening+at+Home</xsl:when>
						<xsl:otherwise>Morning+at+Home</xsl:otherwise>
					</xsl:choose>&amp;
					bankName=<xsl:value-of select="fn:encode-for-uri($lookup-parameters/field[@name='bank-aba']/output/item[@key='name'])" />&amp;
					bankPhone=<xsl:value-of select="fn:encode-for-uri($lookup-parameters/field[@name='bank-aba']/output/item[@key='phone'])" />&amp;
					bankType=<xsl:choose>
								<xsl:when test="fn:lower-case($input-parameters/item[@key='bank-account-type']) = 'checking'">Checking</xsl:when>
								<xsl:when test="fn:lower-case($input-parameters/item[@key='bank-account-type']) = 'savings'">Savings</xsl:when>
								<xsl:otherwise>Checking</xsl:otherwise>
							  </xsl:choose>&amp;					
					bankABA=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='bank-aba'])" />&amp;
					bankAccount=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='bank-account-number'])" />&amp;
					bankLength=<xsl:value-of select="fn:encode-for-uri(fn:format-date(plan-xsl:calculate-date-ago(0, $input-parameters/item[@key='bank-account-months']), '[Y0001]-[M01]-[D01]'))" />&amp;
					employmentStatus=<xsl:choose>
						<!-- employment|unemployment|selfemployed|socialsecurity|disability -->
						<xsl:when test="$input-parameters/item[@key='income-type'] = 'employment'">Employed</xsl:when>
						<xsl:when test="$input-parameters/item[@key='income-type'] = 'selfemployed'">Self+Employed</xsl:when>
						<xsl:when test="$input-parameters/item[@key='income-type'] = 'socialsecurity'">Social+Security</xsl:when>
						<xsl:when test="$input-parameters/item[@key='income-type'] = 'unemployment'">Unemployed</xsl:when>
						<xsl:when test="$input-parameters/item[@key='income-type'] = 'disability'">Disability</xsl:when>
						<xsl:otherwise>Employed</xsl:otherwise>
					</xsl:choose>&amp;
					employerName=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='employer-name'])" />&amp;
					jobTitle=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='occupation'])" />&amp;
					employerPhone=<xsl:value-of select="fn:encode-for-uri(plan-xsl:minimal-phonenumber($input-parameters/item[@key='employer-phone']))" />&amp;
					employerCity=<xsl:value-of select="$lookup-parameters/field[@name='employer-postalcode']/output/item[@key='city']" />&amp;
					employerState=<xsl:value-of select="$lookup-parameters/field[@name='employer-postalcode']/output/item[@key='state']" />&amp;
					employerZip=<xsl:value-of select="$input-parameters/item[@key='employer-postalcode']" />&amp;
					employerLength=<xsl:value-of select="fn:encode-for-uri(fn:format-date(plan-xsl:calculate-date-ago(0, $input-parameters/item[@key='employed-months']), '[Y0001]-[M01]-[D01]'))" />&amp;
					monthlyIncome=<xsl:value-of select="xs:integer($input-parameters/item[@key='monthly-income'])" />&amp;
					payFrequency=<xsl:choose>
								<xsl:when test="$input-parameters/item[@key='pay-period'] = 'weekly'">Weekly</xsl:when>
								<xsl:when test="$input-parameters/item[@key='pay-period'] = 'bi-weekly'">Every+Other+Week</xsl:when>
								<xsl:when test="$input-parameters/item[@key='pay-period'] = 'twice_monthly'">Twice+a+Month</xsl:when>
								<xsl:when test="$input-parameters/item[@key='pay-period'] = 'monthly'">Monthly</xsl:when>
								<xsl:otherwise>Monthly</xsl:otherwise>
							  </xsl:choose>&amp;
					nextPayDate01=<xsl:value-of select="fn:encode-for-uri(fn:format-date(plan-xsl:parse-date($input-parameters/item[@key='next-paydate']), '[Y0001]-[M01]-[D01]'))" />&amp;
					nextPayDate02=<xsl:value-of select="fn:encode-for-uri(fn:format-date(plan-xsl:parse-date($input-parameters/item[@key='second-paydate']), '[Y0001]-[M01]-[D01]'))" />&amp;
					directDeposit=<xsl:choose>
								<xsl:when test="$input-parameters/item[@key='direct-deposit'] = 'true'">T</xsl:when>
								<xsl:when test="$input-parameters/item[@key='direct-deposit'] = 'false'">F</xsl:when>
								<xsl:otherwise>T</xsl:otherwise>
							  </xsl:choose>&amp;
					reference01name=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='reference1-first-name'])" /><![CDATA[ ]]><xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='reference1-last-name'])" />&amp;	
					reference01phone=<xsl:value-of select="fn:encode-for-uri(plan-xsl:minimal-phonenumber($input-parameters/item[@key='reference1-phone']))" />&amp;	
					reference01relationship=<xsl:choose>
													<xsl:when test="$input-parameters/item[@key='reference1-relation'] = 'friend'">Friend</xsl:when>
													<xsl:when test="$input-parameters/item[@key='reference1-relation'] = 'parent'">Friend</xsl:when>
													<xsl:when test="$input-parameters/item[@key='reference1-relation'] = 'sibling'">Friend</xsl:when>
													<xsl:when test="$input-parameters/item[@key='reference1-relation'] = 'relative'">Friend</xsl:when>
													<xsl:when test="$input-parameters/item[@key='reference1-relation'] = 'coworker'">Friend</xsl:when>
													<xsl:otherwise>Other</xsl:otherwise>
												  </xsl:choose>&amp;
					reference02name=<xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='reference2-first-name'])" /><![CDATA[ ]]><xsl:value-of select="fn:encode-for-uri($input-parameters/item[@key='reference2-last-name'])" />&amp;	
					reference02phone=<xsl:value-of select="fn:encode-for-uri(plan-xsl:minimal-phonenumber($input-parameters/item[@key='reference2-phone']))" />&amp;	
					reference02relationship=<xsl:choose>
													<xsl:when test="$input-parameters/item[@key='reference2-relation'] = 'friend'">Friend</xsl:when>
													<xsl:when test="$input-parameters/item[@key='reference2-relation'] = 'parent'">Friend</xsl:when>
													<xsl:when test="$input-parameters/item[@key='reference2-relation'] = 'sibling'">Friend</xsl:when>
													<xsl:when test="$input-parameters/item[@key='reference2-relation'] = 'relative'">Friend</xsl:when>
													<xsl:when test="$input-parameters/item[@key='reference2-relation'] = 'coworker'">Friend</xsl:when>
													<xsl:otherwise>Other</xsl:otherwise>
											</xsl:choose>
						</xsl:variable>
		<xsl:value-of  disable-output-escaping="yes" select="fn:replace($post, '\s', '')" />

  </xsl:template>


<!-- START RESPONSE SECTION -->
<!-- START RESPONSE SECTION -->
<!-- START RESPONSE SECTION -->

<xsl:template match="/" mode="plan:response">
    <xsl:element name="pr:post-response">
      <xsl:choose>
        <xsl:when test="$most-recent-post/response/body[@type='xml']">
          <xsl:apply-templates select="$most-recent-post/response/body[@type='xml']" />
        </xsl:when>
        <xsl:otherwise>
			<xsl:attribute name="accepted">false</xsl:attribute>
			<xsl:attribute name="disposition">NOACK</xsl:attribute>
          <pr:reason>Unexpected response from partner</pr:reason>
          <pr:partner-transaction-id />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="body">
  	<xsl:attribute name="accepted">
      <xsl:choose>
        <xsl:when test="fn:lower-case(response/type) = 'accept'">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
 	<xsl:attribute name="disposition">
      <xsl:choose>
        <xsl:when test="fn:lower-case(response/type) = 'accept'">POSACK</xsl:when>
        <xsl:otherwise>NEGACK</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
		<pr:http-code><xsl:value-of select="$most-recent-http-code" /></pr:http-code>
		<pr:partner-id><xsl:value-of select="$current-partner-id" /></pr:partner-id>
		<pr:partner-integration-id><xsl:value-of select="$current-partner-integration-id" /></pr:partner-integration-id>
		<pr:partner-integration-instance-id><xsl:value-of select="$current-integration-instance-id" /></pr:partner-integration-instance-id>
    <pr:reason>
      <xsl:choose>
			<xsl:when test="fn:lower-case(response/type) = 'accept'">lead accepted</xsl:when>
			<xsl:otherwise>lead rejected</xsl:otherwise>
      </xsl:choose>
    </pr:reason>
    <pr:partner-transaction-id><xsl:value-of select="fn:lower-case(response/id)"/></pr:partner-transaction-id>
    <pr:redirect-url><xsl:value-of select="response/redirectURL"/></pr:redirect-url>
		<pr:price><xsl:value-of select="$current-partner-price"/></pr:price>
  </xsl:template>

<!-- END RESPONSE SECTION -->
<!-- END RESPONSE SECTION -->
<!-- END RESPONSE SECTION -->
<!-- END RESPONSE SECTION -->



	<xsl:template match="/" mode="plan:reporting">
		<rpt:reporting>
				<rpt:destination-queue queue-type="sql" path-type="full">destination-queue-debug</rpt:destination-queue>
				<rpt:destination-queue queue-type="sql" path-type="full">destination-queue-debug2</rpt:destination-queue>
			<rpt:post-response>
				<rpt:application-date><xsl:value-of select="$ERC-transaction-date-utc" /></rpt:application-date>
				<rpt:application-id><xsl:value-of select="$ERC-transaction-id" /></rpt:application-id>
				<rpt:application-url><xsl:value-of select="$ERC-application-url" /></rpt:application-url>
				<rpt:sequence-id>00000000-0000-0000-0000-000000000000</rpt:sequence-id>
				<rpt:service-id><xsl:value-of select="$ERC-service-id" /></rpt:service-id>
				<rpt:post-plan-id><xsl:value-of select="$current-post-plan-id" /></rpt:post-plan-id>
				<rpt:post-plan-name><xsl:value-of select="$current-post-plan-name" /></rpt:post-plan-name>
				<rpt:partner-id><xsl:value-of select="$current-partner-id" /></rpt:partner-id>
				<rpt:partner-name><xsl:value-of select="$current-partner-name" /></rpt:partner-name>				
				<rpt:integration-id><xsl:value-of select="$current-partner-integration-id" /></rpt:integration-id>
				<rpt:integration-name><xsl:value-of select="$current-partner-integration-name" /></rpt:integration-name>
				<rpt:instance-id><xsl:value-of select="$current-integration-instance-id" /></rpt:instance-id>
				<rpt:instance-name><xsl:value-of select="$current-integration-instance-name" /></rpt:instance-name>
				<rpt:owning-partner-id><xsl:value-of select="$service-plan-owner-id" /></rpt:owning-partner-id>
				<rpt:owning-partner-name>owning partner name</rpt:owning-partner-name>
				<rpt:processing-server><xsl:value-of select="agg-xslt:machine-name()" /></rpt:processing-server>
				<rpt:partner-response-time><xsl:value-of select="agg-xslt:timespan-to-milliseconds($most-recent-post-duration)" /></rpt:partner-response-time>
				<rpt:source-hostname><xsl:value-of select="$input-parameters/item[@key='source-url']" /></rpt:source-hostname>
				<rpt:price>
					<xsl:choose>
						<xsl:when test="string-length($most-recent-normalized-result/pr:price) > 0">
							<xsl:value-of select="$most-recent-normalized-result/pr:price" />
						</xsl:when>
						<xsl:otherwise>0.00</xsl:otherwise>
					</xsl:choose>
				</rpt:price>
				<rpt:cost>0.00</rpt:cost>
				<rpt:lead-type>test-cashadvance</rpt:lead-type>
				<rpt:reason><xsl:value-of select="$most-recent-normalized-result/pr:reason" /></rpt:reason>
				<rpt:disposition><xsl:value-of select="$most-recent-normalized-result/@disposition" /></rpt:disposition>
				<rpt:result>
					<xsl:choose>
						<xsl:when test="$most-recent-normalized-result/@accepted = 'true'">accept</xsl:when>
						<xsl:otherwise>reject</xsl:otherwise>
					</xsl:choose>
				</rpt:result>
				<rpt:partner-transaction-id><xsl:value-of select="$most-recent-normalized-result/pr:partner-transaction-id" /></rpt:partner-transaction-id>
				<rpt:redirect-url><xsl:value-of select="$most-recent-normalized-result/pr:redirect-url" /></rpt:redirect-url>
				<rpt:trk-affiliate-id><xsl:value-of select="$input-parameters/item[@key='azq']" /></rpt:trk-affiliate-id>
				<rpt:trk-campaign-id><xsl:value-of select="$input-parameters/item[@key='nzq']" /></rpt:trk-campaign-id>
				<rpt:trk-affiliate-sub-id-1><xsl:value-of select="$input-parameters/item[@key='szq']" /></rpt:trk-affiliate-sub-id-1>
				<rpt:trk-affiliate-sub-id-2><xsl:value-of select="$input-parameters/item[@key='rzq']" /></rpt:trk-affiliate-sub-id-2>
				<rpt:trk-affiliate-sub-id-3><xsl:value-of select="$input-parameters/item[@key='tzq']" /></rpt:trk-affiliate-sub-id-3>
				<rpt:trk-affiliate-sub-id-4><xsl:value-of select="$input-parameters/item[@key='qzq']" /></rpt:trk-affiliate-sub-id-4>
				<rpt:trk-affiliate-sub-id-5><xsl:value-of select="$input-parameters/item[@key='uzq']" /></rpt:trk-affiliate-sub-id-5>
				<rpt:result-url><xsl:value-of select="/app:message/app:dataset[@id='webservice.post.save.blob-uri']/data" /></rpt:result-url>
			</rpt:post-response>
		</rpt:reporting>
	</xsl:template>


  
</xsl:stylesheet>
