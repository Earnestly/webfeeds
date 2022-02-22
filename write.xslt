<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/c">
        <xsl:for-each select="f">
            <xsl:document method="text" encoding="UTF-8" href="{p}">
                <xsl:for-each select="e/i">
                    <xsl:value-of select="d"/><xsl:text> </xsl:text>
                    <xsl:value-of select="l"/><xsl:text> </xsl:text>
                    <xsl:value-of select="t"/><xsl:text>&#10;</xsl:text>
                </xsl:for-each>
            </xsl:document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
