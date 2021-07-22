<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:xml="http://www.w3.org/XML/1998/namespace"
>

<!-- Inserted <xsl:include href="pretext/xsl/pretext-common.xsl"/>-->

<xsl:output method="xml" indent="yes"/>

<!-- https://stackoverflow.com/a/6357859/1607849
<xsl:variable name="slide-defaults">|<xsl:value-of select="pretext/docinfo/@slide-defaults"/>|</xsl:variable>-->
          <!--<xsl:for-each select="*[contains($slide-defaults,concat('|',local-name(),'|')) or @slide='true']">-->

<xsl:template match="/">
    <pretext xmlns:xi="http://www.w3.org/2001/XInclude">
        <xsl:copy-of select="pretext/docinfo"/>
        <slideshow>
            <xsl:apply-templates select="pretext/book|pretext/article"/>
        </slideshow>
    </pretext>
</xsl:template>

<xsl:template match="book|article">
    <xsl:copy-of select="title"/>
    <xsl:copy-of select="subtitle"/>
    <xsl:apply-templates select="frontmatter"/>
    <xsl:apply-templates select="chapter|backmatter/appendix"/>
</xsl:template>

<xsl:template match="frontmatter">
    <frontmatter>
        <xsl:copy-of select="titlepage"/>
        <xsl:copy-of select="abstract"/>
    </frontmatter>
</xsl:template>

<xsl:template match="*" mode="slides-title">
    <title>
        <xsl:apply-templates select="." mode="type-name"/><xsl:text> </xsl:text>
        <xsl:apply-templates select="." mode="number"/><xsl:if test="title">:
        <xsl:value-of select="title"/></xsl:if>
    </title>
</xsl:template>

<xsl:template match="chapter|backmatter/appendix">
    <section>
        <xsl:apply-templates select="." mode="slides-title"/>
    </section>
    <xsl:apply-templates select="section"/>
</xsl:template>

<xsl:template match="section">
    <section>
        <xsl:apply-templates select="." mode="slides-title"/>
        <xsl:apply-templates select="activity|definition|remark|fact|observation|example|subsection"/>
    </section>
</xsl:template>

<xsl:template match="subsection">
    <xsl:apply-templates select="activity|definition|remark|fact|observation|example"/>
</xsl:template>

<xsl:template match="activity|definition|remark|fact|observation|example">
    <slide>
        <xsl:apply-templates select="." mode="slides-title"/>
        <xsl:apply-templates select="statement/*|introduction/*|task" mode="slideshow-copy"/>
    </slide>
</xsl:template>

<xsl:template match="task">
    <li>
        <xsl:apply-templates select="*" mode="slideshow-copy"/>
    </li>
</xsl:template>

<!-- Identity template : copy all text nodes, elements and attributes -->
    <!-- modified from https://stackoverflow.com/a/14985831 -->
    <!-- Identity template : copy all text nodes, elements and attributes -->   
    <xsl:template match="@*|node()" mode="slideshow-copy">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="slideshow-copy" />
        </xsl:copy>
    </xsl:template>

<xsl:template match="image" mode="slideshow-copy">
    <xsl:choose>
        <xsl:when test="latex-image">
            <image>
                <xsl:attribute name="source">
                    <xsl:text>generated/latex-image/</xsl:text>
                    <xsl:apply-templates select="." mode="visible-id" />
                    <xsl:text>.svg</xsl:text>
                </xsl:attribute>
            </image>
        </xsl:when>
        <xsl:otherwise>
            <image>
                <xsl:attribute name="source">
                    <xsl:text>external/</xsl:text>
                    <xsl:value-of select="@source"/>
                </xsl:attribute>
            </image>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


</xsl:stylesheet>