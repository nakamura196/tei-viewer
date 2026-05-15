<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="tei">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <html lang="ja">
      <head>
        <meta charset="UTF-8"/>
        <title><xsl:value-of select="//tei:titlePart"/></title>
        <link rel="stylesheet" href="style.css"/>
        <script src="app.js" defer="defer"></script>
      </head>
      <body class="lang-both">
        <div class="lang-toggle">
          <button id="btn-en">EN</button>
          <button id="btn-ja">JA</button>
          <button id="btn-both" class="active">両方</button>
        </div>
        <header>
          <h1><xsl:value-of select="//tei:titlePart"/></h1>
          <p class="subtitle">TEI/XML 入門ガイドのデモページ</p>
        </header>
        <main>
          <nav class="toc">
            <h2>目次</h2>
            <ul>
              <xsl:apply-templates select="//tei:body/tei:div" mode="toc"/>
            </ul>
          </nav>
          <xsl:apply-templates select="//tei:body"/>
        </main>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="tei:div" mode="toc">
    <li>
      <a href="#{generate-id(tei:head)}">
        <xsl:value-of select="tei:head"/>
      </a>
      <xsl:if test="tei:div">
        <ul>
          <xsl:apply-templates select="tei:div" mode="toc"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="tei:body">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:div">
    <section><xsl:apply-templates/></section>
  </xsl:template>

  <xsl:template match="tei:div/tei:div/tei:head">
    <h3 id="{generate-id(.)}"><xsl:apply-templates/></h3>
  </xsl:template>

  <xsl:template match="tei:head">
    <h2 id="{generate-id(.)}"><xsl:apply-templates/></h2>
  </xsl:template>

  <xsl:template match="tei:p">
    <p>
      <xsl:if test="@xml:lang">
        <xsl:attribute name="lang">
          <xsl:value-of select="@xml:lang"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:hi[@rend='bold']">
    <strong><xsl:apply-templates/></strong>
  </xsl:template>

  <xsl:template match="tei:hi[@rend='italic']">
    <em><xsl:apply-templates/></em>
  </xsl:template>

  <xsl:template match="tei:list[@rend='bulleted']">
    <ul><xsl:apply-templates/></ul>
  </xsl:template>

  <xsl:template match="tei:list[@rend='numbered']">
    <ol><xsl:apply-templates/></ol>
  </xsl:template>

  <xsl:template match="tei:item">
    <li><xsl:apply-templates/></li>
  </xsl:template>

  <xsl:template match="tei:note[@place='foot']">
    <span class="note-wrapper">
      <sup class="note-ref">[<xsl:value-of select="@n"/>]</sup>
      <span class="tooltip"><xsl:value-of select="."/></span>
    </span>
  </xsl:template>

</xsl:stylesheet>
