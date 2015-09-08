<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<MediaItemList>
			<xsl:for-each select="CatalogType/MediaItemList/MediaItem">
				<MediaItem>
					<Filename>
						<xsl:value-of select="AssetProperties/Filename"/>
					</Filename>
					<Filepath>
						<xsl:variable name="checkString" select="AssetProperties/Filepath"/>
						<xsl:call-template name="replace">
							<!--xsl:with-param name="string" select="substring($checkString, 46, 12)"/-->
							<xsl:with-param name="string" select="$checkString"/>
							<!--xsl:with-param name="pattern" select="'.tif'"/>
						<xsl:with-param name="replacement" select="'.jpg'"/-->
							<xsl:with-param name="pattern" select="'R:\archival2\churn'"/>
							<xsl:with-param name="replacement" select="'\\ryrie.lib.ed.ac.uk\new'"/>
						</xsl:call-template>
					</Filepath>
					<FileSize>
						<xsl:value-of select="AssetProperties/FileSize"/>
					</FileSize>
					<UniqueID>
						<xsl:value-of select="AssetProperties/UniqueID"/>
					</UniqueID>
					<Created>
						<xsl:value-of select="AssetProperties/Created"/>
					</Created>
					<Modified>
						<xsl:value-of select="AssetProperties/Modified"/>
					</Modified>
					<Added>
						<xsl:value-of select="AssetProperties/Added"/>
					</Added>
					<Dimensions>
						<xsl:value-of select="concat(MediaProperties/Width,' x ',MediaProperties/Height)"/>
					</Dimensions>
					<Width>
						<xsl:value-of select="MediaProperties/Width"/>
					</Width>
					<Height>
						<xsl:value-of select="MediaProperties/Height"/>
					</Height>
					<Resolution>
						<xsl:value-of select="MediaProperties/Resolution"/>
					</Resolution>
					<Depth>
						<xsl:value-of select="MediaProperties/Depth"/>
					</Depth>
					<ViewRotation>
						<xsl:value-of select="MediaProperties/ViewRotation"/>
					</ViewRotation>
					<ColorSpace>
						<xsl:value-of select="MediaProperties/SampleColor"/>
					</ColorSpace>
					<Pages>
						<xsl:value-of select="MediaProperties/Pages"/>
					</Pages>
					<Compression>
						<xsl:value-of select="MediaProperties/Compression"/>
					</Compression>
					<Fixture>
						<xsl:value-of select="AnnotationFields/Fixture"/>
					</Fixture>
					<EventDate>
						<xsl:value-of select="AnnotationFields/EventDate"/>
					</EventDate>
					<Author>
						<xsl:value-of select="AnnotationFields/Author"/>
					</Author>
					<CreatorAddress>
						<xsl:value-of select="AnnotationFields/CreatorAddress"/>
					</CreatorAddress>
					<CreatorCity>
						<xsl:value-of select="AnnotationFields/CreatorCity"/>
					</CreatorCity>
					<CreatorPostcode>
						<xsl:value-of select="AnnotationFields/CreatorPostcode"/>
					</CreatorPostcode>
					<CreatorPhone>
						<xsl:value-of select="AnnotationFields/CreatorPhone"/>
					</CreatorPhone>
					<CreatorEmail>
						<xsl:value-of select="AnnotationFields/CreatorEmail"/>
					</CreatorEmail>
					<CreatorURL>
						<xsl:value-of select="AnnotationFields/CreatorURL"/>
					</CreatorURL>
					<Copyright>
						<xsl:value-of select="AnnotationFields/Copyright"/>
					</Copyright>
					<Transmission>
						<xsl:value-of select="AnnotationFields/Transmission"/>
					</Transmission>
					<Location>
						<xsl:value-of select="AnnotationFields/Location"/>
					</Location>
					<Caption>
						<xsl:choose> 
							<xsl:when test="UserFields/UserField_7 = 'University of Edinburgh'">
								<xsl:value-of select="AnnotationFields/Caption"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="pageno" select="UserFields/UserField_6"/>
								<xsl:variable name="title" select="UserFields/UserField_4"/>
								<xsl:value-of select="concat($title, ', ', $pageno)"/>
							</xsl:otherwise>
						</xsl:choose>
					</Caption>
					<Description>
						<xsl:choose> 
							<xsl:when test="UserFields/UserField_7 = 'University of Edinburgh'">
								<xsl:value-of select="AnnotationFields/Description"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="AnnotationFields/Caption"/>
							</xsl:otherwise>
						</xsl:choose>
					</Description>
					<xsl:apply-templates select="AnnotationFields/People"/>
					<xsl:apply-templates select="AnnotationFields/Keyword"/>
					<UserField_1>
						<xsl:value-of select="UserFields/UserField_1"/>
					</UserField_1>
					<UserField_2>
						<xsl:value-of select="UserFields/UserField_2"/>
					</UserField_2>
					<UserField_3>
						<xsl:value-of select="UserFields/UserField_3"/>
					</UserField_3>
					<UserField_4>
						<xsl:value-of select="UserFields/UserField_4"/>
					</UserField_4>
					<UserField_5>
						<xsl:value-of select="UserFields/UserField_5"/>
					</UserField_5>
					<UserField_6>
						<xsl:value-of select="UserFields/UserField_6"/>
					</UserField_6>
					<UserField_7>
						<xsl:value-of select="UserFields/UserField_7"/>
					</UserField_7>
					<UserField_8>
						<xsl:value-of select="UserFields/UserField_8"/>
					</UserField_8>
					<UserField_9>
						<xsl:value-of select="UserFields/UserField_9"/>
					</UserField_9>
					<UserField_10>
						<xsl:value-of select="UserFields/UserField_10"/>
					</UserField_10>
					<UserField_11>
						<xsl:value-of select="UserFields/UserField_11"/>
					</UserField_11>
					<UserField_12>
						<xsl:value-of select="UserFields/UserField_12"/>
					</UserField_12>
					<UserField_13>
						<xsl:value-of select="UserFields/UserField_13"/>
					</UserField_13>
					<UserField_14>
						<xsl:value-of select="UserFields/UserField_14"/>
					</UserField_14>
					<UserField_15>
						<xsl:value-of select="UserFields/UserField_15"/>
					</UserField_15>
					<UserField_16>
						<xsl:value-of select="UserFields/UserField_16"/>
					</UserField_16>
					<Maker>
						<xsl:value-of select="MetaDataFields/Maker"/>
					</Maker>
					<Model>
						<xsl:value-of select="MetaDataFields/Model"/>
					</Model>
					<Software>
						<xsl:value-of select="MetaDataFields/Software"/>
					</Software>
					<SourceURL>
						<xsl:value-of select="MetaDataFields/SourceURL"/>
					</SourceURL>
					<ExifVersion>
						<xsl:value-of select="MetaDataFields/ExifVersion"/>
					</ExifVersion>
					<CaptureDate>
						<xsl:value-of select="MetaDataFields/CaptureDate"/>
					</CaptureDate>
					<ISOSpeedRating>
						<xsl:value-of select="MetaDataFields/ISOSpeedRating"/>
					</ISOSpeedRating>
					<ExposureTime>
						<xsl:value-of select="MetaDataFields/ExposureTime"/>
					</ExposureTime>
					<Aperture>
						<xsl:value-of select="MetaDataFields/Aperture"/>
					</Aperture>
					<LightSource>
						<xsl:value-of select="MetaDataFields/LightSource"/>
					</LightSource>
					<SensingMethod>
						<xsl:value-of select="MetaDataFields/SensingMethod"/>
					</SensingMethod>
				</MediaItem>
			</xsl:for-each>
		</MediaItemList>
	</xsl:template>
	<xsl:template name="replace">
		<xsl:param name="string" select="''"/>
		<xsl:param name="pattern" select="''"/>
		<xsl:param name="replacement" select="''"/>
		<xsl:choose>
			<xsl:when test="$pattern != '' and $string != '' and contains($string, $pattern)">
				<xsl:value-of select="substring-before($string, $pattern)"/>
				<!--
Use "xsl:copy-of" instead of "xsl:value-of" so that users
may substitute nodes as well as strings for $replacement.
-->
				<xsl:copy-of select="$replacement"/>
				<xsl:call-template name="replace">
					<xsl:with-param name="string" select="substring-after($string, $pattern)"/>
					<xsl:with-param name="pattern" select="$pattern"/>
					<xsl:with-param name="replacement" select="$replacement"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="AnnotationFields/People">
		<People>
			<xsl:value-of select="."/>
		</People>
	</xsl:template>
	<xsl:template match="AnnotationFields/Keyword">
		<Keyword>
			<xsl:value-of select="."/>
		</Keyword>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2007. Progress Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="yes" name="ParseiViewXML" userelativepaths="yes" externalpreview="no" url="file:///t:/diu/xmls/Uni7MD.xml" htmlbaseurl="" outputurl="iView.xml" processortype="saxon8" useresolver="yes" profilemode="0" profiledepth="" profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator="" ><advancedProp name="sInitialMode" value=""/><advancedProp name="bXsltOneIsOkay" value="true"/><advancedProp name="bSchemaAware" value="true"/><advancedProp name="bXml11" value="false"/><advancedProp name="iValidation" value="0"/><advancedProp name="bExtensions" value="true"/><advancedProp name="iWhitespace" value="0"/><advancedProp name="sInitialTemplate" value=""/><advancedProp name="bTinyTree" value="true"/><advancedProp name="bWarnings" value="true"/><advancedProp name="bUseDTD" value="false"/><advancedProp name="iErrorHandling" value="fatal"/></scenario></scenarios><MapperMetaTag><MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="iViewVernon.xsd" destSchemaRoot="MediaItemList" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no" ><SourceSchema srcSchemaPath="OrMs20Crop.xml" srcSchemaRoot="CatalogType" AssociatedInstance="" loaderFunction="document" loaderFunctionUsesURI="no"/></MapperInfo><MapperBlockPosition><template match="/"></template></MapperBlockPosition><TemplateContext></TemplateContext><MapperFilter side="source"></MapperFilter></MapperMetaTag>
</metaInformation>
-->