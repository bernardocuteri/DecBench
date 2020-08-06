./collectXML.pl $1 > bench.xml

java -jar saxon9he.jar -xsl:xsltGeneralCSVProcessor.xsl -s:bench.xml > bench.csv
