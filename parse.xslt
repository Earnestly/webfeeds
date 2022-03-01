<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:rss="http://purl.org/rss/1.0/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:str="http://exslt.org/strings"
    extension-element-prefixes="str">

    <xsl:output method="xml" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:param name="prefix"/>

    <xsl:template name="filepath">
        <xsl:param name="link"/>
        <xsl:param name="title"/>

        <!-- Extract the domain name. -->
        <xsl:variable name="domain" select="substring-before(concat(substring-after($link, '://'), '/'), '/')"/>

        <xsl:variable name="title">
            <xsl:choose>
                <xsl:when test="$title = ''">
                    <xsl:value-of select="$link"/>
                </xsl:when>
                <xsl:otherwise>
                    <!--
                        Ensure there are no / characters in the title as it is
                        used to form the final directory.
                    -->
                    <xsl:value-of select="substring-before(concat(str:encode-uri($title, false()), '/'), '/')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:element name="p">
            <xsl:value-of select="$prefix"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="$domain"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="$title"/>
            <xsl:text>/recent</xsl:text>
        </xsl:element>
    </xsl:template>

    <xsl:template name="entry">
        <xsl:param name="date"/>
        <xsl:param name="link"/>
        <xsl:param name="title"/>

        <xsl:element name="i">
            <!--
                The use of &#10; (newlines) are used to ensure the date node is
                on its own line so that dateconv can match them precisely.
            -->
            <xsl:text>&#10;</xsl:text>
            <xsl:element name="d">
                <xsl:choose>
                    <xsl:when test="$date">
                        <xsl:value-of select="$date"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>1970-01-01T01:00:00Z</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:text>&#10;</xsl:text>

            <xsl:element name="l">
                <xsl:choose>
                    <xsl:when test="guid/@isPermaLink = 'true'">
                        <xsl:value-of select="guid"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$link"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>

            <xsl:element name="t">
                <xsl:value-of select="$title"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="/rss">
        <xsl:element name="f">
            <xsl:call-template name="filepath">
                <xsl:with-param name="title" select="channel/title"/>
                <xsl:with-param name="link" select="channel/link"/>
            </xsl:call-template>

            <xsl:element name="e">
                <xsl:for-each select="channel/item">
                    <xsl:call-template name="entry">
                        <xsl:with-param name="title" select="title"/>
                        <xsl:with-param name="link" select="link"/>
                        <xsl:with-param name="date" select="pubDate|dc:date"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="/atom:feed">
        <xsl:element name="f">
            <xsl:call-template name="filepath">
                <xsl:with-param name="title" select="atom:title"/>
                <xsl:with-param name="link" select="atom:link/@href"/>
            </xsl:call-template>

            <xsl:element name="e">
                <xsl:for-each select="atom:entry">
                    <xsl:call-template name="entry">
                        <xsl:with-param name="date" select="atom:published|atom:updated"/>
                        <xsl:with-param name="link" select="atom:link/@href"/>
                        <xsl:with-param name="title" select="atom:title"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- LWN.net -->
    <xsl:template match='/rdf:RDF'>
        <xsl:element name="f">
            <xsl:call-template name="filepath">
                <xsl:with-param name="title" select="rss:channel/rss:title"/>
                <xsl:with-param name="link" select="rss:channel/rss:link"/>
            </xsl:call-template>

            <xsl:element name="e">
                <xsl:for-each select='rss:item'>
                    <xsl:call-template name="entry">
                        <xsl:with-param name="date" select="dc:date"/>
                        <xsl:with-param name="link" select="rss:link"/>
                        <xsl:with-param name="title" select="rss:title"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*">
        <!--
            Override built-in XSLT templates to do nothing if the above
            templates are not matched.
        -->
    </xsl:template>
</xsl:stylesheet>
