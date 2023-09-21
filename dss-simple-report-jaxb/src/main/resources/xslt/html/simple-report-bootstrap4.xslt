<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dss="http://dss.esig.europa.eu/validation/simple-report">
                
	<xsl:output method="html" encoding="utf-8" indent="yes" omit-xml-declaration="yes" />

	<xsl:param name="rootUrlInTlBrowser">https://eidas.ec.europa.eu/efda/tl-browser/#/screen</xsl:param>
	<xsl:param name="euTLSubDirectoryInTlBrowser">/tl</xsl:param>
	<xsl:param name="tcTLSubDirectoryInTlBrowser">/tc-tl</xsl:param>
	<xsl:param name="trustmarkSubDirectoryInTlBrowser">/trustmark</xsl:param>
	<xsl:param name="euGenericTSLType">http://uri.etsi.org/TrstSvc/TrustedList/TSLType/EUgeneric</xsl:param>

    <xsl:template match="/dss:SimpleReport">
		<xsl:comment>Generated by DSS v.${project.version}</xsl:comment>
	    
		<xsl:apply-templates select="dss:ValidationPolicy"/>
		<xsl:apply-templates select="dss:Signature"/>
		<xsl:apply-templates select="dss:Timestamp"/>
		<xsl:apply-templates select="dss:EvidenceRecord"/>
	    
	    <xsl:call-template name="documentInformation"/>
    </xsl:template>

    <xsl:template match="dss:DocumentName"/>
    <xsl:template match="dss:SignaturesCount"/>
    <xsl:template match="dss:ValidSignaturesCount"/>
    <xsl:template match="dss:ContainerType"/>
	<xsl:template match="dss:PDFAInfo"/>

    <xsl:template match="dss:ValidationPolicy">
		<div>
    		<xsl:attribute name="class">card mb-3</xsl:attribute>
    		<div>
    			<xsl:attribute name="class">card-header bg-primary</xsl:attribute>
	    		<xsl:attribute name="data-target">#collapsePolicy</xsl:attribute>
		       	<xsl:attribute name="data-toggle">collapse</xsl:attribute>
    			Validation Policy : <xsl:value-of select="dss:PolicyName"/>
	        </div>
    		<div>
    			<xsl:attribute name="class">card-body collapse show</xsl:attribute>
	        	<xsl:attribute name="id">collapsePolicy</xsl:attribute>
	        	<xsl:value-of select="dss:PolicyDescription"/>
    		</div>
    	</div>
    </xsl:template>

    <xsl:template match="dss:Signature|dss:Timestamp|dss:EvidenceRecord">
		<xsl:param name="cardStyle" select="'primary'" />
		<xsl:param name="parentId" />

        <xsl:variable name="indicationText" select="dss:Indication/text()"/>

        <xsl:variable name="idToken">
			<xsl:choose>
				<xsl:when test="$parentId"><xsl:value-of select="$parentId" />-<xsl:value-of select="@Id" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="@Id" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

        <xsl:variable name="nodeName" select="name()" />
        <xsl:variable name="indicationCssClass">
        	<xsl:choose>
				<xsl:when test="$indicationText='TOTAL_PASSED'">success</xsl:when>
				<xsl:when test="$indicationText='PASSED'">success</xsl:when>
				<xsl:when test="$indicationText='INDETERMINATE'">warning</xsl:when>
				<xsl:when test="$indicationText='FAILED'">danger</xsl:when>
				<xsl:when test="$indicationText='TOTAL_FAILED'">danger</xsl:when>
			</xsl:choose>
        </xsl:variable>
		<xsl:variable name="copyIdBtnColor">
			<xsl:choose>
				<xsl:when test="$cardStyle='primary'">light</xsl:when>
				<xsl:otherwise>dark</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
        
        <div>
    		<xsl:attribute name="class">card mb-3</xsl:attribute>
    		<div>
    			<xsl:attribute name="class">card-header bg-<xsl:value-of select="$cardStyle" /></xsl:attribute>
	    		<xsl:attribute name="data-target">#collapseSig<xsl:value-of select="$idToken" /></xsl:attribute>
		       	<xsl:attribute name="data-toggle">collapse</xsl:attribute>
		       	
		       	<xsl:if test="@CounterSignature = 'true'">
					<span>
			        	<xsl:attribute name="class">badge badge-info pull-right</xsl:attribute>
						Counter-signature
		        	</span>
				</xsl:if>

				<span>
					<xsl:if test="$nodeName = 'Signature'">
						Signature
					</xsl:if>
					<xsl:if test="$nodeName = 'Timestamp'">
						Timestamp
					</xsl:if>
					<xsl:if test="$nodeName = 'EvidenceRecord'">
						Evidence Record
					</xsl:if>
					<xsl:value-of select="@Id" />
				</span>
				<i>
					<xsl:attribute name="class">id-copy fa fa-clipboard btn btn-outline-light cursor-pointer text-<xsl:value-of select="$copyIdBtnColor"/> border-0 p-2 ml-1 mr-1</xsl:attribute>
					<xsl:attribute name="data-id"><xsl:value-of select="$idToken"/></xsl:attribute>
					<xsl:attribute name="data-toggle">tooltip</xsl:attribute>
					<xsl:attribute name="data-placement">right</xsl:attribute>
					<xsl:attribute name="data-success-text">Id copied successfully!</xsl:attribute>
					<xsl:attribute name="title">Copy Id to clipboard</xsl:attribute>
				</i>
	        </div>
    		<div>
    			<xsl:attribute name="class">card-body collapse show</xsl:attribute>
				<xsl:attribute name="id">collapseSig<xsl:value-of select="$idToken" /></xsl:attribute>
				
				<xsl:if test="dss:Filename">
					<dl>
			    		<xsl:attribute name="class">row mb-0</xsl:attribute>
			    		
						<xsl:if test="$nodeName = 'Signature'">
			            	<dt>
			            		<xsl:attribute name="class">col-sm-3</xsl:attribute>
			            		Signature filename:
			            	</dt>
						</xsl:if>
						<xsl:if test="$nodeName = 'Timestamp'">
			            	<dt>
			            		<xsl:attribute name="class">col-sm-3</xsl:attribute>
			            		Timestamp filename:
			            	</dt>
						</xsl:if>
						<xsl:if test="$nodeName = 'EvidenceRecord'">
							<dt>
								<xsl:attribute name="class">col-sm-3</xsl:attribute>
								Evidence record filename:
							</dt>
						</xsl:if>
			            <dd>
			            	<xsl:attribute name="class">col-sm-9</xsl:attribute>
			            
							<xsl:value-of select="dss:Filename" />
			        	</dd>
			        </dl>
				</xsl:if>
				
				<xsl:if test="dss:SignatureLevel | dss:TimestampLevel">
					<dl>
			    		<xsl:attribute name="class">row mb-0</xsl:attribute>
			            <dt>
			            	<xsl:attribute name="class">col-sm-3</xsl:attribute>
			            	Qualification:
			            </dt>
			            <dd>
			            	<xsl:attribute name="class">col-sm-9</xsl:attribute>
			            
							<xsl:if test="dss:SignatureLevel">
								<xsl:value-of select="dss:SignatureLevel" />
							</xsl:if>
							<xsl:if test="dss:TimestampLevel">
								<xsl:value-of select="dss:TimestampLevel" />
							</xsl:if>
							<i>
				    			<xsl:attribute name="class">fa fa-info-circle text-info ml-2</xsl:attribute>
								<xsl:attribute name="data-toggle">tooltip</xsl:attribute>
								<xsl:attribute name="data-placement">right</xsl:attribute>
								
								<xsl:if test="dss:SignatureLevel">
									<xsl:attribute name="title"><xsl:value-of select="dss:SignatureLevel/@description" /></xsl:attribute>
								</xsl:if>
								<xsl:if test="dss:TimestampLevel">
									<xsl:attribute name="title"><xsl:value-of select="dss:TimestampLevel/@description" /></xsl:attribute>
								</xsl:if>
				    		</i>
				    		
			        	</dd>
			        </dl>
				</xsl:if>

				<xsl:apply-templates select="dss:QualificationDetails" />

				<xsl:if test="@SignatureFormat">
			        <dl>
			    		<xsl:attribute name="class">row mb-0</xsl:attribute>
			            <dt>
			            	<xsl:attribute name="class">col-sm-3</xsl:attribute>
			            	Signature format:
			            </dt>
			            <dd>
			            	<xsl:attribute name="class">col-sm-9</xsl:attribute>
			            
			            	<xsl:value-of select="@SignatureFormat"/>
			            </dd>
			        </dl>
		        </xsl:if>
			
				<dl>
					<xsl:attribute name="class">row mb-0</xsl:attribute>
					<dt>
			        	<xsl:attribute name="class">col-sm-3</xsl:attribute>
			            Indication:
					</dt>
					<dd>
			           	<xsl:attribute name="class">col-sm-9 text-<xsl:value-of select="$indicationCssClass" /></xsl:attribute>

						<xsl:variable name="dssIndication" select="dss:Indication" />
						<xsl:variable name="semanticText" select="//dss:Semantic[contains(@Key,$dssIndication)]"/>
			
						<div>
			           		<xsl:attribute name="class">badge mr-2 badge-<xsl:value-of select="$indicationCssClass" /></xsl:attribute>
			           		
			           		<xsl:if test="string-length($semanticText) &gt; 0">
								<xsl:attribute name="data-toggle">tooltip</xsl:attribute>
								<xsl:attribute name="data-placement">right</xsl:attribute>
								<xsl:attribute name="title"><xsl:value-of select="$semanticText" /></xsl:attribute>
			     			</xsl:if>
			           		
							<xsl:value-of select="$indicationText" />
						</div>

						<xsl:variable name="indication-icon-class">
							<xsl:choose>
								<xsl:when test="$indicationText='TOTAL_PASSED'">fa-check-circle</xsl:when>
								<xsl:when test="$indicationText='PASSED'">fa-check-circle</xsl:when>
								<xsl:when test="$indicationText='INDETERMINATE'">fa-exclamation-circle</xsl:when>
								<xsl:when test="$indicationText='FAILED'">fa-times-circle</xsl:when>
								<xsl:when test="$indicationText='TOTAL_FAILED'">fa-times-circle</xsl:when>
							</xsl:choose>
						</xsl:variable>

						<i>
							<xsl:attribute name="class">fa <xsl:value-of select="$indication-icon-class" /> align-middle</xsl:attribute>
							<xsl:attribute name="data-toggle">tooltip</xsl:attribute>
							<xsl:attribute name="data-placement">right</xsl:attribute>
							<xsl:choose>
								<xsl:when test="string-length($semanticText) &gt; 0">
									<xsl:attribute name="title"><xsl:value-of select="$semanticText" /></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="title"><xsl:value-of select="$indicationText" /></xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>

						</i>
					</dd>
				</dl>   
		        
		        <xsl:apply-templates select="dss:SubIndication">
		            <xsl:with-param name="indicationClass" select="$indicationCssClass"/>
		        </xsl:apply-templates>

				<xsl:apply-templates select="dss:AdESValidationDetails" />

				<xsl:if test="dss:CertificateChain">
					<dl>
						<xsl:attribute name="class">row mb-0</xsl:attribute>
						<dt>
							<xsl:attribute name="class">col-sm-3</xsl:attribute>
							Certificate Chain:
						</dt>
						<xsl:choose>
							<xsl:when test="dss:CertificateChain/dss:Certificate">
								<dd>
									<xsl:attribute name="class">col-sm-9</xsl:attribute>

									<ul>
										<xsl:attribute name="class">list-unstyled mb-0</xsl:attribute>

										<xsl:for-each select="dss:CertificateChain/dss:Certificate">
											<xsl:variable name="index" select="position()"/>

											<li>
												<xsl:if test="not(@trusted = 'true' or following-sibling::dss:Certificate[@trusted = 'true'])">
													<xsl:attribute name="class">text-black-50</xsl:attribute>
												</xsl:if>

												<i>
													<xsl:attribute name="class">fa fa-link mr-2</xsl:attribute>
													<xsl:attribute name="data-toggle">tooltip</xsl:attribute>
													<xsl:attribute name="data-placement">left</xsl:attribute>
													<xsl:attribute name="title">Chain item</xsl:attribute>
												</i>
												<span>
													<xsl:choose>
														<xsl:when test="$index = 1">
															<b><xsl:value-of select="dss:QualifiedName" /></b>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="dss:QualifiedName" />
														</xsl:otherwise>
													</xsl:choose>
												</span>
												<xsl:if test="@trusted = 'true' and not(dss:TrustAnchors)">
													<i>
														<xsl:attribute name="class">fa fa-certificate ml-2</xsl:attribute>
														<xsl:attribute name="data-toggle">tooltip</xsl:attribute>
														<xsl:attribute name="data-placement">right</xsl:attribute>
														<xsl:attribute name="title">Trust anchor</xsl:attribute>
													</i>
												</xsl:if>
												<xsl:apply-templates select="dss:TrustAnchors"/>

											</li>
										</xsl:for-each>
									</ul>
								</dd>
							</xsl:when>
							<xsl:otherwise>
								<dd>
									<xsl:attribute name="class">col-sm-9</xsl:attribute>

									/
								</dd>
							</xsl:otherwise>
						</xsl:choose>
					</dl>
				</xsl:if>
		        
				<xsl:if test="dss:SigningTime">
			        <dl>
			    		<xsl:attribute name="class">row mb-0</xsl:attribute>
			            <dt>
			        		<xsl:attribute name="class">col-sm-3</xsl:attribute>
			        		On claimed time:
			        	</dt>
			            <dd>
			            	<xsl:attribute name="class">col-sm-9</xsl:attribute>

							<xsl:call-template name="formatdate">
								<xsl:with-param name="DateTimeStr" select="dss:SigningTime"/>
							</xsl:call-template>
			            </dd>
			        </dl>
		        </xsl:if>
		        
				<xsl:if test="dss:BestSignatureTime">
			        <dl>
			    		<xsl:attribute name="class">row mb-0</xsl:attribute>
			            <dt>
			            	<xsl:attribute name="class">col-sm-3</xsl:attribute>
			            	Best signature time:
			            </dt>
			            <dd>
			            	<xsl:attribute name="class">col-sm-9</xsl:attribute>

							<xsl:call-template name="formatdate">
								<xsl:with-param name="DateTimeStr" select="dss:BestSignatureTime"/>
							</xsl:call-template>

			            	<i>
				    			<xsl:attribute name="class">fa fa-info-circle text-info ml-2</xsl:attribute>
								<xsl:attribute name="data-toggle">tooltip</xsl:attribute>
								<xsl:attribute name="data-placement">right</xsl:attribute>
								<xsl:attribute name="title">Lowest time at which there exists a proof of existence for the signature</xsl:attribute>
				    		</i>		
			            </dd>
			        </dl>
		        </xsl:if>

				<xsl:if test="dss:ProductionTime">
					<dl>
						<xsl:attribute name="class">row mb-0</xsl:attribute>
						<dt>
							<xsl:attribute name="class">col-sm-3</xsl:attribute>
							Production time:
						</dt>
						<dd>
							<xsl:attribute name="class">col-sm-9</xsl:attribute>

							<xsl:call-template name="formatdate">
								<xsl:with-param name="DateTimeStr" select="dss:ProductionTime"/>
							</xsl:call-template>
						</dd>
					</dl>
				</xsl:if>

				<xsl:if test="dss:POETime">
					<dl>
						<xsl:attribute name="class">row mb-0</xsl:attribute>
						<dt>
							<xsl:attribute name="class">col-sm-3</xsl:attribute>
							POE time:
						</dt>
						<dd>
							<xsl:attribute name="class">col-sm-9</xsl:attribute>

							<xsl:call-template name="formatdate">
								<xsl:with-param name="DateTimeStr" select="dss:POETime"/>
							</xsl:call-template>
						</dd>
					</dl>
				</xsl:if>
		        
				<xsl:if test="$nodeName = 'Signature'">
			        <dl>
			    		<xsl:attribute name="class">row mb-0</xsl:attribute>
			            <dt>
			        		<xsl:attribute name="class">col-sm-3</xsl:attribute>
			        		Signature position:
			        	</dt>
			            <dd>
			            	<xsl:attribute name="class">col-sm-9</xsl:attribute>
			            	
			            	<xsl:value-of select="count(preceding-sibling::dss:Signature) + 1"/> out of <xsl:value-of select="count(ancestor::*/dss:Signature)"/>
			            </dd>
			        </dl>
				</xsl:if>

				<xsl:apply-templates select="dss:SignatureScope" />
				<xsl:apply-templates select="dss:TimestampScope" />
				<xsl:apply-templates select="dss:EvidenceRecordScope" />

				<xsl:if test="dss:Timestamps">
					<div>
						<xsl:attribute name="class">card mt-3</xsl:attribute>
						<div>
							<xsl:attribute name="class">card-header bg-primary collapsed</xsl:attribute>
							<xsl:attribute name="data-target">#collapseSigTimestamps<xsl:value-of select="$idToken" /></xsl:attribute>
							<xsl:attribute name="data-toggle">collapse</xsl:attribute>
							<xsl:attribute name="aria-expanded">false</xsl:attribute>

							Timestamps <span class="badge badge-light"><xsl:value-of select="count(dss:Timestamps/dss:Timestamp)" /></span>
						</div>
						<div>
							<xsl:attribute name="class">card-body collapse pb-1</xsl:attribute>
							<xsl:attribute name="id">collapseSigTimestamps<xsl:value-of select="$idToken" /></xsl:attribute>
							<xsl:apply-templates select="dss:Timestamps">
								<xsl:with-param name="parentId" select="$idToken"/>
							</xsl:apply-templates>
						</div>
					</div>
				</xsl:if>

				<xsl:if test="dss:EvidenceRecords">
					<div>
						<xsl:attribute name="class">card mt-3</xsl:attribute>
						<div>
							<xsl:attribute name="class">card-header bg-primary collapsed</xsl:attribute>
							<xsl:attribute name="data-target">#collapseSigEvidenceRecords<xsl:value-of select="$idToken" /></xsl:attribute>
							<xsl:attribute name="data-toggle">collapse</xsl:attribute>
							<xsl:attribute name="aria-expanded">false</xsl:attribute>

							Evidence records <span class="badge badge-light"><xsl:value-of select="count(dss:EvidenceRecords/dss:EvidenceRecord)" /></span>
						</div>
						<div>
							<xsl:attribute name="class">card-body collapse pb-1</xsl:attribute>
							<xsl:attribute name="id">collapseSigEvidenceRecords<xsl:value-of select="$idToken" /></xsl:attribute>
							<xsl:apply-templates select="dss:EvidenceRecords">
								<xsl:with-param name="parentId" select="$idToken"/>
							</xsl:apply-templates>
						</div>
					</div>
				</xsl:if>

    		</div>
    	</div>
    </xsl:template>

	<xsl:template match="dss:SignatureScope|dss:TimestampScope|dss:EvidenceRecordScope">
		<xsl:variable name="header">
			<xsl:choose>
				<xsl:when test="name() = 'SignatureScope'">Signature scope</xsl:when>
				<xsl:when test="name() = 'TimestampScope'">Timestamp scope</xsl:when>
				<xsl:when test="name() = 'EvidenceRecordScope'">Evidence Record scope</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<dl>
			<xsl:attribute name="class">row mb-0</xsl:attribute>
			<dt>
				<xsl:attribute name="class">col-sm-3</xsl:attribute>
				<xsl:value-of select="$header" />:
			</dt>
			<dd>
				<xsl:attribute name="class">col-sm-9</xsl:attribute>

				<xsl:value-of select="@name"/> (<xsl:value-of select="@scope"/>)<br />
				<xsl:value-of select="."/>
			</dd>
		</dl>
	</xsl:template>

	<xsl:template match="dss:TrustAnchors">
		<xsl:apply-templates select="dss:TrustAnchor"/>
	</xsl:template>

	<xsl:template match="dss:TrustAnchor">
		<xsl:variable name="subDirectory">
			<xsl:choose>
				<xsl:when test="dss:TSLType and $euGenericTSLType = dss:TSLType"><xsl:value-of select="$euTLSubDirectoryInTlBrowser" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="$tcTLSubDirectoryInTlBrowser" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="countryTlUrl" select="concat($rootUrlInTlBrowser, $subDirectory, '/', @countryCode)" />
		<xsl:variable name="countryTspUrl" select="concat($rootUrlInTlBrowser, $subDirectory,
				$trustmarkSubDirectoryInTlBrowser, '/', @countryCode, '/', dss:TrustServiceProviderRegistrationId)" />

		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="$countryTlUrl" />
			</xsl:attribute>
			<xsl:attribute name="class">align-middle</xsl:attribute>
			<xsl:attribute name="target">_blank</xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="@countryCode" /></xsl:attribute>
			<xsl:attribute name="style">line-height: 1.2</xsl:attribute>
			<span>
				<xsl:attribute name="class"><xsl:value-of select="concat('small_flag_sig ml-2 flag_', @countryCode)" /></xsl:attribute>
			</span>
		</a>
		<i>
			<xsl:attribute name="class">fa fa-arrow-circle-right ml-2 mr-2</xsl:attribute>
		</i>
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="$countryTspUrl" />
			</xsl:attribute>
			<xsl:attribute name="target">_blank</xsl:attribute>
			<xsl:attribute name="title">View in TL Browser</xsl:attribute>

			<xsl:value-of select="dss:TrustServiceProvider" />
		</a>
		<i>
			<xsl:attribute name="class">fa fa-info-circle text-info ml-2 mr-2</xsl:attribute>
			<xsl:attribute name="data-toggle">tooltip</xsl:attribute>
			<xsl:attribute name="data-placement">bottom</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:for-each select="dss:TrustServiceName">
					<xsl:value-of select="." />
					<xsl:if test="position() &lt; last()">
						<xsl:text>&#xa;</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:attribute>
		</i>

	</xsl:template>

	<xsl:template match="dss:AdESValidationDetails|dss:QualificationDetails">
		<xsl:variable name="header">
			<xsl:choose>
				<xsl:when test="name() = 'AdESValidationDetails'">AdES Validation Details</xsl:when>
				<xsl:when test="name() = 'QualificationDetails'">Qualification Details</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<dl>
			<xsl:attribute name="class">row mb-0</xsl:attribute>
			<dt>
				<xsl:attribute name="class">col-sm-3</xsl:attribute>
				<xsl:value-of select="$header" />:
			</dt>
			<dd>
				<xsl:attribute name="class">col-sm-9</xsl:attribute>
				<ul>
					<xsl:attribute name="class">list-unstyled mb-0</xsl:attribute>
					<xsl:apply-templates select="dss:Error" />
					<xsl:apply-templates select="dss:Warning" />
					<xsl:apply-templates select="dss:Info" />
				</ul>
			</dd>
		</dl>
	</xsl:template>

	<xsl:template match="dss:Error|dss:Warning|dss:Info">
		<xsl:variable name="style">
			<xsl:choose>
				<xsl:when test="name() = 'Error'">danger</xsl:when>
				<xsl:when test="name() = 'Warning'">warning</xsl:when>
				<xsl:otherwise>auto</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<li>
			<xsl:attribute name="class">text-<xsl:value-of select="$style" /></xsl:attribute>
			<xsl:value-of select="." />
		</li>
	</xsl:template>

	<xsl:template match="dss:Timestamps">
		<xsl:param name="parentId" />
		<div>
			<xsl:apply-templates select="dss:Timestamp">
				<xsl:with-param name="cardStyle" select="'light'"/>
				<xsl:with-param name="parentId" select="$parentId"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template match="dss:EvidenceRecords">
		<xsl:param name="parentId" />
		<div>
			<xsl:apply-templates select="dss:EvidenceRecord">
				<xsl:with-param name="cardStyle" select="'light'"/>
				<xsl:with-param name="parentId" select="$parentId"/>
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template match="dss:SubIndication">
		<xsl:param name="indicationClass" />
		
		<xsl:variable name="subIndicationText" select="." />
		<xsl:variable name="semanticText" select="//dss:Semantic[contains(@Key,$subIndicationText)]"/>
				
		<dl>
    		<xsl:attribute name="class">row mb-0</xsl:attribute>
			<dt>
				<xsl:attribute name="class">col-sm-3</xsl:attribute>
				Sub indication:
			</dt>
			<dd>
				<xsl:attribute name="class">col-sm-9</xsl:attribute>
				<div>
					<xsl:attribute name="class">badge badge-<xsl:value-of select="$indicationClass" /></xsl:attribute>

					<xsl:if test="string-length($semanticText) &gt; 0">
						<xsl:attribute name="data-toggle">tooltip</xsl:attribute>
						<xsl:attribute name="data-placement">right</xsl:attribute>
						<xsl:attribute name="title"><xsl:value-of select="$semanticText" /></xsl:attribute>
	     			</xsl:if>
	     			
					<xsl:value-of select="$subIndicationText" />
				</div>
			</dd>
		</dl>
	</xsl:template>

    <xsl:template name="documentInformation">
		<div>
    		<xsl:attribute name="class">card</xsl:attribute>
    		<div>
    			<xsl:attribute name="class">card-header bg-primary</xsl:attribute>
	    		<xsl:attribute name="data-target">#collapseInfo</xsl:attribute>
		       	<xsl:attribute name="data-toggle">collapse</xsl:attribute>
    			Document Information
	        </div>
    		<div>
    			<xsl:attribute name="class">card-body collapse show</xsl:attribute>
	        	<xsl:attribute name="id">collapseInfo</xsl:attribute>
	        	
				<xsl:if test="dss:ContainerType">
			        <dl>
			    		<xsl:attribute name="class">row mb-0</xsl:attribute>
			            <dt>
			        		<xsl:attribute name="class">col-sm-3</xsl:attribute>
			        		Container type:
			        	</dt>
			            <dd>
							<xsl:attribute name="class">col-sm-9</xsl:attribute>
							
							<xsl:value-of select="dss:ContainerType"/>
						</dd>
			        </dl>
		        </xsl:if>

				<xsl:if test="dss:PDFAInfo">
					<dl>
						<xsl:attribute name="class">row mb-0</xsl:attribute>
						<dt>
							<xsl:attribute name="class">col-sm-3</xsl:attribute>
							PDF/A Profile:
						</dt>
						<dd>
							<xsl:attribute name="class">col-sm-9</xsl:attribute>

							<span>
								<xsl:attribute name="class">mr-2</xsl:attribute>
								<xsl:value-of select="dss:PDFAInfo/dss:PDFAProfile"/>
							</span>

							<i>
								<xsl:choose>
									<xsl:when test="dss:PDFAInfo/@valid='true'">
										<xsl:attribute name="class">fa fa-check-circle text-success</xsl:attribute>
										<xsl:attribute name="data-toggle">tooltip</xsl:attribute>
										<xsl:attribute name="data-placement">right</xsl:attribute>
										<xsl:attribute name="title">Valid</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="class">fa fa-times-circle text-danger</xsl:attribute>
										<xsl:attribute name="data-toggle">tooltip</xsl:attribute>
										<xsl:attribute name="data-placement">right</xsl:attribute>
										<xsl:if test="dss:PDFAInfo/dss:ValidationMessages">
											<xsl:attribute name="title">
												<xsl:for-each select="dss:PDFAInfo/dss:ValidationMessages/dss:Error">
													<xsl:value-of select="concat(text(),';','&#10;')" />
												</xsl:for-each>
											</xsl:attribute>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</i>
						</dd>
					</dl>
				</xsl:if>
				
	        	<dl>
		    		<xsl:attribute name="class">row mb-0</xsl:attribute>
		            <dt>
			        	<xsl:attribute name="class">col-sm-3</xsl:attribute>
			        	Signatures status:
			        </dt>
		            <dd>
		                <xsl:choose>
		                    <xsl:when test="dss:ValidSignaturesCount = dss:SignaturesCount">
		                        <xsl:attribute name="class">col-sm-9 text-success</xsl:attribute>
		                    </xsl:when>
		                    <xsl:otherwise>
		                        <xsl:attribute name="class">col-sm-9 text-warning</xsl:attribute>
		                    </xsl:otherwise>
		                </xsl:choose>
		                <xsl:value-of select="dss:ValidSignaturesCount"/> valid signatures, out of <xsl:value-of select="dss:SignaturesCount"/>
		            </dd>
		        </dl>
		        <dl>
		    		<xsl:attribute name="class">row mb-0</xsl:attribute>
		            <dt>
			        	<xsl:attribute name="class">col-sm-3</xsl:attribute>
			        	Document name:
			        </dt>
		            <dd>
						<xsl:attribute name="class">col-sm-9</xsl:attribute>
						
						<xsl:value-of select="dss:DocumentName"/>
					</dd>
		        </dl>
		        
    		</div>
    	</div>
    </xsl:template>

	<xsl:template name="formatdate">
		<xsl:param name="DateTimeStr" />

		<xsl:variable name="date">
			<xsl:value-of select="substring-before($DateTimeStr,'T')" />
		</xsl:variable>

		<xsl:variable name="after-T">
			<xsl:value-of select="substring-after($DateTimeStr,'T')" />
		</xsl:variable>

		<xsl:variable name="time">
			<xsl:value-of select="substring-before($after-T,'Z')" />
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="string-length($date) &gt; 0 and string-length($time) &gt; 0">
				<xsl:value-of select="concat($date,' ', $time, ' (UTC)')" />
			</xsl:when>
			<xsl:when test="string-length($date) &gt; 0">
				<xsl:value-of select="$date" />
			</xsl:when>
			<xsl:when test="string-length($time) &gt; 0">
				<xsl:value-of select="$time" />
			</xsl:when>
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
