./collectXML.pl $1 > bench.xml

java -jar saxon9he.jar -xsl:xsltGeneralProcessor.xsl -s:bench.xml > bench.html
