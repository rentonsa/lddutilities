<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:a="http://www.lunaimaging.com/xsd">
	<xsl:template match="/">
		<recordList xmlns="http://www.lunaimaging.com/xsd">
			<xsl:for-each select="vernon/av">
				<record type="MIMSWorkflow">

					<!--Field Group: Work Record ID-->
					<field type="Work Record ID">
							<xsl:variable name="reprostring" select="object/user_sym_37"/>
							<xsl:value-of select='substring($reprostring,1,7)'/>
					</field>

					<!--Field Group: Work ID Number-->
					<xsl:variable name="nullstring" select="object/accession_no"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="ID Number1">
							<field type="ID Number">
								<xsl:value-of select="object/accession_no"/>
							</field>
							<xsl:variable name="nullstring" select="object/accession_date"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="ID Date">
									<xsl:value-of select="object/accession_date"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/user_sym_17"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Shelfmark">
									<xsl:value-of select="object/user_sym_17"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/controlling_institution"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Holding Institution">
									<xsl:value-of select="object/controlling_institution"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/user_sym_18"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Catalogue Number">
									<xsl:value-of select="object/user_sym_18"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/user_sym_19"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Old ID">
									<xsl:value-of select="object/user_sym_19"/>
								</field>
							</xsl:if>
							<!--<xsl:variable name="nullstring" select="object/otherid1"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Alternate ID">
									<xsl:value-of select="object/otherid1"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/otheridtype1"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Alternate ID Type">
									<xsl:value-of select="object/otheridtype1"/>
								</field>
							</xsl:if>-->
							<xsl:variable name="nullstring" select="object/cataloguer"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Cataloguer">
									<xsl:value-of select="object/cataloguer"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Title-->
					<xsl:variable name="nullstring" select="object/name"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Title">
							<field type="Title">
								<xsl:value-of select="object/name"/>
							</field>
							<xsl:variable name="nullstring" select="object/name_notes"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Title Notes">
									<xsl:value-of select="object/name_notes"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/user_sym_23"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Alternate Title">
									<xsl:value-of select="object/user_sym_23"/>
								</field>
							</xsl:if>
							<!--							<xsl:variable name="nullstring" select="object/other_name_type"/>
							<xsl:if test="normalize-space($nullstring)">
									<field type="Title Type">
										<xsl:value-of select="object/other_name_type"/>
									</field>
							</xsl:if>-->
							<xsl:variable name="nullstring" select="object/user_sym_20"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Translated Title">
									<xsl:value-of select="object/user_sym_20"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/user_sym_21"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Variant Title">
									<xsl:value-of select="object/user_sym_21"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/user_sym_22"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Untranslated Title">
									<xsl:value-of select="object/user_sym_22"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/user_text_5"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Imprint">
									<xsl:value-of select="object/user_text_5"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<xsl:variable name="nullstring" select="object/subset"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Subset">
							<xsl:variable name="nullstring" select="object/subset"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Subset">
									<xsl:value-of select="object/subset"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/subsetpage"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Subset Index">
									<xsl:value-of select="object/subsetpage"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Creator-->
					<xsl:variable name="nullstring" select="object/personname1"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Creator1">
							<field type="Creator">
								<xsl:variable name="lifeyears" select="object/dates1"/>
								<xsl:variable name="activedates" select="object/activedates1"/>
								<xsl:if test="normalize-space($lifeyears)">
									<xsl:value-of select="concat ($nullstring, ' (', $lifeyears,')')"/>
								</xsl:if>
								<xsl:if test="not(normalize-space($lifeyears))">
									<xsl:value-of select="$nullstring"/>
								</xsl:if>
							</field>

							<xsl:variable name="nullstring" select="object/personname1"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Name">
									<xsl:value-of select="object/personname1"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/dates1"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Dates">
									<xsl:value-of select="object/dates1"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/nationality1"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Nationality">
									<xsl:value-of select="object/nationality1"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/role1"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Role">
									<xsl:value-of select="object/role1"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/activedates1"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Active Dates">
									<xsl:value-of select="object/activedates1"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/summarycreator1"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Summary Creator">
									<xsl:value-of select="object/summarycreator1"/>
								</field>
							</xsl:if>
							<!--THIS IS TEMPORARY AND JUST SERVES SOME LEGACY COLLECTIONS-->
							<!--							<xsl:variable name="nullstring" select="object/prod_pri_person_notes"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Notes">
									<xsl:value-of select="object/prod_pri_person_notes"/>
								</field>
							</xsl:if>-->

							<!--					On the template, but we probably won't use this. If we ever do, we will it in here.

							<xsl:variable name="nullstring" select="assoc_person"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associated Person">
									<xsl:value-of select="assoc_person"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="reattribution_person"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Attributed By">
									<xsl:value-of select="reattribution_person"/>
								</field>
							</xsl:if>-->
							<xsl:variable name="nullstring" select="object/prod_notes"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Production Notes">
									<xsl:value-of select="object/prod_notes"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Creator2-->
					<xsl:variable name="nullstring" select="object/personname2"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Creator2">
							<field type="Creator">
								<xsl:variable name="lifeyears" select="object/dates2"/>
								<xsl:variable name="activedates" select="object/activedates2"/>
								<xsl:if test="normalize-space($lifeyears)">
									<xsl:value-of select="concat ($nullstring, ' (', $lifeyears,')')"/>
								</xsl:if>
								<xsl:if test="not(normalize-space($lifeyears))">
									<xsl:value-of select="$nullstring"/>
								</xsl:if>
							</field>

							<xsl:variable name="nullstring" select="object/personname2"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Name">
									<xsl:value-of select="object/personname2"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/dates2"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Dates">
									<xsl:value-of select="object/dates2"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/nationality2"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Nationality">
									<xsl:value-of select="object/nationality2"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/role2"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Role">
									<xsl:value-of select="object/role2"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/activedates2"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Active Dates">
									<xsl:value-of select="object/activedates2"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/summarycreator2"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Summary Creator">
									<xsl:value-of select="object/summarycreator2"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Creator3-->
					<xsl:variable name="nullstring" select="object/personname3"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Creator3">
							<field type="Creator">
								<xsl:variable name="lifeyears" select="object/dates3"/>
								<xsl:variable name="activedates" select="object/activedates3"/>
								<xsl:if test="normalize-space($lifeyears)">
									<xsl:value-of select="concat ($nullstring, ' (', $lifeyears,')')"/>
								</xsl:if>
								<xsl:if test="not(normalize-space($lifeyears))">
									<xsl:value-of select="$nullstring"/>
								</xsl:if>
							</field>


							<xsl:variable name="nullstring" select="object/personname3"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Name">
									<xsl:value-of select="object/personname3"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/dates3"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Dates">
									<xsl:value-of select="object/dates3"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/nationality3"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Nationality">
									<xsl:value-of select="object/nationality3"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/role3"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Role">
									<xsl:value-of select="object/role3"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/activedates3"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Active Dates">
									<xsl:value-of select="object/activedates3"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/summarycreator3"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Summary Creator">
									<xsl:value-of select="object/summarycreator3"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Creator4-->
					<xsl:variable name="nullstring" select="object/personname4"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Creator4">
							<field type="Creator">
								<xsl:variable name="lifeyears" select="object/dates4"/>
								<xsl:variable name="activedates" select="object/activedates4"/>
								<xsl:if test="normalize-space($lifeyears)">
									<xsl:value-of select="concat ($nullstring, ' (', $lifeyears,')')"/>
								</xsl:if>
								<xsl:if test="not(normalize-space($lifeyears))">
									<xsl:value-of select="$nullstring"/>
								</xsl:if>
							</field>

							<xsl:variable name="nullstring" select="object/personname4"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Name">
									<xsl:value-of select="object/personname4"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/dates4"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Dates">
									<xsl:value-of select="object/dates4"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/nationality4"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Nationality">
									<xsl:value-of select="object/nationality4"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/role4"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Role">
									<xsl:value-of select="object/role4"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/activedates4"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Active Dates">
									<xsl:value-of select="object/activedates4"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/summarycreator4"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Summary Creator">
									<xsl:value-of select="object/summarycreator4"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Creator3-->
					<xsl:variable name="nullstring" select="object/personname5"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Creator5">
							<field type="Creator">
								<xsl:variable name="lifeyears" select="object/dates5"/>
								<xsl:variable name="activedates" select="object/activedates5"/>
								<xsl:if test="normalize-space($lifeyears)">
									<xsl:value-of select="concat ($nullstring, ' (', $lifeyears,')')"/>
								</xsl:if>
								<xsl:if test="not(normalize-space($lifeyears))">
									<xsl:value-of select="$nullstring"/>
								</xsl:if>
							</field>

							<xsl:variable name="nullstring" select="object/personname5"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Name">
									<xsl:value-of select="object/personname5"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/dates5"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Dates">
									<xsl:value-of select="object/dates5"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/nationality5"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Nationality">
									<xsl:value-of select="object/nationality5"/>
								</field>
							</xsl:if>


							<xsl:variable name="nullstring" select="object/role5"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Role">
									<xsl:value-of select="object/role5"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/activedates5"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Active Dates">
									<xsl:value-of select="object/activedates5"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/summarycreator5"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Summary Creator">
									<xsl:value-of select="object/summarycreator5"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Creator3-->
					<xsl:variable name="nullstring" select="object/personname6"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Creator6">
							<field type="Creator">
								<xsl:variable name="lifeyears" select="object/dates6"/>
								<xsl:variable name="activedates" select="object/activedates6"/>
								<xsl:if test="normalize-space($lifeyears)">
									<xsl:value-of select="concat ($nullstring, ' (', $lifeyears,')')"/>
								</xsl:if>
								<xsl:if test="not(normalize-space($lifeyears))">
									<xsl:value-of select="$nullstring"/>
								</xsl:if>
							</field>

							<xsl:variable name="nullstring" select="object/personname6"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Name">
									<xsl:value-of select="object/personname6"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/dates6"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Dates">
									<xsl:value-of select="object/dates6"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/nationality6"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Nationality">
									<xsl:value-of select="object/nationality6"/>
								</field>
							</xsl:if>


							<xsl:variable name="nullstring" select="object/role6"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Role">
									<xsl:value-of select="object/role6"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/activedates6"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Active Dates">
									<xsl:value-of select="object/activedates6"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/summarycreator6"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Summary Creator">
									<xsl:value-of select="object/summarycreator6"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Creator3-->
					<xsl:variable name="nullstring" select="object/personname7"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Creator7">

							<field type="Creator">
								<xsl:variable name="lifeyears" select="object/dates7"/>
								<xsl:variable name="activedates" select="object/activedates7"/>
								<xsl:if test="normalize-space($lifeyears)">
									<xsl:value-of select="concat ($nullstring, ' (', $lifeyears,')')"/>
								</xsl:if>
								<xsl:if test="not(normalize-space($lifeyears))">
									<xsl:value-of select="$nullstring"/>
								</xsl:if>
							</field>

							<xsl:variable name="nullstring" select="object/personname7"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Name">
									<xsl:value-of select="object/personname7"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/dates7"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Dates">
									<xsl:value-of select="object/dates7"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/nationality7"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Nationality">
									<xsl:value-of select="object/nationality7"/>
								</field>
							</xsl:if>


							<xsl:variable name="nullstring" select="object/role7"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Role">
									<xsl:value-of select="object/role7"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/activedates7"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Active Dates">
									<xsl:value-of select="object/activedates7"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/summarycreator7"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Summary Creator">
									<xsl:value-of select="object/summarycreator7"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Creator3-->
					<xsl:variable name="nullstring" select="object/personname8"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Creator8">
							<field type="Creator">
								<xsl:variable name="lifeyears" select="object/dates8"/>
								<xsl:variable name="activedates" select="object/activedates8"/>
								<xsl:if test="normalize-space($lifeyears)">
									<xsl:value-of select="concat ($nullstring, ' (', $lifeyears,')')"/>
								</xsl:if>
								<xsl:if test="not(normalize-space($lifeyears))">
									<xsl:value-of select="$nullstring"/>
								</xsl:if>
							</field>

							<xsl:variable name="nullstring" select="object/personname8"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Name">
									<xsl:value-of select="object/personname8"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/dates8"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Dates">
									<xsl:value-of select="object/dates8"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/nationality8"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Nationality">
									<xsl:value-of select="object/nationality8"/>
								</field>
							</xsl:if>


							<xsl:variable name="nullstring" select="object/role8"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Role">
									<xsl:value-of select="object/role8"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/activedates8"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Creator Active Dates">
									<xsl:value-of select="object/activedates8"/>
								</field>
							</xsl:if>

							<xsl:variable name="nullstring" select="object/summarycreator8"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Summary Creator">
									<xsl:value-of select="object/summarycreator8"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Secondary Creator 1-->
					<!-- Needs proper extract format from Vernon, probably User Sym 35-->
					<xsl:variable name="nullstring" select="object/secondarycreator1"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Associate Creator1">
							<field type="Associate Creator">
								<xsl:variable name="lifeyears" select="object/secondarydates1"/>
								<xsl:if test="normalize-space($lifeyears)">
									<xsl:value-of select="concat ($nullstring, ' (', $lifeyears,')')"/>
								</xsl:if>
								<xsl:if test="not(normalize-space($lifeyears))">
									<xsl:value-of select="$nullstring"/>
								</xsl:if>
							</field>
							<xsl:variable name="nullstring" select="object/secondarycreator1"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associate Creator Name">
									<xsl:value-of select="object/secondarycreator1"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/secondarydates1"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associate Creator Dates">
									<xsl:value-of select="object/secondarydates1"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/secondarynat1"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associate Creator Nationality">
									<xsl:value-of select="object/secondarynat1"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/secondaryrole1"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associate Creator Role">
									<xsl:value-of select="object/secondaryrole1"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Secondary Creator 2-->
					<!-- Needs proper extract format from Vernon, probably User Sym 35-->
					<xsl:variable name="nullstring" select="object/secondarycreator2"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Associate Creator2">
							<field type="Associate Creator">
								<xsl:variable name="lifeyears" select="object/secondarydates2"/>
								<xsl:if test="normalize-space($lifeyears)">
									<xsl:value-of select="concat ($nullstring, ' (', $lifeyears,')')"/>
								</xsl:if>
								<xsl:if test="not(normalize-space($lifeyears))">
									<xsl:value-of select="$nullstring"/>
								</xsl:if>
							</field>
							<xsl:variable name="nullstring" select="object/secondarycreator2"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associate Creator Name">
									<xsl:value-of select="object/secondarycreator2"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/secondarydates2"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associate Creator Dates">
									<xsl:value-of select="object/secondarydates2"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/secondarynat2"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associate Creator Nationality">
									<xsl:value-of select="object/secondarynat2"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/secondaryrole2"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associate Creator Role">
									<xsl:value-of select="object/secondaryrole2"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Secondary Creator 3-->
					<!-- Needs proper extract format from Vernon, probably User Sym 35-->
					<xsl:variable name="nullstring" select="object/secondarycreator3"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Associate Creator3">
							<field type="Associate Creator">
								<xsl:variable name="lifeyears" select="object/secondarydates3"/>
								<xsl:if test="normalize-space($lifeyears)">
									<xsl:value-of select="concat ($nullstring, ' (', $lifeyears,')')"/>
								</xsl:if>
								<xsl:if test="not(normalize-space($lifeyears))">
									<xsl:value-of select="$nullstring"/>
								</xsl:if>
							</field>
							<xsl:variable name="nullstring" select="object/secondarycreator3"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associate Creator Name">
									<xsl:value-of select="object/secondarycreator3"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/secondarydates3"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associate Creator Dates">
									<xsl:value-of select="object/secondarydates3"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/secondarynat3"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associate Creator Nationality">
									<xsl:value-of select="object/secondarynat3"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/secondaryrole3"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associate Creator Role">
									<xsl:value-of select="object/secondaryrole3"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>


					<!--Field Group: Secondary Creator 4-->
					<!-- Needs proper extract format from Vernon, probably User Sym 35-->
					<xsl:variable name="nullstring" select="object/secondarycreator4"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Associate Creator4">
							<field type="Associate Creator">
								<xsl:variable name="lifeyears" select="object/secondarydates4"/>
								<xsl:if test="normalize-space($lifeyears)">
									<xsl:value-of select="concat ($nullstring, ' (', $lifeyears,')')"/>
								</xsl:if>
								<xsl:if test="not(normalize-space($lifeyears))">
									<xsl:value-of select="$nullstring"/>
								</xsl:if>
							</field>
							<xsl:variable name="nullstring" select="object/secondarycreator4"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associate Creator Name">
									<xsl:value-of select="object/secondarycreator4"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/secondarydates4"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associate Creator Dates">
									<xsl:value-of select="object/secondarydates4"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/secondarynat4"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associate Creator Nationality">
									<xsl:value-of select="object/secondarynat4"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/secondaryrole4"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Associate Creator Role">
									<xsl:value-of select="object/secondaryrole4"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Dates-->
					<xsl:variable name="nullstring" select="object/prod_pri_date"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Dates">
							<xsl:apply-templates select="object/prod_pri_date"/>
							<xsl:variable name="nullstring" select="object/dc_prod_pri_date_earliest_being"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Early Date">
									<xsl:value-of select="object/dc_prod_pri_date_earliest_being"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/dc_prod_pri_date_latest_being"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Late Date">
									<xsl:value-of select="object/dc_prod_pri_date_latest_being"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/date_notes"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Date Info">
									<xsl:value-of select="object/date_notes"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--					Field Group: Dates (ECA Only)
					<xsl:variable name="nullstring" select="object/date1"/>
					<xsl:if test="normalize-space($nullstring)">
							<fieldGroup type="Dates1">
								<field type="Display Date">
									<xsl:value-of select="object/date1"/>
								</field>
								<xsl:variable name="nullstring" select="object/date_notes1"/>
								<xsl:if test="normalize-space($nullstring)">
								<field type="Date Info">
									<xsl:value-of select="object/date_notes1"/>
								</field>
								</xsl:if>
							</fieldGroup>
					</xsl:if>-->

					<!--					Field Group: Dates (ECA Only)
					<xsl:variable name="nullstring" select="object/date2"/>
					<xsl:if test="normalize-space($nullstring)">
							<fieldGroup type="Dates2">
								<field type="Display Date">
									<xsl:value-of select="object/date2"/>
								</field>
								<xsl:variable name="nullstring" select="object/date_notes2"/>
								<xsl:if test="normalize-space($nullstring)">
								<field type="Date Info">
									<xsl:value-of select="object/date_notes2"/>
								</field>
								</xsl:if>
							</fieldGroup>
					</xsl:if>-->

					<!--Field Group: Description-->
					<xsl:variable name="nullstring" select="object/brief_desc"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Description">
							<xsl:apply-templates select="object/brief_desc"/>
						</fieldGroup>
					</xsl:if>

					<xsl:variable name="nullstring" select="object/user_sym_52"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Work Type">
							<xsl:variable name="nullstring" select="object/user_sym_46"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Classification">
									<xsl:value-of select="object/classification"/>
								</field>
							</xsl:if>
							
							<field type="Work Type">
								<xsl:value-of select="object/user_sym_52"/>
							</field>
							
							<xsl:variable name="nullstring" select="object/researcher_notes"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Work Type Notes">
									<xsl:value-of select="object/researcher_notes"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<xsl:variable name="nullstring" select="object/user_sym_42"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Work Type">
							<field type="Work Type">
								<xsl:value-of select="object/user_sym_42"/>
							</field>
						</fieldGroup>
					</xsl:if>

					<xsl:variable name="nullstring" select="object/user_sym_43"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Work Type">
							<field type="Work Type">
								<xsl:value-of select="object/user_sym_43"/>
							</field>
						</fieldGroup>
					</xsl:if>


					<xsl:variable name="nullstring" select="object/user_sym_44"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Work Type">
							<field type="Work Type">
								<xsl:value-of select="object/user_sym_44"/>
							</field>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Measurements-->
					<xsl:variable name="nullstringA" select="object/measure_reading_display"/>
					<xsl:variable name="nullstringB" select="object/measure_notes_display"/>
					<xsl:choose>
						<xsl:when test="normalize-space($nullstringA)">
							<fieldGroup type="Measurement">
								<field type="Measurement">
									<xsl:value-of select="object/measure_reading_display"/>
								</field>
								<xsl:variable name="nullstring" select="object/measure_display"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Measurement Type">
										<xsl:value-of select="object/measure_display_type"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/measure_unit"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Measurement Unit">
										<xsl:value-of select="object/measure_unit"/>
									</field>
								</xsl:if>
								<xsl:if test="normalize-space($nullstringB)">
									<field type="Measurement Notes">
										<xsl:value-of select="object/measure_notes_display"/>
									</field>
								</xsl:if>
							</fieldGroup>
						</xsl:when>
						<xsl:when test="normalize-space($nullstringB)">
							<fieldGroup type="Measurement">
								<xsl:apply-templates select="object/measure_notes_display"/>
								<xsl:variable name="nullstring" select="object/measure_unit"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Measurement Unit">
										<xsl:value-of select="object/measure_unit"/>
									</field>
								</xsl:if>
							</fieldGroup>
						</xsl:when>
					</xsl:choose>

					<!--Field Group: Material-->
					<xsl:variable name="nullstring" select="object/material"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Material">
							<xsl:apply-templates select="object/material"/>
							<xsl:variable name="nullstring" select="object/material_notes"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Material Notes">
									<xsl:value-of select="object/material_notes"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Technique-->
					<xsl:variable name="nullstring" select="object/prod_pri_technique"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Technique">
							<field type="Technique">
								<xsl:value-of select="object/prod_pri_technique"/>
							</field>
							<xsl:variable name="nullstring" select="object/prod_det_technique"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Secondary Technique">
									<xsl:value-of select="object/prod_det_technique"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>




					<!--Field Group: Location-->
					<xsl:variable name="nullstring" select="object/usual_loc_being"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Location">
							<xsl:apply-templates select="object/usual_loc_being"/>
							<xsl:variable name="nullstring" select="object/gallery"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Gallery">
									<xsl:value-of select="object/gallery"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/location_notes"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Location Info">
									<xsl:value-of select="object/location_notes"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/department"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Department">
									<xsl:value-of select="object/department"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Production Place-->
					<xsl:variable name="nullstring" select="object/user_sym_2"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Production Place">
							<field type="Production Place">
								<xsl:apply-templates select="object/user_sym_2"/>
							</field>
						</fieldGroup>
					</xsl:if>

					<xsl:variable name="nullstring" select="object/user_sym_3"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Production Place">
							<field type="Production Place">
								<xsl:apply-templates select="object/user_sym_3"/>
							</field>
						</fieldGroup>
					</xsl:if>

					<xsl:variable name="nullstring" select="object/user_sym_4"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Production Place">
							<field type="Production Place">
								<xsl:apply-templates select="object/user_sym_4"/>
							</field>
						</fieldGroup>
					</xsl:if>

					<xsl:variable name="nullstring" select="object/user_sym_5"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Production Place">
							<field type="Production Place">
								<xsl:apply-templates select="object/user_sym_5"/>
							</field>
						</fieldGroup>
					</xsl:if>


					<!--Field Group: Repository-->
					<xsl:variable name="nullstring" select="object/user_sym_47"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repository">
							<xsl:apply-templates select="object/user_sym_47"/>
							<xsl:variable name="nullstring" select="object/edition"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Source">
									<xsl:value-of select="object/edition"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/repo_notes"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Repository Notes">
									<xsl:value-of select="object/repo_notes"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

										<!--Field Group: Repository-->
					<xsl:variable name="nullstring" select="object/user_sym_48"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repository">
							<xsl:apply-templates select="object/user_sym_48"/>
							<xsl:variable name="nullstring" select="object/edition"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Source">
									<xsl:value-of select="object/edition"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/repo_notes"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Repository Notes">
									<xsl:value-of select="object/repo_notes"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Repository-->
					<xsl:variable name="nullstring" select="object/user_sym_49"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repository">
							<xsl:apply-templates select="object/user_sym_49"/>
							<xsl:variable name="nullstring" select="object/edition"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Source">
									<xsl:value-of select="object/edition"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="object/repo_notes"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Repository Notes">
									<xsl:value-of select="object/repo_notes"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>


					<!--Field Group: Period-->
					<xsl:variable name="nullstring" select="object/prod_pri_period"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Style or Period">
							<xsl:apply-templates select="object/prod_pri_period"/>
							<xsl:variable name="nullstring" select="object/prod_det_period"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Style Secondary Period Term">
									<xsl:value-of select="object/prod_det_period"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Subject-->
					<xsl:variable name="subjPerson" select="object/user_sym_31"/>
					<xsl:variable name="subjRole" select="object/subject_role"/>
					<xsl:variable name="subjCity" select="object/user_sym_26"/>
					<xsl:variable name="subjCountry" select="object/user_sym_27"/>
					<xsl:variable name="subjGeo" select="object/user_sym_28"/>
					<xsl:variable name="subjBuilding" select="object/user_sym_29"/>
					<xsl:variable name="subjEvent" select="object/subject_event"/>
					<xsl:variable name="subjPeriod" select="object/subject_period"/>
					<xsl:variable name="subjDate" select="object/subject_date"/>
					<xsl:variable name="subjObject" select="object/subject_object"/>
					<xsl:variable name="subjCategory" select="object/subject_class"/>
					<xsl:variable name="subjNotes" select="object/subject_notes"/>
					<xsl:variable name="subjPlace" select="object/subject_place"/>
					<xsl:variable name="subjNotNull">
						<xsl:choose>
							<xsl:when test="normalize-space($subjPerson)">Yes</xsl:when>
							<xsl:when test="normalize-space($subjRole)">Yes</xsl:when>
							<xsl:when test="normalize-space($subjCity)">Yes</xsl:when>
							<xsl:when test="normalize-space($subjCountry)">Yes</xsl:when>
							<xsl:when test="normalize-space($subjGeo)">Yes</xsl:when>
							<xsl:when test="normalize-space($subjBuilding)">Yes</xsl:when>
							<xsl:when test="normalize-space($subjEvent)">Yes</xsl:when>
							<xsl:when test="normalize-space($subjPeriod)">Yes</xsl:when>
							<xsl:when test="normalize-space($subjDate)">Yes</xsl:when>
							<xsl:when test="normalize-space($subjObject)">Yes</xsl:when>
							<xsl:when test="normalize-space($subjCategory)">Yes</xsl:when>
							<xsl:when test="normalize-space($subjNotes)">Yes</xsl:when>
							<xsl:when test="normalize-space($subjPlace)">Yes</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="$subjNotNull = 'Yes'">
						<fieldGroup type="Subject">
							<xsl:if test="normalize-space($subjPerson)">
								<xsl:apply-templates select="object/user_sym_31"/>
							</xsl:if>
							<xsl:if test="normalize-space($subjRole)">
								<field type="Subject Role">
									<xsl:value-of select="object/subject_role"/>
								</field>
							</xsl:if>
							<!--Charting Workaround-->
							<xsl:if test="normalize-space($subjPlace)">
								<xsl:apply-templates select="object/subject_place"/>
							</xsl:if>

							<!--<xsl:if test="normalize-space($subjCity)">
								<xsl:apply-templates select="object/user_sym_26"/>
							</xsl:if>
							<xsl:if test="normalize-space($subjCountry)">
								<xsl:apply-templates select="object/user_sym_27"/>
							</xsl:if>
							<xsl:if test="normalize-space($subjGeo)">
								<xsl:apply-templates select="object/user_sym_28"/>
							</xsl:if>
							<xsl:if test="normalize-space($subjBuilding)">
								<xsl:apply-templates select="object/user_sym_29"/>
							</xsl:if>-->
							<xsl:if test="normalize-space($subjEvent)">
								<xsl:apply-templates select="object/subject_event"/>
							</xsl:if>
							<xsl:if test="normalize-space($subjDate)">
								<field type="Subject Date">
									<xsl:value-of select="object/subject_date"/>
								</field>
							</xsl:if>
							<xsl:if test="normalize-space($subjObject)">
								<xsl:apply-templates select="object/subject_object"/>
							</xsl:if>
							<xsl:if test="normalize-space($subjCategory)">
								<xsl:apply-templates select="object/subject_class"/>
							</xsl:if>
							<xsl:if test="normalize-space($subjNotes)">
								<xsl:apply-templates select="object/subject_notes"/>
							</xsl:if>
							<xsl:if test="normalize-space($subjPeriod)">
								<field type="Subject Period">
									<xsl:value-of select="object/subject_period"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Related Object-->
					<xsl:variable name="nullstring" select="object/related_object"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Related Object">
							<xsl:apply-templates select="object/related_object"/>
							<xsl:variable name="nullstring" select="object/related_ob_type"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Relation Type">
									<xsl:value-of select="object/related_ob_type"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--					Field Group: References-->
					<xsl:variable name="docnotes" select="object/documentationnotes1"/>
					<xsl:if test="$docnotes = 'Reference'">
						<fieldGroup type="References1">
							<field type="Reference">
								<xsl:variable name="doctitle" select="object/documentation1"/>
								<xsl:variable name="docvolpage" select="object/documentationvolpage1"/>
								<xsl:variable name="docperson" select="object/documentationperson1"/>
								<xsl:variable name="docarticle" select="object/documentationarticle1"/>
								<xsl:value-of select="concat($docperson,',',$docarticle, ',', $doctitle, ',' , $docvolpage)"/>

								<!--							<xsl:if test="normalize-space($docvolpage)">
									<xsl:if test="normalize-space($docperson)">
										<xsl:if test="normalize-space($docarticle)">
											<xsl:if test="normalize-space($doctitle)">
												<xsl:value-of select="concat($docperson,',',$docarticle, ',', $doctitle, ',' , $docvolpage)"/>
											</xsl:if>
										</xsl:if>
									</xsl:if>
								</xsl:if>
								<xsl:if test="normalize-space($docvolpage)">
									<xsl:if test="normalize-space($docperson)">
										<xsl:if test="normalize-space($docarticle)">
											<xsl:if test="not(normalize-space($doctitle))">
												<xsl:value-of select="concat ($docperson, ',' , $docarticle, ',' , $docvolpage)"/>
											</xsl:if>
										</xsl:if>
									</xsl:if>
								</xsl:if>
								<xsl:if test="normalize-space($docvolpage)">
									<xsl:if test="normalize-space($docperson)">
										<xsl:if test="not(normalize-space($docarticle))">
											<xsl:if test="not(normalize-space($doctitle))">
												<xsl:value-of select=" concat ($docperson, ',' , $docvolpage)"/>
											</xsl:if>
										</xsl:if>
									</xsl:if>
								</xsl:if>
								<xsl:if test="normalize-space($docvolpage)">
									<xsl:if test="not(normalize-space($docperson))">
										<xsl:if test="not(normalize-space($docarticle))">
											<xsl:if test="not(normalize-space($doctitle))">
												<xsl:value-of select=" concat ($docvolpage)"/>
											</xsl:if>
										</xsl:if>
									</xsl:if>
								</xsl:if>
								<xsl:if test="normalize-space($docvolpage)">
									<xsl:if test="not(normalize-space($docperson))">
										<xsl:if test="normalize-space($docarticle)">
											<xsl:if test="not(normalize-space($doctitle))">
												<xsl:value-of select=" concat ($docarticle, ',', $docvolpage)"/>
											</xsl:if>
										</xsl:if>
									</xsl:if>
								</xsl:if>
								<xsl:if test="normalize-space($docvolpage)">
									<xsl:if test="not(normalize-space($docperson))">
										<xsl:if test="normalize-space($docarticle)">
											<xsl:if test="normalize-space($doctitle)">
												<xsl:value-of select=" concat ($docarticle, ',' ,$doctitle, ',', $docvolpage)"/>
											</xsl:if>
										</xsl:if>
									</xsl:if>
								</xsl:if>
								<xsl:if test="normalize-space($docvolpage)">
									<xsl:if test="not(normalize-space($docperson))">
										<xsl:if test="normalize-space($docarticle)">
											<xsl:if test="not(normalize-space($docpublishdate))">
												<xsl:value-of select=" concat ($docarticle, ',' ,$doctitle, ',', $docvolpage)"/>
											</xsl:if>
										</xsl:if>
									</xsl:if>
								</xsl:if>
								<xsl:if test="normalize-space($docvolpage)">
									<xsl:if test="not(normalize-space($docperson))">
										<xsl:if test="normalize-space($docarticle)">
											<xsl:if test="not(normalize-space($docpublishdate))">
												<xsl:value-of select=" concat ($docarticle, ',' ,$doctitle, ',', $docvolpage)"/>
											</xsl:if>
										</xsl:if>
									</xsl:if>
								</xsl:if>-->
							</field>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Reference-->
					<xsl:variable name="docnotes" select="object/documentationnotes2"/>
					<xsl:if test="$docnotes = 'Reference'">
						<fieldGroup type="References2">
							<field type="Reference">
								<xsl:variable name="doctitle" select="object/documentation2"/>
								<xsl:variable name="docvolpage" select="object/documentationvolpage2"/>
								<xsl:variable name="docperson" select="object/documentationperson2"/>
								<xsl:variable name="docarticle" select="object/documentationarticle2"/>
								<xsl:value-of select="concat($docperson,',',$docarticle,',',$doctitle,',' ,$docvolpage)"/>
							</field>
						</fieldGroup>
					</xsl:if>


					<!--Field Group: Reference-->
					<xsl:variable name="docnotes" select="object/documentationnotes3"/>
					<xsl:if test="$docnotes = 'Reference'">
						<fieldGroup type="References3">
							<field type="Reference">
								<xsl:variable name="doctitle" select="object/documentation3"/>
								<xsl:variable name="docvolpage" select="object/documentationvolpage3"/>
								<xsl:variable name="docperson" select="object/documentationperson3"/>
								<xsl:variable name="docarticle" select="object/documentationarticle3"/>
								<xsl:value-of select="concat($docperson,',',$docarticle, ',', $doctitle, ',' , $docvolpage)"/>
							</field>
						</fieldGroup>
					</xsl:if>


					<!--Field Group: Reference-->
					<xsl:variable name="docnotes" select="object/documentationnotes4"/>
					<xsl:if test="$docnotes = 'Reference'">
						<fieldGroup type="References4">
							<field type="Reference">
								<xsl:variable name="doctitle" select="object/documentation4"/>
								<xsl:variable name="docvolpage" select="object/documentationvolpage4"/>
								<xsl:variable name="docperson" select="object/documentationperson4"/>
								<xsl:variable name="docarticle" select="object/documentationarticle4"/>
								<xsl:value-of select="concat($docperson,',',$docarticle, ',', $doctitle, ',' , $docvolpage)"/>
							</field>
						</fieldGroup>
					</xsl:if>


					<!--Field Group: Reference-->
					<xsl:variable name="docnotes" select="object/documentationnotes5"/>
					<xsl:if test="$docnotes = 'Reference'">
						<fieldGroup type="References5">
							<field type="Reference">
								<xsl:variable name="doctitle" select="object/documentation5"/>
								<xsl:variable name="docvolpage" select="object/documentationvolpage5"/>
								<xsl:variable name="docperson" select="object/documentationperson5"/>
								<xsl:variable name="docarticle" select="object/documentationarticle5"/>
								<xsl:value-of select="concat($docperson,',',$docarticle,',', $doctitle,',', $docvolpage)"/>
							</field>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Related Work-->
					<xsl:variable name="docnotes" select="object/documentationnotes1"/>
					<xsl:variable name="nullstring" select="object/documentation1"/>
					<xsl:if test="normalize-space($nullstring)">
						<xsl:if test="not($docnotes = 'Reference')">
							<fieldGroup type="Related Work1">
								<field type="Related Work Title">
									<xsl:value-of select="object/documentation1"/>
								</field>
								<xsl:variable name="nullstring" select="object/documentationvolpage1"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Page No">
										<xsl:value-of select="object/documentationvolpage1"/>
									</field>
								</xsl:if>

								<xsl:variable name="nullstring" select="object/documentationperson1"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Creator">
										<xsl:value-of select="object/documentationperson1"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationarticle1"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Article">
										<xsl:value-of select="object/documentationarticle1"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationnotes1"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Notes">
										<xsl:value-of select="object/documentationnotes1"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationpublishdate1"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Publish Date">
										<xsl:value-of select="object/documentationpublishdate1"/>
									</field>
								</xsl:if>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Desc">
										<xsl:value-of select="object/documentationdescnotes1"/>
									</field>
								</xsl:if>
							</fieldGroup>
						</xsl:if>
					</xsl:if>

					<!--Field Group: Related Work-->
					<xsl:variable name="docnotes" select="object/documentationnotes2"/>
					<xsl:variable name="nullstring" select="object/documentation2"/>
					<xsl:if test="normalize-space($nullstring)">
						<xsl:if test="not($docnotes = 'Reference')">
							<fieldGroup type="Related Work2">
								<field type="Related Work Title">
									<xsl:value-of select="object/documentation2"/>
								</field>
								<xsl:variable name="nullstring" select="object/documentationvolpage2"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Page No">
										<xsl:value-of select="object/documentationvolpage2"/>
									</field>
								</xsl:if>

								<xsl:variable name="nullstring" select="object/documentationperson2"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Creator">
										<xsl:value-of select="object/documentationperson2"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationarticle2"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Article">
										<xsl:value-of select="object/documentationarticle2"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationnotes2"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Notes">
										<xsl:value-of select="object/documentationnotes2"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationpublishdate2"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Publish Date">
										<xsl:value-of select="object/documentationpublishdate2"/>
									</field>
								</xsl:if>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Desc">
										<xsl:value-of select="object/documentationdescnotes2"/>
									</field>
								</xsl:if>
							</fieldGroup>
						</xsl:if>
					</xsl:if>

					<!--Field Group: Related Work-->
					<xsl:variable name="docnotes" select="object/documentationnotes3"/>
					<xsl:variable name="nullstring" select="object/documentation3"/>
					<xsl:if test="normalize-space($nullstring)">
						<xsl:if test="not($docnotes = 'Reference')">
							<fieldGroup type="Related Work3">
								<field type="Related Work Title">
									<xsl:value-of select="object/documentation3"/>
								</field>
								<xsl:variable name="nullstring" select="object/documentationvolpage3"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Page No">
										<xsl:value-of select="object/documentationvolpage3"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationperson3"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Creator">
										<xsl:value-of select="object/documentationperson3"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationarticle3"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Article">
										<xsl:value-of select="object/documentationarticle3"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationnotes3"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Notes">
										<xsl:value-of select="object/documentationnotes3"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationpublishdate3"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Publish Date">
										<xsl:value-of select="object/documentationpublishdate3"/>
									</field>
								</xsl:if>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Desc">
										<xsl:value-of select="object/documentationdescnotes3"/>
									</field>
								</xsl:if>
							</fieldGroup>
						</xsl:if>
					</xsl:if>

					<!--Field Group: Related Work-->
					<xsl:variable name="docnotes" select="object/documentationnotes4"/>
					<xsl:variable name="nullstring" select="object/documentation4"/>
					<xsl:if test="not($docnotes = 'Reference')">
						<xsl:if test="normalize-space($nullstring)">
							<fieldGroup type="Related Work4">
								<field type="Related Work Title">
									<xsl:value-of select="object/documentation4"/>
								</field>
								<xsl:variable name="nullstring" select="object/documentationvolpage4"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Page No">
										<xsl:value-of select="object/documentationvolpage4"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationperson4"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Creator">
										<xsl:value-of select="object/documentationperson4"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationarticle4"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Article">
										<xsl:value-of select="object/documentationarticle4"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationnotes4"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Notes">
										<xsl:value-of select="object/documentationnotes4"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationpublishdate4"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Publish Date">
										<xsl:value-of select="object/documentationpublishdate4"/>
									</field>
								</xsl:if>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Desc">
										<xsl:value-of select="object/documentationdescnotes4"/>
									</field>
								</xsl:if>
							</fieldGroup>
						</xsl:if>
					</xsl:if>

					<!--Field Group: Related Work-->
					<xsl:variable name="docnotes" select="object/documentationnotes5"/>
					<xsl:variable name="nullstring" select="object/documentation5"/>
					<xsl:if test="normalize-space($nullstring)">
						<xsl:if test="not($docnotes = 'Reference')">
							<fieldGroup type="Related Work5">
								<field type="Related Work Title">
									<xsl:value-of select="object/documentation5"/>
								</field>
								<xsl:variable name="nullstring" select="object/documentationvolpage5"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Page No">
										<xsl:value-of select="object/documentationvolpage5"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationperson5"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Creator">
										<xsl:value-of select="object/documentationperson5"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationarticle5"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Article">
										<xsl:value-of select="object/documentationarticle5"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationnotes5"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Notes">
										<xsl:value-of select="object/documentationnotes5"/>
									</field>
								</xsl:if>
								<xsl:variable name="nullstring" select="object/documentationpublishdate5"/>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Publish Date">
										<xsl:value-of select="object/documentationpublishdate5"/>
									</field>
								</xsl:if>
								<xsl:if test="normalize-space($nullstring)">
									<field type="Related Work Desc">
										<xsl:value-of select="object/documentationdescnotes5"/>
									</field>
								</xsl:if>
							</fieldGroup>
						</xsl:if>
					</xsl:if>

					<!--Field Group: Rights-->
					<xsl:variable name="nullstring" select="object/credit_line"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Rights">
							<field type="Rights Statement">
								<xsl:value-of select="object/credit_line"/>
							</field>
							<xsl:variable name="nullstring" select="object/copyright_owner"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Rights Details">
									<xsl:value-of select="object/copyright_owner"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Inscription-->
					<xsl:variable name="nullstring" select="object/inscription"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Inscription">
							<field type="Inscription">
								<xsl:value-of select="object/inscription"/>
							</field>
							<xsl:variable name="nullstring" select="object/signature_date"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Inscription Notes">
									<xsl:value-of select="object/signature_date"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Culture-->
					<xsl:variable name="nullstring" select="object/generic"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Culture">
							<field type="Culture">
								<xsl:value-of select="object/generic"/>
							</field>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Provenance-->
					<xsl:variable name="nullstring" select="object/provenance_notes"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Provenance">
							<xsl:variable name="nullstring" select="object/provenance_notes"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Provenance Notes">
									<xsl:value-of select="object/provenance_notes"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Keywords-->
					<xsl:variable name="nullstring" select="object/user_text_2"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Keywords">
							<xsl:variable name="nullstring" select="object/user_text_2"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Keyword">
									<xsl:value-of select="object/user_text_2"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>


					<!--Field Group: Repro Record-->
					<xsl:variable name="nullstring" select="im_ref"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repro Record">
							<field type="Repro Record ID">
								<xsl:value-of select="im_ref"/>
							</field>
							<xsl:variable name="nullstring" select="reproID"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Repro Link ID">
									<xsl:value-of select="reproID"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="user_sym_7"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Repro Capture Device Type">
									<xsl:value-of select="user_sym_7"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="user_sym_8"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Repro File Size (bytes)">
									<xsl:value-of select="user_sym_8"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="res"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Repro Resolution (dpi)">
									<xsl:value-of select="res"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="user_sym_6"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Repro File Type">
									<xsl:value-of select="user_sym_6"/>
								</field>
							</xsl:if>
							<xsl:variable name="nullstring" select="location_notes"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Repro Notes">
									<xsl:value-of select="location_notes"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Repro Title-->
					<xsl:variable name="nullstring" select="caption"/>
					<xsl:variable name="public" select="publication_status"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repro Title">
							<field type="Repro Title">
								<xsl:choose>
									<xsl:when test="$public = 'No public access'">
										<xsl:variable name="caption" select="caption"/>
										<xsl:value-of select="concat ('[PRIVATE IMAGE] ', $caption)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="caption"/>
									</xsl:otherwise>
								</xsl:choose>
							</field>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Repro Measurements-->
					<xsl:variable name="nullstring" select="sym_md_height"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repro Measurement">
							<field type="Repro Display Measurement (pixels)">
								<xsl:variable name="height" select="sym_md_height"/>
								<xsl:variable name="width" select="sym_md_width"/>
								<xsl:value-of select="concat ($height,' × ',$width)"/>
							</field>
							<field type="Repro Measurement Unit">pixels</field>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Repro Measurements-->
					<xsl:variable name="nullstring" select="dimensions"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repro Measurement">
							<field type="Repro Display Measurement (pixels)">
								<xsl:value-of select="dimensions"/>
							</field>
							<field type="Repro Measurement Unit">pixels</field>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Repro Creator-->
					<!--					<xsl:variable name="nullstring" select="av/prod_person"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repro Creator">
							<field type="Repro Creator Name">
								<xsl:value-of select="av/prod_person"/>
							</field>
							<xsl:variable name="nullstring" select="av/prod_role"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Repro Creator Role Description">
									<xsl:value-of select="av/prod_role"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>-->
					<xsl:variable name="nullstring" select="avperson1"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repro Creator1">
							<field type="Repro Creator Name">
								<xsl:value-of select="avperson1"/>
							</field>
							<xsl:variable name="nullstring" select="avrole1"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Repro Creator Role Description">
									<xsl:value-of select="avrole1"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>


					<xsl:variable name="nullstring" select="avperson2"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repro Creator2">
							<field type="Repro Creator Name">
								<xsl:value-of select="avperson2"/>
							</field>
							<xsl:variable name="nullstring" select="avrole2"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Repro Creator Role Description">
									<xsl:value-of select="avrole2"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<xsl:variable name="nullstring" select="avperson3"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repro Creator3">
							<field type="Repro Creator Name">
								<xsl:value-of select="avperson3"/>
							</field>
							<xsl:variable name="nullstring" select="avrole3"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Repro Creator Role Description">
									<xsl:value-of select="avrole3"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<xsl:variable name="nullstring" select="avperson4"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repro Creator4">
							<field type="Repro Creator Name">
								<xsl:value-of select="avperson4"/>
							</field>
							<xsl:variable name="nullstring" select="av/avrole4"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Repro Creator Role Description">
									<xsl:value-of select="avrole4"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<xsl:variable name="nullstring" select="avperson5"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repro Creator5">
							<field type="Repro Creator Name">
								<xsl:value-of select="avperson5"/>
							</field>
							<xsl:variable name="nullstring" select="avrole5"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Repro Creator Role Description">
									<xsl:value-of select="avrole5"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Repro Repository-->
					<xsl:variable name="nullstring" select="collection"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repro Repository">
							<field type="Repro Repository">
								<xsl:value-of select="collection"/>
							</field>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Repro ID Number-->
					<xsl:variable name="nullstring" select="reproID"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repro ID Number">
							<field type="Repro ID Number">
								<!--xsl:value-of select="substring($nullstring,70,12)"/-->
								<xsl:value-of select="(reproID,'.tif')"/>
							</field>
							<xsl:variable name="nullstring" select="user_sym_4"/>
							<xsl:if test="normalize-space($nullstring)">
								<field type="Repro Old ID Number">
									<!--xsl:value-of select="substring($nullstring,70,12)"/-->
									<xsl:value-of select="user_sym_4"/>
								</field>
							</xsl:if>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Repro Description-->
					<xsl:variable name="nullstring" select="brief_desc"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repro Description">
							<field type="Repro Description">
								<xsl:value-of select="brief_desc"/>
							</field>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Repro Rights-->
					<xsl:variable name="nullstring" select="credit_line"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repro Rights">
							<field type="Repro Rights Statement">
								<xsl:value-of select="credit_line"/>
							</field>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Repro Dates- user_value_2 or user_sym_9: check!-->
					<xsl:variable name="nullstring" select="user_sym_9"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repro Dates">
							<field type="Repro Capture Date">
								<xsl:value-of select="user_sym_9"/>
							</field>
						</fieldGroup>
					</xsl:if>

					<!--Field Group: Repro Dates- user_value_2 or user_sym_9: check!-->
					<xsl:variable name="nullstring" select="publication_status"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Repro Publication Status">
							<field type="Repro Publication Status">
								<xsl:value-of select="publication_status"/>
							</field>
						</fieldGroup>
					</xsl:if>

					<!--					Field Group: HORRIBLE WORKAROUND BECAUSE LUNA USES A COMMA SEPARATOR!
					<xsl:variable name="nullstring" select="object/user_sym_33"/>
					<xsl:if test="normalize-space($nullstring)">
						<fieldGroup type="Summary Creators">
							<xsl:apply-templates select="object/user_sym_33"/>
						</fieldGroup>
					</xsl:if>-->
				</record>
			</xsl:for-each>
		</recordList>
	</xsl:template>
	<xsl:template match="object/user_sym_46">
		<field type="Repository">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/user_sym_47">
		<field type="Repository">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/user_sym_48">
		<field type="Repository">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/prod_pri_person">
		<field type="Creator Name">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/prod_pri_role">
		<field type="Creator Role">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/document_display">
		<field type="Related Work Title">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/prod_pri_period">
		<field type="Style or Period">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/material">
		<field type="Material">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/subject_notes">
		<field type="Subject">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/user_sym_26">
		<field type="Subject Place">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/user_sym_31">
		<field type="Subject Person">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/user_sym_27">
		<field type="Subject Place">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/user_sym_28">
		<field type="Subject Place">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/user_sym_29">
		<field type="Subject Place">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/subject_class">
		<field type="Subject Category">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/subject_event">
		<field type="Subject Event">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/subject_object">
		<field type="Subject Object">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/object_type">
		<field type="Work Type">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/prod_pri_date">
		<field type="Date">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/subject_place">
		<field type="Subject Place">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<!--	<xsl:template match="object/gallery">
		<field type="Repository">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>-->
	<xsl:template match="object/brief_desc">
		<field type="Description">
			<xsl:value-of select="substring(.,1,3900)"/>
		</field>
	</xsl:template>
	<xsl:template match="prod_person">
		<field type="Repro Creator Name">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>

	<xsl:template match="prod_role">
		<field type="Repro Creator Role Description">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<xsl:template match="object/usual_loc_being">
		<field type="Location">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
		<xsl:template match="object/prod_pri_place">
		<field type="Production Place">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>

	<xsl:template match="object/measure_notes_display">
		<field type="Measurement">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>
	<!--	<xsl:template match="object/user_sym_33">
		<field type="Summary Creator">
			<xsl:value-of select="."/>
		</field>
	</xsl:template>-->

</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2007. Progress Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="vernonParsed.xml" htmlbaseurl="" outputurl="Load.xml" processortype="saxon8" useresolver="yes" profilemode="0" profiledepth="" profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator="" ><advancedProp name="sInitialMode" value=""/><advancedProp name="bXsltOneIsOkay" value="true"/><advancedProp name="bSchemaAware" value="true"/><advancedProp name="bXml11" value="false"/><advancedProp name="iValidation" value="0"/><advancedProp name="bExtensions" value="true"/><advancedProp name="iWhitespace" value="0"/><advancedProp name="sInitialTemplate" value=""/><advancedProp name="bTinyTree" value="true"/><advancedProp name="bWarnings" value="true"/><advancedProp name="bUseDTD" value="false"/><advancedProp name="iErrorHandling" value="fatal"/></scenario></scenarios><MapperMetaTag><MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="..\Vernon\Ragamala\RagamalaForLoad.xml" destSchemaRoot="recordList" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no" ><SourceSchema srcSchemaPath="vernonParsed.xml" srcSchemaRoot="vernon" AssociatedInstance="" loaderFunction="document" loaderFunctionUsesURI="no"/></MapperInfo><MapperBlockPosition><template match="/"></template></MapperBlockPosition><TemplateContext></TemplateContext><MapperFilter side="source"></MapperFilter></MapperMetaTag>
</metaInformation>
-->