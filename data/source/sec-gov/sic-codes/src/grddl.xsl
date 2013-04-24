<xsl:transform version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:xhtml="http://www.w3.org/1999/xhtml"
   exclude-result-prefixes="">
<xsl:output method="text"/>

<xsl:template match="/">
   <xsl:apply-templates select="//xhtml:table[xhtml:tr[xhtml:td[. = 'AGRICULTURAL PRODUCTION-CROPS']]]/xhtml:tr[count(xhtml:td)=4]"/>
</xsl:template>

<xsl:template match="xhtml:tr">
   <xsl:value-of select="concat($DQ,normalize-space(xhtml:td[1]),$DQ,',',
                                $DQ,normalize-space(xhtml:td[2]),$DQ,',',
                                $DQ,normalize-space(xhtml:td[3]),$DQ,',',
                                $DQ,normalize-space(xhtml:td[4]),$DQ,$NL)"/>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
      <xsl:copy-of select="@*"/>   
      <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<xsl:template match="text()">
   <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:variable name="NL" select="'&#xa;'"/>
<xsl:variable name="DQ" select="'&#x22;'"/>

</xsl:transform>
