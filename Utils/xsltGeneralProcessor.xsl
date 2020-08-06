<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<html> 
<body>
  <h2>Results</h2>
  <table border="1">
    <tr bgcolor="#9acd32">
      <th style="text-align:left">Solver</th>
      <th style="text-align:left">Problem</th>
      <th style="text-align:left">Cpu Time</th>
      <th style="text-align:left">Memory</th>
      <th style="text-align:left">File</th>
      <!--<th style="text-align:left">Clauses</th>-->
    </tr>
    <xsl:for-each select="benchmarkSuite/solver/problem/benchmark">
        <tr>             
          <td><xsl:value-of select="../../name"/></td>
          <td><xsl:value-of select="../name"/></td>
          <td><xsl:value-of select="cpuTime"/></td>
          <td><xsl:value-of select="maxVirtualMemory"/></td>
          <td><xsl:value-of select="file"/></td>
        </tr>                     
    </xsl:for-each>
  </table>
</body>
</html>
</xsl:template>
</xsl:stylesheet>


