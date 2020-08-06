<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
Solver;Problem;Cpu Time;Memory;File<xsl:text>&#xa;</xsl:text>
<xsl:for-each select="benchmarkSuite/solver/problem/benchmark">
<xsl:value-of select="../../name"/>;<xsl:value-of select="../name"/>;<xsl:value-of select="cpuTime"/>;<xsl:value-of select="maxVirtualMemory"/>;<xsl:value-of select="file"/><xsl:text>&#xa;</xsl:text>

</xsl:for-each>
</xsl:template>
</xsl:stylesheet>


