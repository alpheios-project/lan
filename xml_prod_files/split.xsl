<?xml version="1.0" encoding="UTF-8"?>
<!-- XSLT whicih splits a lexicon file on the div1 entries -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:saxon="http://saxon.sf.net/"
    extension-element-prefixes="saxon"
    exclude-result-prefixes="saxon">
    <xsl:param name="e_baseDir" select="'out'"/>
    <xsl:template match="/">    
        <xsl:for-each select="//text/body/div1">
                        
            <xsl:variable name="letter">
                <xsl:choose>
                    <xsl:when test="matches(@n,'[ABCDEFGHIJKLMNOPQRSTUVWXYZ]')">
                        <xsl:value-of select="concat('_',@n)"/>
                    </xsl:when>
                    <xsl:when test="matches(@n,'[\*]')">
                        <xsl:value-of select="translate(@n,'*','_')"/>
                    </xsl:when>                    
                    <xsl:otherwise><xsl:value-of select="@n"/></xsl:otherwise>                    
                </xsl:choose>                                                
            </xsl:variable>
            <xsl:variable name="number">
                <xsl:value-of select="count(preceding-sibling::div1[@n = current()/@n])"/>
            </xsl:variable>
            <xsl:variable name="file" select="concat($e_baseDir,'/',$letter,$number,'.xml')"/>
            <xsl:result-document href="{$file}">
                    <TEI.2>                        
                        <text>
                            <body>
                                  <xsl:apply-templates select="."/>
                            </body>
                        </text>                            
                    </TEI.2>                    
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
                    
    <xsl:template match="@*|node()">        
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>